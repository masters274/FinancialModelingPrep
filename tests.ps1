#region Variables


$moduleName = 'FinancialModelingPrep'

$modulePath = Get-Module -Name $moduleName | Select-Object -ExpandProperty Path

$moduleContent = Get-Content -Path $modulePath -Raw

$ast = [System.Management.Automation.Language.Parser]::ParseInput($moduleContent, [ref]$null, [ref]$null)


#endregion

#region Functions


function Test-FMPCommands {
    [CmdletBinding()]
    param()

    Begin {
        $results = @{
            Passed = @()
            Failed = @()
            Total  = 0
        }

        # Check if module is loaded
        if (-not (Get-Module -Name FinancialModelingPrep)) {
            Write-Warning "FinancialModelingPrep module not loaded. Attempting to import..."
            try {
                Import-Module FinancialModelingPrep -ErrorAction Stop
            }
            catch {
                Write-Error "Failed to import FinancialModelingPrep module: $_"
                return
            }
        }
    }

    Process {
        # Get all commands from the module
        $commands = Get-Command -Module FinancialModelingPrep | Where-Object { $_.Name -notmatch "Credential" }
        $results.Total = $commands.Count
        Write-Host "Found $($commands.Count) commands to test" -ForegroundColor Cyan

        foreach ($command in $commands) {
            Write-Host "`nTesting $($command.Name)..." -ForegroundColor Yellow

            # Get help content for the command
            $help = Get-Help -Name $command.Name -Examples -ErrorAction SilentlyContinue

            if ($help.Examples.Example.Count -gt 0) {
                # Get first example
                $example = $help.Examples.Example[0].Code
                Write-Host "  Example found: $example" -ForegroundColor Gray

                try {
                    # Execute the example
                    $errorDetails = $null
                    $output = Invoke-Expression $example -ErrorVariable errorDetails -ErrorAction SilentlyContinue

                    # Check for premium endpoint error
                    if ($errorDetails -and $errorDetails.Exception.Message -match "(Premium Endpoint|Exclusive Endpoint|Special Endpoint)") {
                        Write-Host "  ✅ PASSED: Requires premium subscription" -ForegroundColor Green
                        $results.Passed += [PSCustomObject]@{
                            Command = $command.Name
                            Result  = "Premium endpoint required"
                        }
                        continue
                    }

                    # Check if output has data
                    if ($null -ne $output -and @($output).Count -gt 0) {
                        Write-Host "  ✅ PASSED: Returned data ($(($output | Measure-Object).Count) items)" -ForegroundColor Green
                        $results.Passed += [PSCustomObject]@{
                            Command = $command.Name
                            Result  = "Data returned"
                        }
                    }
                    else {
                        Write-Host "  ❌ FAILED: No data returned" -ForegroundColor Red
                        $results.Failed += [PSCustomObject]@{
                            Command = $command.Name
                            Result  = "No data returned"
                            Error   = $null
                        }
                    }
                }
                catch {
                    if ($_.Exception.Message -match "(Premium Endpoint|Exclusive Endpoint|Special Endpoint)") {
                        Write-Host "  ✅ PASSED: Requires premium subscription" -ForegroundColor Green
                        $results.Passed += [PSCustomObject]@{
                            Command = $command.Name
                            Result  = "Premium endpoint required"
                        }
                    }
                    else {
                        Write-Host "  ❌ FAILED: Error executing example: $_" -ForegroundColor Red
                        $results.Failed += [PSCustomObject]@{
                            Command = $command.Name
                            Result  = "Example execution error"
                            Error   = $_.Exception.Message
                        }
                    }
                }
            }
            else {
                # If no examples, try with default parameters
                Write-Host "  No examples found, testing with default parameters" -ForegroundColor Gray

                try {
                    # Create parameters hashtable with defaults
                    $parameters = @{}
                    $commandInfo = Get-Command $command.Name

                    # Set default values for common parameter types
                    foreach ($param in $commandInfo.Parameters.Values) {
                        if ($param.Attributes.Where({ $_ -is [System.Management.Automation.ParameterAttribute] -and $_.Mandatory }).Count -gt 0) {
                            switch -regex ($param.Name) {
                                "symbol|ticker" { $parameters[$param.Name] = "AAPL" }
                                "date|period" { $parameters[$param.Name] = "2023-01-01" }
                                "year|quarter" { $parameters[$param.Name] = 2023 }
                                default {
                                    if ($param.ParameterType.Name -eq "String") {
                                        $parameters[$param.Name] = "AAPL"
                                    }
                                    elseif ($param.ParameterType.Name -eq "Int32") {
                                        $parameters[$param.Name] = 2023
                                    }
                                    elseif ($param.ParameterType.Name -eq "Boolean") {
                                        $parameters[$param.Name] = $true
                                    }
                                }
                            }
                        }
                    }

                    Write-Host "  Testing with parameters: $($parameters | ConvertTo-Json -Compress)" -ForegroundColor Gray

                    # Execute the command
                    $output = & $command.Name @parameters -ErrorAction Stop

                    if ($null -ne $output -and @($output).Count -gt 0) {
                        Write-Host "  ✅ PASSED: Returned data ($(($output | Measure-Object).Count) items)" -ForegroundColor Green
                        $results.Passed += [PSCustomObject]@{
                            Command = $command.Name
                            Result  = "Data returned"
                        }
                    }
                    else {
                        Write-Host "  ❌ FAILED: No data returned" -ForegroundColor Red
                        $results.Failed += [PSCustomObject]@{
                            Command = $command.Name
                            Result  = "No data returned"
                            Error   = $null
                        }
                    }
                }
                catch {
                    if ($_.Exception.Message -match "(Premium Endpoint|Exclusive Endpoint|Special Endpoint)") {
                        Write-Host "  ✅ PASSED: Requires premium subscription" -ForegroundColor Green
                        $results.Passed += [PSCustomObject]@{
                            Command = $command.Name
                            Result  = "Premium endpoint required"
                        }
                    }
                    else {
                        Write-Host "  ❌ FAILED: Error executing with default parameters: $_" -ForegroundColor Red
                        $results.Failed += [PSCustomObject]@{
                            Command = $command.Name
                            Result  = "Default parameters execution error"
                            Error   = $_.Exception.Message
                        }
                    }
                }
            }
        }
    }

    End {
        # Output summary
        Write-Host "`n----- TEST SUMMARY -----" -ForegroundColor Cyan
        Write-Host "Total Commands: $($results.Total)" -ForegroundColor White
        Write-Host "Passed: $($results.Passed.Count)" -ForegroundColor Green
        Write-Host "Failed: $($results.Failed.Count)" -ForegroundColor Red
        Write-Host "Success Rate: $(([math]::Round(($results.Passed.Count / $results.Total) * 100, 2)))%" -ForegroundColor Cyan

        if ($results.Failed.Count -gt 0) {
            Write-Host "`nFailed Commands:" -ForegroundColor Red
            $results.Failed | ForEach-Object {
                Write-Host "  - $($_.Command): $($_.Result) $(if($_.Error){"- $($_.Error)"})" -ForegroundColor Red
            }
        }

        return [PSCustomObject]@{
            TotalCommands  = $results.Total
            PassedCommands = $results.Passed
            FailedCommands = $results.Failed
            SuccessRate    = [math]::Round(($results.Passed.Count / $results.Total) * 100, 2)
        }
    }
}


function Search-ModHelpExamples {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $ModuleName
    )

    Begin {
        $results = @{
            Passed = @()
            Failed = @()
            Total  = 0
        }

        # Check if module is loaded
        if (-not (Get-Module -Name $ModuleName )) {
            Write-Warning "$ModuleName  module not loaded. Attempting to import..."
            try {
                Import-Module $ModuleName  -ErrorAction Stop
            }
            catch {
                Write-Error "Failed to import $ModuleName  module: $_"
                return
            }
        }
    }

    Process {
        # Get all commands from the module
        $commands = Get-Command -Module $ModuleName  | Where-Object { $_.Name -notmatch "Credential" }
        $results.Total = $commands.Count
        Write-Host "Found $($commands.Count) commands to test" -ForegroundColor Cyan

        foreach ($command in $commands) {
            Write-Host "`nTesting $($command.Name)..." -ForegroundColor Yellow

            # Get help content for the command
            $help = Get-Help -Name $command.Name -Examples -ErrorAction SilentlyContinue

            if ($help.Examples.Example.Count -gt 0) {
                # Get first example
                $example = $help.Examples.Example[0].Code
                Write-Host "  Example found: $example" -ForegroundColor Gray

            }
            else {
                # If no examples, try with default parameters
                Write-Host "  No examples found, testing with default parameters" -ForegroundColor Red
            }
        }
    }

    End {

    }
}


function Test-CommentHelpPositioning {
    <#
        .SYNOPSIS
            Analyzes PowerShell functions to ensure comment-based help appears before CmdletBinding attributes.

        .DESCRIPTION
            The Test-CommentHelpPositioning function examines PowerShell script code to identify functions
            where comment-based help blocks are incorrectly positioned after the [CmdletBinding()] attribute.

            Following best practices for PowerShell functions, comment-based help should always appear before
            the [CmdletBinding()] attribute. This function helps identify and report violations of this
            standard, making it useful for code quality checks and static analysis.

        .PARAMETER ScriptBlockAst
            The parsed abstract syntax tree (AST) representation of a PowerShell script or module.
            This parameter accepts a System.Management.Automation.Language.ScriptBlockAst object,
            which can be obtained using the [System.Management.Automation.Language.Parser]::ParseFile()
            or [System.Management.Automation.Language.Parser]::ParseInput() methods.

        .EXAMPLE
            $scriptContent = Get-Content -Path .\MyScript.ps1 -Raw
            $ast = [System.Management.Automation.Language.Parser]::ParseInput($scriptContent, [ref]$null, [ref]$null)
            Test-CommentHelpPositioning -ScriptBlockAst $ast

            This example parses a script file and checks all functions for proper help positioning.

        .EXAMPLE
            Get-ChildItem -Path C:\Scripts -Filter *.ps1 | ForEach-Object {
                $ast = [System.Management.Automation.Language.Parser]::ParseFile($_.FullName, [ref]$null, [ref]$null)
                Test-CommentHelpPositioning -ScriptBlockAst $ast
            }

            This example checks all PowerShell scripts in a directory for proper help positioning.

        .OUTPUTS
            [PSCustomObject[]]
            Returns an array of custom objects containing details about each violation found,
            including the rule name, message, code extent, and severity.

        .NOTES
            File Name      : Test-FMPCommands.ps1
            Author         : Your Name
            Prerequisite   : PowerShell 5.0 or later

            This function is designed to be used as part of PowerShell code quality checks
            and can be integrated into CI/CD pipelines or custom code analysis tools.
    #>

    [CmdletBinding()]
    [OutputType([PSCustomObject[]])]
    param (
        [Parameter(Mandatory)]
        [System.Management.Automation.Language.ScriptBlockAst]$ScriptBlockAst
    )

    $violations = @()
    $functions = $ScriptBlockAst.FindAll(
        { $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst] },
        $true
    )

    foreach ($function in $functions) {
        # Get the body of the function
        $body = $function.Body

        # Variables to track positions
        $helpBlockPosition = $null
        $cmdletBindingPosition = $null
        $helpBeforeCmdletBinding = $true

        # Make sure EndBlock exists before accessing it
        $statements = @()
        if ($body -and $body.EndBlock) {
            $statements = $body.EndBlock.Statements
        }
        elseif ($body -and $body.BeginBlock) {
            # Some functions might only have begin blocks
            $statements = $body.BeginBlock.Statements
        }

        # Try using GetHelpContent method as an alternative approach
        $helpContent = $function.GetHelpContent()
        $hasHelpContent = $helpContent -and $helpContent.HasHelpContent

        # Process statements only if we have them
        if ($statements.Count -gt 0) {
            for ($i = 0; $i -lt $statements.Count; $i++) {
                $statement = $statements[$i]

                # Check for comment-based help (appears as a CommentBlockAst)
                if ($statement -is [System.Management.Automation.Language.BlockStatementAst]) {
                    $commentText = $statement.Extent.Text
                    if ($commentText -match '<#[\s\S]*?\.SYNOPSIS[\s\S]*?#>') {
                        $helpBlockPosition = $i
                    }
                }

                # Check for CmdletBinding attribute
                if ($statement -is [System.Management.Automation.Language.AttributedExpressionAst]) {
                    foreach ($attribute in $statement.Attribute) {
                        if ($attribute.TypeName.Name -eq 'CmdletBinding') {
                            $cmdletBindingPosition = $i
                            break
                        }
                    }
                }

                # Check for param block with CmdletBinding attribute
                if ($statement -is [System.Management.Automation.Language.ParamBlockAst]) {
                    foreach ($attribute in $statement.Attributes) {
                        if ($attribute.TypeName.Name -eq 'CmdletBinding') {
                            $cmdletBindingPosition = $i
                            break
                        }
                    }
                }
            }

            # If we found both help and CmdletBinding, check their relative positions
            if ($null -ne $helpBlockPosition -and $null -ne $cmdletBindingPosition) {
                $helpBeforeCmdletBinding = $helpBlockPosition -lt $cmdletBindingPosition
            }
        }

        # If statements approach failed, rely on regex approach
        if (($null -eq $helpBlockPosition -or $null -eq $cmdletBindingPosition) -and $hasHelpContent) {
            $functionText = $function.Extent.Text
            $helpMatch = [regex]::Match($functionText, '(?s)<#.*?#>')
            $cmdletBindingMatch = [regex]::Match($functionText, '\[CmdletBinding\([^\)]*\)\]')

            if ($helpMatch.Success -and $cmdletBindingMatch.Success) {
                $helpBeforeCmdletBinding = $helpMatch.Index -lt $cmdletBindingMatch.Index
            }
        }

        # Add violation if help does not come before CmdletBinding
        if ($hasHelpContent -and (
                ($null -ne $helpBlockPosition -and $null -ne $cmdletBindingPosition -and -not $helpBeforeCmdletBinding) -or
                (($null -eq $helpBlockPosition -or $null -eq $cmdletBindingPosition) -and -not $helpBeforeCmdletBinding)
            )) {
            $violations += [PSCustomObject]@{
                RuleName          = "CommentHelpShouldPrecedeCmdletBinding"
                Message           = "Comment-based help should appear before [CmdletBinding()] in function $($function.Name)"
                Extent            = $function.Extent
                FunctionName      = $function.Name
                RuleSuppressionID = "CommentHelpShouldPrecedeCmdletBinding"
                Severity          = "Warning"
                LineNumber        = $function.Extent.StartLineNumber
            }
        }
    }

    return $violations
}


#endregion

#region Tests


Search-ModHelpExamples -ModuleName $moduleName

$executionTests = Test-FMPCommands; $executionTests.FailedCommands

$helpTests = Test-CommentHelpPositioning -ScriptBlockAst $ast; $helpTests


#endregion

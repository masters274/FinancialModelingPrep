<#
    .SYNOPSIS
        Root module file for FinancialModelingPrep

    .DESCRIPTION
        This module provides cmdlets to interact with the FinancialModelingPrep API

    .NOTES
        Author: Chris Masters
        Tags: FMP, Financial, Modeling, API, Candlestick, Chart, FinancialModelingPrep, Stocks, SEC, Screener, ScreenerAPI
#>

# Get the directory where this script is located
$PSScriptRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition

# Get all public function files
$publicFunctionPath = Join-Path -Path $PSScriptRoot -ChildPath 'PublicFunctions'
$publicFunctions = @()

# If the PublicFunctions directory exists
if (Test-Path -Path $publicFunctionPath) {
    # Get all ps1 files in the PublicFunctions directory
    $functionFiles = Get-ChildItem -Path $publicFunctionPath -Filter *.ps1

    # Dot source each function file and add to the export list
    foreach ($file in $functionFiles) {
        try {
            . $file.FullName
            $publicFunctions += $file.BaseName
            Write-Verbose "Imported function $($file.BaseName)"
        }
        catch {
            Write-Error "Failed to import function $($file.FullName): $_"
        }
    }
}
else {
    Write-Warning "No PublicFunctions directory found at $publicFunctionPath"
}

# Export all public functions
Export-ModuleMember -Function $publicFunctions

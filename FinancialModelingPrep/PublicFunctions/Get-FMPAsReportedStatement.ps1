function Get-FMPAsReportedStatement { 
 

    <#
        .SYNOPSIS
            Retrieves as reported financial statements for a specified company.

        .DESCRIPTION
            Retrieves a company's as reported statement data based on the statement type:
            Income, Balance, CashFlow, or Financial. The statements are from the "Statements" category,
            sub-category "As Reported". Use the StatementType parameter to specify the type of statement.

        .PARAMETER Symbol
            The company's stock ticker (e.g., AAPL).

        .PARAMETER StatementType
            The type of statement to retrieve. Valid values are:
            Income, Balance, CashFlow, and Financial.

        .PARAMETER Period
            The statement period. Valid values are "annual" or "quarter". Default is "annual".

        .PARAMETER Limit
            The maximum number of records to return. Default is 50.

        .PARAMETER ApiKey
            Your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it using Get-FMPCredential.

        .EXAMPLE
            Get-FMPAsReportedStatement -Symbol AAPL -StatementType Income -Period annual -Limit 50

            Retrieves the as reported income statements for Apple Inc. on an annual basis.
    #>

    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true)]
        [string] $Symbol,

        [Parameter(Mandatory = $true)]
        [ValidateSet("Income", "Balance", "CashFlow", "Financial")]
        [string] $StatementType,

        [Parameter(Mandatory = $false)]
        [ValidateSet("annual", "quarter")]
        [string] $Period = "annual",

        [Parameter(Mandatory = $false)]
        [int] $Limit = 50,

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }
        switch ($StatementType) {
            "Income" { $baseUrl = "https://financialmodelingprep.com/api/v3/income-statement-as-reported" }
            "Balance" { $baseUrl = "https://financialmodelingprep.com/api/v3/balance-sheet-statement-as-reported" }
            "CashFlow" { $baseUrl = "https://financialmodelingprep.com/api/v3/cash-flow-statement-as-reported" }
            "Financial" { $baseUrl = "https://financialmodelingprep.com/api/v3/financial-statement-full-as-reported" }
        }
    }

    Process {
        $url = "{0}/{1}?period={2}&limit={3}&apikey={4}" -f $baseUrl, $Symbol, $Period, $Limit, $ApiKey
        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving as reported statement data: $_"
        }
    }
 
 };


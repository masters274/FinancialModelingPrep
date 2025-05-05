function Get-FMPIncomeStatementTTM { 
 

    <#
        .SYNOPSIS
            Retrieves trailing twelve months (TTM) income statement data for a specified company using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPIncomeStatementTTM function fetches the trailing twelve months (TTM) income statement data for a given company
            based on its stock symbol. This provides the most recent 12-month period financial performance regardless of fiscal year
            or quarter boundaries. The TTM data includes revenue, cost of revenue, gross profit, operating expenses, and net income.
            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential function and prompts
            the user if necessary.

        .PARAMETER Symbol
            Specifies the stock symbol for which to retrieve TTM income statement data (e.g., AAPL). This parameter is mandatory.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it using Get-FMPCredential.

        .EXAMPLE
            Get-FMPIncomeStatementTTM -Symbol AAPL

            This example retrieves the trailing twelve months income statement for Apple Inc.

        .NOTES
            This is a premium endpoint, and requires a paid subscription. This function utilizes the Financial Modeling Prep API's TTM Income Statement endpoint.
            For more information, visit: https://financialmodelingprep.com
    #>

    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true)]
        [string] $Symbol,

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/stable/income-statement-ttm"
    }

    Process {
        $url = "{0}?symbol={1}&apikey={2}" -f $baseUrl, $Symbol, $ApiKey

        $headers = @{
            "Upgrade-Insecure-Requests" = "1"
        }

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving TTM income statement data: $_"
        }
    }
 
 };


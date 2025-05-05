function Get-FMPLatestFinancialStatements { 
 

    <#
        .SYNOPSIS
            Retrieves the latest financial statements (income statement, balance sheet, and cash flow) for a specified company using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPLatestFinancialStatements function fetches the most recent financial statements for a given company based on its stock symbol.
            This provides a comprehensive financial overview including income statement, balance sheet, and cash flow data in a single API call.
            Users can specify whether to retrieve annual or quarterly statements. If no API key is provided, the function attempts
            to retrieve it using the Get-FMPCredential function and prompts the user if necessary.

        .PARAMETER Symbol
            Specifies the stock symbol for which to retrieve the latest financial statements (e.g., AAPL). This parameter is mandatory.

        .PARAMETER Period
            Specifies the reporting period type. Valid values are "annual" or "quarter". The default value is "annual".

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it using Get-FMPCredential.

        .EXAMPLE
            Get-FMPLatestFinancialStatements -Symbol AAPL -Period annual

            This example retrieves the latest annual financial statements for Apple Inc.

        .EXAMPLE
            Get-FMPLatestFinancialStatements -Symbol MSFT -Period quarter

            This example retrieves the latest quarterly financial statements for Microsoft Corporation.

        .NOTES
            This is a premium endpoint, and requires a paid subscription. This function utilizes the Financial Modeling Prep API's Latest Financial Statements endpoint.
            For more information, visit: https://financialmodelingprep.com
    #>

    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true)]
        [string] $Symbol,

        [Parameter(Mandatory = $false)]
        [ValidateSet("annual", "quarter")]
        [string] $Period = "annual",

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/stable/latest-financial-statements"
    }

    Process {
        $url = "{0}?symbol={1}&period={2}&apikey={3}" -f $baseUrl, $Symbol, $Period, $ApiKey

        $headers = @{
            "Upgrade-Insecure-Requests" = "1"
        }

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving latest financial statements data: $_"
        }
    }
 
 };


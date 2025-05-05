function Get-FMPBalanceSheetGrowth { 
 

    <#
        .SYNOPSIS
            Retrieves balance sheet growth data for a specified company using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPBalanceSheetGrowth function fetches detailed growth rates for various balance sheet items
            such as total assets, total liabilities, total equity, cash and equivalents, and other key financial metrics.
            This helps investors analyze a company's financial position trends over time. Users can specify which reporting
            period to retrieve growth data for and limit the number of results. If no API key is provided,
            the function attempts to retrieve it using the Get-FMPCredential function and prompts the user if necessary.

        .PARAMETER Symbol
            Specifies the stock symbol for which to retrieve balance sheet growth data (e.g., AAPL). This parameter is mandatory.

        .PARAMETER Period
            Specifies the reporting period type. Valid values are "Q1", "Q2", "Q3", "Q4", or "FY". The default value is "FY".

        .PARAMETER Limit
            Specifies the maximum number of growth records to retrieve. The default value is 5.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it using Get-FMPCredential.

        .EXAMPLE
            Get-FMPBalanceSheetGrowth -Symbol AAPL -Period FY -Limit 5

            This example retrieves the 5 most recent annual balance sheet growth records for Apple Inc.

        .EXAMPLE
            Get-FMPBalanceSheetGrowth -Symbol MSFT -Period Q2 -Limit 10

            This example retrieves the 10 most recent Q2 quarterly balance sheet growth records for Microsoft Corporation.

        .NOTES
            This function utilizes the Financial Modeling Prep API's Balance Sheet Growth endpoint.
            For more information, visit: https://financialmodelingprep.com
    #>

    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true)]
        [string] $Symbol,

        [Parameter(Mandatory = $false)]
        [ValidateSet("Q1", "Q2", "Q3", "Q4", "FY")]
        [string] $Period = "FY",

        [Parameter(Mandatory = $false)]
        [int] $Limit = 5,

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/stable/balance-sheet-statement-growth"
    }

    Process {
        $url = "{0}?symbol={1}&period={2}&limit={3}&apikey={4}" -f $baseUrl, $Symbol, $Period, $Limit, $ApiKey

        $headers = @{
            "Upgrade-Insecure-Requests" = "1"
        }

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving balance sheet growth data: $_"
        }
    }
 
 };


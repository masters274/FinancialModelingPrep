function Get-FMPRatingSnapshot { 
 

    <#
        .SYNOPSIS
            Retrieves a snapshot of financial ratings for a specified stock symbol using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPRatingSnapshot function fetches comprehensive financial ratings data for a stock symbol,
            based on various key financial ratios. This snapshot includes overall rating scores along with ratings for
            discounted cash flow, return on equity, return on assets, debt-to-equity, price-to-earnings, and price-to-book.
            Use this function to quickly assess the financial health and performance of a company.
            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential function and prompts
            the user if necessary.

        .PARAMETER Symbol
            Specifies the stock symbol for which the ratings snapshot is to be retrieved (e.g., AAPL). This parameter is mandatory.

        .PARAMETER Limit
            Specifies the maximum number of results to return. The default value is 1. This parameter is optional.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it using Get-FMPCredential.

        .EXAMPLE
            Get-FMPRatingSnapshot -Symbol AAPL -Limit 1

            This example retrieves the ratings snapshot for Apple Inc. with a limit of 1 result using your Financial Modeling Prep API key.

        .NOTES
            This function utilizes the Financial Modeling Prep API's Ratings Snapshot endpoint.
            For more information, visit: https://financialmodelingprep.com
    #>

    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true)]
        [string] $Symbol,

        [Parameter(Mandatory = $false)]
        [int] $Limit = 1,

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/stable/ratings-snapshot"
    }

    Process {
        $url = "{0}?symbol={1}&limit={2}&apikey={3}" -f $baseUrl, $Symbol, $Limit, $ApiKey

        $headers = @{
            "Upgrade-Insecure-Requests" = "1"
        }

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving FMP ratings snapshot data: $_"
        }
    }
 
 };


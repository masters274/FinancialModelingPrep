function Get-FMPDividendAdjustedPrice { 
 

    <#
        .SYNOPSIS
            Retrieves dividend-adjusted end-of-day stock price and volume data for a specified stock symbol using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPDividendAdjustedPrice function fetches historical price data that accounts for dividend payouts,
            providing a more accurate view of stock performance over time. It returns dividend-adjusted open, high, low, and close prices
            along with trading volume. Users can filter the data by specifying a date range using the "FromDate" and "ToDate" parameters.
            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential function and prompts the user if necessary.

        .PARAMETER Symbol
            Specifies the stock symbol for which the dividend-adjusted price data is to be retrieved (e.g., AAPL). This parameter is mandatory.

        .PARAMETER FromDate
            (Optional) Specifies the start date (inclusive) for data retrieval. The date should be provided as a [datetime] object and is formatted as "yyyy-MM-dd".

        .PARAMETER ToDate
            (Optional) Specifies the end date (inclusive) for data retrieval. The date should be provided as a [datetime] object and is formatted as "yyyy-MM-dd".

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it using the Get-FMPCredential function.

        .EXAMPLE
            Get-FMPDividendAdjustedPrice -Symbol AAPL -FromDate (Get-Date "2025-01-08") -ToDate (Get-Date "2025-04-08")

            This example retrieves dividend-adjusted end-of-day price and volume data for Apple Inc. between January 8, 2025 and April 8, 2025 using your Financial Modeling Prep API key.

        .NOTES
            This function utilizes the Financial Modeling Prep API's Dividend Adjusted Price Chart endpoint.
            For more details, visit: https://financialmodelingprep.com
    #>

    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true)]
        [string] $Symbol,

        [Parameter(Mandatory = $false)]
        [datetime] $FromDate,

        [Parameter(Mandatory = $false)]
        [datetime] $ToDate,

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/stable/historical-price-eod/dividend-adjusted"
    }

    Process {
        $url = "{0}?symbol={1}&apikey={2}" -f $baseUrl, $Symbol, $ApiKey

        if ($FromDate) {
            $url += "&from=" + $FromDate.ToString("yyyy-MM-dd")
        }

        if ($ToDate) {
            $url += "&to=" + $ToDate.ToString("yyyy-MM-dd")
        }

        $headers = @{
            "Upgrade-Insecure-Requests" = "1"
        }

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving dividend-adjusted price data: $_"
        }
    }
 
 };


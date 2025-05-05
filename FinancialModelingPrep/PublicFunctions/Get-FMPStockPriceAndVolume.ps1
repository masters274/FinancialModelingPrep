function Get-FMPStockPriceAndVolume { 
 

    <#
        .SYNOPSIS
            Retrieves comprehensive stock price and volume data for a specified stock symbol using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPStockPriceAndVolume function fetches detailed historical data for a given stock symbol.
            Data retrieved includes open, high, low, close prices, trading volume, price changes, percentage changes,
            and the volume-weighted average price (VWAP). Users can optionally filter the data by a date range using the
            "from" and "to" parameters. If no API key is provided, the function will attempt to retrieve it using the
            Get-FMPCredential function and prompt the user if necessary.

        .PARAMETER Symbol
            Specifies the stock symbol for which to retrieve price and volume data (e.g., AAPL). This parameter is mandatory.

        .PARAMETER FromDate
            (Optional) Specifies the start date (inclusive) for data retrieval. The date is formatted as "yyyy-MM-dd".

        .PARAMETER ToDate
            (Optional) Specifies the end date (inclusive) for data retrieval. The date is formatted as "yyyy-MM-dd".

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it using Get-FMPCredential.

        .EXAMPLE
            Get-FMPStockPriceAndVolume -Symbol AAPL -FromDate (Get-Date "2025-01-08") -ToDate (Get-Date "2025-04-08")

            This example retrieves the comprehensive historical price and volume data for Apple Inc. between January 8, 2025 and April 8, 2025.

        .NOTES
            This function utilizes the Financial Modeling Prep API's full historical price and volume endpoint.
            For more information, visit: https://financialmodelingprep.com
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
        $baseUrl = "https://financialmodelingprep.com/stable/historical-price-eod/full"
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
            throw "Error retrieving stock price and volume data: $_"
        }
    }
 
 };


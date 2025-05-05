function Get-FMPStockChartLight { 
 

    <#
        .SYNOPSIS
            Retrieves simplified end-of-day stock chart data for a specified stock symbol using the FMP Basic Stock Chart API.

        .DESCRIPTION
            The Get-FMPStockChartLight function accesses the Financial Modeling Prep API to fetch essential charting information,
            such as date, price, and trading volume, for a given stock symbol. This simplified data set is ideal for tracking
            stock performance and creating basic price and volume charts.
            Users can optionally filter the data by a date range using the "from" and "to" parameters.
            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential function and prompts the user if necessary.

        .PARAMETER Symbol
            Specifies the stock symbol for which to retrieve end-of-day chart data (e.g., AAPL). This parameter is mandatory.

        .PARAMETER FromDate
            (Optional) Specifies the start date (inclusive) for the data to be retrieved.
            The date is formatted as "yyyy-MM-dd". This parameter is optional.

        .PARAMETER ToDate
            (Optional) Specifies the end date (inclusive) for the data to be retrieved.
            The date is formatted as "yyyy-MM-dd". This parameter is optional.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it using the Get-FMPCredential function.

        .EXAMPLE
            Get-FMPStockChartLight -Symbol AAPL -FromDate (Get-Date "2025-01-08") -ToDate (Get-Date "2025-04-08")

            This example retrieves the basic end-of-day stock chart data for Apple Inc. between January 8, 2025 and April 8, 2025.

        .NOTES
            This function utilizes the FMP Basic Stock Chart API endpoint.
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
        $baseUrl = "https://financialmodelingprep.com/stable/historical-price-eod/light"
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
            throw "Error retrieving FMP stock chart light EOD data: $_"
        }
    }
 
 };


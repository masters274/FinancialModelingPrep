function Get-FMPCryptoIntradayKlineData { 
 

    <#
        .SYNOPSIS
            Provides intraday price data for all cryptocurrencies that are traded on exchanges around the world using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPKlineData function fetches candlestick chart data for a given trading symbol over a specified date range.
            It supports various intraday intervals such as 1min, 5min, 15min, 30min, 1hour, and 4hour. The date range is defined
            by the FromDate and ToDate parameters (both default to today's date) and only the date portion is considered.
            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential function and will prompt
            the user if necessary.

        .PARAMETER TimeFrame
            Specifies the intraday intervals for the candlestick data points. Valid values are: "1min", "5min", "15min", "30min", "1hour", "4hour".
            This parameter is mandatory.

        .PARAMETER Symbol
            Specifies the trading symbol (e.g., BTCUSD). This parameter is mandatory. Use Get-FMPCryptoList to retrieve a list of available cryptocurrencies.

        .PARAMETER FromDate
            Specifies the start date for the data retrieval. The value must be a [datetime] object. Only the date portion is used,
            and the default value is today's date.

        .PARAMETER ToDate
            Specifies the end date for the data retrieval. The value must be a [datetime] object. Only the date portion is used,
            and the default value is today's date.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function will attempt to retrieve it using Get-FMPCredential
            and prompt the user if necessary.

        .EXAMPLE
            Get-FMPCryptoIntradayKlineData -Interval 1hour -Symbol BTCUSD -FromDate $((Get-Date).AddDays(-30))

            This example retrieves the candlestick chart data for Bitcoin (BTCUSD) over the past 30 days with hourly data points.

        .NOTES
            This function utilizes the Financial Modeling Prep API's historical chart endpoint.
            For more information, visit: https://financialmodelingprep.com
    #>

    [CmdletBinding()]

    Param (

        [Parameter(Mandatory = $true)]
        [ValidateSet("1min", "5min", "15min", "30min", "1hour", "4hour")]
        [string] $Interval,

        # The trading symbol (e.g. BTCUSD).
        [Parameter(Mandatory = $true)]
        [string] $Symbol,

        [Parameter(Mandatory = $false)]
        [datetime] $FromDate = (Get-Date),

        [Parameter(Mandatory = $false)]
        [datetime] $ToDate = (Get-Date),

        # Your FMP API key.
        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }

        $baseUrl = "https://financialmodelingprep.com/api/v3/historical-chart"
    }

    Process {

        $url = "{0}/{1}/{2}?from={3}&to={4}&apikey={5}" -f
        $baseUrl,
        $Interval,
        $Symbol,
        $FromDate.ToString("yyyy-MM-dd"),
        $ToDate.ToString("yyyy-MM-dd"),
        $ApiKey

        $headers = @{
            "Upgrade-Insecure-Requests" = "1"
        }

        try {

            $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving FMP kline data: $_"
        }
    }
 
 };


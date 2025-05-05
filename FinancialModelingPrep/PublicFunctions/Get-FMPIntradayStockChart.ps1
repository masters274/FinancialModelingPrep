function Get-FMPIntradayStockChart { 
 

    <#
        .SYNOPSIS
            Retrieves intraday stock chart data for a specified stock symbol at a given time interval using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPIntradayStockChart function consolidates multiple intraday chart endpoints into a single function.
            Users can retrieve precise intraday stock price and volume data (including open, high, low, close, and volume)
            for a specified stock symbol at various time intervals. Supported intervals include:
            1min, 5min, 15min, 30min, 1hr, and 4hr.

            In addition, users can optionally specify a date range (using the FromDate and ToDate parameters) to filter the
            chart data, and determine whether to retrieve nonadjusted data using the NonAdjusted parameter.

            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential function and prompts the user if necessary.

        .PARAMETER Interval
            Specifies the time interval for the intraday stock chart.
            Valid values are: "1min", "5min", "15min", "30min", "1hour", "4hour". This parameter is mandatory.

        .PARAMETER Symbol
            Specifies the stock symbol for which the intraday chart data is to be retrieved (e.g., AAPL). This parameter is mandatory.

        .PARAMETER FromDate
            (Optional) Specifies the start date (inclusive) for filtering the data. The date should be provided as a [datetime] object.

        .PARAMETER ToDate
            (Optional) Specifies the end date (inclusive) for filtering the data. The date should be provided as a [datetime] object.

        .PARAMETER NonAdjusted
            (Optional) Specifies whether to retrieve nonadjusted data. Default is $false.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it using Get-FMPCredential.

        .EXAMPLE
            Get-FMPIntradayStockChart -Interval "1min" -Symbol AAPL -FromDate (Get-Date "2024-01-01") -ToDate (Get-Date "2024-03-01") -NonAdjusted $false

            This example retrieves 1-minute interval intraday chart data for Apple Inc. between January 1, 2024 and March 1, 2024.

        .NOTES
            This is a premium endpoint, and requires a paid subscription. This function consolidates the following endpoints:
              - https://financialmodelingprep.com/stable/historical-chart/1min
              - https://financialmodelingprep.com/stable/historical-chart/5min
              - https://financialmodelingprep.com/stable/historical-chart/15min
              - https://financialmodelingprep.com/stable/historical-chart/30min
              - https://financialmodelingprep.com/stable/historical-chart/1hour
              - https://financialmodelingprep.com/stable/historical-chart/4hour
            For more information, visit: https://financialmodelingprep.com
    #>

    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true)]
        [ValidateSet("1min", "5min", "15min", "30min", "1hour", "4hour")]
        [string] $Interval,

        [Parameter(Mandatory = $true)]
        [string] $Symbol,

        [Parameter(Mandatory = $false)]
        [datetime] $FromDate,

        [Parameter(Mandatory = $false)]
        [datetime] $ToDate,

        [Parameter(Mandatory = $false)]
        [bool] $NonAdjusted = $false,

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/stable/historical-chart/{0}"
    }

    Process {
        $url = $baseUrl -f $Interval
        $url += "?symbol=$Symbol&apikey=$ApiKey"

        if ($FromDate) {
            $url += "&from=" + $FromDate.ToString("yyyy-MM-dd")
        }

        if ($ToDate) {
            $url += "&to=" + $ToDate.ToString("yyyy-MM-dd")
        }

        $url += "&nonadjusted=" + $NonAdjusted.ToString().ToLower()

        $headers = @{
            "Upgrade-Insecure-Requests" = "1"
        }

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving intraday stock chart data: $_"
        }
    }
 
 };


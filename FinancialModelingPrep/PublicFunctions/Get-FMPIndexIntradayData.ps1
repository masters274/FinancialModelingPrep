function Get-FMPIndexIntradayData { 
 

    <#
        .SYNOPSIS
            Retrieves intraday historical price data for a specified index symbol.

        .DESCRIPTION
            The Get-FMPIndexIntradayData function fetches intraday price data for a given index symbol
            at various time intervals (1min, 5min, or 1hour). This function provides access to detailed
            price movements within the trading day, which can be useful for analyzing short-term trends
            and intraday volatility.

            Users can specify a date range to filter the data and customize the time interval resolution.
            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential function.

        .PARAMETER Symbol
            Specifies the index symbol for which to retrieve intraday data (e.g., "^GSPC" for S&P 500).
            This parameter is mandatory.

        .PARAMETER Interval
            Specifies the time interval for the intraday data. Valid values are "1min", "5min", and "1hour".
            Default is "1min".

        .PARAMETER FromDate
            Specifies the start date (inclusive) for filtering the intraday data.
            The date must be a [datetime] object and is formatted as "yyyy-MM-dd".
            This parameter is optional.

        .PARAMETER ToDate
            Specifies the end date (inclusive) for filtering the intraday data.
            The date must be a [datetime] object and is formatted as "yyyy-MM-dd".
            This parameter is optional.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it
            using Get-FMPCredential.

        .EXAMPLE
            Get-FMPIndexIntradayData -Symbol "^GSPC" -Interval "1min"

            Retrieves 1-minute interval intraday data for the S&P 500 index.

        .EXAMPLE
            Get-FMPIndexIntradayData -Symbol "^DJI" -Interval "1hour" -FromDate (Get-Date).AddDays(-7) -ToDate (Get-Date)

            Retrieves hourly intraday data for the Dow Jones Industrial Average for the past 7 days.

        .NOTES
            This is a premium endpoint, and requires a paid subscription. This function uses the Financial Modeling Prep API's Index Intraday endpoints.
            For more information, visit:
            https://site.financialmodelingprep.com/developer/docs/stable/index-intraday-1-min
            https://site.financialmodelingprep.com/developer/docs/stable/index-intraday-5-min
            https://site.financialmodelingprep.com/developer/docs/stable/index-intraday-1-hour
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [string] $Symbol,

        [Parameter(Mandatory = $false)]
        [ValidateSet("1min", "5min", "1hour")]
        [string] $Interval = "1min",

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

        # Updated to use the stable endpoints
        switch ($Interval) {
            "1min" { $baseUrl = "https://financialmodelingprep.com/stable/historical-chart/1min" }
            "5min" { $baseUrl = "https://financialmodelingprep.com/stable/historical-chart/5min" }
            "1hour" { $baseUrl = "https://financialmodelingprep.com/stable/historical-chart/1hour" }
        }
    }

    Process {
        $queryParams = @{
            symbol = $Symbol
            apikey = $ApiKey
        }

        if ($FromDate) { $queryParams.from = $FromDate.ToString("yyyy-MM-dd") }
        if ($ToDate) { $queryParams.to = $ToDate.ToString("yyyy-MM-dd") }

        $queryString = ($queryParams.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" }) -join "&"
        $url = "{0}?{1}" -f $baseUrl, $queryString

        $headers = @{
            "Upgrade-Insecure-Requests" = "1"
        }

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving index intraday data: $_"
        }
    }
 
 };


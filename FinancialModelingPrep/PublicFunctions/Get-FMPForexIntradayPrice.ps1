function Get-FMPForexIntradayPrice { 
 

    <#
        .SYNOPSIS
            Retrieves intraday price data for a specified forex currency pair using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPForexIntradayPrice function fetches intraday historical price data for a given forex currency pair.
            Three time intervals are available:
            - 1min: provides minute-by-minute price data
            - 5min: provides 5-minute interval price data
            - 1hour: provides hourly price data

            The data can be filtered by a custom date range using the FromDate and ToDate parameters.
            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential
            function and will prompt the user if necessary.

        .PARAMETER Symbol
            Specifies the forex currency pair symbol (e.g., EURUSD, GBPJPY). This parameter is mandatory.

        .PARAMETER Interval
            Specifies the time interval for the price data. Valid values are "1min", "5min", and "1hour".
            The default value is "1hour".

        .PARAMETER FromDate
            Specifies the start date (inclusive) for the intraday data.
            The date must be a [datetime] object and is formatted as "yyyy-MM-dd".
            This parameter is optional.

        .PARAMETER ToDate
            Specifies the end date (inclusive) for the intraday data.
            The date must be a [datetime] object and is formatted as "yyyy-MM-dd".
            This parameter is optional.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it
            using Get-FMPCredential.

        .EXAMPLE
            Get-FMPForexIntradayPrice -Symbol EURUSD -Interval 1hour -FromDate (Get-Date).AddDays(-1) -ToDate (Get-Date)

            Retrieves hourly price data for EUR/USD over the past day.

        .EXAMPLE
            Get-FMPForexIntradayPrice -Symbol GBPJPY -Interval 5min -FromDate (Get-Date).AddDays(-4)

            Retrieves 5-minute interval price data for GBP/JPY over the past 4 hours.

        .NOTES
            This is a premium endpoint, and requires a paid subscription. This function uses the Financial Modeling Prep API's Forex Intraday endpoints.
            For more information, visit:
            https://site.financialmodelingprep.com/developer/docs/stable/forex-intraday-1-min
            https://site.financialmodelingprep.com/developer/docs/stable/forex-intraday-5-min
            https://site.financialmodelingprep.com/developer/docs/stable/forex-intraday-1-hour
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [string] $Symbol,

        [Parameter(Mandatory = $false)]
        [ValidateSet("1min", "5min", "1hour")]
        [string] $Interval = "1hour",

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

        # Updated base URL to use the new stable API path
        $baseUrl = "https://financialmodelingprep.com/stable/historical-chart/{0}" -f $Interval
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
            throw "Error retrieving forex intraday price data: $_"
        }
    }
 
 };


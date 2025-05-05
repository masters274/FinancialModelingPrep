function Get-FMPForexHistoricalPrice { 
 

    <#
        .SYNOPSIS
            Retrieves historical end-of-day price data for a specified forex currency pair using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPForexHistoricalPrice function fetches historical end-of-day (EOD) price data for a given forex currency pair.
            Two data formats are available:
            - Light: provides basic OHLC (Open, High, Low, Close) price data
            - Full: provides comprehensive data including volume, change, and additional metrics

            The data can be filtered by a custom date range using the FromDate and ToDate parameters.
            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential function.

        .PARAMETER Symbol
            Specifies the forex currency pair symbol (e.g., EURUSD, GBPJPY). This parameter is mandatory.

        .PARAMETER Mode
            Specifies the data format to retrieve. Valid values are "Light" and "Full".
            The default value is "Full".

        .PARAMETER FromDate
            Specifies the start date (inclusive) for the historical data.
            The date must be a [datetime] object and is formatted as "yyyy-MM-dd".
            This parameter is optional.

        .PARAMETER ToDate
            Specifies the end date (inclusive) for the historical data.
            The date must be a [datetime] object and is formatted as "yyyy-MM-dd".
            This parameter is optional.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it
            using Get-FMPCredential.

        .EXAMPLE
            Get-FMPForexHistoricalPrice -Symbol EURUSD -FromDate (Get-Date).AddMonths(-1) -ToDate (Get-Date)

            Retrieves the full historical price data for EUR/USD over the past month.

        .EXAMPLE
            Get-FMPForexHistoricalPrice -Symbol GBPJPY -Mode Light -FromDate (Get-Date "2025-01-01") -ToDate (Get-Date "2025-03-31")

            Retrieves the light historical price data for GBP/JPY for Q1 2025.
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [string] $Symbol,

        [Parameter(Mandatory = $false)]
        [ValidateSet("Light", "Full")]
        [string] $Mode = "Full",

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

        # Select the appropriate endpoint based on the Mode parameter - using the new paths
        if ($Mode -eq "Light") {
            $baseUrl = "https://financialmodelingprep.com/stable/historical-price-eod/light"
        }
        else {
            $baseUrl = "https://financialmodelingprep.com/stable/historical-price-eod/full"
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
            throw "Error retrieving forex historical price data: $_"
        }
    }
 
 };


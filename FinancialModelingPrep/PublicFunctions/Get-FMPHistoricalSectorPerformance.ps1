function Get-FMPHistoricalSectorPerformance { 
 

    <#
        .SYNOPSIS
            Retrieves historical performance data for a specific market sector.

        .DESCRIPTION
            The Get-FMPHistoricalSectorPerformance function fetches historical performance data for a specified
            market sector over a custom date range. This allows you to track the performance of a sector
            over time and compare how it has performed during different market conditions or economic cycles.

            The data includes daily performance metrics and can be filtered by date range using the FromDate
            and ToDate parameters, and by exchange using the Exchange parameter. If no API key is provided,
            the function attempts to retrieve it using the Get-FMPCredential function.

        .PARAMETER Sector
            Specifies the market sector for which to retrieve historical performance data.
            This parameter is mandatory.

        .PARAMETER Exchange
            Specifies the exchange to filter results (e.g., "NASDAQ").
            If omitted, returns data for all exchanges.

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
            Get-FMPHistoricalSectorPerformance -Sector "Technology" -Exchange "NASDAQ" -FromDate (Get-Date).AddMonths(-6) -ToDate (Get-Date)

            Retrieves the historical performance data for the Technology sector on NASDAQ over the past 6 months.
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [string] $Sector,

        [Parameter(Mandatory = $false)]
        [string] $Exchange,

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
        $baseUrl = "https://financialmodelingprep.com/api/v3/historical-sectors-performance"
    }

    Process {
        $queryParams = @{
            sector = $Sector
            apikey = $ApiKey
        }

        if ($Exchange) { $queryParams.exchange = $Exchange }
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
            throw "Error retrieving historical sector performance: $_"
        }
    }
 
 };


function Get-FMPHistoricalIndustryPerformance { 
 

    <#
        .SYNOPSIS
            Retrieves historical performance data for a specific market industry.

        .DESCRIPTION
            The Get-FMPHistoricalIndustryPerformance function fetches historical performance data for a specified
            market industry over a custom date range. This allows investors to track industry trends
            and performance over time, providing insights into how specific industries respond to various
            market conditions and economic factors.

            The data includes daily performance metrics and can be filtered by date range using the FromDate
            and ToDate parameters, and by exchange using the Exchange parameter. If no API key is provided,
            the function attempts to retrieve it using the Get-FMPCredential function.

        .PARAMETER Industry
            Specifies the market industry for which to retrieve historical performance data.
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
            Get-FMPHistoricalIndustryPerformance -Industry "Biotechnology" -Exchange "NASDAQ" -FromDate (Get-Date).AddMonths(-3) -ToDate (Get-Date)

            Retrieves the historical performance data for the Biotechnology industry on NASDAQ over the past 3 months.

        .NOTES
            This function uses the Financial Modeling Prep API's Historical Industry Performance endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/historical-industry-performance
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [string] $Industry,

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
        # Updated to use the stable endpoint
        $baseUrl = "https://financialmodelingprep.com/stable/historical-industry-performance"
    }

    Process {
        $queryParams = @{
            industry = $Industry
            apikey   = $ApiKey
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
            throw "Error retrieving historical industry performance: $_"
        }
    }
 
 };


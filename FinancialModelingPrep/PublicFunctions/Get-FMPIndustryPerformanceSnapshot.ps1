function Get-FMPIndustryPerformanceSnapshot { 
 

    <#
        .SYNOPSIS
            Retrieves a real-time snapshot of performance metrics for all market industries.

        .DESCRIPTION
            The Get-FMPIndustryPerformanceSnapshot function fetches current performance data for all market industries.
            The data includes detailed performance metrics such as changes over various time periods (1 day, 5 day,
            1 month, etc.), providing a granular view of market performance at the industry level. This information
            is useful for industry analysis, comparison, and identifying specific investment opportunities.

        .PARAMETER Date
            Specifies the date for which to retrieve industry performance data.
            The date must be a [datetime] object and is formatted as "yyyy-MM-dd".
            If omitted, returns the latest data.

        .PARAMETER Industry
            Specifies a specific industry to retrieve data for.
            If omitted, returns data for all industries.

        .PARAMETER Exchange
            Specifies the exchange to filter results (e.g., "NASDAQ").
            If omitted, returns data for all exchanges.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it
            using Get-FMPCredential.

        .EXAMPLE
            Get-FMPIndustryPerformanceSnapshot -Date (Get-Date "2024-02-01") -Industry "Biotechnology" -Exchange "NASDAQ"

            Retrieves industry performance data for the Biotechnology industry on NASDAQ for February 1, 2024.

        .NOTES
            This is a premium endpoint, and requires a paid subscription. This function uses the Financial Modeling Prep API's Industry Performance Snapshot endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/industry-performance-snapshot
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $false, HelpMessage = "Premium parameter, but also required")]
        [datetime] $Date,

        [Parameter(Mandatory = $false)]
        [string] $Industry,

        [Parameter(Mandatory = $false)]
        [string] $Exchange,

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/stable/industry-performance-snapshot"
    }

    Process {
        $queryParams = @{ apikey = $ApiKey }
        if ($Date) { $queryParams.date = $Date.ToString("yyyy-MM-dd") }
        if ($Industry) { $queryParams.industry = $Industry }
        if ($Exchange) { $queryParams.exchange = $Exchange }

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
            throw "Error retrieving industry performance snapshot: $_"
        }
    }
 
 };


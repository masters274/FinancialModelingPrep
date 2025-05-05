function Get-FMPSectorPerformanceSnapshot { 
 

    <#
        .SYNOPSIS
            Retrieves a real-time snapshot of performance metrics for all market sectors.

        .DESCRIPTION
            The Get-FMPSectorPerformanceSnapshot function fetches current performance data for all market sectors.
            The data includes performance metrics such as changes over various time periods (1 day, 5 day, 1 month, etc.),
            allowing you to compare sector performance across different timeframes. This information is valuable for
            sector rotation analysis and identifying market trends.

            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential
            function and prompts the user if necessary.

        .PARAMETER Date
            Specifies the date for which to retrieve sector performance data.
            The date must be a [datetime] object and is formatted as "yyyy-MM-dd".
            If omitted, returns the latest data.

        .PARAMETER Exchange
            Specifies the exchange to filter results (e.g., "NASDAQ").
            If omitted, returns data for all exchanges.

        .PARAMETER Sector
            Specifies a specific sector to retrieve data for.
            If omitted, returns data for all sectors.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it
            using Get-FMPCredential.

        .EXAMPLE
            Get-FMPSectorPerformanceSnapshot -Date (Get-Date "2024-02-01") -Exchange "NASDAQ" -Sector "Energy"

            Retrieves sector performance data for the Energy sector on NASDAQ for February 1, 2024.

        .NOTES
            This is a premium endpoint, and requires a paid subscription. This function uses the Financial Modeling Prep API's Sector Performance Snapshot endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/sector-performance-snapshot
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $false, HelpMessage = "Premium parameter, but also required")]
        [datetime] $Date,

        [Parameter(Mandatory = $false)]
        [string] $Exchange,

        [Parameter(Mandatory = $false)]
        [string] $Sector,

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/stable/sector-performance-snapshot"
    }

    Process {
        $queryParams = @{ apikey = $ApiKey }
        if ($Date) { $queryParams.date = $Date.ToString("yyyy-MM-dd") }
        if ($Exchange) { $queryParams.exchange = $Exchange }
        if ($Sector) { $queryParams.sector = $Sector }

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
            throw "Error retrieving sector performance snapshot: $_"
        }
    }
 
 };


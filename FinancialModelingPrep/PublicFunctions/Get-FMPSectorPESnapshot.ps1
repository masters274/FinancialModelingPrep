function Get-FMPSectorPESnapshot { 
 

    <#
        .SYNOPSIS
            Retrieves a snapshot of price-to-earnings (PE) ratios for all market sectors.

        .DESCRIPTION
            The Get-FMPSectorPESnapshot function fetches current PE ratio data for all market sectors.
            This allows investors to compare valuations across different market sectors and identify
            potentially overvalued or undervalued sectors. Results can be filtered by date, exchange,
            and specific sector.

            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential
            function and prompts the user if necessary.

        .PARAMETER Date
            Specifies the date for which to retrieve sector PE ratio data.
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
            Get-FMPSectorPESnapshot

            Retrieves the current PE ratio snapshot for all market sectors.

        .EXAMPLE
            Get-FMPSectorPESnapshot -Date (Get-Date "2024-02-01") -Exchange "NASDAQ" -Sector "Technology"

            Retrieves PE ratio data for the Technology sector on NASDAQ for February 1, 2024.

        .NOTES
            This is a premium endpoint, and requires a paid subscription. This function uses the Financial Modeling Prep API's Sector PE Snapshot endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/sector-pe-snapshot
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $false)]
        [datetime] $Date = (Get-Date),

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
        $baseUrl = "https://financialmodelingprep.com/stable/sector-pe-snapshot"
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
            throw "Error retrieving sector PE snapshot: $_"
        }
    }
 
 };


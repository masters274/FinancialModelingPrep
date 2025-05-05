function Get-FMPIndustryPESnapshot { 
 

    <#
        .SYNOPSIS
            Retrieves a snapshot of price-to-earnings (PE) ratios for all market industries.

        .DESCRIPTION
            The Get-FMPIndustryPESnapshot function fetches current PE ratio data for all market industries.
            This allows investors to compare valuations across different market industries and identify
            potentially overvalued or undervalued industries. Results can be filtered by date, exchange,
            and specific industry.

            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential
            function and prompts the user if necessary.

        .PARAMETER Date
            Specifies the date for which to retrieve sector PE ratio data.
            The date must be a [datetime] object and is formatted as "yyyy-MM-dd".
            If omitted, returns the latest data.

        .PARAMETER Exchange
            Specifies the exchange to filter results (e.g., "NASDAQ").
            If omitted, returns data for all exchanges.

        .PARAMETER Industry
            Specifies a specific industry to retrieve data for.
            If omitted, returns data for all industries.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it
            using Get-FMPCredential.

        .EXAMPLE
            Get-FMPIndustryPESnapshot -Date (Get-Date "2024-02-01")

            Retrieves the current PE ratio snapshot for all market industries.

        .EXAMPLE
            Get-FMPIndustryPESnapshot -Date (Get-Date "2024-02-01") -Exchange "NASDAQ" -Industry "Software"

            Retrieves PE ratio data for the Software industry on NASDAQ for February 1, 2024.

        .NOTES
            This is a premium endpoint, and requires a paid subscription. This function uses the Financial Modeling Prep API's Industry PE Snapshot endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/industry-pe-snapshot
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [datetime] $Date,

        [Parameter(Mandatory = $false)]
        [string] $Exchange,

        [Parameter(Mandatory = $false)]
        [string] $Industry,

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/stable/industry-pe-snapshot"
    }

    Process {
        $queryParams = @{ apikey = $ApiKey }
        if ($Date) { $queryParams.date = $Date.ToString("yyyy-MM-dd") }
        if ($Exchange) { $queryParams.exchange = $Exchange }
        if ($Industry) { $queryParams.industry = $Industry }

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
            throw "Error retrieving industry PE snapshot: $_"
        }
    }
 
 };


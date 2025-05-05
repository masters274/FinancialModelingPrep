function Get-FMPLatest8KFilings { 
 

    <#
        .SYNOPSIS
            Retrieves the latest 8-K SEC filings data.

        .DESCRIPTION
            The Get-FMPLatest8KFilings function fetches the most recent 8-K filings from publicly traded companies.
            It provides access to significant company events such as mergers, acquisitions, leadership changes,
            and other material events that may impact the market. Results can be filtered by date range.

        .PARAMETER FromDate
            Specifies the start date for filing retrieval in datetime format.
            If omitted, no start date filter is applied.

        .PARAMETER ToDate
            Specifies the end date for filing retrieval in datetime format.
            If omitted, no end date filter is applied.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it
            using Get-FMPCredential.

        .EXAMPLE
            Get-FMPLatest8KFilings

            Retrieves all recent 8-K filings without date filtering.

        .EXAMPLE
            Get-FMPLatest8KFilings -FromDate (Get-Date).AddMonths(-1) -ToDate (Get-Date)

            Retrieves 8-K filings from the past month.

        .NOTES
            This function uses the Financial Modeling Prep API's Latest 8-K SEC Filings endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/8k-latest
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $false)]
        [datetime] $FromDate = (Get-Date).AddDays(-30),

        [Parameter(Mandatory = $false)]
        [datetime] $ToDate = (Get-Date),

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/stable/sec-filings-8k"
    }

    Process {
        $queryParams = @{ apikey = $ApiKey }

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
            throw "Error retrieving latest 8-K filings data: $_"
        }
    }
 
 };


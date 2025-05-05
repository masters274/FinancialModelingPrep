function Get-FMPHistoricalIndexData { 
 
    <#
        .SYNOPSIS
            Retrieves historical constituent data for major stock indices.

        .DESCRIPTION
            The Get-FMPHistoricalIndexData function fetches historical constituent data for
            major stock indices (S&P 500, NASDAQ, or Dow Jones).
            This allows tracking of index composition changes over time.

        .PARAMETER IndexType
            Specifies the index type to retrieve historical data for.
            Valid values are "sp500", "nasdaq", and "dowjones".

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts
            to retrieve it using Get-FMPCredential.

        .EXAMPLE
            Get-FMPHistoricalIndexData -IndexType sp500

            Retrieves historical S&P 500 constituent data from January 1 to March 1, 2023.

        .NOTES
            This is a premium endpoint, and requires a paid subscription. This function uses the Financial Modeling Prep API's Historical Index Constituent endpoints.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [ValidateSet("sp500", "nasdaq", "dowjones")]
        [string] $IndexType,

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Enter your Financial Modeling Prep API key"
        }

        # Set the endpoint based on the index type
        switch ($IndexType) {
            "sp500" { $baseUrl = "https://financialmodelingprep.com/stable/historical-sp500-constituent" }
            "nasdaq" { $baseUrl = "https://financialmodelingprep.com/stable/historical-nasdaq-constituent" }
            "dowjones" { $baseUrl = "https://financialmodelingprep.com/stable/historical-dowjones-constituent" }
        }
    }

    Process {
        $queryParams = @{ apikey = $ApiKey }

        # Build the query string
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
            throw "Error retrieving historical index constituent data: $_"
        }
    }
 
 };


function Get-FMPTreasuryRates { 
 

    <#
        .SYNOPSIS
            Retrieves real-time and historical Treasury rates for all maturities using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPTreasuryRates function fetches Treasury rates that serve as key benchmarks for interest rates
            across the economy. Users can optionally filter the results by specifying a date range using the FromDate and ToDate
            parameters. This function returns rates for various maturities (e.g., 1 month, 2 month, 3 month, 6 month, 1 year,
            2 year, etc.), providing valuable insights for monitoring economic trends.
            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential function
            and prompts the user if necessary.

        .PARAMETER FromDate
            (Optional) Specifies the start date (inclusive) for retrieving Treasury rate data.
            The date should be provided as a [datetime] object and is formatted as "yyyy-MM-dd".

        .PARAMETER ToDate
            (Optional) Specifies the end date (inclusive) for retrieving Treasury rate data.
            The date should be provided as a [datetime] object and is formatted as "yyyy-MM-dd".

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function will attempt to retrieve it using
            the Get-FMPCredential function.

        .EXAMPLE
            Get-FMPTreasuryRates -FromDate (Get-Date "2024-01-01") -ToDate (Get-Date "2024-03-01")

            This example retrieves Treasury rates data from January 1, 2024 to March 1, 2024.

        .NOTES
            This function utilizes the Financial Modeling Prep Treasury Rates API endpoint.
            For more information, visit: https://financialmodelingprep.com
    #>

    [CmdletBinding()]

    Param (
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
        $baseUrl = "https://financialmodelingprep.com/stable/treasury-rates"
    }

    Process {
        $url = "{0}?apikey={1}" -f $baseUrl, $ApiKey

        if ($FromDate) {
            $url += "&from=" + $FromDate.ToString("yyyy-MM-dd")
        }
        if ($ToDate) {
            $url += "&to=" + $ToDate.ToString("yyyy-MM-dd")
        }

        $headers = @{
            "Upgrade-Insecure-Requests" = "1"
        }

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving Treasury rates data: $_"
        }
    }
 
 };


function Get-FMPIndexHistoricalEOD { 
 

    <#
        .SYNOPSIS
            Retrieves historical end-of-day (EOD) price data for a specified index symbol.

        .DESCRIPTION
            The Get-FMPIndexHistoricalEOD function fetches historical end-of-day price data for a given index.
            It offers two data modes: "Light" for basic price and volume data, and "Full" for comprehensive
            data including calculated metrics like VWAP and price changes. Optional date range filtering
            is available through FromDate and ToDate parameters.

        .PARAMETER Symbol
            Specifies the index symbol for which to retrieve historical data (e.g., ^GSPC for S&P 500).
            This parameter is mandatory.

        .PARAMETER Mode
            Specifies the data mode: "Light" returns basic price/volume data, while "Full" returns comprehensive data
            including additional metrics. Default value is "Full".

        .PARAMETER FromDate
            Specifies the start date (inclusive) for filtering the historical data.
            The date must be a [datetime] object and is formatted as "yyyy-MM-dd".
            This parameter is optional.

        .PARAMETER ToDate
            Specifies the end date (inclusive) for filtering the historical data.
            The date must be a [datetime] object and is formatted as "yyyy-MM-dd".
            This parameter is optional.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it
            using Get-FMPCredential.

        .EXAMPLE
            Get-FMPIndexHistoricalEOD -Symbol "^GSPC" -Mode Light

            Retrieves basic historical EOD price data for the S&P 500 index.

        .EXAMPLE
            Get-FMPIndexHistoricalEOD -Symbol "^DJI" -FromDate (Get-Date).AddMonths(-3) -ToDate (Get-Date)

            Retrieves comprehensive historical EOD price data for the Dow Jones Industrial Average for the last 3 months.

        .NOTES
            This function uses the Financial Modeling Prep API's Index Historical Price EOD endpoint.
            For more information, visit:
            - https://site.financialmodelingprep.com/developer/docs/stable/index-historical-price-eod-light
            - https://site.financialmodelingprep.com/developer/docs/stable/index-historical-price-eod-full
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

        # Select endpoint based on the Mode parameter
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
            throw "Error retrieving index historical EOD data: $_"
        }
    }
 
 };


function Get-FMPCOTAnalysis { 
 

    <#
        .SYNOPSIS
            Retrieves Commitment of Traders (COT) analysis data for a specified trading symbol within a given date range.

        .DESCRIPTION
            The Get-FMPCOTAnalysis function fetches in-depth insights into market sentiment by analyzing Commitment of Traders (COT)
            reports over a specified date range. This API provides detailed information about market dynamics, sentiment,
            and potential reversals across various sectors. The returned data includes key metrics such as current long and
            short market situations, net positions, market sentiment ratings, and reversal trends.
            The function supports filtering by trading symbol, as well as a custom date range through the "from" and "to" parameters.
            If no API key is provided, the function retrieves it using the Get-FMPCredential function or prompts the user if necessary.

        .PARAMETER Symbol
            Specifies the trading symbol for which the COT analysis data should be retrieved (e.g., AAPL). This parameter is mandatory.

        .PARAMETER FromDate
            Specifies the start date (inclusive) for the COT analysis data. The date must be a [datetime] object and is formatted as "yyyy-MM-dd".
            This parameter is optional.

        .PARAMETER ToDate
            Specifies the end date (inclusive) for the COT analysis data. The date must be a [datetime] object and is formatted as "yyyy-MM-dd".
            This parameter is optional.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it using the Get-FMPCredential function
            and prompts the user if necessary.

        .EXAMPLE
            Get-FMPCOTAnalysis -Symbol AAPL -FromDate (Get-Date "2024-01-01") -ToDate (Get-Date "2024-03-01")

            This example retrieves the COT analysis data for the symbol AAPL between January 1, 2024 and March 1, 2024.

        .NOTES
            This is a premium endpoint, and requires a paid subscription. This function utilizes the Financial Modeling Prep API's Commitment of Traders Analysis endpoint.
            For more information, visit: https://financialmodelingprep.com
    #>

    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true)]
        [string] $Symbol,

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
        $baseUrl = "https://financialmodelingprep.com/stable/commitment-of-traders-analysis"
    }

    Process {
        $url = "{0}?apikey={1}&symbol={2}" -f $baseUrl, $ApiKey, $Symbol

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
            throw "Error retrieving COT analysis data: $_"
        }
    }
 
 };


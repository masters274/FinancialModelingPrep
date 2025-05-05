function Get-FMPCOTReport { 
 

    <#
        .SYNOPSIS
            Retrieves comprehensive Commitment of Traders (COT) report data using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPCOTReport function fetches detailed COT report information that includes long and short positions
            across various sectors, enabling you to assess market sentiment and track positions in commodities, indices,
            and financial instruments. The function allows filtering by trading symbol and date range using the "symbol",
            "from", and "to" query parameters. If no API key is provided, the function attempts to retrieve it using the
            Get-FMPCredential function and prompts the user if necessary.

        .PARAMETER Symbol
            Specifies the trading symbol for which the COT (Commitment Of Traders) report data should be retrieved (e.g., AAPL). This parameter is mandatory.

        .PARAMETER FromDate
            Specifies the start date (inclusive) of the COT report data to retrieve.
            The date must be a [datetime] object and will be formatted as "yyyy-MM-dd".
            This parameter is optional.

        .PARAMETER ToDate
            Specifies the end date (inclusive) of the COT report data to retrieve.
            The date must be a [datetime] object and will be formatted as "yyyy-MM-dd".
            This parameter is optional.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function will attempt to retrieve it using Get-FMPCredential
            and will prompt the user if necessary.

        .EXAMPLE
            Get-FMPCOTReport -Symbol AAPL -FromDate (Get-Date "2024-01-01") -ToDate (Get-Date "2024-03-01")

            This example retrieves COT report data for the symbol AAPL between January 1, 2024 and March 1, 2024.

        .NOTES
            This is a premium endpoint, and requires a paid subscription. This function utilizes the Financial Modeling Prep API's Commitment of Traders Report endpoint.
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

        $baseUrl = "https://financialmodelingprep.com/stable/commitment-of-traders-report"
    }

    Process {
        # Build the base URL with mandatory API key and symbol parameters.
        $url = "{0}?apikey={1}&symbol={2}" -f $baseUrl, $ApiKey, $Symbol

        # Append optional from date if provided.
        if ($FromDate) {
            $url += "&from=" + $FromDate.ToString("yyyy-MM-dd")
        }

        # Append optional to date if provided.
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
            throw "Error retrieving COT report data: $_"
        }
    }
 
 };


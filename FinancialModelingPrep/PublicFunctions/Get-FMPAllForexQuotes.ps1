function Get-FMPAllForexQuotes { 
 

    <#
        .SYNOPSIS
            Retrieves current quote data for all available forex currency pairs using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPAllForexQuotes function fetches current market data for all available forex currency pairs
            in a single request. This provides a comprehensive overview of the entire forex market,
            including prices, changes, and other key metrics for all currency pairs.

            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential
            function and will prompt the user if necessary.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it
            using Get-FMPCredential.

        .EXAMPLE
            Get-FMPAllForexQuotes

            Retrieves quotes for all available forex currency pairs.

        .NOTES
            This is a premium endpoint, and requires a paid subscription. This function uses the Financial Modeling Prep API's All Forex Quotes endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/all-forex-quotes
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/api/v3/quotes/forex"
    }

    Process {
        $url = "{0}?apikey={1}" -f $baseUrl, $ApiKey

        $headers = @{
            "Upgrade-Insecure-Requests" = "1"
        }

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving all forex quotes: $_"
        }
    }
 
 };


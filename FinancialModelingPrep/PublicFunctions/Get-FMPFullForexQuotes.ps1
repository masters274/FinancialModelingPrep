function Get-FMPFullForexQuotes { 
 

    <#
        .SYNOPSIS
            Retrieves quote data for all forex currency pairs using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPFullForexQuotes function fetches comprehensive quote data for all forex currency pairs
            in a single request. This provides a complete snapshot of the foreign exchange market, including
            current exchange rates, rate changes, and other metrics for all available currency pairs.
            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential function.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it
            using Get-FMPCredential.

        .EXAMPLE
            Get-FMPFullForexQuotes

            Retrieves quotes for all available forex currency pairs.

        .NOTES
            This is a premium endpoint, and requires a paid subscription. This function uses the Financial Modeling Prep API's Batch Forex Quotes endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/full-forex-quotes
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
        $baseUrl = "https://financialmodelingprep.com/stable/batch-forex-quotes"
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
            throw "Error retrieving full forex quotes: $_"
        }
    }
 
 };


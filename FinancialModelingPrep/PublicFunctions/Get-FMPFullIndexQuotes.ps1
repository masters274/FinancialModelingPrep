function Get-FMPFullIndexQuotes { 
 

    <#
        .SYNOPSIS
            Retrieves quote data for all market indexes using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPFullIndexQuotes function fetches comprehensive quote data for all market indexes
            in a single request. This provides a complete snapshot of global market indexes, including
            current values, point changes, percentage changes, and other metrics for all available indexes.
            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential function.

        .PARAMETER Short
            Indicates whether to retrieve shorter, summarized quote data instead of the full detailed quotes.
            When set to $true, returns abbreviated information. Default is $false (full quotes).

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it
            using Get-FMPCredential.

        .EXAMPLE
            Get-FMPFullIndexQuotes

            Retrieves full quotes for all available market indexes.

        .EXAMPLE
            Get-FMPFullIndexQuotes -Short

            Retrieves shortened quotes for all available market indexes.

        .NOTES
            This is a premium endpoint, and requires a paid subscription. This function uses the Financial Modeling Prep API's Batch Index Quotes endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/full-index-quotes
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $false)]
        [switch] $Short,

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }

        $baseUrl = "https://financialmodelingprep.com/stable/batch-index-quotes"
    }

    Process {
        $url = "{0}?apikey={1}" -f $baseUrl, $ApiKey

        if ($Short) {
            $url = "{0}&short=true" -f $url
        }

        $headers = @{
            "Upgrade-Insecure-Requests" = "1"
        }

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving full index quotes: $_"
        }
    }
 
 };


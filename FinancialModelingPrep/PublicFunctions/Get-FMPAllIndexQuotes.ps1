function Get-FMPAllIndexQuotes { 
 

    <#
        .SYNOPSIS
            Retrieves quotes for all indexes.

        .DESCRIPTION
            Uses the Financial Modeling Prep API to obtain real-time quotes for all available indexes.

        .PARAMETER ApiKey
            Your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it via Get-FMPCredential.

        .EXAMPLE
            Get-FMPAllIndexQuotes

        .NOTES
            This is a premium endpoint, and requires a paid subscription. This function uses the All Index Quotes API endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/all-index-quotes
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
            $ApiKey = Read-Host "Enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/stable/batch-index-quotes"
    }

    Process {
        $url = "{0}?apikey={1}" -f $baseUrl, $ApiKey

        if ($Short) {
            $url += "&short"
        }

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving all index quotes: $_"
        }
    }
 
 };


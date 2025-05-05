function Get-FMPFullMutualFundQuotes { 
 

    <#
        .SYNOPSIS
            Retrieves quote data for all mutual funds using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPFullMutualFundQuotes function fetches comprehensive quote data for all mutual funds
            in a single request. This provides a complete snapshot of the mutual fund market, including
            current prices, price changes, net asset values, and other metrics for all available mutual funds.
            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential function.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it
            using Get-FMPCredential.

        .EXAMPLE
            Get-FMPFullMutualFundQuotes

            Retrieves quotes for all available mutual funds.

        .NOTES
            This is a premium endpoint, and requires a paid subscription. This function uses the Financial Modeling Prep API's Batch Mutual Fund Quotes endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/full-mutualfund-quotes
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
        $baseUrl = "https://financialmodelingprep.com/stable/batch-mutualfund-quotes"
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
            throw "Error retrieving full mutual fund quotes: $_"
        }
    }
 
 };


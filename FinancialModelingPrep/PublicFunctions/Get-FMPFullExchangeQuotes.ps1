function Get-FMPFullExchangeQuotes { 
 

    <#
        .SYNOPSIS
            Retrieves quote data for all stocks on a specified exchange using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPFullExchangeQuotes function fetches comprehensive quote data for all stocks
            trading on a specified exchange in a single request. This provides a complete market snapshot
            for a particular exchange, including current prices, price changes, volumes, and other trading metrics
            for all listed securities. If no API key is provided, the function attempts to retrieve it
            using the Get-FMPCredential function.

        .PARAMETER Exchange
            Specifies the exchange for which to retrieve quotes (e.g., "NASDAQ", "NYSE"). This parameter is mandatory.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it
            using Get-FMPCredential.

        .EXAMPLE
            Get-FMPFullExchangeQuotes -Exchange "NASDAQ"

            Retrieves quotes for all stocks listed on the NASDAQ exchange.

        .NOTES
            This is a premium endpoint, and requires a paid subscription. This function uses the Financial Modeling Prep API's Batch Exchange Quote endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/full-exchange-quotes
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [string] $Exchange,

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/stable/batch-exchange-quote"
    }

    Process {
        $url = "{0}?exchange={1}&apikey={2}" -f $baseUrl, $Exchange, $ApiKey

        $headers = @{
            "Upgrade-Insecure-Requests" = "1"
        }

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving full exchange quotes: $_"
        }
    }
 
 };


function Get-FMPCryptoQuote { 
 

    <#
        .SYNOPSIS
            Retrieves current quote data for a specified cryptocurrency using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPCryptoQuote function fetches the current market data for a specific cryptocurrency.
            Two quote formats are available:
            - Full: provides comprehensive data including price, change, day low/high, year low/high, and more
            - Short: provides concise data with only the symbol, price, and volume

            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential
            function and will prompt the user if necessary.

        .PARAMETER Symbol
            Specifies the cryptocurrency symbol (e.g., BTCUSD, ETHUSD). This parameter is mandatory.

        .PARAMETER Mode
            Specifies the quote format to retrieve. Valid values are "Full" and "Short".
            The default value is "Full".

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it
            using Get-FMPCredential.

        .EXAMPLE
            Get-FMPCryptoQuote -Symbol BTCUSD

            Retrieves the full quote for Bitcoin (BTCUSD).

        .EXAMPLE
            Get-FMPCryptoQuote -Symbol ETHUSD -Mode Short

            Retrieves the short quote for Ethereum (ETHUSD).

        .NOTES
            This function uses the Financial Modeling Prep API's Cryptocurrency Quote endpoints.
            For more information, visit:
            https://site.financialmodelingprep.com/developer/docs/stable/cryptocurrency-quote
            https://site.financialmodelingprep.com/developer/docs/stable/cryptocurrency-quote-short
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [string] $Symbol,

        [Parameter(Mandatory = $false)]
        [ValidateSet("Full", "Short")]
        [string] $Mode = "Full",

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }

        # Select the appropriate endpoint based on the Mode parameter
        if ($Mode -eq "Full") {
            $baseUrl = "https://financialmodelingprep.com/api/v3/quote"
        }
        else {
            $baseUrl = "https://financialmodelingprep.com/api/v3/quote-short"
        }
    }

    Process {
        $url = "{0}/{1}?apikey={2}" -f $baseUrl, $Symbol, $ApiKey

        $headers = @{
            "Upgrade-Insecure-Requests" = "1"
        }

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving cryptocurrency quote: $_"
        }
    }
 
 };


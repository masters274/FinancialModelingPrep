function Get-FMPCommodityQuote { 
 

    <#
        .SYNOPSIS
            Retrieves current quote data for a specified commodity using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPCommodityQuote function fetches the current market data for a specific commodity.
            Two quote formats are available:
            - Full: provides comprehensive data including price, change, day low/high, year low/high, and more
            - Short: provides concise data with only the symbol, price, and volume

            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential
            function and will prompt the user if necessary.

        .PARAMETER Symbol
            Specifies the commodity symbol (e.g., OUSX, GCUSD). This parameter is mandatory.

        .PARAMETER Mode
            Specifies the quote format to retrieve. Valid values are "Full" and "Short".
            The default value is "Full".

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it
            using Get-FMPCredential.

        .EXAMPLE
            Get-FMPCommodityQuote -Symbol GCUSD

            Retrieves the full quote for Gold (GCUSD).

        .EXAMPLE
            Get-FMPCommodityQuote -Symbol OUSX -Mode Short

            Retrieves the short quote for Crude Oil (OUSX).

        .NOTES
            This function uses the Financial Modeling Prep API's Commodities Quote endpoints.
            For more information, visit:
            https://site.financialmodelingprep.com/developer/docs/stable/commodities-quote
            https://site.financialmodelingprep.com/developer/docs/stable/commodities-quote-short
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
            throw "Error retrieving commodity quote: $_"
        }
    }
 
 };


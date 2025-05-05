function Get-FMPQuoteChange { 
 

    <#
        .SYNOPSIS
            Retrieves price change data for a specified stock symbol using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPQuoteChange function fetches price change information for a given stock symbol,
            showing how the stock price has changed over various time periods (1 day, 5 day, 1 month, etc.).
            This helps analyze short and long-term price performance. If no API key is provided,
            the function attempts to retrieve it using the Get-FMPCredential function.

        .PARAMETER Symbol
            Specifies the stock symbol for which to retrieve price change data (e.g., AAPL). This parameter is mandatory.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it
            using Get-FMPCredential.

        .EXAMPLE
            Get-FMPQuoteChange -Symbol AAPL

            Retrieves price change data for Apple Inc.

        .NOTES
            This function uses the Financial Modeling Prep API's Stock Price Change endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/quote-change
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [string] $Symbol,

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/stable/stock-price-change"
    }

    Process {
        $url = "{0}?symbol={1}&apikey={2}" -f $baseUrl, $Symbol, $ApiKey

        $headers = @{
            "Upgrade-Insecure-Requests" = "1"
        }

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving price change data: $_"
        }
    }
 
 };


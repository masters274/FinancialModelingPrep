function Get-FMPAfterMarketQuote { 
 

    <#
        .SYNOPSIS
            Retrieves after-market quote data for a specified stock symbol using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPAfterMarketQuote function fetches after-market quote information for a given stock symbol,
            providing details about how the stock is trading after regular market hours. This includes after-hours
            price, price change, and percentage change. If no API key is provided, the function attempts to retrieve it
            using the Get-FMPCredential function.

        .PARAMETER Symbol
            Specifies the stock symbol for which to retrieve after-market quote data (e.g., AAPL). This parameter is mandatory.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it
            using Get-FMPCredential.

        .EXAMPLE
            Get-FMPAfterMarketQuote -Symbol AAPL

            Retrieves after-market quote data for Apple Inc.

        .NOTES
            This function uses the Financial Modeling Prep API's After Market Quote endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/aftermarket-quote
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
        $baseUrl = "https://financialmodelingprep.com/stable/aftermarket-quote"
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
            throw "Error retrieving after-market quote data: $_"
        }
    }
 
 };


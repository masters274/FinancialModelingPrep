function Get-FMPQuote { 
 

    <#
        .SYNOPSIS
            Retrieves full quote data for a specified stock symbol using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPQuote function fetches comprehensive quote data for a given stock symbol,
            including current price, price changes, volume, day range, 52-week range, market capitalization,
            and other relevant trading information. If no API key is provided, the function attempts to retrieve it
            using the Get-FMPCredential function.

        .PARAMETER Symbol
            Specifies the stock symbol for which to retrieve quote data (e.g., AAPL). This parameter is mandatory.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it
            using Get-FMPCredential.

        .EXAMPLE
            Get-FMPQuote -Symbol AAPL

            Retrieves comprehensive quote data for Apple Inc.

        .NOTES
            This function uses the Financial Modeling Prep API's Quote endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/quote
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
        $baseUrl = "https://financialmodelingprep.com/stable/quote"
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
            throw "Error retrieving quote data: $_"
        }
    }
 
 };


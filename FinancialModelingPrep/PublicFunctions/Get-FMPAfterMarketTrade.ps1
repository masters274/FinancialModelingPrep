function Get-FMPAfterMarketTrade { 
 

    <#
        .SYNOPSIS
            Retrieves after-market trading data for a specified stock symbol using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPAfterMarketTrade function fetches after-market trading information for a given stock symbol,
            including the most recent after-hours trades, prices, and volumes. If no API key is provided,
            the function attempts to retrieve it using the Get-FMPCredential function.

        .PARAMETER Symbol
            Specifies the stock symbol for which to retrieve after-market trade data (e.g., AAPL). This parameter is mandatory.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it
            using Get-FMPCredential.

        .EXAMPLE
            Get-FMPAfterMarketTrade -Symbol AAPL

            Retrieves after-market trading data for Apple Inc.

        .NOTES
            This function uses the Financial Modeling Prep API's After Market Trade endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/aftermarket-trade
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
        $baseUrl = "https://financialmodelingprep.com/stable/aftermarket-trade"
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
            throw "Error retrieving after-market trade data: $_"
        }
    }
 
 };


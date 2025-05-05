function Get-FMPCryptoList { 
 

    <#
        .SYNOPSIS
            Retrieves a list of available cryptocurrencies from Financial Modeling Prep.

        .DESCRIPTION
            The Get-FMPCryptoList function calls the Financial Modeling Prep API endpoint for available cryptocurrencies.
            It returns data including each cryptocurrency?s symbol, name, currency, stockExchange, and exchangeShortName.
            If no API key is provided, the function will attempt to retrieve it using Get-FMPCredential and prompt the user if necessary.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function will attempt to retrieve it using Get-FMPCredential
            and prompt the user if necessary.

        .EXAMPLE
            Get-FMPCryptoList

            Retrieves the list of available cryptocurrencies using the specified API key.

        .NOTES
            This function uses the Financial Modeling Prep API?s endpoint:
            https://financialmodelingprep.com/api/v3/symbol/available-cryptocurrencies
            For more information, visit: https://financialmodelingprep.com
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
        # Base URL for the FMP API v3.
        $baseUrl = "https://financialmodelingprep.com/api/v3"
    }

    Process {
        # Construct the complete URL with the API key.
        $url = "$baseUrl/symbol/available-cryptocurrencies?apikey=$ApiKey"

        # Prepare the required headers.
        $headers = @{
            "Upgrade-Insecure-Requests" = "1"
        }

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving FMP crypto list: $_"
        }
    }
 
 };


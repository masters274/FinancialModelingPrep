function Get-FMPQuoteShort { 
 

    <#
        .SYNOPSIS
            Retrieves short-form quote data for a specified stock symbol using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPQuoteShort function fetches abbreviated quote data for a given stock symbol,
            providing just the essential information including symbol, price, and volume.
            This is useful when only basic price information is needed. If no API key is provided,
            the function attempts to retrieve it using the Get-FMPCredential function.

        .PARAMETER Symbol
            Specifies the stock symbol for which to retrieve short quote data (e.g., AAPL). This parameter is mandatory.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it
            using Get-FMPCredential.

        .EXAMPLE
            Get-FMPQuoteShort -Symbol AAPL

            Retrieves short-form quote data for Apple Inc.

        .NOTES
            This function uses the Financial Modeling Prep API's Quote Short endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/quote-short
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
        $baseUrl = "https://financialmodelingprep.com/stable/quote-short"
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
            throw "Error retrieving short quote data: $_"
        }
    }
 
 };


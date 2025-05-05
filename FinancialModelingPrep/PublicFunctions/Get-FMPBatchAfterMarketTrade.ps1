function Get-FMPBatchAfterMarketTrade { 
 

    <#
        .SYNOPSIS
            Retrieves after-market trading data for multiple stock symbols in a single request using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPBatchAfterMarketTrade function fetches after-market trading information for multiple stock symbols
            in one API call, including the most recent after-hours trades, prices, and volumes for each requested symbol.
            This is efficient for monitoring after-hours activity across multiple stocks. If no API key is provided,
            the function attempts to retrieve it using the Get-FMPCredential function.

        .PARAMETER Symbols
            Specifies the stock symbols for which to retrieve after-market trade data as a comma-separated string (e.g., "AAPL,MSFT,GOOGL").
            This parameter is mandatory.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it
            using Get-FMPCredential.

        .EXAMPLE
            Get-FMPBatchAfterMarketTrade -Symbols "AAPL,MSFT,GOOGL"

            Retrieves after-market trading data for Apple, Microsoft, and Google.

        .NOTES
            This is a premium endpoint, and requires a paid subscription. This function uses the Financial Modeling Prep API's Batch After Market Trade endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/batch-aftermarket-trade
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [string] $Symbols,

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/stable/batch-aftermarket-trade"
    }

    Process {
        $url = "{0}?symbols={1}&apikey={2}" -f $baseUrl, $Symbols, $ApiKey

        $headers = @{
            "Upgrade-Insecure-Requests" = "1"
        }

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving batch after-market trade data: $_"
        }
    }
 
 };


function Get-FMPBatchQuote { 
 

    <#
        .SYNOPSIS
            Retrieves full quote data for multiple stock symbols in a single request using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPBatchQuote function fetches comprehensive quote data for multiple stock symbols in one API call,
            improving efficiency when monitoring multiple stocks. The function returns detailed information including
            current price, price changes, volume, day range, market capitalization, and other trading metrics for each symbol.
            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential function.

        .PARAMETER Symbols
            Specifies the stock symbols for which to retrieve quote data as a comma-separated string (e.g., "AAPL,MSFT,GOOGL").
            This parameter is mandatory.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it
            using Get-FMPCredential.

        .EXAMPLE
            Get-FMPBatchQuote -Symbols "AAPL,MSFT,GOOGL"

            Retrieves comprehensive quote data for Apple, Microsoft, and Google.

        .NOTES
            This is a premium endpoint, and requires a paid subscription. This function uses the Financial Modeling Prep API's Batch Quote endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/batch-quote
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
        $baseUrl = "https://financialmodelingprep.com/stable/batch-quote"
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
            throw "Error retrieving batch quote data: $_"
        }
    }
 
 };


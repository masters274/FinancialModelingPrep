function Search-FMPStockSymbol { 
 

    <#
        .SYNOPSIS
            Searches for stock symbols by company name or symbol using the Financial Modeling Prep API.

        .DESCRIPTION
            The Search-FMPStockSymbol function allows you to search for ticker symbols across multiple global markets.
            You can search by company name or stock symbol using the query parameter. In addition, you may specify a
            limit for the number of results returned (default is 50) and optionally restrict the search to a specific exchange.
            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential function and prompts
            the user if necessary.

        .PARAMETER Query
            Specifies the search query for the company name or stock symbol (e.g., "AAPL"). This parameter is mandatory.

        .PARAMETER Limit
            Specifies the maximum number of results to return. The default value is 50. This parameter is optional.

        .PARAMETER Exchange
            Optionally restricts the search results to a specific exchange (e.g., "NASDAQ"). This parameter is optional.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it using Get-FMPCredential
            and will prompt the user if necessary.

        .EXAMPLE
            Search-FMPStockSymbol -Query AAPL -Limit 50 -Exchange NASDAQ

            This example searches for stock symbols matching "AAPL" on the NASDAQ exchange, returning up to 50 results.

        .NOTES
            This function utilizes the Financial Modeling Prep API's Stock Symbol Search endpoint.
            For more information, visit: https://financialmodelingprep.com
    #>

    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true)]
        [string] $Query,

        [Parameter(Mandatory = $false)]
        [int] $Limit = 50,

        [Parameter(Mandatory = $false)]
        [string] $Exchange,

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/stable/search-symbol"
    }

    Process {
        $url = "{0}?query={1}&limit={2}&apikey={3}" -f $baseUrl, $Query, $Limit, $ApiKey

        if ($Exchange) {
            $url += "&exchange=" + $Exchange
        }

        $headers = @{
            "Upgrade-Insecure-Requests" = "1"
        }

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving stock symbol search data: $_"
        }
    }
 
 };


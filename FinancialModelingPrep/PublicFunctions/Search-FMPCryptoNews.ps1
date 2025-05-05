function Search-FMPCryptoNews { 
 

    <#
        .SYNOPSIS
            Searches for cryptocurrency news by specific symbols.

        .DESCRIPTION
            The Search-FMPCryptoNews function allows you to search for cryptocurrency news
            articles related to specified crypto symbols. You can also limit results by date range.

        .PARAMETER Symbols
            Specifies the cryptocurrency symbol(s) to search for news. Comma-separated list for multiple symbols (e.g., "BTCUSD,ETHUSD").
            This parameter is mandatory.

        .PARAMETER FromDate
            Specifies the start date for the news search in datetime format.
            Default is 7 days ago from current date.

        .PARAMETER ToDate
            Specifies the end date for the news search in datetime format.
            Default is current date.

        .PARAMETER ApiKey
            Your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it using Get-FMPCredential.

        .EXAMPLE
            Search-FMPCryptoNews -Symbols "BTCUSD"

            Searches for news about Bitcoin from the last 7 days.

        .EXAMPLE
            Search-FMPCryptoNews -Symbols "BTCUSD,ETHUSD" -FromDate (Get-Date).AddMonths(-1) -ToDate (Get-Date)

            Searches for news about Bitcoin and Ethereum from the last month.

        .NOTES
            This is a premium endpoint, and requires a paid subscription. This function uses the Financial Modeling Prep API's Search Crypto News endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/search-crypto-news
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [string]$Symbols,

        [Parameter(Mandatory = $false)]
        [datetime]$FromDate = (Get-Date).AddDays(-7),

        [Parameter(Mandatory = $false)]
        [datetime]$ToDate = (Get-Date),

        [Parameter(Mandatory = $false)]
        [string]$ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/stable/news/crypto"
    }

    Process {
        $url = "{0}?symbols={1}&from={2}&to={3}&apikey={4}" -f $baseUrl, $Symbols,
        $FromDate.ToString("yyyy-MM-dd"), $ToDate.ToString("yyyy-MM-dd"), $ApiKey

        $headers = @{
            "Upgrade-Insecure-Requests" = "1"
        }

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error searching crypto news: $_"
        }
    }
 
 };


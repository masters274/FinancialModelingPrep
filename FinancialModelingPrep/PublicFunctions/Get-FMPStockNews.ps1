function Get-FMPStockNews { 
 

    <#
        .SYNOPSIS
            Retrieves latest stock market news.

        .DESCRIPTION
            The Get-FMPStockNews function fetches the most recent stock market news articles.
            You can filter by ticker symbol, specify the page number for pagination, and set
            the maximum number of articles to return.

        .PARAMETER Tickers
            Specifies the stock symbol(s) to filter news. Accepts a single ticker or a comma-separated list of tickers.

        .PARAMETER Page
            Specifies the page number for pagination. Default is 0.

        .PARAMETER Limit
            Specifies the maximum number of news articles to return. Default is 50.

        .PARAMETER ApiKey
            Your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it using Get-FMPCredential.

        .EXAMPLE
            Get-FMPStockNews -Page 0 -Limit 20

            Returns the first 20 stock market news articles from page 0.

        .EXAMPLE
            Get-FMPStockNews -Tickers "AAPL,MSFT" -Limit 10

            Returns up to 10 news articles related to Apple and Microsoft.

        .NOTES
            This is a premium endpoint, and requires a paid subscription. This function uses the Financial Modeling Prep API's Stock News endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/stock-news
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $false)]
        [string]$Tickers,

        [Parameter(Mandatory = $false)]
        [int]$Page = 0,

        [Parameter(Mandatory = $false)]
        [int]$Limit = 50,

        [Parameter(Mandatory = $false)]
        [string]$ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/api/v3/stock_news"
    }

    Process {
        $queryParams = @{
            page   = $Page
            limit  = $Limit
            apikey = $ApiKey
        }

        if ($Tickers) { $queryParams.tickers = $Tickers }

        $queryString = ($queryParams.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" }) -join "&"
        $url = "{0}?{1}" -f $baseUrl, $queryString

        $headers = @{
            "Upgrade-Insecure-Requests" = "1"
        }

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving stock news: $_"
        }
    }
 
 };


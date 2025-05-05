function Search-FMPStockNews { 
 

    <#
            .SYNOPSIS
            Searches for stock market news by specific symbols.

            .DESCRIPTION
            The Search-FMPStockNews function allows you to search for stock market news
            articles related to specified stock symbols. You can also limit results by date range.

            .PARAMETER Symbols
            Specifies the stock symbol(s) to search for news. Comma-separated list for multiple symbols (e.g., "AAPL,MSFT").
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
            Search-FMPStockNews -Symbols "AAPL"

            Searches for news about Apple Inc. from the last 7 days.

            .EXAMPLE
            Search-FMPStockNews -Symbols "AAPL,MSFT" -FromDate (Get-Date).AddMonths(-1) -ToDate (Get-Date)

            Searches for news about Apple and Microsoft from the last month.

            .NOTES
            This is a premium endpoint, and requires a paid subscription. This function uses the Financial Modeling Prep API's Search Stock News endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/search-stock-news
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
        $baseUrl = "https://financialmodelingprep.com/stable/news/stock"
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
            throw "Error searching stock news: $_"
        }
    }
 
 };


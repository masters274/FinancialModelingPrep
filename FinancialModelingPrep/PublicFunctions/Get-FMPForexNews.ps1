function Get-FMPForexNews { 
 

    <#
        .SYNOPSIS
            Retrieves latest forex market news.

        .DESCRIPTION
            The Get-FMPForexNews function fetches the most recent news articles related to foreign exchange markets.
            Results are paginated and can be limited to control the amount of data returned.

        .PARAMETER Page
            Specifies the page number for pagination. Default is 0.

        .PARAMETER Limit
            Specifies the maximum number of news articles to return. Default is 50.

        .PARAMETER ApiKey
            Your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it using Get-FMPCredential.

        .EXAMPLE
            Get-FMPForexNews -Page 0 -Limit 20

            Returns the first 20 forex news articles from page 0.

        .NOTES
            This is a premium endpoint, and requires a paid subscription. This function uses the Financial Modeling Prep API's Forex News endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/forex-news
    #>

    [CmdletBinding()]
    Param (
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
        $baseUrl = "https://financialmodelingprep.com/api/v4/forex_news"
    }

    Process {
        $url = "{0}?page={1}&limit={2}&apikey={3}" -f $baseUrl, $Page, $Limit, $ApiKey

        $headers = @{
            "Upgrade-Insecure-Requests" = "1"
        }

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving forex news: $_"
        }
    }
 
 };


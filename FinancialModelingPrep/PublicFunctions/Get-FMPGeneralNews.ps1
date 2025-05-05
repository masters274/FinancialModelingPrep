function Get-FMPGeneralNews { 
 

    <#
        .SYNOPSIS
            Retrieves general news articles from a variety of sources.

        .DESCRIPTION
            The Get-FMPGeneralNews function fetches general news articles from various sources
            through the Financial Modeling Prep API. This provides broad coverage of general news
            topics beyond just financial markets. Results are paginated.

        .PARAMETER Page
            Specifies the page number for pagination. Default is 0.

        .PARAMETER Limit
            Specifies the maximum number of news articles to return. Default is 50.

        .PARAMETER ApiKey
            Your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it using Get-FMPCredential.

        .EXAMPLE
            Get-FMPGeneralNews -Page 0 -Limit 30

            Returns the first 30 general news articles from page 0.

        .NOTES
            This is a premium endpoint, and requires a paid subscription. This function uses the Financial Modeling Prep API's General News endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/general-news
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
        $baseUrl = "https://financialmodelingprep.com/api/v4/general_news"
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
            throw "Error retrieving general news: $_"
        }
    }
 
 };


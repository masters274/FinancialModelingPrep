function Get-FMPArticles { 
 

    <#
        .SYNOPSIS
            Retrieves FMP-authored financial articles and analysis.

        .DESCRIPTION
            The Get-FMPArticles function fetches financial articles written by Financial Modeling Prep.
            These articles provide in-depth analysis and insights on various financial topics,
            companies, and market trends. Results can be paginated and filtered by category.

        .PARAMETER Page
            Specifies the page number for pagination. Default is 0.

        .PARAMETER Category
            Specifies the article category to filter results. Optional.

        .PARAMETER Limit
            Specifies the maximum number of articles to return. Default is 50.

        .PARAMETER ApiKey
            Your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it using Get-FMPCredential.

        .EXAMPLE
            Get-FMPArticles -Page 0 -Limit 20

            Returns the first 20 FMP-authored articles from page 0.

        .EXAMPLE
            Get-FMPArticles -Category "Financial Analysis" -Page 1

            Returns FMP articles in the "Financial Analysis" category from page 1.

        .NOTES
            This is a premium endpoint, and requires a paid subscription. This function uses the Financial Modeling Prep API's FMP Articles endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/fmp-articles
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $false)]
        [int]$Page = 0,

        [Parameter(Mandatory = $false)]
        [string]$Category,

        [Parameter(Mandatory = $false)]
        [int]$Limit = 50,

        [Parameter(Mandatory = $false)]
        [string]$ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/stable/fmp-articles"
    }

    Process {
        $queryParams = @{
            page   = $Page
            limit  = $Limit
            apikey = $ApiKey
        }

        if ($Category) { $queryParams.category = $Category }

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
            throw "Error retrieving FMP articles: $_"
        }
    }
 
 };


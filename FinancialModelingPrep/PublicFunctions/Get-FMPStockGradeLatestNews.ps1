function Get-FMPStockGradeLatestNews { 
 

    <#
        .SYNOPSIS
            Retrieves the latest updates on stock rating changes for all stock symbols using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPStockGradeLatestNews function fetches real-time news updates related to analyst rating changes
            for stocks, including information such as the published date, news title, news URL, grading actions, and price details.
            This function helps track stock price movements and grading firm actions as they are reported by trusted publishers.
            Use the "page" and "limit" parameters to control pagination. If no API key is provided, the function attempts to retrieve
            it using the Get-FMPCredential function and will prompt the user if necessary.

        .PARAMETER Page
            Specifies the page number for paginated results. The default value is 0.

        .PARAMETER Limit
            Specifies the maximum number of news items to return per request. The default value is 10, which is the max for the free version.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it using Get-FMPCredential.

        .EXAMPLE
            Get-FMPStockGradeLatestNews -Page 0 -Limit 10

            This example retrieves up to 10 of the latest stock grade news items from the first page using your Financial Modeling Prep API key.

        .NOTES
            This function utilizes the Financial Modeling Prep API's Grades Latest News endpoint.
            For more information, visit: https://financialmodelingprep.com
    #>

    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $false)]
        [int] $Page = 0,

        [Parameter(Mandatory = $false)]
        [int] $Limit = 10,

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/stable/grades-latest-news"
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
            throw "Error retrieving FMP stock grade latest news data: $_"
        }
    }
 
 };


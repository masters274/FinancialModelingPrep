function Get-FMPPriceTargetLatestNews { 
 

    <#
        .SYNOPSIS
            Retrieves the most recent analyst price target news across all stock symbols using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPPriceTargetLatestNews function fetches the latest news updates related to analyst price targets.
            It provides detailed information including the published date, news URL, news title, analyst name, price targets,
            stock price at the time of posting, and publisher details. This function supports pagination via the "limit"
            and "page" parameters. If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential
            function and prompts the user if necessary.

        .PARAMETER Limit
            Specifies the maximum number of news items to return. The default value is 10.

        .PARAMETER Page
            Specifies the page number for pagination. The default value is 0.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it using Get-FMPCredential.

        .EXAMPLE
            Get-FMPPriceTargetLatestNews -Limit 10 -Page 0

            This example retrieves up to 10 of the latest price target news items from the first page using your Financial Modeling Prep API key.

        .NOTES
            This function utilizes the Financial Modeling Prep API's Price Target Latest News endpoint.
            For more information, visit: https://financialmodelingprep.com
    #>

    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $false)]
        [int] $Limit = 10,

        [Parameter(Mandatory = $false)]
        [int] $Page = 0,

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/stable/price-target-latest-news"
    }

    Process {
        $url = "{0}?limit={1}&page={2}&apikey={3}" -f $baseUrl, $Limit, $Page, $ApiKey

        $headers = @{
            "Upgrade-Insecure-Requests" = "1"
        }

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving price target latest news data: $_"
        }
    }
 
 };


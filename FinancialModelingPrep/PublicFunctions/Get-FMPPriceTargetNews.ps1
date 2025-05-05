function Get-FMPPriceTargetNews { 
 

    <#
        .SYNOPSIS
            Retrieves real-time analyst price target news for a specified stock symbol using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPPriceTargetNews function fetches real-time updates on analyst price targets for stocks.
            It provides detailed information such as the news title, published date, news URL, analyst name, price target,
            stock price at the time of the update, and additional publisher details.
            Users can filter the results by specifying the stock symbol, and paginate the results using the limit and page parameters.
            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential function and prompts
            the user if necessary.

        .PARAMETER Symbol
            Specifies the stock symbol for which the price target news is to be retrieved (e.g., AAPL). This parameter is mandatory.

        .PARAMETER Limit
            Specifies the maximum number of news items to return. The default value is 10. This parameter is optional.

        .PARAMETER Page
            Specifies the page number for the results. The default value is 0. This parameter is optional.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it using the Get-FMPCredential function.

        .EXAMPLE
            Get-FMPPriceTargetNews -Symbol AAPL -Limit 10 -Page 0

            This example retrieves up to 10 news items for the stock symbol AAPL from the first page using your Financial Modeling Prep API key.

        .NOTES
            This is a premium endpoint, and requires a paid subscription. This function utilizes the Financial Modeling Prep API's Price Target News endpoint.
            For more information, visit: https://financialmodelingprep.com
    #>

    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true)]
        [string] $Symbol,

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
        $baseUrl = "https://financialmodelingprep.com/stable/price-target-news"
    }

    Process {
        $url = "{0}?symbol={1}&limit={2}&page={3}&apikey={4}" -f $baseUrl, $Symbol, $Limit, $Page, $ApiKey

        $headers = @{
            "Upgrade-Insecure-Requests" = "1"
        }

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving price target news data: $_"
        }
    }
 
 };


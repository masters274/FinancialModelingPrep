function Get-FMPCryptoNews { 
 

    <#
        .SYNOPSIS
            Retrieves the latest cryptocurrency news articles from Financial Modeling Prep.

        .DESCRIPTION
            The Get-FMPCryptoNews function fetches crypto news data from Financial Modeling Prep?s API.
            You can specify the page number, a cryptocurrency symbol (e.g., BTCUSD), a date range (from and to),
            and a limit on the number of articles to return. If no API key is provided, the function attempts to retrieve
            it using Get-FMPCredential and will prompt the user if necessary.

        .PARAMETER Page
            The page number for pagination. Example: 0

        .PARAMETER Symbol
            The cryptocurrency symbol to filter news articles. Example: BTCUSD

        .PARAMETER From
            The start date for news retrieval in the format YYYY-MM-DD. Example: 2024-01-01

        .PARAMETER To
            The end date for news retrieval in the format YYYY-MM-DD. Example: 2024-03-01

        .PARAMETER Limit
            The maximum number of articles to return. Example: 50

        .PARAMETER ApiKey
            Your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it using Get-FMPCredential.

        .PARAMETER BaseUrl
            The base URL for the Financial Modeling Prep API. Defaults to "https://financialmodelingprep.com/api/v4".

        .EXAMPLE
            Get-FMPCryptoNews -Page 0 -Symbol BTCUSD -From "2024-01-01" -To "2024-03-01" -Limit 50

            Retrieves the first 50 crypto news articles for BTCUSD published between January 1, 2024 and March 1, 2024.

        .NOTES
            This is a premium endpoint, and requires a paid subscription. This function uses the endpoint:
            https://financialmodelingprep.com/api/v4/crypto_news?page=0&symbol=BTCUSD&from=2024-01-01&to=2024-03-01&limit=50&apikey=YOUR_API_KEY
            For additional details, see the Financial Modeling Prep documentation.
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $false)]
        [int]$Page = 0,

        [Parameter(Mandatory = $true)]
        [string]$Symbol,

        [Parameter(Mandatory = $false)]
        [datetime]$FromDate = (Get-Date).AddDays(-7),

        [Parameter(Mandatory = $false)]
        [datetime]$ToDate = (Get-Date),

        [Parameter(Mandatory = $false)]
        [int]$Limit = 50,

        [Parameter(Mandatory = $false)]
        [string]$ApiKey = (Get-FMPCredential),

        [Parameter(Mandatory = $false)]
        [string]$BaseUrl = "https://financialmodelingprep.com/api/v4"
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }
    }

    Process {
        # Construct the full URL with query parameters.
        $url = "$BaseUrl/crypto_news?page=$Page&symbol=$Symbol&from={0}&to={1}&limit=$Limit&apikey=$ApiKey" -f $FromDate.ToString("yyyy-MM-dd"), $ToDate.ToString("yyyy-MM-dd")

        # Prepare the required header.
        $headers = @{
            "Upgrade-Insecure-Requests" = "1"
        }

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving FMP crypto news: $_"
        }
    }
 
 };


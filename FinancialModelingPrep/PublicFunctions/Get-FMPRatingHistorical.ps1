function Get-FMPRatingHistorical { 
 

    <#
        .SYNOPSIS
            Retrieves historical financial ratings data for a specified stock symbol using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPRatingHistorical function fetches historical financial ratings information, including key financial metric scores
            for specific dates, for a given stock symbol. This allows users to track changes in a company's financial performance over time.
            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential function and prompts the user if necessary.

        .PARAMETER Symbol
            Specifies the stock symbol for which to retrieve historical ratings (e.g., AAPL). This parameter is mandatory.

        .PARAMETER Limit
            Specifies the maximum number of results to return. The default value is 1. This parameter is optional.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it using the Get-FMPCredential function.

        .EXAMPLE
            Get-FMPRatingHistorical -Symbol AAPL -Limit 1

            This example retrieves the historical financial ratings for Apple Inc. with a result limit of 1.

        .NOTES
            This function uses the Financial Modeling Prep API's Historical Ratings endpoint.
            For more information, visit: https://financialmodelingprep.com
    #>

    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true)]
        [string] $Symbol,

        [Parameter(Mandatory = $false)]
        [int] $Limit = 1,

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/stable/ratings-historical"
    }

    Process {
        $url = "{0}?symbol={1}&limit={2}&apikey={3}" -f $baseUrl, $Symbol, $Limit, $ApiKey

        $headers = @{
            "Upgrade-Insecure-Requests" = "1"
        }

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving historical ratings data: $_"
        }
    }
 
 };


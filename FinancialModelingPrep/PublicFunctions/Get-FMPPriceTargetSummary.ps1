function Get-FMPPriceTargetSummary { 
 

    <#
        .SYNOPSIS
            Retrieves price target summary data for a specified stock symbol using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPPriceTargetSummary function fetches average price target data from industry analysts for various timeframes.
            It provides insights such as the average price targets for the last month, quarter, year, and all-time,
            along with the count of estimates and the list of publishers.
            This data can help investors assess future stock performance based on expert opinions.
            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential function and prompts the user if necessary.

        .PARAMETER Symbol
            Specifies the stock symbol for which the price target summary is to be retrieved (e.g., AAPL). This parameter is mandatory.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it using Get-FMPCredential.

        .EXAMPLE
            Get-FMPPriceTargetSummary -Symbol AAPL

            This example retrieves the price target summary data for Apple Inc. using your Financial Modeling Prep API key.

        .NOTES
            This function utilizes the Financial Modeling Prep API's Price Target Summary endpoint.
            For more information, visit: https://financialmodelingprep.com
    #>

    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true)]
        [string] $Symbol,

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/stable/price-target-summary"
    }

    Process {
        $url = "{0}?symbol={1}&apikey={2}" -f $baseUrl, $Symbol, $ApiKey

        $headers = @{
            "Upgrade-Insecure-Requests" = "1"
        }

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving FMP price target summary data: $_"
        }
    }
 
 };


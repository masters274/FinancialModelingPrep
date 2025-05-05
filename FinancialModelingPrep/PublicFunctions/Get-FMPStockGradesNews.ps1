function Get-FMPStockGradesNews { 
 

    <#
        .SYNOPSIS
            Retrieves an overall summary of analyst ratings for a specified stock symbol using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPStockGradesNews function fetches a consolidated summary of market sentiment for a given stock symbol.
            This summary includes the total number of strong buy, buy, hold, sell, and strong sell ratings, along with the overall consensus.
            This consolidated view helps investors understand how experts evaluate the company's outlook.
            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential function and prompts the user if necessary.

        .PARAMETER Symbol
            Specifies the stock symbol for which the grades summary is to be retrieved (e.g., AAPL). This parameter is mandatory.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it using the Get-FMPCredential function.

        .EXAMPLE
            Get-FMPStockGradesNews -Symbol AAPL

            This example retrieves the stock grades summary for Apple Inc. using your Financial Modeling Prep API key.

        .NOTES
            This function utilizes the Financial Modeling Prep API's Grades Consensus endpoint.
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
        $baseUrl = "https://financialmodelingprep.com/stable/grades-consensus"
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
            throw "Error retrieving FMP stock grades summary data: $_"
        }
    }
 
 };


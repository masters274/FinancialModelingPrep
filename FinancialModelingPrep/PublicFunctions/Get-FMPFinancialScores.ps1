function Get-FMPFinancialScores { 
 

    <#
        .SYNOPSIS
            Retrieves financial scores and recommendations for a specified stock symbol using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPFinancialScores function fetches comprehensive financial scoring data for a given company,
            including Altman Z-Score, Piotroski Score, and various financial ratios. These scores help assess a company's
            financial stability, investment value, and risk level. Users can specify the limit for the number of
            historical records to retrieve. If no API key is provided, the function attempts to retrieve it using
            the Get-FMPCredential function and prompts the user if necessary.

        .PARAMETER Symbol
            Specifies the stock symbol for which to retrieve financial scores (e.g., AAPL). This parameter is mandatory.

        .PARAMETER Limit
            Specifies the maximum number of historical financial score records to retrieve. The default value is 5.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it using Get-FMPCredential.

        .EXAMPLE
            Get-FMPFinancialScores -Symbol AAPL -Limit 5

            This example retrieves the 5 most recent financial scores for Apple Inc.

        .NOTES
            This function utilizes the Financial Modeling Prep API's Financial Scores endpoint.
            For more information, visit: https://financialmodelingprep.com
    #>

    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true)]
        [string] $Symbol,

        [Parameter(Mandatory = $false)]
        [int] $Limit = 5,

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/stable/financial-scores"
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
            throw "Error retrieving financial scores data: $_"
        }
    }
 
 };


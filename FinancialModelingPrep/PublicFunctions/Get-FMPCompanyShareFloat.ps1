function Get-FMPCompanyShareFloat { 
 

    <#
        .SYNOPSIS
            Retrieves company share float and liquidity data for a specified company using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPCompanyShareFloat function fetches data that provides insights into the liquidity and volatility of a stock.
            It returns details on the free float percentage, float shares, and outstanding shares for the specified company.
            This information is crucial for assessing the investment potential and market behavior of a stock.
            If no API key is provided, the function will attempt to retrieve it using the Get-FMPCredential function and prompt
            the user if necessary.

        .PARAMETER Symbol
            Specifies the trading symbol for the company (e.g., AAPL). This parameter is mandatory.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function will attempt to retrieve it using Get-FMPCredential
            and prompt the user if necessary.

        .EXAMPLE
            Get-FMPCompanyShareFloat -Symbol AAPL

            This example retrieves the share float and liquidity data for Apple Inc. using your Financial Modeling Prep API key.

        .NOTES
            This function utilizes the Financial Modeling Prep API's Share Float and Liquidity endpoint.
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

        $baseUrl = "https://financialmodelingprep.com/stable/shares-float"
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
            throw "Error retrieving FMP company share float data: $_"
        }
    }
 
 };


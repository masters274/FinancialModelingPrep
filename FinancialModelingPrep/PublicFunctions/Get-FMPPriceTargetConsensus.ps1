function Get-FMPPriceTargetConsensus { 
 

    <#
        .SYNOPSIS
            Retrieves analysts' consensus price target data for a specified stock symbol using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPPriceTargetConsensus function fetches the high, low, median, and consensus price targets for a given stock symbol.
            This API provides a comprehensive view of market expectations for future stock prices based on analysts' forecasts.
            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential function and will prompt the user if necessary.

        .PARAMETER Symbol
            Specifies the stock symbol for which the price target consensus data is to be retrieved (e.g., AAPL). This parameter is mandatory.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it using Get-FMPCredential.

        .EXAMPLE
            Get-FMPPriceTargetConsensus -Symbol AAPL

            This example retrieves the price target consensus data for Apple Inc. using your Financial Modeling Prep API key.

        .NOTES
            This function utilizes the Financial Modeling Prep API's Price Target Consensus endpoint.
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
        $baseUrl = "https://financialmodelingprep.com/stable/price-target-consensus"
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
            throw "Error retrieving FMP price target consensus data: $_"
        }
    }
 
 };


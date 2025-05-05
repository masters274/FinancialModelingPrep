function Get-FMPTopTradedStocks { 
 

    <#
        .SYNOPSIS
            Retrieves a list of the most actively traded stocks in the market.

        .DESCRIPTION
            The Get-FMPTopTradedStocks function fetches data for stocks with the highest trading volume
            in the most recent trading session. This information is valuable for identifying stocks
            with significant market interest, liquidity, and potential price momentum.

            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential
            function and prompts the user if necessary.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it
            using Get-FMPCredential.

        .EXAMPLE
            Get-FMPTopTradedStocks

            Returns the list of most actively traded stocks in the most recent trading session.

        .NOTES
            This function uses the Financial Modeling Prep API's Most Active endpoint.
            For more information, visit:
            https://site.financialmodelingprep.com/developer/docs/stable/most-active
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }
        # Base URL for the endpoint
        $baseUrl = "https://financialmodelingprep.com/api/v3/stock_market/actives"
    }

    Process {
        $headers = @{
            "Upgrade-Insecure-Requests" = "1"
        }

        try {
            $url = "{0}?apikey={1}" -f $baseUrl, $ApiKey
            $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving most active stocks data: $_"
        }
    }
 
 };


function Get-FMPExchangeGlobalMarketHours { 
 

    <#
        .SYNOPSIS
            Retrieves current market hours and status for various stock exchanges using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPExchangeGlobalMarketHours function fetches information about the trading hours and current status
            of stock exchanges around the world. This data includes whether markets are currently open or closed,
            the local time at the exchange, and the schedule for regular trading sessions, pre-market, and after-hours trading.

            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential
            function and will prompt the user if necessary.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it
            using Get-FMPCredential.

        .EXAMPLE
            Get-FMPExchangeGlobalMarketHours

            Retrieves the current market hours and status for all available exchanges.

        .NOTES
            This function uses the Financial Modeling Prep API's Exchange Market Hours endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/exchange-market-hours
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
        $baseUrl = "https://financialmodelingprep.com/api/v3/market-hours"
    }

    Process {
        $url = "{0}?apikey={1}" -f $baseUrl, $ApiKey

        $headers = @{
            "Upgrade-Insecure-Requests" = "1"
        }

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving exchange market hours data: $_"
        }
    }
 
 };


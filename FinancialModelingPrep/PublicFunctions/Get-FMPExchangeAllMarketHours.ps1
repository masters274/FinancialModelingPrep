function Get-FMPExchangeAllMarketHours { 
 

    <#
        .SYNOPSIS
            Retrieves comprehensive market hours and status information for all global stock exchanges.

        .DESCRIPTION
            The Get-FMPExchangeAllMarketHours function fetches detailed information about the trading hours and current status
            of all global stock exchanges in a single request. This data includes whether markets are currently open or closed,
            the local time at each exchange, and the schedule for regular trading sessions, pre-market, and after-hours trading.

            The data is returned in a structured format that makes it easy to compare market hours across different exchanges.

            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential
            function and will prompt the user if necessary.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it
            using Get-FMPCredential.

        .EXAMPLE
            Get-FMPExchangeAllMarketHours

            Retrieves comprehensive market hours and status information for all global stock exchanges.

        .NOTES
            This function uses the Financial Modeling Prep API's All Exchange Market Hours endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/all-exchange-market-hours
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
        $baseUrl = "https://financialmodelingprep.com/stable/all-exchange-market-hours"
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
            throw "Error retrieving all exchange market hours data: $_"
        }
    }
 
 };


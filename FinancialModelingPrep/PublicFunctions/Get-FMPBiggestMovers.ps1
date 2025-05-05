function Get-FMPBiggestMovers { 
 

    <#
        .SYNOPSIS
            Retrieves a list of stocks with the biggest percentage movements (gains or losses) in the market.

        .DESCRIPTION
            The Get-FMPBiggestMovers function fetches data for stocks that have experienced the
            largest percentage price increases or decreases in the most recent trading session.
            This information is valuable for momentum traders, identifying potential breakout or breakdown
            candidates, and understanding which sectors are seeing significant price action.

            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential
            function and prompts the user if necessary.

        .PARAMETER Direction
            Specifies which type of movers to retrieve: "Gainers", "Losers", or "Both".
            Default is "Both".

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it
            using Get-FMPCredential.

        .EXAMPLE
            Get-FMPBiggestMovers

            Returns the list of stocks with the biggest percentage gains and losses in the most recent trading session.

        .EXAMPLE
            Get-FMPBiggestMovers -Direction Gainers

            Returns only the list of stocks with the biggest percentage gains in the most recent trading session.

        .NOTES
            This function uses the Financial Modeling Prep API's Biggest Gainers and Biggest Losers endpoints.
            For more information, visit:
            https://site.financialmodelingprep.com/developer/docs/stable/biggest-gainers
            https://site.financialmodelingprep.com/developer/docs/stable/biggest-losers
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $false)]
        [ValidateSet("Gainers", "Losers", "Both")]
        [string] $Direction = "Both",

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }
        # Base URLs for the endpoints
        $gainersUrl = "https://financialmodelingprep.com/api/v3/stock_market/gainers"
        $losersUrl = "https://financialmodelingprep.com/api/v3/stock_market/losers"
    }

    Process {
        $headers = @{
            "Upgrade-Insecure-Requests" = "1"
        }

        $result = @()

        try {
            # Get gainers if requested
            if ($Direction -eq "Gainers" -or $Direction -eq "Both") {
                $url = "{0}?apikey={1}" -f $gainersUrl, $ApiKey
                $gainers = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
                $result += $gainers
            }

            # Get losers if requested
            if ($Direction -eq "Losers" -or $Direction -eq "Both") {
                $url = "{0}?apikey={1}" -f $losersUrl, $ApiKey
                $losers = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
                $result += $losers
            }

            return $result
        }
        catch {
            throw "Error retrieving biggest movers data: $_"
        }
    }
 
 };


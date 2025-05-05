function Get-FMPActivelyTradingList { 
 

    <#
        .SYNOPSIS
            Retrieves a list of stocks that are actively trading using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPActivelyTradingList function fetches data about stocks that are currently experiencing
            significant trading activity. This information helps investors identify securities with high market
            interest, unusual volume, or price movements that may present trading opportunities.
            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential
            function and will prompt the user if necessary.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it
            using Get-FMPCredential.

        .EXAMPLE
            Get-FMPActivelyTradingList

            Retrieves the complete list of actively trading stocks.

        .NOTES
            This function uses the Financial Modeling Prep API's Actively Trading List endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/actively-trading-list
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
        $baseUrl = "https://financialmodelingprep.com/stable/actively-trading-list"
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
            throw "Error retrieving actively trading list: $_"
        }
    }
 
 };


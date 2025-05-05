function Get-FMPInsiderTradeStatistics { 
 

    <#
        .SYNOPSIS
            Retrieves insider trade statistics for a specified company using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPInsiderTradeStatistics function fetches comprehensive statistical data about
            insider trading activities for a given company based on its stock symbol. This includes
            data about buying and selling patterns, transaction volumes, and other metrics that help
            investors understand insider sentiment and activity.

            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential
            function and prompts the user if necessary.

        .PARAMETER Symbol
            Specifies the stock symbol for which to retrieve insider trade statistics (e.g., AAPL).
            This parameter is mandatory.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts
            to retrieve it using Get-FMPCredential.

        .EXAMPLE
            Get-FMPInsiderTradeStatistics -Symbol AAPL

            Retrieves insider trading statistics for Apple Inc.

        .NOTES
            This is a premium endpoint, and requires a paid subscription.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/insider-trade-statistics
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
        $baseUrl = "https://financialmodelingprep.com/stable/insider-trading/statistics"
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
            throw "Error retrieving insider trade statistics: $_"
        }
    }
 
 };


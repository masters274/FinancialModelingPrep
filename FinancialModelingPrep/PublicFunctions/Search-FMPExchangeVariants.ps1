function Search-FMPExchangeVariants { 
 

    <#
        .SYNOPSIS
            Searches across multiple public exchanges to find where a given stock symbol is listed using the Financial Modeling Prep API.

        .DESCRIPTION
            The Search-FMPExchangeVariants function retrieves detailed information about the exchanges where a specific stock symbol is actively traded.
            This endpoint provides comprehensive data including pricing, beta, market capitalization, company details, and other related information.
            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential function and will prompt the user if necessary.

        .PARAMETER Symbol
            Specifies the stock symbol to search for (e.g., "AAPL"). This parameter is mandatory.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it using the Get-FMPCredential
            function and will prompt the user if necessary.

        .EXAMPLE
            Search-FMPExchangeVariants -Symbol AAPL

            This example retrieves exchange variants data for the stock symbol AAPL.

        .NOTES
            This is a premium endpoint, and requires a paid subscription. This function uses the Financial Modeling Prep API's Exchange Variants endpoint.
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
        $baseUrl = "https://financialmodelingprep.com/stable/search-exchange-variants"
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
            throw "Error retrieving exchange variants data: $_"
        }
    }
 
 };


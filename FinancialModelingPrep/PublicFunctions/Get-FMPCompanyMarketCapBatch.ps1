function Get-FMPCompanyMarketCapBatch { 
 

    <#
        .SYNOPSIS
            Retrieves market capitalization data for multiple companies in a single request using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPCompanyMarketCapBatch function fetches market capitalization details for a list of companies simultaneously.
            This API endpoint allows users to compare the market sizes and overall valuations of various companies at once.
            The returned data includes the company symbol, the date of the market capitalization value, and the market cap.
            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential function and will prompt
            the user if necessary.

        .PARAMETER Symbols
            Specifies the list of trading symbols for the companies (e.g., AAPL, MSFT, GOOG). This parameter is mandatory.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function will attempt to retrieve it using Get-FMPCredential
            and prompt the user if necessary.

        .EXAMPLE
            Get-FMPCompanyMarketCapBatch -Symbols AAPL, MSFT

            This example retrieves the market capitalization data for Apple Inc., Microsoft Corporation, and Alphabet Inc.
            using your Financial Modeling Prep API key.

        .NOTES
            This function utilizes the Financial Modeling Prep API's Batch Market Capitalization endpoint.
            For more information, visit: https://financialmodelingprep.com
    #>

    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true)]
        [string[]] $Symbols,

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }

        $baseUrl = "https://financialmodelingprep.com/stable/market-capitalization-batch"
    }

    Process {
        $joinedSymbols = $Symbols -join ","
        $url = "{0}?symbols={1}&apikey={2}" -f $baseUrl, $joinedSymbols, $ApiKey

        $headers = @{
            "Upgrade-Insecure-Requests" = "1"
        }

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving batch market capitalization data: $_"
        }
    }
 
 };


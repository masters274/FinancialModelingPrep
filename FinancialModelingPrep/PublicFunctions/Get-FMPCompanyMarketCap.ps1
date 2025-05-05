function Get-FMPCompanyMarketCap { 
 

    <#
        .SYNOPSIS
            Retrieves the market capitalization for a specified company on a given date using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPCompanyMarketCap function fetches the market capitalization data for a given trading symbol on a specific date.
            This data is essential for assessing a company's size and market value. The API returns the company symbol, the date,
            and the market capitalization figure. If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential
            function and will prompt the user if necessary.

        .PARAMETER Symbol
            Specifies the trading symbol for the company (e.g., AAPL). This parameter is mandatory.

        .PARAMETER Date
            Specifies the date for which the market capitalization data should be retrieved.
            The date must be a [datetime] object. Only the date portion is used, and the default value is today's date.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function will attempt to retrieve it using Get-FMPCredential
            and prompt the user if necessary.

        .EXAMPLE
            Get-FMPCompanyMarketCap -Symbol AAPL -Date (Get-Date).AddDays(-1)

            This example retrieves the market capitalization data for Apple Inc. for yesterday's date using your Financial Modeling Prep API key.

        .NOTES
            This function utilizes the Financial Modeling Prep API's Market Capitalization endpoint.
            For more information, visit: https://financialmodelingprep.com
    #>

    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true)]
        [string] $Symbol,

        [Parameter(Mandatory = $false)]
        [datetime] $Date = (Get-Date),

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }

        $baseUrl = "https://financialmodelingprep.com/stable/market-capitalization"
    }

    Process {
        $formattedDate = $Date.ToString("yyyy-MM-dd")
        $url = "{0}?symbol={1}&date={2}&apikey={3}" -f $baseUrl, $Symbol, $formattedDate, $ApiKey

        $headers = @{
            "Upgrade-Insecure-Requests" = "1"
        }

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving FMP market capitalization data: $_"
        }
    }
 
 };


function Get-FMPStockSplitDetails { 
 

    <#
        .SYNOPSIS
            Retrieves detailed stock split information for a specified stock symbol using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPStockSplitDetails function fetches data on stock splits for a given company, including the split date
            and the split ratio (numerator and denominator). This information helps users understand changes in a company's
            share structure after a stock split. If no API key is provided, the function attempts to retrieve it using the
            Get-FMPCredential function and prompts the user if necessary.

        .PARAMETER Symbol
            Specifies the stock symbol for which the stock split details are to be retrieved (e.g., AAPL). This parameter is mandatory.

        .PARAMETER Limit
            Specifies the maximum number of stock split records to return. The default value is 5, which is the max for the free version.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it using Get-FMPCredential.

        .EXAMPLE
            Get-FMPStockSplitDetails -Symbol AAPL -Limit 5

            This example retrieves up to 100 stock split records for Apple Inc. using your Financial Modeling Prep API key.

        .NOTES
            This function utilizes the Financial Modeling Prep API's Stock Split Details endpoint.
            For more information, visit: https://financialmodelingprep.com
    #>

    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true)]
        [string] $Symbol,

        [Parameter(Mandatory = $false)]
        [int] $Limit = 5,

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/stable/splits"
    }

    Process {
        $url = "{0}?symbol={1}&limit={2}&apikey={3}" -f $baseUrl, $Symbol, $Limit, $ApiKey

        $headers = @{
            "Upgrade-Insecure-Requests" = "1"
        }

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving stock split details: $_"
        }
    }
 
 };


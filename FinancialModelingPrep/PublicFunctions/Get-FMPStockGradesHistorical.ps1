function Get-FMPStockGradesHistorical { 
 

    <#
        .SYNOPSIS
            Retrieves a comprehensive record of historical analyst grades for a specified stock symbol using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPStockGradesHistorical function fetches historical changes in analyst ratings for a given stock symbol.
            This data includes key metrics such as the number of buy, hold, sell, and strong sell recommendations over time.
            It allows investors to track how analyst sentiments have evolved. If no API key is provided, the function attempts to retrieve it
            using the Get-FMPCredential function and prompts the user if necessary.

        .PARAMETER Symbol
            Specifies the stock symbol for which historical analyst grades are to be retrieved (e.g., AAPL). This parameter is mandatory.

        .PARAMETER Limit
            Specifies the maximum number of records to retrieve. The default value is 100. This parameter is optional.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it using Get-FMPCredential.

        .EXAMPLE
            Get-FMPStockGradesHistorical -Symbol AAPL -Limit 10

            This example retrieves up to 100 historical records of analyst grades for Apple Inc. using your Financial Modeling Prep API key.

        .NOTES
            This function utilizes the Financial Modeling Prep API's Historical Grades endpoint.
            For more information, visit: https://financialmodelingprep.com
    #>

    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true)]
        [string] $Symbol,

        [Parameter(Mandatory = $false)]
        [int] $Limit = 10,

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/stable/grades-historical"
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
            throw "Error retrieving historical stock grades data: $_"
        }
    }
 
 };


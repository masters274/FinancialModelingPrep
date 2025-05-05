function Get-FMPETFHoldings { 
 

    <#
        .SYNOPSIS
            Retrieves the holdings data for a specified ETF using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPETFHoldings function fetches detailed holdings information for a given ETF based on its symbol.
            This includes data about the individual assets comprising the ETF, their weightings, and other key metrics.
            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential function
            and will prompt the user if necessary.

        .PARAMETER Symbol
            Specifies the ETF symbol (e.g., SPY, QQQ). This parameter is mandatory.

        .PARAMETER Date
            (Optional) Specifies a specific date for which to retrieve holdings data.
            The date must be a [datetime] object. If omitted, returns the most recent holdings data.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it
            using Get-FMPCredential.

        .EXAMPLE
            Get-FMPETFHoldings -Symbol SPY

            Retrieves the current holdings for the SPDR S&P 500 ETF.

        .EXAMPLE
            Get-FMPETFHoldings -Symbol QQQ -Date (Get-Date "2025-01-15")

            Retrieves the holdings for the Invesco QQQ Trust as of January 15, 2025.

        .NOTES
            This is a premium endpoint, and requires a paid subscription. This function uses the Financial Modeling Prep API's ETF Holdings endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/holdings
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [string] $Symbol,

        [Parameter(Mandatory = $false)]
        [datetime] $Date,

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/stable/etf/holdings"
    }

    Process {
        $queryParams = @{ symbol = $Symbol; apikey = $ApiKey }
        if ($Date) { $queryParams.date = $Date.ToString("yyyy-MM-dd") }
        $queryString = ($queryParams.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" }) -join "&"
        $url = "{0}?{1}" -f $baseUrl, $queryString

        $headers = @{
            "Upgrade-Insecure-Requests" = "1"
        }

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving ETF holdings data: $_"
        }
    }
 
 };


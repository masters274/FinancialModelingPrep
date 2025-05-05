function Get-FMPLatestFundDisclosures { 
 

    <#
        .SYNOPSIS
            Retrieves the latest disclosures for ETFs and mutual funds.

        .DESCRIPTION
            The Get-FMPLatestFundDisclosures function fetches the most recent disclosure filings for a specific
            ETF or mutual fund based on its symbol. These disclosures provide important information about fund
            holdings and other regulatory information.

            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential function
            and will prompt the user if necessary.

        .PARAMETER Symbol
            Specifies the stock symbol for the fund (e.g., "AAPL"). This parameter is mandatory.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it
            using Get-FMPCredential.

        .EXAMPLE
            Get-FMPLatestFundDisclosures -Symbol "AAPL"

            Retrieves the latest fund disclosures for Apple Inc.

        .NOTES
            This is a premium endpoint, and requires a paid subscription. This function uses the Financial Modeling Prep API's Latest Disclosures endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/latest-disclosures
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
        $baseUrl = "https://financialmodelingprep.com/stable/funds/disclosure-holders-latest"
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
            throw "Error retrieving latest fund disclosures: $_"
        }
    }
 
 };


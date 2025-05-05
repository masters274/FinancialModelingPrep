function Get-FMPMutualFundDisclosures { 
 

    <#
        .SYNOPSIS
            Retrieves mutual fund disclosure data for a specified fund.

        .DESCRIPTION
            The Get-FMPMutualFundDisclosures function fetches disclosure data for a specific mutual fund
            or ETF based on its symbol, year, and quarter. These disclosures provide important information
            about the fund's holdings and other regulatory information.

            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential function
            and will prompt the user if necessary.

        .PARAMETER Symbol
            Specifies the symbol for the mutual fund or ETF (e.g., "VWO"). This parameter is mandatory.

        .PARAMETER Year
            Specifies the year for which to retrieve disclosure data (e.g., 2023). This parameter is mandatory.

        .PARAMETER Quarter
            Specifies the quarter for which to retrieve disclosure data (1-4). This parameter is mandatory.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it
            using Get-FMPCredential.

        .EXAMPLE
            Get-FMPMutualFundDisclosures -Symbol VWO -Year 2023 -Quarter 4

            Retrieves the disclosures for Vanguard FTSE Emerging Markets ETF for Q4 2023.

        .NOTES
            This is a premium endpoint, and requires a paid subscription. This function uses the Financial Modeling Prep API's Mutual Fund Disclosures endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/mutual-fund-disclosures
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [string] $Symbol,

        [Parameter(Mandatory = $true)]
        [int] $Year,

        [Parameter(Mandatory = $true)]
        [ValidateRange(1, 4)]
        [int] $Quarter,

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/stable/funds/disclosure"
    }

    Process {
        $url = "{0}?symbol={1}&year={2}&quarter={3}&apikey={4}" -f $baseUrl, $Symbol, $Year, $Quarter, $ApiKey

        $headers = @{
            "Upgrade-Insecure-Requests" = "1"
        }

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving mutual fund disclosures: $_"
        }
    }
 
 };


function Get-FMPETFCountryWeighting { 
 

    <#
        .SYNOPSIS
            Retrieves the country allocation weightings for a specified ETF.

        .DESCRIPTION
            The Get-FMPETFCountryWeighting function fetches detailed information about a given ETF's
            geographic exposure, showing how the fund's assets are allocated across different countries.
            This helps investors understand the geographic diversification of their ETF investments.

            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential function
            and will prompt the user if necessary.

        .PARAMETER Symbol
            Specifies the ETF symbol (e.g., SPY, VXUS). This parameter is mandatory.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it
            using Get-FMPCredential.

        .EXAMPLE
            Get-FMPETFCountryWeighting -Symbol VXUS

            Retrieves the country allocation for the Vanguard Total International Stock ETF.

        .NOTES
            This is a premium endpoint, and requires a paid subscription. This function uses the Financial Modeling Prep API's ETF Country Weighting endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/country-weighting
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
        $baseUrl = "https://financialmodelingprep.com/stable/etf/country-weightings"
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
            throw "Error retrieving ETF country weightings: $_"
        }
    }
 
 };


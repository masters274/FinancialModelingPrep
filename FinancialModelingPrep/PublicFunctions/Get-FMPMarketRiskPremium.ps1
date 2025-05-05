function Get-FMPMarketRiskPremium { 
 

    <#
        .SYNOPSIS
            Retrieves the market risk premium data using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPMarketRiskPremium function accesses the FMP Market Risk Premium API to fetch key financial metrics,
            including the country risk premium and the total equity risk premium. This information is useful for assessing
            the additional return expected from investing in the stock market over a risk-free investment.
            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential function and prompts
            the user if necessary.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it using the
            Get-FMPCredential function.

        .EXAMPLE
            Get-FMPMarketRiskPremium

            This example retrieves market risk premium data using your Financial Modeling Prep API key.

        .NOTES
            This function utilizes the FMP Market Risk Premium API endpoint.
            For more details, visit: https://financialmodelingprep.com
    #>

    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/stable/market-risk-premium"
    }

    Process {
        $url = "{0}?apikey={1}" -f $baseUrl, $ApiKey

        $headers = @{
            "Upgrade-Insecure-Requests" = "1"
        }

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving market risk premium data: $_"
        }
    }
 
 };


function Get-FMPDCFValuation { 
 

    <#
        .SYNOPSIS
            Estimates the intrinsic value of a company using the Discounted Cash Flow (DCF) valuation model via the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPDCFValuation function calculates the DCF valuation for a given company based on its expected future cash flows
            and discount rates. It retrieves the DCF value along with the current stock price for the specified stock symbol.
            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential function and prompts the user if necessary.

        .PARAMETER Symbol
            Specifies the stock symbol for which to retrieve the DCF valuation (e.g., AAPL). This parameter is mandatory.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it using the Get-FMPCredential function.

        .EXAMPLE
            Get-FMPDCFValuation -Symbol AAPL

            This example retrieves the DCF valuation data for Apple Inc. using your Financial Modeling Prep API key.

        .NOTES
            This function utilizes the Financial Modeling Prep Discounted Cash Flow Valuation API endpoint.
            For additional details, visit: https://financialmodelingprep.com
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
        $baseUrl = "https://financialmodelingprep.com/stable/discounted-cash-flow"
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
            throw "Error retrieving DCF valuation data: $_"
        }
    }
 
 };


function Get-FMPDCFLevered { 
 

    <#
        .SYNOPSIS
            Retrieves the levered DCF valuation for a specified stock symbol using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPDCFLevered function analyzes a company?s value while taking into account its debt obligations
            through a levered Discounted Cash Flow (DCF) model. This API provides a post-debt valuation, offering investors
            a more accurate measure of a company's true worth. If no API key is provided, the function attempts to retrieve
            it using the Get-FMPCredential function and will prompt the user if necessary.

        .PARAMETER Symbol
            Specifies the stock symbol for which the levered DCF valuation is to be retrieved (e.g., AAPL). This parameter is mandatory.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it using Get-FMPCredential.

        .EXAMPLE
            Get-FMPDCFLevered -Symbol AAPL

            This example retrieves the levered DCF valuation data for Apple Inc. using your Financial Modeling Prep API key.

        .NOTES
            This function uses the Financial Modeling Prep Levered Discounted Cash Flow API endpoint.
            For more information, visit: https://financialmodelingprep.com
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
        $baseUrl = "https://financialmodelingprep.com/stable/levered-discounted-cash-flow"
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
            throw "Error retrieving levered DCF valuation data: $_"
        }
    }
 
 };


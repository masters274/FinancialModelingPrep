function Get-FMPCompanyNote { 
 

    <#
        .SYNOPSIS
            Retrieves detailed company notes data for a specified trading symbol using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPCompanyNote function fetches detailed information about company-issued notes for a given company based on its trading symbol.
            The output includes essential data such as the CIK number, stock symbol, note title, and the exchange where the notes are listed.
            If no API key is provided, the function will attempt to retrieve it using the Get-FMPCredential function and prompt the user if necessary.

        .PARAMETER Symbol
            Specifies the trading symbol for the company (e.g., AAPL). This parameter is mandatory.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function will attempt to retrieve it using Get-FMPCredential and prompt the user if necessary.

        .EXAMPLE
            Get-FMPCompanyNote -Symbol AAPL

            This example retrieves the company notes for Apple Inc. using your Financial Modeling Prep API key.

        .NOTES
            This function uses the Financial Modeling Prep Company's Notes API endpoint.
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

        $baseUrl = "https://financialmodelingprep.com/stable/company-notes"
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
            throw "Error retrieving FMP company notes data: $_"
        }
    }
 
 };


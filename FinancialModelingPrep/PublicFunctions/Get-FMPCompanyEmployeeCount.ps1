function Get-FMPCompanyEmployeeCount { 
 

    <#
        .SYNOPSIS
            Retrieves detailed company workforce information using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPCompanyEmployeeCount function fetches data regarding a company's employee count, reporting period,
            filing date, and provides direct links to the official SEC documents for further verification and in-depth research.
            This information helps track company workforce trends and validate official filings. If no API key is provided,
            the function attempts to retrieve it using the Get-FMPCredential function and will prompt the user if necessary.

        .PARAMETER Symbol
            Specifies the trading symbol for the company (e.g., AAPL). This parameter is mandatory.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function will attempt to retrieve it using Get-FMPCredential
            and prompt the user if necessary.

        .EXAMPLE
            Get-FMPCompanyEmployeeCount -Symbol AAPL

            This example retrieves the employee count and associated workforce details for Apple Inc. using your Financial Modeling Prep API key.

        .NOTES
            This function utilizes the Financial Modeling Prep API's Employee Count endpoint.
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

        $baseUrl = "https://financialmodelingprep.com/stable/employee-count"
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
            throw "Error retrieving FMP company employee count data: $_"
        }
    }
 
 };


function Get-FMPCompanyEmployeeCountHistorical { 
 

    <#
        .SYNOPSIS
            Retrieves historical employee count data for a specified trading symbol using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPCompanyEmployeeCountHistorical function fetches historical workforce data for a given company over multiple
            reporting periods. This information helps in analyzing how a company?s employee count has evolved over time,
            providing insights into growth trends and operational changes. The output includes details such as the trading symbol,
            CIK, acceptance time, reporting period, company name, form type, filing date, employee count, and the source link to
            the official SEC document. If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential
            function and will prompt the user if necessary.

        .PARAMETER Symbol
            Specifies the trading symbol for the company (e.g., AAPL). This parameter is mandatory.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function will attempt to retrieve it using Get-FMPCredential
            and prompt the user if necessary.

        .EXAMPLE
            Get-FMPCompanyEmployeeCountHistorical -Symbol AAPL

            This example retrieves the historical employee count data for Apple Inc. using your Financial Modeling Prep API key.

        .NOTES
            This function utilizes the Financial Modeling Prep API's Historical Employee Count endpoint.
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

        $baseUrl = "https://financialmodelingprep.com/stable/historical-employee-count"
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
            throw "Error retrieving FMP historical employee count data: $_"
        }
    }
 
 };


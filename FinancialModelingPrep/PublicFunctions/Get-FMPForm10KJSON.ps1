function Get-FMPForm10KJSON { 
 

    <#
        .SYNOPSIS
            Retrieves the annual Form 10-K financial report in JSON format using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPForm10KJSON function fetches the comprehensive annual Form 10-K report for a specified company.
            This report provides detailed information about the company's financial performance, business operations,
            and risk factors as disclosed in its SEC filings. The function requires a stock ticker symbol and the fiscal
            year as mandatory parameters. An optional Period parameter is available, which defaults to "FY" for full-year reports.
            If an API key is not provided, the function will attempt to retrieve it using Get-FMPCredential and prompt the user if necessary.

        .PARAMETER Symbol
            Specifies the stock ticker symbol of the company (e.g., AAPL). This parameter is mandatory.

        .PARAMETER Year
            Specifies the fiscal year for which to retrieve the Form 10-K report (e.g., 2022). This parameter is mandatory.

        .PARAMETER Period
            Specifies the type of period for the report. Valid values are "FY", "Q1", "Q2", "Q3", "Q4". The default value is "FY".

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function will attempt to retrieve it using Get-FMPCredential.

        .EXAMPLE
            Get-FMPForm10KJSON -Symbol AAPL -Year 2022

            This example retrieves the annual Form 10-K report for Apple Inc. for the fiscal year 2022.

        .NOTES
            This function uses the Financial Reports Form 10-K JSON API endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/financial-reports-form-10-k-json
    #>

    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true)]
        [string] $Symbol,

        [Parameter(Mandatory = $true)]
        [int] $Year,

        [Parameter(Mandatory = $false)]
        [ValidateSet("FY", "Q1", "Q2", "Q3", "Q4")]
        [string] $Period = "FY",

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/stable/financial-reports-json"
    }

    Process {
        $url = "{0}?symbol={1}&year={2}&period={3}&apikey={4}" -f $baseUrl, $Symbol, $Year, $Period, $ApiKey

        $headers = @{
            "Upgrade-Insecure-Requests" = "1"
        }

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving Form 10-K data: $_"
        }
    }
 
 };


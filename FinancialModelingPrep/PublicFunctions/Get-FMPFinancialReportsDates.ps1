function Get-FMPFinancialReportsDates { 
 

    <#
        .SYNOPSIS
            Retrieves the dates for which financial statements are available for a specified company.

        .DESCRIPTION
            The Get-FMPFinancialReportsDates function uses the Financial Modeling Prep API to obtain a list of all dates
            on which financial reports have been published for the given company ticker symbol. This data helps you track
            a company's reporting history and identify the available financial statement dates.

        .PARAMETER Symbol
            Specifies the stock ticker symbol of the company (e.g., AAPL).

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function will attempt to retrieve it using Get-FMPCredential.

        .EXAMPLE
            Get-FMPFinancialReportsDates -Symbol AAPL

            This example retrieves the available financial report dates for Apple Inc.

        .NOTES
            This function calls the Financial Reports Dates API endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/financial-reports-dates
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
        $baseUrl = "https://financialmodelingprep.com/stable/financial-reports-dates"
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
            throw "Error retrieving financial reports dates data: $_"
        }
    }
 
 };


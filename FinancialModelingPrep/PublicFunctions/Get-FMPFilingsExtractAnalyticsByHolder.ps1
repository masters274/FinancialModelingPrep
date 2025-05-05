function Get-FMPFilingsExtractAnalyticsByHolder { 
 

    <#
        .SYNOPSIS
            Retrieves filings extract analytics data segmented by institutional holder.

        .DESCRIPTION
            Uses the Financial Modeling Prep API to obtain an analytical breakdown of a company's SEC filings by holder.
            Requires the company's stock ticker, fiscal year, and quarter.

        .PARAMETER Symbol
            The company's stock ticker (e.g., AAPL).

        .PARAMETER Year
            The fiscal year (e.g., 2022).

        .PARAMETER Quarter
            The fiscal quarter for the report. Valid values are "Q1", "Q2", "Q3", and "Q4".

        .PARAMETER ApiKey
            Your Financial Modeling Prep API key. If omitted, the function calls Get-FMPCredential.

        .EXAMPLE
            Get-FMPFilingsExtractAnalyticsByHolder -Symbol AAPL -Year 2024 -Quarter Q1

            Retrieves the filings extract analytics data for Apple Inc. for Q1 2022.

        .NOTES
            This is a premium endpoint, and requires a paid subscription. This function uses the Filings Extract Analytics by Holder API endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/filings-extract-analytics-by-holder
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [string] $Symbol,

        [Parameter(Mandatory = $true)]
        [int] $Year,

        [Parameter(Mandatory = $true)]
        [ValidateSet("Q1", "Q2", "Q3", "Q4")]
        [string] $Quarter,

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/stable/institutional-ownership/extract-analytics/holder"
    }

    Process {
        $url = "{0}?symbol={1}&quarter={2}&year={3}&apikey={4}" -f $baseUrl, $Symbol, $Quarter, $Year, $ApiKey

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving filings extract analytics by holder data: $_"
        }
    }
 
 };


function Get-FMPMetricsRatios { 
 

    <#
        .SYNOPSIS
            Retrieves financial ratios data for a specified company using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPMetricsRatios function fetches comprehensive financial ratios for a given company based on its stock symbol.
            It provides vital financial indicators such as PE Ratio, Price to Sales Ratio, Return on Equity, Debt to Equity,
            Current Ratio, and many other important valuation and performance metrics. Users can specify whether to retrieve
            annual or quarterly ratios and limit the number of results. If no API key is provided, the function attempts to
            retrieve it using the Get-FMPCredential function and prompts the user if necessary.

        .PARAMETER Symbol
            Specifies the stock symbol for which to retrieve financial ratios data (e.g., AAPL). This parameter is mandatory.

        .PARAMETER Period
            Specifies the reporting period type. Valid values are "annual" or "quarter". The default value is "annual".

        .PARAMETER Limit
            Specifies the maximum number of financial ratio records to retrieve. The default value is 5.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it using Get-FMPCredential.

        .EXAMPLE
            Get-FMPMetricsRatios -Symbol AAPL -Period FY -Limit 5

            This example retrieves the 5 most recent annual financial ratios for Apple Inc.

        .EXAMPLE
            Get-FMPMetricsRatios -Symbol MSFT -Period Q1 -Limit 10

            This example retrieves the 10 most recent quarterly financial ratios for Microsoft Corporation.

        .NOTES
            This function utilizes the Financial Modeling Prep API's Financial Ratios endpoint.
            For more information, visit: https://financialmodelingprep.com
    #>

    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true)]
        [string] $Symbol,

        [Parameter(Mandatory = $false)]
        [ValidateSet("Q1", "Q2", "Q3", "Q4", "FY")]
        [string] $Period = "FY",

        [Parameter(Mandatory = $false)]
        [int] $Limit = 5,

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/stable/ratios"
    }

    Process {
        $url = "{0}?symbol={1}&period={2}&limit={3}&apikey={4}" -f $baseUrl, $Symbol, $Period, $Limit, $ApiKey

        $headers = @{
            "Upgrade-Insecure-Requests" = "1"
        }

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving financial ratios data: $_"
        }
    }
 
 };


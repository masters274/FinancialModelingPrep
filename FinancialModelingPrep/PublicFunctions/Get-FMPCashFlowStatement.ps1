function Get-FMPCashFlowStatement { 
 

    <#
        .SYNOPSIS
            Retrieves cash flow statement data for a specified company using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPCashFlowStatement function fetches detailed cash flow statement data for a given company based on its stock symbol.
            It provides comprehensive financial information including operating activities, investing activities, financing activities,
            and net cash flow. Users can specify whether to retrieve annual or quarterly statements and limit the number of results.
            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential function and prompts
            the user if necessary.

        .PARAMETER Symbol
            Specifies the stock symbol for which to retrieve cash flow statement data (e.g., AAPL). This parameter is mandatory.

        .PARAMETER Period
            Specifies the reporting period type. Valid values are "annual" or "quarter". The default value is "annual".

        .PARAMETER Limit
            Specifies the maximum number of cash flow statements to retrieve. The default value is 5.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it using Get-FMPCredential.

        .EXAMPLE
            Get-FMPCashFlowStatement -Symbol AAPL -Period annual -Limit 5

            This example retrieves the 5 most recent annual cash flow statements for Apple Inc.

        .EXAMPLE
            Get-FMPCashFlowStatement -Symbol MSFT -Period quarter -Limit 10

            This example retrieves the 10 most recent quarterly cash flow statements for Microsoft Corporation.

        .NOTES
            This function utilizes the Financial Modeling Prep API's Cash Flow Statement endpoint.
            For more information, visit: https://financialmodelingprep.com
    #>

    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true)]
        [string] $Symbol,

        [Parameter(Mandatory = $false)]
        [ValidateSet("annual", "quarter")]
        [string] $Period = "annual",

        [Parameter(Mandatory = $false)]
        [int] $Limit = 5,

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/stable/cash-flow-statement"
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
            throw "Error retrieving cash flow statement data: $_"
        }
    }
 
 };


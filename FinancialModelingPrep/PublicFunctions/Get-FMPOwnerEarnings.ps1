function Get-FMPOwnerEarnings { 
 

    <#
        .SYNOPSIS
            Retrieves owner earnings data for a specified company using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPOwnerEarnings function fetches owner earnings data as defined by Warren Buffett,
            which provides a more accurate picture of a company's true economic value than standard accounting metrics.
            This includes data such as net income, depreciation and amortization, capital expenditures, and working capital changes.
            Users can specify whether to retrieve annual or quarterly data and limit the number of results.
            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential function and prompts
            the user if necessary.

        .PARAMETER Symbol
            Specifies the stock symbol for which to retrieve owner earnings data (e.g., AAPL). This parameter is mandatory.

        .PARAMETER Period
            Specifies the reporting period type. Valid values are "annual" or "quarter". The default value is "annual".

        .PARAMETER Limit
            Specifies the maximum number of owner earnings records to retrieve. The default value is 5.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it using Get-FMPCredential.

        .EXAMPLE
            Get-FMPOwnerEarnings -Symbol AAPL -Period annual -Limit 5

            This example retrieves the 5 most recent annual owner earnings records for Apple Inc.

        .EXAMPLE
            Get-FMPOwnerEarnings -Symbol MSFT -Period quarter -Limit 10

            This example retrieves the 10 most recent quarterly owner earnings records for Microsoft Corporation.

        .NOTES
            This function utilizes the Financial Modeling Prep API's Owner Earnings endpoint.
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
        $baseUrl = "https://financialmodelingprep.com/stable/owner-earnings"
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
            throw "Error retrieving owner earnings data: $_"
        }
    }
 
 };


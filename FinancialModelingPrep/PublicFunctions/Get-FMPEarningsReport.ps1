function Get-FMPEarningsReport { 
 

    <#
        .SYNOPSIS
            Retrieves in-depth earnings information for a specified stock symbol using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPEarningsReport function fetches key financial data for a given stock symbol, including earnings report dates,
            EPS actual and estimates, revenue actual and estimates, and the last updated timestamp.
            This information helps you stay on top of company performance and earnings trends.
            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential function and will prompt
            the user if necessary.

        .PARAMETER Symbol
            Specifies the stock symbol for which earnings report data should be retrieved (e.g., AAPL). This parameter is mandatory.

        .PARAMETER Limit
            Specifies the maximum number of earnings report records to retrieve. The default value is 5, which is the max for the free version. This parameter is optional.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function will attempt to retrieve it using Get-FMPCredential.

        .EXAMPLE
            Get-FMPEarningsReport -Symbol AAPL -Limit 5

            This example retrieves up to 100 earnings report records for Apple Inc. using your Financial Modeling Prep API key.

        .NOTES
            This function utilizes the Financial Modeling Prep API's Earnings Report endpoint.
            For more information, visit: https://financialmodelingprep.com
    #>

    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true)]
        [string] $Symbol,

        [Parameter(Mandatory = $false)]
        [int] $Limit = 5,

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }

        $baseUrl = "https://financialmodelingprep.com/stable/earnings"
    }

    Process {
        $url = "{0}?symbol={1}&limit={2}&apikey={3}" -f $baseUrl, $Symbol, $Limit, $ApiKey

        $headers = @{
            "Upgrade-Insecure-Requests" = "1"
        }

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving earnings report data: $_"
        }
    }
 
 };


function Get-FMPFinancialEstimates { 
 

    <#
        .SYNOPSIS
            Retrieves analyst financial estimates for a specified stock symbol using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPFinancialEstimates function fetches projected financial figures such as revenue, EBITDA, earnings per share (EPS),
            and other key financial metrics as forecasted by industry analysts. These estimates can be filtered by reporting period
            (annual or quarter), and pagination parameters can be used to navigate through multiple results.
            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential function and will prompt the user if necessary.

        .PARAMETER Symbol
            Specifies the stock symbol for which to retrieve analyst estimates (e.g., AAPL). This parameter is mandatory.

        .PARAMETER Period
            Specifies the reporting period for the estimates. Valid values are "annual" or "quarter". This parameter is mandatory.

        .PARAMETER Page
            Specifies the page number for pagination (default is 0). This parameter is optional.

        .PARAMETER Limit
            Specifies the maximum number of results to return (default is 10). This parameter is optional.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function will attempt to retrieve it using Get-FMPCredential.

        .EXAMPLE
            Get-FMPFinancialEstimates -Symbol AAPL -Period annual -Page 0 -Limit 10

            This example retrieves the annual analyst financial estimates for Apple Inc. using the specified parameters.

        .NOTES
            This function utilizes the Financial Modeling Prep API's Analyst Estimates endpoint.
            For more information, visit: https://financialmodelingprep.com
    #>

    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true)]
        [string] $Symbol,

        [Parameter(Mandatory = $true)]
        [ValidateSet("annual", "quarter")]
        [string] $Period,

        [Parameter(Mandatory = $false)]
        [int] $Page = 0,

        [Parameter(Mandatory = $false)]
        [int] $Limit = 10,

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/stable/analyst-estimates"
    }

    Process {
        $url = "{0}?symbol={1}&period={2}&page={3}&limit={4}&apikey={5}" -f $baseUrl, $Symbol, $Period, $Page, $Limit, $ApiKey

        $headers = @{
            "Upgrade-Insecure-Requests" = "1"
        }

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving analyst financial estimates: $_"
        }
    }
 
 };


function Get-FMPWeightedMovingAverage { 
 

    <#
        .SYNOPSIS
            Retrieves Weighted Moving Average (WMA) technical indicator data for a specified symbol.

        .DESCRIPTION
            The Get-FMPWeightedMovingAverage function calculates and returns the Weighted Moving Average (WMA)
            technical indicator for a given symbol. This indicator assigns more weight to recent data points
            and less weight to data points in the distant past.

        .PARAMETER Symbol
            Specifies the stock symbol (e.g., AAPL, MSFT) for which to retrieve the WMA.
            This parameter is mandatory.

        .PARAMETER PeriodLength
            Specifies the number of periods to consider for calculating the WMA.
            This parameter is mandatory.

        .PARAMETER Timeframe
            Specifies the timeframe to use for calculations.
            Valid values include: 1min, 5min, 15min, 30min, 1hour, 4hour, 1day, 1week, 1month.
            The default value is "1day".

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it
            using Get-FMPCredential.

        .EXAMPLE
            Get-FMPWeightedMovingAverage -Symbol AAPL -PeriodLength 20 -Timeframe 1day

        .NOTES
            This is a premium endpoint, and requires a paid subscription. This function uses the Financial Modeling Prep API's WMA endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/weighted-moving-average
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [string] $Symbol,

        [Parameter(Mandatory = $true)]
        [int] $PeriodLength,

        [Parameter(Mandatory = $false)]
        [ValidateSet("1min", "5min", "15min", "30min", "1hour", "4hour", "1day", "1week", "1month")]
        [string] $Timeframe = "1day",

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/stable/technical-indicators/wma"
    }

    Process {
        $queryParams = @{
            symbol       = $Symbol
            periodLength = $PeriodLength
            timeframe    = $Timeframe
            apikey       = $ApiKey
        }

        $queryString = ($queryParams.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" }) -join "&"
        $url = "{0}?{1}" -f $baseUrl, $queryString

        $headers = @{
            "Upgrade-Insecure-Requests" = "1"
        }

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving Weighted Moving Average data: $_"
        }
    }
 
 };


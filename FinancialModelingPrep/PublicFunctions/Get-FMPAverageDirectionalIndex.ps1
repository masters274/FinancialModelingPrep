function Get-FMPAverageDirectionalIndex { 
 

    <#
        .SYNOPSIS
            Retrieves Average Directional Index (ADX) technical indicator data for a specified symbol.

        .DESCRIPTION
            The Get-FMPAverageDirectionalIndex function calculates and returns the Average Directional Index (ADX)
            technical indicator for a given symbol. ADX helps determine trend strength without regard to
            direction, with values ranging from 0 to 100.

        .PARAMETER Symbol
            Specifies the stock symbol (e.g., AAPL, MSFT) for which to retrieve the ADX.
            This parameter is mandatory.

        .PARAMETER PeriodLength
            Specifies the number of periods to consider for calculating the ADX.
            This parameter is mandatory.

        .PARAMETER Timeframe
            Specifies the timeframe to use for calculations.
            Valid values include: 1min, 5min, 15min, 30min, 1hour, 4hour, 1day, 1week, 1month.
            The default value is "1day".

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it
            using Get-FMPCredential.

        .EXAMPLE
            Get-FMPAverageDirectionalIndex -Symbol AAPL -PeriodLength 14 -Timeframe 1day

        .NOTES
            This is a premium endpoint, and requires a paid subscription. This function uses the Financial Modeling Prep API's ADX endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/average-directional-index
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
        $baseUrl = "https://financialmodelingprep.com/stable/technical-indicators/adx"
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
            throw "Error retrieving Average Directional Index data: $_"
        }
    }
 
 };


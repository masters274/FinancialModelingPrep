function Get-FMPDividendCalendar { 
 

    <#
        .SYNOPSIS
            Retrieves a comprehensive schedule of upcoming dividend events for all stocks using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPDividendCalendar function fetches dividend event data including record dates, payment dates, declaration dates,
            dividend amounts, yields, and frequency information for stocks. It allows filtering based on a date range using the "from" and
            "to" parameters, and limits the number of records returned. This information helps users stay informed about upcoming
            dividend payments for effective investment planning.
            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential function and will prompt the user if necessary.

        .PARAMETER FromDate
            Specifies the start date for the dividend calendar events. The date must be a [datetime] object and is formatted as "yyyy-MM-dd".
            This parameter is optional. Must have a paid subscription to use this.

        .PARAMETER ToDate
            Specifies the end date for the dividend calendar events. The date must be a [datetime] object and is formatted as "yyyy-MM-dd".
            This parameter is optional.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it using Get-FMPCredential.

        .EXAMPLE
            Get-FMPDividendCalendar

            This example retrieves up to 100 dividend events scheduled between January 8, 2025 and April 8, 2025 using your Financial Modeling Prep API key.

        .NOTES
            This function utilizes the Financial Modeling Prep Dividends Calendar API endpoint.
            For more information, visit: https://financialmodelingprep.com
    #>

    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $false, HelpMessage = "Premium parameter")]
        [datetime] $FromDate,

        [Parameter(Mandatory = $false)]
        [datetime] $ToDate,

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/stable/dividends-calendar"
    }

    Process {
        $url = "{0}?apikey={1}" -f $baseUrl, $ApiKey

        if ($FromDate) {
            $url += "&from=" + $FromDate.ToString("yyyy-MM-dd")
        }

        if ($ToDate) {
            $url += "&to=" + $ToDate.ToString("yyyy-MM-dd")
        }

        $headers = @{
            "Upgrade-Insecure-Requests" = "1"
        }

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving dividend calendar data: $_"
        }
    }
 
 };


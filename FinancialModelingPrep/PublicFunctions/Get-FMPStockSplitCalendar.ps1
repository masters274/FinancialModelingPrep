function Get-FMPStockSplitCalendar { 
 

    <#
        .SYNOPSIS
            Retrieves upcoming stock splits calendar information using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPStockSplitCalendar function fetches upcoming stock split events for multiple companies, providing details
            such as the split date and the split ratio (numerator and denominator). This data helps users track changes in share
            structures before they occur. Users can filter the results by specifying a date range using the "from" and "to" parameters.
            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential function and will prompt the user if necessary.

        .PARAMETER FromDate
            Specifies the start date (inclusive) for filtering the stock splits calendar events.
            The date must be a [datetime] object and is formatted as "yyyy-MM-dd". This parameter is optional. This is a paid subscription feature.

        .PARAMETER ToDate
            Specifies the end date (inclusive) for filtering the stock splits calendar events.
            The date must be a [datetime] object and is formatted as "yyyy-MM-dd". This parameter is optional.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it using Get-FMPCredential.

        .EXAMPLE
            Get-FMPStockSplitCalendar -FromDate (Get-Date "2025-01-08") -ToDate (Get-Date "2025-04-08")

            This example retrieves up to 100 upcoming stock split events scheduled between January 8, 2025 and April 8, 2025 using your Financial Modeling Prep API key.

        .NOTES
            This function utilizes the Financial Modeling Prep API's Splits Calendar endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/splits-calendar
    #>

    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $false)]
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
        $baseUrl = "https://financialmodelingprep.com/stable/splits-calendar"
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
            throw "Error retrieving stock splits calendar data: $_"
        }
    }
 
 };


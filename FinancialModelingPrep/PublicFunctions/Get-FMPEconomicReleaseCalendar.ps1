function Get-FMPEconomicReleaseCalendar { 
 

    <#
        .SYNOPSIS
            Retrieves a calendar of upcoming economic data releases using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPEconomicReleaseCalendar function fetches real-time and historical economic release data for key events
            such as GDP announcements, inflation reports, and other economic indicators. Users can filter the data by specifying a date range
            using the FromDate and ToDate parameters. This information can be used to prepare for market impacts and make informed investment decisions.
            If no API key is provided, the function will attempt to retrieve it using the Get-FMPCredential function and prompt the user if necessary.

        .PARAMETER FromDate
            (Optional) Specifies the start date (inclusive) for retrieving economic release events.
            The date must be provided as a [datetime] object and will be formatted as "yyyy-MM-dd".

        .PARAMETER ToDate
            (Optional) Specifies the end date (inclusive) for retrieving economic release events.
            The date must be provided as a [datetime] object and will be formatted as "yyyy-MM-dd".

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it using the Get-FMPCredential function.

        .EXAMPLE
            Get-FMPEconomicReleaseCalendar

            This example retrieves economic data release events occurring between January 1, 2024 and March 1, 2024.

        .NOTES
            This is a premium endpoint, and requires a paid subscription. This function utilizes the Financial Modeling Prep Economic Data Releases Calendar endpoint.
            For more information, visit: https://financialmodelingprep.com
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
        $baseUrl = "https://financialmodelingprep.com/stable/economic-calendar"
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
            throw "Error retrieving economic release calendar data: $_"
        }
    }
 
 };


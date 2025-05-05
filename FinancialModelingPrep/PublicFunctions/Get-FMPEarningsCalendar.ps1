function Get-FMPEarningsCalendar { 
 

    <#
        .SYNOPSIS
            Retrieves upcoming and past earnings announcements for publicly traded companies using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPEarningsCalendar function fetches key earnings calendar data including announcement dates, EPS actual,
            EPS estimated, revenue actual, revenue estimated, and the last updated timestamp for companies.
            Use the "from" and "to" parameters to filter events by date, and control the number of records returned with the "limit" parameter.
            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential function and will prompt
            the user if necessary.

        .PARAMETER FromDate
            Specifies the start date (inclusive) for the earnings calendar events. The date is formatted as "yyyy-MM-dd". This parameter is only available with a paid subscription.

        .PARAMETER ToDate
            Specifies the end date (inclusive) for the earnings calendar events. The date is formatted as "yyyy-MM-dd".

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it using the Get-FMPCredential function.

        .EXAMPLE
            Get-FMPEarningsCalendar

            This example retrieves earnings calendar events between January 8, 2025 and April 8, 2025 with a maximum of 100 records.

        .NOTES
            This function utilizes the Financial Modeling Prep Earnings Calendar API endpoint.
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
        $baseUrl = "https://financialmodelingprep.com/stable/earnings-calendar"
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
            throw "Error retrieving earnings calendar data: $_"
        }
    }
 
 };


function Get-FMPIPOCalendar { 
 

    <#
        .SYNOPSIS
            Retrieves a comprehensive list of upcoming initial public offerings (IPOs) using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPIPOCalendar function fetches details for upcoming IPO events including IPO dates, company names,
            expected pricing information, and exchange listings. Users can filter the IPO events by specifying a date range
            using the "from" and "to" parameters. This function helps you stay informed on the latest companies entering
            the public market. If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential function
            and prompts the user if necessary.

        .PARAMETER FromDate
            Specifies the start date (inclusive) for the IPO calendar events.
            The date must be a [datetime] object and will be formatted as "yyyy-MM-dd".

        .PARAMETER ToDate
            Specifies the end date (inclusive) for the IPO calendar events.
            The date must be a [datetime] object and will be formatted as "yyyy-MM-dd".

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it using the
            Get-FMPCredential function.

        .EXAMPLE
            Get-FMPIPOCalendar -FromDate (Get-Date "2025-01-08") -ToDate (Get-Date "2025-04-08")

            This example retrieves the IPO calendar events scheduled between January 8, 2025 and April 8, 2025 using your Financial Modeling Prep API key.

        .NOTES
            This is a premium endpoint, and requires a paid subscription. This function utilizes the Financial Modeling Prep IPO Calendar API endpoint.
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
        $baseUrl = "https://financialmodelingprep.com/stable/ipos-calendar"
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
            throw "Error retrieving IPO calendar data: $_"
        }
    }
 
 };


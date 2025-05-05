function Get-FMPIPODisclosure { 
 

    <#
        .SYNOPSIS
            Retrieves IPO disclosure filings for upcoming initial public offerings using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPIPODisclosure function fetches a list of disclosure filings for upcoming IPOs. This includes
            key regulatory filing details such as filing dates, effectiveness dates, CIK numbers, form types, and direct
            links to the official SEC documents. Users can filter the results by specifying a date range using the "from"
            and "to" parameters. If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential
            function and prompts the user if necessary.

        .PARAMETER FromDate
            Specifies the start date (inclusive) for the IPO disclosure filings. The date must be a [datetime] object
            and is formatted as "yyyy-MM-dd". This parameter is optional.

        .PARAMETER ToDate
            Specifies the end date (inclusive) for the IPO disclosure filings. The date must be a [datetime] object
            and is formatted as "yyyy-MM-dd". This parameter is optional.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it using
            Get-FMPCredential.

        .EXAMPLE
            Get-FMPIPODisclosure -FromDate (Get-Date "2025-01-08") -ToDate (Get-Date "2025-04-08")

            This example retrieves IPO disclosure filings between January 8, 2025 and April 8, 2025 using your Financial Modeling Prep API key.

        .NOTES
            This is a premium endpoint, and requires a paid subscription. This function utilizes the Financial Modeling Prep IPO Disclosures API endpoint.
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
        $baseUrl = "https://financialmodelingprep.com/stable/ipos-disclosure"
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
            throw "Error retrieving IPO disclosure data: $_"
        }
    }
 
 };


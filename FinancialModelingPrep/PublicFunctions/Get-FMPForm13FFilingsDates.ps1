function Get-FMPForm13FFilingsDates { 
 

    <#
        .SYNOPSIS
            Retrieves dates associated with Form 13F filings for a specified institutional investor using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPForm13FFilingsDates function fetches the dates on which an institutional investor filed Form 13F reports with the SEC.
            Form 13F reports reveal stock holdings of institutional investors, providing valuable insights into their investment strategies.
            The function requires a Central Index Key (CIK) to identify the institutional investor.
            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential function.

        .PARAMETER CIK
            Specifies the Central Index Key (CIK) of the institutional investor (e.g., "0001067983" for Berkshire Hathaway).
            This parameter is mandatory.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it using Get-FMPCredential.

        .EXAMPLE
            Get-FMPForm13FFilingsDates -CIK "0001067983"

            Retrieves the Form 13F filing dates for Berkshire Hathaway (CIK: 0001067983).

        .NOTES
            This is a premium endpoint, and requires a paid subscription. This function utilizes the Financial Modeling Prep API's Form 13F Filings Dates endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/form-13f-filings-dates
    #>

    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true)]
        [string] $CIK,

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/stable/institutional-ownership/dates"
    }

    Process {
        $url = "{0}?cik={1}&apikey={2}" -f $baseUrl, $CIK, $ApiKey

        $headers = @{
            "Upgrade-Insecure-Requests" = "1"
        }

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving Form 13F filing dates: $_"
        }
    }
 
 };


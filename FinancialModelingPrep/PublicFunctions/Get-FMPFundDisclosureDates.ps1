function Get-FMPFundDisclosureDates { 
 

    <#
        .SYNOPSIS
            Retrieves the available disclosure dates for a specified ETF or mutual fund.

        .DESCRIPTION
            The Get-FMPFundDisclosureDates function fetches a list of all dates on which disclosures
            have been filed for a specific ETF or mutual fund. This information helps you track the
            reporting history of the fund and identify available disclosure dates for further investigation.

            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential function
            and will prompt the user if necessary.

        .PARAMETER Symbol
            Specifies the ticker symbol for the ETF or mutual fund (e.g., "VWO"). This parameter is mandatory.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it
            using Get-FMPCredential.

        .EXAMPLE
            Get-FMPFundDisclosureDates -Symbol "VWO"

            Retrieves all disclosure dates for the Vanguard FTSE Emerging Markets ETF.

        .NOTES
            This is a premium endpoint, and requires a paid subscription. This function uses the Financial Modeling Prep API's Fund Disclosure Dates endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/disclosures-dates
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [string] $Symbol,

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/stable/funds/disclosure-dates"
    }

    Process {
        $url = "{0}?symbol={1}&apikey={2}" -f $baseUrl, $Symbol, $ApiKey

        $headers = @{
            "Upgrade-Insecure-Requests" = "1"
        }

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving fund disclosure dates: $_"
        }
    }
 
 };


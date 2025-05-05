function Get-FMPEquityOfferingByCIK { 
 

    <#
        .SYNOPSIS
            Retrieves equity offerings for a specified company by CIK using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPEquityOfferingByCIK function fetches equity offerings data for a specific company
            using its Central Index Key (CIK). Results can be paginated using the Page parameter.

            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential function
            and will prompt the user if necessary.

        .PARAMETER CIK
            Specifies the Central Index Key (CIK) for the company. This parameter is mandatory.

        .PARAMETER Page
            Specifies the page number for paginated results. The default value is 0.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it
            using Get-FMPCredential.

        .EXAMPLE
            Get-FMPEquityOfferingByCIK -CIK "0001547416" -Page 0

            Retrieves the first page of equity offerings for the company with CIK 0001640334.

        .NOTES
            This is a premium endpoint, and requires a paid subscription. This function uses the Financial Modeling Prep API's Equity Offering by CIK endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/equity-offering-by-cik
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [string] $CIK,

        [Parameter(Mandatory = $false)]
        [int] $Page = 0,

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/stable/fundraising"
    }

    Process {
        $url = "{0}?cik={1}&page={2}&apikey={3}" -f $baseUrl, $CIK, $Page, $ApiKey

        $headers = @{
            "Upgrade-Insecure-Requests" = "1"
        }

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving equity offerings by CIK: $_"
        }
    }
 
 };


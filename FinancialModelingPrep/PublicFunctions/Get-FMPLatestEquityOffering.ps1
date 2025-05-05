function Get-FMPLatestEquityOffering { 
 

    <#
        .SYNOPSIS
            Retrieves the latest equity offerings data from Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPLatestEquityOffering function fetches the most recent equity offerings data.
            Results can be paginated using the Page parameter.

            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential function
            and will prompt the user if necessary.

        .PARAMETER Page
            Specifies the page number for paginated results. The default value is 0.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it
            using Get-FMPCredential.

        .EXAMPLE
            Get-FMPLatestEquityOffering -Page 0

            Retrieves the first page of the latest equity offerings data.

        .NOTES
            This is a premium endpoint, and requires a paid subscription. This function uses the Financial Modeling Prep API's Latest Equity Offering endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/latest-equity-offering
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $false)]
        [int] $Page = 0,

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/stable/fundraising-latest"
    }

    Process {
        $url = "{0}?page={1}&apikey={2}" -f $baseUrl, $Page, $ApiKey

        $headers = @{
            "Upgrade-Insecure-Requests" = "1"
        }

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving latest equity offerings data: $_"
        }
    }
 
 };


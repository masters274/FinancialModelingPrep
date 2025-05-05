function Search-FMPEquityOffering { 
 

    <#
        .SYNOPSIS
            Searches for equity offerings by company name using the Financial Modeling Prep API.

        .DESCRIPTION
            The Search-FMPEquityOffering function allows you to search for equity offerings
            by specifying a search term for the company name. Results can be paginated using the Page parameter.

            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential function
            and will prompt the user if necessary.

        .PARAMETER Name
            Specifies the search term for the company name. This parameter is mandatory.

        .PARAMETER Page
            Specifies the page number for paginated results. The default value is 0.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it
            using Get-FMPCredential.

        .EXAMPLE
            Search-FMPEquityOffering -Name "Tech" -Page 0

            Searches for equity offerings from companies with "Tech" in their name, returning the first page of results.

        .NOTES
            This is a premium endpoint, and requires a paid subscription. This function uses the Financial Modeling Prep API's Equity Offering Search endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/equity-offering-search
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [string] $Name,

        [Parameter(Mandatory = $false)]
        [int] $Page = 0,

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/stable/fundraising-search"
    }

    Process {
        $url = "{0}?name={1}&page={2}&apikey={3}" -f $baseUrl, [Uri]::EscapeDataString($Name), $Page, $ApiKey

        $headers = @{
            "Upgrade-Insecure-Requests" = "1"
        }

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error searching equity offerings: $_"
        }
    }
 
 };


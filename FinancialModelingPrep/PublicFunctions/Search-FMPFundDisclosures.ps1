function Search-FMPFundDisclosures { 
 

    <#
        .SYNOPSIS
            Searches for mutual fund or ETF disclosures by fund name.

        .DESCRIPTION
            The Search-FMPFundDisclosures function allows you to search for mutual fund or ETF disclosures
            by specifying a search term for the fund name. This helps you locate disclosure information for
            funds when you don't know their CIK numbers. Results can be paginated using the Page parameter.

            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential function
            and will prompt the user if necessary.

        .PARAMETER Name
            Specifies the search term for the fund name (e.g., "Vanguard", "S&P 500"). This parameter is mandatory.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it
            using Get-FMPCredential.

        .EXAMPLE
            Search-FMPFundDisclosures -Name "Vanguard"

            Searches for disclosures from funds with "Vanguard" in their name, returning the first page of results.

        .NOTES
            This is a premium endpoint, and requires a paid subscription. This function uses the Financial Modeling Prep API's Disclosures Name Search endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/disclosures-name-search
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [string] $Name,

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/stable/funds/disclosure-holders-search"
    }

    Process {
        $url = "{0}?name={1}&apikey={2}" -f $baseUrl, [Uri]::EscapeDataString($Name), $ApiKey

        $headers = @{
            "Upgrade-Insecure-Requests" = "1"
        }

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error searching fund disclosures: $_"
        }
    }
 
 };


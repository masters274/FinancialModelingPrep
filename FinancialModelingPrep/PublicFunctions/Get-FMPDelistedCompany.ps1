function Get-FMPDelistedCompany { 
 

    <#
        .SYNOPSIS
            Retrieves a list of companies that have been delisted from US exchanges using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPDelistedCompany function fetches comprehensive data on companies that are no longer listed on US exchanges.
            This function helps users stay informed about risky stocks and potential financial troubles by identifying companies
            that have been delisted. The returned data includes details such as the trading symbol, company name, exchange,
            IPO date, and the delisted date.
            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential function and will prompt
            the user if necessary.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function will attempt to retrieve it using Get-FMPCredential
            and prompt the user if necessary.

        .EXAMPLE
            Get-FMPDelistedCompany

            This example retrieves a list of delisted companies from US exchanges using your Financial Modeling Prep API key.

        .NOTES
            This function utilizes the Financial Modeling Prep API's Delisted Companies endpoint.
            For more information, visit: https://financialmodelingprep.com
    #>

    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }

        $baseUrl = "https://financialmodelingprep.com/stable/delisted-companies"
    }

    Process {
        $url = "{0}?apikey={1}" -f $baseUrl, $ApiKey

        $headers = @{
            "Upgrade-Insecure-Requests" = "1"
        }

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving delisted companies data: $_"
        }
    }
 
 };


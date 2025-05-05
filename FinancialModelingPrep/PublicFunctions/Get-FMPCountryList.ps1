function Get-FMPCountryList { 
 

    <#
        .SYNOPSIS
            Retrieves a list of available countries where stock symbols are available using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPCountryList function fetches a comprehensive list of countries where stock symbols are available
            from the Financial Modeling Prep API. This data enables users to filter and analyze stock symbols based on
            the country of origin or the primary market where the securities are traded.
            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential
            function and will prompt the user if necessary.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it
            using Get-FMPCredential.

        .EXAMPLE
            Get-FMPCountryList

            Retrieves the complete list of available countries.

        .NOTES
            This function uses the Financial Modeling Prep API's Available Countries endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/available-countries
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
        $baseUrl = "https://financialmodelingprep.com/stable/available-countries"
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
            throw "Error retrieving country list: $_"
        }
    }
 
 };


function Get-FMPIndustryList { 
 

    <#
        .SYNOPSIS
            Retrieves a list of available industry classifications using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPIndustryList function fetches a comprehensive list of supported industry classifications
            from the Financial Modeling Prep API. This data provides information about the various industries
            that can be used to categorize companies and filter other API requests.
            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential
            function and will prompt the user if necessary.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it
            using Get-FMPCredential.

        .EXAMPLE
            Get-FMPIndustryList

            Retrieves the complete list of available industry classifications.

        .NOTES
            This function uses the Financial Modeling Prep API's Available Industries endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/available-industries
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
        $baseUrl = "https://financialmodelingprep.com/stable/available-industries"
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
            throw "Error retrieving industry list: $_"
        }
    }
 
 };


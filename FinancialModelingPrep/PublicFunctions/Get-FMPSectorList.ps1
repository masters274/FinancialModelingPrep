function Get-FMPSectorList { 
 

    <#
        .SYNOPSIS
            Retrieves a list of available industry sectors using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPSectorList function fetches a comprehensive list of supported industry sectors
            from the Financial Modeling Prep API. This data provides information about the various sectors
            that can be used to categorize companies and filter other API requests.
            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential
            function and will prompt the user if necessary.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it
            using Get-FMPCredential.

        .EXAMPLE
            Get-FMPSectorList

            Retrieves the complete list of available industry sectors.

        .NOTES
            This function uses the Financial Modeling Prep API's Available Sectors endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/available-sectors
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
        $baseUrl = "https://financialmodelingprep.com/stable/available-sectors"
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
            throw "Error retrieving sector list: $_"
        }
    }
 
 };


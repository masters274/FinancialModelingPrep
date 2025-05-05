function Get-FMPForexList { 
 

    <#
        .SYNOPSIS
            Retrieves a list of available forex currency pairs from the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPForexList function fetches a comprehensive list of available forex (foreign exchange)
            currency pairs through the Financial Modeling Prep API. This list provides symbols and names
            for various currency pairs that can be used with other forex-related functions.

            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential
            function and will prompt the user if necessary.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it
            using Get-FMPCredential.

        .EXAMPLE
            Get-FMPForexList

            Retrieves the complete list of available forex currency pairs.

        .NOTES
            This function uses the Financial Modeling Prep API's Forex List endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/forex-list
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
        # Updated to the correct endpoint
        $baseUrl = "https://financialmodelingprep.com/stable/forex-list"
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
            throw "Error retrieving forex list: $_"
        }
    }
 
 };


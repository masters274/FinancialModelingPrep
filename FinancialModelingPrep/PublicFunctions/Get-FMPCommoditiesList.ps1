function Get-FMPCommoditiesList { 
 

    <#
        .SYNOPSIS
            Retrieves a list of available commodities from the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPCommoditiesList function fetches a comprehensive list of tradable commodities
            available through the Financial Modeling Prep API. This list provides symbols and names
            for various commodities that can be used with other commodity-related functions.

            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential
            function and will prompt the user if necessary.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it
            using Get-FMPCredential.

        .EXAMPLE
            Get-FMPCommoditiesList

            Retrieves the complete list of available commodities.

        .NOTES
            This function uses the Financial Modeling Prep API's Commodities List endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/commodities-list
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
        $baseUrl = "https://financialmodelingprep.com/api/v3/symbol/available-commodities"
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
            throw "Error retrieving commodities list: $_"
        }
    }
 
 };


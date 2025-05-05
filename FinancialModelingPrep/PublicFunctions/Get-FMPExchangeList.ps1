function Get-FMPExchangeList { 
 

    <#
        .SYNOPSIS
            Retrieves a list of available stock exchanges using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPExchangeList function fetches a comprehensive list of supported stock exchanges
            from the Financial Modeling Prep API. This data provides information about where securities
            are traded globally and can be used to filter other API requests by specific exchanges.
            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential
            function and will prompt the user if necessary.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it
            using Get-FMPCredential.

        .EXAMPLE
            Get-FMPExchangeList

            Retrieves the complete list of available stock exchanges.

        .NOTES
            This function uses the Financial Modeling Prep API's Available Exchanges endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/available-exchanges
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
        $baseUrl = "https://financialmodelingprep.com/stable/available-exchanges"
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
            throw "Error retrieving exchange list: $_"
        }
    }
 
 };


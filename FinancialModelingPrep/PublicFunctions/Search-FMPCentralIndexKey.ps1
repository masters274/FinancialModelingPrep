function Search-FMPCentralIndexKey { 
 

    <#
        .SYNOPSIS
            Retrieves CIK data for publicly traded companies using the Financial Modeling Prep API.

        .DESCRIPTION
            The Search-FMPCentralIndexKey function searches for companies by their Central Index Key (CIK). It returns key details
            including the company's symbol, name, CIK, exchange full name, exchange, and currency. This function is useful for
            accessing unique identifiers required for SEC filings and regulatory documents.
            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential function and will prompt
            the user if necessary.

        .PARAMETER CIK
            Specifies the Central Index Key for the company (e.g., "320193"). This parameter is mandatory.

        .PARAMETER Limit
            Specifies the maximum number of results to return. Default is 50. This parameter is optional.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it using the Get-FMPCredential
            function and prompts the user if necessary.

        .EXAMPLE
            Search-FMPCentralIndexKey -CIK "320193" -Limit 50

            This example searches for the company with the CIK "320193" and retrieves up to 50 results.

        .NOTES
            This function utilizes the Financial Modeling Prep API's CIK search endpoint.
            For more information, visit: https://financialmodelingprep.com
    #>

    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true)]
        [string] $CIK,

        [Parameter(Mandatory = $false)]
        [int] $Limit = 50,

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/stable/search-cik"
    }

    Process {
        $url = "{0}?cik={1}&limit={2}&apikey={3}" -f $baseUrl, $CIK, $Limit, $ApiKey

        $headers = @{
            "Upgrade-Insecure-Requests" = "1"
        }

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving CIK data: $_"
        }
    }
 
 };


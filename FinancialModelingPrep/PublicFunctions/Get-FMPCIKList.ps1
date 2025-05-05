function Get-FMPCIKList { 
 

    <#
        .SYNOPSIS
            Retrieves a comprehensive database of CIK (Central Index Key) numbers for SEC-registered entities using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPCIKList function fetches a list of CIK numbers assigned to SEC-registered entities.
            CIK numbers serve as unique identifiers required for regulatory filings and financial transactions.
            This function is valuable for investment research, regulatory compliance, and portfolio management.
            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential function and will prompt the user if necessary.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it
            using Get-FMPCredential.

        .EXAMPLE
            Get-FMPCIKList

            Retrieves the complete list of CIK numbers for SEC-registered entities.

        .NOTES
            This function utilizes the Financial Modeling Prep API's CIK List endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/cik-list
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
        $baseUrl = "https://financialmodelingprep.com/stable/cik-list"
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
            throw "Error retrieving CIK list data: $_"
        }
    }
 
 };


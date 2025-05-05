function Get-FMPAllInsiderTransactionTypes { 
 

    <#
        .SYNOPSIS
            Retrieves a list of all transaction types used in insider trading data.

        .DESCRIPTION
            The Get-FMPAllInsiderTransactionTypes function fetches a comprehensive list of transaction types
            and their descriptions from the Financial Modeling Prep API. This information helps users
            interpret transaction codes found in insider trading reports (e.g., "P" for Purchase or
            "S" for Sale).

            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential
            function and prompts the user if necessary.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts
            to retrieve it using Get-FMPCredential.

        .EXAMPLE
            Get-FMPAllInsiderTransactionTypes

            Retrieves all transaction types and their descriptions.

        .NOTES
            This is a premium endpoint, and requires a paid subscription. This function uses the Financial Modeling Prep API's All Transaction Types endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/all-transaction-types
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
        $baseUrl = "https://financialmodelingprep.com/stable/insider-trading-transaction-type"
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
            throw "Error retrieving transaction types: $_"
        }
    }
 
 };


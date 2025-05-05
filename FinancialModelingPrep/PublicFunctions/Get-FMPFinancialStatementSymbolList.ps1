function Get-FMPFinancialStatementSymbolList { 
 

    <#
        .SYNOPSIS
            Retrieves a list of stock symbols that have financial statements available using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPFinancialStatementSymbolList function fetches a comprehensive list of ticker symbols that have
            financial statements available through the Financial Modeling Prep API. This helps users identify which
            companies they can retrieve financial statement data for. If no API key is provided, the function attempts
            to retrieve it using the Get-FMPCredential function and will prompt the user if necessary.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it
            using Get-FMPCredential.

        .EXAMPLE
            Get-FMPFinancialStatementSymbolList

            Retrieves the complete list of symbols with financial statements available.

        .NOTES
            This function utilizes the Financial Modeling Prep API's Financial Statement Symbol List endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/financial-symbols-list
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
        $baseUrl = "https://financialmodelingprep.com/stable/financial-statement-symbol-list"
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
            throw "Error retrieving financial statement symbol list: $_"
        }
    }
 
 };


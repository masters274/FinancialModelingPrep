function Get-FMPSymbolChanges { 
 

    <#
        .SYNOPSIS
            Retrieves a list of historical stock symbol changes using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPSymbolChanges function fetches data about companies that have changed their ticker symbols.
            This information includes details about the old symbol, new symbol, date of change, and company name.
            This data is useful for tracking companies that have undergone symbol changes due to mergers, acquisitions,
            rebranding, or other corporate actions.
            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential function
            and will prompt the user if necessary.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it
            using Get-FMPCredential.

        .EXAMPLE
            Get-FMPSymbolChanges

            Retrieves the complete list of historical stock symbol changes.

        .NOTES
            This function utilizes the Financial Modeling Prep API's Symbol Changes endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/symbol-changes-list
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
        $baseUrl = "https://financialmodelingprep.com/stable/symbol-change"
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
            throw "Error retrieving symbol changes data: $_"
        }
    }
 
 };


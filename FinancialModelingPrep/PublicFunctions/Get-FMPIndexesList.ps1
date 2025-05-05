function Get-FMPIndexesList { 
 

    <#
        .SYNOPSIS
            Retrieves a list of available stock indexes.

        .DESCRIPTION
            Uses the Financial Modeling Prep API to obtain a list of all available stock indexes.

        .PARAMETER ApiKey
            Your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it using Get-FMPCredential.

        .EXAMPLE
            Get-FMPIndexesList

            Retrieves the list of available indexes.
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )
    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/api/v3/symbol/available-indexes"
    }
    Process {
        $url = "{0}?apikey={1}" -f $baseUrl, $ApiKey
        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving indexes list: $_"
        }
    }
 
 };


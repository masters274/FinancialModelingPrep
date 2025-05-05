function Search-FMPSenateTradingByName { 
 

    <#
        .SYNOPSIS
            Searches for trading activities by specific U.S. Senators by name.

        .DESCRIPTION
            The Search-FMPSenateTradingByName function allows you to search for trading activities
            conducted by specific U.S. Senators by providing their name as a search term.

        .PARAMETER Name
            Specifies the Senator's name to search for.
            This parameter is mandatory.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts
            to retrieve it using Get-FMPCredential.

        .EXAMPLE
            Search-FMPSenateTradingByName -Name "John"

            Searches for trading activities by match. Finds any Senator where given or surname matches John.

        .NOTES
            This function uses the Financial Modeling Prep API's Senate Trading by Name endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/senate-trading-by-name
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [string] $Name,

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/stable/senate-trades-by-name"
    }

    Process {
        $url = "{0}?name={1}&apikey={2}" -f $baseUrl, [Uri]::EscapeDataString($Name), $ApiKey

        $headers = @{
            "Upgrade-Insecure-Requests" = "1"
        }

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error searching Senate trading by name: $_"
        }
    }
 
 };


function Get-FMPETFList { 
 

    <#
        .SYNOPSIS
            Retrieves a comprehensive list of ETFs (Exchange-Traded Funds) using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPETFList function fetches a complete list of available ETFs from the Financial Modeling Prep API.
            This data provides essential information for investors and analysts seeking to explore ETF options for their portfolios.
            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential function and will prompt the user if necessary.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it using Get-FMPCredential.

        .EXAMPLE
            Get-FMPETFList

            Retrieves the complete list of available ETFs.

        .NOTES
            This function uses the Financial Modeling Prep API's ETF List endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/etfs-list
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
        $baseUrl = "https://financialmodelingprep.com/stable/etf-list"
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
            throw "Error retrieving ETF list: $_"
        }
    }
 
 };


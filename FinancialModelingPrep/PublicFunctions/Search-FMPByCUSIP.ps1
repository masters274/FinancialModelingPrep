function Search-FMPByCUSIP { 
 

    <#
        .SYNOPSIS
            Searches for financial securities information by CUSIP number using the Financial Modeling Prep API.

        .DESCRIPTION
            The Search-FMPByCUSIP function retrieves key details such as the company name, stock symbol, and market capitalization
            associated with a given CUSIP number. This function is useful for obtaining detailed security information needed
            for SEC filings and financial analysis. If no API key is provided, the function attempts to retrieve it using the
            Get-FMPCredential function and will prompt the user if necessary.

        .PARAMETER CUSIP
            Specifies the CUSIP number for the security (e.g., "037833100"). This parameter is mandatory.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it using the Get-FMPCredential
            function and prompts the user if necessary.

        .EXAMPLE
            Search-FMPByCUSIP -CUSIP "037833100"

            This example retrieves information for the security with the CUSIP number 037833100 using your Financial Modeling Prep API key.

        .NOTES
            This is a premium endpoint, and requires a paid subscription. This function utilizes the Financial Modeling Prep API's CUSIP search endpoint.
            For more information, visit: https://financialmodelingprep.com
    #>

    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true)]
        [string] $CUSIP,

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/stable/search-cusip"
    }

    Process {
        $url = "{0}?cusip={1}&apikey={2}" -f $baseUrl, $CUSIP, $ApiKey

        $headers = @{
            "Upgrade-Insecure-Requests" = "1"
        }

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving CUSIP data: $_"
        }
    }
 
 };


function Search-FMPByISIN { 
 

    <#
        .SYNOPSIS
            Retrieves financial securities information by ISIN using the Financial Modeling Prep API.

        .DESCRIPTION
            The Search-FMPByISIN function searches for financial securities using an International Securities Identification Number (ISIN).
            It returns key details such as the company name, stock symbol, and market capitalization. This function uses the FMP ISIN API endpoint.
            If no API key is provided, it attempts to retrieve it using the Get-FMPCredential function and will prompt the user if necessary.

        .PARAMETER ISIN
            Specifies the International Securities Identification Number (e.g., "US0378331005"). This parameter is mandatory.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it using Get-FMPCredential and prompts the user if necessary.

        .EXAMPLE
            Search-FMPByISIN -ISIN "US0378331005"

            This example retrieves information for the security with the ISIN "US0378331005" using your Financial Modeling Prep API key.

        .NOTES
            This is a premium endpoint, and requires a paid subscription. This function utilizes the Financial Modeling Prep ISIN API endpoint.
            For more information, visit: https://financialmodelingprep.com
    #>

    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true)]
        [string] $ISIN,

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/stable/search-isin"
    }

    Process {
        $url = "{0}?isin={1}&apikey={2}" -f $baseUrl, $ISIN, $ApiKey

        $headers = @{
            "Upgrade-Insecure-Requests" = "1"
        }

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving ISIN data: $_"
        }
    }
 
 };


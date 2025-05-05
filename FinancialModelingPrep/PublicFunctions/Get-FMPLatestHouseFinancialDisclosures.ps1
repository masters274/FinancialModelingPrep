function Get-FMPLatestHouseFinancialDisclosures { 
 

    <#
        .SYNOPSIS
            Retrieves the latest financial disclosures from U.S. House members.

        .DESCRIPTION
            The Get-FMPLatestHouseFinancialDisclosures function fetches the most recent financial
            disclosure data from members of the U.S. House of Representatives, providing transparency
            into their financial holdings and transactions.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts
            to retrieve it using Get-FMPCredential.

        .EXAMPLE
            Get-FMPLatestHouseFinancialDisclosures

            Retrieves the latest financial disclosures from U.S. House members.

        .NOTES
            This function uses the Financial Modeling Prep API's Latest House Financial Disclosures endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/house-latest
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
        $baseUrl = "https://financialmodelingprep.com/stable/house-latest"
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
            throw "Error retrieving latest House financial disclosures: $_"
        }
    }
 
 };


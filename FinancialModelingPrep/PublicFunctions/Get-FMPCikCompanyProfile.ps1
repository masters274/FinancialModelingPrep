function Get-FMPCikCompanyProfile { 
 

    <#
        .SYNOPSIS
            Retrieves detailed company profile data using a unique CIK with the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPCikCompanyProfile function fetches comprehensive profile information for a company based on its unique
            Central Index Key (CIK). The returned profile data includes details such as stock price, market capitalization,
            industry, and many other financial and corporate metrics.
            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential function and will prompt
            the user if necessary.

        .PARAMETER CIK
            Specifies the unique Central Index Key (CIK) for the company (e.g., "320193"). This parameter is mandatory.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function will attempt to retrieve it using Get-FMPCredential
            and prompt the user if necessary.

        .EXAMPLE
            Get-FMPCikCompanyProfile -CIK "320193"

            This example retrieves the company profile for the company with the CIK "320193" using your Financial Modeling Prep API key.

        .NOTES
            This function utilizes the Financial Modeling Prep API's Company Profile by CIK endpoint.
            For more information, visit: https://financialmodelingprep.com
    #>

    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true)]
        [string] $CIK,

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }

        $baseUrl = "https://financialmodelingprep.com/stable/profile-cik"
    }

    Process {
        $url = "{0}?cik={1}&apikey={2}" -f $baseUrl, $CIK, $ApiKey

        $headers = @{
            "Upgrade-Insecure-Requests" = "1"
        }

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving FMP company profile by CIK data: $_"
        }
    }
 
 };


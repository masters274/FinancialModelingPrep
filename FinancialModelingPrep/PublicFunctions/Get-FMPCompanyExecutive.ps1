function Get-FMPCompanyExecutive { 
 

    <#
        .SYNOPSIS
            Retrieves detailed information on company executives using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPCompanyExecutive function fetches comprehensive data about key company executives.
            This includes details such as their name, title, compensation, gender, and year of birth among other demographic information.
            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential function and will prompt
            the user if necessary.

        .PARAMETER Symbol
            Specifies the trading symbol for the company (e.g., AAPL). This parameter is mandatory.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it using the Get-FMPCredential
            function and prompts the user if necessary.

        .EXAMPLE
            Get-FMPCompanyExecutive -Symbol AAPL

            This example retrieves the executive details for Apple Inc. using your Financial Modeling Prep API key.

        .NOTES
            This function uses the Financial Modeling Prep API's Company Executives endpoint.
            For more information, visit: https://financialmodelingprep.com
    #>

    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true)]
        [string] $Symbol,

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/stable/key-executives"
    }

    Process {
        $url = "{0}?symbol={1}&apikey={2}" -f $baseUrl, $Symbol, $ApiKey

        $headers = @{
            "Upgrade-Insecure-Requests" = "1"
        }

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving FMP company executives data: $_"
        }
    }
 
 };


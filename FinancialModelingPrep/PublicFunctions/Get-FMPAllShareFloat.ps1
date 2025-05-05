function Get-FMPAllShareFloat { 
 

    <#
        .SYNOPSIS
            Retrieves comprehensive shares float data for all available companies using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPAllShareFloat function fetches critical liquidity information across a wide range of companies.
            It returns data such as the free float percentage, float shares, and outstanding shares.
            This endpoint is ideal for analyzing stock liquidity and volatility on a broad scale.
            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential function and prompts
            the user if necessary.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function will attempt to retrieve it using Get-FMPCredential
            and prompt the user if necessary.

        .EXAMPLE
            Get-FMPAllShareFloat

            This example retrieves comprehensive shares float data for all companies using your Financial Modeling Prep API key.

        .NOTES
            This function utilizes the Financial Modeling Prep API's All Shares Float endpoint.
            For more information, visit: https://financialmodelingprep.com
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
        $baseUrl = "https://financialmodelingprep.com/stable/shares-float-all"
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
            throw "Error retrieving all shares float data: $_"
        }
    }
 
 };


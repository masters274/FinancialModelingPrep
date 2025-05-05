function Get-FMPLatestMerger { 
 

    <#
        .SYNOPSIS
            Retrieves the latest mergers and acquisitions data using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPLatestMerger function fetches real-time information on recent mergers and acquisitions.
            The returned data includes key details such as the transaction date, company names, targeted company information,
            CIK numbers, and links to detailed filing information for further analysis.
            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential function and will prompt
            the user if necessary.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function will attempt to retrieve it using Get-FMPCredential
            and prompt the user if necessary.

        .EXAMPLE
            Get-FMPLatestMerger

            This example retrieves the latest mergers and acquisitions data using your Financial Modeling Prep API key.

        .NOTES
            This function utilizes the Financial Modeling Prep API's Latest Mergers & Acquisitions endpoint.
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
        $baseUrl = "https://financialmodelingprep.com/stable/mergers-acquisitions-latest"
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
            throw "Error retrieving latest mergers and acquisitions data: $_"
        }
    }
 
 };


function Find-FMPMerger { 
 

    <#
        .SYNOPSIS
            Searches for specific mergers and acquisitions data using the Financial Modeling Prep API.

        .DESCRIPTION
            The Find-FMPMerger function fetches detailed M&A activity information based on a search term for the company name.
            It returns data such as the acquiring company details, targeted company information, transaction dates, and
            links to official SEC filings. If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential
            function and will prompt the user if necessary.

        .PARAMETER Name
            Specifies the company name to search for mergers and acquisitions data (e.g., "Apple"). This parameter is mandatory.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function will attempt to retrieve it using Get-FMPCredential
            and prompt the user if necessary.

        .EXAMPLE
            Find-FMPMerger -Name Apple

            This example searches for mergers and acquisitions data related to "Apple" using your Financial Modeling Prep API key.

        .NOTES
            This is a premium endpoint, and requires a paid subscription. This function utilizes the Financial Modeling Prep API's Search Mergers & Acquisitions endpoint.
            For more information, visit: https://financialmodelingprep.com
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
        $baseUrl = "https://financialmodelingprep.com/stable/mergers-acquisitions-search"
    }

    Process {
        $url = "{0}?name={1}&apikey={2}" -f $baseUrl, $Name, $ApiKey

        $headers = @{
            "Upgrade-Insecure-Requests" = "1"
        }

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving FMP mergers and acquisitions search data: $_"
        }
    }
 
 };


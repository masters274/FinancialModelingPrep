function Get-FMPAcquisitionOwnership { 
 

    <#
        .SYNOPSIS
            Retrieves acquisition and ownership data for a specified company using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPAcquisitionOwnership function fetches comprehensive data about acquisitions and ownership changes
            for a given company based on its stock symbol. This data helps investors track significant changes in
            company ownership structure and acquisition activities.

            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential function
            and prompts the user if necessary.

        .PARAMETER Symbol
            Specifies the stock symbol for which to retrieve acquisition ownership data (e.g., AAPL).
            This parameter is mandatory.

        .PARAMETER Page
            Specifies the page number for paginated results. The default value is 0.
            This parameter is optional.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts
            to retrieve it using Get-FMPCredential.

        .EXAMPLE
            Get-FMPAcquisitionOwnership -Symbol AAPL -Page 0

            Retrieves acquisition ownership data for Apple Inc. from the first page of results.

        .NOTES
            This is a premium endpoint, and requires a paid subscription.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/acquisition-ownership
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [string] $Symbol,

        [Parameter(Mandatory = $false)]
        [int] $Page = 0,

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/stable/acquisition-of-beneficial-ownership"
    }

    Process {
        $url = "{0}?symbol={1}&page={2}&apikey={3}" -f $baseUrl, $Symbol, $Page, $ApiKey

        $headers = @{
            "Upgrade-Insecure-Requests" = "1"
        }

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving acquisition ownership data: $_"
        }
    }
 
 };


function Get-FMPExecutiveCompensation { 
 

    <#
        .SYNOPSIS
            Retrieves comprehensive executive compensation data using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPExecutiveCompensation function fetches detailed compensation information for company executives,
            including salaries, bonuses, stock awards, option awards, incentive plan compensation, other compensation, and
            total compensation figures. It also includes filing details and links to official SEC documents.
            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential function and prompts
            the user if necessary.

        .PARAMETER Symbol
            Specifies the trading symbol for the company (e.g., AAPL). This parameter is mandatory.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function will attempt to retrieve it using
            Get-FMPCredential and prompt the user if necessary.

        .EXAMPLE
            Get-FMPExecutiveCompensation -Symbol AAPL

            This example retrieves executive compensation data for Apple Inc. using your Financial Modeling Prep API key.

        .NOTES
            This function utilizes the Financial Modeling Prep API's Executive Compensation endpoint.
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
        $baseUrl = "https://financialmodelingprep.com/stable/governance-executive-compensation"
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
            throw "Error retrieving executive compensation data: $_"
        }
    }
 
 };


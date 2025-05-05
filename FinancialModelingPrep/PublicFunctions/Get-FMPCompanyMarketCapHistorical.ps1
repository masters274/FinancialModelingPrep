function Get-FMPCompanyMarketCapHistorical { 
 

    <#
        .SYNOPSIS
            Retrieves historical market capitalization data for a specified company using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPCompanyMarketCapHistorical function fetches historical market capitalization details for a given
            trading symbol. This data helps track changes in a company's market value over time, enabling long-term assessments
            of its growth or decline. The returned information includes the company symbol, the date of the record, and the
            market capitalization value. If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential
            function and will prompt the user if necessary.

        .PARAMETER Symbol
            Specifies the trading symbol for the company (e.g., AAPL). This parameter is mandatory.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function will attempt to retrieve it using Get-FMPCredential
            and prompt the user if necessary.

        .EXAMPLE
            Get-FMPCompanyMarketCapHistorical -Symbol AAPL

            This example retrieves the historical market capitalization data for Apple Inc. using your Financial Modeling Prep API key.

        .NOTES
            This function utilizes the Financial Modeling Prep API's Historical Market Capitalization endpoint.
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

        $baseUrl = "https://financialmodelingprep.com/stable/historical-market-capitalization"
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
            throw "Error retrieving historical market capitalization data: $_"
        }
    }
 
 };


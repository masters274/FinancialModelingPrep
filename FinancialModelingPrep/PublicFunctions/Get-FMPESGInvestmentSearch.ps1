function Get-FMPESGInvestmentSearch { 
 

    <#
        .SYNOPSIS
            Searches for ESG investment data for a specified stock symbol using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPESGInvestmentSearch function retrieves Environmental, Social, and Governance (ESG) disclosure information
            for a given stock symbol. This API helps investors align their investments with their values by providing insights into
            companies' ESG performance including environmental scores, social scores, governance scores, and overall ESG scores.
            The returned data also includes key details such as the disclosure date, accepted date, company name, and a link to the SEC filing.
            If no API key is provided, the function will attempt to retrieve it using the Get-FMPCredential function and prompt
            the user if necessary.

        .PARAMETER Symbol
            Specifies the stock symbol to search for ESG investment data (e.g., AAPL). This parameter is mandatory.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function will attempt to retrieve it using
            the Get-FMPCredential function.

        .EXAMPLE
            Get-FMPESGInvestmentSearch -Symbol AAPL

            This example retrieves the ESG disclosures for Apple Inc. using your Financial Modeling Prep API key.

        .NOTES
            This is a premium endpoint, and requires a paid subscription. This function utilizes the Financial Modeling Prep ESG Disclosures endpoint.
            For additional details, visit: https://financialmodelingprep.com
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
        $baseUrl = "https://financialmodelingprep.com/stable/esg-disclosures"
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
            throw "Error retrieving ESG investment data: $_"
        }
    }
 
 };


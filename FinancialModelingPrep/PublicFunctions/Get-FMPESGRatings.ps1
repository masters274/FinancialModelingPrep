function Get-FMPESGRatings { 
 

    <#
        .SYNOPSIS
            Retrieves comprehensive ESG ratings for a specified company or fund using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPESGRatings function fetches Environmental, Social, and Governance (ESG) ratings data for a given stock symbol.
            This function provides key details such as the company name, CIK number, industry, fiscal year, ESG risk rating,
            and industry ranking. This information helps investors make informed decisions based on a company's ESG performance.
            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential function and prompts
            the user if necessary.

        .PARAMETER Symbol
            Specifies the stock symbol for which the ESG ratings are to be retrieved (e.g., AAPL). This parameter is mandatory.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it using the
            Get-FMPCredential function.

        .EXAMPLE
            Get-FMPESGRatings -Symbol AAPL

            This example retrieves the ESG ratings data for Apple Inc. using your Financial Modeling Prep API key.

        .NOTES
            This is a premium endpoint, and requires a paid subscription. This function utilizes the Financial Modeling Prep ESG Ratings API endpoint.
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
        $baseUrl = "https://financialmodelingprep.com/stable/esg-ratings"
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
            throw "Error retrieving ESG ratings data: $_"
        }
    }
 
 };


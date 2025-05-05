function Search-FMPCompanyName { 
 

    <#
        .SYNOPSIS
            Searches for equity securities and ETFs by company name using the Financial Modeling Prep API.

        .DESCRIPTION
            The Search-FMPCompanyName function searches for ticker symbols, company names, and exchange details for equity securities
            and ETFs listed on various exchanges. This endpoint is useful when you have the full or partial company or asset name but
            do not know the symbol identifier. Users can specify a search query, limit the number of results returned (default is 50),
            and optionally restrict the search to a specific exchange.
            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential function and will prompt the user if necessary.

        .PARAMETER Query
            Specifies the search query for the company or asset name (e.g., "AA"). This parameter is mandatory.

        .PARAMETER Limit
            Specifies the maximum number of results to return. The default value is 50. This parameter is optional.

        .PARAMETER Exchange
            Optionally restricts the search results to a specific exchange (e.g., "NASDAQ"). This parameter is optional.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it using the Get-FMPCredential
            function and prompts the user if necessary.

        .EXAMPLE
            Search-FMPCompanyName -Query AA -Limit 50 -Exchange NASDAQ

            This example searches for company names matching "AA" on the NASDAQ exchange, returning up to 50 results.

        .NOTES
            This function utilizes the Financial Modeling Prep API's Company Name Search endpoint.
            For more information, visit: https://financialmodelingprep.com
    #>

    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true)]
        [string] $Query,

        [Parameter(Mandatory = $false)]
        [int] $Limit = 50,

        [Parameter(Mandatory = $false)]
        [string] $Exchange,

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/stable/search-name"
    }

    Process {
        $url = "{0}?query={1}&limit={2}&apikey={3}" -f $baseUrl, $Query, $Limit, $ApiKey

        if ($Exchange) {
            $url += "&exchange=" + $Exchange
        }

        $headers = @{
            "Upgrade-Insecure-Requests" = "1"
        }

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving company name search data: $_"
        }
    }
 
 };


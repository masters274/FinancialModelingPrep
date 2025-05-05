function Search-FMPPressReleases { 
 

    <#
        .SYNOPSIS
            Searches for company press releases using specific criteria.

        .DESCRIPTION
            The Search-FMPPressReleases function allows you to search for press releases
            from companies based on specific symbols. This helps you target exactly the
            corporate disclosures you need for your analysis.

        .PARAMETER Symbols
            Specifies the stock symbol(s) to search for press releases. Comma-separated list for multiple symbols (e.g., "AAPL,MSFT").
            This parameter is mandatory.

        .PARAMETER ApiKey
            Your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it using Get-FMPCredential.

        .EXAMPLE
            Search-FMPPressReleases -Symbols "AAPL"

            Searches for press releases from Apple Inc.

        .EXAMPLE
            Search-FMPPressReleases -Symbols "AAPL,MSFT,GOOGL"

            Searches for press releases from Apple, Microsoft, and Google.

        .NOTES
            This is a premium endpoint, and requires a paid subscription. This function uses the Financial Modeling Prep API's Search Press Releases endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/search-press-releases
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [string]$Symbols,

        [Parameter(Mandatory = $false)]
        [string]$ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/stable/news/press-releases"
    }

    Process {
        $url = "{0}?symbols={1}&apikey={2}" -f $baseUrl, $Symbols, $ApiKey

        $headers = @{
            "Upgrade-Insecure-Requests" = "1"
        }

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error searching press releases: $_"
        }
    }
 
 };


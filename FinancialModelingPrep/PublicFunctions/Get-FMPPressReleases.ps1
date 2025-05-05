function Get-FMPPressReleases { 
 

    <#
        .SYNOPSIS
            Retrieves latest press releases from companies.

        .DESCRIPTION
            The Get-FMPPressReleases function fetches the most recent press releases issued by companies.
            You can filter by a specific company symbol and paginate results.

        .PARAMETER Symbol
            Specifies the stock symbol to retrieve press releases for. Optional.

        .PARAMETER Page
            Specifies the page number for pagination. Default is 0.

        .PARAMETER ApiKey
            Your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it using Get-FMPCredential.

        .EXAMPLE
            Get-FMPPressReleases -Page 0

            Returns the latest press releases from all companies, starting from page 0.

        .EXAMPLE
            Get-FMPPressReleases -Symbol AAPL -Page 1

            Returns press releases from Apple Inc., starting from page 1.

        .NOTES
            This is a premium endpoint, and requires a paid subscription. This function uses the Financial Modeling Prep API's Press Releases endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/press-releases
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $false)]
        [string]$Symbol,

        [Parameter(Mandatory = $false)]
        [int]$Page = 0,

        [Parameter(Mandatory = $false)]
        [string]$ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/api/v3/press-releases"
    }

    Process {
        $queryParams = @{
            page   = $Page
            apikey = $ApiKey
        }

        if ($Symbol) { $queryParams.symbol = $Symbol }

        $queryString = ($queryParams.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" }) -join "&"
        $url = "{0}?{1}" -f $baseUrl, $queryString

        $headers = @{
            "Upgrade-Insecure-Requests" = "1"
        }

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving press releases: $_"
        }
    }
 
 };


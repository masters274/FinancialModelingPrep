function Get-FMPLatestFilings { 
 

    <#
        .SYNOPSIS
            Retrieves the latest SEC filings data using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPLatestFilings function fetches the most recent SEC filings from institutional investors.
            Results can be paginated using the Page and Limit parameters to control the number of records returned.
            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential function
            and prompts the user if necessary.

        .PARAMETER Page
            Specifies the page number for pagination. Default is 0 (first page).

        .PARAMETER Limit
            Specifies the maximum number of filings to return per page. Default is 100.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it
            using Get-FMPCredential.

        .EXAMPLE
            Get-FMPLatestFilings -Page 0 -Limit 50

            Retrieves the 50 most recent filings from the first page of results.

        .NOTES
            This is a premium endpoint, and requires a paid subscription. This function uses the Financial Modeling Prep API's Latest Filings endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/latest-filings
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $false)]
        [int] $Page = 0,

        [Parameter(Mandatory = $false)]
        [int] $Limit = 100,

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/stable/institutional-ownership/latest"
    }

    Process {
        $queryParams = @{
            page   = $Page
            limit  = $Limit
            apikey = $ApiKey
        }

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
            throw "Error retrieving latest filings: $_"
        }
    }
 
 };


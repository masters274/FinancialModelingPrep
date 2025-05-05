function Get-FMPHoldersIndustryBreakdown { 
 

    <#
        .SYNOPSIS
            Retrieves the industry breakdown of institutional holders for a specified company.

        .DESCRIPTION
            Uses the Financial Modeling Prep API to obtain a summary of the industries in which institutional holders
            invest, filtered by the company's CIK and a specified date. Data is returned as a JSON object.

        .PARAMETER CIK
            The Central Index Key (CIK) for the company (e.g., "0001067983").

        .PARAMETER Date
            The date for which to retrieve the data in YYYY-MM-DD format. Defaults to today's date.

        .PARAMETER ApiKey
            Your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it using Get-FMPCredential.

        .EXAMPLE
            Get-FMPHoldersIndustryBreakdown -CIK "0001067983" -Date "2023-06-30"

        .NOTES
            This is a premium endpoint, and requires a paid subscription. This function uses the Holder Industry Breakdown API endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/holder-industry-breakdown
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [string] $CIK,

        [Parameter(Mandatory = $false)]
        [string] $Date = (Get-Date -Format "yyyy-MM-dd"),

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/stable/institutional-ownership/holder-industry-breakdown"
    }

    Process {
        $queryParams = @{ cik = $CIK; date = $Date; apikey = $ApiKey }
        $queryString = ($queryParams.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" }) -join "&"
        $url = "{0}?{1}" -f $baseUrl, $queryString

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving holders industry breakdown data: $_"
        }
    }
 
 };


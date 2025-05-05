function Get-FMPHolderPerformanceSummary { 
 

    <#
        .SYNOPSIS
            Retrieves the performance summary of institutional holders for a specified company.

        .DESCRIPTION
            Uses the Financial Modeling Prep API to obtain insights into the performance of institutional investors
            based on their stock holdings. This function calls the Holder Performance Summary endpoint from the
            "Institutional Ownership" category.

        .PARAMETER CIK
            The Central Index Key (CIK) for the company (e.g., "0001067983").

        .PARAMETER Page
            (Optional) The page number for paging through results. Default is 0.

        .PARAMETER ApiKey
            Your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it using Get-FMPCredential.

        .EXAMPLE
            Get-FMPHolderPerformanceSummary -CIK "0001067983" -Page 0

        .NOTES
            This is a premium endpoint, and requires a paid subscription. This function uses the Holder Performance Summary API endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/holder-performance-summary
    #>

    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true)]
        [string] $CIK,

        [Parameter(Mandatory = $false)]
        [int] $Page = 0,

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/stable/institutional-ownership/holder-performance-summary"
    }

    Process {
        $url = "{0}?cik={1}&page={2}&apikey={3}" -f $baseUrl, $CIK, $Page, $ApiKey
        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving holder performance summary: $_"
        }
    }
 
 };


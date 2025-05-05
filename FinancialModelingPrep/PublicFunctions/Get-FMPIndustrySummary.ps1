function Get-FMPIndustrySummary { 
 

    <#
        .SYNOPSIS
            Retrieves a summary of industry performance data.

        .DESCRIPTION
            Uses the Financial Modeling Prep API to obtain an industry summary from institutional ownership data.
            Optionally filter the data by fiscal year and quarter.

        .PARAMETER Year
            (Optional) Fiscal year to filter the data.

        .PARAMETER Quarter
            (Optional) Fiscal quarter to filter the data. Valid values: Q1, Q2, Q3, Q4.

        .PARAMETER ApiKey
            Your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it using Get-FMPCredential.

        .EXAMPLE
            Get-FMPIndustrySummary -Year 2023 -Quarter Q3

        .NOTES
            This is a premium endpoint, and requires a paid subscription. This function uses the Industry Summary API endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/industry-summary
    #>

    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $false)]
        [int] $Year,

        [Parameter(Mandatory = $false)]
        [ValidateSet("Q1", "Q2", "Q3", "Q4")]
        [string] $Quarter,

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/stable/institutional-ownership/industry-summary"
    }

    Process {
        $queryParams = @{ apikey = $ApiKey }
        if ($Year) { $queryParams.year = $Year }
        if ($Quarter) { $queryParams.quarter = $Quarter }
        $queryString = ($queryParams.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" }) -join "&"
        $url = "{0}?{1}" -f $baseUrl, $queryString

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving industry summary data: $_"
        }
    }
 
 };


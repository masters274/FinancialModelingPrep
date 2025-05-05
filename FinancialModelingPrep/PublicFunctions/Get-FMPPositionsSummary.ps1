function Get-FMPPositionsSummary { 
 

    <#
        .SYNOPSIS
            Retrieves a snapshot summary of institutional holdings for a given stock symbol.

        .DESCRIPTION
            Uses the Financial Modeling Prep API to return a positions summary for the specified company.
            Optionally, you can filter the results by fiscal year and quarter.

        .PARAMETER Symbol
            The company's stock ticker (e.g., AAPL).

        .PARAMETER Year
            The fiscal year (e.g., 2023).

        .PARAMETER Quarter
            The fiscal quarter (valid values: 1, 2, 3, 4).

        .PARAMETER ApiKey
            Your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it using Get-FMPCredential.

        .EXAMPLE
            Get-FMPPositionsSummary -Symbol AAPL -Year 2023 -Quarter 3

        .NOTES
            This is a premium endpoint, and requires a paid subscription. This function uses the Positions Summary API endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/positions-summary
    #>

    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true)]
        [string] $Symbol,

        [Parameter(Mandatory = $true)]
        [int] $Year,

        [Parameter(Mandatory = $true)]
        [ValidateSet("1", "2", "3", "4")]
        [string] $Quarter,

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/stable/institutional-ownership/symbol-positions-summary"
    }

    Process {
        $queryParams = @{ symbol = $Symbol; apikey = $ApiKey }
        if ($Year) { $queryParams.year = $Year }
        if ($Quarter) { $queryParams.quarter = $Quarter }

        $queryString = ($queryParams.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" }) -join "&"
        $url = "{0}?{1}" -f $baseUrl, $queryString

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving positions summary data: $_"
        }
    }
 
 };


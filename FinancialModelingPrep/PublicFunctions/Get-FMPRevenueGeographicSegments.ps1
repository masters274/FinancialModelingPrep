function Get-FMPRevenueGeographicSegments { 
 

    <#
        .SYNOPSIS
            Retrieves a breakdown of a company's revenue by geographic region.

        .DESCRIPTION
            Uses the Financial Modeling Prep API to obtain revenue segmentation data by geographic region for the specified company.

        .PARAMETER Symbol
            The company's stock ticker (e.g., AAPL).

        .PARAMETER Structure
            An optional format parameter (e.g., "flat"). If not provided, the API defaults are used.

        .PARAMETER ApiKey
            Your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it using Get-FMPCredential.

        .EXAMPLE
            Get-FMPRevenueGeographicSegments -Symbol AAPL -Structure flat
    #>

    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true)]
        [string] $Symbol,

        [Parameter(Mandatory = $false)]
        [string] $Structure,

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/stable/revenue-geographic-segmentation"
    }

    Process {
        $queryParams = @{ symbol = $Symbol; apikey = $ApiKey }
        if ($Structure) { $queryParams.structure = $Structure }
        $queryString = ($queryParams.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" }) -join "&"
        $url = "{0}?{1}" -f $baseUrl, $queryString

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving revenue geographic segments data: $_"
        }
    }
 
 };


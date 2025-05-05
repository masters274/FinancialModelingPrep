function Get-FMPEarningsTranscriptList { 
 

    <#
        .SYNOPSIS
            Retrieves a list of available earnings call transcripts using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPEarningsTranscriptList function fetches data about available earnings call transcripts
            for publicly traded companies. This information helps investors and analysts access verbal
            commentary from company management during earnings calls. Optional parameters allow filtering
            by symbol, quarter, and year.
            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential
            function and will prompt the user if necessary.

        .PARAMETER Symbol
            Specifies the stock symbol for which to retrieve earnings transcript information (e.g., AAPL).
            This parameter is optional. If omitted, transcripts for all available companies will be returned.

        .PARAMETER Quarter
            Specifies the fiscal quarter for filtering transcript results (e.g., "Q1", "Q2", "Q3", "Q4").
            This parameter is optional.

        .PARAMETER Year
            Specifies the year for filtering transcript results (e.g., 2023).
            This parameter is optional.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it
            using Get-FMPCredential.

        .EXAMPLE
            Get-FMPEarningsTranscriptList

            Retrieves a list of all available earnings call transcripts.

        .EXAMPLE
            Get-FMPEarningsTranscriptList -Symbol AAPL

            Retrieves a list of earnings call transcripts for Apple Inc.

        .EXAMPLE
            Get-FMPEarningsTranscriptList -Symbol MSFT -Quarter Q1 -Year 2023

            Retrieves earnings call transcripts for Microsoft Corporation for Q1 2023.

        .NOTES
            This function utilizes the Financial Modeling Prep API's Earnings Transcript List endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/earnings-transcript-list
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $false)]
        [string] $Symbol,

        [Parameter(Mandatory = $false)]
        [ValidateSet("Q1", "Q2", "Q3", "Q4")]
        [string] $Quarter,

        [Parameter(Mandatory = $false)]
        [int] $Year,

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/stable/earnings-transcript-list"
    }

    Process {
        # Build query parameters
        $queryParams = @{ apikey = $ApiKey }

        if ($Symbol) { $queryParams.symbol = $Symbol }
        if ($Quarter) { $queryParams.quarter = $Quarter }
        if ($Year) { $queryParams.year = $Year }

        # Create query string
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
            throw "Error retrieving earnings transcript list: $_"
        }
    }
 
 };


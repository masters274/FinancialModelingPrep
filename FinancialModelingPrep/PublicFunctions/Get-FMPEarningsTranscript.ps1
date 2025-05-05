function Get-FMPEarningsTranscript { 
 

    <#
        .SYNOPSIS
            Retrieves earnings call transcripts for a specified company.

        .DESCRIPTION
            The Get-FMPEarningsTranscript function fetches earnings call transcripts for a given company symbol.
            It provides access to the full text of earnings calls, which includes management discussions,
            financial performance reviews, and Q&A sessions with analysts.

        .PARAMETER Symbol
            Specifies the stock symbol of the company to retrieve transcript data for (e.g., AAPL).
            This parameter is mandatory.

        .PARAMETER Quarter
            Specifies which quarter's transcript to retrieve.
            Valid values include: "Q1", "Q2", "Q3", or "Q4".
            This parameter is mandatory.

        .PARAMETER Year
            Specifies the year of the transcript to retrieve (e.g., 2023).
            This parameter is mandatory.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it
            using Get-FMPCredential.

        .EXAMPLE
            Get-FMPEarningsTranscript -Symbol AAPL -Quarter Q1 -Year 2023

            Retrieves Apple Inc.'s Q1 2023 earnings call transcript.

        .NOTES
            This function uses the Financial Modeling Prep API's Earnings Transcript endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/earnings-transcript
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [string] $Symbol,

        [Parameter(Mandatory = $true)]
        [ValidateSet("Q1", "Q2", "Q3", "Q4")]
        [string] $Quarter,

        [Parameter(Mandatory = $true)]
        [int] $Year,

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/stable/earning-call-transcript-latest"
    }

    Process {
        $url = "{0}?symbol={1}&quarter={2}&year={3}&apikey={4}" -f $baseUrl, $Symbol, $Quarter, $Year, $ApiKey

        $headers = @{
            "Upgrade-Insecure-Requests" = "1"
        }

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving earnings transcript: $_"
        }
    }
 
 };


function Get-FMPIndexQuote { 
 

    <#
        .SYNOPSIS
            Retrieves index quote data (full or short) for the specified symbol.

        .DESCRIPTION
            Uses the Financial Modeling Prep API to obtain either a full index quote or a short index quote, based on the Mode parameter.

        .PARAMETER Symbol
            The index symbol (e.g., ^GSPC).

        .PARAMETER Mode
            Specifies the type of quote data: "Full" returns detailed data, while "Short" returns concise data. Default is "Full".

        .PARAMETER ApiKey
            Your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it using Get-FMPCredential.

        .EXAMPLE
            Get-FMPIndexQuote -Symbol '^GSPC' -Mode Full

            Retrieves the full index quote data for the S&P 500 index.

        .NOTES
            This function uses the Index Quote API endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/index-quote and
            https://site.financialmodelingprep.com/developer/docs/stable/index-quote-short
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [string] $Symbol,

        [Parameter(Mandatory = $false)]
        [ValidateSet("Full", "Short")]
        [string] $Mode = "Short",

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Enter your Financial Modeling Prep API key"
        }
        switch ($Mode) {
            "Full" { $baseUrl = "https://financialmodelingprep.com/stable/quote" }
            "Short" { $baseUrl = "https://financialmodelingprep.com/stable/quote-short" }
        }
    }

    Process {
        $url = "{0}/?symbol={1}&apikey={2}" -f $baseUrl, $Symbol, $ApiKey
        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving index quote data: $_"
        }
    }
 
 };


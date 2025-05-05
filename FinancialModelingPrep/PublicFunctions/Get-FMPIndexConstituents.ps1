function Get-FMPIndexConstituents { 
 

    <#
        .SYNOPSIS
            Retrieves the list of index constituents.

        .DESCRIPTION
            Uses the Financial Modeling Prep API to return the companies that make up the specified index.
            Supported indexes are S&P 500, Nasdaq, and Dow Jones.

        .PARAMETER IndexType
            Specifies the index type. Valid values are "sp500", "nasdaq", and "dowjones".

        .PARAMETER ApiKey
            Your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it using Get-FMPCredential.

        .EXAMPLE
            Get-FMPIndexConstituents -IndexType sp500

            Retrieves the constituents for the S&P 500 index.

        .NOTES
            This is a premium endpoint, and requires a paid subscription. This function uses the Index Constituents API endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/sp-500 ,
            https://site.financialmodelingprep.com/developer/docs/stable/nasdaq , https://site.financialmodelingprep.com/developer/docs/stable/dow-jones
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [ValidateSet("sp500", "nasdaq", "dowjones")]
        [string] $IndexType,

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Enter your Financial Modeling Prep API key"
        }
        switch ($IndexType) {
            "sp500" { $baseUrl = "https://financialmodelingprep.com/api/v3/sp500_constituent" }
            "nasdaq" { $baseUrl = "https://financialmodelingprep.com/api/v3/nasdaq_constituent" }
            "dowjones" { $baseUrl = "https://financialmodelingprep.com/api/v3/dowjones_constituent" }
        }
    }

    Process {
        $url = "{0}?apikey={1}" -f $baseUrl, $ApiKey
        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving $IndexType constituents: $_"
        }
    }
 
 };


function Get-FMPSenateTradingActivity { 
 

    <#
        .SYNOPSIS
            Retrieves trading activity data for U.S. Senators.

        .DESCRIPTION
            The Get-FMPSenateTradingActivity function fetches detailed information about
            trading activities conducted by members of the U.S. Senate, including transaction
            dates, assets traded, and transaction amounts.

        .PARAMETER Symbol
            Specifies the stock symbol to filter results (e.g., AAPL).
            This parameter is optional.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts
            to retrieve it using Get-FMPCredential.

        .EXAMPLE
            Get-FMPSenateTradingActivity -Symbol "AAPL"

            Retrieves trading activity by U.S. Senators involving Apple stock.

        .NOTES
            This function uses the Financial Modeling Prep API's Senate Trading Activity endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/senate-trading
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $false)]
        [string] $Symbol,

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/stable/senate-trades"
    }

    Process {
        $queryParams = @{ apikey = $ApiKey }

        if ($Symbol) { $queryParams.symbol = $Symbol }

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
            throw "Error retrieving Senate trading activity: $_"
        }
    }
 
 };


function Get-FMPETFInformation { 
 

    <#
        .SYNOPSIS
            Retrieves general information and profile data for a specified ETF.

        .DESCRIPTION
            The Get-FMPETFInformation function fetches comprehensive profile information for a given ETF.
            This includes data about the fund's investment strategy, assets under management, expense ratio,
            issuer information, inception date, and other important fund characteristics.

            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential function
            and will prompt the user if necessary.

        .PARAMETER Symbol
            Specifies the ETF symbol (e.g., SPY, QQQ). This parameter is mandatory.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it
            using Get-FMPCredential.

        .EXAMPLE
            Get-FMPETFInformation -Symbol SPY

            Retrieves the profile information for the SPDR S&P 500 ETF.

        .NOTES
            This is a premium endpoint, and requires a paid subscription. This function uses the Financial Modeling Prep API's ETF Information endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/information
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [string] $Symbol,

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/stable/etf/info"
    }

    Process {
        $url = "{0}?symbol={1}&apikey={2}" -f $baseUrl, $Symbol, $ApiKey

        $headers = @{
            "Upgrade-Insecure-Requests" = "1"
        }

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving ETF information: $_"
        }
    }
 
 };


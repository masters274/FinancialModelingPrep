function Get-FMPETFAssetExposure { 
 

    <#
        .SYNOPSIS
            Retrieves the asset class exposure data for a specified ETF.

        .DESCRIPTION
            The Get-FMPETFAssetExposure function fetches detailed information about a given ETF's
            exposure to different asset classes (such as stocks, bonds, cash, etc.).
            This helps investors understand the asset allocation and risk profile of their ETF investments.

            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential function
            and will prompt the user if necessary.

        .PARAMETER Symbol
            Specifies the ETF symbol (e.g., VBINX, AOA). This parameter is mandatory.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it
            using Get-FMPCredential.

        .EXAMPLE
            Get-FMPETFAssetExposure -Symbol VBINX

            Retrieves the asset class exposure for the Vanguard Balanced Index Fund.

        .NOTES
            This is a premium endpoint, and requires a paid subscription. This function uses the Financial Modeling Prep API's ETF Asset Exposure endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/etf-asset-exposure
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
        $baseUrl = "https://financialmodelingprep.com/stable/etf/asset-exposure"
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
            throw "Error retrieving ETF asset exposure data: $_"
        }
    }
 
 };


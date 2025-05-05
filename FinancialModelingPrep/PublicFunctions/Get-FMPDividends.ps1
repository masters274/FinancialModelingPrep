function Get-FMPDividends { 
 

    <#
        .SYNOPSIS
            Retrieves dividend payment details for a specified stock symbol using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPDividends function fetches dividend data for individual stock symbols, including important dates
            such as the record date, payment date, and declaration date, as well as dividend amounts and yield information.
            This tool is useful for staying informed about upcoming dividend payments. The function supports a limit parameter
            to control the number of records retrieved. If no API key is provided, the function attempts to retrieve it using
            the Get-FMPCredential function and prompts the user if necessary.

        .PARAMETER Symbol
            Specifies the stock symbol for which dividend data is to be retrieved (e.g., AAPL). This parameter is mandatory.

        .PARAMETER Limit
            Specifies the maximum number of dividend records to return. The default value is 5, which is the max for the free version.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it using Get-FMPCredential.

        .EXAMPLE
            Get-FMPDividends -Symbol AAPL -Limit 5

            This example retrieves dividend data for Apple Inc. with up to 100 records using your Financial Modeling Prep API key.

        .NOTES
            This function utilizes the FMP Dividends Company API endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/dividends-company
    #>

    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true)]
        [string] $Symbol,

        [Parameter(Mandatory = $false)]
        [int] $Limit = 5,

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/stable/dividends"
    }

    Process {
        $url = "{0}?symbol={1}&limit={2}&apikey={3}" -f $baseUrl, $Symbol, $Limit, $ApiKey

        $headers = @{
            "Upgrade-Insecure-Requests" = "1"
        }

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving dividend data: $_"
        }
    }
 
 };


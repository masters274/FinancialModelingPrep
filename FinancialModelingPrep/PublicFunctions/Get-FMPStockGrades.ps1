function Get-FMPStockGrades { 
 

    <#
        .SYNOPSIS
            Retrieves the latest stock grades for a specified stock symbol using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPStockGrades function accesses the Financial Modeling Prep API to fetch the most recent grading actions,
            such as upgrades, downgrades, or maintained ratings, provided by top analysts and financial institutions. The data
            includes the grading company, the previous grade, the new grade, and the action taken for the given stock symbol.
            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential function and prompts
            the user if necessary.

        .PARAMETER Symbol
            Specifies the stock symbol for which the stock grades are to be retrieved (e.g., AAPL). This parameter is mandatory.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it using the Get-FMPCredential
            function and will prompt the user if necessary.

        .EXAMPLE
            Get-FMPStockGrades -Symbol AAPL

            This example retrieves the latest stock grades for Apple Inc. using your Financial Modeling Prep API key.

        .NOTES
            This function utilizes the Financial Modeling Prep API's Grades endpoint.
            For more information, visit: https://financialmodelingprep.com
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
        $baseUrl = "https://financialmodelingprep.com/stable/grades"
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
            throw "Error retrieving FMP stock grades: $_"
        }
    }
 
 };


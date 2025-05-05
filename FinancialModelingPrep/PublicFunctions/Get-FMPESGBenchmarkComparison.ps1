function Get-FMPESGBenchmarkComparison { 
 

    <#
        .SYNOPSIS
            Retrieves ESG benchmark comparison data for a specified fiscal year using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPESGBenchmarkComparison function fetches ESG performance data for various sectors for the given fiscal year.
            This data allows you to compare the Environmental, Social, and Governance (ESG) scores across industries, helping you
            evaluate ESG leaders and laggards to make informed and responsible investment decisions.
            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential function and will prompt
            the user if necessary.

        .PARAMETER Year
            Specifies the fiscal year for which to retrieve the ESG benchmark data (e.g., 2023). This parameter is mandatory.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it using Get-FMPCredential.

        .EXAMPLE
            Get-FMPESGBenchmarkComparison -Year "2023"

            This example retrieves the ESG benchmark comparison data for the fiscal year 2023 using your Financial Modeling Prep API key.

        .NOTES
            This is a premium function, and requires a paid subscription. This function utilizes the Financial Modeling Prep ESG Benchmark Comparison API endpoint.
            For more information, visit: https://financialmodelingprep.com
    #>

    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true)]
        [string] $Year,

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/stable/esg-benchmark"
    }

    Process {
        $url = "{0}?year={1}&apikey={2}" -f $baseUrl, $Year, $ApiKey
        $headers = @{
            "Upgrade-Insecure-Requests" = "1"
        }

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving ESG benchmark comparison data: $_"
        }
    }
 
 };


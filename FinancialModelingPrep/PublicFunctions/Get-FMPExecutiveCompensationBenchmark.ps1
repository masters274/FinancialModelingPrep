function Get-FMPExecutiveCompensationBenchmark { 
 

    <#
        .SYNOPSIS
            Retrieves average executive compensation data across various industries using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPExecutiveCompensationBenchmark function fetches benchmark data for executive compensation,
            including average compensation figures by industry and year. This enables comparisons of executive pay
            across various sectors to understand compensation trends and benchmarks. If no API key is provided, the function
            attempts to retrieve it using the Get-FMPCredential function and will prompt the user if necessary.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function will attempt to retrieve it using
            Get-FMPCredential and prompt the user if necessary.

        .EXAMPLE
            Get-FMPExecutiveCompensationBenchmark

            This example retrieves the average executive compensation data across various industries using your Financial Modeling Prep API key.

        .NOTES
            This is a premium endpoint, and requires a paid subscription. This function utilizes the Financial Modeling Prep API's Executive Compensation Benchmark endpoint.
            For more information, visit: https://financialmodelingprep.com
    #>

    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }

        $baseUrl = "https://financialmodelingprep.com/stable/executive-compensation-benchmark"
    }

    Process {
        $url = "{0}?apikey={1}" -f $baseUrl, $ApiKey

        $headers = @{
            "Upgrade-Insecure-Requests" = "1"
        }

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving executive compensation benchmark data: $_"
        }
    }
 
 };


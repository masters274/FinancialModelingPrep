function Get-FMPForm10KXLSX { 
 

    <#
        .SYNOPSIS
            Retrieves the annual Form 10-K report in XLSX format using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPForm10KXLSX function downloads a comprehensive annual Form 10-K report for a specified company in Excel (XLSX) format.
            This report includes detailed information about the company's financial performance, business operations, and risk factors as filed with the SEC.
            The function accepts a stock ticker symbol, fiscal year, and an optional period type (default is "FY") along with an optional OutFile parameter to specify
            where the report should be saved. If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential function and prompts the user if necessary.

        .PARAMETER Symbol
            Specifies the stock ticker symbol of the company (e.g., AAPL). This parameter is mandatory.

        .PARAMETER Year
            Specifies the fiscal year for which to retrieve the Form 10-K report (e.g., 2022). This parameter is mandatory.

        .PARAMETER Period
            Specifies the period type of the report. Valid values are "FY", "Q1", "Q2", "Q3", and "Q4". The default value is "FY".

        .PARAMETER OutFile
            Specifies the destination file path for the downloaded XLSX report.
            If omitted, the function generates a default file name in the current directory in the format "Symbol-10K-Year-Period.xlsx".

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it using Get-FMPCredential.

        .EXAMPLE
            Get-FMPForm10KXLSX -Symbol AAPL -Year 2022

            This example downloads the annual Form 10-K report for Apple Inc. for the fiscal year 2022 and saves it with a default file name.

        .NOTES
            This function uses the Financial Reports Form 10-K XLSX API endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/financial-reports-form-10-k-xlsx
    #>

    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true)]
        [string] $Symbol,

        [Parameter(Mandatory = $true)]
        [int] $Year,

        [Parameter(Mandatory = $false)]
        [ValidateSet("FY", "Q1", "Q2", "Q3", "Q4")]
        [string] $Period = "FY",

        [Parameter(Mandatory = $false)]
        [string] $OutFile,

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/stable/financial-reports-xlsx"
        if (-not $OutFile) {
            $OutFile = "$($Symbol)-10K-$($Year)-$($Period).xlsx"
        }
    }

    Process {
        $url = "{0}?symbol={1}&year={2}&period={3}&apikey={4}" -f $baseUrl, $Symbol, $Year, $Period, $ApiKey

        $headers = @{
            "Upgrade-Insecure-Requests" = "1"
        }

        try {
            Invoke-WebRequest -Uri $url -Method Get -Headers $headers -OutFile $OutFile -ErrorAction Stop
            Write-Output "File saved to: $OutFile"
        }
        catch {
            throw "Error retrieving Form 10-K XLSX data: $_"
        }
    }
 
 };


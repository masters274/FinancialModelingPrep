function Get-FMPFilingsExtract { 
 

    <#
        .SYNOPSIS
            Retrieves extracted SEC filings data using the Financial Modeling Prep API.

        .DESCRIPTION
            Uses the Financial Modeling Prep Institutional Ownership Extract API to obtain detailed extracted data
            from SEC filings. You can specify a company by CIK, and filter results by year and quarter.

        .PARAMETER CIK
            The Central Index Key (CIK) of the company (e.g., "0001388838").

        .PARAMETER Year
            The filing year (e.g., 2023).

        .PARAMETER Quarter
            The filing quarter (e.g., 1, 2, 3, or 4).

        .PARAMETER Symbol
            (Deprecated) The stock ticker symbol. Use CIK parameter instead for the new endpoint.
            Included for backward compatibility.

        .PARAMETER FilingType
            (Deprecated) The filing type. Use Year and Quarter parameters instead for the new endpoint.
            Included for backward compatibility.

        .PARAMETER ApiKey
            Your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it using Get-FMPCredential.

        .EXAMPLE
            Get-FMPFilingsExtract -CIK "0001388838" -Year 2023 -Quarter 3

            Retrieves extracted data from Q3 2023 filings for the company with CIK 0001388838.

        .NOTES
            This is a premium endpoint, and requires a paid subscription. This function uses the Financial Modeling Prep Institutional Ownership Extract API endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/filings-extract
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $false, ParameterSetName = "NewAPI")]
        [string] $CIK,

        [Parameter(Mandatory = $false, ParameterSetName = "NewAPI")]
        [int] $Year,

        [Parameter(Mandatory = $false, ParameterSetName = "NewAPI")]
        [ValidateRange(1, 4)]
        [int] $Quarter,

        [Parameter(Mandatory = $false, ParameterSetName = "LegacyAPI")]
        [string] $Symbol,

        [Parameter(Mandatory = $false, ParameterSetName = "LegacyAPI")]
        [string] $FilingType,

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Enter your Financial Modeling Prep API key"
        }

        # Determine which API endpoint to use based on parameters provided
        if ($PSCmdlet.ParameterSetName -eq "NewAPI" -or ($CIK -and ($Year -or $Quarter))) {
            $baseUrl = "https://financialmodelingprep.com/stable/institutional-ownership/extract"
            $usingNewApi = $true
        }
        else {
            $baseUrl = "https://financialmodelingprep.com/api/v3/filings-extract"
            $usingNewApi = $false
        }
    }

    Process {
        $queryParams = @{ apikey = $ApiKey }

        if ($usingNewApi) {
            # New API parameters
            if ($CIK) { $queryParams.cik = $CIK }
            if ($Year) { $queryParams.year = $Year }
            if ($Quarter) { $queryParams.quarter = $Quarter }
        }
        else {
            # Legacy API parameters
            if ($Symbol) { $queryParams.symbol = $Symbol }
            if ($FilingType) { $queryParams.filingType = $FilingType }
        }

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
            throw "Error retrieving filings extract data: $_"
        }
    }
 
 };


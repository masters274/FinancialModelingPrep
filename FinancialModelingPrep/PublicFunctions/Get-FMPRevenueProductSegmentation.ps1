function Get-FMPRevenueProductSegmentation { 
 

    <#
        .SYNOPSIS
            Retrieves a breakdown of a company's revenue by product category using the Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPRevenueProductSegmentation function fetches the revenue segmentation data for a given company.
            This data shows how the company's revenue is distributed across different product lines or segments,
            thereby offering insights into which products drive its earnings. This function uses the Revenue Product Segmentation API.

        .PARAMETER Symbol
            Specifies the stock ticker symbol of the company (e.g., AAPL). This parameter is mandatory.

        .PARAMETER Period
            Specifies the period type for the report (e.g., "annual", "quarter"). This parameter is optional.
            If omitted, the API's default behavior will be applied.

        .PARAMETER Structure
            Specifies the structure of the returned data. For example, "flat" or other supported formats by the API.
            This parameter is optional.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it using Get-FMPCredential.

        .EXAMPLE
            Get-FMPRevenueProductSegmentation -Symbol AAPL -Period annual -Structure flat

            This example retrieves the annual revenue product segmentation data for Apple Inc. with a flat structure.

        .NOTES
            This function uses the Revenue Product Segmentation API endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/revenue-product-segmentation
    #>

    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true)]
        [string] $Symbol,

        [Parameter(Mandatory = $false)]
        [string] $Period,

        [Parameter(Mandatory = $false)]
        [string] $Structure,

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/stable/revenue-product-segmentation"
    }

    Process {

        $queryParams = @{ symbol = $Symbol; apikey = $ApiKey }
        if ($Period) { $queryParams.period = $Period }
        if ($Structure) { $queryParams.structure = $Structure }

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
            throw "Error retrieving revenue product segmentation data: $_"
        }
    }
 
 };


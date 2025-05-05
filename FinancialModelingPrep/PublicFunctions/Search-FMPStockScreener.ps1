function Search-FMPStockScreener { 
 

    <#
        .SYNOPSIS
            Discovers stocks that align with specific investment criteria using the FMP Stock Screener API.

        .DESCRIPTION
            The Search-FMPStockScreener function retrieves stocks based on various filter criteria including market cap, price,
            volume, beta, sector, industry, dividend yield, exchange, country, and more. Use this function to identify opportunities
            that match your investment strategy. Users can specify filters such as a lower or upper limit on market cap, price,
            beta, volume, dividend, etc., as well as specify if they want only ETFs, funds, or actively trading stocks.
            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential function and will prompt
            the user if necessary.

        .PARAMETER marketCapMoreThan
            Returns stocks with a market capitalization greater than the specified value.

        .PARAMETER marketCapLowerThan
            Returns stocks with a market capitalization lower than the specified value.

        .PARAMETER sector
            Filters stocks by a specific sector (e.g., "Technology").

        .PARAMETER industry
            Filters stocks by a specific industry (e.g., "Consumer Electronics").

        .PARAMETER betaMoreThan
            Returns stocks with a beta greater than the specified value.

        .PARAMETER betaLowerThan
            Returns stocks with a beta lower than the specified value.

        .PARAMETER priceMoreThan
            Returns stocks with a price greater than the specified value.

        .PARAMETER priceLowerThan
            Returns stocks with a price lower than the specified value.

        .PARAMETER dividendMoreThan
            Returns stocks with an annual dividend greater than the specified value.

        .PARAMETER dividendLowerThan
            Returns stocks with an annual dividend lower than the specified value.

        .PARAMETER volumeMoreThan
            Returns stocks with a trading volume greater than the specified value.

        .PARAMETER volumeLowerThan
            Returns stocks with a trading volume lower than the specified value.

        .PARAMETER exchange
            Filters stocks based on the specified exchange (e.g., "NASDAQ").

        .PARAMETER country
            Filters stocks based on the specified country code (e.g., "US").

        .PARAMETER isEtf
            Specifies whether to filter only ETFs (true/false).

        .PARAMETER isFund
            Specifies whether to filter only funds (true/false).

        .PARAMETER isActivelyTrading
            Specifies whether to filter only stocks that are actively trading (true/false).

        .PARAMETER limit
            Specifies the maximum number of results to return. The default value is 1000.

        .PARAMETER includeAllShareClasses
            Specifies whether to include all share classes (true/false).

        .PARAMETER ApiKey
            Your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it using Get-FMPCredential.

        .EXAMPLE
            Search-FMPStockScreener -marketCapMoreThan 1000000 -marketCapLowerThan 1000000000 `
            -sector "Technology" -industry "Consumer Electronics"

            This example retrieves stocks on the NASDAQ with the specified filters.

        .NOTES
            This is a premium endpoint, and requires a paid subscription. This function uses the Financial Modeling Prep Stock Screener API endpoint.
            For more information, visit: https://financialmodelingprep.com
    #>

    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $false)]
        [double] $marketCapMoreThan,

        [Parameter(Mandatory = $false)]
        [double] $marketCapLowerThan,

        [Parameter(Mandatory = $false)]
        [string] $sector,

        [Parameter(Mandatory = $false)]
        [string] $industry,

        [Parameter(Mandatory = $false)]
        [double] $betaMoreThan,

        [Parameter(Mandatory = $false)]
        [double] $betaLowerThan,

        [Parameter(Mandatory = $false)]
        [double] $priceMoreThan,

        [Parameter(Mandatory = $false)]
        [double] $priceLowerThan,

        [Parameter(Mandatory = $false)]
        [double] $dividendMoreThan,

        [Parameter(Mandatory = $false)]
        [double] $dividendLowerThan,

        [Parameter(Mandatory = $false)]
        [double] $volumeMoreThan,

        [Parameter(Mandatory = $false)]
        [double] $volumeLowerThan,

        [Parameter(Mandatory = $false)]
        [string] $exchange,

        [Parameter(Mandatory = $false)]
        [string] $country,

        [Parameter(Mandatory = $false)]
        [bool] $isEtf,

        [Parameter(Mandatory = $false)]
        [bool] $isFund,

        [Parameter(Mandatory = $false)]
        [bool] $isActivelyTrading,

        [Parameter(Mandatory = $false)]
        [int] $limit = 1000,

        [Parameter(Mandatory = $false)]
        [bool] $includeAllShareClasses,

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/stable/company-screener"
        # Initialize URL with mandatory API key
        $url = "{0}?apikey={1}" -f $baseUrl, $ApiKey
    }

    Process {
        if ($marketCapMoreThan) { $url += "&marketCapMoreThan=" + $marketCapMoreThan }
        if ($marketCapLowerThan) { $url += "&marketCapLowerThan=" + $marketCapLowerThan }
        if ($sector) { $url += "&sector=" + $sector }
        if ($industry) { $url += "&industry=" + $industry }
        if ($betaMoreThan) { $url += "&betaMoreThan=" + $betaMoreThan }
        if ($betaLowerThan) { $url += "&betaLowerThan=" + $betaLowerThan }
        if ($priceMoreThan) { $url += "&priceMoreThan=" + $priceMoreThan }
        if ($priceLowerThan) { $url += "&priceLowerThan=" + $priceLowerThan }
        if ($dividendMoreThan) { $url += "&dividendMoreThan=" + $dividendMoreThan }
        if ($dividendLowerThan) { $url += "&dividendLowerThan=" + $dividendLowerThan }
        if ($volumeMoreThan) { $url += "&volumeMoreThan=" + $volumeMoreThan }
        if ($volumeLowerThan) { $url += "&volumeLowerThan=" + $volumeLowerThan }
        if ($exchange) { $url += "&exchange=" + $exchange }
        if ($country) { $url += "&country=" + $country }
        if ($isEtf -ne $null) { $url += "&isEtf=" + $isEtf.ToString().ToLower() }
        if ($isFund -ne $null) { $url += "&isFund=" + $isFund.ToString().ToLower() }
        if ($isActivelyTrading -ne $null) { $url += "&isActivelyTrading=" + $isActivelyTrading.ToString().ToLower() }
        if ($limit) { $url += "&limit=" + $limit }
        if ($includeAllShareClasses -ne $null) { $url += "&includeAllShareClasses=" + $includeAllShareClasses.ToString().ToLower() }

        $headers = @{
            "Upgrade-Insecure-Requests" = "1"
        }

        Write-Verbose "Request URL: $url"

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving stock screener data: $_"
        }
    }
 
 };


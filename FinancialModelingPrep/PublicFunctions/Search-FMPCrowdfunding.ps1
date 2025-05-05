function Search-FMPCrowdfunding { 
 

    <#
        .SYNOPSIS
            Searches for crowdfunding offerings by company name using the Financial Modeling Prep API.

        .DESCRIPTION
            The Search-FMPCrowdfunding function allows you to search for crowdfunding offerings
            by specifying a search term for the company name. Results can be paginated using the Page parameter.

            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential function
            and will prompt the user if necessary.

        .PARAMETER Name
            Specifies the search term for the company name. This parameter is mandatory.

        .PARAMETER Page
            Specifies the page number for paginated results. The default value is 0.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it
            using Get-FMPCredential.

        .EXAMPLE
            Search-FMPCrowdfunding -Name "enotap"

            Searches for crowdfunding offerings from companies with "Tech" in their name, returning the first page of results.

        .NOTES
            This is a premium endpoint, and requires a paid subscription. This function uses the Financial Modeling Prep API's Crowdfunding Search endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/crowdfunding-search
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [string] $Name,

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/stable/crowdfunding-offerings-search"
    }

    Process {
        $url = "{0}?name={1}&apikey={2}" -f $baseUrl, [Uri]::EscapeDataString($Name), $ApiKey

        $headers = @{
            "Upgrade-Insecure-Requests" = "1"
        }

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error searching crowdfunding offerings: $_"
        }
    }
 
 };


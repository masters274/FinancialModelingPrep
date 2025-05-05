function Get-FMPLatestCrowdfunding { 
 

    <#
        .SYNOPSIS
            Retrieves the latest crowdfunding offerings data from Financial Modeling Prep API.

        .DESCRIPTION
            The Get-FMPLatestCrowdfunding function fetches the most recent crowdfunding offerings data.
            Results can be paginated using the Page parameter.

            If no API key is provided, the function attempts to retrieve it using the Get-FMPCredential function
            and will prompt the user if necessary.

        .PARAMETER Page
            Specifies the page number for paginated results. The default value is 0.

        .PARAMETER ApiKey
            Specifies your Financial Modeling Prep API key. If omitted, the function attempts to retrieve it
            using Get-FMPCredential.

        .EXAMPLE
            Get-FMPLatestCrowdfunding -Page 0

            Retrieves the first page of the latest crowdfunding offerings data.

        .NOTES
            This is a premium endpoint, and requires a paid subscription. This function uses the Financial Modeling Prep API's Latest Crowdfunding endpoint.
            For more information, visit: https://site.financialmodelingprep.com/developer/docs/stable/latest-crowdfunding
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $false)]
        [int] $Page = 0,

        [Parameter(Mandatory = $false)]
        [string] $ApiKey = (Get-FMPCredential)
    )

    Begin {
        if (-not $ApiKey) {
            $ApiKey = Read-Host "Please enter your Financial Modeling Prep API key"
        }
        $baseUrl = "https://financialmodelingprep.com/stable/crowdfunding-offerings-latest"
    }

    Process {
        $url = "{0}?page={1}&apikey={2}" -f $baseUrl, $Page, $ApiKey

        $headers = @{
            "Upgrade-Insecure-Requests" = "1"
        }

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ErrorAction Stop
            return $response
        }
        catch {
            throw "Error retrieving latest crowdfunding data: $_"
        }
    }
 
 };


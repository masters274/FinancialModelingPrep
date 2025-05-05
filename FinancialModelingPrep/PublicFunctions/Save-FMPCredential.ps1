function Save-FMPCredential { 
 
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $false)]
        [string] $ApiKey = $(Get-RHCCredentials -ApiKey)
    )

    $apiKeyVarName = 'FMPApiKey'


    $ApiKeySecureString = (
        ([PSCredential]::new('temp', ($ApiKey | ConvertTo-SecureString -AsPlainText -Force))).Password |
        ConvertFrom-SecureString
    )


    Remove-FMPCredential -ErrorAction SilentlyContinue

    Invoke-EnvironmentalVariable -Name $apiKeyVarName -Value $ApiKeySecureString -Scope User -Action New

    # When making a new environment variable, it is necessary to reload the profile to make it available.
    # This will make them available now
    Invoke-EnvironmentalVariable -Name $apiKeyVarName -Value $ApiKeySecureString -Scope Process -Action New
 
 };


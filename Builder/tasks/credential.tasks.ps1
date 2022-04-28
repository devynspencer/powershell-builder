# Synopsis: Cache build credentials
task Credentials {
    $CredentialParams = @{
        TypeName = 'System.Management.Automation.PSCredential'
        ArgumentList = $Config.RegistryUser, (ConvertTo-SecureString -AsPlainText $Config.RegistryToken -Force)
    }

    $script:RegistryCredential = New-Object @CredentialParams
}

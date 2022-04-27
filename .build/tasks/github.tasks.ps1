task ShowPackageIndex Credentials, {
    Write-Build Cyan "Retrieving registry index from [$($Config.RegistryIndexUri)] ..."

    $Response = Invoke-RestMethod -Uri $Config.RegistryIndexUri -Credential $RegistryCredential
    $Response.resources
}

task QueryPackageIndex Credentials, {
    $QueryUri = "$($Config.RegistryBaseUri)/query"
    Write-Build Cyan "Querying registry at [$QueryUri] ..."

    $Response = Invoke-RestMethod -Uri $QueryUri -Credential $RegistryCredential
    $Response.data
}

task QueryPackageVersions Credentials, {
    $QueryUri = "$($Config.RegistryBaseUri)/query"
    Write-Build Cyan "Retrieving package versions from [$QueryUri] ..."

    $Response = Invoke-RestMethod -Uri $QueryUri -Credential $RegistryCredential
    $Response.data.versions
}

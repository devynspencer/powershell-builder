# powershell-builder
Build scripts, templates, snippets, and utilities for developing modules, scripts, functions, tests, and whatever else.

## Profile
To save time when building modules in the future, specify default values for common parameters:

```powershell
# Microsoft.PowerShell_profile.ps1

$PSDefaultParameterValues = @{
    "Build-Module:Author" = "Greg Goodguy"
    "Build-Module:CompanyName" = "Helpful People, Inc."
    "Build-Module:Description" = "PowerShell module focused on x, y, and z."
    "Build-Module:Editor" = "VSCode"
    "Build-Module:License" = "MIT"
    "Build-Module:ModuleDirectories" = "public", "private", "data"
    "Build-Module:PowerShellVersion" = "7.2"
    "Build-Module:TemplateName" = "BasicModule"
    "Build-Module:GitHubUserName" = "%GITHUB_USERNAME%"
    "Build-Module:GitHubPackagesToken" = "%GITHUB_PACKAGES_TOKEN%"
    "Build-Module:PackageSourceName" = "Internal"
    "Build-Module:PackageSourceUri" = "https://nuget.pkg.github.com/%GITHUB_USERNAME%/index.json"
    "Build-Module:StagingPackageSourcePath" = "temp\staging"
}
```

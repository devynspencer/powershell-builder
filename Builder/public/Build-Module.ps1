function Build-Module {
    param (
        # Name of Plaster template to use
        [ValidateSet('BasicModule')]
        $TemplateName = 'BasicModule',

        # New-ModuleManifest parameter
        [Parameter(Mandatory)]
        $ModuleName,

        # Filepath of new module
        $Destination = ($env:PSModulePath -split ';')[0],

        # New-ModuleManifest parameter
        $Description,

        # New-ModuleManifest parameter
        $Version = '0.0.0',

        # New-ModuleManifest parameter
        $Author,

        # New-ModuleManifest parameter
        $CompanyName,

        # New-ModuleManifest parameter
        $PowerShellVersion = '5.1'
    )

    $PlasterParams = @{
        # Plaster
        TemplatePath = Join-Path -Path "$PSScriptRoot\..\templates" -ChildPath $TemplateName
        DestinationPath = Join-Path $Destination -ChildPath $ModuleName

        # Module manifest fields
        ModuleName = $ModuleName
        ModuleDescription = $Description
        ModuleVersion = $Version
        ModuleAuthor = $Author
        CompanyName = $CompanyName
        PowerShellVersion = $PowerShellVersion
    }

    Write-Host -ForegroundColor Cyan "Building module [$ModuleName] at [$DestinationPath] using template [$TemplateName]"
    Write-Host -ForgeoundColor DarkCyan "Using build configuration:`n`n$(ConvertTo-Json $PlasterParams)"

    Invoke-Plaster @PlasterParams
}

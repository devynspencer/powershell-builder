function Build-Module {
    param (
        # Name of Plaster template to use
        [ValidateSet('BasicModule')]
        $TemplateName = 'BasicModule',

        # New-ModuleManifest parameter
        [Parameter(Mandatory)]
        $ModuleName,

        # Filepath of new module
        [Parameter(Mandatory)]
        $Destination,

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
        DestinationPath = $Destination

        # Module manifest fields
        ModuleName = $ModuleName
        ModuleDescription = $Description
        ModuleVersion = $Version
        ModuleAuthor = $Author
        CompanyName = $CompanyName
        PowerShellVersion = $PowerShellVersion
    }

    Write-Host -ForegroundColor Cyan "Building module [$ModuleName] at [$DestinationPath] using template [$TemplateName]"

    Invoke-Plaster @PlasterParams
}

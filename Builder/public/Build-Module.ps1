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
        $PowerShellVersion = '5.1',

        [ValidateSet('None', 'MIT')]
        $License = 'MIT',

        [ValidateSet('None', 'VSCode')]
        $Editor = 'VSCode',

        [ValidateSet(
            'public',
            'private',
            'classes',
            'lib',
            'bin',
            'data',
            'templates'
        )]
        $ModuleDirectories = @('public', 'private')
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

        # Project structure
        Editor = $Editor
        License = $License # TODO: should these be passed to Invoke-Plaster only if specified?
        ModuleDirectories = $ModuleDirectories
    }

    Write-Host -ForegroundColor Cyan "Building module [$ModuleName] at [$DestinationPath] using template [$TemplateName]"
    Write-Host -ForgeoundColor DarkCyan "Using build configuration:`n`n$(ConvertTo-Json $PlasterParams)"

    Invoke-Plaster @PlasterParams
}

function Import-BuildPartial {
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ValidateScript({ Test-Path $_ })]
        $Path,

        [ValidatePattern('.*\.ps1$')]
        $Suffix = '*.ps1',

        [switch]
        $Recurse
    )

    $GetParams = @{
        Path = $Path
        Filter = $Suffix
        File = $true
    }

    if ($Recurse) {
        $GetParams.Recurse = $true
    }

    Write-Build -Color DarkCyan "Importing [$Suffix] partials from [$Path]"

    $PartialFiles = Get-ChildItem @GetParams

    foreach ($Partial in $PartialFiles) {
        Write-Build -Color Green "Importing partial: [$($Partial.Name)]"

        # Load the partial content
        . $Partial.FullName

        # Output the file object for convenience
        $Partial
    }
}

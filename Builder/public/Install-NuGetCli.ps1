function Install-NuGetCli {
    param (
        # NuGet client version to download
        $Version = 'latest',

        # Directory to download nuget.exe to, ideally somewhere on
        # the system environment path
        [Parameter(Mandatory)]
        [ValidateScript({ Test-Path $_ })]
        $Destination
    )

    $DownloadUri = "https://dist.nuget.org/win-x86-commandline/$Version/nuget.exe"
    $FilePath = "$Destination\nuget.exe"

    $null = Invoke-WebRequest -Uri $DownloadUri -OutFile $FilePath
}

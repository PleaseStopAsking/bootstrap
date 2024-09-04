$BaseModules = @{
    'Az'                  = 'latest'
}

# set psgallery as trusted
Set-PSRepository -Name 'PSGallery' -InstallationPolicy 'Trusted'

# install each module
foreach ($Module in $BaseModules.GetEnumerator()) {
    if ($Module.Value -ieq 'latest') {
        Install-Module -Name $Module.Key -AcceptLicense -Repository PSGallery
    }
    else {
        Install-Module -Name $Module.Key -RequiredVersion $Module.Value -AcceptLicense -Repository 'PSGallery'
    }
}

# copy ps profile to final location
$ProfilePath = $Profile.Substring(0, $Profile.lastIndexOf('/'))
if (!(Test-Path $ProfilePath)) {
    New-Item -Path $ProfilePath -ItemType 'Directory' -Force | Out-Null
}
Copy-Item -Path ./configs/powershell_profile.ps1 -Destination $Profile

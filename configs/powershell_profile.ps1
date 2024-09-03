#Requires -Modules Color

#region MODULES
Import-Module -Name 'Color'
#endregion

#region MISC
#endregion

#region FUNCTIONS
function Uninstall-OldModuleVersions {
    param (
        [Parameter(ParameterSetName = 'All')]
        [switch]$All,

        [Parameter(ParameterSetName = 'Name')]
        [string]$Name,

        [Parameter(ParameterSetName = 'All')]
        [Parameter(ParameterSetName = 'Name')]
        [switch]$InstallLatestVersion
    )

    <#
    .SYNOPSIS

    Removes old versions of installed modules and installs the latest version.

    .DESCRIPTION

    The Uninstall-OldModuleVersions function removes all but the latest version of installed modules.
    It then installs the latest version of each module.

    .PARAMETER Name
    Specifies the name of a specific module to update to manage.

    .PARAMETER All
    Perform action on all installed modules.

    .PARAMETER InstallLatestVersion
    Installs the latest version of each module.

    .INPUTS
    None

    .OUTPUTS
    None

    .EXAMPLE

    PS> Uninstall-OldModuleVersions -InstallLatestVersion -Name Color

    This command removes all but the latest version of the Color module and installs the latest version.
    #>

    if ($PSCmdlet.ParameterSetName -eq 'All') {
        $installedModules = Get-InstalledModule
    } else {
        $installedModules = Get-InstalledModule -Name $Name
    }

    $totalModules = $installedModules.Count
    $currentModule = 0

    foreach ($module in $installedModules) {
        $currentModule++

        # get all versions of the module
        $allVersions = Get-InstalledModule -Name $module.Name -AllVersions

        # if there's more than one version installed
        if ($allVersions.Count -gt 1) {
            # sort by version and select all but the latest version
            $oldVersions = $allVersions | Sort-Object -Property { $_.Version } | Select-Object -First ($allVersions.Count - 1)
            # uninstall old versions
            foreach ($oldVersion in $oldVersions) {
                Write-Host "Uninstalling $($oldVersion.Name) version $($oldVersion.Version)..."
                Uninstall-Module -Name $oldVersion.Name -RequiredVersion $oldVersion.Version -Force
            }
        }

        # install the latest version
        if ($InstallLatestVersion) {
            Write-Host "Installing latest version of $($module.Name)..."
            Update-Module -Name $module.Name -Force
        }

        # update progress bar
        Write-Progress -PercentComplete (($currentModule / $totalModules) * 100) -Status 'Processing Modules' -Activity "Processed $currentModule of $totalModules"
    }

    Write-Progress -Completed
}
#endregion

#region ALIASES

# list all files/folder
Set-Alias -Name 'l' -Value 'Get-ChildItem'

# Shortcuts
Set-Alias -Name 'd' -Value 'Set-Location -Path ~/Documents'
Set-Alias -Name 'dl' -Value 'Set-Location -Path ~/Downloads'
Set-Alias -Name 'dt' -Value 'Set-Location -Path ~/Desktop'
Set-Alias -Name 'p' -Value 'Set-Location -Path ~/Documents/Projects'

#endregion

Clear-Host

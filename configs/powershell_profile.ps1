#Requires -Modules Color

#region MODULES
Import-Module -Name 'Color'
#endregion

#region MISC
#endregion

#region FUNCTIONS
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

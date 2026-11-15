# Source XDG config location
if (Test-Path -Path "$env:XDG_CONFIG_HOME\powershell\$($MyInvocation.MyCommand.Name)") {
    . "$env:XDG_CONFIG_HOME\powershell\$($MyInvocation.MyCommand.Name)"
}
# Source XDG config location
# 1. Prefer XDG_CONFIG_HOME environment variable
# 2. ~/.config based on the HOME environment variable
# 3. ~/.config based on the HOME PowerShell variable
foreach ($config in "$env:XDG_CONFIG_HOME","$(Join-Path $env:HOME .config)","$(Join-Path $HOME .config)") {
    if ($config -ne "" -and (Test-Path -Path "$(Join-Path $config powershell $MyInvocation.MyCommand.Name)")) {
        . "$(Join-Path $config powershell $MyInvocation.MyCommand.Name)"
        break
    }
}

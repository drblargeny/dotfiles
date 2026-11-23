# Update $env:PSModulePath using XDG data location
# 1. Prefer XDG_DATA_HOME environment variable
# 2. ~/.local/share based on the HOME environment variable
# 3. ~/.local/share based on the HOME PowerShell variable
foreach ($config in "$env:XDG_DATA_HOME","$(Join-Path $env:HOME .local share)","$(Join-Path $HOME .local share)") {
    if ($config -ne "" -and (Test-Path -Path "$(Join-Path $config powershell Modules)")) {        
        $env:PSModulePath = "$(Join-Path $config powershell Modules);$env:PSModulePath"
        break
    }
}

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
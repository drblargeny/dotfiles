# PowerShell

Within my dotfiles project, my powershell profile/scripts follow Linux naming
conventions (i.e., `~/.config/powershell/…` instead of
`$HOME\Documents\PowerShell\…`).  To use this in Windows, you can create a
symlink/junction at the Windows location to point to this folder.

## XDG Profile Shim

Including xdg_profile_shim.ps1 in a Windows PowerShell \$PROFILE location configures PowerShell to source the corresponding XDG_CONFIG_HOME profile location whene the XDG_CONFIG_HOME environment variable is set.

### XDG Profile Shim Installation

```shell
cp $env:XDG_CONFIG_HOME\powershell\xdg_profile_shim.ps1 $PROFILE.CurrentUserAllHosts
cp $env:XDG_CONFIG_HOME\powershell\xdg_profile_shim.ps1 $PROFILE.CurrentUserCurrentHost
```
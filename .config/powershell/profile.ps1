# Change to UTF-8 (with BOM in PowerShell 5.1, without BOM in 6+)
# For Out-File, >, and >>
$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8' 
# For all cmdlets
$PSDefaultParameterValues['*:Encoding'] = 'utf8' 

# Add scripts to PATH
# From: https://stackoverflow.com/questions/1011243/where-to-put-powershell-scripts
$ProfileRoot = (Split-Path -Parent $MyInvocation.MyCommand.Path)
$env:PATH += ";$ProfileRoot\scripts"

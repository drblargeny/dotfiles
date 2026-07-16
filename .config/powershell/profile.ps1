## Map PSDrives to other registry hives
## But only when a Registry provider exists
if (!(Test-Path HKCR:) -and (Get-PSProvider Registry -ErrorAction Ignore)) {
    $null = New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT
    $null = New-PSDrive -Name HKU -PSProvider Registry -Root HKEY_USERS
}

## Customize the prompt
function prompt {
    if ([OperatingSystem]::isWindows()) {
      $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
      $principal = [Security.Principal.WindowsPrincipal] $identity
      $adminRole = [Security.Principal.WindowsBuiltInRole]::Administrator
      $isAdminRole = $principal.IsInRole($adminRole)
    } else {
      $isAdminRole = (id -u) -eq 0
    }
    $prefix = $PSStyle.Foreground.BrightBlue + ([DateTime]::Now).toString("s")
    if (Test-Path Variable:/PSDebugContext) { 
        $prefix = "[DBG]: ${prefix}"
    }
    $username = "${env:USERNAME}@${env:COMPUTERNAME} " + $PSStyle.Reset
    if ($env:USERDOMAIN) {
        $username = "${env:USERDOMAIN}+${username}"
    }
    if ($isAdminRole) {
        $prefix = $PSStyle.Foreground.Red + "[ADMIN]:${prefix} " + $PSStyle.Foreground.Red + $username
    } else {
        $prefix += ' ' + $PSStyle.Foreground.Green + $username
    }
    $body = 'PS ' + $PSStyle.Foreground.Yellow + $PWD.path + $PSStyle.Reset
    $suffix = $(if ($NestedPromptLevel -ge 1) { '>>' }) + '> '
    "${prefix}`n${body}${suffix}"
}

## Create $PSStyle if running on a version older than 7.2
## - Add other ANSI color definitions as needed

if ($PSVersionTable.PSVersion.ToString() -lt '7.2.0') {
    # define escape char since "`e" may not be supported
    $esc = [char]0x1b
    $PSStyle = [pscustomobject]@{
        Foreground = @{
            Magenta = "${esc}[35m"
            BrightYellow = "${esc}[93m"
        }
        Background = @{
            BrightBlack = "${esc}[100m"
        }
    }
}

## Set PSReadLine options and keybindings
$PSROptions = @{
    ContinuationPrompt = '  '
    Colors             = @{
        #Operator         = $PSStyle.Foreground.Magenta
        #Parameter        = $PSStyle.Foreground.Magenta
        #Selection        = $PSStyle.Background.BrightBlack
        #InLinePrediction = $PSStyle.Foreground.BrightYellow + $PSStyle.Background.BrightBlack
        Command                = $PSStyle.Foreground.BrightYellow
        Comment                = $PSStyle.Foreground.Green
        ContinuationPrompt     = $PSStyle.Foreground.White
        #DefaultToken           = $PSStyle.Foreground.White
        Emphasis               = $PSStyle.Foreground.BrightCyan
        Error                  = $PSStyle.Foreground.BrightRed
        InlinePrediction       = $PSStyle.Foreground.BrightWhite + $PSStyle.Dim + $PSStyle.Italic
        #InlinePrediction       = "`e[38;5;238m"
        #InlinePrediction       = $PSStyle.Foreground.White + $PSStyle.Dim
        Keyword                = $PSStyle.Foreground.BrightGreen
        ListPrediction         = $PSStyle.Foreground.Yellow
        ListPredictionSelected = $PSStyle.Foreground.BrightWhite + $PSStyle.Background.BrightBlack
        #ListPredictionSelected = "`e[48;5;238m"
        ListPredictionTooltip  = $PSStyle.Foreground.BrightWhite + $PSStyle.Dim + $PSStyle.Italic
        Member                 = $PSStyle.Foreground.White
        Number                 = $PSStyle.Foreground.BrightWhite
        Operator               = $PSStyle.Foreground.BrightBlack
        Parameter              = $PSStyle.Foreground.BrightBlack
        Selection              = $PSStyle.Foreground.Black + $PSStyle.Background.White
        String                 = $PSStyle.Foreground.Cyan
        Type                   = $PSStyle.Foreground.White
        Variable               = $PSStyle.Foreground.BrightGreen
    }
}
Set-PSReadLineOption @PSROptions
Set-PSReadLineKeyHandler -Chord 'Ctrl+f' -Function ForwardWord
Set-PSReadLineKeyHandler -Chord 'Enter' -Function ValidateAndAcceptLine

## Add argument completer for the dotnet CLI tool
$scriptblock = {
    param($wordToComplete, $commandAst, $cursorPosition)
    dotnet complete --position $cursorPosition $commandAst.ToString() |
        ForEach-Object {
            [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
        }
}
Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock $scriptblock

# Change to UTF-8 (with BOM in PowerShell 5.1, without BOM in 6+)
# For Out-File, >, and >>
$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8' 
# For all cmdlets
$PSDefaultParameterValues['*:Encoding'] = 'utf8' 

# Add scripts to PATH
# From: https://stackoverflow.com/questions/1011243/where-to-put-powershell-scripts
$ProfileRoot = (Split-Path -Parent $MyInvocation.MyCommand.Path)
$env:PATH += ";$ProfileRoot\my-scripts"

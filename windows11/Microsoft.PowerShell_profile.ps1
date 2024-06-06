# set PowerShell to UTF-8
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

Import-Module Catppuccin
function prompt {
  $(if (Test-Path variable:/PSDebugContext) { "$($Flavor.Red.Foreground())[DBG]: " }
    else { '' }) + "$($Flavor.Teal.Foreground())PS $($Flavor.Yellow.Foreground())" + $(Get-Location) +
  "$($Flavor.Green.Foreground())" + $(if ($NestedPromptLevel -ge 1) { '>>' }) + '> ' + $($PSStyle.Reset)
}
$Flavor = $Catppuccin['Macchiato']
# The above example requires the automatic variable $PSStyle to be available, so can be only used in PS 7.2+
# Replace $PSStyle.Reset with "`e[0m" for PS 6.0 through PS 7.1 or "$([char]27)[0m" for PS 5.1
# Import-Module posh-git

$env:Path += ";C:\Users\User\AppData\Local\Programs\oh-my-posh\bin"
$omp_config = Join-Path $env:POSH_THEMES_PATH "catppuccin_macchiato.omp.json"
oh-my-posh init pwsh --config $omp_config | Invoke-Expression

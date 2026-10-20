# Native Windows toast with no modules. Needs Windows PowerShell 5.1 (powershell.exe), which ships with Windows 10 and 11.
param([string]$Title = 'Claude Code', [string]$Message = '')

# Windows only shows toasts from a registered app ID. Register our own (per user, no admin) so the toast
# is labeled "Heads-up for Claude Code" and clicking it just dismisses it instead of opening another app.
$aumid = 'DecodedXR.HeadsUp'
$key = "HKCU:\SOFTWARE\Classes\AppUserModelId\$aumid"
if (-not (Test-Path $key)) {
  New-Item -Path $key -Force | Out-Null
  New-ItemProperty -Path $key -Name DisplayName -Value 'Heads-up for Claude Code' -PropertyType String -Force | Out-Null
}

[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
[Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null

$esc = [System.Security.SecurityElement]
$xml = New-Object Windows.Data.Xml.Dom.XmlDocument
$xml.LoadXml("<toast><visual><binding template='ToastGeneric'><text>$($esc::Escape($Title))</text><text>$($esc::Escape($Message))</text></binding></visual></toast>")
[Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($aumid).Show([Windows.UI.Notifications.ToastNotification]::new($xml))

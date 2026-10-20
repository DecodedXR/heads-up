# Native Windows toast with no modules. Needs Windows PowerShell 5.1 (powershell.exe), which ships with Windows 10 and 11.
param([string]$Title = 'Claude Code', [string]$Message = '')

[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
[Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null

$esc = [System.Security.SecurityElement]
$xml = New-Object Windows.Data.Xml.Dom.XmlDocument
$xml.LoadXml("<toast><visual><binding template='ToastGeneric'><text>$($esc::Escape($Title))</text><text>$($esc::Escape($Message))</text></binding></visual></toast>")

# Windows only shows toasts from a registered app ID; PowerShell's own ID is always registered.
$appId = '{1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\WindowsPowerShell\v1.0\powershell.exe'
[Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($appId).Show([Windows.UI.Notifications.ToastNotification]::new($xml))

.\Load-Module.ps1 SQLCmd

$serverInstance = "BOT-SP2016"

$databases = "SharePoint_Content_80", "WSS_Content_ROZ"

foreach ($database in $databases) {
    Write-Host "[x] database $database in progress..."
    Set-Recovery-Simple $database $serverInstance
    Shrink-Log-File $database $serverInstance
    Set-Recovery-Full $database $serverInstance
}
.\Load-Module.ps1 SQLCmd

$serverInstance = "BOT-SP2016"

$db = @{
    name = "SharePoint_Content_80"
    path = "\db\ksup\content\2019.09.16.00.00.07.bak"
}

$hostInfo = @{
    path = $env:hostPath
    user = $env:hostUser
    password = $env:hostPassword
}

Write-Host "[x] database preconfig"
Show-Advanced-Options $serverInstance
Xp-CmdShell $serverInstance

Write-Host "[x] virtual path mappings"
Net-Use-Delete "H:" $serverInstance
Net-Use-Add "H:" $hostInfo.path $hostInfo.user $hostInfo.password $serverInstance

Write-Host "[x] taking database $($db.name) offline"
Set-Database-Offline $db.name $serverInstance

Write-Host "[x] restorting database $($db.name) from file $($db.path)"
$path = Join-Path -Path $hostInfo.path -ChildPath $db.path
Restore-Database $db.name $path $serverInstance

Write-Host "[x] taking database $($db.name) online"
Set-Database-Online $db.name $serverInstance
Write-Host "[x] scenario completed" -ForegroundColor Green
.\Load-Module.ps1 SQLCmd

$serverInstance = "BOT-SP2016"

$databases = @(@{
        name = "SharePoint_Content_80"
        path = "\db\ksup\content\dev\bucky.bak"
    }, @{ 
        name = "WSS_Content_ROZ"
        path = "\db\roz\content\dev\bucky.bak"
    })

$hostInfo = @{
    path     = $env:hostPath
    user     = $env:hostUser
    password = $env:hostPassword
}

Write-Host "[x] database preconfig"
Show-Advanced-Options $serverInstance
Xp-CmdShell $serverInstance

Write-Host "[x] virtual path mappings"
Net-Use-Delete "H:" $serverInstance
Net-Use-Add "H:" $hostInfo.path $hostInfo.user $hostInfo.password $serverInstance

foreach ($database in $databases) {
    $databasePath = Join-Path -Path $hostInfo.path -ChildPath $database.path
    
    Write-Host "[x] database $($database.name) backing up to $databasePath"

    Backup-Database $database.name $databasePath $serverInstance
}
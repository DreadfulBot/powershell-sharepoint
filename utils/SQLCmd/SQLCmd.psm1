Function Exec(
    [System.String]$command,
    [System.String]$serverInstance
) {
    Invoke-Sqlcmd -Query $command -ServerInstance $ServerInstance
}

Function Test(
    [System.String] $serverInstance
) {
    $command = "EXEC master..xp_cmdshell 'set'"
    Exec $command $serverInstance
}

Function Reconfigure(
    [System.String] $serverInstance
) {
    $command = "RECONFIGURE"
    Exec $command $serverInstance
}

Function Show-Advanced-Options(
    [System.String] $serverInstance
) {
    $command = "EXEC sp_configure 'show advanced options', 1"
    Exec $command $serverInstance
    Reconfigure $serverInstance
}

Function Xp-CmdShell(
    [System.String] $serverInstance
) {
    $command = "EXEC sp_configure 'xp_cmdshell', 1"
    Exec $command $serverInstance
    $command = "RECONFIGURE"
    Reconfigure $serverInstance
}

Function Net-Use-Delete(
    [System.String] $drive,
    [System.String] $serverInstance
) {
    $command = "EXEC XP_CMDSHELL 'net use $drive /delete /y'"
    Exec $command $serverInstance
}

Function Net-Use-Add(
    [System.String] $drive,
    [System.String] $hostPath,
    [System.String] $hostUser,
    [System.String] $hostPassword,
    [System.String] $serverInstance
) {
    $command = "EXEC XP_CMDSHELL 'net use $drive $hostPath /user:$hostUser $hostPassword /persistent:yes'"
    Exec $command $serverInstance
}

Function Set-Database-Offline(
    [System.String] $dbName,
    [System.String] $serverInstance
) {
    $command = "ALTER DATABASE [$dbName] SET OFFLINE WITH ROLLBACK IMMEDIATE"
    Exec $command $serverInstance
}

Function Set-Database-Online(
    [System.String] $dbName,
    [System.String] $serverInstance
) {
    $command = "ALTER DATABASE [$dbName] SET ONLINE"
    Exec $command $serverInstance
}

Function Restore-Database(
    [System.String] $dbName,
    [System.String] $dbFilePath,
    [System.String] $serverInstance
) {
    $command = "RESTORE DATABASE [$dbName] FROM DISK = '$dbFilePath' WITH REPLACE"
    Exec $command $serverInstance
}
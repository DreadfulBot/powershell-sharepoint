param(
    [System.String]$SiteUrl = "http://bot-sp2016",
    [System.String]$SolutionsPath = "C:\updates\KSUP\"
)
Add-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue

# Solutions   

$Solutions = Get-ChildItem -Path $SolutionsPath -filter *.wsp | Sort-Object -Property Name -Descending
    
Function Get-FileName($initialDirectory) {   
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.InitialDirectory = $initialDirectory
    $OpenFileDialog.Multiselect = $true
    $OpenFileDialog.Filter = "WSP files (*.wsp)| *.wsp"
    $OpenFileDialog.ShowDialog() | Out-Null
    $OpenFileDialog.FileNames
} #end function Get-FileName

function Wait-For-Job-To-Finish([string]$SolutionFileName) { 
    $JobName = "*solution-deployment*$SolutionFileName*"
    $job = Get-SPTimerJob | Where-Object { $_.Name -like $JobName }
    if ($null -eq $job) {
        Write-Output "$(Get-Date -Format "yyyy-MM-dd HH:mm:ss") # Timer job not found"
    }
    else {
        $JobFullName = $job.Name
        Write-Output  "$(Get-Date -Format "yyyy-MM-dd HH:mm:ss") # Waiting to finish job $JobFullName" #-NoNewLine -foregroundcolor "DarkBlue"
        
        while ($null -ne (Get-SPTimerJob $JobFullName)) {
            Start-Sleep -Seconds 2
        }
        Write-Output  "$(Get-Date -Format "yyyy-MM-dd HH:mm:ss") # Finished waiting for job.."
    }
}

function Get-Solution-Is-Deployed($solutionPath) {
    $name = $solutionPath.Name
    $solution = Get-SPSolution $name -ErrorAction SilentlyContinue

    while ($solution.JobExists -eq $true) {
        Write-Host '.' -NoNewline
        Start-Sleep -Seconds 2
        $solution = Get-SPSolution $name -ErrorAction SilentlyContinue
    }

    $lastOperationResult = $solution.LastOperationResult
    return ($lastOperationResult -eq [Microsoft.SharePoint.Administration.SPSolutionOperationResult]::DeploymentSucceeded)
}

function Add-Solution($solutionPath, [string[]]$webApps = @()) {
    $name = $solutionPath.Name
    Write-Output "$(Get-Date -Format "yyyy-MM-dd HH:mm:ss") # Run on $name"  #-foregroundcolor "DarkBlue"
    $solution = Get-SPSolution $name -ErrorAction SilentlyContinue

    if ($null -ne $solution) {
        Write-Output "$(Get-Date -Format "yyyy-MM-dd HH:mm:ss") # Uninstalling $name"  #-foregroundcolor "DarkBlue"
        if ($solution.Deployed) {
            if ($solution.ContainsWebApplicationResource) {
                $solution | Uninstall-SPSolution -AllWebApplications -Confirm:$false
            }
            else {
                $solution | Uninstall-SPSolution -Confirm:$false
            }
            Wait-For-Job-To-Finish 
        }
        Wait-For-Job-To-Finish 
        
        $solution | Remove-SPSolution -Confirm:$false -Force
    }
    
    Write-Output "$(Get-Date -Format "yyyy-MM-dd HH:mm:ss") # Installing (add+deploy) $name" #-foregroundcolor "DarkBlue"    
    $solution = Add-SPSolution $solutionPath.FullName

    if ($solution.ContainsWebApplicationResource -eq $false) {
        $solution | Install-SPSolution -GACDeployment:$true -Confirm:$false -Force:$true
        Wait-For-Job-To-Finish 
        while ($true -ne (Get-Solution-Is-Deployed $solutionPath)) {
            Write-Output "$(Get-Date -Format "yyyy-MM-dd HH:mm:ss") The solution $name installation failed, retrying"
            $solution | Install-SPSolution -GACDeployment:$true -Confirm:$false -Force:$true
            Wait-For-Job-To-Finish 
        }
    }
    else {
        if ($null -eq $webApps -or $webApps.Length -eq 0) {
            Write-Output "$(Get-Date -Format "yyyy-MM-dd HH:mm:ss") The solution $name contains web application resources but no web applications were specified to deploy to."
            return
        }
        $webApps | ForEach-Object {
            $solution | Install-SPSolution -GACDeployment:$true -WebApplication $_ -Confirm:$false -Force:$true
            Wait-For-Job-To-Finish 
            while ($true -ne (Get-Solution-Is-Deployed $solutionPath)) {
                Write-Output "$(Get-Date -Format "yyyy-MM-dd HH:mm:ss") The solution $name installation failed, retrying"
                $solution | Install-SPSolution -GACDeployment:$true -WebApplication $_ -Confirm:$false -Force:$true
                Wait-For-Job-To-Finish 
            }
        }
    }
}

function Remove-Solution($name, [string[]]$webApps = @()) {
    Write-Output "$(Get-Date -Format "yyyy-MM-dd HH:mm:ss") # Run on $name"  #-foregroundcolor "DarkBlue"
    $solution = Get-SPSolution $name -ErrorAction SilentlyContinue

    if ($null -ne $solution) {
        Write-Output "$(Get-Date -Format "yyyy-MM-dd HH:mm:ss") # Uninstalling $name"  #-foregroundcolor "DarkBlue"
        if ($solution.Deployed) {
            if ($solution.ContainsWebApplicationResource) {
                $solution | Uninstall-SPSolution -AllWebApplications -Confirm:$false
            }
            else {
                $solution | Uninstall-SPSolution -Confirm:$false
            }
            Wait-For-Job-To-Finish 
        }
        Wait-For-Job-To-Finish 
        
        $solution | Remove-SPSolution -Confirm:$false
    }
}

$Solutions | ForEach-Object { $_.FullName }

$Solutions | ForEach-Object { Add-Solution $_ @($SiteUrl) }
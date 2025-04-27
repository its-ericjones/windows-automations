
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$appContext = New-Object System.Windows.Forms.ApplicationContext
$trayIcon = New-Object System.Windows.Forms.NotifyIcon

# Load icons
$studioIcon = New-Object System.Drawing.Icon("C:\Scripts\Icons\systemTray-Monitor-Icon.ico")
$gamingIcon = New-Object System.Drawing.Icon("C:\Scripts\Icons\systemTray-Controller-Icon.ico")

# Set initial icon
$trayIcon.Icon = $studioIcon
$trayIcon.Text = "Steam Watcher: Studio Display Mode"

# Create right-click menu
$menu = New-Object System.Windows.Forms.ContextMenu
$exitItem = New-Object System.Windows.Forms.MenuItem "Exit"
$exitItem.Add_Click({
    $trayIcon.Visible = $false
    $appContext.ExitThread()
})
$menu.MenuItems.Add($exitItem)
$trayIcon.ContextMenu = $menu
$trayIcon.Visible = $true

# State variable
$script:steamRunning = $false

# Timer to check Steam every 5 seconds
$timer = New-Object System.Windows.Forms.Timer
$timer.Interval = 5000  # 5000ms = 5 seconds
$timer.Add_Tick({

    $steamProcess = Get-Process -Name "Steam" -ErrorAction SilentlyContinue
    Write-Host "Checking Steam status..."
    Write-Host "Steam running state: $script:steamRunning"

    if ($steamProcess -and -not $script:steamRunning) {
        Write-Host "Steam has started. Switching to Gaming Mode."
        Start-Process -FilePath "cmd.exe" -ArgumentList '/c "C:\Scripts\Display\Set-GamingMode.bat"' -WindowStyle Hidden -Wait
        $script:steamRunning = $true
        $trayIcon.Icon = $gamingIcon
        $trayIcon.Text = "Steam Watcher: Gaming Mode"
    }
    elseif (-not $steamProcess -and $script:steamRunning) {
        Write-Host "Steam has stopped. Switching back to Studio Display Mode."
        Start-Sleep -Seconds 3
        Start-Process -FilePath "cmd.exe" -ArgumentList '/c "C:\Scripts\Display\Set-StudioDisplayMode.bat"' -WindowStyle Hidden -Wait
        $script:steamRunning = $false
        $trayIcon.Icon = $studioIcon
        $trayIcon.Text = "Steam Watcher: Studio Display Mode"
    }
})

$timer.Start()
[System.Windows.Forms.Application]::Run($appContext)

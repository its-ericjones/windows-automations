$PiServer = "RPI_IP_ADDRESS:5000"
$SteamPath = "C:\Program Files (x86)\Steam\steam.exe"
$SteamIsRunning = $false

Write-Host "Monitoring for button presses. Press Ctrl+C to exit."

function IsSteamRunning {
    $steamProcess = Get-Process -Name "steam" -ErrorAction SilentlyContinue
    return ($null -ne $steamProcess)
}

try {
    while ($true) {
        try {
            $response = Invoke-WebRequest -Uri "$PiServer/button_status" -TimeoutSec 2
            
            if ($response.Content -eq "PRESSED") {
                # Check the current state of Steam
                $SteamIsRunning = IsSteamRunning
                
                if ($SteamIsRunning) {
                    # Steam is running, so close it
                    Write-Host "Button press detected! Closing Steam..." -ForegroundColor Yellow
                    Stop-Process -Name "steam" -Force -ErrorAction SilentlyContinue
                    $SteamIsRunning = $false
                } else {
                    # Steam is not running, so launch it
                    Write-Host "Button press detected! Launching Steam..." -ForegroundColor Green
                    Start-Process -FilePath $SteamPath
                    $SteamIsRunning = $true
                }
                
                # Prevent multiple actions
                Start-Sleep -Seconds 3
            }
        }
        catch {
            Write-Host "Connection error. Retrying in 5 seconds..."
            Start-Sleep -Seconds 5
        }
        
        Start-Sleep -Seconds 1
    }
}
catch {
    Write-Host "Script terminated."
}
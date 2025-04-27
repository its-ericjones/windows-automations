# Path to NirCmd
$nircmd = "C:\Tools\NirCmd\nircmd.exe"

# Change resolution to 2560x1440
Start-Process -FilePath $nircmd -ArgumentList "setdisplay 2560 1440 32"

# Set power plan to High Performance
powercfg /setactive SCHEME_MIN

# Get the current power plan and display it
$currentPlan = powercfg /getactivescheme
Write-Host "`n[OK] Resolution set to 2560x1440"
Write-Host "[OK] Power Plan Changed: $currentPlan"


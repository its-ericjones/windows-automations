# Path to NirCmd
$nircmd = "C:\Tools\NirCmd\nircmd.exe"

# Change resolution to 5120x2880 (5K native)
Start-Process -FilePath $nircmd -ArgumentList "setdisplay 5120 2880 32"

# Set power plan to Balanced
powercfg /setactive SCHEME_BALANCED

# Get the current power plan and display it
$currentPlan = powercfg /getactivescheme
Write-Host "`n[OK] Resolution set to 5120x2880"
Write-Host "[OK] Power Plan Changed: $currentPlan"

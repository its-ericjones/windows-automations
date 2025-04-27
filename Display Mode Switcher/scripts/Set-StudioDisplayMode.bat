powershell.exe -ExecutionPolicy Bypass -File "C:\Scripts\Display\Set-StudioDisplayMode.ps1"
@echo off
echo === Studio Mode Activated === >> C:\Scripts\Display\log.txt
date /t >> C:\Scripts\Display\log.txt
time /t >> C:\Scripts\Display\log.txt
C:\Tools\NirCmd\nircmd.exe setdisplay 5120 2880 32 60 >> C:\Scripts\Display\log.txt 2>&1
powercfg /setactive SCHEME_BALANCED >> C:\Scripts\Display\log.txt 2>&1
echo [End] >> C:\Scripts\Display\log.txt

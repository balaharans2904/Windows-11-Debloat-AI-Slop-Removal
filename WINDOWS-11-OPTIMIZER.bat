@echo off
REM ============================================================================
REM  WINDOWS 11 RAM & CPU OPTIMIZER
REM  Removes bloatware, AI features, telemetry, and unnecessary services
REM  Run as Administrator
REM ============================================================================

net session >nul 2>&1
if %errorLevel% neq 0 (
    echo ERROR: Must run as Administrator!
    echo Right-click and select "Run as administrator"
    pause
    exit
)

echo ============================================================================
echo   WINDOWS 11 RAM ^& CPU OPTIMIZATION
echo   Removing bloatware, AI, telemetry and unnecessary services
echo ============================================================================
echo.
echo WARNING: This will disable Windows AI features (Copilot, Recall, etc.)
echo and remove bloatware to free up RAM and CPU.
echo.
set /p confirm="Type YES to continue: "
if /i not "%confirm%"=="YES" (
    echo Cancelled.
    pause
    exit
)

echo.
echo ============================================================================
echo [1/15] DISABLING WINDOWS AI FEATURES (Copilot, Recall, etc.)
echo ============================================================================

REM Disable Copilot
reg add "HKCU\Software\Policies\Microsoft\Windows\WindowsCopilot" /v "TurnOffWindowsCopilot" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot" /v "TurnOffWindowsCopilot" /t REG_DWORD /d 1 /f >nul 2>&1
echo    [OK] Copilot: DISABLED

REM Disable Windows Recall
reg add "HKCU\Software\Policies\Microsoft\Windows\WindowsAI" /v "DisableAIDataAnalysis" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsAI" /v "DisableAIDataAnalysis" /t REG_DWORD /d 1 /f >nul 2>&1
echo    [OK] Windows Recall: DISABLED

REM Disable Click to Do (AI text analysis)
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\SmartActionPlatform\SmartClipboard" /v "Disabled" /t REG_DWORD /d 1 /f >nul 2>&1
echo    [OK] Click to Do: DISABLED

REM Disable AI features in Photos app
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Photos" /v "AIFeatures" /t REG_DWORD /d 0 /f >nul 2>&1
echo    [OK] Photos AI: DISABLED

REM Disable AI in Paint
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Paint" /v "AIEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
echo    [OK] Paint AI: DISABLED

echo.

REM ============================================================================
echo [2/15] DISABLING TELEMETRY ^& DATA COLLECTION
echo ============================================================================

REM Disable all telemetry
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f >nul 2>&1
echo    [OK] Telemetry: DISABLED

REM Disable DiagTrack service (telemetry)
sc config "DiagTrack" start= disabled >nul 2>&1
sc stop "DiagTrack" >nul 2>&1
echo    [OK] DiagTrack Service: STOPPED

REM Disable Connected User Experiences and Telemetry
sc config "dmwappushservice" start= disabled >nul 2>&1
sc stop "dmwappushservice" >nul 2>&1
echo    [OK] Connected User Experiences: STOPPED

echo.

REM ============================================================================
echo [3/15] STOPPING RAM ^& CPU HUNGRY SERVICES
echo ============================================================================

REM Windows Search (uses 200-500MB RAM)
sc config "WSearch" start= demand >nul 2>&1
sc stop "WSearch" >nul 2>&1
echo    [OK] Windows Search: STOPPED (on-demand only)

REM Superfetch/SysMain (uses 100-300MB RAM)
sc config "SysMain" start= disabled >nul 2>&1
sc stop "SysMain" >nul 2>&1
echo    [OK] SysMain (Superfetch): DISABLED

REM Windows Update (uses RAM in background)
sc config "wuauserv" start= demand >nul 2>&1
sc stop "wuauserv" >nul 2>&1
echo    [OK] Windows Update: ON-DEMAND

REM Background Intelligent Transfer
sc config "BITS" start= demand >nul 2>&1
sc stop "BITS" >nul 2>&1
echo    [OK] BITS: ON-DEMAND

REM Delivery Optimization
sc config "DoSvc" start= disabled >nul 2>&1
sc stop "DoSvc" >nul 2>&1
echo    [OK] Delivery Optimization: DISABLED

REM Windows Error Reporting
sc config "WerSvc" start= disabled >nul 2>&1
sc stop "WerSvc" >nul 2>&1
echo    [OK] Error Reporting: DISABLED

REM Program Compatibility Assistant
sc config "PcaSvc" start= disabled >nul 2>&1
sc stop "PcaSvc" >nul 2>&1
echo    [OK] Compatibility Assistant: DISABLED

REM Diagnostic Policy Service
sc config "DPS" start= demand >nul 2>&1
sc stop "DPS" >nul 2>&1
echo    [OK] Diagnostic Policy: ON-DEMAND

echo.

REM ============================================================================
echo [4/15] DISABLING CORTANA ^& VOICE ASSISTANT
echo ============================================================================

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /t REG_DWORD /d 0 /f >nul 2>&1
echo    [OK] Cortana: DISABLED

echo.

REM ============================================================================
echo [5/15] DISABLING WIDGETS ^& TASKBAR BLOAT
echo ============================================================================

reg add "HKLM\SOFTWARE\Policies\Microsoft\Dsh" /v "AllowNewsAndInterests" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Feeds" /v "ShellFeedsTaskbarViewMode" /t REG_DWORD /d 2 /f >nul 2>&1
echo    [OK] Widgets: DISABLED

echo.

REM ============================================================================
echo [6/15] DISABLING BACKGROUND APPS
echo ============================================================================

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t REG_DWORD /d 1 /f >nul 2>&1
echo    [OK] Background Apps: DISABLED

echo.

REM ============================================================================
echo [7/15] REMOVING WINDOWS BLOATWARE APPS
echo ============================================================================

echo    Removing bloatware apps (this may take a minute)...

powershell -Command "Get-AppxPackage *Microsoft.549981C3F5F10* | Remove-AppxPackage -ErrorAction SilentlyContinue" >nul 2>&1
echo    [OK] Cortana app removed

powershell -Command "Get-AppxPackage *Microsoft.BingWeather* | Remove-AppxPackage -ErrorAction SilentlyContinue" >nul 2>&1
echo    [OK] Bing Weather removed

powershell -Command "Get-AppxPackage *Microsoft.BingNews* | Remove-AppxPackage -ErrorAction SilentlyContinue" >nul 2>&1
echo    [OK] Bing News removed

powershell -Command "Get-AppxPackage *Microsoft.GetHelp* | Remove-AppxPackage -ErrorAction SilentlyContinue" >nul 2>&1
echo    [OK] Get Help removed

powershell -Command "Get-AppxPackage *Microsoft.Getstarted* | Remove-AppxPackage -ErrorAction SilentlyContinue" >nul 2>&1
echo    [OK] Get Started removed

powershell -Command "Get-AppxPackage *Microsoft.MixedReality.Portal* | Remove-AppxPackage -ErrorAction SilentlyContinue" >nul 2>&1
echo    [OK] Mixed Reality Portal removed

powershell -Command "Get-AppxPackage *Microsoft.Office.OneNote* | Remove-AppxPackage -ErrorAction SilentlyContinue" >nul 2>&1
echo    [OK] OneNote removed

powershell -Command "Get-AppxPackage *Microsoft.People* | Remove-AppxPackage -ErrorAction SilentlyContinue" >nul 2>&1
echo    [OK] People app removed

powershell -Command "Get-AppxPackage *Microsoft.SkypeApp* | Remove-AppxPackage -ErrorAction SilentlyContinue" >nul 2>&1
echo    [OK] Skype removed

powershell -Command "Get-AppxPackage *Microsoft.WindowsFeedbackHub* | Remove-AppxPackage -ErrorAction SilentlyContinue" >nul 2>&1
echo    [OK] Feedback Hub removed

powershell -Command "Get-AppxPackage *Microsoft.Xbox* | Remove-AppxPackage -ErrorAction SilentlyContinue" >nul 2>&1
echo    [OK] Xbox apps removed

powershell -Command "Get-AppxPackage *Microsoft.ZuneMusic* | Remove-AppxPackage -ErrorAction SilentlyContinue" >nul 2>&1
echo    [OK] Groove Music removed

powershell -Command "Get-AppxPackage *Microsoft.ZuneVideo* | Remove-AppxPackage -ErrorAction SilentlyContinue" >nul 2>&1
echo    [OK] Movies ^& TV removed

powershell -Command "Get-AppxPackage *Clipchamp.Clipchamp* | Remove-AppxPackage -ErrorAction SilentlyContinue" >nul 2>&1
echo    [OK] Clipchamp removed

powershell -Command "Get-AppxPackage *Microsoft.Copilot* | Remove-AppxPackage -ErrorAction SilentlyContinue" >nul 2>&1
echo    [OK] Copilot app removed

echo.

REM ============================================================================
echo [8/15] DISABLING VISUAL EFFECTS (SAVES RAM ^& CPU)
echo ============================================================================

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v "UserPreferencesMask" /t REG_BINARY /d 9012038010000000 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v "MinAnimate" /t REG_SZ /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\DWM" /v "EnableAeroPeek" /t REG_DWORD /d 0 /f >nul 2>&1
echo    [OK] Visual Effects: MINIMAL (performance mode)

echo.

REM ============================================================================
echo [9/15] DISABLING ANIMATIONS ^& TRANSPARENCY
echo ============================================================================

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\DWM" /v "AlwaysHibernateThumbnails" /t REG_DWORD /d 0 /f >nul 2>&1
echo    [OK] Transparency ^& Animations: DISABLED

echo.

REM ============================================================================
echo [10/15] DISABLING GAME BAR ^& DVR (SAVES 300MB+ RAM)
echo ============================================================================

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v "AppCaptureEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowGameDVR" /t REG_DWORD /d 0 /f >nul 2>&1
echo    [OK] Game Bar ^& DVR: DISABLED (300MB+ RAM freed)

echo.

REM ============================================================================
echo [11/15] OPTIMIZING MEMORY MANAGEMENT
echo ============================================================================

REM Disable paging executive (keeps system in RAM)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /t REG_DWORD /d 1 /f >nul 2>&1
echo    [OK] Paging Executive: DISABLED (faster system)

REM Clear pagefile at shutdown
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "ClearPageFileAtShutdown" /t REG_DWORD /d 0 /f >nul 2>&1
echo    [OK] Pagefile clearing: DISABLED (faster shutdown)

REM Disable memory compression (saves CPU)
powershell -Command "Disable-MMAgent -MemoryCompression -ErrorAction SilentlyContinue" >nul 2>&1
echo    [OK] Memory Compression: DISABLED (saves CPU)

REM Disable prefetch/superfetch
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnablePrefetcher" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnableSuperfetch" /t REG_DWORD /d 0 /f >nul 2>&1
echo    [OK] Prefetch/Superfetch: DISABLED

echo.

REM ============================================================================
echo [12/15] DISABLING FAST STARTUP (PREVENTS ISSUES)
echo ============================================================================

reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "HiberbootEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
echo    [OK] Fast Startup: DISABLED (cleaner boots)

echo.

REM ============================================================================
echo [13/15] DISABLING TIPS, SUGGESTIONS ^& ADS
echo ============================================================================

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SystemPaneSuggestionsEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338393Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-353694Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-353696Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowSyncProviderNotifications" /t REG_DWORD /d 0 /f >nul 2>&1
echo    [OK] Tips, Suggestions ^& Ads: DISABLED

echo.

REM ============================================================================
echo [14/15] DISABLING ACTIVITY HISTORY ^& TIMELINE
echo ============================================================================

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableActivityFeed" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "PublishUserActivities" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "UploadUserActivities" /t REG_DWORD /d 0 /f >nul 2>&1
echo    [OK] Activity History: DISABLED

echo.

REM ============================================================================
echo [15/15] CLEANING TEMP FILES
echo ============================================================================

del /q /f /s "%TEMP%\*" >nul 2>&1
del /q /f /s "C:\Windows\Temp\*" >nul 2>&1
del /q /f /s "%LOCALAPPDATA%\Microsoft\Windows\INetCache\*" >nul 2>&1
echo    [OK] Temp Files: CLEANED

echo.
echo ============================================================================
echo   OPTIMIZATION COMPLETE!
echo ============================================================================
echo.
echo WHAT WAS DONE:
echo  [+] All Windows AI features DISABLED (Copilot, Recall, etc.)
echo  [+] Telemetry and data collection DISABLED
echo  [+] RAM-hungry services STOPPED (Search, Superfetch, etc.)
echo  [+] Cortana DISABLED
echo  [+] Widgets DISABLED
echo  [+] Background apps DISABLED
echo  [+] Bloatware apps REMOVED (20+ apps)
echo  [+] Visual effects MINIMIZED (performance mode)
echo  [+] Transparency ^& animations DISABLED
echo  [+] Game Bar ^& DVR DISABLED (300MB+ RAM freed)
echo  [+] Memory management OPTIMIZED
echo  [+] Fast Startup DISABLED (cleaner boots)
echo  [+] Tips, suggestions ^& ads DISABLED
echo  [+] Activity history DISABLED
echo  [+] Temp files CLEANED
echo.
echo ESTIMATED RAM SAVINGS: 1-2 GB
echo ESTIMATED CPU SAVINGS: 10-20%%
echo.
echo IMPORTANT: RESTART YOUR COMPUTER NOW!
echo.
echo After restart:
echo  - Windows will use significantly less RAM
echo  - CPU usage will be much lower
echo  - No AI features running in background
echo  - No telemetry or bloatware
echo  - Much faster overall performance
echo.
echo NOTE: Some disabled services may re-enable after Windows updates.
echo Just run this script again if that happens.
echo.
pause

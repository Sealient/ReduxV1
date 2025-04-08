@echo off
chcp 65001 >nul
title 🛠️ Windows Optimization Center - Sealient Edition
color 0A
mode con: cols=90 lines=35

@echo off
setlocal enabledelayedexpansion

:: Define versions and URLs
set "local_version=2.0.0"
set "version_url=https://raw.githubusercontent.com/Sealient/NightLib/refs/heads/main/version.txt"
set "script_url=https://raw.githubusercontent.com/Sealient/NightLib/refs/heads/main/tes.bat"

:: Get remote version (simplified approach)
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('%version_url%', '%TEMP%\version.txt')"
set /p remote_version=<"%TEMP%\version.txt"
del "%TEMP%\version.txt"

echo Local version: %local_version%
echo Remote version: %remote_version%

:: Compare versions (simplified comparison)
if "%local_version%" == "%remote_version%" (
    echo You have the latest version.
) else (
    echo Update available! Downloading new version...
    powershell -Command "(New-Object System.Net.WebClient).DownloadFile('%script_url%', '%~dpn0_new.bat')"
    echo Update downloaded. Replacing old version...
    
    :: Create an update bridge script that will replace the file and run the new version
    echo @echo off > "%TEMP%\update_bridge.bat"
    echo timeout /t 1 >> "%TEMP%\update_bridge.bat"
    echo copy /y "%~dpn0_new.bat" "%~f0" >> "%TEMP%\update_bridge.bat"
    echo del "%~dpn0_new.bat" >> "%TEMP%\update_bridge.bat"
    echo start "" "%~f0" >> "%TEMP%\update_bridge.bat"
    echo exit >> "%TEMP%\update_bridge.bat"
    
    :: Run the update bridge and exit
    start "" "%TEMP%\update_bridge.bat"
    exit
)

:: Main menu
:mainMenu
echo This is the main menu
echo Local version: %local_version%
pause
exit /b

:: Get system info
for /f "tokens=2 delims==" %%i in ('wmic computersystem get name /value') do set "PC_NAME=%%i"
for /f "tokens=2 delims==" %%i in ('wmic computersystem get username /value') do set "USER_NAME=%%i"
net session >nul 2>&1 && set "IS_ADMIN=1" || set "IS_ADMIN=0"

:mainMenu
cls
echo.
echo ╔════════════════════════════════════════════════════════════════════════════╗
echo ║                      WINDOWS OPTIMIZATION CENTER                           ║
echo ╚════════════════════════════════════════════════════════════════════════════╝
echo.
echo   📅 Date: %date%      ⏰ Time: %time%
echo   🖥️  Computer Name: %PC_NAME%      👤 User: %USER_NAME%
echo   🔐 Admin Rights: %IS_ADMIN%
echo.
echo ╔══════════════════════════════════╗
echo ║         MAIN MENU                ║
echo ╠══════════════════════════════════╣
echo ║ [1] System Optimization           ║
echo ║ [2] Disk Cleanup                  ║
echo ║ [3] Service Management            ║
echo ║ [4] Performance Tweaks            ║
echo ║ [5] Network Settings              ║
echo ║ [6] Privacy Settings              ║
echo ║ [7] Security Enhancements         ║
echo ║ [0] Exit                          ║
echo ╚══════════════════════════════════╝
echo.
set /p opt=Choose an option: 

if "%opt%"=="1" goto systemOpt
if "%opt%"=="2" goto diskCleanup
if "%opt%"=="3" goto serviceMgmt
if "%opt%"=="4" goto perfTweaks
if "%opt%"=="5" goto netSettings
if "%opt%"=="6" goto privacySettings
if "%opt%"=="7" goto securityEnhancements
if "%opt%"=="0" exit
goto mainMenu

:systemOpt
cls
echo.
echo ╔══════════════════════════════════════════════════════╗
echo ║             SYSTEM OPTIMIZATION MODULE               ║
echo ╚══════════════════════════════════════════════════════╝
echo.
echo [1] Clear Temporary Files
echo [2] Defragment Drives
echo [3] System File Check (SFC)
echo [4] Disk Check (CHKDSK)
echo [5] Optimize Startup
echo [6] Update Windows
echo [7] Clean Registry (built-in cleanup)
echo [8] Power Plan Optimization
echo [9] Back to Main Menu
echo.
set /p soopt=Enter your choice: 

if "%soopt%"=="1" goto clearTemp
if "%soopt%"=="2" goto defrag
if "%soopt%"=="3" goto sfc
if "%soopt%"=="4" goto chkdsk
if "%soopt%"=="5" goto startup
if "%soopt%"=="6" goto update
if "%soopt%"=="7" goto cleanRegistry
if "%soopt%"=="8" goto powerPlan
if "%soopt%"=="9" goto mainMenu
goto systemOpt

:diskCleanup
cls
echo.
echo ╔══════════════════════════════════════════════════════╗
echo ║                DISK CLEANUP MODULE                   ║
echo ╚══════════════════════════════════════════════════════╝
echo.
echo [1] Quick Cleanup
echo [2] Deep Cleanup
echo [3] Clean System Restore Points
echo [4] Remove Windows Update Cache
echo [5] Back to Main Menu
echo.
set /p dcopt=Enter your choice: 

if "%dcopt%"=="1" goto quickClean
if "%dcopt%"=="2" goto deepClean
if "%dcopt%"=="3" goto cleanRestore
if "%dcopt%"=="4" goto updateCache
if "%dcopt%"=="5" goto mainMenu
goto diskCleanup

:: ===============================
:: ===== SYSTEM OPT FUNCTIONS ===
:: ===============================

:clearTemp
cls
echo 🧹 Clearing temporary files...
del /q /f /s %TEMP%\*
del /q /f /s C:\Windows\Temp\*
echo ✅ Done!
pause
goto systemOpt

:defrag
cls
echo 🔄 Defragmenting C: drive...
defrag C: /U /V
echo ✅ Done!
pause
goto systemOpt

:sfc
cls
echo 🧰 Running System File Checker...
sfc /scannow
pause
goto systemOpt

:chkdsk
cls
echo 💽 Running CHKDSK (may require restart)...
chkdsk C: /F
pause
goto systemOpt

:startup
cls
echo 🚀 Opening Startup Folder...
start shell:startup
echo 🔧 Tip: Use Task Manager > Startup tab for full control.
pause
goto systemOpt

:update
cls
echo 🔄 Opening Windows Update Settings...
start ms-settings:windowsupdate
pause
goto systemOpt

:cleanRegistry
cls
echo 🧼 Running basic registry cleanup...
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /va /f >nul 2>&1
echo ✅ Registry startup keys cleared.
pause
goto systemOpt

:powerPlan
cls
echo ⚡ Setting power plan to High Performance...
powercfg -setactive SCHEME_MIN
echo ✅ Power plan optimized.
pause
goto systemOpt

:: ===============================
:: ===== DISK CLEAN FUNCTIONS ===
:: ===============================

:quickClean
cls
echo 🧹 Performing Quick Cleanup...
del /s /f /q "%TEMP%\*.*"
del /s /f /q "C:\Windows\Temp\*.*"
echo ✅ Quick Cleanup completed.
pause
goto diskCleanup

:deepClean
cls
echo 🧹 Performing Deep Cleanup (including `cleanmgr`)...
cleanmgr /sagerun:1
echo ✅ Deep Cleanup triggered.
pause
goto diskCleanup

:cleanRestore
cls
echo 🧼 Cleaning old System Restore Points (keeping latest)...
vssadmin delete shadows /for=C: /oldest
echo ✅ Old restore points cleaned.
pause
goto diskCleanup

:updateCache
cls
echo 🔧 Removing Windows Update Cache...
net stop wuauserv
net stop bits
del /f /s /q "C:\Windows\SoftwareDistribution\Download\*"
net start wuauserv
net start bits
echo ✅ Windows Update Cache cleared.
pause
goto diskCleanup

:serviceMgmt
cls
echo.
echo ╔══════════════════════════════════════════════════════╗
echo ║               SERVICE MANAGEMENT MODULE              ║
echo ╚══════════════════════════════════════════════════════╝
echo.
echo [1] View Running Services
echo [2] Optimize Windows Services
echo [3] Start/Stop Individual Services
echo [4] Disable Print Spooler
echo [5] Disable Windows Search
echo [6] Disable Superfetch (SysMain)
echo [7] Restore Default Services
echo [8] Back to Main Menu
echo.
set /p svcopt=Enter your choice: 

if "%svcopt%"=="1" goto viewServices
if "%svcopt%"=="2" goto optimizeServices
if "%svcopt%"=="3" goto controlService
if "%svcopt%"=="4" goto disablePrint
if "%svcopt%"=="5" goto disableSearch
if "%svcopt%"=="6" goto disableSuperfetch
if "%svcopt%"=="7" goto restoreServices
if "%svcopt%"=="8" goto mainMenu
goto serviceMgmt

:viewServices
cls
echo 🧾 Running Services:
echo ====================
tasklist /svc | more
pause
goto serviceMgmt

:optimizeServices
cls
echo.
echo ╔════════════════════════════════════════╗
echo ║ CHOOSE OPTIMIZATION PROFILE            ║
echo ╠════════════════════════════════════════╣
echo ║ [1] Safe                               ║
echo ║ [2] Balanced                           ║
echo ║ [3] Aggressive                         ║
echo ║ [4] Custom (manual control)            ║
echo ║ [5] Back                               ║
echo ╚════════════════════════════════════════╝
echo.
set /p mode=Choose optimization level: 

if "%mode%"=="1" goto optimizeSafe
if "%mode%"=="2" goto optimizeBalanced
if "%mode%"=="3" goto optimizeAggressive
if "%mode%"=="4" goto controlService
if "%mode%"=="5" goto serviceMgmt
goto optimizeServices

:optimizeSafe
cls
echo 🔧 Applying SAFE optimization...
sc config "DiagTrack" start= disabled
sc config "MapsBroker" start= disabled
sc config "XblGameSave" start= disabled
echo ✅ Safe profile applied.
pause
goto serviceMgmt

:optimizeBalanced
cls
echo ⚖️ Applying BALANCED optimization...
sc config "DiagTrack" start= disabled
sc config "MapsBroker" start= disabled
sc config "XblGameSave" start= disabled
sc config "Fax" start= disabled
sc config "RetailDemo" start= disabled
echo ✅ Balanced profile applied.
pause
goto serviceMgmt

:optimizeAggressive
cls
echo ⚠️ Applying AGGRESSIVE optimization...
sc config "DiagTrack" start= disabled
sc config "MapsBroker" start= disabled
sc config "XblGameSave" start= disabled
sc config "Fax" start= disabled
sc config "RetailDemo" start= disabled
sc config "PhoneSvc" start= disabled
sc config "WSearch" start= disabled
sc config "PrintSpooler" start= disabled
sc config "SysMain" start= disabled
echo ✅ Aggressive profile applied.
pause
goto serviceMgmt

:controlService
cls
set /p sname=🔍 Enter the service name (e.g., WSearch): 
echo.
echo [1] Start %sname%
echo [2] Stop %sname%
echo [3] Disable %sname%
echo [4] Enable %sname%
echo [5] Back
set /p sopt=Choose an option: 

if "%sopt%"=="1" sc start "%sname%"
if "%sopt%"=="2" sc stop "%sname%"
if "%sopt%"=="3" sc config "%sname%" start= disabled
if "%sopt%"=="4" sc config "%sname%" start= auto
pause
goto serviceMgmt

:disablePrint
cls
echo 🖨️ Disabling Print Spooler...
sc stop "Spooler"
sc config "Spooler" start= disabled
echo ✅ Print Spooler disabled.
pause
goto serviceMgmt

:disableSearch
cls
echo 🔎 Disabling Windows Search...
sc stop "WSearch"
sc config "WSearch" start= disabled
echo ✅ Windows Search disabled.
pause
goto serviceMgmt

:disableSuperfetch
cls
echo 🧠 Disabling Superfetch (SysMain)...
sc stop "SysMain"
sc config "SysMain" start= disabled
echo ✅ Superfetch disabled.
pause
goto serviceMgmt

:restoreServices
cls
echo ♻️ Restoring default settings for key services...
sc config "Spooler" start= auto
sc config "WSearch" start= delayed-auto
sc config "SysMain" start= auto
sc config "DiagTrack" start= auto
sc config "MapsBroker" start= demand
sc config "XblGameSave" start= demand
echo ✅ Services restored to default.
pause
goto serviceMgmt

:perfTweaks
cls
echo.
echo ╔══════════════════════════════════════════════════════╗
echo ║             PERFORMANCE TWEAKS MODULE                ║
echo ╚══════════════════════════════════════════════════════╝
echo.
echo [1] Visual Effects Optimization
echo [2] Reduce Startup Programs
echo [3] Optimize Virtual Memory
echo [4] Enable Large System Cache
echo [5] Clear Memory Cache
echo [6] Disable Memory Compression
echo [7] CPU Priority Boost
echo [8] Clear Page File at Shutdown
echo [9] Optimize Gaming Performance
echo [10] SSD Optimization
echo [11] Disable Unnecessary Services
echo [12] Back to Main Menu
echo.
set /p perfopt=Enter your choice: 

if "%perfopt%"=="1" goto visEffects
if "%perfopt%"=="2" goto reduceStartup
if "%perfopt%"=="3" goto virtualMem
if "%perfopt%"=="4" goto largeCache
if "%perfopt%"=="5" goto clearMem
if "%perfopt%"=="6" goto disableMemComp
if "%perfopt%"=="7" goto cpuBoost
if "%perfopt%"=="8" goto clearPageFile
if "%perfopt%"=="9" goto gameBoost
if "%perfopt%"=="10" goto ssdOpt
if "%perfopt%"=="11" goto disableUnneeded
if "%perfopt%"=="12" goto mainMenu
goto perfTweaks

:visEffects
cls
echo 🎨 Optimizing visual effects for performance...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f
reg add "HKCU\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d 9012038010000000 /f
reg add "HKCU\Control Panel\Desktop" /v DragFullWindows /t REG_SZ /d 0 /f
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 0 /f
echo ✅ Visual effects optimized.
pause
goto perfTweaks

:reduceStartup
cls
echo 🚫 Reducing startup programs...
start shell:startup
echo 🔧 Tip: Use Task Manager > Startup tab to disable more apps.
pause
goto perfTweaks

:virtualMem
cls
echo 💾 Optimizing Virtual Memory (manual review)...
SystemPropertiesPerformance
echo 🔧 Go to Advanced > Virtual Memory to adjust page file.
pause
goto perfTweaks

:largeCache
cls
echo 💡 Enabling Large System Cache...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v LargeSystemCache /t REG_DWORD /d 1 /f
echo ✅ Large System Cache enabled.
pause
goto perfTweaks

:clearMem
cls
echo 🧹 Clearing memory cache...
%windir%\system32\rundll32.exe advapi32.dll,ProcessIdleTasks
echo ✅ Memory cache cleared.
pause
goto perfTweaks

:disableMemComp
cls
echo 🧠 Disabling memory compression (Windows 10+ only)...
PowerShell -Command "Disable-MMAgent -MemoryCompression"
echo ✅ Memory compression disabled.
pause
goto perfTweaks

:cpuBoost
cls
echo ⚡ Boosting foreground application CPU priority...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 26 /f
echo ✅ CPU priority tweak applied.
pause
goto perfTweaks

:clearPageFile
cls
echo 🧼 Enabling clear page file at shutdown...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v ClearPageFileAtShutdown /t REG_DWORD /d 1 /f
echo ✅ Page file will be cleared at shutdown.
pause
goto perfTweaks

:gameBoost
cls
echo 🎮 Optimizing for gaming performance...
reg add "HKCU\Software\Microsoft\GameBar" /v AllowAutoGameMode /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Microsoft\GameBar" /v AutoGameModeEnabled /t REG_DWORD /d 1 /f
echo ✅ Game Mode enabled.
pause
goto perfTweaks

:ssdOpt
cls
echo ⚙️ Enabling SSD optimizations...
fsutil behavior set disablelastaccess 1 >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v NtfsMemoryUsage /t REG_DWORD /d 2 /f
echo ✅ SSD optimizations applied.
pause
goto perfTweaks

:disableUnneeded
cls
echo 🧺 Disabling non-essential services...
sc config "Fax" start= disabled
sc config "RetailDemo" start= disabled
sc config "RemoteRegistry" start= disabled
sc config "XblGameSave" start= disabled
echo ✅ Unnecessary services disabled.
pause
goto perfTweaks

:netSettings
cls
echo.
echo ╔══════════════════════════════════════════════════════╗
echo ║              NETWORK SETTINGS MODULE                 ║
echo ╚══════════════════════════════════════════════════════╝
echo.
echo [1] Display Network Information
echo [2] Optimize TCP/IP Settings
echo [3] WiFi Signal Strength
echo [4] Speed Test (ping)
echo [5] Reset Network Settings
echo [6] Flush & Reset DNS
echo [7] Reset Network Adapter
echo [8] Advanced IP Configuration
echo [9] Back to Main Menu
echo.
set /p netopt=Enter your choice: 

if "%netopt%"=="1" goto netInfo
if "%netopt%"=="2" goto optimizeTCP
if "%netopt%"=="3" goto wifiStrength
if "%netopt%"=="4" goto speedTest
if "%netopt%"=="5" goto resetNet
if "%netopt%"=="6" goto flushDNS
if "%netopt%"=="7" goto resetAdapter
if "%netopt%"=="8" goto ipConfig
if "%netopt%"=="9" goto mainMenu
goto netSettings

:netInfo
cls
echo 🌐 Network Information:
echo ==========================
ipconfig /all | more
pause
goto netSettings

:optimizeTCP
cls
echo 🚀 Optimizing TCP/IP stack...
netsh int tcp set global autotuninglevel=normal
netsh int tcp set global chimney=enabled
netsh int tcp set global rss=enabled
netsh int tcp set global dca=enabled
echo ✅ TCP/IP settings optimized.
pause
goto netSettings

:wifiStrength
cls
echo 📶 WiFi Signal Strength:
netsh wlan show interfaces | findstr /i "SSID Signal"
pause
goto netSettings

:speedTest
cls
echo ⚡ Pinging Google DNS (8.8.8.8)...
ping 8.8.8.8 -n 5
echo ✅ Speed check complete (approximate).
pause
goto netSettings

:resetNet
cls
echo 🔁 Resetting all network settings...
netsh int ip reset
netsh winsock reset
ipconfig /release
ipconfig /renew
echo ✅ Network settings reset.
pause
goto netSettings

:flushDNS
cls
echo 🔄 Flushing DNS and resetting cache...
ipconfig /flushdns
netsh int ip reset
netsh winsock reset
echo ✅ DNS flushed and reset.
pause
goto netSettings

:resetAdapter
cls
echo ♻️ Restarting network adapter...
set /p adapter=Enter adapter name (e.g. "Wi-Fi"): 
netsh interface set interface "%adapter%" admin=disable
timeout /t 2 >nul
netsh interface set interface "%adapter%" admin=enable
echo ✅ Adapter reset.
pause
goto netSettings

:ipConfig
cls
echo.
echo ╔══════════════════════════════════════╗
echo ║        ADVANCED IP CONFIGURATION     ║
echo ╚══════════════════════════════════════╝
echo.
echo [1] Set Static IP
echo [2] Set Dynamic IP (DHCP)
echo [3] Configure Public DNS
echo [4] Reset IP Configuration
echo [5] Back
set /p ipopt=Choose: 

if "%ipopt%"=="1" goto setStaticIP
if "%ipopt%"=="2" goto setDHCP
if "%ipopt%"=="3" goto setDNS
if "%ipopt%"=="4" goto resetIP
if "%ipopt%"=="5" goto netSettings
goto ipConfig

:setStaticIP
cls
set /p adapter=Adapter name (e.g. "Ethernet"): 
set /p ip=IP Address (e.g. 192.168.1.100): 
set /p mask=Subnet Mask (e.g. 255.255.255.0): 
set /p gw=Default Gateway (e.g. 192.168.1.1): 
netsh interface ip set address name="%adapter%" static %ip% %mask% %gw%
echo ✅ Static IP set.
pause
goto ipConfig

:setDHCP
cls
set /p adapter=Adapter name (e.g. "Ethernet"): 
netsh interface ip set address name="%adapter%" source=dhcp
netsh interface ip set dns name="%adapter%" source=dhcp
echo ✅ Dynamic IP (DHCP) enabled.
pause
goto ipConfig

:setDNS
cls
set /p adapter=Adapter name (e.g. "Ethernet"): 
echo 🛡️ Setting DNS to Google (8.8.8.8 / 8.8.4.4)...
netsh interface ip set dns name="%adapter%" static 8.8.8.8
netsh interface ip add dns name="%adapter%" 8.8.4.4 index=2
echo ✅ Public DNS applied.
pause
goto ipConfig

:resetIP
cls
echo 🔁 Resetting IP configuration...
netsh int ip reset
ipconfig /release
ipconfig /renew
echo ✅ IP settings refreshed.
pause
goto ipConfig

:privacySettings
cls
echo.
echo ╔══════════════════════════════════════════════════════╗
echo ║                PRIVACY SETTINGS MODULE               ║
echo ╚══════════════════════════════════════════════════════╝
echo.
echo [1] Disable Telemetry & Data Collection
echo [2] App Permissions Management
echo [3] Web & Browser Privacy
echo [4] Cortana & Search Privacy
echo [5] Activity History & Timeline
echo [6] Windows Update Privacy
echo [7] Microsoft Account Privacy
echo [8] Speech, Inking & Typing Privacy
echo [9] Back to Main Menu
echo.
set /p privacyopt=Enter your choice: 

if "%privacyopt%"=="1" goto telemetryData
if "%privacyopt%"=="2" goto appPermissions
if "%privacyopt%"=="3" goto browserPrivacy
if "%privacyopt%"=="4" goto cortanaSearch
if "%privacyopt%"=="5" goto activityHistory
if "%privacyopt%"=="6" goto winUpdatePrivacy
if "%privacyopt%"=="7" goto msAccountPrivacy
if "%privacyopt%"=="8" goto speechInking
if "%privacyopt%"=="9" goto mainMenu
goto privacySettings

:telemetryData
cls
echo 🕵️ Disabling Telemetry & Data Collection...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v Enabled /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Feedback" /v Frequency /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\TailoredExperiences" /v Enabled /t REG_DWORD /d 0 /f
echo ✅ Telemetry & Data Collection disabled.
pause
goto privacySettings

:appPermissions
cls
echo 🔒 Managing App Permissions...
start ms-settings:privacy-apps
echo ✅ App permissions management window opened.
pause
goto privacySettings

:browserPrivacy
cls
echo 🌐 Clearing browser privacy...
start ms-settings:privacy-webbrowser
echo ✅ Browser privacy options opened.
pause
goto privacySettings

:cortanaSearch
cls
echo 🔍 Configuring Cortana & Search Privacy...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v CortanaConsent /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v DisableSearchHistory /t REG_DWORD /d 1 /f
echo ✅ Cortana disabled and search history cleared.
pause
goto privacySettings

:activityHistory
cls
echo 📅 Clearing Activity History & Timeline...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ActivityCache" /v Disabled /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v RecentApps /t REG_DWORD /d 0 /f
echo ✅ Activity history cleared and timeline disabled.
pause
goto privacySettings

:winUpdatePrivacy
cls
echo 🔧 Configuring Windows Update Privacy...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v DoNotConnectToWindowsUpdateInternetLocations /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v DisableAutomaticDriverUpdates /t REG_DWORD /d 1 /f
echo ✅ Windows Update privacy configured.
pause
goto privacySettings

:msAccountPrivacy
cls
echo 🛠 Configuring Microsoft Account Privacy...
start ms-settings:sync
echo ✅ Microsoft account privacy settings opened.
pause
goto privacySettings

:speechInking
cls
echo 🎤 Disabling Speech, Inking & Typing Data Collection...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Speech" /v Enabled /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\PenInput" /v DisableInkAndTyping /t REG_DWORD /d 1 /f
echo ✅ Speech, Inking & Typing data collection disabled.
pause
goto privacySettings

:securityEnhancements
cls
echo.
echo ╔══════════════════════════════════════════════════════╗
echo ║              SECURITY ENHANCEMENTS MODULE            ║
echo ╚══════════════════════════════════════════════════════╝
echo.
echo [1] Windows Defender Settings
echo [2] Firewall Configuration
echo [3] User Account Controls
echo [4] Secure Boot & BitLocker
echo [5] Windows Update Security
echo [6] Security Auditing
echo [7] Network Security
echo [8] Ransomware Protection
echo [9] Back to Main Menu
echo.
set /p secopt=Enter your choice: 

if "%secopt%"=="1" goto defenderSettings
if "%secopt%"=="2" goto firewallConfig
if "%secopt%"=="3" goto uacSettings
if "%secopt%"=="4" goto secureBootBitLocker
if "%secopt%"=="5" goto winUpdateSecurity
if "%secopt%"=="6" goto securityAuditing
if "%secopt%"=="7" goto networkSecurity
if "%secopt%"=="8" goto ransomwareProtection
if "%secopt%"=="9" goto mainMenu
goto securityEnhancements

:defenderSettings
cls
echo 🛡️ Configuring Windows Defender Settings...
start ms-settings:defender
echo ✅ Windows Defender settings opened.
pause
goto securityEnhancements

:firewallConfig
cls
echo 🔥 Configuring Firewall Settings...
start wf.msc
echo ✅ Windows Firewall settings opened.
pause
goto securityEnhancements

:uacSettings
cls
echo ⚙️ Configuring User Account Control (UAC) settings...
start ms-settings:uac
echo ✅ UAC settings window opened.
pause
goto securityEnhancements

:secureBootBitLocker
cls
echo 🔒 Configuring Secure Boot & BitLocker settings...
start ms-settings:bitlocker
echo ✅ BitLocker settings window opened.
pause
goto securityEnhancements

:winUpdateSecurity
cls
echo 🔄 Configuring Windows Update Security settings...
start ms-settings:windowsupdate
echo ✅ Windows Update settings window opened.
pause
goto securityEnhancements

:securityAuditing
cls
echo 🕵️ Configuring Security Auditing and Event Log settings...
start secpol.msc
echo ✅ Security Auditing settings window opened.
pause
goto securityEnhancements

:networkSecurity
cls
echo 🌐 Configuring Network Security settings...
start ms-settings:network
echo ✅ Network Security settings window opened.
pause
goto securityEnhancements

:ransomwareProtection
cls
echo 🛑 Configuring Ransomware Protection...
start ms-settings:ransomware-protection
echo ✅ Ransomware protection settings window opened.
pause
goto securityEnhancements


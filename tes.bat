@echo off
chcp 65001 >nul
title 🛠️ Windows Optimization Center - Sealient Edition
color 0A
mode con: cols=90 lines=35

@echo off
setlocal enabledelayedexpansion

:: Define versions and URLs
set "local_version=2.1.0"
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

echo Local version: %local_version%
pause

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

if "%opt%"=="1" goto systemOptimization
if "%opt%"=="2" goto diskCleanup
if "%opt%"=="3" goto serviceMgmt
if "%opt%"=="4" goto perfTweaks
if "%opt%"=="5" goto netSettings
if "%opt%"=="6" goto privacySettings
if "%opt%"=="7" goto securityEnhancements
if "%opt%"=="0" exit
goto mainMenu

:systemOptimization
cls
echo ╔══════════════════════════════════════════════════════╗
echo ║            SYSTEM OPTIMIZATION MODULE               ║
echo ╚══════════════════════════════════════════════════════╝
echo.
echo [1] Clear Temporary Files
echo [2] Defragment Drives
echo [3] System File Check (SFC)
echo [4] Disk Check (CHKDSK)
echo [5] Optimize Startup
echo [6] Update Windows
echo [7] Clean Registry
echo [8] Power Plan Optimization
echo [9] Back to Main Menu
echo.
set /p opt=Enter your choice: 

if "%opt%"=="1" goto clearTempFiles
if "%opt%"=="2" goto defragmentDrives
if "%opt%"=="3" goto systemFileCheck
if "%opt%"=="4" goto diskCheck
if "%opt%"=="5" goto optimizeStartup
if "%opt%"=="6" goto updateWindows
if "%opt%"=="7" goto cleanRegistry
if "%opt%"=="8" goto powerPlanOptimization
if "%opt%"=="9" goto mainMenu
goto systemOptimization


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

:clearTempFiles
cls
echo 🧹 Clearing Temporary Files...
echo.
echo [1] Clear Windows Temp Files
echo [2] Clear Browser Cache
echo [3] Clear System Caches (Pre-fetch, etc.)
echo [4] Clear All
echo [5] Back to System Optimization Menu
set /p tempOpt=Enter your choice: 

if "%tempOpt%"=="1" goto clearWindowsTemp
if "%tempOpt%"=="2" goto clearBrowserCache
if "%tempOpt%"=="3" goto clearSystemCaches
if "%tempOpt%"=="4" goto clearAllTemp
if "%tempOpt%"=="5" goto systemOptimization
goto clearTempFiles

:clearWindowsTemp
echo Clearing Windows Temp...
del /q /f %temp%\*
echo ✅ Windows Temp files cleared.
pause
goto clearTempFiles

:clearBrowserCache
cls
echo 🧹 Clearing Browser Cache...
echo.
echo [1] Clear Chrome Browser Cache
echo [2] Clear Firefox Browser Cache
echo [3] Clear Edge Browser Cache
echo [4] Clear Opera Browser Cache
echo [5] Clear Internet Explorer Cache
echo [6] Clear All Browsers' Cache
echo [7] Back to System Optimization Menu
set /p browserOpt=Enter your choice: 

if "%browserOpt%"=="1" goto clearChromeCache
if "%browserOpt%"=="2" goto clearFirefoxCache
if "%browserOpt%"=="3" goto clearEdgeCache
if "%browserOpt%"=="4" goto clearOperaCache
if "%browserOpt%"=="5" goto clearIECache
if "%browserOpt%"=="6" goto clearAllBrowserCache
if "%browserOpt%"=="7" goto systemOptimization
goto clearBrowserCache

:clearChromeCache
echo Clearing Chrome Browser Cache...
rd /s /q "%localappdata%\Google\Chrome\User Data\Default\Cache"
rd /s /q "%localappdata%\Google\Chrome\User Data\Default\Media Cache"
echo ✅ Chrome Browser Cache cleared.
pause
goto clearBrowserCache

:clearFirefoxCache
echo Clearing Firefox Browser Cache...
rd /s /q "%appdata%\Mozilla\Firefox\Profiles\*\cache2"
rd /s /q "%appdata%\Mozilla\Firefox\Profiles\*\cache"
echo ✅ Firefox Browser Cache cleared.
pause
goto clearBrowserCache

:clearEdgeCache
echo Clearing Edge Browser Cache...
rd /s /q "%localappdata%\Microsoft\Edge\User Data\Default\Cache"
rd /s /q "%localappdata%\Microsoft\Edge\User Data\Default\Media Cache"
echo ✅ Edge Browser Cache cleared.
pause
goto clearBrowserCache

:clearOperaCache
echo Clearing Opera Browser Cache...
rd /s /q "%appdata%\Opera Software\Opera Stable\Cache"
rd /s /q "%appdata%\Opera Software\Opera Stable\Media Cache"
echo ✅ Opera Browser Cache cleared.
pause
goto clearBrowserCache

:clearIECache
echo Clearing Internet Explorer Cache...
del /q /f "%localappdata%\Microsoft\Windows\INetCache\IE\*"
echo ✅ Internet Explorer Cache cleared.
pause
goto clearBrowserCache

:clearAllBrowserCache
echo Clearing Cache for All Browsers...
rd /s /q "%localappdata%\Google\Chrome\User Data\Default\Cache"
rd /s /q "%localappdata%\Google\Chrome\User Data\Default\Media Cache"
rd /s /q "%appdata%\Mozilla\Firefox\Profiles\*\cache2"
rd /s /q "%appdata%\Mozilla\Firefox\Profiles\*\cache"
rd /s /q "%localappdata%\Microsoft\Edge\User Data\Default\Cache"
rd /s /q "%localappdata%\Microsoft\Edge\User Data\Default\Media Cache"
rd /s /q "%appdata%\Opera Software\Opera Stable\Cache"
rd /s /q "%appdata%\Opera Software\Opera Stable\Media Cache"
del /q /f "%localappdata%\Microsoft\Windows\INetCache\IE\*"
echo ✅ All Browser Caches cleared.
pause
goto clearBrowserCache

:clearSystemCaches
echo Clearing System Caches (Prefetch, etc.)...
del /q /f C:\Windows\Prefetch\*
echo ✅ System caches cleared.
pause
goto clearTempFiles

:clearAllTemp
echo Clearing All Temporary Files...
del /q /f %temp%\*
rd /s /q "%localappdata%\Google\Chrome\User Data\Default\Cache"
del /q /f C:\Windows\Prefetch\*
echo ✅ All temporary files cleared.
pause
goto clearTempFiles

:defragmentDrives
cls
echo 📀 Defragmenting Drives...
echo.
echo [1] Defragment C: Drive
echo [2] Defragment D: Drive
echo [3] Defragment All Drives
echo [4] Back to System Optimization Menu
set /p fragOpt=Enter your choice: 

if "%fragOpt%"=="1" goto defragC
if "%fragOpt%"=="2" goto defragD
if "%fragOpt%"=="3" goto defragAll
if "%fragOpt%"=="4" goto systemOptimization
goto defragmentDrives


:defragC
echo Defragmenting C: Drive...
defrag C: /O
echo ✅ C: Drive defragmented.
pause
goto defragmentDrives

:defragD
echo Defragmenting D: Drive...
defrag D: /O
echo ✅ D: Drive defragmented.
pause
goto defragmentDrives

:defragAll
echo Defragmenting All Drives...
defrag C: /O
defrag D: /O
echo ✅ All drives defragmented.
pause
goto defragmentDrives


:systemFileCheck
cls
echo 🛠 Running System File Check (SFC)...
sfc /scannow
echo ✅ System File Check complete.
pause
goto systemOptimization


:diskCheck
cls
echo 🛠 Running Disk Check (CHKDSK)...
echo.
echo [1] Check C: Drive
echo [2] Check D: Drive
echo [3] Check All Drives
echo [4] Back to System Optimization Menu
set /p diskOpt=Enter your choice: 

if "%diskOpt%"=="1" goto checkC
if "%diskOpt%"=="2" goto checkD
if "%diskOpt%"=="3" goto checkAll
if "%diskOpt%"=="4" goto systemOptimization
goto diskCheck

:checkC
echo Checking C: Drive for errors...
chkdsk C: /f /r
echo ✅ C: Drive check complete.
pause
goto diskCheck

:checkD
echo Checking D: Drive for errors...
chkdsk D: /f /r
echo ✅ D: Drive check complete.
pause
goto diskCheck

:checkAll
echo Checking All Drives for errors...
chkdsk C: /f /r
chkdsk D: /f /r
echo ✅ All drives checked.
pause
goto diskCheck

:optimizeStartup
cls
echo 🚀 Optimizing Startup...
echo.
echo [1] View Startup Programs
echo [2] Disable Startup Program
echo [3] Enable Startup Program
echo [4] Back to System Optimization Menu
set /p startupOpt=Enter your choice: 

if "%startupOpt%"=="1" goto viewStartupPrograms
if "%startupOpt%"=="2" goto disableStartupProgram
if "%startupOpt%"=="3" goto enableStartupProgram
if "%startupOpt%"=="4" goto systemOptimization
goto optimizeStartup

:viewStartupPrograms
echo Viewing Startup Programs...
start msconfig
pause
goto optimizeStartup

:disableStartupProgram
echo Enter the name of the program to disable:
set /p prog=Program Name: 
echo Disabling %prog%...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "%prog%" /t REG_SZ /f
echo ✅ %prog% disabled at startup.
pause
goto optimizeStartup

:enableStartupProgram
echo Enter the name of the program to enable:
set /p prog=Program Name: 
echo Enabling %prog%...
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "%prog%" /f
echo ✅ %prog% enabled at startup.
pause
goto optimizeStartup

:update
cls
echo 🔄 Opening Windows Update Settings...
start ms-settings:windowsupdate
pause
goto systemOpt

:cleanRegistry
cls
echo 🧹 Cleaning the Registry...
echo.
echo [1] Clean Unused File Extensions
echo [2] Clean Empty Registry Keys
echo [3] Clean Windows Installer Cache
echo [4] Clean Old Windows Updates
echo [5] Back to System Optimization Menu
set /p regOpt=Enter your choice: 

if "%regOpt%"=="1" goto cleanFileExtensions
if "%regOpt%"=="2" goto cleanEmptyKeys
if "%regOpt%"=="3" goto cleanInstallerCache
if "%regOpt%"=="4" goto cleanWindowsUpdates
if "%regOpt%"=="5" goto systemOptimization
goto cleanRegistry

:cleanFileExtensions
echo Cleaning Unused File Extensions...
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts" /f
echo ✅ Unused File Extensions cleaned.
pause
goto cleanRegistry

:cleanEmptyKeys
echo Cleaning Empty Registry Keys...
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Uninstall" /f
echo ✅ Empty Registry Keys cleaned.
pause
goto cleanRegistry

:cleanInstallerCache
echo Cleaning Windows Installer Cache...
rd /s /q "C:\Windows\Installer"
echo ✅ Windows Installer Cache cleaned.
pause
goto cleanRegistry

:cleanWindowsUpdates
echo Cleaning Old Windows Updates...
rd /s /q "C:\Windows\SoftwareDistribution\Download"
echo ✅ Old Windows Updates cleaned.
pause
goto cleanRegistry


:powerPlanOptimization
cls
echo ⚡ Power Plan Optimization...
echo.
echo [1] Set High Performance Power Plan
echo [2] Set Balanced Power Plan
echo [3] Set Power Saver Plan
echo [4] Restore Default Power Plan Settings
echo [5] Back to System Optimization Menu
set /p powerOpt=Enter your choice: 

if "%powerOpt%"=="1" goto highPerformance
if "%powerOpt%"=="2" goto balancedPower
if "%powerOpt%"=="3" goto powerSaver
if "%powerOpt%"=="4" goto restoreDefaultPower
if "%powerOpt%"=="5" goto systemOptimization
goto powerPlanOptimization

:highPerformance
echo Setting High Performance Power Plan...
powercfg -change -standby-timeout-ac 0
powercfg -change -monitor-timeout-ac 5
powercfg -change -disk-timeout-ac 0
echo ✅ High Performance Power Plan applied.
pause
goto powerPlanOptimization

:balancedPower
echo Setting Balanced Power Plan...
powercfg -change -standby-timeout-ac 10
powercfg -change -monitor-timeout-ac 10
powercfg -change -disk-timeout-ac 10
echo ✅ Balanced Power Plan applied.
pause
goto powerPlanOptimization

:powerSaver
echo Setting Power Saver Plan...
powercfg -change -standby-timeout-ac 20
powercfg -change -monitor-timeout-ac 15
powercfg -change -disk-timeout-ac 20
echo ✅ Power Saver Plan applied.
pause
goto powerPlanOptimization

:restoreDefaultPower
echo Restoring Default Power Plan Settings...
powercfg -restoredefaultschemes
echo ✅ Default Power Plan Settings restored.
pause
goto powerPlanOptimization


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
start ms-settings:windowsdefender
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
start ms-settings:privacy
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
start eventvwr.msc
echo ✅ Event Viewer opened for security auditing.
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



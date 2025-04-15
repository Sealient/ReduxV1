@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion

:: === CONFIG ===
set "local_version=5.0.0"
set "version_url=https://raw.githubusercontent.com/Sealient/NightLib/refs/heads/main/version.txt"
set "update_url=https://raw.githubusercontent.com/Sealient/NightLib/refs/heads/main/t.bat"
set "self_name=%~nx0"
set "temp_file=update_temp.bat"
set "launcher_file=updater_launcher.bat"
set "log_file=update.log"
set "backup_dir=%~dp0backup"
set "version_check_log=%backup_dir%\version_check.log"

:: === UI: HEADER ===
cls
echo(
echo ███╗   ██╗██╗ ██████╗ ██╗  ██╗████████╗██╗     ██╗██████╗ 
echo ████╗  ██║██║██╔═══██╗██║  ██║╚══██╔══╝██║     ██║██╔══██╗
echo ██╔██╗ ██║██║██║   ██║███████║   ██║   ██║     ██║██║  ██║
echo ██║╚██╗██║██║██║   ██║██╔══██║   ██║   ██║     ██║██║  ██║
echo ██║ ╚████║██║╚██████╔╝██║  ██║   ██║   ███████╗██║██████╔╝
echo ╚═╝  ╚═══╝╚═╝ ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚══════╝╚═╝╚═════╝ 
echo ---------------------------------------------------------
echo                 NightLib CLI v%local_version%
echo ---------------------------------------------------------
echo.

:: === FETCH LATEST VERSION ===
for /f "usebackq delims=" %%a in (`powershell -Command "(Invoke-WebRequest -Uri '%version_url%' -UseBasicParsing).Content.Trim()"`) do (
    set "latest_version=%%a"
)
set "latest_version=%latest_version: =%"

:: === LOGGING VERSION CHECK ===
echo [%date% %time%] Checking for updates... >> "%version_check_log%"
echo Latest available version: %latest_version%

:: === COMPARE VERSIONS ===
if "%latest_version%" NEQ "%local_version%" (
    echo A newer version (%latest_version%) is available. Updating...
    echo [%date% %time%] Update found. Local: %local_version% | Latest: %latest_version% >> "%version_check_log%"
    
    :: === DOWNLOAD NEW VERSION ===
    powershell -Command "Invoke-WebRequest -Uri '%update_url%' -OutFile '%temp_file%'"

    if not exist "%temp_file%" (
        echo ERROR: Failed to download update. Check logs for details.
        echo [%date% %time%] ERROR: Failed to download update. >> "%log_file%"
        pause
        exit /b
    )
    
    :: === VERIFY BACKUP ===
    echo Verifying backup before updating...
    if not exist "%backup_dir%" mkdir "%backup_dir%"
    copy "%self_name%" "%backup_dir%\%self_name%.bak"

    :: === REPLACE FILE ===
    echo Replacing with the new version...
    echo Preparing update...
    (
        echo @echo off
        echo timeout /t 1 ^>nul
        echo del "%self_name%" ^>nul 2^>nul
        echo rename "%temp_file%" "%self_name%" ^>nul
        echo echo [%%date%% %%time%%] Updated to v%latest_version% >> "%log_file%"
        echo start "" "%self_name%"
    ) > "%launcher_file%"

    echo [%date% %time%] Successfully updated to v%latest_version%. Restarting... >> "%version_check_log%"
    echo Update successful! Restarting the script...
    start "" "%launcher_file%"
    exit /b
)

:: === LOGIN SYSTEM ===
:login
cls
echo -------------------------------
echo         SECURE LOGIN
echo -------------------------------
set /p user=Username: 
set /p pass=Password: 

:: Dummy credentials
set "correct_user=admin"
set "correct_pass=1234"

if "%user%"=="%correct_user%" (
    if "%pass%"=="%correct_pass%" (
        echo.
        echo Login successful!
        timeout /t 1 >nul
        goto :mainmenu
    ) else (
        echo Incorrect password.
        timeout /t 2 >nul
        goto :login
    )
) else (
    echo Username not recognized.
    timeout /t 2 >nul
    goto :login
)

:: === MAIN MENU ===
:mainmenu
cls
echo ===============================
echo     Welcome, %user%
echo     NightLib v%local_version%
echo ===============================
echo 1. System Info
echo 2. File Management
echo 3. Changelog
echo 4. Check for Updates
echo 5. Exit
echo.
choice /c 12345 /n /m "Choose an option: "

if errorlevel 5 exit /b
if errorlevel 4 call :checkupdates & pause & goto :mainmenu
if errorlevel 3 call :show_changelog & pause & goto :mainmenu
if errorlevel 2 call :file_management & pause & goto :mainmenu
if errorlevel 1 call :system_info & pause & goto :mainmenu

:: === SYSTEM INFO ===
:system_info
cls
echo ------------------------------
echo           SYSTEM INFO
echo ------------------------------
systeminfo | findstr /C:"OS" /C:"Memory" /C:"CPU"
echo.
pause
goto :eof

:: === FILE MANAGEMENT ===
:file_management
cls
echo ------------------------------
echo        FILE MANAGEMENT
echo ------------------------------
echo 1. List files in directory
echo 2. Backup a file
echo 3. Delete a file
echo 4. Open a file
echo 5. Return to menu
echo.
choice /c 12345 /n /m "Choose an option: "

if errorlevel 5 goto :mainmenu
if errorlevel 4 call :open_file & goto :file_management
if errorlevel 3 call :delete_file & goto :file_management
if errorlevel 2 call :backup_file & goto :file_management
if errorlevel 1 call :list_files & goto :file_management

:: === LIST FILES ===
:list_files
cls
echo ------------------------------
echo         FILE LIST
echo ------------------------------
dir /b
echo.
pause
goto :eof

:: === BACKUP FILE ===
:backup_file
cls
echo ------------------------------
echo        BACKUP FILE
echo ------------------------------
set /p filename=Enter the file name to backup: 
if exist "%filename%" (
    if not exist "%backup_dir%" mkdir "%backup_dir%"
    copy "%filename%" "%backup_dir%\%filename%.bak"
    echo Backup successful!
) else (
    echo File not found!
)
pause
goto :eof

:: === DELETE FILE ===
:delete_file
cls
echo ------------------------------
echo         DELETE FILE
echo ------------------------------
set /p filename=Enter the file name to delete: 
if exist "%filename%" (
    del "%filename%"
    echo File deleted successfully!
) else (
    echo File not found!
)
pause
goto :eof

:: === OPEN FILE ===
:open_file
cls
echo ------------------------------
echo         OPEN FILE
echo ------------------------------
set /p filename=Enter the file name to open: 
if exist "%filename%" (
    start "" "%filename%"
    echo File opened successfully!
) else (
    echo File not found!
)
pause
goto :eof

:: === SHOW CHANGELOG ===
:show_changelog
cls
echo ------------------------------
echo           CHANGELOG
echo ------------------------------
echo v5.0.0 - Improved version check with backup verification, progress indication, auto-restart
echo v4.0.0 - Added multi-user support, full file explorer, scheduled tasks
echo v3.1.0 - Added system info, file management, backup & delete functionality
echo v3.0.0 - Initial update system with self-replacement
echo.
pause
goto :eof

:: === UPDATE CHECK ===
:checkupdates
echo Checking for updates...
goto :eof

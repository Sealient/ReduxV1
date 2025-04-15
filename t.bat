@echo off
setlocal EnableDelayedExpansion

:: === CONFIG ===
set "local_version=2.1.0"
set "version_url=https://raw.githubusercontent.com/Sealient/NightLib/refs/heads/main/version.txt"
set "update_url=https://raw.githubusercontent.com/Sealient/NightLib/refs/heads/main/tes.bat"
set "self_name=%~nx0"
set "temp_file=update_temp.bat"
set "launcher_file=updater_launcher.bat"
set "log_file=update.log"

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

echo Latest version: %latest_version%
echo.

:: === COMPARE VERSIONS ===
if "%latest_version%" NEQ "%local_version%" (
    echo Update available. Downloading...
    powershell -Command "Invoke-WebRequest -Uri '%update_url%' -OutFile '%temp_file%'"

    if not exist "%temp_file%" (
        echo ERROR: Failed to download update. See %log_file%
        echo [%date% %time%] ERROR: Failed to download update. >> %log_file%
        pause
        exit /b
    )

    echo Preparing update script...
    (
        echo @echo off
        echo timeout /t 1 ^>nul
        echo del "%self_name%" ^>nul 2^>nul
        echo rename "%temp_file%" "%self_name%" ^>nul
        echo del "%launcher_file%" ^>nul
        echo echo [%%date%% %%time%%] Updated to v%latest_version% >> "%log_file%"
        echo start "" "%self_name%"
    ) > "%launcher_file%"

    echo Launching updater...
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
echo 2. Check for Updates
echo 3. Exit
echo.
choice /c 123 /n /m "Choose an option: "

if errorlevel 3 exit /b
if errorlevel 2 call :checkupdates & pause & goto :mainmenu
if errorlevel 1 systeminfo | more & pause & goto :mainmenu

:: === MANUAL UPDATE CHECK ===
:checkupdates
echo Checking again for updates...
goto :eof

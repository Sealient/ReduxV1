@echo off
chcp 65001 >nul
cls

:: Set URLs
set "VERSION_URL=https://raw.githubusercontent.com/Sealient/NightLib/refs/heads/main/version.txt"
set "BAT_URL=https://raw.githubusercontent.com/Sealient/NightLib/refs/heads/main/t.bat"
set "CONFIG_FILE=config.txt"
set "LOG_FILE=update_log.txt"

:: Load Configuration
call :LoadConfig

:: Initialize Log
echo %date% %time% - Script Started >> %LOG_FILE%

:: Check for updates
call :CheckForUpdates

:: Proceed to Login Menu
call :LoginMenu

exit /b

:: ============================
:: Functions Below
:: ============================

:: Load Configuration from file
:LoadConfig
for /f "tokens=1,2 delims==" %%A in (%CONFIG_FILE%) do (
    if "%%A"=="VERSION" set "CURRENT_VERSION=%%B"
    if "%%A"=="PASSWORD" set "ENCRYPTED_PASSWORD=%%B"
)
goto :eof

:: Check for version updates
:CheckForUpdates
echo Checking for updates...
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('%VERSION_URL%', 'latest_version.txt')" 2>> %LOG_FILE%

:: If failed to download version.txt
if not exist "latest_version.txt" (
    echo %date% %time% - Error: Failed to download version information. >> %LOG_FILE%
    echo Error: Failed to download version information.
    exit /b
)

:: Read the latest version
set /p latest_version=<latest_version.txt

:: Compare versions
if "%latest_version%" neq "%CURRENT_VERSION%" (
    echo Update available. Your version: %CURRENT_VERSION%, Latest version: %latest_version%
    echo Updating to version %latest_version%...

    :: Download new batch file
    powershell -Command "(New-Object System.Net.WebClient).DownloadFile('%BAT_URL%', 't.bat')" 2>> %LOG_FILE%

    :: If download fails
    if not exist "t.bat" (
        echo %date% %time% - Error: Failed to download the batch file. >> %LOG_FILE%
        echo Error: Failed to download update file. Please check your connection.
        exit /b
    )

    echo Update complete. Restarting...
    echo %date% %time% - Updated to version %latest_version% successfully. >> %LOG_FILE%
    call t.bat
    exit /b
) else (
    echo Your script is up to date.
)

goto :eof

:: ============================
:: Login Menu
:: ============================

:LoginMenu
cls
echo =======================
echo   Secure Login System
echo =======================
set /p username=Username: 
if "%username%"=="" (
    echo Error: Username cannot be empty.
    pause
    goto :LoginMenu
)

:: Simulate password decryption
call :DecryptPassword
set /p entered_password=Password: 

:: Validate login
if "%entered_password%"=="%decrypted_password%" (
    echo Login successful.
    echo %date% %time% - Successful login attempt by %username%. >> %LOG_FILE%
    :: Continue with your main application logic
    pause
) else (
    echo Invalid credentials. Please try again.
    echo %date% %time% - Failed login attempt by %username%. >> %LOG_FILE%
    pause
    goto :LoginMenu
)

goto :eof

:: ============================
:: Simulate Password Decryption
:: ============================

:DecryptPassword
:: In practice, this would decrypt an actual password. Here it's a simple placeholder.
set "decrypted_password=secret_password"
goto :eof

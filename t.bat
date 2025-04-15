@echo off
chcp 65001 >nul

:: Set the URL for version and batch file
set "VERSION_URL=https://raw.githubusercontent.com/Sealient/NightLib/refs/heads/main/version.txt"
set "BAT_URL=https://raw.githubusercontent.com/Sealient/NightLib/refs/heads/main/t.bat"
set "LOG_FILE=update_log.txt"
set "LATEST_VERSION_FILE=latest_version.txt"
set "CURRENT_VERSION=5.0.0"
set "PASSWORD_FILE=encrypted_password.txt"

:: Initialize log
echo %date% %time% - Starting update check >> %LOG_FILE%

:: Check for updates
echo Checking for updates...
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('%VERSION_URL%', '%LATEST_VERSION_FILE%')" 2>> %LOG_FILE%

:: Check if the version file was downloaded successfully
if not exist "%LATEST_VERSION_FILE%" (
    echo Error: Failed to download version information. >> %LOG_FILE%
    echo Failed to download version info. Please check your connection and try again.
    exit /b
)

:: Read the version from the downloaded file
set /p latest_version=<%LATEST_VERSION_FILE%

:: Log the latest version fetched
echo %date% %time% - Fetched latest version: %latest_version% >> %LOG_FILE%

:: Compare versions
if "%latest_version%" neq "%CURRENT_VERSION%" (
    echo Update available. Your version: %CURRENT_VERSION%, Latest version: %latest_version%
    echo Updating to version %latest_version%...

    :: Download the latest batch file (t.bat)
    powershell -Command "(New-Object System.Net.WebClient).DownloadFile('%BAT_URL%', 't.bat')" 2>> %LOG_FILE%

    :: Check if the new batch file was downloaded successfully
    if not exist "t.bat" (
        echo Error: Failed to download the updated batch file. >> %LOG_FILE%
        echo Failed to download the updated batch file. Exiting update process.
        exit /b
    )

    echo Update complete. Restarting script...
    echo %date% %time% - Update to version %latest_version% completed successfully. >> %LOG_FILE%
    call t.bat
    exit /b
) else (
    echo Your script is up to date.
)

:: Proceed to login menu
echo Please enter your credentials.
call :LoginMenu

:: End of the script
goto :eof

:: Function to handle login
:LoginMenu
:: Prompt for username
set /p username=Username: 

:: If the username is invalid, deny access
if "%username%"=="" (
    echo Error: Username cannot be empty. Please try again.
    goto :LoginMenu
)

:: Decrypt the stored password (For the sake of this example, it's a simple decryption)
call :DecryptPassword
set /p entered_password=Password: 

:: Validate login
if "%entered_password%"=="%decrypted_password%" (
    echo Login successful.
    echo %date% %time% - Successful login attempt by %username%. >> %LOG_FILE%
    :: Continue with your script logic here
    pause
) else (
    echo Invalid credentials. Please try again.
    echo %date% %time% - Failed login attempt by %username%. >> %LOG_FILE%
    goto :LoginMenu
)

:: Function to simulate password decryption (In practice, this should be done securely)
:DecryptPassword
:: Simulating password decryption. Replace with actual encryption/decryption logic.
set "decrypted_password=secret_password"
goto :eof

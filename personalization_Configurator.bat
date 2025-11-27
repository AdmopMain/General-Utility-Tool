@echo off
setlocal EnableDelayedExpansion
mode con: cols=76 lines=36
title personalization Configurator For General Utility Tool - By admop

:: Set config file path for saving color preferences
set "CONFIG_DIR=%APPDATA%\General_Utility_Tool"
set "CONFIG_FILE=%CONFIG_DIR%\config.ini"

:MENU
echo ===============================
echo Customization Menu
echo ===============================
echo [1] launch General_Utility_Tool
echo [2] Apply new font
echo [3] Reset font to default
echo [4] Color scheme
echo [5] Exit
echo ===============================
set /p choice=Choose an option: 
if "%choice%"=="1" goto :COLOR_CONFIRMED
if "%choice%"=="2" goto :FONTMENU
if "%choice%"=="3" goto :RESETFONT
if "%choice%"=="4" goto :COLOR_PICKER
if "%choice%"=="5" exit (
	echo Exiting the tool.
    for /l %%i in (3,-1,1) do (
		echo Exiting in %%i...
		timeout /t 1 /nobreak >nul
    )
    exit /b 0
)
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :MENU

:FONTMENU
echo ===============================
echo Font Installer
echo ===============================
echo [1] Install Consolas
echo [2] Install Cascadia Mono
echo [3] Install TF2 Build (custom)
echo [4] Back to main menu
echo ===============================
set /p fontchoice=Choose a font: 
if "%fontchoice%"=="1" call :INSTALLFONT "https://github.com/microsoft/cascadia-code/releases/download/v2404.23/CascadiaCode-2404.23.zip" "Consolas" "Consola.ttf"
if "%fontchoice%"=="2" call :INSTALLFONT "https://github.com/microsoft/cascadia-code/releases/download/v2404.23/CascadiaCode-2404.23.zip" "Cascadia Mono" "CascadiaMono.ttf"
if "%fontchoice%"=="3" call :INSTALLFONT "https://www.ffonts.net/zip/t/f/tf2-build.zip" "TF2 Build" "TF2Build.ttf"
if "%fontchoice%"=="4" goto MENU

goto :FONTMENU

:INSTALLFONT
:: %1 = URL, %2 = Font Name, %3 = Font File
set FONTURL=%~1
set FONTNAME=%~2
set FONTFILE=%~3
set ZIPFILE=%TEMP%\fontdl.zip
set DESTFONTS=%WINDIR%\Fonts

echo Downloading %FONTNAME%...
powershell -command "Invoke-WebRequest '%FONTURL%' -OutFile '%ZIPFILE%'"

:: Extract font (if zipped)
powershell -command "Expand-Archive -Path '%ZIPFILE%' -DestinationPath '%TEMP%' -Force" >nul 2>&1

:: Copy TTF file (may need adjusting if inside subfolder)
for /r "%TEMP%" %%f in (%FONTFILE%) do (
copy "%%f" "%DESTFONTS%" >nul 2>&1
set FOUND=1
goto :foundfont
)

:foundfont
if not defined FOUND (
echo Could not find %FONTFILE% in archive.
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :eof
)

echo Adding registry entries for %FONTNAME%...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" /v "%FONTNAME% (TrueType)" /t REG_SZ /d %FONTFILE% /f

reg add "HKCU\Console" /v FaceName /t REG_SZ /d "%FONTNAME%" /f
reg add "HKCU\Console" /v FontSize /t REG_DWORD /d 0x00100000 /f

echo Font %FONTNAME% applied! Open a new CMD window to see the change.
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :eof

:RESETFONT
echo Resetting font to default (Consolas 16)...
reg add "HKCU\Console" /v FaceName /t REG_SZ /d "Consolas" /f
reg add "HKCU\Console" /v FontSize /t REG_DWORD /d 0x00100000 /f
echo Done! Open a new CMD window to see the reset.
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto MENU

:: Color picker menu
:COLOR_PICKER
echo.
echo Select a text Background color (current color: !SAVED_COLOR!):
echo [0] Black
echo.
echo [1] Blue----------------Preview: [44mExample[0m
echo.
echo [2] Green---------------Preview: [42mExample[0m
echo.
echo [3] Aqua----------------Preview: [46mExample[0m
echo.
echo [4] Red-----------------Preview: [41mExample[0m
echo.
echo [5] Purple--------------Preview: [45mExample[0m
echo.
echo [6] Yellow--------------Preview: [103mExample[0m
echo.
echo [7] White---------------Preview: [107mExample[0m
echo.
echo [8] Gray----------------Preview: [100mExample[0m
echo.
echo [9] Light Blue----------Preview: [104mExample[0m
echo.
echo [A] Light Green---------Preview: [102mExample[0m
echo.
echo [B] Cyan----------------Preview: [106mExample[0m
echo.
echo [C] Light Red-----------Preview: [101mExample[0m
echo.
echo [D] Light Purple--------Preview: [105mExample[0m
echo.
echo [E] Light Yellow--------Preview: [103mExample[0m
echo.
echo [F] Bright White--------Preview: [107mExample[0m
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
    goto :COLOR_PICKER
)

:BACKGROUND_PICKER
echo.
echo Select a foreground color:
echo [0] Black
echo.
echo [1] Blue----------------Preview: [34mExample[0m
echo.
echo [2] Green---------------Preview: [32mExample[0m
echo.
echo [3] Aqua----------------Preview: [36mExample[0m
echo.
echo [4] Red-----------------Preview: [31mExample[0m
echo.
echo [5] Purple--------------Preview: [35mExample[0m
echo.
echo [6] Yellow--------------Preview: [33mExample[0m
echo.
echo [7] White---------------Preview: [37mExample[0m
echo.
echo [8] Gray----------------Preview: [90mExample[0m
echo.
echo [9] Light Blue----------Preview: [94mExample[0m
echo.
echo [A] Light Green---------Preview: [92mExample[0m
echo.
echo [B] Cyan----------------Preview: [36mExample[0m
echo.
echo [C] Light Red-----------Preview: [91mExample[0m
echo.
echo [D] Light Purple--------Preview: [95mExample[0m
echo.
echo [E] Light Yellow--------Preview: [93mExample[0m
echo.
echo [F] Bright White--------Preview: [97mExample[0m
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
echo [3] Go back to main menu
set "CONFIRM_CHOICE="
set /p CONFIRM_CHOICE=Enter your choice (1-3): 
if "!CONFIRM_CHOICE!"=="1" (
    :: Save the color choice to config file
    if not exist "!CONFIG_DIR!" mkdir "!CONFIG_DIR!" 2>nul
    echo Color=!NEW_COLOR! > "!CONFIG_FILE!"
    set "SAVED_COLOR=!NEW_COLOR!"
    goto :COLOR_CONFIRMED
)
if "!CONFIRM_CHOICE!"=="2" (
    :: Revert to saved color and try again
    color !SAVED_COLOR!
    goto :COLOR_PICKER
)

if "!CONFIRM_CHOICE!"=="3" (
    :: Revert to saved color and try again
    color !SAVED_COLOR!
    goto :MENU
)

echo Invalid choice. Please enter 1,2 or 3.
color !SAVED_COLOR!
pause
if exist "!CONFIG_FILE!" (
    for /f "tokens=2 delims==" %%C in ('findstr /B "Color=" "!CONFIG_FILE!"') do (
        set "SAVED_COLOR=%%C"
        color !SAVED_COLOR!
    )
)
goto :COLOR_PICKER

:COLOR_CONFIRMED
echo Color selection complete. Launching General Utility Tool...
:: Launch General_Utility_Tool.exe
start "" General_Utility_Tool.exe
exit /b 0
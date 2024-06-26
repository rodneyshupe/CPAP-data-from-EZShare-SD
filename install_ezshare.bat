@ECHO OFF
SETLOCAL

SET venv_name=%USERPROFILE%\.venv\ezshare_resmed
CALL :check_python python_exists

IF %python_exists%==0 (
    ECHO Python not installed, please install
    EXIT /B 1
)

CALL :check_venv %venv_name%,venv_exists

IF %venv_exists%==0 (
    CALL :create_venv %venv_name%
)

CALL :install_deps %venv_name%
mkdir %USERPROFILE%\.local\bin
mkdir %USERPROFILE%\.config\ezshare_resmed
copy ezshare_resmed.cmd %USERPROFILE%\.local\bin
copy ezshare_resmed.py %USERPROFILE%\.local\bin
IF NOT EXIST "%USERPROFILE%\.config\ezshare_resmed\config.ini" (
    copy ezshare_resmed_default.ini %USERPROFILE%\.config\ezshare_resmed\config.ini
)

SET script_dir=%~dp0
SET ps_script_path=%script_dir%local_bin_path.ps1
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& '%ps_script_path%'";

echo.
echo Installation complete
echo Default configuration file is %USERPROFILE%\.config\ezshare_resmed\config.ini
echo Run with:
echo.
echo ezshare_resmed

EXIT /B %ERRORLEVEL%

:create_venv
python -m venv %~1
EXIT /B 0

:install_deps
CALL %~1\Scripts\activate.bat

IF EXIST ".\requirements.txt" (
    pip install -r ".\requirements.txt"
)

IF EXIST ".\setup.py" (
    pip install -e .
)
EXIT /B 0

:check_venv
IF EXIST "%~1\" (
    SET /A %~2=1
) ELSE (
    SET /A %~2=0
)
EXIT /B 0

:check_python
WHERE python >nul 2>nul
IF %ERRORLEVEL% EQU 0 (
    SET /A %~1=1
) ELSE (
    SET /A %~1=0
)
EXIT /B 0

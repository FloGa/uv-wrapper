@echo off

rem This script can be used to call the uv-wrapper Bash script with git-bash.
rem On some Windows systems, "bash" refers to the Ubuntu WSL, which is not
rem what we want here. Instead, we are searching for the "git" executable and
rem call the "bash" executable in the same folder.
rem
rem It can be called like the Bash script: .\uv.bat -V

rem Author: Florian Gamböck <uv-wrapper@mail.floga.de>
rem Version: 0.2.0-SNAPSHOT
rem Repository: https://github.com/FloGa/uv-wrapper
rem
rem SPDX-License-Identifier: 0BSD
rem
rem This file is intentionally license-light to allow frictionless reuse. Feel
rem free to copy and paste this script into your own projects and adjust if
rem necessary. No attribution or license text is required.

rem Required for !-syntax.
setlocal enabledelayedexpansion

rem Try all Git executables in the PATH.
for /f "delims=" %%i in ('where git') do (
    set git_path=%%i

    rem Extract the directory of git.
    for %%j in ("!git_path!") do (
        set git_dir=%%~dpj
    )

    rem Build the path to the bash executable. Since git can be found in bin
    rem or in cmd directory, we need to explicitly go up and use the bin
    rem directory, since bash only resides there.
    set bash_path=!git_dir!..\bin\bash.exe

    rem Check if the bash executable exists.
    if exist "!bash_path!" (
        rem Call the bash executable with the uv-wrapper Bash script and the
        rem rest of the arguments. The path of the Bash script is determined
        rem by the path of this script, without the file extension.
        "!bash_path!" "%~dp0%~n0" %*
        exit /b
    )
)

rem Bash was not found, but was Git found at least?
if defined git_path (
    echo Bash executable was not found in any Git install directory.>&2
) else (
    echo Git executable was not found.>&2
)

rem If this point has been reached, Bash could not be found, so exit with an
rem error status.
exit /b 1

endlocal

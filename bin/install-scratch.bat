@echo OFF
cd %CD%/..

rem Set parameters
set ORG_ALIAS=automation-components

@echo:
echo Installing Automation Components scratch org (%ORG_ALIAS%)
@echo:

rem Install script
echo Cleaning previous scratch org...
cmd.exe /c sf org delete scratch -p -o %ORG_ALIAS% 2>NUL
@echo:

echo Creating scratch org...
cmd.exe /c sf org create scratch -d -f config/project-scratch-def.json -y 30 -c -a %ORG_ALIAS%
call :checkForError
@echo:

echo Pushing source...
cmd.exe /c sf project deploy start
call :checkForError
@echo:

rem Report install success if no error
@echo:
if ["%errorlevel%"]==["0"] (
  echo Installation completed.
  @echo:
  cmd.exe /c sf org open -p lightning/page/home
)

:: ======== FN ======
GOTO :EOF

rem Display error if the install has failed
:checkForError
if NOT ["%errorlevel%"]==["0"] (
    echo Installation failed.
    exit /b %errorlevel%
)
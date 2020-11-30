@echo OFF

rem Set parameters
set ORG_ALIAS=automation-components

@echo:
echo Installing Automation Components scratch org (%ORG_ALIAS%)
@echo:

rem Install script
echo Cleaning previous scratch org...
cmd.exe /c sfdx force:org:delete -p -u %ORG_ALIAS% 2>NUL
@echo:

echo Creating scratch org...
cmd.exe /c sfdx force:org:create -s -f config/project-scratch-def.json -a %ORG_ALIAS% -d 30
call :checkForError
@echo:

echo Pushing source...
cmd.exe /c sfdx force:source:push -f -u %ORG_ALIAS%
call :checkForError
@echo:

echo Assigning permissions...
cmd.exe /c sfdx force:user:permset:assign -n Streaming_Monitor -u %ORG_ALIAS%
call :checkForError
@echo:

rem Report install success if no error
@echo:
if ["%errorlevel%"]==["0"] (
  echo Installation completed.
  @echo:
  cmd.exe /c sfdx force:org:open -p lightning/page/home -u %ORG_ALIAS%
)

:: ======== FN ======
GOTO :EOF

rem Display error if the install has failed
:checkForError
if NOT ["%errorlevel%"]==["0"] (
    echo Installation failed.
    exit /b %errorlevel%
)
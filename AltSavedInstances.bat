@echo off
chcp 65001

rem cd to script's directory
cd %~dp0

echo const data = {};>data.js

rem out of AltSavedInstances, out of Addons, out of Interface, (main wow dir), into WTF, into Account

setlocal EnableDelayedExpansion
for /D %%a in (.\..\..\..\WTF\Account\*) do (
    set account=%%~na
    for /D %%r in (.\..\..\..\WTF\Account\!account!\*) do (
        set realm=%%~nr
        if not "!realm!" == "SavedVariables" (
            for /D %%c in (.\..\..\..\WTF\Account\!account!\!realm!\*) do (
                set character=%%~nc
                if exist .\..\..\..\WTF\Account\!account!\!realm!\!character!\SavedVariables\AltSavedInstances.lua (
                    for /f "tokens=*" %%l in (.\..\..\..\WTF\Account\!account!\!realm!\!character!\SavedVariables\AltSavedInstances.lua) do (
                        set data=%%l
                        set data=!data:AltSavedInstances_DB=data['%%~nc-%%~nr']!
                        echo !data!>>data.js
                    )
                )
            )
        )
    )
)

setlocal DisableDelayedExpansion

start AltSavedInstances.html
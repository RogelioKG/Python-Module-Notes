@echo off
setlocal enabledelayedexpansion

:LOOP
set /p "expeceted_module=Module: "

if "%expeceted_module%"=="" (
    goto :END
)

for /d %%i in (*) do (
    for /d %%j in ("%%i/*") do (
        set "module=%%j"
        set "module=!module:S(=!"
        set "module=!module:T(=!"
        set "module=!module:)=!"
        set "module=!module:+=!"
        if "!module!"=="%expeceted_module%" (
            echo The module "%expeceted_module%" is under the subject "%%i".
            set "expeceted_module_path=.\%%i\%%j"
            goto :OPT
        )
    )
)
echo The module "%expeceted_module%" does not exist.
set "expeceted_module="
goto :LOOP

:OPT
echo.
set /p "option=Go to the directory (-g) / Open in VScode (-o): "
if "%option%"=="-g" (
    explorer "%expeceted_module_path%"
    goto :END
)
if "%option%"=="-o" (
    code "%expeceted_module_path%"
    goto :END
)
if "%option%"=="" (
    goto :END
)

:END
endlocal
exit /b 0
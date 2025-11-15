@echo off
setlocal enabledelayedexpansion 

:: 列寬度
set width=60

:: 計算目錄總大小
set total_size=0

:: 計算目錄模組總數量
set total_module_count=0
set learned_module_count=0

for /d %%i in (*) do (
    set "subdir=%%i"

    :: 計算子目錄模組數量
    set total_module_count_in_subdir=0
    set learned_module_count_in_subdir=0

    for /d %%j in ("!subdir!\*") do (
        set "module=%%j"

        set /a total_module_count_in_subdir+=1
        set /a total_module_count+=1
        if "!module:~-1,1!" NEQ "+" (
            set /a learned_module_count_in_subdir+=1
            set /a learned_module_count+=1
        )
    )

    :: 計算子目錄大小
    set size=0
    pushd "!subdir!"
    for /r %%k in (*) do (
        set /a size+=%%~zk
        set /a total_size+=%%~zk
    )
    popd

    :: 輸出字串 (子目錄)
    call :StrLen learned_module_count_in_subdir len_1
    call :StrLen total_module_count_in_subdir len_2
    set /a n_1=3-len_1
    set /a n_2=3-len_2
    call :DupChar " " !n_1! spaces_1
    call :DupChar " " !n_2! spaces_2
    set "info_string=!spaces_1!!learned_module_count_in_subdir! / !spaces_2!!total_module_count_in_subdir! modules in !subdir!"
    call :Unit !size! size_string
    call :StrLen info_string info_len
    call :StrLen size_string size_len
    set /a n=%width%-info_len-size_len
    call :DupChar " " !n! spaces
    echo !info_string!!spaces!!size_string!
)

:: 水平分隔線
call :DupChar "-" %width% hr
echo %hr%

:: 輸出字串 (目錄)
call :StrLen learned_module_count len_1
call :StrLen total_module_count len_2
set /a n_1=3-len_1
set /a n_2=3-len_2
call :DupChar " " %n_1% spaces_1
call :DupChar " " %n_2% spaces_2
set "info_string=%spaces_1%%learned_module_count% / %spaces_2%%total_module_count% modules you have learned"
call :Unit %total_size% size_string
call :StrLen info_string info_len
call :StrLen size_string size_len
set /a n=width-info_len-size_len
call :DupChar " " %n% spaces
echo %info_string%%spaces%%size_string%

endlocal
pause > nul
exit /b 0


:StrLen
rem %1 字串, %2 字串長度 (回傳值)
set len=0
:loop
if "!%1:~%len%!" NEQ "" (
    set /a len+=1
    goto :loop
)
set %2=%len%
goto :eof

:DupChar
rem %1 字元, %2 重複次數, %3 字串 (回傳值)
set "%3="
for /l %%l in (1, 1, %2) do (
    set "%3=!%3!%~1"
)
goto :eof

:Unit
rem %1 位元組數, %2 適當單位 (回傳值)
set quotient=%1
if %quotient% LSS 1000 (
    set "%2=%quotient%  B"
    goto :eof
)
set /a quotient=%1/1000
if %quotient% LSS 1000 (
    set "%2=%quotient% KB"
    goto :eof
)
set /a quotient=quotient/1000
if %quotient% LSS 1000 (
    set "%2=%quotient% MB"
    goto :eof
)
set /a quotient=quotient/1000
if %quotient% LSS 1000 (
    set "%2=%quotient% GB"
    goto :eof
)
set /a quotient=quotient/1000
set "%2=%quotient% TB"
goto :eof
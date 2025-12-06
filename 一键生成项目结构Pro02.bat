@echo off
chcp 65001 >nul 2>&1
title 生成项目树形结构

:: 1. 输入文件名（自动加 .txt）
set "out_file=project_structure.txt"
set /p "out_file=请输入生成的结构文件名（直接回车默认：%out_file%）： "
if "%out_file%"=="" set "out_file=project_structure.txt"
echo "%out_file%" | findstr /i "\.txt$" >nul
if errorlevel 1 set "out_file=%out_file%.txt"

:: 2. 备份旧文件
if exist "%out_file%" (
    echo [提示] 已存在 %out_file%，正在备份为 %out_file%.bak
    move /y "%out_file%" "%out_file%.bak" >nul
)

:: 3. 检查 tree 命令
where tree >nul 2>&1
if %errorlevel% neq 0 (
    echo [错误] 当前系统找不到 tree 命令，无法继续！
    pause
    exit /b
)

:: 4. 生成 tree 输出（GBK）
tree /f > temp_tree.txt

:: 5. 用 GBK 读取，写成 UTF-8
powershell -NoProfile -Command ^
    "$tree = Get-Content 'temp_tree.txt' -Encoding Default; [System.IO.File]::WriteAllLines('%~dp0%out_file%', $tree, [System.Text.Encoding]::UTF8)"

:: 6. 添加简单标题（UTF-8）
powershell -NoProfile -Command ^
    "$header = @('==========================================', '项目文件夹结构（tree /f 生成）', '==========================================', ''); [System.IO.File]::WriteAllLines('temp_header.txt', $header, [System.Text.Encoding]::UTF8)"

:: 7. 合并标题 + 内容
powershell -NoProfile -Command ^
    "$h = Get-Content 'temp_header.txt' -Encoding UTF8; $b = Get-Content '%~dp0%out_file%' -Encoding UTF8; [System.IO.File]::WriteAllLines('%~dp0%out_file%', $h + $b, [System.Text.Encoding]::UTF8)"

:: 8. 清理
del temp_tree.txt temp_header.txt >nul 2>&1

:: 9. 完成
echo.
echo ✅ 结构已生成至：%~dp0%out_file%
echo    可直接用文本编辑器打开，或贴给 AI 阅读。
echo.
pause
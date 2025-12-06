@echo off
:: 本地仓库 添加/修改 远程地址（支持 HTTPS & SSH）
chcp 65001 >nul
title Git 添加远程地址
color 0B

:: 必须在仓库里
if not exist .git (
    echo [ERROR] 当前目录不是 Git 仓库！
    pause & exit /b 1
)

:: 读取当前远程（若有则显示）
echo ===== 当前远程 =====
git remote -v 2>nul || echo 无远程
echo ====================

:: 选择协议
choice /C HS /N /M "协议：H=HTTPS  S=SSH "
if %errorlevel%==1 (set "proto=https") else (set "proto=ssh")

:: 输入仓库信息
set /p "user=GitHub 用户名："
set /p "repo=GitHub 仓库名："
if "%user%"=="" (
    echo [ERROR] 用户名不能为空！
    pause & exit /b 1
)
if "%repo%"=="" (
    echo [ERROR] 仓库名不能为空！
    pause & exit /b 1
)

:: 拼接地址
if "%proto%"=="https" (
    set "url=https://github.com/%user%/%repo%.git"
) else (
    set "url=git@github.com:%user%/%repo%.git"
)

:: 添加 / 覆盖 origin
git remote remove origin 2>nul
git remote add origin "%url%"

echo ===== 已设置 =====
echo 协议  : %proto%
echo 地址  : %url%
echo ==================
echo 完成！按任意键退出...
pause & exit /b
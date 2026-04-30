@echo off
:: GitHub 超级工具箱 v3.0 - 新增本地回滚功能
chcp 936 >nul
title GitHub 工具箱 Pro
color 0F

:: ========== 0. 环境检测 ==========
where git >nul 2>&1
if %errorlevel% neq 0 (
    echo [FATAL] 未检测到 Git，请先安装 Git 并配置到系统 PATH！
    pause & exit /b 1
)

:: ========== 主菜单 ==========
:MAIN_MENU
cls
color 0F
echo.
echo ===========================================
echo    GitHub 超级工具箱 v3.0
echo    融合10个脚本功能，已修复所有已知bug
echo ===========================================
echo.
echo 1. 克隆仓库 + 智能配置环境
echo 2. 本地文件夹转 Git 仓库（安全模式）
echo 3. 设置或查看本地 Git 身份
echo 4. 添加或修改远程仓库地址（支持自定义名称）
echo 5. 智能推送（支持双协议，自动排除node_modules）
echo 6. 生成项目结构树形图
echo 7. 一键执行 npm install + dev
echo 8. 完整工作流（克隆-配置-推送-启动）
echo 9. 【新增】本地回滚到远程版本（救急专用）
echo 0. 退出程序
echo.
set /p "CHOICE=请选择操作 [0-9]: "

if "%CHOICE%"=="1" goto CLONE_REPO
if "%CHOICE%"=="2" goto INIT_REPO
if "%CHOICE%"=="3" goto SET_IDENTITY
if "%CHOICE%"=="4" goto ADD_REMOTE
if "%CHOICE%"=="5" goto SMART_PUSH
if "%CHOICE%"=="6" goto GEN_TREE
if "%CHOICE%"=="7" goto NPM_DEV
if "%CHOICE%"=="8" goto FULL_WORKFLOW
if "%CHOICE%"=="9" goto ROLLBACK_LOCAL
if "%CHOICE%"=="0" goto END_PROGRAM

echo [ERROR] 无效的选择，请重新输入！
timeout /t 2 >nul
goto MAIN_MENU

:: ========== 退出程序 ==========
:END_PROGRAM
echo.
echo 感谢使用，再见！
timeout /t 1 >nul
exit /b 0

:: ========== 9. 本地回滚到远程版本（救急专用）==========
:ROLLBACK_LOCAL
color 0E
cls
echo.
echo ===========================================
echo    【本地回滚到远程版本】
echo    功能说明：把本地文件强制恢复为远程最新状态
echo    适用场景：本地改崩了 / 想放弃本地修改 / 代码冲突搞不定
echo    ?? 警告：本地未提交的修改将全部丢失！
echo ===========================================
echo.

:: 检测当前目录是否是 Git 仓库
if not exist .git (
    echo [ERROR] 当前目录不是 Git 仓库！
    echo [INFO] 请先进入你的项目文件夹，或选择菜单【1】克隆仓库
    pause
    goto MAIN_MENU
)

echo [INFO] 当前路径: %CD%
echo.

:: 显示当前 Git 身份
echo -------------------------------------------
echo 当前 Git 身份：
git config user.name 2>nul && call echo   用户名: %%user.name%% || echo   用户名: 未设置
git config user.email 2>nul && call echo   邮  箱: %%user.email%% || echo   邮  箱: 未设置
echo -------------------------------------------
echo.

:: 显示当前分支和远程信息
for /f "tokens=*" %%b in ('git symbolic-ref --short HEAD 2^>nul') do set "CUR_BRANCH=%%b"
if "%CUR_BRANCH%"=="" set "CUR_BRANCH=main"
echo [INFO] 当前分支: %CUR_BRANCH%
echo.

:: 显示远程仓库列表
echo [INFO] 检测到以下远程仓库：
git remote -v 2>nul
if %errorlevel% neq 0 (
    echo   未配置任何远程仓库！
    echo [ERROR] 没有远程仓库，无法回滚！
    pause
    goto MAIN_MENU
)
echo.

:: 让用户选择远程仓库
echo 请选择要回滚到的远程仓库：
echo   提示: 输入远程名称（通常是 origin）
set /p "REMOTE_NAME=远程名称（直接回车使用 origin）: "
if "%REMOTE_NAME%"=="" set "REMOTE_NAME=origin"

:: 验证远程是否存在
git remote 2>nul | findstr /i /c:"%REMOTE_NAME%" >nul
if %errorlevel% neq 0 (
    echo [ERROR] 远程 '%REMOTE_NAME%' 不存在！
    echo [INFO] 可用远程列表：
    git remote
    pause
    goto MAIN_MENU
)

:: 获取远程分支名
for /f "tokens=*" %%u in ('git remote show %REMOTE_NAME% 2^>nul ^| findstr /i "HEAD branch"') do (
    for /f "tokens=3" %%h in ("%%u") do set "REMOTE_BRANCH=%%h"
)
if "%REMOTE_BRANCH%"=="" set "REMOTE_BRANCH=main"

echo [INFO] 目标远程: %REMOTE_NAME%/%REMOTE_BRANCH%
echo.

:: 二次确认
echo ===========================================
echo ??  即将执行以下操作：
echo    1. 暂存当前本地修改（可选）
echo    2. 强制将本地文件恢复为 %REMOTE_NAME%/%REMOTE_BRANCH% 的最新状态
echo    3. 本地所有未提交的修改将被覆盖
echo ===========================================
echo.
choice /C YN /N /M "确认回滚？(Y=确认 / N=取消): "
if %errorlevel%==2 (
    echo [INFO] 已取消回滚
    pause
    goto MAIN_MENU
)

:: 询问是否先 stash 本地修改
echo.
echo [INFO] 是否先保存本地修改到 stash？（以后可以恢复）
choice /C YN /N /M "保存本地修改？(Y=保存 / N=直接丢弃): "
if %errorlevel%==1 (
    echo [INFO] 正在 stash 本地修改...
    git stash push -m "工具箱自动保存: %DATE% %TIME%"
    if %errorlevel% equ 0 (
        echo [SUCCESS] 本地修改已保存到 stash
        echo [INFO] 以后恢复请执行: git stash pop
    ) else (
        echo [WARN] stash 失败，可能没有需要保存的修改
    )
) else (
    echo [INFO] 直接丢弃本地修改...
)

echo.
echo [INFO] 正在从远程获取最新版本...
git fetch %REMOTE_NAME% %REMOTE_BRANCH%
if %errorlevel% neq 0 (
    echo [ERROR] 获取远程版本失败！请检查网络连接
    pause
    goto MAIN_MENU
)

echo [INFO] 正在强制回滚本地文件...
git reset --hard %REMOTE_NAME%/%REMOTE_BRANCH%
if %errorlevel% neq 0 (
    echo [ERROR] 回滚失败！
    pause
    goto MAIN_MENU
)

echo.
echo ===========================================
echo [SUCCESS] 回滚完成！
echo ===========================================
echo 本地文件已恢复为 %REMOTE_NAME%/%REMOTE_BRANCH% 的最新状态
echo.
for /f "tokens=*" %%c in ('git log -1 --oneline') do echo 最新提交: %%c
echo.
if %errorlevel% equ 0 (
    echo [INFO] 如需查看 stash 列表: git stash list
    echo [INFO] 如需恢复刚才的修改: git stash pop
)
echo ===========================================
pause
goto MAIN_MENU

:: ========== 1. 克隆仓库 ==========
:CLONE_REPO
color 0F
set /p "USER=GitHub 用户名: "
if "%USER%"=="" goto INPUT_ERROR
set /p "REPO=仓库名称: "
if "%REPO%"=="" goto INPUT_ERROR

echo.
echo 协议选择：
echo   按下 H = HTTPS (推荐新手，无需SSH密钥)
echo   按下 S = SSH (需要提前配置SSH密钥)
choice /C HS /N /M "请选择协议: "
if %errorlevel%==1 (
    set "URL=https://github.com/%USER%/%REPO%.git"
) else (
    set "URL=git@github.com:%USER%/%REPO%.git"
)

if exist "%REPO%" (
    echo [WARN] 文件夹 '%REPO%' 已存在
    choice /C YN /N /M "是否进入并配置环境？(Y/N): "
    if %errorlevel%==2 goto MAIN_MENU
    cd /d "%REPO%"
    echo [INFO] 已进入现有文件夹
) else (
    echo [INFO] 开始克隆 %URL%...
    git clone --progress "%URL%" "%REPO%"
    if not exist "%REPO%\.git" (
        echo [ERROR] 克隆失败！请检查网络、地址或SSH密钥
        pause
        goto MAIN_MENU
    )
    cd /d "%REPO%"
    echo [SUCCESS] 克隆完成！
)

call :AUTO_CONFIGURE "%USER%" "%REPO%"
pause
goto MAIN_MENU

:: ========== 2. 初始化本地仓库 ==========
:INIT_REPO
color 0F
echo "%CD%" | find /i "Desktop" >nul
if %errorlevel%==0 goto BLOCK_DESKTOP
echo "%CD%" | find /i "桌面" >nul
if %errorlevel%==0 goto BLOCK_DESKTOP

if not exist .git (
    echo [INFO] 当前目录不是Git仓库，开始初始化...
    goto DO_INIT
)

echo [WARN] 当前目录已是 Git 仓库
choice /C YN /N /M "是否删除后重新初始化？(Y/N): "
if %errorlevel%==2 goto MAIN_MENU
rmdir /s /q .git
echo [INFO] 已删除旧的 .git 文件夹"

:DO_INIT
echo "[INFO] 初始化 Git 仓库..."
git init >nul 2>&1

if not exist .gitignore (
    echo "[INFO] 创建默认 .gitignore..."
    (
        echo # === GitHub 超级工具箱 自动生成 ===
        echo node_modules/
        echo *.log
        echo .cache/
        echo dist/
        echo build/
        echo .vscode/
        echo .env
        echo .DS_Store
        echo Thumbs.db
        echo **/.git/
    ) > .gitignore
    echo "[SUCCESS] .gitignore 已创建"
)

echo "[INFO] 添加文件到暂存区..."
git add -A

set /p "USER=GitHub 用户名: "
set /p "EMAIL=邮箱: "
if "%USER%"=="" goto INPUT_ERROR
if "%EMAIL%"=="" goto INPUT_ERROR

git config user.name "%USER%"
git config user.email "%EMAIL%"
echo "[INFO] 身份已配置: %USER% <%EMAIL%>"

git commit -m "chore: initial commit" >nul 2>&1
if %errorlevel% equ 0 (
    echo [SUCCESS] 初始提交完成！"
) else (
    echo "[WARN] 提交失败（可能没有文件可提交）"
)
pause
goto MAIN_MENU

:BLOCK_DESKTOP
echo "[ERROR] 禁止在桌面或桌面文件夹初始化Git仓库！"
pause
goto MAIN_MENU

:: ========== 3. 设置身份 ==========
:SET_IDENTITY
color 0F
if not exist .git (
    echo "[ERROR] 当前目录不是Git仓库"
    pause
    goto MAIN_MENU
)

echo 当前 Git 身份配置：
git config user.name 2>nul && call echo 用户名: %%user.name%% || echo 用户名: 未设置
git config user.email 2>nul && call echo 邮箱: %%user.email%% || echo 邮箱: 未设置
echo.

set /p "NAME=新用户名 (直接回车保留当前): "
set /p "EMAIL=新邮箱 (直接回车保留当前): "

if not "%NAME%"=="" git config user.name "%NAME%"
if not "%EMAIL%"=="" git config user.email "%EMAIL%"

echo [SUCCESS] 身份设置已更新！"
git config user.name
git config user.email
pause
goto MAIN_MENU

:: ========== 4. 添加远程地址 ==========
:ADD_REMOTE
color 0F
if not exist .git (
    echo "[ERROR] 当前目录不是Git仓库"
    pause
    goto MAIN_MENU
)

echo ===========================================
echo        当前远程仓库配置
echo ===========================================
git remote -v 2>nul || echo 未配置任何远程仓库
echo ===========================================
echo.

echo 协议选择：
echo   按下 H = HTTPS (推荐新手)
echo   按下 S = SSH (需要SSH密钥)
choice /C HS /N /M "请选择协议: "
if %errorlevel%==1 (set "PROTO=https") else (set "PROTO=ssh")

echo.
echo 远程名称选择：
echo   按下 1 = origin (标准名称)
echo   按下 2 = https  (按协议命名)
echo   按下 3 = ssh    (按协议命名)
echo   按下 4 = custom (自定义名称)
choice /C 1234 /N /M "请选择远程名称: "
if %errorlevel%==1 set "REMOTE_NAME=origin"
if %errorlevel%==2 set "REMOTE_NAME=https"
if %errorlevel%==3 set "REMOTE_NAME=ssh"
if %errorlevel%==4 (
    set /p "REMOTE_NAME=请输入自定义名称: "
    if "%REMOTE_NAME%"=="" (
        echo "[ERROR] 远程名称不能为空！"
        pause
        goto MAIN_MENU
    )
)

set /p "USER=GitHub 用户名: "
if "%USER%"=="" goto INPUT_ERROR
set /p "REPO=仓库名称: "
if "%REPO%"=="" goto INPUT_ERROR

if "%PROTO%"=="https" (
    set "URL=https://github.com/%USER%/%REPO%.git"
) else (
    set "URL=git@github.com:%USER%/%REPO%.git"
)

git remote remove %REMOTE_NAME% 2>nul
git remote add %REMOTE_NAME% "%URL%"

echo ===========================================
echo        配置成功！"
echo ===========================================
echo 远程名称: %REMOTE_NAME%
echo 协议类型: %PROTO%
echo 远程地址: %URL%
echo ===========================================
pause
goto MAIN_MENU

:: ========== 5. 智能推送 ==========
:SMART_PUSH
color 0F
if not exist .git (
    echo "[ERROR] 当前目录不是Git仓库"
    pause
    goto MAIN_MENU
)

echo ===========================================
echo        当前远程仓库配置
echo ===========================================
git remote -v 2>nul
if %errorlevel% neq 0 (
    echo 未配置任何远程仓库！
    echo ===========================================
    echo 请先使用选项4添加远程地址
    pause
    goto MAIN_MENU
)
echo ===========================================
echo.

for /f "tokens=*" %%b in ('git symbolic-ref --short HEAD 2^>nul') do set "BRANCH=%%b"
if "%BRANCH%"=="" set "BRANCH=main"
echo 当前分支: %BRANCH%
echo.

echo 请选择要使用的远程仓库：
echo   提示: 根据上面的列表，输入远程名称（如 origin, ssh, https）
set /p "REMOTE_NAME=输入远程名称（直接回车使用origin）: "
if "%REMOTE_NAME%"=="" (
    set "REMOTE_NAME=origin"
)

git remote 2>nul | findstr /i /c:"%REMOTE_NAME%" >nul
if %errorlevel% neq 0 (
    echo [ERROR] 远程 '%REMOTE_NAME%' 不存在！
    echo 可用远程: 
    git remote
    pause
    goto MAIN_MENU
)

for /f "tokens=2" %%u in ('git remote -v ^| findstr /i "%REMOTE_NAME%.*fetch"') do set "CURRENT_URL=%%u"
if "%CURRENT_URL%"=="" (
    echo [ERROR] 无法获取远程地址
    pause
    goto MAIN_MENU
)

echo "%CURRENT_URL%" | findstr /i ".git" >nul
if %errorlevel% neq 0 (
    echo [ERROR] 远程URL格式不正确: %CURRENT_URL%
    echo        缺少用户名或仓库名
    echo        请使用选项4重新配置远程地址
    pause
    goto MAIN_MENU
)

set "CURRENT_PROTO=未知"
echo "%CURRENT_URL%" | findstr /i "https://" >nul && set "CURRENT_PROTO=HTTPS"
echo "%CURRENT_URL%" | findstr /i "git@" >nul && set "CURRENT_PROTO=SSH"
echo [INFO] 远程 '%REMOTE_NAME%' 的协议是: %CURRENT_PROTO%
echo.

echo 推送协议选择：
echo   按下 H = HTTPS
echo   按下 S = SSH
choice /C HS /N /M "请选择推送协议: "
if %errorlevel%==1 (
    set "PUSH_PROTO=https"
) else (
    set "PUSH_PROTO=ssh"
)

if not "%CURRENT_PROTO%"=="%PUSH_PROTO%" (
    echo [WARN] 协议不匹配（远程%CURRENT_PROTO% vs 选择%PUSH_PROTO%），正在转换...
    setlocal enabledelayedexpansion
    if "%PUSH_PROTO%"=="https" (
        set "NEW_URL=!CURRENT_URL:git@github.com:=https://github.com/ !"
    ) else (
        set "NEW_URL=!CURRENT_URL:https://github.com/=git@github.com: !"
    )
    git remote set-url %REMOTE_NAME% !NEW_URL!
    endlocal
)

echo [INFO] 使用远程: %REMOTE_NAME%"
echo [INFO] 远程地址: %CURRENT_URL%"

if exist node_modules (
    echo [INFO] 检测到 node_modules，自动从Git跟踪中剔除...
    git rm -r --cached node_modules 2>nul
)

set /p "COMMIT_MSG=提交信息 (回车=update): "
if "%COMMIT_MSG%"=="" set "COMMIT_MSG=update"

git add .
git diff --cached --quiet
if %errorlevel% equ 0 (
    git diff --quiet
    if %errorlevel% equ 0 (
        echo [INFO] 工作区干净，没有文件改动
        pause
        goto MAIN_MENU
    )
)

git commit -m "%COMMIT_MSG%"
if %errorlevel% neq 0 (
    echo [ERROR] 提交失败
    pause
    goto MAIN_MENU
)

echo [INFO] 推送到 %REMOTE_NAME% (%BRANCH%)...
git push %REMOTE_NAME% %BRANCH% 2>nul
if %errorlevel% neq 0 (
    echo [WARN] 推送失败，尝试 master 分支...
    git push %REMOTE_NAME% master 2>nul
    if %errorlevel% neq 0 (
        echo [ERROR] 推送失败！可能原因：
        echo   - 远程仓库不存在
        echo   - 没有推送权限
        echo   - 需要先执行 git pull
        pause
        goto MAIN_MENU
    )
)

echo [SUCCESS] 推送成功！
pause
goto MAIN_MENU

:: ========== 6. 生成项目结构 ==========
:GEN_TREE
color 0F
set "OUT_FILE=project_structure.txt"
if exist "%OUT_FILE%" (
    echo [INFO] 检测到旧文件，备份为 %OUT_FILE%.bak
    move /y "%OUT_FILE%" "%OUT_FILE%.bak" >nul
)

echo 正在生成项目结构树...
(
    echo ==========================================
    echo 项目结构报告
    echo 生成时间: %DATE% %TIME%
    echo 项目路径: %CD%
    echo ==========================================
    echo.
    echo [目录结构]
    tree /f
    echo.
    echo [文件统计]
    dir /s /-c ^| findstr "个文件"
) > "%OUT_FILE%"

echo [SUCCESS] 结构已生成: %CD%\%OUT_FILE%"
choice /C YN /N /M "是否打开文件查看？( 是 Y / 否 N)"
if %errorlevel%==1 start notepad "%OUT_FILE%"
pause
goto MAIN_MENU

:: ========== 7. 一键 npm dev ==========
:NPM_DEV
color 0F
if not exist package.json (
    echo [ERROR] 当前目录没有 package.json
    pause
    goto MAIN_MENU
)

echo [INFO] 执行 npm install...
call npm install
if %errorlevel% neq 0 (
    echo [ERROR] npm install 失败
    pause
    goto MAIN_MENU
)

powershell -NoP -C "(Get-Content package.json -Raw | ConvertFrom-Json).scripts.dev" > "%TEMP%\dev.txt" 2>nul
set /p "DEV_CMD=" < "%TEMP%\dev.txt" 2>nul
del "%TEMP%\dev.txt" 2>nul

if "%DEV_CMD%"=="" (
    echo [WARN] package.json 中未定义 'dev' 脚本
    echo 正在尝试自动识别项目类型...
    
    findstr /C:"\"vite\"" package.json >nul && set "DEV_CMD=vite"
    findstr /C:"\"next\"" package.json >nul && set "DEV_CMD=next dev"
    findstr /C:"\"react-scripts\"" package.json >nul && set "DEV_CMD=react-scripts start"
    findstr /C:"\"@vue/cli-service\"" package.json >nul && set "DEV_CMD=vue-cli-service serve"
    findstr /C:"\"webpack\"" package.json >nul && set "DEV_CMD=webpack serve"
    findstr /C:"\"remix\"" package.json >nul && set "DEV_CMD=remix dev"
    findstr /C:"\"gatsby\"" package.json >nul && set "DEV_CMD=gatsby develop"
    
    if not "%DEV_CMD%"=="" (
        echo [INFO] 检测到 %DEV_CMD%，自动补全 dev 脚本...
        call :ADD_DEV_SCRIPT "%DEV_CMD%"
    ) else (
        echo [ERROR] 无法自动识别启动命令
        pause
        goto MAIN_MENU
    )
)

echo [INFO] 启动开发服务器...
timeout /t 2 >nul
start cmd /k "title DEV Server & npm run dev"
goto MAIN_MENU

:ADD_DEV_SCRIPT
powershell -NoP -C ^
  "$p=Get-Content package.json -Raw | ConvertFrom-Json; $" ^
  "if(-not $p.scripts) { $p | Add-Member -Name 'scripts' -Value @{}};" ^
  "$p.scripts.dev = '%~1'; $" ^
  "$p | ConvertTo-Json -Depth 10 | Set-Content package.json"
echo [SUCCESS] 已添加 dev 脚本: %~1
goto :eof

:: ========== 8. 完整工作流 ==========
:FULL_WORKFLOW
color 0F
echo [WARNING] 即将执行完整工作流
choice /C YN /N /M "是否继续？( Y是 / N否 ): "
if %errorlevel%==2 goto MAIN_MENU

set /p "USER=GitHub 用户名: "
set /p "REPO=仓库名称: "
if "%USER%"=="" goto INPUT_ERROR
if "%REPO%"=="" goto INPUT_ERROR

echo [INFO] 步骤1/4: 克隆仓库
echo 协议选择：
echo   按下 H = HTTPS
echo   按下 S = SSH
choice /C HS /N /M "请选择协议: "
if %errorlevel%==1 (
    set "PROTO=https"
    set "URL=https://github.com/%USER%/%REPO%.git"
) else (
    set "PROTO=ssh"
    set "URL=git@github.com:%USER%/%REPO%.git"
)

if exist "%REPO%" (
    echo [WARN] 文件夹已存在，直接进入...
    cd /d "%REPO%"
) else (
    git clone "%URL%" "%REPO%"
    if not exist "%REPO%\.git" (
        echo [ERROR] 克隆失败！请检查网络、地址或SSH密钥
        pause
        goto MAIN_MENU
    )
    cd /d "%REPO%"
)

echo [INFO] 步骤2/4: 配置环境
set /p "NAME=用户名 (回车使用%USER%): "
if "%NAME%"=="" set "NAME=%USER%"
set /p "EMAIL=邮箱: "
if "%EMAIL%"=="" goto INPUT_ERROR

git config user.name "%NAME%"
git config user.email "%EMAIL%"

git remote remove origin 2>nul
git remote add origin "%URL%"

echo [INFO] 步骤3/4: 推送到远程
git add .
git commit -m "init: first commit" >nul 2>&1
git push origin main 2>nul || git push origin master 2>nul || echo [WARN] 推送失败，可能需要手动处理

echo [INFO] 步骤4/4: 启动开发环境
if exist package.json (
    call npm install
    start cmd /k "npm run dev"
)

echo [SUCCESS] 完整工作流执行完毕！
pause
goto MAIN_MENU

:: ========== 辅助函数 ==========
:AUTO_CONFIGURE
color 0F
echo 正在配置本地 Git 身份...
set /p "NAME=用户名 (回车使用 %~1): "
if "%NAME%"=="" set "NAME=%~1"
set /p "EMAIL=邮箱: "
if "%EMAIL%"=="" (
    echo [ERROR] 邮箱不能为空
    pause
    exit /b
)

git config user.name "%NAME%"
git config user.email "%EMAIL%"
echo [SUCCESS] 身份已配置: %NAME% <%EMAIL%>"

echo 正在配置远程仓库地址...
echo 协议选择：
echo   按下 H = HTTPS
echo   按下 S = SSH
choice /C HS /N /M "请选择协议: "
if %errorlevel%==1 (
    set "URL=https://github.com/%~1/%~2.git"
) else (
    set "URL=git@github.com:%~1/%~2.git"
)

git remote remove origin 2>nul
git remote add origin "%URL%"
echo [SUCCESS] 远程地址: %URL%"
goto :eof

:INPUT_ERROR
echo [ERROR] 输入不能为空！
timeout /t 2 >nul
goto MAIN_MENU
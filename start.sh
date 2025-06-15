#!/bin/sh

# 服务器配置
SERVER_BIN="/usr/local/bin/static-web-server"
DEFAULT_ARGS=(
  "--port" "7860"
  "--host" "0.0.0.0"
  "--root" "/home/lingyicute/Me"
  "-g" "debug"
)

# 显示欢迎信息
echo "[$(date +'%Y-%m-%d %H:%M:%S')] === 静态网页服务器启动脚本 ==="

# 检查可执行文件
echo "[$(date +'%Y-%m-%d %H:%M:%S')] 检查可执行文件是否存在: $SERVER_BIN"
if [ ! -x "$SERVER_BIN" ]; then
    echo "错误：找不到可执行文件或没有执行权限！"
    echo "请检查以下内容："
    echo "1. 文件路径是否正确"
    echo "2. 文件权限是否可执行"
    echo "3. 文件是否已成功安装"
    exit 1
fi

# 显示配置摘要
echo "[$(date +'%Y-%m-%d %H:%M:%S')] 服务器配置信息："
echo "  监听地址：http://0.0.0.0:7860"
echo "  网站根目录：/home/lingyicute/Me"
echo "  日志级别：debug"
echo "  重启机制：自动重启（异常退出时）"

# 服务控制变量
MAX_RESTART=50
RESTART_COUNT=0
RESTART_DELAY=1

# 持续运行服务
echo "[$(date +'%Y-%m-%d %H:%M:%S')] === 启动服务主循环 ==="
while true; do
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] 尝试启动服务（第${RESTART_COUNT}次重启尝试）"
    
    # 启动服务器
    "$SERVER_BIN" "${DEFAULT_ARGS[@]}" "$@"
    EXIT_CODE=$?
    
    # 检查退出状态
    if [ $EXIT_CODE -eq 0 ]; then
        echo "[$(date +'%Y-%m-%d %H:%M:%S')] 服务正常退出，结束运行"
        break
    else
        echo "[$(date +'%Y-%m-%d %H:%M:%S')] 服务异常退出（退出码：$EXIT_CODE）"
        
        # 限制最大重启次数
        if [ $RESTART_COUNT -ge $MAX_RESTART ]; then
            echo "[$(date +'%Y-%m-%d %H:%M:%S')] 达到最大重启次数限制（$MAX_RESTART），停止服务"
            exit 1
        fi
        
        RESTART_COUNT=$((RESTART_COUNT + 1))
        echo "[$(date +'%Y-%m-%d %H:%M:%S')] $RESTART_COUNT/${MAX_RESTART} 次重启尝试"
        echo "[$(date +'%Y-%m-%d %H:%M:%S')] $RESTART_DELAY 秒后重启服务..."
        sleep $RESTART_DELAY
    fi
done

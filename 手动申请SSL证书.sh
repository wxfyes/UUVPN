#!/bin/bash

# 手动申请Let's Encrypt证书脚本
# 适用于宝塔面板Let's Encrypt功能异常的情况

echo "=== 手动申请Let's Encrypt证书 ==="
echo "域名: tianque.126581.xyz"

# 检查是否安装了certbot
if ! command -v certbot &> /dev/null; then
    echo "正在安装certbot..."
    if command -v apt &> /dev/null; then
        apt update
        apt install -y certbot
    elif command -v yum &> /dev/null; then
        yum install -y certbot
    else
        echo "无法安装certbot，请手动安装"
        exit 1
    fi
fi

# 创建证书目录
mkdir -p /www/server/panel/vhost/cert/tianque.126581.xyz

# 申请证书
echo "正在申请证书..."
certbot certonly --webroot \
    -w /www/wwwroot/tianque.126581.xyz \
    -d tianque.126581.xyz \
    --email your-email@example.com \
    --agree-tos \
    --non-interactive

# 检查证书是否申请成功
if [ -f "/etc/letsencrypt/live/tianque.126581.xyz/fullchain.pem" ]; then
    echo "证书申请成功！"
    
    # 复制证书到宝塔面板目录
    cp /etc/letsencrypt/live/tianque.126581.xyz/fullchain.pem /www/server/panel/vhost/cert/tianque.126581.xyz/
    cp /etc/letsencrypt/live/tianque.126581.xyz/privkey.pem /www/server/panel/vhost/cert/tianque.126581.xyz/
    
    # 设置权限
    chmod 644 /www/server/panel/vhost/cert/tianque.126581.xyz/fullchain.pem
    chmod 600 /www/server/panel/vhost/cert/tianque.126581.xyz/privkey.pem
    
    echo "证书已复制到宝塔面板目录"
    echo "证书路径: /www/server/panel/vhost/cert/tianque.126581.xyz/"
    
    # 设置自动续期
    echo "设置自动续期..."
    (crontab -l 2>/dev/null; echo "0 12 * * * /usr/bin/certbot renew --quiet") | crontab -
    
    echo "=== 证书申请完成 ==="
    echo "请使用 '宝塔Nginx配置-完全SSL.txt' 配置文件"
else
    echo "证书申请失败，请检查域名解析和网站配置"
    exit 1
fi

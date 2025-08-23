#!/bin/bash

# 使用acme.sh申请Let's Encrypt证书
# acme.sh是一个更稳定的证书申请工具

echo "=== 使用acme.sh申请Let's Encrypt证书 ==="
echo "域名: tianque.126581.xyz"

# 安装acme.sh
if ! command -v acme.sh &> /dev/null; then
    echo "正在安装acme.sh..."
    curl https://get.acme.sh | sh -s email=your-email@example.com
    
    # 重新加载环境变量
    source ~/.bashrc
fi

# 创建证书目录
mkdir -p /www/server/panel/vhost/cert/tianque.126581.xyz

# 申请证书
echo "正在申请证书..."
acme.sh --issue -d tianque.126581.xyz \
    --webroot /www/wwwroot/tianque.126581.xyz \
    --server letsencrypt

# 检查证书是否申请成功
if [ -f "/root/.acme.sh/tianque.126581.xyz/tianque.126581.xyz.cer" ]; then
    echo "证书申请成功！"
    
    # 安装证书到指定目录
    acme.sh --install-cert -d tianque.126581.xyz \
        --key-file /www/server/panel/vhost/cert/tianque.126581.xyz/privkey.pem \
        --fullchain-file /www/server/panel/vhost/cert/tianque.126581.xyz/fullchain.pem \
        --reloadcmd "systemctl reload nginx"
    
    # 设置权限
    chmod 644 /www/server/panel/vhost/cert/tianque.126581.xyz/fullchain.pem
    chmod 600 /www/server/panel/vhost/cert/tianque.126581.xyz/privkey.pem
    
    echo "证书已安装到宝塔面板目录"
    echo "证书路径: /www/server/panel/vhost/cert/tianque.126581.xyz/"
    
    echo "=== 证书申请完成 ==="
    echo "请使用 '宝塔Nginx配置-完全SSL.txt' 配置文件"
else
    echo "证书申请失败，请检查域名解析和网站配置"
    exit 1
fi

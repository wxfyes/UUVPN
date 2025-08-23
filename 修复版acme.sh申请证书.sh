#!/bin/bash

# 修复版acme.sh申请Let's Encrypt证书脚本
# 解决acme.sh命令找不到的问题

echo "=== 修复版acme.sh申请Let's Encrypt证书 ==="
echo "域名: tianque.126581.xyz"

# 设置acme.sh路径
ACME_SH="$HOME/.acme.sh/acme.sh"

# 检查acme.sh是否存在
if [ ! -f "$ACME_SH" ]; then
    echo "acme.sh不存在，正在安装..."
    
    # 清理之前的安装
    rm -rf ~/.acme.sh
    
    # 重新安装acme.sh
    curl https://get.acme.sh | sh -s email=your-email@example.com
    
    # 重新加载环境变量
    source ~/.bashrc
    
    # 再次检查
    if [ ! -f "$ACME_SH" ]; then
        echo "acme.sh安装失败，请手动安装"
        exit 1
    fi
fi

echo "acme.sh路径: $ACME_SH"
echo "acme.sh版本: $($ACME_SH --version)"

# 创建证书目录
mkdir -p /www/server/panel/vhost/cert/tianque.126581.xyz

# 申请证书
echo "正在申请证书..."
$ACME_SH --issue -d tianque.126581.xyz \
    --webroot /www/wwwroot/tianque.126581.xyz \
    --server letsencrypt

# 检查证书是否申请成功
if [ -f "$HOME/.acme.sh/tianque.126581.xyz/tianque.126581.xyz.cer" ]; then
    echo "证书申请成功！"
    
    # 安装证书到指定目录
    $ACME_SH --install-cert -d tianque.126581.xyz \
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
    echo "错误日志: $HOME/.acme.sh/acme.sh.log"
    exit 1
fi

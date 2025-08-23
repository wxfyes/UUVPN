#!/bin/bash

# 生成自签名SSL证书脚本
# 适用于临时测试或开发环境

echo "=== 生成自签名SSL证书 ==="
echo "域名: tianque.126581.xyz"

# 创建证书目录
mkdir -p /www/server/panel/vhost/cert/tianque.126581.xyz

# 生成私钥
echo "生成私钥..."
openssl genrsa -out /www/server/panel/vhost/cert/tianque.126581.xyz/privkey.pem 2048

# 生成证书签名请求
echo "生成证书签名请求..."
openssl req -new -key /www/server/panel/vhost/cert/tianque.126581.xyz/privkey.pem \
    -out /www/server/panel/vhost/cert/tianque.126581.xyz/cert.csr \
    -subj "/C=CN/ST=Beijing/L=Beijing/O=UUVPN/OU=IT/CN=tianque.126581.xyz"

# 生成自签名证书
echo "生成自签名证书..."
openssl x509 -req -days 365 \
    -in /www/server/panel/vhost/cert/tianque.126581.xyz/cert.csr \
    -signkey /www/server/panel/vhost/cert/tianque.126581.xyz/privkey.pem \
    -out /www/server/panel/vhost/cert/tianque.126581.xyz/fullchain.pem

# 设置权限
chmod 644 /www/server/panel/vhost/cert/tianque.126581.xyz/fullchain.pem
chmod 600 /www/server/panel/vhost/cert/tianque.126581.xyz/privkey.pem

# 清理临时文件
rm -f /www/server/panel/vhost/cert/tianque.126581.xyz/cert.csr

echo "=== 自签名证书生成完成 ==="
echo "证书路径: /www/server/panel/vhost/cert/tianque.126581.xyz/"
echo "注意: 自签名证书会导致浏览器显示安全警告"
echo "请使用 '宝塔Nginx配置-完全SSL.txt' 配置文件"

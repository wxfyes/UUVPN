#!/bin/bash

# Android签名配置脚本
echo "🔑 Android签名密钥配置脚本"
echo "================================"

# 检查Java是否安装
if ! command -v keytool &> /dev/null; then
    echo "❌ 错误: 未找到keytool命令，请确保已安装Java JDK"
    echo "请访问: https://adoptium.net/ 下载并安装Java JDK"
    exit 1
fi

echo "✅ Java JDK已安装"

# 生成keystore
echo ""
echo "📝 开始生成签名密钥..."
echo "请按提示填写信息："
echo ""

keytool -genkey -v \
    -keystore uuvpn-release-key.keystore \
    -alias uuvpn-key \
    -keyalg RSA \
    -keysize 2048 \
    -validity 10000

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ 密钥生成成功！"
    echo ""
    
    # 转换为Base64
    echo "🔄 正在转换为Base64编码..."
    if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
        # Windows
        base64_content=$(powershell -Command "[Convert]::ToBase64String([IO.File]::ReadAllBytes('uuvpn-release-key.keystore'))")
    else
        # macOS/Linux
        base64_content=$(base64 -i uuvpn-release-key.keystore)
    fi
    
    echo ""
    echo "📋 配置信息："
    echo "================================"
    echo "1. 将以下内容添加到GitHub Secrets:"
    echo ""
    echo "SIGNING_KEY_ALIAS: uuvpn-key"
    echo "SIGNING_KEY_PASSWORD: [你设置的密钥密码]"
    echo "SIGNING_STORE_PASSWORD: [你设置的密钥库密码]"
    echo "ANDROID_KEYSTORE_BASE64: $base64_content"
    echo ""
    echo "2. 将 uuvpn-release-key.keystore 文件复制到 Android-kotlin-Code/ 目录"
    echo ""
    echo "3. 提交代码后，GitHub Actions将自动使用此密钥签名APK"
    echo ""
    echo "⚠️  重要提醒："
    echo "- 请妥善保管keystore文件和密码"
    echo "- 不要将keystore文件提交到Git仓库"
    echo "- 建议备份keystore文件到安全位置"
    
else
    echo "❌ 密钥生成失败，请检查输入信息"
    exit 1
fi

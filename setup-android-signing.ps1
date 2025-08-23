# Android签名配置脚本 (Windows PowerShell)
Write-Host "🔑 Android签名密钥配置脚本" -ForegroundColor Green
Write-Host "================================" -ForegroundColor Green

# 检查Java是否安装
try {
    $keytoolOutput = keytool -help 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Java JDK已安装" -ForegroundColor Green
    } else {
        throw "keytool not found"
    }
} catch {
    Write-Host "❌ 错误: 未找到keytool命令，请确保已安装Java JDK" -ForegroundColor Red
    Write-Host "请访问: https://adoptium.net/ 下载并安装Java JDK" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "📝 开始生成签名密钥..." -ForegroundColor Cyan
Write-Host "请按提示填写信息：" -ForegroundColor Yellow
Write-Host ""

# 生成keystore
$keytoolArgs = @(
    "-genkey",
    "-v",
    "-keystore", "uuvpn-release-key.keystore",
    "-alias", "uuvpn-key",
    "-keyalg", "RSA",
    "-keysize", "2048",
    "-validity", "10000"
)

$process = Start-Process -FilePath "keytool" -ArgumentList $keytoolArgs -Wait -PassThru -NoNewWindow

if ($process.ExitCode -eq 0) {
    Write-Host ""
    Write-Host "✅ 密钥生成成功！" -ForegroundColor Green
    Write-Host ""
    
    # 转换为Base64
    Write-Host "🔄 正在转换为Base64编码..." -ForegroundColor Cyan
    $base64Content = [Convert]::ToBase64String([IO.File]::ReadAllBytes("uuvpn-release-key.keystore"))
    
    Write-Host ""
    Write-Host "📋 配置信息：" -ForegroundColor Green
    Write-Host "================================" -ForegroundColor Green
    Write-Host "1. 将以下内容添加到GitHub Secrets:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "SIGNING_KEY_ALIAS: uuvpn-key" -ForegroundColor White
    Write-Host "SIGNING_KEY_PASSWORD: [你设置的密钥密码]" -ForegroundColor White
    Write-Host "SIGNING_STORE_PASSWORD: [你设置的密钥库密码]" -ForegroundColor White
    Write-Host "ANDROID_KEYSTORE_BASE64: $base64Content" -ForegroundColor White
    Write-Host ""
    Write-Host "2. 将 uuvpn-release-key.keystore 文件复制到 Android-kotlin-Code/ 目录" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "3. 提交代码后，GitHub Actions将自动使用此密钥签名APK" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "⚠️  重要提醒：" -ForegroundColor Red
    Write-Host "- 请妥善保管keystore文件和密码" -ForegroundColor Yellow
    Write-Host "- 不要将keystore文件提交到Git仓库" -ForegroundColor Yellow
    Write-Host "- 建议备份keystore文件到安全位置" -ForegroundColor Yellow
    
} else {
    Write-Host "❌ 密钥生成失败，请检查输入信息" -ForegroundColor Red
    exit 1
} 

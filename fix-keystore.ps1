# 修复Android Keystore Base64编码问题
Write-Host "🔧 修复Android Keystore Base64编码问题" -ForegroundColor Green
Write-Host ""

# 检查是否存在keystore文件
if (Test-Path "Android-kotlin-Code/release.keystore") {
    Write-Host "✅ 找到现有的keystore文件" -ForegroundColor Green
    
    # 读取keystore文件并生成正确的Base64
    $keystoreBytes = Get-Content "Android-kotlin-Code/release.keystore" -Encoding Byte
    $base64String = [Convert]::ToBase64String($keystoreBytes)
    
    Write-Host "📋 正确的Base64字符串:" -ForegroundColor Yellow
    Write-Host $base64String
    Write-Host ""
    Write-Host "📝 请将此字符串复制到GitHub Secrets中的 ANDROID_KEYSTORE_BASE64" -ForegroundColor Cyan
    Write-Host ""
    
    # 验证Base64是否正确
    try {
        $decodedBytes = [Convert]::FromBase64String($base64String)
        Write-Host "✅ Base64验证成功！" -ForegroundColor Green
    }
    catch {
        Write-Host "❌ Base64验证失败: $($_.Exception.Message)" -ForegroundColor Red
    }
}
else {
    Write-Host "❌ 未找到keystore文件" -ForegroundColor Red
    Write-Host ""
    Write-Host "请先运行以下命令生成keystore:" -ForegroundColor Yellow
    Write-Host "keytool -genkey -v -keystore Android-kotlin-Code/release.keystore -alias your-key-alias -keyalg RSA -keysize 2048 -validity 10000"
    Write-Host ""
    Write-Host "然后重新运行此脚本" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "🔗 GitHub Secrets设置步骤:" -ForegroundColor Cyan
Write-Host "1. 进入你的GitHub仓库" -ForegroundColor White
Write-Host "2. 点击 Settings → Secrets and variables → Actions" -ForegroundColor White
Write-Host "3. 点击 'New repository secret'" -ForegroundColor White
Write-Host "4. 名称: ANDROID_KEYSTORE_BASE64" -ForegroundColor White
Write-Host "5. 值: 上面生成的Base64字符串" -ForegroundColor White
Write-Host "6. 点击 'Add secret'" -ForegroundColor White
Write-Host ""
Write-Host "其他必需的Secrets:" -ForegroundColor Cyan
Write-Host "- ANDROID_KEYSTORE_PASSWORD: keystore密码" -ForegroundColor White
Write-Host "- ANDROID_KEY_ALIAS: 密钥别名" -ForegroundColor White
Write-Host "- ANDROID_KEY_PASSWORD: 密钥密码" -ForegroundColor White

# 简化的Android Keystore Base64修复脚本
Write-Host "🔧 修复Android Keystore Base64编码问题" -ForegroundColor Green
Write-Host ""

# 检查keystore文件
if (Test-Path "Android-kotlin-Code/release.keystore") {
    Write-Host "✅ 找到keystore文件" -ForegroundColor Green
    
    # 生成Base64
    $keystoreBytes = Get-Content "Android-kotlin-Code/release.keystore" -Encoding Byte
    $base64String = [Convert]::ToBase64String($keystoreBytes)
    
    Write-Host "📋 Base64字符串:" -ForegroundColor Yellow
    Write-Host $base64String
    Write-Host ""
    Write-Host "📝 复制到GitHub Secrets: ANDROID_KEYSTORE_BASE64" -ForegroundColor Cyan
}
else {
    Write-Host "❌ 未找到keystore文件" -ForegroundColor Red
    Write-Host "请先生成keystore文件" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "🔗 GitHub Secrets设置:" -ForegroundColor Cyan
Write-Host "1. GitHub仓库 → Settings → Secrets → Actions" -ForegroundColor White
Write-Host "2. New repository secret" -ForegroundColor White
Write-Host "3. 名称: ANDROID_KEYSTORE_BASE64" -ForegroundColor White
Write-Host "4. 值: 上面的Base64字符串" -ForegroundColor White

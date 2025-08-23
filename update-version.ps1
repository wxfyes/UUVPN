# UUVPN 版本更新脚本
# 使用方法: .\update-version.ps1 [versionCode] [versionName]

param(
    [int]$VersionCode = 323002,
    [string]$VersionName = "3.1.1"
)

Write-Host "正在更新UUVPN版本号..." -ForegroundColor Green
Write-Host "版本号: $VersionCode" -ForegroundColor Yellow
Write-Host "版本名: $VersionName" -ForegroundColor Yellow

# 读取当前文件内容
$filePath = "Android-kotlin-Code/build.gradle.kts"
$content = Get-Content $filePath -Raw

# 更新版本号
$content = $content -replace 'versionCode = \d+', "versionCode = $VersionCode"
$content = $content -replace 'versionName = "[^"]*"', "versionName = `"$VersionName`""

# 写回文件
$content | Set-Content $filePath -Encoding UTF8

Write-Host "版本更新完成！" -ForegroundColor Green
Write-Host "文件: $filePath" -ForegroundColor Cyan
Write-Host "新版本号: $VersionCode" -ForegroundColor Cyan
Write-Host "新版本名: $VersionName" -ForegroundColor Cyan

# 显示更新后的内容
Write-Host "`n更新后的版本配置:" -ForegroundColor Magenta
$content | Select-String "versionCode|versionName"

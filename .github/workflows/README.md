# GitHub Actions 工作流说明

## 📋 工作流概览

本项目包含以下GitHub Actions工作流：

### 1. **Quick Build (Skip Lint)** ⭐ 推荐使用
**用途**：快速构建测试版APK

**触发方式**：
- ✅ **手动触发**：在GitHub Actions页面手动运行
- ✅ **自动触发**：推送代码到 `develop` 或 `test` 分支

**功能**：
- 跳过Lint检查和单元测试
- 快速构建APK文件
- 上传到Artifacts（不进Release）
- 适合开发和测试阶段

**APK位置**：GitHub Actions → Artifacts → `UUVPN-Test-Build-{编号}`

---

### 2. **Release Build (Signed APK)** 🚀 正式发布
**用途**：构建正式签名版本并创建GitHub Release

**触发方式**：
- ✅ **自动触发**：推送标签（如 `v1.0.0`）到 `main` 或 `master` 分支

**功能**：
- 使用签名密钥构建APK
- 自动创建GitHub Release
- 上传到GitHub Releases页面
- 适合正式版本发布

**APK位置**：GitHub Releases + Artifacts

---

### 3. **CI** 🔍 代码质量检查
**用途**：代码质量检查和安全扫描

**触发方式**：
- ✅ **自动触发**：推送代码到 `main` 或 `master` 分支

**功能**：
- Android Lint检查（跳过错误）
- 单元测试（跳过错误）
- 安全漏洞扫描
- 不生成APK

---

## 🎯 使用指南

### 测试版构建（推荐）
```bash
# 方法1：手动触发（最简单）
# 1. 进入GitHub仓库
# 2. 点击 Actions 标签
# 3. 选择 "Quick Build (Skip Lint)"
# 4. 点击 "Run workflow"

# 方法2：推送到测试分支
git checkout -b develop
git push origin develop
```

### 正式版发布
```bash
# 创建版本标签
git tag v1.0.0
git push origin v1.0.0
```

## 📱 APK下载位置

### 测试版APK
1. 进入GitHub仓库
2. 点击 **Actions** 标签
3. 找到运行记录（绿色勾号）
4. 点击 **Artifacts** 部分
5. 下载 `UUVPN-Test-Build-{编号}`

### 正式版APK
1. 进入GitHub仓库
2. 点击 **Releases** 标签
3. 找到对应版本
4. 下载APK文件

## 🔧 配置要求

### 正式版构建需要配置的Secrets
- `ANDROID_KEYSTORE_BASE64`：签名密钥库（Base64编码）
- `ANDROID_KEYSTORE_PASSWORD`：密钥库密码
- `ANDROID_KEY_ALIAS`：密钥别名
- `ANDROID_KEY_PASSWORD`：密钥密码

### 测试版构建
- 无需配置任何Secrets
- 直接可用

## 📝 注意事项

1. **测试版**：跳过代码质量检查，适合快速测试
2. **正式版**：需要签名密钥，适合生产环境
3. **CI检查**：用于代码质量监控，不影响构建
4. **API配置**：所有版本都连接到 `https://tianque.126581.xyz`

## 🚀 快速开始

1. **首次测试**：使用 "Quick Build (Skip Lint)" 手动触发
2. **开发测试**：推送到 `develop` 分支自动构建
3. **正式发布**：创建版本标签自动发布

---

**推荐工作流**：Quick Build (Skip Lint) - 功能完整，使用简单，适合大多数场景！

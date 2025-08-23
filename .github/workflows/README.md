# GitHub Actions 工作流说明

本项目包含了完整的GitHub Actions工作流配置，支持自动构建、测试和发布Android和iOS应用。

## 工作流概览

### 1. Android构建工作流 (`android-build.yml`)
- **触发条件**: 推送到main/master分支、Pull Request、发布Release
- **功能**: 
  - 自动构建Debug和Release APK
  - 上传构建产物
  - 发布Release时自动创建GitHub Release

### 2. iOS构建检查工作流 (`ios-build.yml`)
- **触发条件**: 推送到main/master分支、Pull Request、手动触发
- **功能**:
  - 自动构建iOS应用（模拟器和通用设备）
  - 验证代码编译正确性
  - 上传构建日志
- **注意**: 此工作流不需要Apple开发者账号，仅用于代码质量检查

### 3. iOS发布工作流 (`ios-release.yml`)
- **触发条件**: 发布Release
- **功能**:
  - 自动构建iOS应用并导出IPA
  - 支持Apple证书和配置文件管理
  - 发布Release时自动上传IPA到GitHub Releases
- **注意**: 此工作流需要Apple开发者账号和相关配置

### 4. CI工作流 (`ci.yml`)
- **触发条件**: 推送到main/master分支、Pull Request
- **功能**:
  - Android代码质量检查(Lint)
  - Android单元测试
  - 安全漏洞扫描

### 5. 依赖更新工作流 (`dependency-update.yml`)
- **触发条件**: 每周定时运行、手动触发
- **功能**:
  - 检查Android依赖更新
  - 自动创建依赖更新PR
  - 安全审计

## 配置要求

### Android构建配置

#### 第一步：生成签名密钥

**方法一：使用提供的脚本（推荐）**

1. **Windows用户**：
   ```powershell
   .\setup-android-signing.ps1
   ```

2. **macOS/Linux用户**：
   ```bash
   chmod +x setup-android-signing.sh
   ./setup-android-signing.sh
   ```

**方法二：手动生成**

1. 确保已安装Java JDK
2. 运行以下命令：
   ```bash
   keytool -genkey -v -keystore uuvpn-release-key.keystore -alias uuvpn-key -keyalg RSA -keysize 2048 -validity 10000
   ```
3. 按提示填写信息（姓名、组织等）

#### 第二步：配置GitHub Secrets

1. 进入你的GitHub仓库
2. 点击 `Settings` → `Secrets and variables` → `Actions`
3. 点击 `New repository secret`
4. 添加以下Secrets：

| Secret名称 | 值 | 说明 |
|-----------|-----|------|
| `SIGNING_KEY_ALIAS` | `uuvpn-key` | 密钥别名 |
| `SIGNING_KEY_PASSWORD` | 你的密钥密码 | 密钥密码 |
| `SIGNING_STORE_PASSWORD` | 你的密钥库密码 | 密钥库密码 |
| `ANDROID_KEYSTORE_BASE64` | keystore的Base64编码 | 签名文件 |

**获取Base64编码**：
- **Windows**: `[Convert]::ToBase64String([IO.File]::ReadAllBytes("uuvpn-release-key.keystore"))`
- **macOS/Linux**: `base64 -i uuvpn-release-key.keystore`

#### 第三步：放置keystore文件

将生成的 `uuvpn-release-key.keystore` 文件复制到 `Android-kotlin-Code/` 目录下。

### iOS发布配置（可选）

如果你有Apple开发者账号，可以在GitHub仓库的Settings > Secrets and variables > Actions中添加以下密钥来启用iOS发布功能：

```
IOS_P12_BASE64            # iOS证书文件(Base64编码)
IOS_P12_PASSWORD          # iOS证书密码
IOS_BUNDLE_ID             # iOS应用Bundle ID
IOS_ISSUER_ID             # Apple开发者Issuer ID
IOS_API_KEY_ID            # Apple API密钥ID
IOS_API_PRIVATE_KEY       # Apple API私钥
```

### 可选配置

```
SNYK_TOKEN                # Snyk安全扫描令牌(可选)
```

## 使用方法

### 1. 自动构建
- 推送代码到main/master分支会自动触发构建
- 创建Pull Request会触发CI检查

### 2. 手动发布
1. 在GitHub上创建新的Release
2. 选择要发布的版本标签
3. 发布Release会自动触发构建并上传APK/IPA

### 3. 依赖更新
- 每周自动检查依赖更新
- 或手动在Actions页面触发"Dependency Update"工作流

## 构建产物

### Android
- Debug APK: 用于测试
- Release APK: 用于发布
- 位置: `Android-kotlin-Code/app/build/outputs/apk/alpha/`

### iOS
- **构建检查**: 仅验证代码编译正确性，不生成可安装文件
- **发布版本**: IPA文件，用于发布到App Store（需要Apple开发者账号）
- 位置: `iOS-SwiftUI-Code/build/`

## 无Apple开发者账号的解决方案

如果你没有Apple开发者账号，项目仍然可以：

1. **进行代码质量检查**: iOS构建检查工作流会验证代码编译正确性
2. **本地开发**: 可以在本地Xcode中开发和测试
3. **Android发布**: 完整支持Android APK的自动构建和发布

### 获取Apple开发者账号

如果需要发布iOS应用到App Store，你需要：

1. 注册Apple开发者账号（年费$99）
2. 创建App ID和证书
3. 配置GitHub Secrets
4. 启用iOS发布工作流

## 注意事项

1. **签名配置**: 确保Android签名配置正确
2. **证书管理**: iOS证书需要定期更新（仅在有Apple开发者账号时）
3. **构建时间**: iOS构建需要macOS环境，可能需要较长时间
4. **存储限制**: GitHub Actions有存储和运行时间限制

## 故障排除

### 常见问题

1. **Android构建失败**
   - 检查Gradle配置
   - 验证签名密钥配置
   - 查看构建日志

2. **iOS构建检查失败**
   - 检查Xcode项目配置
   - 验证依赖库
   - 查看构建日志

3. **iOS发布失败**
   - 检查证书和配置文件
   - 验证Bundle ID
   - 确认Xcode版本兼容性

4. **依赖更新失败**
   - 检查网络连接
   - 验证仓库权限
   - 查看依赖冲突

### 获取帮助

如果遇到问题，请：
1. 查看Actions页面的详细日志
2. 检查Secrets配置
3. 提交Issue描述问题

# Android签名密钥生成指南

## 方法一：使用命令行生成（推荐）

### 1. 生成keystore文件
```bash
keytool -genkey -v -keystore uuvpn-release-key.keystore -alias uuvpn-key -keyalg RSA -keysize 2048 -validity 10000
```

### 2. 按提示填写信息
- **密钥库口令**: 设置一个密码（记住这个密码）
- **名字与姓氏**: 你的姓名
- **组织单位名称**: 开发团队名称
- **组织名称**: 公司名称
- **城市或区域名称**: 城市
- **省/市/自治区名称**: 省份
- **国家/地区代码**: CN

### 3. 生成完成后，你会得到：
- `uuvpn-release-key.keystore` - 签名文件

## 方法二：使用Android Studio生成

1. 打开Android Studio
2. 点击菜单 `Build` → `Generate Signed Bundle / APK`
3. 选择 `APK`
4. 点击 `Create new` 创建新的keystore
5. 填写相关信息并保存

## 方法三：使用在线工具生成

如果不想使用命令行，可以使用在线keystore生成工具：
- https://keystore.online/
- https://www.keystore-explorer.org/

---

## 配置GitHub Secrets

生成keystore后，需要将相关信息配置到GitHub Secrets中：

### 1. 将keystore文件转换为Base64
```bash
# Windows PowerShell
[Convert]::ToBase64String([IO.File]::ReadAllBytes("uuvpn-release-key.keystore"))

# macOS/Linux
base64 -i uuvpn-release-key.keystore
```

### 2. 在GitHub仓库中配置Secrets
进入你的GitHub仓库 → Settings → Secrets and variables → Actions → New repository secret

添加以下Secrets：

| Secret名称 | 值 |
|-----------|-----|
| `SIGNING_KEY_ALIAS` | `uuvpn-key` |
| `SIGNING_KEY_PASSWORD` | 你设置的密钥密码 |
| `SIGNING_STORE_PASSWORD` | 你设置的密钥库密码 |
| `ANDROID_KEYSTORE_BASE64` | keystore文件的Base64编码 |

### 3. 将keystore文件添加到项目中
将生成的 `uuvpn-release-key.keystore` 文件放到 `Android-kotlin-Code/` 目录下。

---

## 验证配置

配置完成后，当你推送代码到main/master分支时，GitHub Actions会自动：
1. 使用配置的密钥签名APK
2. 生成可发布的Release版本
3. 上传到GitHub Releases

---

## 安全注意事项

1. **备份keystore文件**: 这个文件非常重要，丢失后无法更新应用
2. **保护密码**: 不要将密码提交到代码仓库
3. **定期更换**: 建议定期更换签名密钥
4. **团队共享**: 如果是团队项目，确保团队成员都能访问keystore文件

---

## 故障排除

### 常见问题：

1. **密码错误**: 确保SIGNING_KEY_PASSWORD和SIGNING_STORE_PASSWORD正确
2. **别名错误**: 确保SIGNING_KEY_ALIAS与生成时使用的别名一致
3. **文件路径错误**: 确保keystore文件在正确的位置

### 测试签名：
```bash
cd Android-kotlin-Code
./gradlew assembleAlphaRelease
```

如果构建成功，说明签名配置正确。

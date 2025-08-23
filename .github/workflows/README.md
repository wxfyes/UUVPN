# GitHub Actions 工作流说明

## 🎯 核心工作流（推荐使用）

### 1. **Quick Build (Skip Lint)** ⭐ 推荐
- **用途**: 快速测试构建，跳过Lint检查
- **触发**: 手动触发或推送到 `develop/test` 分支
- **输出**: 未签名APK，上传到Artifacts
- **适用**: 日常测试，快速验证功能

### 2. **Release Signed** 🔐 正式发布
- **用途**: 正式签名发布版本
- **触发**: 推送标签 `v*` 到 `main/master` 分支
- **输出**: 签名APK，创建GitHub Release
- **适用**: 正式版本发布，生产环境使用

### 3. **Android 14 Debug Fix** 🐛 调试修复
- **用途**: Android 14兼容性调试版本
- **触发**: 手动触发
- **输出**: Debug APK，包含Android 14修复
- **适用**: Android 14设备闪退问题调试

### 4. **Release Unsigned** 📱 测试发布
- **用途**: 未签名测试版本
- **触发**: 手动触发或推送标签
- **输出**: 未签名APK，上传到Artifacts
- **适用**: 测试发布，无需签名

## 🔧 辅助工作流

### 5. **CI** ✅ 代码质量
- **用途**: 代码质量检查，Lint和测试
- **触发**: 推送到任何分支
- **输出**: 检查报告
- **适用**: 代码质量保证

### 6. **Compatibility Test** 🔄 兼容性测试
- **用途**: 多版本Android兼容性测试
- **触发**: 手动触发
- **输出**: 多个targetSdk版本的APK
- **适用**: 兼容性验证

### 7. **Dependency Update** 📦 依赖更新
- **用途**: 自动更新依赖包
- **触发**: 定时触发
- **输出**: 依赖更新PR
- **适用**: 保持依赖最新

## 📱 iOS工作流

### 8. **iOS Build Check** 🍎 iOS构建检查
- **用途**: iOS构建验证
- **触发**: 推送到 `main/master` 分支
- **输出**: 构建状态报告
- **适用**: iOS兼容性检查

### 9. **iOS Release** 🍎 iOS发布
- **用途**: iOS正式发布
- **触发**: 推送标签 `v*`
- **输出**: iOS Release
- **适用**: iOS版本发布

## 🚀 使用建议

### 日常开发
1. 使用 **Quick Build** 进行快速测试
2. 使用 **CI** 检查代码质量

### 版本发布
1. 使用 **Release Signed** 发布正式版本
2. 使用 **Release Unsigned** 发布测试版本

### 问题调试
1. 使用 **Android 14 Debug Fix** 调试Android 14问题
2. 使用 **Compatibility Test** 验证兼容性

### 维护更新
1. 使用 **Dependency Update** 更新依赖
2. 定期运行 **CI** 检查代码质量

## 📋 工作流状态

| 工作流 | 状态 | 用途 |
|--------|------|------|
| Quick Build | ✅ 正常 | 快速测试 |
| Release Signed | ✅ 正常 | 正式发布 |
| Android 14 Debug Fix | ✅ 正常 | 调试修复 |
| Release Unsigned | ✅ 正常 | 测试发布 |
| CI | ✅ 正常 | 代码质量 |
| Compatibility Test | ✅ 正常 | 兼容性测试 |
| Dependency Update | ✅ 正常 | 依赖更新 |
| iOS Build Check | ✅ 正常 | iOS检查 |
| iOS Release | ✅ 正常 | iOS发布 |

---
*最后更新: 2025-08-23*

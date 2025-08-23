# UUVPN API服务器部署说明 (Nginx版本)

## 🖥️ 宝塔面板 + Nginx部署步骤

### 第一步：创建网站

1. **登录宝塔面板**
2. **添加站点**：
   - 域名：`api.yourdomain.com`（替换为你的域名）
   - 根目录：`/www/wwwroot/api.yourdomain.com`
   - PHP版本：选择PHP 7.4或8.0
   - 数据库：暂时不需要
   - **重要**：选择Nginx作为Web服务器

### 第二步：上传文件

将以下文件上传到网站根目录：

1. **`config.php`** - 简单的配置接口
2. **`api/index.php`** - 完整的API服务器

### 第三步：配置Nginx

#### 方法一：使用宝塔面板配置

1. **进入网站设置**
2. **点击"配置文件"**
3. **将以下配置复制到配置文件中**：

```nginx
server {
    listen 80;
    server_name api.yourdomain.com;
    
    root /www/wwwroot/api.yourdomain.com;
    index index.php index.html;
    
    # 跨域配置
    add_header Access-Control-Allow-Origin * always;
    add_header Access-Control-Allow-Methods "GET, POST, OPTIONS" always;
    add_header Access-Control-Allow-Headers "Content-Type, Authorization" always;
    
    # 处理OPTIONS预检请求
    if ($request_method = 'OPTIONS') {
        add_header Access-Control-Allow-Origin * always;
        add_header Access-Control-Allow-Methods "GET, POST, OPTIONS" always;
        add_header Access-Control-Allow-Headers "Content-Type, Authorization" always;
        add_header Access-Control-Max-Age 1728000;
        add_header Content-Type 'text/plain; charset=utf-8';
        add_header Content-Length 0;
        return 204;
    }
    
    # 配置接口路由
    location /config {
        try_files $uri $uri/ /config.php?$query_string;
    }
    
    # API接口路由
    location /api/ {
        try_files $uri $uri/ /api/index.php?$query_string;
    }
    
    # PHP处理
    location ~ [^/]\.php(/|$) {
        try_files $uri =404;
        fastcgi_pass unix:/tmp/php-cgi.sock;
        fastcgi_index index.php;
        include fastcgi.conf;
        include fastcgi_params;
    }
    
    # 安全配置
    location ~ /\. {
        deny all;
    }
}
```

4. **保存配置文件**
5. **重启Nginx服务**

#### 方法二：手动配置

1. **SSH连接到服务器**
2. **编辑Nginx配置文件**：
   ```bash
   nano /www/server/panel/vhost/nginx/api.yourdomain.com.conf
   ```
3. **粘贴上述配置**
4. **保存并退出**
5. **重启Nginx**：
   ```bash
   systemctl restart nginx
   ```

### 第四步：配置域名解析

在你的域名管理面板中添加A记录：
- 主机记录：`api`
- 记录值：你的服务器IP地址

### 第五步：修改PHP配置

编辑 `config.php` 或 `api/index.php` 文件，修改以下配置：

```php
$config = [
    "baseURL" => "https://api.yourdomain.com/api/v1/",  // 修改为你的域名
    "baseDYURL" => "https://api.yourdomain.com/api/vpnnodes.php",
    "mainregisterURL" => "https://yourdomain.com/#/register?code=",  // 修改为你的域名
    "paymentURL" => "https://yourdomain.com/payment",
    "telegramurl" => "https://t.me/yourchannel",  // 修改为你的Telegram群组
    "kefuurl" => "https://yourdomain.com/support",
    "websiteURL" => "https://yourdomain.com",  // 修改为你的网站
    "crisptoken" => "your-crisp-token-here",  // 修改为你的Crisp token
    "banners" => [
        "https://yourdomain.com/banner1.png",  // 修改为你的图片地址
        "https://yourdomain.com/banner2.png",
        "https://yourdomain.com/banner3.png"
    ],
    "message" => "OK",
    "code" => 1
];
```

### 第六步：SSL证书配置

在宝塔面板中：
1. **进入网站设置**
2. **点击"SSL"**
3. **申请Let's Encrypt免费证书**
4. **开启"强制HTTPS"**

### 第七步：测试API

在浏览器中访问以下地址测试：

1. **配置接口**：`https://api.yourdomain.com/config`
2. **完整API**：`https://api.yourdomain.com/api/config`

应该返回JSON格式的配置数据。

### 第八步：修改Android应用配置

在Android项目中修改 `ApiClient.kt` 文件：

```kotlin
object ApiClientConfig {
    private const val ConfigURL = "https://api.yourdomain.com/api/" // 修改这里
    const val ConfigNodeURL = ""
}
```

## 🔧 故障排除

### 常见问题：

1. **404错误**：
   - 检查文件路径是否正确
   - 确认Nginx配置中的root路径
   - 检查文件权限

2. **500错误**：
   - 检查PHP错误日志
   - 确认PHP版本兼容性
   - 检查fastcgi配置

3. **跨域问题**：
   - 确认Nginx配置中的CORS头设置
   - 检查OPTIONS请求处理

4. **SSL证书问题**：
   - 确认域名解析正确
   - 检查证书文件路径
   - 重启Nginx服务

### 查看日志：

```bash
# Nginx错误日志
tail -f /www/wwwlogs/api.yourdomain.com.error.log

# PHP错误日志
tail -f /www/server/php/版本号/var/log/php-fpm.log
```

## 📱 测试账号

在 `api/index.php` 中配置的测试账号：
- 邮箱：`test@example.com`
- 密码：`password123`

## 🚀 部署完成

部署完成后，你的API服务器将支持：

- ✅ 配置信息获取
- ✅ 用户登录/注册
- ✅ 用户信息查询
- ✅ 订阅信息获取
- ✅ 套餐列表获取

## 📞 技术支持

如果遇到问题：
1. 检查宝塔面板错误日志
2. 确认域名解析是否正确
3. 验证SSL证书是否有效
4. 测试API接口是否可访问
5. 检查Nginx配置文件语法

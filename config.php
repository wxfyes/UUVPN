<?php
header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

// 处理OPTIONS请求（CORS预检）
if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200);
    exit();
}

// 配置数据
    $config = [
        "baseURL" => "https://tianque.126581.xyz/api/v1/",
        "baseDYURL" => "https://tianque.126581.xyz/api/vpnnodes.php",
        "mainregisterURL" => "https://tianque.126581.xyz/#/register?code=",
        "paymentURL" => "https://tianque.126581.xyz/payment",
        "telegramurl" => "https://t.me/yourchannel",
        "kefuurl" => "https://tianque.126581.xyz/support",
        "websiteURL" => "https://tianque.126581.xyz",
        "crisptoken" => "your-crisp-token-here",
        "banners" => [
            "https://tianque.126581.xyz/banner1.png",
            "https://tianque.126581.xyz/banner2.png",
            "https://tianque.126581.xyz/banner3.png"
        ],
        "message" => "OK",
        "code" => 1
    ];

// 返回JSON响应
echo json_encode($config, JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT);
?>

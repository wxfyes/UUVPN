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
        "baseURL" => "https://123.108.70.221:8443/api/v1/",
        "baseDYURL" => "https://123.108.70.221:8443/api/vpnnodes.php",
        "mainregisterURL" => "https://tianque.126581.xyz/#/register?code=",
        "paymentURL" => "https://tianque.126581.xyz/payment",
        "telegramurl" => "https://t.me/fastlink",
        "kefuurl" => "https://tianque.126581.xyz/support",
        "websiteURL" => "https://tianque.126581.xyz",
        "crisptoken" => "5546c6ea-4b1e-41bc-80e4-4b6648cbca76",
        "banners" => [
            "https://image.gooapis.com/api/images/12-11-56.png",
            "https://image.gooapis.com/api/images/12-44-57.png",
            "https://image.gooapis.com/api/images/12-47-03.png"
        ],
        "message" => "OK",
        "code" => 1
    ];

// 返回JSON响应
echo json_encode($config, JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT);
?>

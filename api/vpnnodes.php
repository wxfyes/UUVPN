<?php
header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200);
    exit();
}

$nodes = [
    [
        "name" => "香港节点1",
        "type" => "ss",
        "server" => "hk1.example.com",
        "port" => 8388,
        "password" => "password123",
        "cipher" => "aes-256-gcm"
    ],
    [
        "name" => "新加坡节点1", 
        "type" => "vmess",
        "server" => "sg1.example.com",
        "port" => 443,
        "uuid" => "12345678-1234-1234-1234-123456789012",
        "alterId" => 0,
        "security" => "auto"
    ],
    [
        "name" => "日本节点1",
        "type" => "trojan",
        "server" => "jp1.example.com",
        "port" => 443,
        "password" => "trojan123"
    ]
];

echo json_encode($nodes, JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT);
?>

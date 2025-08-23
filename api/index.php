<?php
header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200);
    exit();
}

$request_uri = $_SERVER['REQUEST_URI'];
$path = parse_url($request_uri, PHP_URL_PATH);
$path = trim($path, '/');

// 移除 /api 前缀
if (strpos($path, 'api/') === 0) {
    $path = substr($path, 4);
}

// 调试信息
error_log("API Request Path: " . $path);

switch ($path) {
    case 'config':
        handleConfig();
        break;
    case 'passport/auth/login':
        handleLogin();
        break;
    case 'passport/auth/register':
        handleRegister();
        break;
    case 'user/info':
        handleUserInfo();
        break;
    case 'user/getSubscribe':
        handleGetSubscribe();
        break;
    case 'user/plan/fetch':
        handleGetPlans();
        break;
    case 'user/order/fetch':
        handleGetOrders();
        break;
    case 'user/order/save':
        handleSaveOrder();
        break;
    case 'user/order/detail':
        handleGetOrderDetail();
        break;
    case 'user/order/getPaymentMethod':
        handleGetPaymentMethod();
        break;
    case 'user/order/checkout':
        handleCheckout();
        break;
    case 'user/invite/fetch':
        handleGetInvite();
        break;
    case 'user/invite/save':
        handleSaveInvite();
        break;
    case 'user/ticket/fetch':
        handleGetTickets();
        break;
    case 'user/ticket/close':
        handleCloseTicket();
        break;
    case 'user/ticket/save':
        handleSaveTicket();
        break;
    case 'user/ticket/reply':
        handleReplyTicket();
        break;
    default:
        http_response_code(404);
        echo json_encode(['error' => 'API endpoint not found: ' . $path], JSON_UNESCAPED_UNICODE);
        break;
}

function handleConfig() {
    $config = [
        "baseURL" => "https://tianque.126581.xyz/api/v1/",
        "baseDYURL" => "https://tianque.126581.xyz/api/vpnnodes.php",
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
    echo json_encode($config, JSON_UNESCAPED_UNICODE);
}

function handleLogin() {
    $input = json_decode(file_get_contents('php://input'), true);
    $email = $input['email'] ?? '';
    $password = $input['password'] ?? '';
    
    // 简单的登录验证（实际应用中需要数据库验证）
    if ($email && $password) {
        $response = [
            "message" => "登录成功",
            "data" => [
                "token" => "sample_token_" . time(),
                "isAdmin" => 0,
                "auth_data" => "Bearer sample_auth_" . time()
            ]
        ];
    } else {
        $response = [
            "message" => "邮箱或密码错误",
            "data" => null
        ];
    }
    
    echo json_encode($response, JSON_UNESCAPED_UNICODE);
}

function handleRegister() {
    $input = json_decode(file_get_contents('php://input'), true);
    $email = $input['email'] ?? '';
    $password = $input['password'] ?? '';
    
    if ($email && $password) {
        $response = [
            "message" => "注册成功",
            "data" => [
                "token" => "sample_token_" . time(),
                "isAdmin" => 0,
                "auth_data" => "Bearer sample_auth_" . time()
            ]
        ];
    } else {
        $response = [
            "message" => "注册失败",
            "data" => null
        ];
    }
    
    echo json_encode($response, JSON_UNESCAPED_UNICODE);
}

function handleUserInfo() {
    $response = [
        "data" => [
            "email" => "user@example.com",
            "transferEnable" => 107374182400, // 100GB
            "lastLoginAt" => time(),
            "createdAt" => time() - 86400 * 30,
            "banned" => 0,
            "remindExpire" => 0,
            "remindTraffic" => 0,
            "expiredAt" => time() + 86400 * 365,
            "balance" => 10000, // 100元
            "commissionBalance" => 0,
            "uuid" => "12345678-1234-1234-1234-123456789012",
            "avatarURL" => "https://tianque.126581.xyz/avatar/default.png"
        ]
    ];
    echo json_encode($response, JSON_UNESCAPED_UNICODE);
}

function handleGetSubscribe() {
    $response = [
        "data" => [
            "plan_id" => 1,
            "token" => "subscribe_token_12345",
            "expired_at" => time() + 86400 * 365,
            "u" => 10737418240, // 10GB used
            "d" => 21474836480, // 20GB used
            "transfer_enable" => 107374182400, // 100GB total
            "email" => "user@example.com",
            "uuid" => "12345678-1234-1234-1234-123456789012",
            "plan" => [
                "id" => 1,
                "group_id" => 1,
                "transfer_enable" => 107374182400,
                "name" => "基础版",
                "speed_limit" => 104857600, // 100Mbps
                "show" => 1,
                "sort" => 1,
                "renew" => 1,
                "content" => "基础VPN套餐",
                "month_price" => 999,
                "quarter_price" => 2699,
                "half_year_price" => 4999,
                "year_price" => 8999,
                "two_year_price" => 15999,
                "three_year_price" => 21999,
                "onetime_price" => 999,
                "reset_price" => 0,
                "reset_traffic_method" => "month",
                "capacity_limit" => 1,
                "created_at" => time(),
                "updated_at" => time()
            ],
            "subscribe_url" => "https://tianque.126581.xyz/subscribe/12345678-1234-1234-1234-123456789012",
            "reset_day" => "1"
        ]
    ];
    echo json_encode($response, JSON_UNESCAPED_UNICODE);
}

function handleGetPlans() {
    $response = [
        "data" => [
            [
                "id" => 1,
                "group_id" => 1,
                "transfer_enable" => 107374182400, // 100GB
                "name" => "基础版",
                "speed_limit" => 104857600, // 100Mbps
                "show" => 1,
                "sort" => 1,
                "renew" => 1,
                "content" => "基础VPN套餐，适合个人使用",
                "month_price" => 999,
                "quarter_price" => 2699,
                "half_year_price" => 4999,
                "year_price" => 8999,
                "two_year_price" => 15999,
                "three_year_price" => 21999,
                "onetime_price" => 999,
                "reset_price" => 0,
                "reset_traffic_method" => "month",
                "capacity_limit" => 1,
                "created_at" => time(),
                "updated_at" => time()
            ],
            [
                "id" => 2,
                "group_id" => 1,
                "transfer_enable" => 536870912000, // 500GB
                "name" => "高级版",
                "speed_limit" => 209715200, // 200Mbps
                "show" => 1,
                "sort" => 2,
                "renew" => 1,
                "content" => "高级VPN套餐，适合家庭使用",
                "month_price" => 1999,
                "quarter_price" => 5399,
                "half_year_price" => 9999,
                "year_price" => 17999,
                "two_year_price" => 31999,
                "three_year_price" => 43999,
                "onetime_price" => 1999,
                "reset_price" => 0,
                "reset_traffic_method" => "month",
                "capacity_limit" => 3,
                "created_at" => time(),
                "updated_at" => time()
            ]
        ],
        "message" => "获取套餐列表成功",
        "status" => "success"
    ];
    echo json_encode($response, JSON_UNESCAPED_UNICODE);
}

function handleGetOrders() {
    $response = [
        "data" => [
            [
                "actual_commission_balance" => null,
                "balance_amount" => null,
                "callback_no" => null,
                "commission_balance" => 0,
                "commission_status" => 0,
                "coupon_code" => null,
                "coupon_id" => null,
                "created_at" => time() - 86400 * 7,
                "discount_amount" => null,
                "handling_amount" => 0,
                "invite_user_id" => null,
                "paid_at" => time() - 86400 * 7,
                "payment_id" => 1,
                "period" => "year_price",
                "plan" => [
                    "id" => 1,
                    "name" => "基础版"
                ],
                "plan_id" => 1,
                "refund_amount" => null,
                "site_id" => null,
                "status" => 1,
                "surplus_amount" => null,
                "surplus_order_ids" => null,
                "tixianstatus" => null,
                "total_amount" => 8999,
                "trade_no" => "ORDER" . time(),
                "type" => 1,
                "updated_at" => time() - 86400 * 7
            ]
        ],
        "message" => "获取订单列表成功",
        "status" => "success"
    ];
    echo json_encode($response, JSON_UNESCAPED_UNICODE);
}

function handleSaveOrder() {
    $input = json_decode(file_get_contents('php://input'), true);
    $period = $input['period'] ?? '';
    $plan_id = $input['plan_id'] ?? 0;
    $coupon_code = $input['coupon_code'] ?? '';
    
    $response = [
        "data" => "ORDER" . time(),
        "message" => "订单创建成功",
        "status" => "success"
    ];
    echo json_encode($response, JSON_UNESCAPED_UNICODE);
}

function handleGetOrderDetail() {
    $trade_no = $_GET['trade_no'] ?? '';
    
    $response = [
        "data" => [
            "actual_commission_balance" => null,
            "balance_amount" => null,
            "callback_no" => null,
            "commission_balance" => 0,
            "commission_status" => 0,
            "coupon_code" => null,
            "coupon_id" => null,
            "created_at" => time() - 86400 * 7,
            "discount_amount" => null,
            "handling_amount" => 0,
            "id" => 1,
            "invite_user_id" => null,
            "paid_at" => time() - 86400 * 7,
            "payment_id" => 1,
            "period" => "year_price",
            "plan" => [
                "id" => 1,
                "name" => "基础版"
            ],
            "plan_id" => 1,
            "refund_amount" => null,
            "site_id" => null,
            "status" => 1,
            "surplus_amount" => null,
            "surplus_order_ids" => null,
            "tixianstatus" => null,
            "total_amount" => 8999,
            "trade_no" => $trade_no ?: "ORDER" . time(),
            "try_out_plan_id" => null,
            "type" => 1,
            "updated_at" => time() - 86400 * 7,
            "user_id" => 1
        ],
        "message" => "获取订单详情成功",
        "status" => "success"
    ];
    echo json_encode($response, JSON_UNESCAPED_UNICODE);
}

function handleGetPaymentMethod() {
    $response = [
        "data" => [
            [
                "handling_fee_fixed" => null,
                "handling_fee_percent" => "0",
                "icon" => null,
                "id" => 1,
                "name" => "支付宝",
                "payment" => "alipay"
            ],
            [
                "handling_fee_fixed" => null,
                "handling_fee_percent" => "0",
                "icon" => null,
                "id" => 2,
                "name" => "微信支付",
                "payment" => "wechat"
            ]
        ],
        "message" => "获取支付方式成功",
        "status" => "success"
    ];
    echo json_encode($response, JSON_UNESCAPED_UNICODE);
}

function handleCheckout() {
    $input = json_decode(file_get_contents('php://input'), true);
    $trade_no = $input['trade_no'] ?? '';
    $method = $input['method'] ?? 1;
    
    $response = [
        "data" => "支付链接生成成功",
        "message" => "请完成支付",
        "status" => "success"
    ];
    echo json_encode($response, JSON_UNESCAPED_UNICODE);
}

function handleGetInvite() {
    $response = [
        "data" => [
            "codes" => [
                [
                    "code" => "INVITE123",
                    "created_at" => time() - 86400 * 30,
                    "pv" => 5,
                    "status" => 1,
                    "updated_at" => time() - 86400 * 30,
                    "user_id" => 1
                ]
            ],
            "stat" => [0, 0, 0, 0, 0, 0, 0]
        ],
        "error" => null,
        "message" => "获取邀请列表成功",
        "status" => "success"
    ];
    echo json_encode($response, JSON_UNESCAPED_UNICODE);
}

function handleSaveInvite() {
    $response = [
        "data" => "INVITE" . time(),
        "message" => "邀请码生成成功",
        "status" => "success"
    ];
    echo json_encode($response, JSON_UNESCAPED_UNICODE);
}

function handleGetTickets() {
    $ticket_id = $_GET['id'] ?? null;
    
    if ($ticket_id) {
        // 获取特定工单详情
        $response = [
            "data" => [
                "created_at" => time() - 86400 * 7,
                "id" => $ticket_id,
                "level" => 1,
                "message" => [
                    [
                        "created_at" => time() - 86400 * 7,
                        "id" => 1,
                        "is_me" => true,
                        "message" => "我的问题",
                        "ticket_id" => $ticket_id,
                        "updated_at" => time() - 86400 * 7
                    ],
                    [
                        "created_at" => time() - 86400 * 6,
                        "id" => 2,
                        "is_me" => false,
                        "message" => "客服回复",
                        "ticket_id" => $ticket_id,
                        "updated_at" => time() - 86400 * 6
                    ]
                ],
                "reply_status" => 1,
                "status" => 1,
                "subject" => "连接问题",
                "updated_at" => time() - 86400 * 6,
                "user_id" => 1
            ],
            "message" => "获取工单详情成功",
            "status" => "success"
        ];
    } else {
        // 获取工单列表
        $response = [
            "data" => [
                [
                    "created_at" => time() - 86400 * 7,
                    "id" => 1,
                    "level" => 1,
                    "message" => "连接问题",
                    "reply_status" => 1,
                    "status" => 1,
                    "subject" => "连接问题",
                    "updated_at" => time() - 86400 * 6,
                    "user_id" => 1
                ]
            ],
            "message" => "获取工单列表成功",
            "status" => "success"
        ];
    }
    
    echo json_encode($response, JSON_UNESCAPED_UNICODE);
}

function handleCloseTicket() {
    $input = json_decode(file_get_contents('php://input'), true);
    $ticket_id = $input['id'] ?? 0;
    
    $response = [
        "data" => "工单关闭成功",
        "message" => "工单已关闭",
        "status" => "success"
    ];
    echo json_encode($response, JSON_UNESCAPED_UNICODE);
}

function handleSaveTicket() {
    $input = json_decode(file_get_contents('php://input'), true);
    $subject = $input['subject'] ?? '';
    $level = $input['level'] ?? 1;
    $message = $input['message'] ?? '';
    
    $response = [
        "data" => "工单创建成功",
        "message" => "工单已提交",
        "status" => "success"
    ];
    echo json_encode($response, JSON_UNESCAPED_UNICODE);
}

function handleReplyTicket() {
    $input = json_decode(file_get_contents('php://input'), true);
    $ticket_id = $input['id'] ?? 0;
    $message = $input['message'] ?? '';
    
    $response = [
        "data" => "回复提交成功",
        "message" => "回复已提交",
        "status" => "success"
    ];
    echo json_encode($response, JSON_UNESCAPED_UNICODE);
}
?>

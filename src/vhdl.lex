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

    if(strcmp(yytext, "i") == 0)                return GEN_VAR;

    yylval = strdup(yytext); /* TODO: probably a terrible memory leak */
    return IDENT;
}

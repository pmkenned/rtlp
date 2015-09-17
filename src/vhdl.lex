ES  (\\(['"\?\\abfnrtv]|[0-7]{1,3}|x[a-fA-F0-9]+))

%{

#define DEBUG 1
#include "y.tab.h"

extern "C" int yylex(void);

%}

%option noyywrap
%option yylineno

%%

--.*                    ; /* ignore comments */

[ \t\n]                 ; /* ignore whitespace */

\"([^"\\\n]|{ES})*\"    return(STRING);

,                       return(',');
'                       return('\'');
\"                      return('"');
\.                      return('.');
;                       return(';');
:                       return(':');
\+                      return('+');
-                       return('-');
\*                      return('*');
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
attribute               return(ATTRIBUTE);
is                      return(IS);
of                      return(OF);
port                    return(PORT);
generic                 return(GENERIC);
map                     return(MAP);
begin                   return(_BEGIN_);
end                     return(END);
to                      return(TO);
signal                  return(SIGNAL);
in                      return(IN);
out                     return(OUT);
inout                   return(INOUT);
std_ulogic              return(STD_ULOGIC);
std_ulogic_vector       return(STD_ULOGIC_VECTOR);
power_logic             return(POWER_LOGIC);

 /* TODO: create check_type function for allowing for typedefs */
[A-Za-z_][A-Za-z0-9_]*  DEBUG && printf("ident: %s\n", yytext); return(IDENT);
[0-9]+                  return(NUMBER);

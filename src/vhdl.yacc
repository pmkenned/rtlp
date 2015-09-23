/* TODO:
 * functions
 * generate
 * packages
 * constants
 * x"000"
 */

%{
#  include  <stdio.h>
#  include  <ctype.h>

extern "C" {
    void yyerror(const char *s);
    int yylex(void);
}

extern FILE * yyin;

extern int yylineno;

extern const char * file_name;

%}

%left EXP ABS NOT
%left '*' '/' MOD REM
 /* TODO: unary */ /* %left '+' '-' */
%left '+' '-' '&'
%left SLL SRL SLA  SRA  ROL  ROR  
%left '=' NEQ '<' LTEQ  '>' GTEQ 
%left AND  OR NAND NOR  XOR  XNOR 

%start  root

%token  IDENT NUMBER STRING DIGIT
%token  OTHERS RANGE
%token  LTEQ EQGT
%token  COLEQ
%token  NOT AND NAND OR NOR XOR XNOR
%token  USE LIBRARY ENTITY ARCHITECTURE PACKAGE BODY GENERATE
%token  ATTRIBUTE IS OF PORT GENERIC MAP _BEGIN_ END TO DOWNTO SIGNAL IN OUT INOUT
%token  STD_LOGIC STD_ULOGIC STD_ULOGIC_VECTOR
%token  TYPE_NAME
%token  GEN_VAR
%token  SUBTYPE CONSTANT VARIABLE
%token  FUNC_NAME CONSTANT_NAME
%token  ASSERT REPORT SEVERITY ERROR WARNING
%token  TRUE FALSE
%token  WHEN ELSE FOR

%%      /*  beginning  of  rules  section  */

root    :     /* empty */
        | root use_stm
        | root lib_stm
        | root arch_def
        | root package_decl
        | root package_def
        | root entity_def
        ;

use_stm : USE ident_period_list ';'
        ;

lib_stm : LIBRARY ident_list ';'
        ;

package_decl    : PACKAGE IDENT IS package_decl_body END IDENT ';'
                ;

/* TODO */
/* subtype  ppc_primary         is natural range   0 to 63  ;
 * constant dmap_ip_slice_route           : integer := 00             ; -- pmk 4/8/15
 * function dcd_ppc       (ppc : in std_ulogic_vector(0 to 31) ;
 */

package_decl_body   :
                    ;

package_def : PACKAGE BODY IDENT IS package_body END IDENT ';'
            ;

/* TODO */
package_body    : 
                ;

arch_def    : ARCHITECTURE IDENT OF IDENT IS signal_attr_list _BEGIN_ arch_body END arch_opt IDENT ';'
            ;

arch_opt    : /* empty */
            | ARCHITECTURE
            ;

arch_body   : /* empty */
            | arch_body assign
            | arch_body instantiation
            | arch_body generate_block
            | arch_body assertion
            | arch_body func_invocation ';'
            ;

generate_body   : /* empty */
                | generate_body assign
                | generate_body instantiation
                | generate_body assertion
                | generate_body func_invocation ';'
                ;

assertion   : ASSERT expr REPORT expr SEVERITY severity ';'
            ;

severity    : ERROR
            | WARNING
            ;

assign  : signal_opt_vector LTEQ when_expr ';'
        ;

when_list   :
            | when_list expr WHEN expr ELSE
            ;

when_expr   : when_list expr
            ;

instantiation   : IDENT ':' ENTITY IDENT '.' IDENT arch_spec_opt generic_map_opt PORT MAP '(' port_map_list ')' ';'
                ;

generate_block  : IDENT ':' FOR GEN_VAR IN bit_index TO bit_index GENERATE _BEGIN_ generate_body END GENERATE ident_opt ';'
                ;

ident_opt   :
            | IDENT
            ;

arch_spec_opt   : /* empty */
                | '(' IDENT ')'
                ;

generic_map_opt : /* empty */
                | GENERIC MAP '(' port_map_list ')'
                ;

port_map_list   : /* empty */
                | port_map
                | port_map_list ',' port_map
                ;

/* TODO: func_invocation might be wrong. Should probably only allow FUNC_NAME '(' signal_opt_vector ')' */
port_map    : signal_opt_vector EQGT expr
            | func_invocation EQGT expr
            | expr
            ;

signal_opt_vector   : IDENT bit_slice_opt
                    ;

signal_attr_list    : /* empty */
                    | signal_attr_list signal_decl
                    | signal_attr_list attribute
                    ;

 /* add identifiers to list of signal names */
signal_decl : SIGNAL ident_list ':' type_specifier bit_range_opt ';'
            ;

entity_def  : ENTITY IDENT IS generic_spec PORT '(' port_list ')' ';' attribute_list END entity_opt IDENT ';'
            ;

generic_spec    : /* empty */
                | GENERIC '(' generic_list ')'
                ;

generic_list    : /* empty */
                | generic
                | generic_list ';' generic
                ;

generic : IDENT ':' type_specifier COLEQ literal
        ;

entity_opt  : /* empty */
            | ENTITY
            ;

attribute_list  : /* empty */
                | attribute_list attribute
                ;

attribute   : ATTRIBUTE IDENT OF IDENT ':' entity_or_signal IS expr ';'
            | ATTRIBUTE IDENT ':' type_specifier ';'
            ;

entity_or_signal    : ENTITY
                    | SIGNAL
                    ; 

literal :   STRING
        |   NUMBER
        |   DIGIT
        |   TRUE
        |   FALSE
        ;

port_list   : /* empty */
            | port
            | port_list ';' port
            ;

port    : IDENT ':' direction type_specifier bit_range_opt
        ;

direction   : IN
            | OUT
            | INOUT
            ;

bit_range_opt   : /* empty */
                | '(' bit_range ')'
                ;

bit_slice_opt   : /* empty */
                | '(' bit_slice ')'
                ;

bit_slice   : bit_index
            | bit_range
            ;

bit_range   : bit_index TO bit_index
            | bit_index DOWNTO bit_index
            ;

/* TODO: algebraic expressions */
bit_index   : NUMBER
            | CONSTANT_NAME
            | GEN_VAR
            ;

ident_list  : IDENT
            | ident_list ',' IDENT
            ;

ident_period_list   : IDENT
                    | ident_period_list '.' IDENT
                    ;

  /* TODO */
  /* FUNCTION IDENT '(' IDENT ':' IDENT ')'
    RETURN  IDENT  IS
    variable result     : bit; 
  _BEGIN_
  function_body
  END IDENT   ';' */

/* TODO: verify that the prec used with NOT is correct */
expr    : literal
        | signal_opt_vector
        | expr OR expr
        | expr AND expr
        | expr NOR expr
        | expr NAND expr
        | expr XOR expr
        | expr XNOR expr
        | expr '+' expr
        | expr '-' expr
        | expr '=' expr
        | expr NEQ expr
        | expr '&' expr
        | expr '>' expr
        | expr '<' expr
        | expr GTEQ expr
        | expr LTEQ expr
        | func_invocation
        | type_specifier '(' expr ')'
        | '(' choices ')'
        | NOT expr %prec AND
        | '(' expr ')'
        ;

choices : choice
        | choices ',' choice
        ;

choice      : selection EQGT expr
            ;

selection   : bit_slice
            | OTHERS
            ;



func_invocation : FUNC_NAME '(' arg_list_opt ')'
                ;

arg_list_opt    : /* empty */
                | arg_list
                ;

arg_list    : arg
            | arg_list ',' arg
            ;

arg : expr
    | IDENT EQGT expr
    ;

/* TODO: allow for typedefs */
type_specifier  : STD_LOGIC
                | STD_ULOGIC
                | STD_ULOGIC_VECTOR
                | TYPE_NAME
                ;

%%      /*  start  of  programs  */

void yyerror(const char *s)
{
    fprintf(stderr, "%s:\t", file_name);
    fprintf(stderr, "%d: %s\n", yylineno, s);
}

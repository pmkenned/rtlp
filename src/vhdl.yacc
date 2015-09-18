%{
#  include  <stdio.h>
#  include  <ctype.h>

extern "C" {
    void yyerror(const char *s);
    int yylex(void);
}

extern FILE * yyin;

extern int yylineno;

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
%token  LTEQ EQGT
%token  NOT AND NAND OR NOR XOR XNOR
%token  USE LIBRARY ENTITY ARCHITECTURE
%token  ATTRIBUTE IS OF PORT GENERIC MAP _BEGIN_ END TO SIGNAL IN OUT INOUT
%token  STD_ULOGIC STD_ULOGIC_VECTOR POWER_LOGIC

%%      /*  beginning  of  rules  section  */

root    :     /* empty */
        | root use_stm
        | root lib_stm
        | root arch_def
        | root entity_def
        ;

use_stm : USE ident_period_list ';'
        ;

lib_stm : LIBRARY ident_list ';'
        ;

arch_def    : ARCHITECTURE IDENT OF IDENT IS signal_attr_list _BEGIN_ arch_body END IDENT ';'
            ;

arch_body   : /* empty */
            | arch_body assign
            | arch_body instantiation
            ;

assign  : signal_opt_vector LTEQ expr ';'
        ;

instantiation   : IDENT ':' ENTITY IDENT '.' IDENT generic_map_opt PORT MAP '(' port_map_list_opt ')' ';'
                ;

generic_map_opt : /* empty */
                | GENERIC MAP '(' generic_map_list ')'
                ;

generic_map_list    : port_map_list_opt
                    ;

port_map_list_opt   : /* empty */
                    | port_map_list
                    ;

port_map_list   : port_map
                | port_map_list ',' port_map
                ;

/* TODO: needs to handle Tconv */
port_map    : signal_opt_vector EQGT expr
            ;

signal_opt_vector   : IDENT bit_slice_opt
                    ;

signal_attr_list    : /* empty */
                    | signal_attr_list signal_decl
                    | signal_attr_list attribute
                    ;

signal_decl : SIGNAL ident_list ':' type_specifier bit_range_opt ';'
            ;

entity_def  : ENTITY IDENT IS PORT '(' port_list_opt ')' ';' attribute_list END IDENT ';'
            ;

attribute_list  : /* empty */
                | attribute_list attribute
                ;

attribute   : ATTRIBUTE IDENT OF IDENT ':' entity_or_signal IS expr ';'
            ;

entity_or_signal    : ENTITY
                    | SIGNAL
                    ; 

literal :   STRING
        |   NUMBER
        |   DIGIT
        ;

port_list_opt   : /* empty */
                | port_list
                ;

port_list   : port
            | port_list ';' port
            ;

port    : IDENT ':' direction type_specifier bit_range_opt
        ;

direction   : IN
            | OUT
            | INOUT
            ;

bit_range_opt   : /* empty */
                | bit_range
                ;

bit_slice_opt   : /* empty */
                | bit_slice
                ;

bit_slice   : bit_index
            | bit_range
            ;

bit_index   : '(' NUMBER ')'
            ;

bit_range   : '(' NUMBER TO NUMBER ')'
            ;

ident_list  : IDENT
            | ident_list ',' IDENT
            ;

ident_period_list   : IDENT
                    | ident_period_list '.' IDENT
                    ;

/* TODO: function invocation */
/* TODO: verify that the prec used with unary_op is correct */
expr    : literal
        | signal_opt_vector
        | expr binop expr
        | unary_op expr %prec AND
        | '(' expr')'
        ;

unary_op    : NOT
            ;

binop : OR
      | AND
      | NOR
      | NAND
      | XOR
      | XNOR
      | '+'
      | '-'
      | '='
      | NEQ
      | '&'
      | '>'
      | '<'
      | GTEQ
      | LTEQ
      ;

/* TODO: allow for typedefs */
type_specifier  : STD_ULOGIC
                | STD_ULOGIC_VECTOR
                | POWER_LOGIC
                ;

%%      /*  start  of  programs  */

void yyerror(const char *s)
{
    fprintf(stderr, "%d: %s\n", yylineno, s);
}

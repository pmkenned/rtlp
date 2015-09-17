.PHONY: clean

all:
	yacc -d vhdl.yacc
	lex vhdl.lex
	g++ -o rtlp main.cpp y.tab.c lex.yy.c

clean:
	rm y.tab.c y.tab.h lex.yy.c rtlp.exe

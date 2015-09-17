#include <iostream>
#include <cstdio>
#include <cstdlib>

#include "y.tab.h"

int yyparse(); // needed for earlier versions of bison

extern FILE * yyin;

int main(int argc, char * argv[]) {

    if(argc < 2) {
        fprintf(stderr, "usage: %s [FILE]\n", argv[0]);
        std::exit(1);
    }

    yyin = std::fopen(argv[1], "r");

    yyparse();

    std::fclose(yyin);

    return 0;
}

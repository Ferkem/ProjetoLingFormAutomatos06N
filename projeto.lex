%{

#include <stdio.h>
#define YY_DECL int yylex()
#include "projeto.tab.h"

%}

white [ \t]+
digit [0-9]
integer {digit}+
exponent [eE][+-]?{integer}
real {integer}("."{integer})?{exponent}?

%%

[ \t]          ;
{white} { }
{real} { yylval.pfloat=atof(yytext); 
 return NUMBER;
}
"+" 			return PLUS;
"-" 			return MINUS;
"*" 			return TIMES;
"/" 			return DIVIDE;
"^" 			return POWER;
"(" 			return LEFT;
")" 			return RIGHT;
"ls" 		return LS;
"ps" 		return PS;
"quit" 		return QUIT;
"calculo" 	return CALCULO;
"kill" 		return KILL;
"mkdir" 	return MKDIR;
"rmdir" 	return RMDIR;
"cd" 		return CD;
"touch" 	return TOUCH;
"ifconfig"  return IFCONFIG;
"start"         return START;

[a-zA-Z0-9]+   {
	yylval.sval = strdup(yytext);
	return STRING;
}
\n             return END;
.              ;
%%
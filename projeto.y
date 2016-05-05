%{
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
void yyerror();
#define YYSTYPE double
%}

%token NUMBER
%token PLUS MINUS TIMES DIVIDE POWER
%token LEFT RIGHT
%token END
%token LS PS QUIT CALCULO KILL ERROR

%left PLUS MINUS
%left TIMES DIVIDE
%left NEG
%right POWER

%start Input
%%

Input: 					{printf("%s >> ", getenv("HOME"));}
     | Input Line 			{printf("%s >> ", getenv("HOME"));}
;

Line:
     END
     | CALCULO Expression END 		{ printf("Result: %g\n", $2); }
     | LS END 							{ system("ls"); }
     | PS END 							{ system("ps"); }
     | QUIT END 							{ printf("Saindo do shell \n"); exit(0); }
     | KILL NUMBER END 				{char commandS[1024]; int n; n=(int)$2; snprintf(commandS, 1024, "kill %d", n); system(commandS); }
     | ERROR END 						{ printf("Comando invalido\n"); }
;


Expression:
    	  NUMBER 								{ $$=$1; }
	| Expression PLUS Expression 		{ $$=$1+$3; }
	| Expression MINUS Expression 		{ $$=$1-$3; }
	| Expression TIMES Expression 		{ $$=$1*$3; }
	| Expression DIVIDE Expression 	{ if ($3) $$=$1/$3; else{ yyerror("erro de compilacao") ; return(0);} }
	| MINUS Expression %prec NEG 		{ $$=-$2; }
	| Expression POWER Expression 	{ $$=pow($1,$3); }
	| LEFT Expression RIGHT 				{ $$=$2; }
;

%%

void yyerror(char *s) {
	printf("%s\n", s);
	yyparse();
}

int main() {
  	if (yyparse())
     		fprintf(stderr, "Successful parsing.\n");
 	else
     		fprintf(stderr, "error found.\n");
 
}

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <math.h>

extern int yylex();
extern int yyparse();
extern FILE* yyin;
void yyerror(const char* s);

%}

%union {
	int integer;
	float pfloat;
	char *sval;
}

%token <pfloat> NUMBER
%token <sval> STRING
%token PS KILL LS QUIT CALCULO MKDIR
%token PLUS MINUS TIMES DIVIDE POWER
%token LEFT RIGHT 
%token END

%left PLUS MINUS
%left TIMES DIVIDE
%left NEG
%right POWER

%type <pfloat> Expression

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
     | MKDIR STRING END 				{char cmd[1024]; strcpy(cmd,"/bin/mkdir ");strcat(cmd, $2); system(cmd); }
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

int main() {
	yyin = stdin;
	do { 
		yyparse();
	} while(!feof(yyin));
	return 0;
}
void yyerror(const char* s) {
	fprintf(stderr, "Comando/Argumento nao valido. Erro: %s\n", s);
}
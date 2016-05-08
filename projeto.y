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
%token PS KILL LS QUIT CALCULO MKDIR RMDIR CD TOUCH IFCONFIG START ERROR
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

Input: 					{	char shellName[1024] = "MyPersonalShell:";
							char dir[1024];
							getcwd(dir, sizeof(dir));
							strcat(shellName,dir);
							strcat(shellName,">> ");
							printf("%s",shellName); 
						}
     | Input Line 			
						{	char shellName[1024] = "MyPersonalShell:";
							char dir[1024];
							getcwd(dir, sizeof(dir));
							strcat(shellName,dir);
							strcat(shellName,">> ");
							printf("%s",shellName); 
						}
;

Line:
     END
     | CALCULO Expression END 		{ printf("Result: %g\n", $2); }
     | LS END 							{ system("ls"); }
     | PS END 							{ system("ps"); }
     | QUIT END 							{ printf("Saindo do shell \n"); exit(0); }
     | KILL NUMBER END 				{char commandS[1024]; int n; n=(int)$2; snprintf(commandS, 1024, "kill %d", n); system(commandS); }
     | MKDIR STRING END 				{char cmd[1024]; strcpy(cmd,"/bin/mkdir ");strcat(cmd, $2); system(cmd); }
     | RMDIR STRING END 				{char cmd[1024]; strcpy(cmd,"/bin/rmdir ");strcat(cmd, $2); system(cmd); }
     | CD STRING END 					{	
											int response = 0;
						   					char dir_path[1024];
						   					getcwd(dir_path, sizeof(dir_path));
						   					strcat(dir_path, "/");
						   					strcat(dir_path, $2);
											response = chdir(dir_path);
											if(response != 0){
												printf("Erro! Diretorio nao encontrado!\n");
											}
										}
     | TOUCH STRING END 			        {char cmd[1024]; strcpy(cmd,"/bin/touch ");strcat(cmd, $2); system(cmd); }
     | IFCONFIG END 				        {system("ifconfig"); }
     | START STRING END 				{char start[1024]; strcpy(start, $2); strcat(start, "&"); system(start);}
     |STRING END 						{yyerror("Comando Desconhecido") ; return(0);}
     |ERROR END 						{yyerror("Comando Desconhecido") ; return(0);}
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
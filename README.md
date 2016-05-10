# ProjetoLingFormAutomatos06N
Repositório para projeto da disciplina de Linguagens Formais e Autômatos

--Intrucoes de Uso:
1)compilar bison: 
bison -d projeto.y

2)compilar flex: 
flex  -o projeto.lex.c projeto.lex

3)compilar o programa: 
gcc -o projeto projeto.lex.c projeto.tab.c -lfl -lm

4)executar o programa: ./projeto

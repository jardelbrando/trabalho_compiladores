%{
    int linhas = 1, erros = 0;
%}

DIGITO  [0-9]
ID     [A-Za-z][A-Za-z0-9]*
ESP         [\t\r" "]
LER     "ler"
OPERADOR_LOGICO "and"|"our"|"not"|">"|">="|"<"|"<="|"!="
OPERADOR_ARITIMETICO "+"|"-"|"*"|"/"|"^"
OPERADOR_REPETICAO "for"|"while"
ESPECIAL "@"|"$"|"&"

%%

{ESP} /* Espaços em braco (espaço ou tab) */

"inicio" {
    /* Controle de fluxo */
    printf("%s  :   inicio do programa\n", yytext);
}

"fim" {
    printf("%s  :   fim do programa\n", yytext);
}

"inteiro"|"real"|"cadeia"|"caractere" {
    printf("%s  :   tipo de variavel\n", yytext);
}

"+"|"-"|"*"|"/" {
    printf("%s  :   operador aritmetico\n", yytext);
}

{ESPECIAL} {
    printf("%s  :   caractere especial\n", yytext);
}

{DIGITO}{ESPECIAL}+{DIGITO} {
    printf("%s  :   digito inválido", yytext);
    erros++;
    printf("    |   Erro na linha %d\n", linhas);
}

{ID}{ESPECIAL}+{ID} {
    printf("%s  :   Identificador inválido", yytext);
    erros++;
    printf("    |   Erro na linha %d\n", linhas);
}

{OPERADOR_LOGICO} {
    printf("%s  :   operador logico\n", yytext);
}

{OPERADOR_LOGICO}{OPERADOR_LOGICO}+ {
    printf("%s  :   operador inválido", yytext);
    erros++;
    printf("    |   Erro na linha %d\n", linhas);
}

{OPERADOR_REPETICAO} {
    printf("%s  :   operador de repetição\n", yytext);
}

"{"|"}" {
    printf("%s  :   chaves\n", yytext);
}

"=" {
    printf("%s  :   atribuicao\n", yytext);
}

["]([^"\\\n]|\\(.|\n))*["] {
    printf("%s  :   texto entre aspas\n", yytext);
}

{LER} {
    printf("%s  :   funcao de leitura\n", yytext);
}

"imprima" {
    printf("%s  :   imprimir o valor lido\n", yytext);
}

"if"|"else"|"elseif" {
    printf("%s  :   comando de comparação\n", yytext);
}

{ID}{DIGITO}*{ID}* {
    printf("%s  :   Identificador\n", yytext);
}

"," {
    printf("%s  :   vírgula\n", yytext);
}

";" {
    printf("%s  :   ponto e vírgula\n", yytext);
}

"("|")" {
    printf("%s  :   parenteses\n", yytext);
}

{DIGITO}+ {
    printf("%s  :   numero inteiro\n", yytext);
}

{DIGITO}+{ID} {
    printf("%s  :   Identificador inválido", yytext);
    erros++;
    printf("    |   Erro na linha %d\n", linhas);
}


[/][*][^*]*[*]+([^*/][^*]*[*]+)*[/] {
    printf("comentario em bloco  :   %s\n", yytext);
}

"//"[^\n]* {
    /* Comentario de uma linha */
    printf("Comentario: %s\n", yytext);
}

"\n" {
    printf("quebra de linha\n");
    linhas++;
}

{DIGITO}+{DIGITO}*"++" {
    printf("%s  :   acréscimo de um número inteiro\n", yytext);
}

{DIGITO}+{DIGITO}*"--" {
    printf("%s  :   decréscimo de um número inteiro\n", yytext);
}

{ID}*"++" {
    printf("%s  :   acréscimo de um número inteiro em variavel\n", yytext);
}

{ID}*"--" {
    printf("%s  :   decréscimo de um número inteiro em variavel\n", yytext);
}

{OPERADOR_ARITIMETICO}{OPERADOR_ARITIMETICO}+ {
    printf("%s  :   operador aritimetico inválido", yytext);
    erros++;
    printf("    |   Erro na linha %d\n", linhas);
}



%%

int yywrap();

int main() {
    yylex();
    printf("\nTotal de erros encontrados: %d\n", erros);
    if (erros == 0) {
        printf("\nO codigo analisado esta lexicamente correto!\n");
    }
    return 0;
}
    
int yywrap() {
    return 1;
}
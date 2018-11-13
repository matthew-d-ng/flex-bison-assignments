%{
# include <stdio.h>
# include <stdlib.h>
# include <string.h>
int yylex();
void yyerror(char* s);
int sym_table['z'-'a'];
int val_set['z'-'a'];

void add_sym(char c, int val);
int get_sym(char c);
int has_val(char c);

%}

/* declare tokens */
%token ASSIGN ADD SUB MUL DIV
%token PRINT VAR NUMBER
%token EOL
%%
calclist: /* nothing */
 | calclist statement EOL
 ;

statement: VAR ASSIGN expr  { add_sym($1, $3); }
 | PRINT expr               { printf("%d\n", $2); }
 ;

expr: expr ADD factor      { $$ = $1 + $3; }
 | expr SUB factor         { $$ = $1 - $3; }
 | factor  
 ;
 
factor: factor MUL num      { $$ = $1 * $3; }
 | factor DIV num           { $$ = $1 / $3; }
 | num
 ;

num: SUB num                { $$ = -$2; }
 | VAR                      { 
                                if (has_val($1))
                                  $$ = get_sym($1);
                                else
                                  yyerror("syntax error");
                            }
 | NUMBER
 ;

%%

void add_sym(char c, int val)
{
  int i = c - 'a';
  sym_table[i] = val;
  val_set[i] = 1;
}

int get_sym(char c)
{
  int i = c - 'a';
  return sym_table[i];

}

int has_val(char c)
{
  int i = c - 'a'; 
  return val_set[i];
}

int main()
{ 
  yyparse();
  return 0;
}

void yyerror(char* s)
{
  printf("%s\n", s);
  exit(0);
}




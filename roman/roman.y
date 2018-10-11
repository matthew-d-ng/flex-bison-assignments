%{
# include <stdio.h>
# include <stdlib.h>
int yylex();
void yyerror();
%}

/* declare tokens */
%token ONE FIVE TEN FIFTY HUNDRED FIVE_HUNDRED THOUSAND
%token EOL
%%
calclist: /* nothing */
 | calclist num EOL { printf("%d\n", $2); }
 ; 

num: thousands hundreds tens ones { $$ = $1 + $2 + $3 + $4; }
 | thousands hundreds tens        { $$ = $1 + $2 + $3; }
 | thousands hundreds ones        { $$ = $1 + $2 + $3; }
 | thousands hundreds             { $$ = $1 + $2; }
 | thousands tens ones            { $$ = $1 + $2 + $3; }
 | thousands tens                 { $$ = $1 + $2; }
 | thousands ones                 { $$ = $1 + $2; }
 | thousands
 | hundreds tens ones             { $$ = $1 + $2 + $3; }
 | hundreds tens                  { $$ = $1 + $2; }
 | hundreds ones                  { $$ = $1 + $2; }
 | hundreds
 | tens ones                      { $$ = $1 + $2; }
 | tens
 | ones
 ;

ones: ONE                       { $$ = 1; }
 | ONE ONE                      { $$ = 2; }
 | ONE ONE ONE                  { $$ = 3; }
 | ONE FIVE                     { $$ = 4; }
 | FIVE                         { $$ = 5; }
 | FIVE ONE                     { $$ = 6; }
 | FIVE ONE ONE                 { $$ = 7; }
 | FIVE ONE ONE ONE             { $$ = 8; }
 | ONE TEN                      { $$ = 9; }
 ;

tens: TEN HUNDRED               { $$ = 90; }
 | FIFTY TEN TEN TEN            { $$ = 80; }
 | FIFTY TEN TEN                { $$ = 70; }
 | FIFTY TEN                    { $$ = 60; }
 | FIFTY                        { $$ = 50; }
 | TEN FIFTY                    { $$ = 40; }
 | TEN TEN TEN                  { $$ = 30; }
 | TEN TEN                      { $$ = 20; }                     
 | TEN                          { $$ = 10; }
 ;

hundreds:  HUNDRED THOUSAND             { $$ = 900; }
 | FIVE_HUNDRED HUNDRED HUNDRED HUNDRED { $$ = 800; }
 | FIVE_HUNDRED HUNDRED HUNDRED         { $$ = 700; } 
 | FIVE_HUNDRED HUNDRED                 { $$ = 600; }
 | FIVE_HUNDRED                         { $$ = 500; }
 | HUNDRED FIVE_HUNDRED                 { $$ = 400; } 
 | HUNDRED HUNDRED HUNDRED              { $$ = 300; }
 | HUNDRED HUNDRED                      { $$ = 200; }
 | HUNDRED                              { $$ = 100; }
 ;

thousands: THOUSAND THOUSAND THOUSAND   { $$ = 3000; }
 | THOUSAND THOUSAND                    { $$ = 2000; }
 | THOUSAND                             { $$ = 1000; }
 ;

%%
int main()
{ 
  yyparse();
  return 0;
}

void yyerror()
{
  printf("syntax error\n");
  exit(0);
}




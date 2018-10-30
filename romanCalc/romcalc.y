%{
# include <stdio.h>
# include <stdlib.h>
# include <string.h>
int yylex();
void yyerror();
char* to_roman(int num);

char* SYM_HUNDREDS[9] = 
      { "C", "CC", "CCC", "CD", "D", "DC", "DCC", "DCCC", "CM"};
char* SYM_TENS[9] =
      { "X", "XX", "XXX", "XL", "L", "LX", "LXX", "LXXX", "XC"};
char* SYM_ONES[9] =
      { "I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX"};
%}

/* declare tokens */
%token ONE FIVE TEN FIFTY HUNDRED FIVE_HUNDRED THOUSAND
%token ADD SUB MUL DIV OPEN_BR CLOSE_BR
%token EOL
%%
calclist: /* nothing */
 | calclist expr EOL { printf("%s\n", to_roman($2)); }
 ;
 
expr: factor
 | expr ADD factor                { $$ = $1 + $3; }
 | expr SUB factor                { $$ = $1 - $3; }
 ;
 
factor: inner_expr
 | factor MUL inner_expr          { $$ = $1 * $3; }
 | factor SUB inner_expr          { $$ = $1 / $3; }
 ;
 
inner_expr: num
 | OPEN_BR expr CLOSE_BR          { $$ = $2; }
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

char* add_roman_unit(char* romanNum, const char** symbols, int num)
{
  size_t charsize = sizeof(romanNum[0]);
  
  if (num != 0) {
    char* newRoman;
    char* old = *romanNum;
    switch (num) {
    
    case 1:
      newRoman = calloc( sizeof(old) + 1, charsize );
      newRoman = strncpy(newRoman, old, strlen(old));
      newRoman = strncat(newRoman, symbols[0], 1);
      break;
      
    case 2:
      newRoman = calloc( sizeof(old) + 2, charsize );
      newRoman = strncpy(newRoman, old, strlen(old));
      newRoman = strncat(newRoman, symbols[1], 2);
      break;    
      
    case 3:
      newRoman = calloc( sizeof(old) + 3, charsize );
      newRoman = strncpy(newRoman, old, strlen(old));
      newRoman = strncat(newRoman, symbols[2], 3);
      break;    
      
    case 4:
      newRoman = calloc( sizeof(old) + 2, charsize );
      newRoman = strncpy(newRoman, old, strlen(old));
      newRoman = strncat(newRoman, symbols[3], 2);
      break;
      
    case 5:
      newRoman = calloc( sizeof(old) + 1, charsize );
      newRoman = strncpy(newRoman, old, strlen(old));
      newRoman = strncat(newRoman, symbols[4], 1);  
      break;
      
    case 6:
      newRoman = calloc( sizeof(old) + 2, charsize );
      newRoman = strncpy(newRoman, old, strlen(old));
      newRoman = strncat(newRoman, symbols[5], 2);  
      break;
      
    case 7:
      newRoman = calloc( sizeof(old) + 3, charsize );
      newRoman = strncpy(newRoman, old, strlen(old));
      newRoman = strncat(newRoman, symbols[6], 3);  
      break;
      
    case 8:
      newRoman = calloc( sizeof(old) + 4, charsize );
      newRoman = strncpy(newRoman, old, strlen(old));
      newRoman = strncat(newRoman, symbols[7], 4);  
      break;
      
    case 9:
      newRoman = calloc( sizeof(old) + 2, charsize );
      newRoman = strncpy(newRoman, old, strlen(old));
      newRoman = strncat(newRoman, symbols[8], 2);  
      break;
    
    default:
      newRoman = *romanNum;
    }
    
    romanNum = &newRoman; 
    free(old);
  }
}

char* to_roman(int num) 
{
  if (num == 0)
    return "Z";   // actually should be nullus B)

  char* romanNum[1];
  size_t charsize = sizeof(romanNum[0]);
  if (num < 0) {
    char* newRoman = calloc( sizeof(romanNum) + 1, charsize );
    if (!newRoman)
      yyerror("Ran out of memory\n");
      
    newRoman = strncpy(newRoman, romanNum, sizeof(romanNum));
    newRoman = strncat(newRoman, "-", 1);
    char* old = romanNum;
    romanNum = newRoman;
    free(old);
    num = -num;
  }
  
  // assign thousands
  if (num % 1000 == 0)
  {
    for ( int rem = num; rem > 0; rem -= 1000) {
      char* newRoman = calloc( sizeof(romanNum) + 1, charsize );
      if (!newRoman)
        yyerror("Ran out of memory\n");
        
      newRoman = strncpy(newRoman, romanNum, strlen(romanNum));
      newRoman = strncat(newRoman, "M", 1);
      char* old = romanNum;
      romanNum = newRoman;
      free(old);
    }
  }
  
  // assign hundreds
  num = num % 1000;
  int hund = num / 100;
  add_roman_unit(&romanNum, SYM_HUNDREDS, num);
   // assign tens
  num = num % 100;
  int ten = num / 10;
  add_roman_unit(&romanNum, SYM_TENS, num);

  // assign ones
  num = num % 10;
  add_roman_unit(&romanNum, SYM_ONES, num);
  
  return romanNum;
}

int main()
{ 
  yyparse();
  return 0;
}

void yyerror(char* s)
{
  printf(s);
  exit(0);
}




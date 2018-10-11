/*
  CS3071  Assignment 3 plates.l 
  Matthew Ng ngm1@tcd.ie 16323205
*/

ONGOING_COUNTY  C|CE|CN|CW|D|DL|G|KE|KK|KY|L|LD|LH|LM|LS|MH|MN|MO|OY|RN|SO|W|WH|WX|WW
PREV_COUNTY     LK|TN|TS|WD
NEW_COUNTY      T

%{
const int CURRENT_YEAR = 2018;
const int CURRENT_PLATE_YEAR = 18;
const int MIN_YEAR = 1987;
const int SPEC_CHANGE_YEAR = 2014;
const int PLATE_YEAR_CHANGE = 2013;

int getYear(char* reg);
%}
%%

13[12]-({PREV_COUNTY}|{ONGOING_COUNTY})-[0-9]{1,6}  { // only 2013 had new year + old counties
                                             printf("%d\n", CURRENT_YEAR - 2013);
                                           }
                                           
[0-9]{2}[12]-({NEW_COUNTY})-[0-9]{1,6}     { // new year + new county
                                             int year = getYear(yytext);
                                             if (year >= SPEC_CHANGE_YEAR && year >= PLATE_YEAR_CHANGE && year <= CURRENT_YEAR) 
                                               printf("%d\n", CURRENT_YEAR - year);
                                             else
                                               printf("INVALID\n %d", year);        
                                           }    
                                             
[0-9]{2}-({PREV_COUNTY})-[0-9]{1,6}        { // old year + old county
                                             int year = getYear(yytext);
                                             if (year < SPEC_CHANGE_YEAR && year >= MIN_YEAR && year < PLATE_YEAR_CHANGE) 
                                               printf("%d\n", CURRENT_YEAR - year);
                                             else
                                               printf("INVALID\n %d", year);        
                                           }             
                                                                              
[0-9]{2}-{ONGOING_COUNTY}-[0-9]{1,6}       { 
                                             // old year, regular county
                                             int year = getYear(yytext);
                                             if (year >= MIN_YEAR && year < PLATE_YEAR_CHANGE) 
                                               printf("%d\n", CURRENT_YEAR - year);
                                             else
                                               printf("INVALID\n %d", year);    
                                           }
                                           
[0-9]{2}[12]-{ONGOING_COUNTY}-[0-9]{1,6}   { 
                                             // new year, regular county
                                             int year = getYear(yytext);
                                             if (year <= CURRENT_YEAR && year > PLATE_YEAR_CHANGE) 
                                               printf("%d\n", CURRENT_YEAR - year);
                                             else
                                               printf("INVALID\n %d", year);    
                                           }

[ \t\n]                                    { /*ignore*/ }
[^ \t\n]+                                  { printf("INVALID\n"); }

%%

int main()
{
  yylex();
  return 0;
}

int getYear(char* reg)
{
  int year = atoi(strtok(reg, "-"));
  if ( year / 100 > 0)
    year /= 10;
  
  if ( year<CURRENT_PLATE_YEAR && year >= 0)
    return 2000+year;
  return 1900+year;
}


/*
  CS3071  Assignment 4 roman.l 
  Matthew Ng ngm1@tcd.ie 16323205
*/
%{
# include "roman.tab.h"
void yyerror();
%}

%%
I             { return ONE; }
V       	    { return FIVE; }
X             { return TEN; }
L             { return FIFTY; }
C             { return HUNDRED; }
D             { return FIVE_HUNDRED; }
M             { return THOUSAND; }
\n            { return EOL; }
.             { yyerror(); }
%%


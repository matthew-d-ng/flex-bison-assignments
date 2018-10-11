/*
  CS3071  Assignment 2 comments.l 
  Matthew Ng ngm1@tcd.ie 16323205
*/
%{
// nothing here
%}

%%
\"[^\"]*\"      { printf("%s", yytext); }
\{[^\}]*\}	    { /* do nothing! */ }
"**".*/\n       { /* nothing */ }
[/{/}]          { printf("syntax error\n"); return -1; }
\n              { printf("%s", yytext); }
.	              { printf("%s", yytext); }

%%

int main()
{
  yylex();
  return 0;
}

/*
  CS3071  Assignment 1 even.l 
  Matthew Ng ngm1@tcd.ie 16323205
*/
%{
int evenNo = 0;
%}

%%

[0-9]*[02468]	  { evenNo++; }
[0-9]*[13579]   { /* ignore */ }
\n              { /*ignore*/ }
.		            { /* do nothing */ }

%%

int main()
{
  yylex();
  printf("%d\n", evenNo);
  return 0;
}

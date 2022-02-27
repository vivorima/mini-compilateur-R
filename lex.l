%{

	#include "syn.tab.h"
	#include "Fonctions.h"
	#include "Quad.h"
	#include<stdio.h>
	#include<stdlib.h>
	#include<string.h>

	
	extern nbLigne;
	static int next_column = 1;
    extern column;
    #define colonne_count column = next_column; next_column += strlen(yytext)


%}

cfr	   [0-9]
chfr   [1-9] 

integer {chfr}+{cfr}*|0
numeric	{cfr}+"."{cfr}+|0
car \'.\'
logical	(TRUE|FALSE)
idf [A-Z][a-z0-9]*

%%

INTEGER   		{	colonne_count; 	yylval.string = strdup(yytext); 	return mc_integer;	}
NUMERIC			{  	colonne_count;	yylval.string = strdup(yytext);		return mc_numeric;	}
CHARACTER		{	colonne_count; 	yylval.string = strdup(yytext);		return mc_car;		}
LOGICAL  		{	colonne_count; 	yylval.string = strdup(yytext);		return mc_logical;	}
FOR				{	colonne_count;	return mc_for;			}
WHILE			{	colonne_count;	return mc_while;		}
IF	     		{	colonne_count; 	return mc_if;			}
ELSE	   		{	colonne_count; 	return mc_else;			}
"ELSE IF"	    {	colonne_count; 	return mc_elseif;		}
IFELSE	   		{	colonne_count; 	return mc_ifelse;		}
IN				{	colonne_count;	return in;				}	
"and" 			{	colonne_count;	return and;				}
"or" 			{	colonne_count; 	return or;				}
"<-"			{	colonne_count;	return aff;				}
"+"				{	colonne_count;	return mc_plus;			}
"-"				{	colonne_count;	return mc_moins;		}
"*"				{	colonne_count;	return mc_mul;			}
"/"				{	colonne_count;	return mc_div;			}
"%"        		{	colonne_count;	return mc_rest;			}
"(" 			{	colonne_count; 	return parO;			}
")" 			{	colonne_count; 	return parF;			}
"{"				{ 	colonne_count;	return accO;			}				
"}"				{	colonne_count;	return accF;			}
"["				{ 	colonne_count;	return croO;			}
"]" 			{ 	colonne_count;	return croF;			}
\'				{ 	colonne_count;	return gui;				}
" "				{ 	colonne_count;	return space;			}
","				{ 	colonne_count;	return vrg;				}
":"				{	colonne_count; 	return pt;				}
"=="|">"|"<"|">="|"<="|"!="			{colonne_count; yylval.string=strdup(yytext);	return mc_comp;}
[ \t]			{	colonne_count;							}	
\n				{	colonne_count; 	next_column = 1;	nbLigne++;}

{integer}		{ colonne_count;  	yylval.integer=atoi(yytext);	return id_integer;	}
{numeric}		{ colonne_count; 	yylval.numeric = atof(yytext); 	return id_numeric;	}
{idf}			{ 
					colonne_count;
				  	if(yyleng<=10)
					  	{ 
					  		yylval.string = strdup(yytext);
					  		return id;
					  	}    
				  	else 
				  		printf("\nErreur lexicale a la ligne %d, colonne %d: Idf trop long.",nbLigne,column);
				}		
{car} 			{ colonne_count;	yylval.string = strdup(yytext);	return car;		}	
{logical} 		{ colonne_count;	yylval.string = strdup(yytext);	return logical;	}
   
"#".* 	{ 
			colonne_count;
			int i;
			for(i=0;i<yyleng;i++)
				if (yytext[i]=='\n') 
					nbLigne++;
		}
			   
. { 
	colonne_count;	
	printf("\nErreur lexicale: <<%s>> a la ligne %d, colonne %d.",yytext,nbLigne,column); 
  }
%%

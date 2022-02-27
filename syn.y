%{
#include <stdio.h>
#define YYERROR_VERBOSE 1

int nbLigne=1;
int column=1;
char type[10];
char TypeAffecte[10]; 
char sauvIdf[10];
char sauvTypeEXP[10];
char sauvIdf_EXP[10];
char sauv_comp[10];
char sauv_log[10];
char typeExp1[10];
char typeExp2[10];
char loc[10];
int borne1, borne2;
int pos = 0;
int posBR = 0;
int posEV = 0;
char snum[10];
char temp[10];
char temp2[10];
char tempCpt[10];
char var[10];
int erreur = 1;
int cpt = 1;
float valNum;
int valInt;
%}

	
   %union {

	int integer;
	float numeric;
	char* string;

   }


%token mc_integer
%token mc_numeric
%token mc_car
%token mc_logical
%token <integer>id_integer
%token <numeric>id_numeric
%token <string>id
%token <string>car
%token <string>logical
%token mc_for
%token mc_while
%token mc_if 
%token mc_elseif 
%token mc_else 
%token mc_ifelse 
%token in
%token <string>mc_comp 
%token aff
%token mc_plus
%token mc_moins
%token mc_mul    	 
%token mc_div 	 
%token mc_rest	
%token and
%token or
%token parO		  
%token parF		  
%token croO       
%token croF
%token accO
%token accF
%token space
%token vrg
%token gui
%token pt

%%
Start	: VAR INST {printf("\n\n\nProgramme Syntaxiquement Correct.\n");YYACCEPT;}
;
REEL: id_numeric 	{
						valNum = $1;
					}
		| parO mc_moins id_numeric parF {
											valNum = -$3;
										}
;
ENTIER: id_integer 			{
								valInt = $1;
							}
		| parO mc_moins id_integer parF {
											valInt = -$3;
										}
;
VAR:TYPE space VARS VAR
	|
;
TYPE : 
		 mc_integer {strcpy(type,"INTEGER");}

		|mc_numeric {strcpy(type,"NUMERIC"); }

		|mc_car {strcpy(type,"CHARACTER");}

		|mc_logical {strcpy(type,"LOGICAL");}
;

VARS:	 
		id space aff space VAL
						{	erreur = 1; //init
							if (doubleDeclaration($1)==1 ) 
								inserer($1,"IDF",type,1);
							else {
								printf("\nErreur Sementique: Double declaration de %s a la ligne %d.",$1,nbLigne);
								erreur = 0;
							}
							
							if (permit($1,TypeAffecte)==1) {
								printf("\nErreur Sementique: non compatibilite  de type entre %s et %s a Ligne %d.",$1,TypeAffecte,nbLigne);
								erreur = 0;
							}
							/* QUADS */
							if(erreur==1){ //false
								GEN(":=",snum,"",$1); //get snum fromVAL	
							}
						}
		
		|id croO id_integer croF {		erreur = 1;//init
										if (doubleDeclaration($1)==1 ) 
											inserer($1,"TAB",type,$3);
										else {
											printf("\nErreur Sementique: Double declaration de %s a la ligne %d.",$1,nbLigne);
											erreur = 0;
										}
										/* QUADS */
										if(erreur==1){
											itoa($3, snum, 10);
											GEN("BOUNDS","0",snum,"");
											GEN("ADEC",$1,"","");
										}

								}

		|id LISTE				{	
										if (doubleDeclaration($1)==1 ) 
											inserer($1,"IDF",type,1);
										else printf("\nErreur Sementique: Double declaration de %s a la ligne %d.",$1,nbLigne);
									}
;
VAL: 
		ENTIER  {
						strcpy(TypeAffecte,"INTEGER");
					 	sprintf(snum, "%d", valInt); 
					}
		
		|REEL {	strcpy(TypeAffecte,"NUMERIC");
						sprintf(snum, "%f", valNum); 
					}
		
		|car		{
						strcpy(TypeAffecte,"CHARACTER");
						sprintf(snum, "%s", $1); 

					}

		|logical	{	strcpy(TypeAffecte,"LOGICAL");
						sprintf(snum, "%s", $1);
					}

;

LISTE: 	vrg id LISTE	{
							if (doubleDeclaration($2)==1 ) 
								inserer($2,"IDF",type,1);
							else printf("\nErreur Sementique: Double declaration de %s a la ligne %d.",$2,nbLigne);
						}
		|
;

INST:INST_AFF INST
	|INST_INCRM INST
	|INST_IF INST
	|INST_IFELSE INST
	|INST_WHILE INST
	|INST_FOR INST
	|

;
INST_AFF: VAR_AFF aff VAL {		
								erreur = 1;
								if(strcmp(type,"")==0)//var non declared donc je l'ajoute
									{
										inserer(sauvIdf,"IDF",TypeAffecte,1);
										strcpy(sauvTypeEXP,(char*)TypeAffecte); 
									}
								else if(strcmp(type,"TabNONDEC")!=0)  //si le tab ou la var sont decalré
									{
										if(permit(sauvIdf,TypeAffecte)==1) //type mismatch
											{
												printf("\nErreur semantique : non compatibilite  de type entre %s et %s a la ligne %d.",sauvIdf,TypeAffecte,nbLigne);	
												erreur=0;
											}
										strcpy(sauvTypeEXP,(char*)get_TypeEntite(sauvIdf));
									}
								 /* QUADS */
								strcpy(temp,snum);
							} EXP {
								if(erreur==1 && strcmp(var,"_")==-1)
									GEN(":=",temp,"",var);
								}
		|VAR_AFF aff id  {		
								erreur = 1;
								if (doubleDeclaration($3)==1 ){ //non dec
									printf("\nErreur Sementique: Entite %s non declaree a la ligne %d.",$3,nbLigne);
									erreur = 0;
								}else 
								{
									if(strcmp((char*)get_CodeEntite($3),(char*)"TAB")==0)
									{
										printf("\nErreur Sementique: %s est un tableau, specifiez l'element..ligne %d.",$3,nbLigne);
										erreur = 0;
									}
									if(strcmp(type,"")==0)//var non declared donc je l'ajoute
										{
											inserer(sauvIdf,"IDF",(char*)get_TypeEntite($3),1);
											strcpy(sauvTypeEXP,(char*)get_TypeEntite($3)); //je copie le type de la prem val
										}
									else 
									{
									if(strcmp(type,"TabNONDEC")!=0) //tab declaré
										{
											if (permitParEntite(sauvIdf,$3)==1){
												printf("\nErreur semantique: non compatibilite de type entre %s et %s a la ligne %d.",sauvIdf,$3,nbLigne);
												erreur = 0;
											}
											strcpy(sauvTypeEXP,(char*)get_TypeEntite(sauvIdf));
										}
									}
								}

								/* QUADS */
								sprintf(temp, "%s", $3);
								/* QUADS */

							} EXP {/* QUADS */
									if(erreur==1 && strcmp(var,"_")==-1)
										GEN(":=",temp,"",var);
								   /* QUADS */
								}
		|VAR_AFF aff id croO id_integer croF {
								erreur =1;
        						//TABLEAU DROIT
        						if (doubleDeclaration($3)==1 ) //non dec
									{
										printf("\nErreur Sementique: Entité %s non declarée a la ligne %d.",$3,nbLigne);
										erreur=0;
									}
								else if(verifierDepassement_Taille_Tab($3,$5)==1) 
									{
										printf("\nErreur Semantique: Depassement de la taille du tableau %s, a la ligne %d.",$3,nbLigne);
										erreur=0;
									}
								//TABLEAU GAUCHE
								else {

									if(strcmp(type,"")==0)
									{
											inserer(sauvIdf,"IDF",(char*)get_TypeEntite($3),1);
											strcpy(sauvTypeEXP,(char*)get_TypeEntite($3)); //je copie le type de la prem val
									}
									else if(strcmp(type,"TabNONDEC")!=0) //tab ou var declaré 
										{	if(permitParEntite(sauvIdf,$3)==1)
												{
													printf("\nErreur semantique: non compatibilite  de type entre %s et %s a la ligne %d.",sauvIdf,$3,nbLigne);
													erreur=0;
												}
											strcpy(sauvTypeEXP,(char*)get_TypeEntite(sauvIdf));
										}
								}

								/* QUADS */
								sprintf(temp, "%s%s%d%s", $3 ,"[",$5,"]");
								
        					} EXP {
								if(erreur==1 && strcmp(var,"_")==-1) //Aucune erreur
									GEN(":=",temp,"",var);
								}	

;

VAR_AFF:    id  {
					if (doubleDeclaration($1)==1 ) 
					{
						strcpy(sauvIdf,$1); //VARIABLE non declare devine type
						strcpy(type,"");
					}
					else {
						if(strcmp((char*)get_CodeEntite($1),(char*)"TAB")==0)
						{
							printf("\nErreur Sementique: %s est un tableau, specifiez l'element..ligne %d.",$1,nbLigne);
						}
						strcpy(type,(char*)get_TypeEntite($1));	//VARIABLE DECLARED 	
						strcpy(sauvIdf,$1);
					}
					
					sprintf(var, "%s", $1);
					 
				}
		    |id croO id_integer croF 
		    	{	erreur = 1; //init
					if (doubleDeclaration($1)==1 ) //TABLEAU NON DECLARED
						{
							printf("\nErreur Sementique: Entité %s non declarée a la ligne %d.",$1,nbLigne);
							strcpy(type,"TabNONDEC"); //pour faire la diff avec une variable non decalrée
							erreur = 0;
						}
					else 
						{	//TAB DECLARED  
							if(verifierDepassement_Taille_Tab($1,$3)==1) 
							{
								printf("\nErreur Semantique: Depassement de la taille du tableau %s, a la ligne %d.",$1,nbLigne);
								erreur = 0;
							}
							strcpy(type,(char*)get_TypeEntite($1)); 
							strcpy(sauvIdf,$1);
						}
						if(erreur==1){
							sprintf(var, "%s%s%d%s", $1 ,"[",$3,"]");
						}else sprintf(var, "%s","_"); //pour signaler une erreur en haut
				}
			 
;

COMP:mc_plus 		{strcpy(sauv_comp,"+");}
	|mc_moins		{strcpy(sauv_comp,"-");}
	|mc_div			{strcpy(sauv_comp,"/");}
	|mc_mul			{strcpy(sauv_comp,"*");}
	|mc_rest		{strcpy(sauv_comp,"%");}
;

LOG:and 		{strcpy(sauv_log,"and");}
	|or 		{strcpy(sauv_log,"or");}
;

EXP: COMP ENTIER 					{	erreur =1 ;
													if((strcmp(sauv_comp,"/")==0 || strcmp(sauv_comp,"%")==0) && valInt==0 ) //DIV PAR ZERO
													{
														printf("\nErreur Semantique: Division par 0 a la ligne %d.",nbLigne);
														erreur = 0;
													}
													if(permit_cond((char*)sauvTypeEXP,"INTEGER")==1)
													{
														printf("\nErreur Semantique: non compatibilite %s avec %d, a la ligne %d.",sauvTypeEXP,valInt,nbLigne);
														erreur = 0;
													}
													/* QUADS */
													if(erreur==1 && strcmp(var,"_")==-1){ //Aucune erreur
														CreerTemp(tempCpt);
														sprintf(snum, "%d", valInt);
														GEN(sauv_comp,temp,snum, tempCpt);
														strcpy(temp, tempCpt);
													}

										}EXP
	|COMP REEL
												{	erreur =1 ;
													if((strcmp(sauv_comp,"/")==0 || strcmp(sauv_comp,"%")==0) && valNum==0 ) //DIV PAR ZERO
													{
														printf("\nErreur Semantique: Division par 0 a la ligne %d.",nbLigne);
														erreur = 0;
													}
													
													if(strcmp((char*)sauvTypeEXP,"NUMERIC")==-1)
													{	
														printf("\nErreur Semantique: non compatibilite %s avec %f a la ligne %d.",sauvTypeEXP,valNum,nbLigne);
														erreur = 0;
													}
													if(erreur==1 && strcmp(var,"_")==-1){ //Aucune erreur
														CreerTemp(tempCpt);
														sprintf(snum, "%f", valNum);
														GEN(sauv_comp,temp,snum, tempCpt);
														strcpy(temp, tempCpt);
													}
												}EXP	
	|COMP id
										{erreur =1 ;
													if (doubleDeclaration($2)==1 ) //non dec
														{
															printf("\nErreur Sementique: Entité %s non declarée a la ligne %d.",$2,nbLigne);
															erreur = 0;
														}
													else 
													{	
														if(strcmp((char*)get_CodeEntite($2),(char*)"TAB")==0)
														{
															printf("\nErreur Sementique: %s est un tableau, specifiez l'element..ligne %d.",$2,nbLigne);
															erreur = 0;
														}
														if(permit_cond((char*)sauvTypeEXP,(char*)get_TypeEntite($2))!=0)
														{
															printf("\nErreur Semantique: non compatibilite entre %s et %s a la ligne %d.",sauvTypeEXP,$2,nbLigne);
															erreur = 0;
														}
													}
													if(erreur==1 && strcmp(var,"_")==-1){ //Aucune erreur
														CreerTemp(tempCpt);
														GEN(sauv_comp,temp,$2, tempCpt);
														strcpy(temp, tempCpt);
													}

										}EXP	
	|COMP id croO id_integer croF 				{	erreur =1 ;
													if (doubleDeclaration($2)==1 ) //non dec
													{	
														printf("\nErreur Sementique: Entité %s non declarée a la ligne %d.",$2,nbLigne);
														erreur = 0;
													}	
													else 
														{
															if(verifierDepassement_Taille_Tab($2,$4)==1) {
																printf("\nErreur Semantique: Depassement de la taille du tableau %s a la ligne %d.",$2,nbLigne);
																erreur = 0;
															}
														
															if(permit_cond((char*)sauvTypeEXP,(char*)get_TypeEntite($2))!=0)
															{
																printf("\nErreur Semantique: non compatibilite de %s avec %s a la ligne %d.",sauvTypeEXP,$2,nbLigne);
																erreur = 0;
															}
														}
													if(erreur==1 && strcmp(var,"_")==-1){ //Aucune erreur
														CreerTemp(tempCpt);
														sprintf(temp2, "%s%s%d%s", $2 ,"[",$4,"]");
														GEN(sauv_comp,temp,temp2, tempCpt);
														strcpy(temp, tempCpt);
													}
												}EXP
	|space LOG space logical			{			
													erreur =1 ;
													if(permit_cond((char*)sauvTypeEXP,"LOGICAL")==1)
													{
														printf("\nErreur Semantique: non compatibilite %s avec %s a la ligne %d.",sauvTypeEXP,$4,nbLigne);
														erreur = 0;
													}
													if(erreur==1 && strcmp(var,"_")==-1){ //Aucune erreur
														CreerTemp(tempCpt);
														GEN(sauv_log,temp,$4, tempCpt);
														strcpy(temp, tempCpt);
													}
												}EXP

	|space LOG space id						{
												erreur =1;
												if (doubleDeclaration($4)==1) {
														printf("\nErreur Sementique: Entité %s non declarée a la ligne %d.",$4,nbLigne);
														erreur = 0;
												}else
												{

													 if(strcmp((char*)get_CodeEntite($4),(char*)"TAB")==0)
													{
														printf("\nErreur Sementique: %s est un tableau, specifiez l'element..ligne %d.",$4,nbLigne);
														erreur = 0;
													}
													if(permit_cond((char*)sauvTypeEXP,(char*)get_TypeEntite($4))==1)
													{
														printf("\nErreur Semantique: non compatibilite %s avec %s a la ligne %d.",sauvTypeEXP,$4,nbLigne);
														erreur = 0;
													}
												}
												if(erreur==1 && strcmp(var,"_")==-1){ //Aucune erreur
														CreerTemp(tempCpt);
														GEN(sauv_log,temp,$4, tempCpt);
														strcpy(temp, tempCpt);
													}
												}EXP

	|space LOG space id croO id_integer croF{	
												erreur = 1;
												if (doubleDeclaration($4)==1 ) //non dec 
												{
														printf("\nErreur Sementique: Entité %s non declarée a la ligne %d.",$4,nbLigne);
														erreur = 0;
												}
												else { 
													if(verifierDepassement_Taille_Tab($4,$6)==1) {
														printf("\nErreur Semantique: Depassement de la taille du tableau %s, a la ligne %d.",$4,nbLigne);
														erreur = 0;
													}

													if(permit_cond((char*)sauvTypeEXP,(char*)get_TypeEntite($4))==1)
													{
														printf("\nErreur Semantique: non compatibilite %s avec %s, a la ligne %d.",sauvTypeEXP,$4,nbLigne);
														erreur = 0;
													}
												}
												if (erreur==1 && strcmp(var,"_")==-1){ //Aucune erreur
														CreerTemp(tempCpt);
														sprintf(temp2, "%s%s%d%s", $4 ,"[",$4,"]");
														GEN(sauv_log,temp,temp2, tempCpt);
														strcpy(temp, tempCpt);
												}
											}EXP
	|
;

INST_INCRM: id mc_plus aff id_integer 		{	//id int ici doit etre positif
												erreur = 1; //init
												if (doubleDeclaration($1)==1 ) //non dec
												{
													printf("\nErreur Sementique: Entité %s non declarée a la ligne %d.",$1,nbLigne);
													erreur=0;
												}else if(strcmp((char*)get_CodeEntite($1),(char*)"TAB")==0)
												{
													printf("\nErreur Sementique: %s est un tableau, specifiez l'element..ligne %d.",$1,nbLigne);
													erreur = 0;
												}	
													
												if($4<=0){
													printf("\nErreur Semantique: %d est = 0 a la ligne %d.",$4,nbLigne);
													erreur=0;
												}
												
												/* QUADS */
												if(erreur==1)
												{
													itoa($4, snum, 10);
													CreerTemp(temp);
													GEN("+",$1,snum,temp);
													GEN(":=",temp,"",$1);
												}
												/* QUADS */

											}
			|id mc_moins aff id_integer {	erreur = 1; //init
												if (doubleDeclaration($1)==1 ) //non dec
													{
														printf("\nErreur Sementique: Entité %s non declarée a la ligne %d.",$1,nbLigne);
														erreur=0;
													}else if(strcmp((char*)get_CodeEntite($1),(char*)"TAB")==0)
												{
													printf("\nErreur Sementique: %s est un tableau, specifiez l'element..ligne %d.",$1,nbLigne);
													erreur = 0;
												}
												if($4<=0)
													{
														printf("\nErreur Semantique: %d est = 0 a la ligne %d.",$4,nbLigne);
														erreur=0;
													}
												/* QUADS */
													if(erreur==1)
													{	itoa($4, snum, 10);
														CreerTemp(temp);
														GEN("-",$1,snum,temp);
														GEN(":=",temp, "",$1);
													}
												/* QUADS */

											}
			|id croO id_integer croF mc_plus aff id_integer {	
												erreur = 1; //init
												if (doubleDeclaration($1)==1 ) //non dec
													{
														printf("\nErreur Sementique: Entité %s non declarée a la ligne %d.",$1,nbLigne);
														erreur=0;
													}
												else if(verifierDepassement_Taille_Tab($1,$3)==1) 
												{
													printf("\nErreur Semantique: Depassement de la taille du tableau %s a la ligne %d.",$1,nbLigne);
													erreur=0;	
												}
												if($7<=0)
												{
													printf("\nErreur Semantique: %d est <=0 a la ligne %d.",$7,nbLigne);
													erreur=0;
												}
												/* QUADS */
												if(erreur==1)
													{
														itoa($7, snum, 10);
														CreerTemp(temp);
														GEN("+",$1,snum,temp);
														GEN(":=",temp,"",$1);
													}
												/* QUADS */

											}
			|id croO id_integer croF mc_moins aff id_integer {	
												erreur = 1; //init
												if (doubleDeclaration($1)==1 ) //non dec
												{
													printf("\nErreur Sementique: Entité %s non declarée a la ligne %d.",$1,nbLigne);
													erreur=0;	
												}	
												else if(verifierDepassement_Taille_Tab($1,$3)==1) 
												{
													printf("\nErreur Semantique: Depassement de la taille du tableau %s a la ligne %d.",$1,nbLigne);
													erreur=0;
												}
												if($7<=0)
												{
													printf("\nErreur Semantique: %d est <=0 a la ligne %d.",$7,nbLigne);
													erreur=0;
												}
												/* QUADS */
												if(erreur==1)
												{
													itoa($7, snum, 10);
													CreerTemp(temp);
													GEN("-",$1,snum,temp);
													GEN(":=",temp,"",$1);
												}
												/* QUADS */
											}
;



INST_IF:  mc_if parO CONDIT parF accO INST {
											pos = getNumQuads();
											addPos(pos, posBR); 
											} 
											accF SUITE
;

SUITE: mc_elseif parO CONDIT parF accO INST {
											pos = getNumQuads();
											addPos(pos, posBR);
											} 
											accF SUITE
	  |mc_else accO INST accF
	  |
;

INST_IFELSE: VAR_AFF aff mc_ifelse parO CONDIT vrg Membre EXP vrg Membre EXP parF {
																			if(erreur==1 && strcmp(var,"_")==-1){
																				pos = getNumQuads();
																				addPos(pos-1, posBR); 
																				GEN(":=",temp,"",var); 
																			}
																		  }
;

INST_WHILE: mc_while parO {posEV = getNumQuads();} CONDIT parF accO INST accF {
														 if(erreur==1 && strcmp(var,"_")==-1){
															pos = getNumQuads();
															addPos(pos+1, posBR); //add pos du br
															sprintf(snum,"%d",posEV);
															GEN("BR",snum,"","");
														}
													 }
;

INST_FOR: mc_for parO id space in space id_integer pt id_integer 
						      			{	//int ici doit etre positif
						      				erreur = 1;
						      				if (doubleDeclaration($3)==1 ) //non dec meme si elle est pas dec je l'insere
												{
													inserer($3,"TEMP","INTEGER",1);

												}else 
												{
													if(strcmp((char*)get_CodeEntite($3),(char*)"TAB")==0)
													{
														printf("\nErreur Sementique: %s est un tableau, specifiez l'element..ligne %d.",$3,nbLigne);
														erreur = 0;
													}
													if (strcmp((char*)get_TypeEntite($3),"INTEGER")==-1 && strcmp((char*)get_TypeEntite($3),"NUMERIC")==-1)	{

								      					printf("\nErreur Semantique: non compatibilite de %s avec les entiers a la ligne %d.",$3,nbLigne);
								      					erreur=0;
								      				}
								      			}
						      				borne1 = $7;
											borne2 = $9;
												if (borne2 <= borne1 || borne1<0 || borne2 <=0){
												printf("\nErreur S%cmantique: bornes fausses,%c la ligne %d.",130,133,nbLigne);
												erreur = 0;
											}
											if(erreur==1 && strcmp(var,"_")==-1){
												sprintf(temp, "%s", $3);
												sprintf(temp2, "%d", $9);
												sprintf(snum, "%d", borne1);
												GEN(":=",snum,"",temp);
												posBR = getNumQuads();
												GEN("BGE","",temp,temp2);//generer sans la pos du  br
												
											}
										} parF accO INST accF {
																pos = getNumQuads();
																addPos(pos+2, posBR); 
																sprintf(snum,"%d",posBR);
																sprintf(temp, "%s", $3);
																GEN("+","",temp,"1");
																GEN("BR",snum,"","");
									     					  }
;

CONDIT: Membre EXP mc_comp {strcpy(loc, temp);} Membre EXP	{	
																if(strcmp($3, "==")==0) strcpy(temp2, "BNE"); 
																else if(strcmp($3, "!=")==0) strcpy(temp2, "BE");
																else if(strcmp($3, ">=")==0) strcpy(temp2, "BL");
																else if(strcmp($3, "<=")==0) strcpy(temp2, "BG");
																else if(strcmp($3, ">")==0)  strcpy(temp2, "BLE"); 
																else if(strcmp($3, "<")==0)  strcpy(temp2, "BGE"); 

																posBR = getNumQuads();
																sprintf(snum, "%d", posBR);
																GEN(temp2,"",loc,temp);//generer sans la pos du  br
															}
;

Membre: id 			
									{	erreur=1;
										if (doubleDeclaration($1)==1 ) //NON DECLARED
										{
											printf("\nErreur Sementique: Entité %s non declarée a la ligne %d.",$1,nbLigne);
											erreur=0;
										}else if(strcmp((char*)get_CodeEntite($1),(char*)"TAB")==0)
												{
													printf("\nErreur Sementique: %s est un tableau, specifiez l'element..ligne %d.",$1,nbLigne);
													erreur = 0;
												}		
										sprintf(temp, "%s", $1);
										strcpy(sauvTypeEXP,(char*)get_TypeEntite($1));
									}
		|id croO id_integer croF	{	erreur=1;
										if (doubleDeclaration($1)==1 ) //NON DECLARED
										{
											printf("\nErreur Sementique: Entité %s non declarée a la ligne %d.",$1,nbLigne);
											erreur=0;
										}
										else 
											{	//DECLARED  
												if(verifierDepassement_Taille_Tab($1,$3)==1) 
												{
													printf("\nErreur Semantique: Depassement de la taille du tableau %s, a la ligne %d.",$1,nbLigne);
													erreur=0;
												}
											}
										sprintf(temp, "%s%s%d%s", $1, "[", $3, "]");
										strcpy(sauvTypeEXP,(char*)get_TypeEntite($1));
									}
		|ENTIER		{
							strcpy(sauvTypeEXP,"INTEGER"); 
							sprintf(temp, "%d", valInt);
						}

		|REEL		 {
							strcpy(sauvTypeEXP,"NUMERIC"); 
							sprintf(temp, "%f", valNum);
						}

		|car			{
							strcpy(sauvTypeEXP,"CHARACTER"); 
							sprintf(temp, "%c", $1);
						}
						
		|logical			 {
							strcpy(sauvTypeEXP,"LOGICAL"); 
							sprintf(temp, "%s", $1);
						}

;

%%

main()
{
yyparse();
afficher();
afficher_qdr();
}
yywrap()
{}
int yyerror(char *s) 
{
    printf("\nErreur Syntaxique << %s >> a la ligne %d, colonne %d.\n",s,nbLigne,column);
}

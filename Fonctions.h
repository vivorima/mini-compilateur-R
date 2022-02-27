typedef struct liste
{
char *NomEntite;
char *TypeEntite;
int TailleEntite;
char *CodeEntite;
struct liste *nxt;
} li;

li *MaTS=NULL;

li *rechercher(char *entite){
	li *cout=MaTS;
	if(MaTS==NULL)return NULL;
	while(cout!=NULL)
	{
		if (strcmp(entite,cout->NomEntite)==0) return cout;
		cout=cout->nxt;
	}
	return NULL;
}

void inserer(char *entite, char* code, char* type, int taille){
	li *cout=NULL,*suiv=MaTS;
	if (rechercher(entite)==NULL)
	{
		cout=malloc(sizeof(li));
		cout->nxt = malloc(sizeof(li));
		cout->NomEntite=malloc((strlen(entite)+1)*sizeof(char));
        strcpy(cout->NomEntite,entite);
		cout->TypeEntite=malloc((10)*sizeof(char));
		cout->CodeEntite=malloc((20)*sizeof(char));
	    strcpy(cout->TypeEntite,type);		
		strcpy(cout->CodeEntite,code);		
        cout->TailleEntite=taille;
		cout->nxt = NULL;
	    if(MaTS==NULL) 
			{
				MaTS=cout;
			}
	    else{
	    	while(suiv->nxt!=NULL){
			suiv=suiv->nxt;
		    }
			suiv->nxt=cout;
		}
	}
}

void afficher (){ 
    printf("\n\n\t\t\t/***************  Table des symboles  ****************/\n");
    printf(" ___________________________________________________________________________________________________\n");
	printf("\n |     Nom Entite         |      Code Entite      |        Type Entite       |       Taille        |\n");
    printf(" ___________________________________________________________________________________________________\n");
	int i =0;
    li *cout=MaTS;
	while(cout!=NULL){
        printf(" |%10s              |         %10s    |          %10s      |          %5d      |\n",cout->NomEntite,cout->CodeEntite,cout->TypeEntite,cout->TailleEntite);
    	cout=cout->nxt;
    }
	printf("\n\t\t\t\t\t*****  Fin affichage  *****\n");
}

void insererType(char *entite, char *type){
	li *cout=rechercher(entite);
	strcpy(cout->TypeEntite,type);
}
void insererCode(char *entite, char *code){
	li *cout=rechercher(entite);
	strcpy(cout->CodeEntite,code);
}
void insererTaille(char *entite, int taille){
	li *cout=rechercher(entite);
	cout->TailleEntite= taille;	
}

////Les routines sémantiques



int doubleDeclaration (char *entite){
	li *cout=rechercher(entite);
	//variable non doublement declarée
	if(cout == NULL) return 1;//n'existe pas 
	return 0; //existe donc double dec
}


int verifierDeclaration (char *entite){
	li *cout=rechercher(entite);
	if (strcmp(cout->TypeEntite,"")==0)return 0;
	else return 1;
}


int verifierDepassement_Taille_Tab(char *entite,int tail){
	li *cout=rechercher(entite);
    int taille_tab = cout->TailleEntite;
	if(tail < taille_tab && tail >= 0) return 0;
	else return 1;// depassement de taille tableau 
}

int permitParEntite(char* entite1,char* entite2 )
{
	li *cout1=rechercher(entite1);
	li *cout2=rechercher(entite2);
	char* type1 = cout1->TypeEntite;
	char* type2 = cout2->TypeEntite;
	
	if(strcmp(type1,type2)==0) return 0;// elle sont compatible
	//else return 1;
	if((strcmp(type1,"CHARACTER")==0)||(strcmp(type2,"CHARACTER")==0)) return 1;// non compatible
	if((strcmp(type1,"LOGICAL")==0)||(strcmp(type2,"LOGICAL")==0)) return 1;// non compatible
	if((strcmp(type1,"NUMERIC")==0)&&(strcmp(type2,"INTEGER")==0)) return 0;//compatible float := int
	else return 1;// non compatible
}

int permit(char* entite1,char* type )
{
	li *cout1=rechercher(entite1);
	char* type1 = cout1->TypeEntite;
	
	if(strcmp(type1,type)==0) return 0;// elles sont compatibles
	//else return 1;
	if((strcmp(type1,"CHARACTER")==0)||(strcmp(type,"CHARACTER")==0)) return 1;// non compatible
	if((strcmp(type1,"LOGICAL")==0)||(strcmp(type,"LOGICAL")==0)) return 1;// non compatible
	if((strcmp(type1,"NUMERIC")==0)&&(strcmp(type,"INTEGER")==0)) return 0;//compatible float := int
	else return 1;// non compatible
}
int permit_cond(char* typeExp1,char* typeExp2)
{
	if(strcmp(typeExp1,typeExp2)==0) return 0;
	if((strcmp(typeExp1,"NUMERIC")==0)&&(strcmp(typeExp2,"INTEGER")==0)) return 0;
	return 1;
}
char* get_TypeEXP(char* type_Exp1,char op,char* type_Exp2)
{
	char* type=malloc((10)*sizeof(char));
	strcpy(type,"float");
	if (op=='/') return (type);
	if((strcmp(type_Exp1,type)==0)||(strcmp(type_Exp2,type)==0)) return(type);
	strcpy(type,"int");
	return (type);
}
char* get_TypeEntite(char* entite)
{
	li *cout=rechercher(entite);
	char* type=malloc((10)*sizeof(char));
	if(cout!=NULL)	strcpy(type, cout->TypeEntite);
	return type;
}

char* get_CodeEntite(char* entite)
{
	li *cout=rechercher(entite);
	char* code=malloc((10)*sizeof(char));
	if(cout!=NULL)	strcpy(code, cout->CodeEntite);
	return code;
}

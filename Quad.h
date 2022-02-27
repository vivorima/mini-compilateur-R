#include<stdio.h>
char* Quad[300][4];
int QuadSuiv = 0; /* initialement, la matrice Quad est vide */
int Indice = 1;


void GEN (char *OP,char *ARG1,char *ARG2,char *RES)
{
	Quad[QuadSuiv][0] = malloc(sizeof(char) * 10);
	Quad[QuadSuiv][1] = malloc(sizeof(char) * 10);
	Quad[QuadSuiv][2] = malloc(sizeof(char) * 10);
	Quad[QuadSuiv][3] = malloc(sizeof(char) * 10);

	snprintf(Quad[QuadSuiv][0], 10, "%s", OP);
	snprintf (Quad[QuadSuiv][1], 10,"%s", ARG1);
	snprintf (Quad[QuadSuiv][2], 10,"%s", ARG2);
	snprintf (Quad[QuadSuiv][3], 10,"%s", RES);
	QuadSuiv++;
}

void addPos (int pos, int num)
{
	Quad[num][1] = malloc(sizeof(char) * 10);

	snprintf (Quad[num][1], 10,"%d", pos);
}

void CreerTemp(char *temp)
{	
	sprintf(temp, "x%d", Indice);
	Indice++;
}

int getNumQuads()
{
	return QuadSuiv; 
}

void afficher_qdr()
{
	printf("\n\n\t\t\t/***************  Les Quadruplets  ****************/\n");
	int i;
	for(i=0;i<QuadSuiv;i++)
			{
	printf("\n\t\t\t %d - ( %s  ,  %s  ,  %s  ,  %s )",i,Quad[i][0],Quad[i][1],Quad[i][2],Quad[i][3]); 
	 printf("\n\n\t\t\t---------------------------------------------------\n");
	}
	printf("\n\t\t\t\t\t*****  Fin Quadruplets  *****\n");
}

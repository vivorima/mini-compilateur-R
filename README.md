# mini-compilateur-R

**Rapport du Projet de Compilation du Langage R**

**Analyse Lexicale Avec Flex :**

Nous commençons par définir les différents types possibles indiqués dans
l’énoncé à l’aide des expressions régulières


Nous avons associé à chaque mot clé du langage son identificateur afin de le
reconnaitre


Pour autoriser les commentaires, nous avons ajouté l’expression régulière :

Chaque ligne du commentaire doit être précédée par un « \# ».

**Analyse Syntaxico-sémantique Avec Bison :**

**Analyse syntaxique :**

Dans le but de définir le langage R, nous avons conçu des grammaires conformes
aux structures des instructions mentionnées dans l’énoncé.

La grammaire globale qui fait appel aux déclarations des variables ainsi que les
différentes instructions est :

La grammaire faisant appel à la déclaration d’une ou multiples variables avec ou
sans affectation est la suivante :

Avec :

-   

-   

-   

-   

-   

-   

La grammaire constituant les différentes formes d’instructions est :

-   **Affectation** :

    Avec représentant la variable définie recevant l’affectation que ce soit une
    simple variable ou bien un élément du tableau :

Les diverses expressions arithmétiques sont elles aussi formulées dans la
grammaire suivante :

\|

Avec :

-   **Incrémentation** :

-   **Conditions** :

-   **IF...** & **IF…ELSE…** & **IF...ELSE IF...ELSE:**

    Avec :

-   **IFELSE :**

    Avec :

-   **Boucle** :

-   **WHILE :**

-   **FOR :**

**Analyse sémantique :**

Des routines d’analyse sémantique ont été introduites dans toutes les grammaires
discutées précédemment afin d’assurer le bon fonctionnement du compilateur :

-   **Recherche d’une entité :** indique si une entité existe dans la table des
    symboles.

-   **Insertion :** sert à créer un nouvel élément dans la table des symboles
    afin d’inclure la variable fraichement déclarée. Présente après chaque
    vérification de déclaration, si cette dernière ne retourne aucune erreur
    alors la procédure d’insertion sera exécutée.

-   **Double déclaration :** introduite après la déclaration d’une variable,
    sert à vérifier si la variable existe déjà dans la table des symboles,
    retourne une erreur de type double déclaration.

-   **Vérification de la déclaration** : introduite en cas d’utilisation d’un
    identificateur inconnu lors de l’affectation ou autre. Retourne une erreur
    d’absence de déclaration de la variable considérée.

-   **Vérification du dépassement de taille :** programmée dans le but de
    signaler le dépassement de taille lors d’un accès au tableau considéré.
    Retourne une erreur de type dépassement de taille.

-   **Vérification du type** : indique s’il y a une compatibilité entre les
    types des variables en cas d’affectation ou d’expression
    arithmétique/logiques. Retourne une erreur de type absence de compatibilité.

**Gestion de la table des symboles :**

En ce qui concerne la table des symboles, nous avons opté pour une structure de
table dynamique programmée à l’aide des pointeurs. Chaque élément de la table
est composé de 4 champs :

-   Nom de l’entité (ex : A)

-   Type (ex : INTEGER)

-   Taille (1 sinon le nombre d’éléments du tableau)

-   Code (ex : ‘IDF’ / ‘TAB’ en cas de tableau / ‘TEMP’ pour les variables
    utilisées dans une boucle)

**Prenons un exemple simple :**

![](media/2e8a73b6c6fcc72109de7881277d26be.png)

**Tables des Symboles :**

**![](media/005f37a932b5f8f5a60153bffe03c530.png)**

**Génération du code intermédiaire :**

La structure des quadruplets est une matrice Quad (𝒏,4), où 𝒏 est le nombre de
quadruplets.

Un quadruplet est composé de 4 champs :

-   OP est l'opérateur.

-   ARG1 et ARG2 sont les opérandes.

-   RES est le résultat.

Pour générer un quadruplet, nous avons créé une fonction qui prends en
paramètres les 4 champs cités ci-dessus, cette fonction mets à jour le compteur
qui nous indique la ligne (adresse) du quadruplet suivant dans la matrice

Pour générer les variables temporaires, la fonction nous permet de mettre à jour
(une variable globale initialisée à 1) des variables temporaires utilisées pour
la génération des quadruplets.

**Les quadruplets générés pour l’exemple précèdent :**

![](media/70dee5c4b212c614fe6d6594b52cde9b.png)

**Traitement des erreurs :**

Afin d’afficher des messages d’erreurs le plus précisément possible à chaque
étape du processus de compilation, nous avons rajouté deux variables « nbLigne
et nbColonne » partagées entre « Flex » et « Bison ».

**Dans Flex :**

Nous ajoutons la procédure compteur pour chaque entité lexicale afin de
comptabiliser le nombre de colonnes dans une ligne.

**Dans Bison :**

YYERROR_VERBOSE sert à nous donner plus d’informations concernant l’erreur
lexicale ou syntaxique.

**Exemple d’erreurs lexicales et syntaxiques :**

![](media/dc9b45e8cda235a7223593c052cd53db.png)

**Procédure d’exécution (sous Windows) :**

1.  Commande pour compiler le programme Flex :

    **Résultat** : création d’un fichier C dont le nom est

2.  Commande pour compiler le programme Bison :

    **Cette commande aura comme résultat 2 fichiers :**

-   : c’est un analyseur syntaxique de langage.

-   : contient la liste de tous les terminaux de langage.

1.  Commande pour créer le fichier exécutable (le compilateur) :

1.  Commande pour tester le compilateur sur un fichier texte :

![](media/bd671ad99c945b9d1d4a0ff4ba05eb07.png)

# Mini-compiler for R language

## This project is a basic compiler for R language using C Language, Flex and Bison.
it includes :
* A lexical analyzer.
* A syntactic parser.
* The generation of a table of symbols.
* The detection of semantic errors
* Intermediate code (quadruples).
* Generating code in assembler.
	
it was created using :
* MingW
* Flex version : 2.4.1 
* Bison version : 2.5.4a

To run the compiler open ***command prompt*** in this repo and type the following instructions:
* flex lex.l
* bison -d syn.y
* gcc lex.yy.c syn.tab.c -lfl -ly -o Compilateur
* .\Compilateur <exemple.txt
you can edit exmeple.txt 

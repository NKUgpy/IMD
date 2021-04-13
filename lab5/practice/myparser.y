%{
#include "mylexer.h"
#include <stdio.h>
#include <string.h>
#include <fstream>
#include <string>
#include"node.h"
#define YYSTYPE treenode*
void yyerror(const char *str)
{
    fprintf(stderr,"error: %s\n",str);
}
%}

%name myparser

%token IF
%token ELSE
%token FOR
%token WHILE
%token TYPE
%token ID
%token NUMBER
%token LOGO1
%token LOGO2
%token LOGO3
%token ARTO1
%token ARTO2
%token ASSO
%token BITO
%token LOGCON
%token IO
%token COMMA
%token SEMICOLON
%token CHART
%token LBRACE
%token RBRACE
%token LPAREN
%token RPAREN
%token LBRACK
%token RBRACK

%%
fun:
        ID LPAREN idlist RPAREN block_stmt{
                $$=new treenode(ComK);
                $$->child[0]=$1;
                $$->child[1]=$3;
                $$->child[2]=$5;
                $$->check_node();
                $$->print_tree(0);
                $$->get_label();
                $$->gen_code();
        }
        | ID LPAREN RPAREN block_stmt{
                $$=new treenode(ComK);
                $$->child[0]=$1;
                $$->child[2]=$4;
                $$->check_node();
                $$->print_tree(0);
                $$->get_label();
                $$->gen_code();
        }
        ;
block_stmt:
        LBRACE stmts RBRACE{
                $$=new treenode(ComK);
                $$->child[0]=$2;
        }
        | stmt{
                $$=$1;
        }
        ;
stmts:
        block_stmt stmts{
                $$=$1;
                $$->sibling=$2;
        }
        | block_stmt{
                $$=$1;
        }
        ;
stmt:
        io_stmt{
                $$=$1;
        }
        | while_stmt{
                $$=$1;
        }
        | for_stmt{
                $$=$1;
        }
        | if_stmt{
                $$=$1;
        }
        | ass_stmt{
                $$=$1;
        }
        | def_stmt{
                $$=$1;
        }
        | SEMICOLON{
               $$=new treenode(EmpK);
        }
        ;
io_stmt:
        IO expr SEMICOLON{
                $$=new treenode(IOK);
                $$->child[0]=$1;
                $$->child[1]=$2;
        };
while_stmt:
        WHILE expr block_stmt{
                $$=new treenode(WhileK);
                $$->child[0]=$2;
                if($3->kind.stmt!=ComK){
                        treenode* t=new treenode(ComK);
                        t->child[0]=$3;
                        $$->child[1]=t;
                }
                else{
                        $$->child[1]=$3;
                }
        }
        ;
for_stmt:
        FOR LPAREN for_expr_list RPAREN block_stmt{
                $$=new treenode(ForK);
                $$->child[0]=$3;
                if($5->kind.stmt!=ComK){
                        treenode* t=new treenode(ComK);
                        t->child[0]=$5;
                        $$->child[1]=t;
                }
                else{
                        $$->child[1]=$5;
                }
        }
        ;
for_expr_list:
         for_e SEMICOLON for_e SEMICOLON for_e {
                $$=new treenode(ExpL);
                $$->child[0]=$1;
                $$->child[1]=$3;
                $$->child[2]=$5;
        }
        | SEMICOLON for_e SEMICOLON for_e {
                $$=new treenode(ExpL);
                $$->child[1]=$2;
                $$->child[2]=$4;
        }
        | for_e SEMICOLON SEMICOLON for_e {
                $$=new treenode(ExpL);
                $$->child[0]=$1;
                $$->child[2]=$4;
        }
        | for_e SEMICOLON for_e SEMICOLON {
                $$=new treenode(ExpL);
                $$->child[0]=$1;
                $$->child[1]=$3;
        }
        | SEMICOLON SEMICOLON for_e {
                $$=new treenode(ExpL);
                $$->child[2]=$3;
        }
        | SEMICOLON for_e SEMICOLON {
                $$=new treenode(ExpL);
                $$->child[1]=$2;
        }
        | for_e SEMICOLON SEMICOLON {
                $$=new treenode(ExpL);
                $$->child[0]=$1;
        }
        | SEMICOLON SEMICOLON {
                $$=new treenode(ExpL);
        }
        ;
for_e:
        e1{
                $$=$1;
        }
        | e2{
                $$=$1;
        }
        ;
e1:
        e1_term COMMA e1{
                $$=$1;
                $$->sibling=$3;
        }
        | e1_term{
                $$=$1;
        }
        ;
e1_term:
        VAR ASSO expr{
                $$=new treenode(AssK);
                $$->child[0]=$1;
                $$->child[1]=$3;
        }
        ;
e2:
        log_expr{
                $$=$1;
        }
        ;
if_stmt:
        IF expr block_stmt{
                $$=new treenode(IfK);
                $$->child[0]=$2;
                if($3->kind.stmt!=ComK){
                        treenode* t=new treenode(ComK);
                        t->child[0]=$3;
                        $$->child[1]=t;
                }
                else{
                        $$->child[1]=$3;
                }
        }
        | IF expr block_stmt ELSE block_stmt {
                $$=new treenode(IfK);
                $$->child[0]=$2;
                if($3->kind.stmt!=ComK){
                        treenode* t=new treenode(ComK);
                        t->child[0]=$3;
                        $$->child[1]=t;
                }
                else{
                        $$->child[1]=$3;
                }
                if($5->kind.stmt!=ComK){
                        treenode* t=new treenode(ComK);
                        t->child[0]=$5;
                        $$->child[2]=t;
                }
                else{
                        $$->child[2]=$5;
                }
        }
        ;
        
def_stmt:
        TYPE idlist SEMICOLON{
                $$=new treenode(VarK);
                $$->child[0]=$1;
                $$->child[1]=$2;
        };
idlist:
        VAR COMMA idlist{
                $$=$1;
                $$->sibling=$3;
        }
        | VAR{
                $$=$1;
        }
        ;
ass_stmt:
        VAR ASSO ass_stmt {
                $$=new treenode(AssK);
                $$->child[0]=$1;
                $$->child[1]=$3;
                $$->type=$3->type;
                $$->name=$3->name;
        }
        | VAR ASSO expr SEMICOLON {
                $$=new treenode(AssK);
                $$->child[0]=$1;
                $$->child[1]=$3;
                $$->type=$3->type;
                $$->name=$3->name;
        }
        ;
expr:
        log_expr{
                $$=$1;
        }
        | art_expr{
                $$=$1;
        }
        ;
log_expr: 
        log_expr LOGO1 log_term{
                $$=new treenode(OpE);
                $$->child[0]=$1;
                $$->child[1]=$3;
                $$->attr.op=$2->attr.op;
                $$->name=$2->name;
        }
        | log_term{
                $$=$1;
        }
        ;
log_term: 
        log_term LOGO2 log_factor{
                $$=new treenode(OpE);
                $$->child[0]=$1;
                $$->child[1]=$3;
                $$->attr.op=$2->attr.op;
                $$->name=$2->name;
        }
        | log_factor{
                $$=$1;
        }
        ;
log_factor:
        LPAREN expr RPAREN{
                $$=$2;
        }
        | LOGO3 log_factor{
                $$=new treenode(OpE);
                $$->child[0]=$2;
                $$->attr.op=$1->attr.op;
                $$->name=$1->name;
        }
	| VAR{
                $$=$1;
        }
        | LOGCON{
                $$=$1;
        }
        | NUMBER{
                $$=$1;
        }
        | art_expr{
                $$=$1;
        }
        ;
art_expr:
        art_expr ARTO1 art_term{
                $$=new treenode(OpE);
                $$->child[0]=$1;
                $$->child[1]=$3;
                $$->attr.op=$2->attr.op;
                $$->name=$2->name;
        }
        | art_term{
                $$=$1;
        }
        ;
art_term:
        art_term ARTO2 art_factor{
                $$=new treenode(OpE);
                $$->child[0]=$1;
                $$->child[1]=$3;
                $$->attr.op=$2->attr.op;
                $$->name=$2->name;
        }
        | art_factor{
                $$=$1;
        }
        ;
art_factor:
        LPAREN expr RPAREN{
                $$=$2;
        }              
	| VAR{
                $$=$1;
        }
	| NUMBER{
                $$=$1;
        }
        | CHART{
                $$=$1;
        }
        ;
ARRAY:
        ID ARRAY_LIST{
                $$=new treenode(ArrayK);
                $$->name=$1->name;
                $$->attr.index=$3;
        }
        | ID ARRAY_LIST{
                $$=new treenode(ArrayK);
                $$->name=$1->name;
                $$->attr.index=$3;
        }
        ;
ARRAY_LIST:
        ARRAY_LIST LBRACK NUMBER RBRACK{
                $$=$1;
                $$->sibling=$3;
        }
        | ARRAY_LIST LBRACK ID RBRACK{
                $$=$1;
                $$->sibling=$3;
        }
        | LBRACK NUMBER RBRACK{
                $$=$2;
        }
        | LBRACK ID RBRACK{
                $$=$2;
        }
        ;
VAR:
        ID{
                $$=$1;
        }
        | ARRAY{
                $$=$1;
        }
        ;
%%


int main(void)
{
	int n = 1;
	mylexer lexer;
	myparser parser;
	if (parser.yycreate(&lexer)) {
		if (lexer.yycreate(&parser)) {
                        lexer.yyin = new ifstream("E:\\code\\compiling\\hw6\\test\\test7.txt");
			n = parser.yyparse();
		}
	}
        system("pause");
	return n;
}


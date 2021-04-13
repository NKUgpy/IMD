%{
#include "myparser.h"
#include <stdio.h>
#include <string.h>
#include <iostream>
#include <map>
#include "node.h"
#include <fstream>
#define YYSTYPE treenode*
extern YYSTYPE yylval;
extern char *yytext;
int temp_var_seq=0;
int temp_sum=-1;
using namespace std;
int line=0;
bool is_annotation1=false,is_annotation2=false;
int label_id=0;
ofstream outfile;
map<string, var> symbol_table;
%}


%name mylexer

ID [a-zA-Z_]([a-zA-Z]|[0-9]|_)*
CHART '.'
INPUT input
OUTPUT output
NOT \!
EQ \==
UEQ \!=
LOE \<=
GOE \>=
LESS \<
GREATER \>
ANNOTATION1 \/\/
ANNOTATION2_S \/\*
ANNOTATION2_E \*\/
NUMBER [0-9]+
IF if
ELSE else
FOR for
WHILE while
INT int
CHAR char
BOOL bool
TRUE true
FALSE false
PLUS \+
SUB \-
MUL \*
DIV \/
MOD \%
COMMA \,
SEMICOLON ;
AND \&\&
OR \|\|
ASSIGN \=
LBRACE \{
RBRACE \}
LPAREN \(
RPAREN \)
LBRACK \[
RBRACK \]
%%


%{
	// extract yylval for use later on in actions
	YYSTYPE YYFAR& yylval = *(YYSTYPE YYFAR*)yyparserptr->yylvalptr;
%}

{LBRACE} {
	if(!is_annotation1&&!is_annotation2){
		return LBRACE;
	}
}
{RBRACE} {
	if(!is_annotation1&&!is_annotation2){
		return RBRACE;
	}
}
{LPAREN} {
	if(!is_annotation1&&!is_annotation2){
		return LPAREN;
	}
}
{RPAREN} {
	if(!is_annotation1&&!is_annotation2){
		return RPAREN;
	}
}
{LBRACK} {
	if(!is_annotation1&&!is_annotation2){
		return LBRACK;
	}
}
{RBRACK} {
	if(!is_annotation1&&!is_annotation2){
		return RBRACK;
	}
}
{IF} {
	if(!is_annotation1&&!is_annotation2){
		return IF;
	}
}
{ELSE} {
	if(!is_annotation1&&!is_annotation2){
		return ELSE;
	}
}
{FOR} {
	if(!is_annotation1&&!is_annotation2){
		return FOR;
	}
}
{WHILE} {
	if(!is_annotation1&&!is_annotation2){
		return WHILE;
	}
}
{COMMA} {
	if(!is_annotation1&&!is_annotation2){
		return COMMA;
	}
}
{SEMICOLON} {
	if(!is_annotation1&&!is_annotation2){
		return SEMICOLON;
	}
}
{INPUT} {
	if(!is_annotation1&&!is_annotation2){
		treenode* t=new treenode(InputK);
		t->name=yytext;
		yylval=t; return IO;
	}
}
{OUTPUT} {
	if(!is_annotation1&&!is_annotation2){
		treenode* t=new treenode(OutputK);
		t->name=yytext;
		yylval=t; return IO;
	}
}
{INT} {
	if(!is_annotation1&&!is_annotation2){
		treenode* t=new treenode(TypeK);
		t->name=yytext;
		yylval=t;
		t->type=Integer;
		return TYPE;
	}
}
{CHAR} {
	if(!is_annotation1&&!is_annotation2){
		treenode* t=new treenode(TypeK);
		t->name=yytext;
		yylval=t;
		t->type=Char;
		return TYPE;
	}
}
{BOOL} {
	if(!is_annotation1&&!is_annotation2){
		treenode* t=new treenode(TypeK);
		t->name=yytext;
		yylval=t;
		t->type=Boolean;
		return TYPE;
	}
}
{ID} {
	if(!is_annotation1&&!is_annotation2){
		treenode* t=new treenode(IdK);
		t->name=yytext;
		yylval=t;
		return ID;
	}
}
{NUMBER} {
	if(!is_annotation1&&!is_annotation2){
		treenode* t=new treenode(ConstK);
		t->attr.val=atoi(yytext);
		t->name=yytext;
		t->type=Integer;
		yylval=t;
		return NUMBER;
	}
}
{CHART} {
	if(!is_annotation1&&!is_annotation2){
		treenode* t=new treenode(ConstK);
		t->name=yytext;
		t->type=Char;
		yylval=t;
		return CHART;
	}
}
{FALSE} {
	if(!is_annotation1&&!is_annotation2){
		treenode* t=new treenode(ConstK);
		t->name=yytext;
		t->type=Boolean;
		t->attr.boolean=false;
		yylval=t;
		return LOGCON;
	}
}
{TRUE} {
	if(!is_annotation1&&!is_annotation2){
		treenode* t=new treenode(ConstK);
		t->name=yytext;
		t->type=Boolean;
		t->attr.boolean=true;
		yylval=t;
		return LOGCON;
	}
}
{AND} {
	if(!is_annotation1&&!is_annotation2){
		treenode* t=new treenode(OpK);
		t->name=yytext;
		t->attr.op=AND;
		yylval=t;
		return LOGO1;
	}
}
{OR} {
	if(!is_annotation1&&!is_annotation2){
		treenode* t=new treenode(OpK);
		t->name=yytext;
		t->attr.op=OR;
		yylval=t;
		return LOGO1;
	}
}
{EQ} {
	if(!is_annotation1&&!is_annotation2){
		treenode* t=new treenode(OpK);
		t->name=yytext;
		t->attr.op=EQ;
		yylval=t;
		return LOGO2;
	}
}
{UEQ} {
	if(!is_annotation1&&!is_annotation2){
		treenode* t=new treenode(OpK);
		t->name=yytext;
		t->attr.op=UEQ;
		yylval=t;
		return LOGO2;
	}
}
{LOE} {
	if(!is_annotation1&&!is_annotation2){
		treenode* t=new treenode(OpK);
		t->name=yytext;
		t->attr.op=LOE;
		yylval=t;
		return LOGO2;
	}
}
{GOE} {
	if(!is_annotation1&&!is_annotation2){
		treenode* t=new treenode(OpK);
		t->name=yytext;
		t->attr.op=GOE;
		yylval=t;
		return LOGO2;
	}
}
{LESS} {
	if(!is_annotation1&&!is_annotation2){
		treenode* t=new treenode(OpK);
		t->name=yytext;
		t->attr.op=LESS;
		yylval=t;
		return LOGO2;
	}
}
{GREATER} {
	if(!is_annotation1&&!is_annotation2){
		treenode* t=new treenode(OpK);
		t->name=yytext;
		t->attr.op=GREATER;
		yylval=t;
		return LOGO2;
	}
}
{NOT} {
	if(!is_annotation1&&!is_annotation2){
		treenode* t=new treenode(OpK);
		t->name=yytext;
		t->attr.op=NOT;
		yylval=t;
		return LOGO3;
	}
}
{PLUS} {
	if(!is_annotation1&&!is_annotation2){
		treenode* t=new treenode(OpK);
		t->name=yytext;
		t->attr.op=PLUS;
		yylval=t;
		return ARTO1;
	}
}
{SUB} {
	if(!is_annotation1&&!is_annotation2){
		treenode* t=new treenode(OpK);
		t->name=yytext;
		t->attr.op=SUB;
		yylval=t;
		return ARTO1;
	}
}
{MUL} {
	if(!is_annotation1&&!is_annotation2){
		treenode* t=new treenode(OpK);
		t->name=yytext;
		t->attr.op=MUL;
		yylval=t;
		return ARTO2;
	}
}
{DIV} {
	if(!is_annotation1&&!is_annotation2){
		treenode* t=new treenode(OpK);
		t->name=yytext;
		t->attr.op=DIV;
		yylval=t;
		return ARTO2;
	}
}
{MOD} {
	if(!is_annotation1&&!is_annotation2){
		treenode* t=new treenode(OpK);
		t->name=yytext;
		t->attr.op=MOD;
		yylval=t;
		return ARTO2;
	}
}
{ASSIGN} {
	if(!is_annotation1&&!is_annotation2){
		treenode* t=new treenode(OpK);
		t->name=yytext;
		t->attr.op=ASSIGN;
		yylval=t;
		return ASSO;
	}
}
{ANNOTATION1} {is_annotation1=true;}
{ANNOTATION2_S} {is_annotation2=true;}
{ANNOTATION2_E} {is_annotation2=false;}
\n {
	is_annotation1=false;
	line++;
}
[ \t]+ /* ignore whitespace */;
%%
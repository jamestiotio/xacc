
grammar xasm;

/* This part of the grammar is particular to XACC */
/**********************************************************************/
xaccsrc
   : xacckernel
   | xacclambda
   ;

    xacckernel : '__qpu__' 'void' kernelname =
                    id '(' 'qbit' acceleratorbuffer =
                        id (',' typedparam) * ')' '{' mainprog '}';

    xacclambda : '['('&'|'=')?']' '(' 'qbit' acceleratorbuffer=id (',' typedparam) * ')' '{' mainprog '}';

    typedparam : type id;

    type : 'int' | 'double' | 'float' | 'std::vector<double>';

/***********************************************************************/


/* The main program */
mainprog
   : program
   ;

/* The actual program statements */
program
   : (line)+
   ;

line
   : statement+
   | comment
   ;

/* A program statement */
statement
   : instruction ';'
   | 'return' ';'
   ;

/* A program comment */
comment
   : COMMENT
   ;

instruction
   : inst_name=id  '(' (bits=bitsType) (',' params=explist)? (',' options=optionsMap)? ')'
   ;

bufferIndex
   : id ('[' INT ']')?
   ;

bitsType
   : bufferIndex (',' bufferIndex)*
   ;

optionsMap
   : '{' optionsType (',' optionsType)* '}'
   ;

optionsType
   : '{' key=string ',' value=exp '}'
   ;

/* A list of expressions */
explist
   : exp ( ',' exp )*
   ;

/* An expression */
exp
   : real
   | INT
   | 'pi'
   | id
   | exp '+' exp
   | exp '-' exp
   | exp '*' exp
   | exp '/' exp
   | '-'exp
   | exp '^' exp
   | '(' exp ')'
   | unaryop '(' exp ')'
   | string
   ;

/* unary operations */
unaryop
   : 'sin'
   | 'cos'
   | 'tan'
   | 'exp'
   | 'ln'
   | 'sqrt'
   ;

/* variable identity */
id
   : ID
   ;

/* real numbers */
real
   : REAL
   ;

/* strings are enclosed in quotes */
string
   : STRING
   ;

/* Tokens for the grammer */

/* Comment */
COMMENT
   : '#' ~ [\r\n]* EOL
   ;

/* id, ego, and super-ego */
ID
   : [a-z][A-Za-z0-9_]*
   | [A-Z][A-Za-z0-9_]*
   | [A-Z][A-Za-z]*
   ;

/* Keep it real...numbers */
REAL
   : INT ( '.' (INT) )
   ;

/* Non-negative integers */
INT
   : ('0'..'9')+
   ;

/* Strings include numbers and slashes */
STRING
   : '"' ~ ["]* '"'
   ;

/* Whitespaces, we skip'em */
WS
   : [ \t\r\n] -> skip
   ;

/* This is the end of the line, boys */
EOL
: '\r'? '\n'
;
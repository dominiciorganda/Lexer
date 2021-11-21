import java.util.*;
import java.util.stream.Collectors;

%%
%standalone
%line
%class SymTabs

%{

private List<String>identifiers = new ArrayList<>();
private List<String>separators = new ArrayList<>();
private List<String>operators = new ArrayList<>();
private List<String>keywords = new ArrayList<>();
private List<String>constants = new ArrayList<>();
private List<String>stringsLiterals = new ArrayList<>();
private List<String>numberLiterals = new ArrayList<>();

public void printList(List<String> list){
    for(String token:list){
        String type = "";
        if(stringsLiterals.contains(token)) type = "(String)";
        if(numberLiterals.contains(token)) type = "(Integer)";
        if(type.equals(""))   System.out.println("\t" + token);
        else    System.out.println("\t" + token + " " + type);
    }
}

%}

%eof{
    constants.addAll(stringsLiterals);
    constants.addAll(numberLiterals);

    System.out.println("Summary:");
    System.out.println("\tTokens " +( identifiers.size() + constants.size() + keywords.size() + operators.size()+separators.size()));
    System.out.println("\tIdentifiers  " + identifiers.size());
    System.out.println("\tConstants  " + constants.size());
    System.out.println("\tKeywords  " + keywords.size());
    System.out.println("\tOperators  " + operators.size());
    System.out.println();

    identifiers = identifiers.stream().distinct().sorted().collect(Collectors.toList());
    keywords = keywords.stream().distinct().sorted().collect(Collectors.toList());
    constants = constants.stream().distinct().sorted().collect(Collectors.toList());

    System.out.println("Identifiers:");
    printList(identifiers);

    System.out.println("Literals:");
    printList(constants);

    System.out.println("Keywords:");
    printList(keywords);

%eof}

ALPHA=[A-Za-z]
DIGIT=[0-9]
DIGITWITHOUTNULL=[1-9]
IDENTIFIER = {ALPHA}({ALPHA}|{DIGIT})*
NUMBER = [0] | {DIGITWITHOUTNULL} ({DIGIT})*
COMMENT = [//][//] ({ALPHA}|[ ]|{DIGIT})*
KEYWORDS = ("import"|"public"|"class"|"private"|"int"|"this"|"static"|"void"|"new"|"while"|"if")
STRING = [\"]({ALPHA}|{DIGIT}|[ ])*[\"]
OPERATOR = [!][=] | [=\+>]
SEPARATOR = [\.\(\)\[\]\;\{\}\,]
IGNORE = [\s\n\t]

%%
{COMMENT} {}
{STRING} {stringsLiterals.add(yytext());}
{KEYWORDS} {keywords.add(yytext());}
{IDENTIFIER} {identifiers.add(yytext());}
{NUMBER} {numberLiterals.add(yytext());}
{OPERATOR} {operators.add(yytext());}
{SEPARATOR} {separators.add(yytext());}
{IGNORE} {}
. {System.out.println("Lexical error on line " + (yyline+1) + " at " + yytext());} /* report lexical error */




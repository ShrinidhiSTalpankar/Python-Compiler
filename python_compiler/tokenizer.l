%{
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
//#include "symboltfunc.c"
//#include "calc3.h" 
#include "y.tab.h"
#include "stack.c"
//void yyerror(char *s);
STACK indent;
//STACK1 symbolstk;
STACK scope;
int pointer=0;
int counter=0;
int def_flag=0;
FILE* f;
FILE* icgf;
FILE* ofile;
%}
letter [A-Za-z]
digit [0-9]
nonzerodigit [1-9]
day [1-9]|(1[0-9])|(2[0-9])|30|31
month [1-9]|(1[0-2]) 
day1 "21st"|"1st"|("1"[0-9]"th")|"2nd"|"22nd"|"3rd"|"23rd"|("2"[4-8]"th")|([4-9]"th")|"20th"
day29 "29th"
day30 "30th"
day31 "31st"
month31 "January"|"March"|"May"|"July"|"August"|"October"|"December"
month30 "April"|"June"|"September"|"November"
month28 "February"
year ("19"[0-9][0-9])|("20"[0-1][0-7])
%% 

 
(\n)(\n)+                                               {
			                                   yyless(1);yylineno++;
			                                }

\n[ \t]*'''([^*])*'''                                       {
				                           int i;
								 yylineno++;
				                           
			                             
			                                   if(yytext[yyleng-4]=='\'')
                                                           {
                                                               printf("\nError in comment %s at line no %d",yytext,yylineno);
                                                               fprintf(f,"\nError in comment %s at line no %d",yytext,yylineno);
								for(i=1;i<strlen(yytext);i++)
					                   {
					                       if(*(yytext+i)=='\n')
						                  yylineno++;
					                   }
                                                           }
                                                           else     
                                                           {
                                                               int count=0;
                                                               int flag=0;
                                                               int j=0,num=0;
                                                               while(yytext[j]!='\'')
                                                                 j++;
                                                               for(i=j;i<yyleng-4;i++)
                                                               {
                                                                 if(yytext[i]!='\'')
                                                                   break;
                                                               }
                                                               num=i-j;  
                                                               if(num==6)
                                                               {
                                                                  yyless(6);
                                                             //     printf("\nMultiline comment\n");
                                                                  fprintf(f,"\nMultiline comment\n");
                                                               }
                                                               else
                                                               {    
                                                               for(j=i;j<yyleng-4;j++)
                                                               {
                                        
                                                                  if(yytext[j]=='\'')
                                                                  {
                                                                     count++;
                                                                     flag=1;
                                                                  }
                                                                  
                                                                  if(yytext[j]!='\'')
                                                                    {
                                                                     count=0;
                                                                     flag=0;
                                                                    }
                                                                  
                                                                  if(count==3 && flag==1)
                                                                  {
                                            
                                                                     yyless(j+1);
									for(i=1;i<j+1;i++)
									   {
							 
									       if(*(yytext+i)=='\n')
										  yylineno++;
									   }
                                                                     break;
                                                                  }      
                                                               }
								if(count!=3 || flag!=1)
									{for(i=1;i<strlen(yytext);i++)
					                   {
					                       if(*(yytext+i)=='\n')
						                  yylineno++;
					                   }}
                                                           //    printf("\nMultiline comment\n");
                                                               fprintf(f,"\nMultiline comment\n");
                                                              } 
                                                           }				
				                       }
			 
\n[ \t]*\"\"\"([^*])*\"\"\"                               {
				                           int i;yylineno++;
                                                           
                                                           if(yytext[yyleng-4]=='"')
                                                           {
                                                              printf("\nError in comment %s at line no %d",yytext,yylineno);
                                                              fprintf(f,"\nError in comment %s at line no %d",yytext,yylineno);
								for(i=1;i<strlen(yytext);i++)
					                   {
					                       if(*(yytext+i)=='\n')
						                  yylineno++;
					                   }
                                                           }
                                  
                                                           else     
                                                           {
                                                               int count=0;
                                                               int flag=0;
                                                               int j=0,num=0;
                                                               while(yytext[j]!='"')
                                                                 j++;
                                                               for(i=j;i<yyleng-4;i++)
                                                               {
                                                                 if(yytext[i]!='"')
                                                                   break;
                                                               }
                                                               num=i-j;  
                                                               if(num==6)
                                                               {
                                                                  yyless(6);
                                                         //         printf("\nMultiline comment\n");
                                                                  fprintf(f,"\nMultiline comment\n");
                                                               }
                                                               else
                                                               {    
                                                               for(j=i;j<yyleng-4;j++)
                                                               {
                                        
                                                                  if(yytext[j]=='"')
                                                                  {
                                                                     count++;
                                                                     flag=1;
                                                                  }
                                                                  
                                                                  if(yytext[j]!='"')
                                                                  {
                                                                     count=0;
                                                                     flag=0;
                                                                  }                                                                     
                                                                  if(count==3 && flag==1)
                                                                  {
                                            
                                                                     yyless(j+1);
									for(i=1;i<j+1;i++)
									   {
							 
									       if(*(yytext+i)=='\n')
										  yylineno++;
									   }
                                                                     break;
                                                                  }      
                                                               }
								if(count!=3 || flag!=1)
									{for(i=1;i<strlen(yytext);i++)
					                   {
					                       if(*(yytext+i)=='\n')
						                  yylineno++;
					                   }}
                                                       //        printf("\nMultiline comment\n");
                                                               fprintf(f,"\nMultiline comment\n");
                                                              } 
                                                           }				
				                       }

\n[ \t]*		                              { 
                                                           yylineno++;
                                                           if (yyleng == 1)
		                                           {
			                                          if (indent.size > 0)
			                                          {
			                                             pop(&indent);
			                                             if (peek(&indent) > yyleng && indent.size != 0)
				                                         yyless(0);
			                                             //printf("\nDEDENT");
			                                             fprintf(f,"\nDEDENT");
			                                             
			                                             // printf("\nEND_STATEMENT");
			                                          fprintf(f,"\nEND_STATEMENT");
			                                           
			                                             if( def_flag==1 && scope.size>0)
                                                                     { 
                                                                         pop(&scope);
			                                                 if (peek(&scope) > yyleng && scope.size != 0)
				                                              yyless(0);
				                                         if(isemptyy(&scope))
				                                         {
				                                              def_flag==0; 
				                                              pointer=0;
				                                         }   
				                                     }	
				                                      return DEDENT;
                                                                  }
			                                          //printf("\nEND_STATEMENT");
			                                          fprintf(f,"\nEND_STATEMENT");
			                                          return END_STATEMENT;
		                                           }
		                                           else
		                                           {
			                                         if (peek(&indent) < yyleng || indent.size == 0)
			                                         {
			                                           push(&indent, yyleng);
			                                           //printf ("\nINDENT");
			                                           fprintf(f,"\nINDENT");
			                                           
			                                           if(def_flag==1)
			                                               push(&scope,yyleng);
			                                               return INDENT;
                                                                 }
			                                        else if (peek(&indent) > yyleng && indent.size != 0)
			                                        {
			                                           pop(&indent);
			                                           if (peek(&indent) > yyleng && indent.size != 0)
				                                       yyless(0);
			                                           //printf ("\nDEDENT");
			                                           fprintf(f,"\nDEDENT");
			                                        
			                                           if( def_flag==1 && scope.size>0)
                                                                   { 
                                                                       pop(&scope);
			                                               if (peek(&scope) > yyleng && scope.size != 0)
				                                            yyless(0);
				                                       if(isemptyy(&scope))
				                                       {
				                                            def_flag==0;
				                                            pointer--;
				                                       }    
				                                   }
				                                      return DEDENT;
		                                                }
			                                       else
			                                       {
			                                           //printf("\nEND_STATEMENT");
			                                           fprintf(f,"\nEND_STATEMENT");
			                                           return END_STATEMENT;
			                                       }
		                                         }
		                                    }
		

 
<<EOF>>		                                    {
                                                       if (indent.size > 0)
                                                       {
                                                          pop(&indent);
                                                          //printf("\nDEDENT");
                                                          fprintf(f,"\nDEDENT"); 
                                                          return DEDENT;
                                                       }
                                                       yyterminate();
                                                    }
                
"if"                                                { 
                                                       //printf("\nIF");
                                                       fprintf(f,"\nIF");
                                                     //  addId(&symbolstk,yytext,"KEYWORD",pointer);
                                                       return IF;
                                                       
                                                    }

"else"                                              { 
                                                       //printf("\nELSE");
                                                       fprintf(f,"\nELSE");
                                                      //  addId(&symbolstk,yytext,"KEYWORD",pointer);
                                                       return ELSE; 
                                                      
                                                    }

"while"                                             {
                                                       //printf("\nWHILE");
                                                       fprintf(f,"\nWHILE");
                                                  //     addId(&symbolstk,yytext,"keyword",pointer);
                                                       return WHILE;
                                                       
                                                    }

"print"                                             {
                                                       //printf("\nPRINT");
                                                       fprintf(f,"\nPRINT");
                                                   //    addId(&symbolstk,yytext,"keyword",pointer);
                                                       return PRINT;
                                                     
                                                    }

"input"                                             {
                                                       //printf("\nINPUT");
                                                       fprintf(f,"\nINPUT");
                                                   //    addId(&symbolstk,yytext,"keyword",pointer);
                                                       return INPUT; 
                                                     
                                                    }

"break"                                             {
                                                       //printf("\nBREAK");
                                                       fprintf(f,"\nBREAK");
                                                   //    addId(&symbolstk,yytext,"keyword",pointer);
                                                       return BREAK; 
                                                       
                                                    }

"continue"                                          {
                                                       //printf("\nCONTINUE");
                                                       fprintf(f,"\nCONTINUE");
                                                     //  addId(&symbolstk,yytext,"keyword",pointer);
                                                       return CONTINUE; 
                                                       
                                                    }

"return"                                            {
                                                       //printf("\nRETURN");
                                                       fprintf(f,"\nRETURN");
                                                     //  addId(&symbolstk,yytext,"keyword",pointer);
                                                       return RETURN;
                                                       
                                                    }

"def"         					    {
						       //printf("\nDEF");
						       fprintf(f,"\nDEF");
						     //  addId(&symbolstk,yytext,"keyword",pointer);
						         def_flag=1;
                				       
                				       counter++;
                				       pointer=pointer+counter;
						       return DEF; 
						    
						     
                				    }

"elif"        					    {
						       //printf("\nELIF");
						       fprintf(f,"\nELIF");
						      
						     //  addId(&symbolstk,yytext,"keyword",pointer);
						        return ELIF;
						    }

"and"   				            {
						       //printf(" AND");
						       fprintf(f," AND");
						       
						    //   addId(&symbolstk,yytext,"keyword",pointer);
						        return AND;
						    }

"or"          					    {
						       //printf(" OR");
						       fprintf(f," OR");
						       
						    //   addId(&symbolstk,yytext,"keyword",pointer);
						       return OR; 
						    }

"not in"         					    {
						       //printf(" NOT_IN");
						       fprintf(f," NOT_IN");
						       
						    //   addId(&symbolstk,yytext,"keyword",pointer);
						       return NOT_IN; 
						    }

"not"         					    {
						       //printf(" NOT");
						       fprintf(f," NOT");
						       
						    //   addId(&symbolstk,yytext,"keyword",pointer);
						       return NOT; 
						    }

"in"            				    {
						       //printf(" IN");
						       fprintf(f," IN");
						      
						    //   addId(&symbolstk,yytext,"keyword",pointer);
						        return IN; 
						    }

\"(.)*\"              				    {
						       int fl=0,j=1;
                          			       for(j=1;j<strlen(yytext)-1;j++)
						       {
							 	if(*(yytext+j)=='"' && *(yytext+j-1)!='\\')
								{
								      printf("\nSyntax error: string %s\n at line no %d",yytext,yylineno);
					                              fprintf(f,"\nSyntax error: string %s\n at line no %d",yytext,yylineno);
                                                                      fl=1;break;
                                                                }
				                       }
				                       if(fl==0)
				                       {
    					                        //printf(" STRING");
    					                        fprintf(f," STRING");

								int i;
  						       /* for(i=0;i<yyleng;i++)
  						       {
  						          yylval.identifier[i] = yytext[i];
  						       } yylval.identifier[i] ='\0';*/
							yylval.expr.value=strdup(yytext);
    					                       
    					                 //       addId(&symbolstk,yytext,"string",pointer);
    					                        return STRING;
				                       } 
		                                    }

'(.)*' 					            {
						       int fl=0,j=1;
                          			       for(j=1;j<strlen(yytext)-1;j++)
						       {
								if(*(yytext+j)=='\'' && *(yytext+j-1)!='\\')
								{ 
								    printf("\nSyntax error: string %s\n at line no %d",yytext,yylineno);
					                            fprintf(f,"\nSyntax error: string %s\n at line no %d",yytext,yylineno);
                                                                    fl=1;break;
                                                                }
				                       }
				                       if(fl==0)
				                       {
    					                        //printf(" STRING");
    					                        fprintf(f," STRING"); 
    					                       int i;
  						       /* for(i=0;i<yyleng;i++)
  						       {
  						          yylval.identifier[i] = yytext[i];
  						       } yylval.identifier[i] ='\0';*/
							yylval.expr.value=strdup(yytext);
    					                   //     addId(&symbolstk,yytext,"string",pointer);
    					                        return STRING;
						       }
						    }



[-<>=+*/.%] 					   { 
                    				        //printf("%s",yytext);
                    				        fprintf(f,"%s",yytext);
                    				      
                    				    //    addId(&symbolstk,yytext,"operators",pointer);
                    				        return *yytext;
                    				      
                  				   }

({letter}|_)({letter}|_|{digit})*                  {
  						        //printf(" IDENTIFIER");
  						        fprintf(f," IDENTIFIER");
  						        int i;
  						       /* for(i=0;i<yyleng;i++)
  						       {
  						          yylval.identifier[i] = yytext[i];
  						       } yylval.identifier[i] ='\0';*/
							yylval.expr.value=strdup(yytext);
  						       
  						    //    addId(&symbolstk,yytext,"identifier",pointer);
  						         return IDENTIFIER;
  						   } 

{nonzerodigit}{digit}*|0			   {
 						        //printf(" DECIMALINTEGER");
 						        fprintf(f," DECIMALINTEGER"); 
 						        yylval.expr.value=strdup(yytext);
 						        
 						    //    addId(&symbolstk,yytext,"decimalint",pointer);
 						        return DECIMALINTEGER;
 						   }  

"["              			           {
						       //printf("%s" ,yytext);
						       fprintf(f,"%s",yytext);
						    //   addId(&symbolstk,yytext,"left square bracket",pointer);
						       return *yytext;
						       
						   }     

"]"              			           {
						       //printf("%s" ,yytext);
						       fprintf(f,"%s",yytext);
						    //   addId(&symbolstk,yytext,"right square bracket",pointer);
						        return *yytext;
						   }    

"("              			           {
						       //printf("%s" ,yytext);
						       fprintf(f,"%s",yytext); 
						       
						    //   addId(&symbolstk,yytext,"left parentheses",pointer);
						        return *yytext;
						   } 

")"              			           {
						       //printf("%s" ,yytext);
						       fprintf(f,"%s",yytext); 
						       
						    //   addId(&symbolstk,yytext,"right parentheses",pointer);
						        return *yytext;
						   } 

"{"              				   { 
						       //printf("%s" ,yytext);
						       fprintf(f,"%s",yytext);
						    
						    //   addId(&symbolstk,yytext,"left curly braces",pointer);
						       return *yytext;
						   }

"}"               				   {
						       //printf("%s" ,yytext);
						       fprintf(f,"%s",yytext); 
						        
						    //   addId(&symbolstk,yytext,"right curly braces",pointer);
						       return *yytext;
						   }   

 "\\n"|"\\t"        				   {
						       //printf(" ESCAPESEQ");
						       fprintf(f," ESCAPESEQ");
						       
						    //   addId(&symbolstk,yytext,"escapeseq",pointer); 
						       
						   }  

[ \t]+                                             ; /* ignore whitespace */


";"               				   {
							//printf(" SEMICOLON");
							fprintf(f," SEMICOLON ");
							
						//	addId(&symbolstk,yytext,"semicolon",pointer);
							  return *yytext; 
				  		   }

":"              				   {
							//printf(" COLON");
							fprintf(f," COLON");
							
						//	addId(&symbolstk,yytext,"colon",pointer);
							 return *yytext;
					           }

","              				  {
							//printf(" SEPARATOR");
							fprintf(f," SEPARATOR");
							
						//	addId(&symbolstk,yytext,"separator",pointer);
							 return *yytext; 
					  	  }
					  	  
">="							 {
							//printf(" GE");
							fprintf(f,"GE");
							 
						//	addId(&symbolstk,yytext,"GE",pointer);
							return GE; 
					  	  }
					  	  

"<="						 {
							//printf("LE");
							fprintf(f,"LE");
							
						//	addId(&symbolstk,yytext,"LE",pointer);
							 return LE; 
					  	  }
					  	  

"=="   							 {
							//printf("EQ");
							fprintf(f,"EQ");
						
						//	addId(&symbolstk,yytext,"EQ",pointer);
							 return EQ; 
					  	  }
					  	  
"!="|"<>"					 {
							//printf("NE");
							fprintf(f,"NE");
							  
						//	addId(&symbolstk,yytext,"NE",pointer);
							return NE;
					  	  }
					  	  

#(.)*$            				  {
							//printf("\nCOMMENT");
							fprintf(f,"\nCOMMENT");
						  }

. 						  {
							//yyerror("\nError:Unexpected character");
							printf("%s at line no:%d\n" ,yytext,yylineno);
						        fprintf(f,"\nError:Unexpected character %s at line no:%d\n" ,yytext,yylineno);
						  }

%%
int yywrap(void) {
  return 1;
}
/*
void yyerror(char *s) {
  fprintf(stdout,"%s\n",s);
  }
*/
int main(int argc,char *argv[])
{
   FILE *fh;
 
   initStack(&indent,1);
   initStack(&scope,3);
   fh=fopen(argv[1], "r");
   f=fopen("file.txt", "w");
   icgf=fopen("icg.txt","w");
   ofile=fopen("output.txt","w");
   yyin=fh;

   yyparse();
   fclose(yyin);
   fclose(f);
   fclose(icgf);
   fclose(ofile);
   //printSymbol_table(&symbolstk);
   return 0;
}

#INCLUDE "TOTVS.CH"                  
#INCLUDE "TBICONN.CH"

// Material ADVPL Fundamental                                  

User Function TipoVar()           

// OBS: O nome de uma variável tamanho máximo de 10 caracteres

Local cCaracter := ""  //Entre aspas duplas (") ou aspas simples (')
Local nNumerica := 0   //Variavel numerida pode ter dezoito dígitos, incluindo o ponto flutuante
Local lLogica   := .T. // .T. ou .Y. para verdadeiro e .F. ou .N. para falso
Local aArray    := {}        
Local dData     := "18/08/2013"



Return( NIL )
//*********************************************************************************************************************                                   

User Function EscopoVar()                                                                                                                                 


Local   cLocal   := "Não posso ser vista em outa Funct"
Static  cStatic  := "Parecida com a Private não consege mudar seu valor "
Private cPrivate := "Posso ser visto em qualquer lugar da Funct "
Public  _cPublic := "Pode ver em qualquer Lugar do Projeto"     

	ExVar() // Sub Função Linha Mista 

Return( NIL )
//*********************************************************************************************************************                                   

Static Function ExVar()

 Alert ( "Variavel cLocal não existe mais")
 Alert ( cStatic  )
 Alert ( cPrivate )
 Alert ( _cPublic  )
  

Return( NIL )

//*********************************************************************************************************************                                   

User Function Atribu()

//Local xVar

xVar := "Agora a Variavel é caracter.."

MsgAlert("Valor do Texto:" + xVar ) 

xVar := 22

Alert(xVar)

xVar := .T.

If xVar
	MsgInfo("A variavel e verdadeira")
Else
	Alert("A variavel e false")
EndIf

xVar := Date()

Alert("Data de hoje é: " + Dtoc(xVar) )

xVar := Nil

Alert("Variavel Nulo" + cValtoChar (xVar) )


Return( NIL )
//*********************************************************************************************************************                                   
User Function Operadores


// Operadores Matematicos
Local nAdicao        := 5 + 2 
Local nSubtracao     := 5 - 5 
Local nMultplicao    := 2 * 2
Local nDivisao       := 10/5 // OU
Local nDivMod        := mod(10,5) 
Local nExponenciacao := 5^2

// Operadores String
Local cContatenacao := "BOM "+"DIA"
Local cCont         := "BOA " - "TARDE"
Local cContido      := "SN"

//Exemplo do Contido
If cContido $ "S"
	Alert ("Achou a letra S")
EndIf                         

//Left( cusername , 15 ) $ GETMV( "MV_SUPERPP" ) 

// Operadores Relacionais

Private cMenor      := " > MAIOR QUE "
Private cMaior      := " < MENOR QUE "
Private cIgual      := " = IGUAL "
Private cIdentico   := " == EXATAMENTE IGUAL "
Private cMenorIgual := " >= MAIOR OU IGUAL "
Private cMaiorIgual := " <= MENOR OU IGUAL "
Private cDiferente  := " <> Diferente  ou != "

// Operadores Logicos

Private cAnd     := " .AND. "
Private cOr      := " .OR. "
Private cNegacao := " .NOT. ou ! "

// Operadores Especial

Private nSoma        := (5+2)*2 // () Agrupamento ou Funcão
Private aArray       := {"A"}  // [] Para acessar ele Elemento da Array aArray[1]
Private cApontamento := "-> Apontamento pod Referencia ex: SA1->A1_COD "
Private cMacro       := "Alert('Exemplo de macro')"

 &cMacro                  
               
//*********************************************************************************************************************                                    

// Tipos de Repeticão  
User Function RepFOR()

Local nX // Contador 

For nx := 1 to 10 

	MsgAlert("Contando: " + cValToChar (nX) )

Next nX                   

// Com Step
For nx := 10 to 1 step - 1

	MsgAlert("Contagem: " + cValToChar (nX) )

Next nX             

// Com Exit 
For nx := 1 to 10 

	If nx == 5  
		MsgAlert("Quando Chegar no " + cValToChar (nX) + " Sair do Loop: "  )
		Exit
	EndIf	
                                      
Next nX 

// Loop
 
For nx := 1 to 10 
	If nx == 5  
		MsgAlert("Quando Chegar no " + cValToChar(nX) + " Loop" )
	   Loop                                                      	   
	EndIf	                                                     

	If nx == 5  
		MsgAlert("Não pode entrar nesse If " )
	EndIf	      
                                      
Next nX 
                          
//*********************************************************************************************************************                                                                

User Function RepWhile()  

Local nCount := 1    
Local lRet   := .T.
Local nX 
Local PulaLinha := CHR(10)+CHR(13)

	If Select("SX2") == 0
		Prepare Environment Empresa '99' Filial '01' Tables 'SX5', 'SX2', 'SX6', 'SA1'
	EndIf
 
	While  nCount < 10

		MsgAlert("Contagem: " + cValToChar (nCount) )
				
		nCount++   
			
	EndDo 
 
	While lRet
	
		For nX := 10 To 1 Step -2
			MsgAlert("Contagem :"+ cValToChar(nX) )
		Next nX
		
		If MsgYesNo("Deseja Sair do While ?","Atenção!!" )	
			lRet := .F.
		EndIf				

	EndDo      
	
	// Exemplo com Tabela 
	dbSelectArea("SA1")      
	SA1->(dbSetOrder(1))
	SA1->(dbGoTop()) 
	
	lRet := .T.
	nCount := 1
		
	While ! SA1->( EOF() ) .AND. ( SA1->A1_FILIAL == xFilial("SA1") )
	
		MsgInfo("Codigo do Cliente :" + SA1->A1_COD + " " + SA1->A1_LOJA + " " + PulaLinha + SA1->A1_NOME  )               
		
		If nCount >= 5
			Exit
		EndIf 	
		
		nCount++   		
		
		SA1->(DbSkip())       
		
	EndDo	
	
	RESET ENVIRONMENT 

	

Return(Nil)	

//*********************************************************************************************************************    
User function IfCase()

Local dMes := Month(Date())

// Exemplo com IF
	
	If dMes <= 3
		MsgAlert(" Primeiro Trimestre EXEMPLO IF")		
	ElseIf dMes <= 6	
		MsgAlert(" Segundo Trimestre EXEMPLO IF")
	ElseIf dMes <= 9
		MsgAlert(" Terceiro Trimestre EXEMPLO IF")
   Else
		MsgAlert(" Terceiro Quarto Trimestre EXEMPLO IF")		
	EndIf 
	
	iif (dMes <= 9, MsgAlert( "EXEMPLO IIF .T." ), MsgAlert(" EXEMPLO IFF .F."))
	     
// Exemplo com Case
	
	Do Case	
		Case dMes <= 3
			MsgAlert(" Primeiro Trimestre EXEMPLO CASE")
		Case dMes <= 6	
			MsgAlert(" Segundo Trimestre EXEMPLO CASE")
		Case dMes <= 9
			MsgAlert(" Terceiro Trimestre EXEMPLO CASE")
	   OTHERWISE
			MsgAlert(" Quarto Trimestre EXEMPLO CASE")		
	EndCase
	
Return()                               

//*********************************************************************************************************************  

// Exemplo do AXCADASTRO ||         
User Function xCadastro()

dbSelectArea("SA1")
dbSetOrder(1)

AxCadastro("SA1","Cadastro de Cliente")

Return()
//*********************************************************************************************************************  
  
User Function fArray()

Local aArray  := {}
Local aArray1 := Array(6)
Local aArray2 := {}
Local aArray3 := {8,5,3,9,7,2,1,6,4}
Local nPos   

aArray1[1] := "Segunda Feira"
aArray1[2] := "Terça Feira"
aArray1[3] := "Quarta Feira"
aArray1[4] := "Quinta Feira"

AADD(aArray1,"Sexta Feira")

aArray := aArray1 // Não pode fazer essa atribuição

AADD(aArray1, "Sabado" )

MsgInfo( aArray1[8] )

aArray := aClone(aArray1) // Atribuição correta \\

AADD(aArray1, "Domingo" )    

nPos := ASCAN(aArray1,"Domingo")  // TRAZ a posição no array

aArray2 := AADD(aArray2,{{"MARIA" , 21},;
		   	  			    {"ALINE" , 19},;
					            {"MARCOS", 30},;
					            {"EVA"   , 15}})
                
aArray3 := aSort(aArray3)

aArray2 := aSort( aArray2,,,{ |x,y| x[2] >y[2] } ) // POR IDADE

aArray2 := aSort( aArray2,,,{ |x,y| x[1] <y[1] } ) // POR NOME DECRESENTE
					  

Return()
//*********************************************************************************************************************  

User Function BlocCod() 

bCodBloc := { |X| 2*X }
MsgAlert( EVAL(bCodBloc, 2) )  

//*********************************************************************************************************************  

User Function BlocCod1() 
x:=20
y:=24
bBloco:={|x,y|If(x>y, "O Valor de x e maior, ","O valor de y e maior")}
MsgAlert(Eval(bBloco,x,y))
Return()

//*********************************************************************************************************************  

User Function BlocCod2() 
Local bBloco:={|| 2 * 10}
Local nResult
nResult:=Eval(bBloco)
Alert(nResult)
Return()

//*********************************************************************************************************************  

User Function BlocCod2()
Local x,y,z
Local bBloco:={||x:=10,y:=20,z:=100}
//Executa uma lista de expressao e retorna o resultado
// da ultima expressao executada.
MsgAlert(Eval(bBloco))
Return()

//*********************************************************************************************************************  
// Fazer exemplo do campo B1_TE
// if( M->B1_TE <= "500", .T., Eval( { | | Help("",1,"F4_TIPO"), .F. } ) )   

// Fazer exemplo do campo B1_TS
// if( M->B1_TS > "500", .T., Eval( { ||Help("",1,"F4_TIPO"), .F. } ) )

// Acessar a tabela SF4 F4_TIPO mostrar o Help do campo \\


//*********************************************************************************************************************  

User Function Parametro()

// CLIAR UM PARAMETRO CHAMADO MV_TESTE

Local cPar := ""
                         
	If Select("SX2") == 0
		Prepare Environment Empresa '99' Filial '01' Tables 'SX5', 'SX2', 'SX6', 'SX3'
	EndIf

	cPar := GetMv( "MV_TESTE" )
	
	MsgAlert( cPar )	
	
	PutMv("MV_TESTE","HOROLD.LEITE")
	
	cPar := GetMv( "MV_TESTE" )

	MsgAlert( cPar )	


Return()
//*********************************************************************************************************************    
// FAZER O PONTO DE ENTRADA \\ M010INC
//*********************************************************************************************************************  

//mBrawser


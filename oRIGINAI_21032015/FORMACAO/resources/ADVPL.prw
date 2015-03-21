#include 'protheus.ch'
#include 'parmtype.ch'

User function ADVPL()
// Linha 

/* Comentario
de 
Bloco
*/

	nValor  := 0 // Numerico
	cVar    := "" // ' ' // Caracter
	lVar    := .T. // Logico
	dVar    := Data()  // Data
	bVar    := { || }  // Bloco
	aVar    := {}     // Array Vetor
	oVar    := Nil    // objeto
      
Return( NIL )
//----------------------------------------------------

User Function xVar()

	Local xVar
	xVar := "Agora a variavel é caracter..."

	MsgInfo(xVar)

	xVar := 22 + 10  // Agora é numerico

	MsgInfo(xVar)

	xVar := .T. // Agora é Logico
 
	If xVar    // Não é necessario colocar operador ex : If xVar == .T.
		MsgInfo("Verdadeiro")
	Else
		MsgInfo("Falso")
	EndIf

	xVar := Date() + 2 // Agora é Data

	MsgInfo("Hoje é :" + Dtoc(xVar))

	xVar := Nil

	MsgInfo("Valor nulo" + CValTochar(xVar) + "..." )

Return( NIL )
//----------------------------------------------------
User Function xEscopo()

	Static  cStatic := "Pode ser vista em outra FUNC, mas não pode alterar seu valor"
	Local   cLocal  := "Só pode ser vista na sua FUNC"
	Private cPrivate:= "Pode ser vista em outra FUNC"
	Public _cPublica := "Pode ser vista em qualquer parte do projeto"

	cVar := "Quando não informar o Escopo fica Private"

	xTSTEscopo()


	MsgAlert(cLocal,"Local")

Return( NIL )
//***************************************************
Static Function xTSTEscopo()

	MsgInfo(cStatic,"Static")

	MsgAlert(cPrivate,"Private")

	MsgStop(_cPublica,"Publica")
	Alert("XXXX")


Return( NIL )

//---------------------------------------------------------------------

User Function OpString()

	Local cTexto := "MARIA SILVA"
	Local cTexto2 := "TEXTO 02"
	Local nRet    := 0
	Local cVar    := "A"
	
MsgInfo(Replicate("*",20),"Replicate") // Replica qantidade de "?" caracter desejado
	
MsgInfo(left(cTexto,3),"left") // Retorna a quantudade de caracter a esqueda
	
MsgInfo(right(cTexto,6),"right") // Retorna a quantudade de caracter a Direita
	
MsgInfo(SubStr(cTexto,7,5),"SubStr") // Retorna a quantidade de caracter na posição informada
	
MsgInfo(Capital("maria da de ferreira" ),"Capital") // Retorno Maria Ferreira deixa a primeira letra maiuscula

	
	// Removendo espaços\\
	/*
	
	MsgInfo(cTexto +cTexto2,"Exemplo" )
	
	MsgInfo(Trim(cTexto) +cTexto2,"TRIM" ) // Remove os espaços da direita
	
	MsgInfo(RTrim(cTexto) +cTexto2,"RTRIM" )// Remove os espaços da direita
	 
	cTexto2 := Space(10) + cTexto2 // cria espaço em branco
	
	MsgInfo( cTexto +cTexto2, "Space" ) 
	
	MsgInfo(RTrim( cTexto) + LTrim(cTexto2), "LTrim" ) // Remove os espaços da Esquerda
	
	msgInfo(AllTrim(cTexto) + AllTrim(cTexto2),"ALLTRIM" ) // Remove espaço de  esquerdo e direito
	*/

	
/*	
	nRet := At(cVar,cTexto) // retorno da posição

If nRet > 0
	
	msgInfo(cVar + " esta: " + cValTochar(nRet) )
	        
	
Else	 
	msgInfo("Falso")
EndIf	




Return( NIL )
*/
//---------------------------------------------------------------------

User Function xConverte()

Local nValor := 10 + 30
Local dData  := Date()

Set Date To British   // Formato para data dd/mm/aaaa
 
// Para caracter
 
MsgInfo("Soma dos valores: "+ Str(nValor) + " #")

MsgInfo("Soma dos valores: "+ cValToChar(nValor) + " #" )

MsgInfo("Soma dos valores: "+ Transform(nValor,"@E 999.99"))

MsgInfo("Hoje é : " + Dtoc(dData) ) // DD/MM/AAAA

MsgInfo("Hoje é : " + Dtos(dData) ) // aaaammdd

// Converte para caracter com zero a Esquerda
MsgInfo("Soma dos valores: " + StrZero(nValor,6) ) 

MsgInfo(Val("40") + 30) // Converte para numerico


Return( NIL )

User Function xFor()


For nContador := 1 To 10 Step 1
	

	If nContador = 5
		Exit	
	EndIf 
	
	MsgInfo("Contador: " + cValToChar(nContador) )

Next nContador

Return( NIL )


//------------------------------------------------------------------

User Function xWhile()

Local nCount := 0
Local lWhile := .T.

dbSelectArea("SA1") // Abre a area da tabela
dbSelectArea("SB1") // Abre a area da tabela 
SA1->( dbSetOrder(1) )      // SIX  Ordena os registros por A1_COD + A1_LOJA
SA1->( dbGotop() )          // Inicio da Tabela

While ! SA1->( EOF() ) // EOF() FIM DE ARQUIVO

	MsgInfo(SA1->A1_COD + " " + CHR(13)+ SA1->A1_LOJA + " " + SA1->A1_NOME)
	
	SA1->( dbSkip() ) 
	
EndDo 
/*
While nCount <= 10

	RecLock("SA1",.T.) // Incluindo registro
	   // ADD Informação nos campos 
		 SA1->A1_FILIAL := xFilial("SA1")
		 SA1->A1_COD    := GETSXENUM("SA1","A1_COD")
		 SA1->A1_LOJA   := "01"	 
		 SA1->A1_NOME   := "SEU NOME" 
		 SA1->A1_NREDUZ := "NOME"		
		 SA1->A1_END    := "RUA SEI LÁ"	
	
	MsUnLock() // Destrava registro 
	
	ConfirmSX8() // Confirma o numero no SXE / SXF
	
   nCount++ 
   
EndDo

MsgInfo("Registros incluido !!!" )


*/
Return( NIL )


//------------------------------------------------------------------


User Function xIf()

dMes := Month(Date())
/*
If dMes <= 3 
	MsgInfo("1º Trimestre", "IF")
ElseIf dMes <= 6  
	MsgInfo("2º Trimestre", "IF")
ElseIf dMes <= 9
	MsgInfo("3º Trimestre", "IF")	
Else
	MsgInfo("4º Trimestre", "IF")
EndIf
*/
Do Case 
	Case dMes <= 3 
		MsgInfo("1º Trimestre", "IF")
	Case dMes <= 6 
		MsgInfo("2º Trimestre", "IF")
	Case dMes <= 9
		MsgInfo("3º Trimestre", "IF")	
	OTHERWISE
		MsgInfo("4º Trimestre", "IF")
EndCase


Return( NIL )


//------------------------------------------------------------------
User Function xArray()

Local aVar := {} 
Local aVar2 := Array(4)
Local bBloco := { | X,Y | ( X + 10 ) * Y }

Local nPOs  := 0

//msgInfo(eVal(bBloco,1,10))


/*
aVar2[1] := "DOMINGO"
aVar2[2] := "SEGUNDA FEIRA"
aVar2[3] := "TERÇA FEIRA"
aVar2[4] := "QUARTA FEIRA"
Aadd(aVar2, "QUINTA FEIRA")
AADD(AVAR2, "SEXTA FEIRA")

aVar  := aClone(aVar2)

Aadd(aVar, "SABADO")
/*
nPos := aScan(aVar,"QUARTA FEIRA") // Retorna a posição do elemento no array

MsgInfo(aVar[nPOs]) 

*/
aVar := {{"MARIA"  ,50,"F"},;
		  {"ADRIANA",20,"F"},;
		  {"JOSE"   ,32,"M"},;
		  {"ANDRE"  ,20,"M"},;
		  {"MARCIO" ,40,"M"}}

aVar := aSort(aVar,,, { | D , F | D[1] < F[1] .AND.  D[2] < F[2] })

nPos := aScan(aVar, { | x | x[1]== "JOSE" })

MsgInfo("Idade: "  + cValTochar(aVar[nPos,2]) )


		  
For x := 1 To Len(aVar)	
	  
	MsgInfo("Nome: "  + aVar[x,1] + Chr(13) + ;
            "Idade: " + cValTochar(aVar[x,2]) + Chr(13) + ; 
            "Sexo: "  + IIf(aVar[x,3] =="M","Masculino","Feminino"))
            
Next x

Return( NIL )



















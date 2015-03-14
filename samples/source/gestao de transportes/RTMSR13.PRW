#include "fivewin.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ RTMSR13  ³ Autor ³Gilson da Silva        ³ Data ³ 29/09/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Seleciona cheques vinculados a viagem para impressao       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGATMS                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RTMSR13()

Local aArea 		:= GetArea()  
Local cPerg 		:= "RTMR13" 
Local cViagem     := ""
Local cNumCtc     := ""  
Local cOrigem     := "" //Programa que chamou essa rotina  
Local cPrefixo    := TMA250GerPrf(cFilAnt)
Local aRotAux     := AClone(aRotina)

Local aCabec      := {}
Local aCabCom     := {}
Local cQuery      := ''
Local cAliasSEF   := ''
Local aList       := {}
Local aListCom    := {}

Private cCadastro := "Impressao de Cheques"
Private cMarca		:= ""     

If Substr(FunName(),1,7) == "TMSA144"
	cViagem	:= DTQ_VIAGEM   
	cOrigem  := "1" //Chamada da Rotina de Viagem
ElseIf FunName() == "TMSA250"  
	cViagem	:= DTY->DTY_VIAGEM 
	cNumCtc	:= DTY->DTY_NUMCTC
	cOrigem  := "2" //Chamada da Rotina de Contrato de Carreteiro
EndIf	 
 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                                          ³
//³ mv_par01      // Mostra Cheques ?  1=Ja Impressos   2=Nao Impressos    3=Ambos³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  
RTM13ChSx1(cPerg)
If Pergunte("RTMR13",.T.) 
	//Monta o Filtro para exibir somente os cheques da Viagem selecionada respeitando o parametro.
   cAliasSEF := GetNextAlias()
	cQuery := "SELECT SEF1.EF_BANCO,"
  	cQuery += "SEF1.EF_AGENCIA,"
  	cQuery += "  SEF1.EF_CONTA,"
  	cQuery += "  SEF1.EF_NUM,"
  	cQuery += "  SEF1.EF_VALOR,"  	
  	cQuery += "  SEF1.R_E_C_N_O_ "
  	cQuery += "FROM "+RetSqlName("SEF")+ " SEF1 "
  	cQuery += "WHERE SEF1.EF_FILIAL = '"+xFilial("SEF")+"' "

	If cOrigem == "1"  //Chamada da Rotina de Viagem
		cQuery += "AND SEF1.EF_NUM <> ' ' "
		cQuery += "AND SEF1.EF_TITULO = '"  + cViagem + "' "  //Imprime os cheques informados no Adiantamento
		If mv_par01 == 1 //Mostra somente os cheques que ja foram impressos
			cQuery += "AND SEF1.EF_IMPRESS = 'S' "
		ElseIf mv_par01 == 2	//Mostra somente os cheques que nao foram impressos
		   cQuery += "AND SEF1.EF_IMPRESS = ' ' "
		EndIf   
	Else	//Chamada da Rotina de Contrato de Carreteiro
		If mv_par01 == 1 //Mostra somente os cheques que ja foram impressos
			cQuery += "AND SEF1.EF_IMPRESS = 'S' "
		ElseIf mv_par01 == 2	//Mostra somente os cheques que nao foram impressos
		   cQuery += "AND SEF1.EF_IMPRESS = ' ' "
		EndIf 
		cQuery += " AND(SEF1.EF_TITULO = '"  + cNumCtc + "' OR "  //Imprime os cheques informados no pagamento do saldo
      	cQuery += "     SEF1.EF_TITULO = '"  + cViagem + "' )  "   //Imprime os cheques informados no Adiantamento
  		cQuery += " AND EXISTS"
  		cQuery += "  (SELECT SEF2.EF_NUM"
  		cQuery += "   FROM "+RetSqlName("SEF")+ " SEF2 "
  		cQuery += "   WHERE SEF2.EF_FILIAL   = SEF1.EF_FILIAL"
  		cQuery += "     AND SEF2.EF_BANCO    = SEF1.EF_BANCO"
  		cQuery += "     AND SEF2.EF_AGENCIA  = SEF1.EF_AGENCIA"
  		cQuery += "     AND SEF2.EF_CONTA    = SEF1.EF_CONTA"
  		cQuery += "     AND SEF2.EF_NUM      = SEF1.EF_NUM"
		If mv_par01 == 1 //Mostra somente os cheques que ja foram impressos  		
  			cQuery += "  AND SEF2.EF_IMPRESS = 'S'"
  		Elseif mv_par01 == 2	//Mostra somente os cheques que nao foram impressos  		
  			cQuery += "  AND SEF2.EF_IMPRESS = ' '"  		
		Endif
  		cQuery += " AND SEF2.D_E_L_E_T_ = ' ') "
	EndIf
	cQuery += " AND SEF1.D_E_L_E_T_ = ' ' "
	cQuery += " AND SEF1.EF_PREFIXO = '"+cPrefixo+"'"
	cQuery := ChangeQuery(cQuery)
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAliasSEF, .F., .T.)

	If (cAliasSEF)->(!Eof())
      aCabec  := {"Cheque","Valor"}
      aCabCom := {"Banco","Agencia","Conta"}
      While (cAliasSEF)->(!Eof())
		   Aadd(aList,{.F.,(cAliasSEF)->EF_NUM,TransForm((cAliasSEF)->EF_VALOR,PesqPict('SEF','EF_VALOR'))})
         Aadd(aListCom,{(cAliasSEF)->EF_BANCO,(cAliasSEF)->EF_AGENCIA,(cAliasSEF)->EF_CONTA,(cAliasSEF)->R_E_C_N_O_})
         (cAliasSEF)->(Dbskip())
      Enddo
		If TMSABrowse(aList,"Escolha",,,,.T.,aCabec,aCabCom,aListCom)
			U_RTM13Imp(aList,aListCom)
      EndIf
   Else
		MsgAlert("Não há dados disponiveis para impressao !!")
   Endif   
   (cAliasSEF)->(DbcloseArea())
EndIf  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura condicao anterior do arquivo                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RestArea(aArea)

aRotina := AClone(aRotAux)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RTM13IMP  ³ Autor ³ Gilson da Silva       ³ Data ³29.09.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Imprime os cheques selecionados para impressao.            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ RTM13IMP(aExp1,aExp2)                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nil                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/
User Function RTm13Imp(aList,aListCom)

Local cDesc1	:= "Este programa imprime os cheques com o valor liquido a pagar"
Local cDesc2	:= "das despesas vinculadas a Viagem."
Local cString	:= "SEF"				//alias do arquivo principal (Base)
Local aOrd		:= {}               //Ordem do Relatorio               
Local cChave   := ""
Local cValor   := ""

Private lLayOut:= .F. 	//--Variavel usada ImpCheq            
PRIVATE lComp  := .T.	//--Variavel usada ImpCheq  
Private lTeste := .F.	//--Variavel usada ImpCheq   
Private cBenef          //--Variavel usada ImpCheq    
PRIVATE nLinVlr := 0    //--Variavel usada ImpCheq  

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Define Variaveis Private(Basicas)						       	  ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Private aReturn	:= {"Zebrado", 1,"Administra‡„o", 2, 2, 1, "",1 }	
Private nomeprog	:= "RTMSR13"
Private nLastKey	:= 0

/* 
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿ 
³ Variaveis Utilizadas na funcao IMPR 					        ³ 
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/ 
Private TITULO		:= "Impressao de Cheques" 
Private nTamanho	:= "M"   
DbSelectArea( "SEF" )
Dbsetorder(1)
nPos := aScan(aList, {|aVal| aVal[1] == .T.})
If nPos > 0 // -- Existe algum Cheque Marcado
   Dbgoto(aListCom[nPos,4])
   cChave := SEF->(EF_FILIAL+EF_BANCO+EF_AGENCIA+EF_CONTA+EF_NUM)
	cValor:= Alltrim(Str(Val(aList[nPos,3])))
EndIf

If SEF->(Dbseek(cChave))
	ProcRegua( RecCount() )

	//-- Preparar a Impressora  chamar set printer e setdefault
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Envia controle para a funcao SETPRINT			    			   ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	wnrel:="RTMSR13"	//Nome Default do relatorio em Disco
	wnrel:=SetPrint(cString,wnrel,/*cPerg*/,@TITULO,cDesc1,cDesc2,,.F.,aOrd,,nTamanho,,.F.)

	IF nLastKey = 27                                           
		Return
	EndIF

	SetDefault(aReturn,cString)
	
	IF nLastKey = 27                                                 '
		Return
	EndIF

	RptStatus( {|lEnd| RTM13PRCH(@lEnd,wnRel,cString,cChave,cValor)}, TITULO ) 
EndIf	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RTM13PRCH ³ Autor ³ Gilson da Silva       ³ Data ³29.09.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Imprime os cheques selecionados para impressao.            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ RTM13PRCH(lExp1, wExp2, cExp3,cExp4,cExp5)                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nil                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/
Static Function RTM13PRCH(lEnd,WnRel,cString,cChave,cValor)  

Local aArea      := GetArea()
Local lFa480Bene := ExistBlock("FA480BENE")

While SEF->(EF_FILIAL+EF_BANCO+EF_AGENCIA+EF_CONTA+EF_NUM)==cChave .And. SEF->(!Eof())
   If Empty(SEF->EF_PREFIXO)
      SEF->(Dbskip())
      Loop
   Endif  
   
   IncProc()
	
	//-- Cancelado pelo operador.
	If lEnd
		Exit
	EndIf
             
	If lFa480Bene
		cBenef := ExecBlock("FA480BENE",.F.,.F.)
	Else
		cBenef := SEF->EF_BENEF
	Endif 
	
	SA6->(dbSetOrder(1))
	SA6->(dbSeek(xFilial("SA6") + SEF->(EF_BANCO+EF_AGENCIA+EF_CONTA)))

	ImpCheq(SEF->EF_BANCO,SEF->EF_AGENCIA,SEF->EF_CONTA,.F.,xFilial("SEF"),1) 
	dbSelectArea("SEF")
	dbSkip()
EndDo	    
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Termino do relatorio                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea( "SEF" )
dbSetOrder(1)
Set Device To Screen
If aReturn[5] = 1
	Set Printer To
	Commit
	ourspool(wnrel)
Endif
MS_FLUSH()
RestArea(aArea)  
Return
 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RTm13ChSx1³ Autor ³ Gilson da Silva       ³ Data ³29.09.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Ajusta o Grupo de Perguntas no dicionario SX1.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ RTm13ChSx1(cExp1)                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nil                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/
Static Function RTm13ChSx1 (cGrupSX1)
PutSx1(cGrupSX1, "01","Mostra Cheques ?","Mostra Cheques ?","Mostra Cheques ?","mv_ch1","N" ,1,0,2,"C","","","","","mv_par01","Já Impressos","Já Impressos","Já Impressos","","Não Impressos","Não Impressos","Não Impressos","Ambos","Ambos","Ambos") //"Mostra Cheques já Impressos ?"
Return	
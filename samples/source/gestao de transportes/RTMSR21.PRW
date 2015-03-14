#INCLUDE "protheus.ch"
#INCLUDE "RTMSR21.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RTMSR21  ³ Autor ³ Richard Anderson      ³ Data ³21.12.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao Nota de Debito/Credito                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ RTMSR21                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGATMS                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RTMSR21()

Local titulo  := STR0001 //"Nota de Débito/Crédito
Local cString := "DIH"
Local wnrel   := "RTMSR21"
Local cDesc1  := STR0002 //"Este programa ira imprimir a Nota de Débito/Crédito
Local cDesc2  := ""
Local cDesc3  := ""
Local tamanho := "P"
Local Limite  := 80
Local cPerg   := "RTMR21"
Local aOrd    := {}

Private aReturn  := {STR0003,1,STR0004,2, 2, 1, "",1 } //"Zebrado"###"Administracao"
Private nLastKey := 0

AjustaSX1(cPerg)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01            	// No.Nota de                         ³
//³ mv_par02            	// No.Nota Ate        	         	  ³
//³ mv_par03            	// Data Emissao de 	      		     ³
//³ mv_par04            	// Data Emissao Ate   		           ³
//³ mv_par05            	// Impressao / Reimpressao            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte(cPerg,.F.)

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)

If nLastKey = 27
	Set Filter To
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey = 27
	Set Filter To
	Return
Endif

RptStatus({|lEnd| RTMSR21Imp(@lEnd,wnRel,titulo,tamanho,Limite)},titulo)

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RTMSR21Imp³ Autor ³ Richard Anderson      ³ Data ³22.11.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Chamada do Relat¢rio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RTMSR21			                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RTMSR21Imp(lEnd,wnRel,titulo,tamanho,Limite)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local  nObs      := 0
Local  cObs      := ''
Local  cDados    := ''
Local  nLin      := 0, nI := 0, nX := 0
Local  cAliasQry := GetNextAlias()
Local  cQuery    := ''
Local  aAreaAtu  := GetArea()
Local  aStruDIH  := DIH->(dbStruct())
Local  cExtenso  := ''

SetRegua(DIH->(LastRec()))

cQuery := "SELECT DIH.*, DIH.R_E_C_N_O_ RECNODIH, DT6_SIGTRA, DT6_TIPTRA, DT6_CLIDEV, DT6_LOJDEV FROM "
cQuery += RetSqlName("DIH")+" DIH, "
cQuery += RetSqlName("DT6")+" DT6  "
cQuery += " WHERE DIH.DIH_FILIAL = '"+xFilial("DIH")+"'"
cQuery += "   AND DIH.DIH_NUMNDC BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
cQuery += "   AND DIH.DIH_DATEMI BETWEEN '"+Dtos(mv_par03)+"' AND '"+Dtos(mv_par04)+"'"
cQuery += "   AND DIH.DIH_STATUS IN ( '1', '2' )"
cQuery += "   AND DIH.DIH_FIMP   IN "+Iif(mv_par05 == 1,"( ' ', '0')","( '1' )")
cQuery += "   AND DIH.D_E_L_E_T_ = ' '" 
cQuery += "   AND DT6.DT6_FILIAL = '"+xFilial('DT6')+"'"
cQuery += "   AND DT6.DT6_FILDOC = DIH_FILDOC"
cQuery += "   AND DT6.DT6_DOC    = DIH_DOC"
cQuery += "   AND DT6.DT6_SERIE  = DIH_SERIE"
cQuery += "   AND DT6.D_E_L_E_T_ = ' '"
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry)
For nX := 1 To Len(aStruDIH)
	If aStruDIH[nX][2]<>"C"
		TcSetField(cAliasQry,aStruDIH[nX][1],aStruDIH[nX][2],aStruDIH[nX][3],aStruDIH[nX][4])
	EndIf
Next nX
While (cAliasQry)->(!Eof())

	IncRegua()
	
	If Interrupcao(@lEnd)
		Exit
	EndIf
	
	nLin := 1
	@ nLin,00 PSay AvalImp(Limite)+__PrtLogo()
	nLin += 1
	
	@ nLin,00 PSay Padl(AllTrim(SM0->M0_CIDCOB)+', '+AllTrim(Str(Day((cAliasQry)->DIH_DATEMI),2))+" de "+AllTrim(MesExtenso(Month((cAliasQry)->DIH_DATEMI)))+" de "+Str(Year((cAliasQry)->DIH_DATEMI),4),Limite)
	nLin += 3
	@ nLin,02 PSay 'A'
	nLin += 1
	aDadCli := TMSDadCli((cAliasQry)->DT6_CLIDEV,(cAliasQry)->DT6_LOJDEV)
	For nI := 1 To Len(aDadCli)
		@ nLin,02 PSay aDadCli[nI]
		nLin+= 1
	Next nI
	nLin += 4
	@ nLin,00 PSay Padc('N O T A  D E  '+Iif((cAliasQry)->DIH_TIPNDC == '1','D E B I T O','C R E D I T O'),Limite)
	nLin += 1
	@ nLin,00 PSay Padc('--------------'+Iif((cAliasQry)->DIH_TIPNDC == '1','-----------','-------------'),Limite)
	nLin += 3
	@ nLin,02 PSay 'Referente Docto.: '+Iif((cAliasQry)->DT6_TIPTRA == '4',Transform((cAliasQry)->(DT6_SIGTRA+DIH_SERIE+DIH_DOC),"@R AA.XXX.XXXXXX"),Transform((cAliasQry)->(DIH_FILDOC+DIH_DOC+DIH_SERIE),"@R 99 999999-XXX"))
	nLin += 3
	@ nLin,02 PSay 'Motivo..........: '
	cObs   := StrTran(MsMM((cAliasQry)->DIH_CODMOT,80),Chr(10),'')
	cDados := ''
	For nObs := 1 To Len(cObs)
		If Substr(cObs,nObs,1) == Chr(13)
			@ nLin,20 PSay cDados
			nObs   += 1
			nLin   += 1
			cDados := ''
			//-- Verifica linhas em branco
			While Substr(cObs,nObs,1) == Chr(13)
				nObs += 1
			EndDo
		EndIf
		cDados += Substr(cObs,nObs,1)
	Next nObs
	nLin += 3
	@ nLin,02 PSay 'Valor...........: '+Transform((cAliasQry)->DIH_VALOR,"@E 99,999,999.99")
	nLin += 1
	cExtenso := Extenso((cAliasQry)->DIH_VALOR)
	@ nLin,18 PSay '('+Padr(cExtenso,60,'*')+' )'
	nLin += 1
	@ nLin,18 PSay '('+Replicate('*',60)+' )'
	nLin += 3
	@ nLin,02 PSay 'Sem outro motivo para o momento, subscrevemo-nos.'
	nLin += 3
	@ nLin,00 PSay Padl('Atenciosamente',67)

	//-- Atualiza flag de impressao
	DIH->(dbGoTo((cAliasQry)->RECNODIH))
	RecLock('DIH',.F.)
	DIH->DIH_FIMP := '1' //-- Impresso
	MsUnLock()
		
	(cAliasQry)->(dbSkip())
	
EndDo	

(cAliasQry)->(dbCloseArea())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se em disco, desvia para Spool                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

RestArea(aAreaAtu)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³AjustaSX1  ³ Autor ³Richard Anderson    ³ Data ³ 22/11/2006 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Inclui Perguntas no SX1                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³RTMSR21                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function AjustaSX1(cPerg)

SX1->(DbSetOrder(1))
If Sx1->(dbSeek(cPerg)) 
	If Alltrim(SX1->X1_PERGUNT)==Alltrim(SX1->X1_PERSPA)
		While SX1->(!Eof()) .And. Alltrim(SX1->X1_GRUPO)==Alltrim(cPerg)
			Reclock("SX1",.F.)
			DBDelete()
			SX1->(MsUnlock())
			SX1->(dbSkip())
		EndDo
	EndIf
EndIf

PutSx1( cPerg,"01","No.Nota de ?        ","¿De No.Nota ?       ","No.Nota de ?        ","mv_ch1","C",6,0,0,"G","","DIH","","","mv_par01")
PutSx1( cPerg,"02","No.Nota Até ?       ","¿A No.Nota  ?       ","No.Nota Até ?       ","mv_ch2","C",6,0,0,"G","","DIH","","","mv_par02")
PutSx1( cPerg,"03","Data Emissão de ?   ","¿De Fecha Emission ?","Data Emissão de ?   ","mv_ch3","D",8,0,0,"G","",""   ,"","","mv_par03")
PutSx1( cPerg,"04","Data Emissão Até ?  ","¿A Fecha Emission  ?","Data Emissão Até ?  ","mv_ch4","D",8,0,0,"G","",""   ,"","","mv_par04")
PutSx1( cPerg,"05","Impressão/Reimpre.? ","¿Impresion/Nuev.Imp.?","Impressão/Reimpre.? ","mv_ch9","N",1,0,0,"C","",""   ,"","","mv_par05","Impressão","Impresion","Impressão","","Reimpressão","Nueva Impresion","Reimpressão")

Return

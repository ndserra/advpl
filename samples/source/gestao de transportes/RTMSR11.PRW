#INCLUDE "rtmsr11.ch"
#DEFINE CHRCOMP If(aReturn[4]==1,15,18)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³RTMSR11   ³ Autor ³ Henry Fila            ³ Data ³22.01.2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Contrato de carreteiro por periodo                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RTMSR11()

Local Titulo  := STR0001 //"Contrato de Coleta e Entrega"
Local cDesc1  := STR0002 //"Este programa ira emitir o Contrato de Coleta e Entrega"
Local cDesc2  := STR0003 //"de acordo com os parametros escolhidos pelo usuario"
Local cDesc3  := ""
Local cString := "DTY"  // Alias utilizado na Filtragem
Local lDic    := .F. // Habilita/Desabilita Dicionario
Local lComp   := .T. // Habilita/Desabilita o Formato Comprimido/Expandido
Local lFiltro := .T. // Habilita/Desabilita o Filtro
Local wnrel   := "RTMSR11"  // Nome do Arquivo utilizado no Spool
Local nomeprog:= "RTMSR11"  // nome do programa

Private Tamanho := "M" // P/M/G
Private Limite  := 132 // 80/132/220
Private cPerg   := "RTMR11"  // Pergunta do Relatorio
Private aReturn := { STR0004, 1,STR0005, 1, 2, 1, "",1 }  //"Zebrado"###"Administrativo"
						//[1] Reservado para Formulario
						//[2] Reservado para N§ de Vias
						//[3] Destinatario
						//[4] Formato => 1-Comprimido 2-Normal
						//[5] Midia   => 1-Disco 2-Impressora
						//[6] Porta ou Arquivo 1-LPT1... 4-COM1...
						//[7] Expressao do Filtro
						//[8] Ordem a ser selecionada
						//[9]..[10]..[n] Campos a Processar (se houver)

Private lEnd    := .F.// Controle de cancelamento do relatorio
Private m_pag   := 1  // Contador de Paginas
Private nLastKey:= 0  // Controla o cancelamento da SetPrint e SetDefault

//Chamada do relatorio padrao
If FindFunction("TRepInUse") .And. TRepInUse()
	TMSR600()
	Return (.T.)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica as Perguntas Seleciondas                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(cPerg,.F.)

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,lDic,,lComp,Tamanho,lFiltro)
If ( nLastKey==27 )
	dbSelectArea(cString)
	dbSetOrder(1)
	Set Filter to
	Return
Endif

	SetDefault(aReturn,cString)
	
If ( nLastKey==27 )
	dbSelectArea(cString)
	dbSetOrder(1)
	Set Filter to
	Return
Endif

RptStatus({|lEnd| ImpDet(@lEnd,wnRel,cString,nomeprog,Titulo)},Titulo)
	
Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³ ImpDet   ³ Autor ³ Henry Fila            ³ Data ³24.01.2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Controle de Fluxo do Relatorio.                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ImpDet(lEnd,wnrel,cString,nomeprog,Titulo)

Local aStruDTY  := {}
Local aStruDTQ  := {}
Local cIndDTY   := ""
Local cQuery    := "" 
Local cAliasDTY := "DTY"
Local cAliasSA2 := "SA2"                    
Local cAliasDTQ := "DTQ"                    

Local cCabec1   := STR0006    //"NUMERO       :"
Local cCabec2   := STR0010    //"PROPRIETARIO :"                                                                                                                       

Local cNumCtc   := ""

Local lQuery    := .F.
Local lCtc      := .F.

Local nValLiq := 0
Local nQtdVol := 0
Local nQtdDoc := 0
Local nPeso   := 0
Local nValFre := 0
Local nIrrf   := 0
Local nSest   := 0
Local nInss   := 0
Local nTotLiq := 0
Local nX      :=0


Local li        := 100 // Contador de Linhas

dbSelectArea(cString)
dbSetOrder(1)
cIndDTY := CriaTrab(NIL,.F.)


lQuery   := .T.

aStruDTY := DTY->(dbStruct())
aStruDTQ := DTQ->(dbStruct())		

cAliasDTY := "TRBQRY"
cAliasSA1 := cAliasDTY
cAliasDTQ := cAliasDTY

cQuery := "SELECT DTY.*,DTQ.*,A2_NOME"		
		
cQuery += " FROM "+ RetSqlName("DTY")+ " DTY ,"
cQuery += RetSqlName("SA2")+ " SA2, "
cQuery += RetSqlName("DTQ")+ " DTQ "		
cQuery += " WHERE "
		
cQuery += "DTY.DTY_FILIAL = '"+xFilial("DTY") + "' AND "
cQuery += "DTY.DTY_DATCTC >='"+Dtos(mv_par01)+"' AND "
cQuery += "DTY.DTY_DATCTC <='"+Dtos(mv_par02)+"' AND "		
cQuery += "DTY.DTY_CODFOR >='"+mv_par03+"' AND "
cQuery += "DTY.DTY_CODFOR <='"+mv_par05+"' AND "		
cQuery += "DTY.DTY_LOJFOR >='"+mv_par04+"' AND "
cQuery += "DTY.DTY_LOJFOR <='"+mv_par06+"' AND "		
cQuery += "DTY.D_E_L_E_T_ = ' ' AND "                

cQuery += "DTQ.DTQ_FILIAL = '"+xFilial("DTQ") + "' AND "
cQuery += "DTQ.DTQ_VIAGEM = DTY.DTY_VIAGEM AND "
cQuery += "DTQ.DTQ_SERTMS IN ( '1', '3' )  AND "
cQuery += "DTQ.D_E_L_E_T_ = ' ' AND "
		
cQuery += "SA2.A2_FILIAL  = '"+xFilial("SA2")+"' AND "
cQuery += "SA2.A2_COD     = DTY.DTY_CODFOR AND "
cQuery += "SA2.A2_LOJA    = DTY.DTY_LOJFOR AND "
cQuery += "SA2.D_E_L_E_T_ = ' ' "  
				
cQuery += "ORDER BY "+SqlOrder(DTY->(IndexKey()))
			
cQuery := ChangeQuery(cQuery)
dBUseArea(.t.,"TOPCONN",TCGENQRY(,,cQuery),"TRBQRY",.f.,.t.)		

For nX := 1 To Len(aStruDTY)
	If aStruDTY[nX][2]!="C"
		TcSetField(cAliasDTY,aStruDTY[nX][1],aStruDTY[nX][2],aStruDTY[nX][3],aStruDTY[nX][4])
  	EndIf
Next nX			

For nX := 1 To Len(aStruDTQ)
	If aStruDTQ[nX][2]!="C"
		TcSetField(cAliasDTY,aStruDTQ[nX][1],aStruDTQ[nX][2],aStruDTQ[nX][3],aStruDTQ[nX][4])
  	EndIf
Next nX			

dbGotop()


//          1         2         3         4         5         6         7         8         9         10        11        12
//01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234
//Data     Serv.Transp.  Tipo Transp. Viagem    Qtd.Vol. Qtd.Doc.         Peso    Frete     IRRF SEST/SENAT     INSS   Vl.Liquido
//99/99/99 X-XXXXXXXXXXX X-XXXXXXXXXX 99 999999   99.999   99.999 999,999.9999 9,999.99 9,999.99 999,999.99 9,999.99   999,999.99

While (cAliasDTY)->(!Eof())

	cNumCtc := (cAliasDTY)->DTY_NUMCTC
	lCtc    := .F.
	
	If lEnd
		@ Prow()+1,001 PSAY STR0007 //"CANCELADO PELO OPERADOR"
		Exit
	EndIf

	If !lQuery
		(cAliasSA2)->(dbSetOrder(1))
		(cAliasSA2)->(MsSeek(xFilial("SA2")+(cAliasDTY)->DTY_CODFOR+(cAliasDTY)->DTY_LOJFOR))
	Endif

	cCabec1   := STR0006+(cAliasDTY)->DTY_NUMCTC    //"NUMERO       :"
	cCabec2   := STR0010+(cAliasDTY)->DTY_CODFOR+"-"	+(cAliasDTY)->DTY_LOJFOR+" "+(cAliasSA2)->A2_NOME

	nQtdVol := 0
	nQtdDoc := 0
	nPeso   := 0
	nValFre := 0
	nIrrf   := 0
	nSest   := 0
	nInss   := 0
	nTotLiq := 0

	If ( li > 53 )
		li := cabec(Titulo,cCabec1,cCabec2,nomeprog,Tamanho,CHRCOMP)
		li++
	Endif

	@ li,000 PSAY STR0008	 //"Data     Serv.Transp.  Tipo Transp. Viagem    Qtd.Vol. Qtd.Doc.       Peso    Frete     IRRF SEST/SENAT     INSS Vl.Liquido"
	li++
	@ li,000 PSAY __PrtThinLine()			
	li++

	While (cAliasDTY)->DTY_NUMCTC == cNumCtc

		If !lQuery
			(cAliasDTQ)->(dbSetOrder(2))
			(cAliasDTQ)->(MsSeek(xFilial("DTQ")+(cAliasDTY)->DTY_FILORI+(cAliasDTY)->DTY_VIAGEM))
		Endif			
	
		nValLiq := 0
		
		If (cAliasDTQ)->DTQ_SERTMS == "1" .Or. (cAliasDTQ)->DTQ_SERTMS == "3"

			lCtc := .T.
		
			nValLiq := (cAliasDTY)->DTY_VALFRE - (cAliasDTY)->DTY_IRRF - (cAliasDTY)->DTY_SEST - (cAliasDTY)->DTY_INSS
		
			@ li,000 PSAY (cAliasDTQ)->DTQ_DATENC	   
			@ li,009 PSAY (cAliasDTQ)->DTQ_SERTMS+"-"+SubStr(TmsValField("DTQ->DTQ_SERTMS",.F.,"DTQ_SERTMS"),1,10)
			@ li,023 PSAY (cAliasDTQ)->DTQ_TIPTRA+"-"+SubStr(TmsValField("DTQ->DTQ_TIPTRA",.F.,"DTQ_TIPTRA"),1,10)
			@ li,036 PSAY (cAliasDTY)->DTY_FILORI+" "+(cAliasDTY)->DTY_VIAGEM
			@ li,047 PSAY (cAliasDTY)->DTY_QTDVOL Picture "@E 999.999"
			@ li,057 PSAY (cAliasDTY)->DTY_QTDDOC Picture "@E 99.999"
			@ li,064 PSAY (cAliasDTY)->DTY_PESO   Picture "@E 999,999.9999"
			@ li,077 PSAY (cAliasDTY)->DTY_VALFRE Picture "@E 9,999.99"
			@ li,086 PSAY (cAliasDTY)->DTY_IRRF   Picture "@E 9,999.99"			
			@ li,095 PSAY (cAliasDTY)->DTY_SEST   Picture "@E 999,999.99"			
			@ li,106 PSAY (cAliasDTY)->DTY_INSS   Picture "@E 9,999.99"						
			@ li,117 PSAY nValLiq                 Picture "@E 999,999.99"									
			
			nQtdVol += (cAliasDTY)->DTY_QTDVOL
			nQtdDoc += (cAliasDTY)->DTY_QTDDOC
			nPeso   += (cAliasDTY)->DTY_PESO
			nValFre += (cAliasDTY)->DTY_VALFRE
			nIrrf   += (cAliasDTY)->DTY_IRRF
			nSest   += (cAliasDTY)->DTY_SEST
			nInss   += (cAliasDTY)->DTY_INSS
			nTotLiq += nValLiq
			
			li++
		Endif

		(cAliasDTY)->(dbSkip())
		
	Enddo		

	@ li,000 PSAY __PrtThinLine()			
	li++
	@ li,000 PSAY STR0011 //"TOTAL =>"
	@ li,047 PSAY nQtdVol Picture "@E 999.999"
	@ li,057 PSAY nQtdDoc Picture "@E 99.999"
	@ li,064 PSAY nPeso   Picture "@E 999,999.9999"
	@ li,077 PSAY nValFre Picture "@E 9,999.99"
	@ li,086 PSAY nIrrf   Picture "@E 9,999.99"			
	@ li,095 PSAY nSest   Picture "@E 999,999.99"			
	@ li,106 PSAY nInss   Picture "@E 9,999.99"						
	@ li,117 PSAY nTotLiq Picture "@E 999,999.99"									
	li++
	
	If !lCtc
		@ li,000 PSAY STR0009 //"NAO EXISTEM VIAGENS PARA ESTE CONTRATO"
		li++
	Endif	

	li := 100

Enddo

If lQuery
	dbSelectArea("TRBQRY")
	dbClearFilter()
	dbCloseArea()
Else	     
	dbSelectArea("DU1")
	Ferase(cIndDTY+OrdBagExt())
	RetIndex("DU1")
Endif


dbSelectArea("DU1")
dbSetOrder(1)	

Set Device To Screen
Set Printer To
If ( aReturn[5] = 1 )
	dbCommitAll()
	OurSpool(wnrel)
Endif
MS_FLUSH()

Return

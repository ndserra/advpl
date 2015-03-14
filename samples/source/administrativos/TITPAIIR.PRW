#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRegeraPCC บAutor  ณMicrosiga           บ Data ณ  20/02/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TitPaiIR

Local cMens 	:= ""

//USO APENAS PARA TOP
#IFDEF TOP
	If TcSrvType() == "AS/400"
		HELP("GrvTitPai",1,"HELP","Atualizacao Financeiro","Esta rotina somente estแ disponํvel para uso com TOPCONNECT",1,0)
		Return .F.
	Endif	
#ELSE
	HELP("GrvTitPai",1,"HELP","Atualizacao Financeiro","Esta rotina somente estแ disponํvel para uso com TOPCONNECT",1,0)
	Return .F.
#ENDIF

cMens := "Atencao !" + CRLF +;
"Esta rotina ira verificar o preenchimento do campo E2_TITPAI para titulos de IR gerados na Emissao."

If Aviso("Atualizacao de Dados", cMens,{"Ok","Cancela"},3) <> 1
	Aviso("Atualizacao de Dados","Atencao !" + CRLF +"A opera็ใo foi abortada pelo operador.",{"Ok"})
	Break 
Else
	Processa({|| GrvTitPai()},,"Avaliando Tํtulos ") 
	Aviso("Atualizacao de Dados","Atencao !" + CRLF +;
	"Ap๓s a corre็ใo da base tire essa rotina do menu de opera็๕es.",{"Ok"})
     
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRefazPCC บAutor  ณMicrosiga           บ Data ณ  26/02/08    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GrvTitPai
Local nRecTitP := 0    	//registro do tํtulo principal que estแ sendo analisado
Local cPrefixo			// armazena o prefixo do tํtulo principal que estแ sendo pesquisado
Local cNumero			// armazena o numero do tํtulo principal que estแ sendo pesquisado
Local cFornece			// armazena o fornecedor do tํtulo principal que estแ sendo pesquisado
Local cValorTot			// armazena o valor total do tํtulo principal que estแ sendo pesquisado
Local nRecFound := 0    
Local nMoeda
Local cTitPai      		//Chave do titulo pai
Local lGeraIR := .T.
Local nHdlArqIR     
Local cParcIR := ""


Local lExistIR := .F.
Local cMVIRNAT := Alltrim(GetMv("MV_IRF",.F.,"IRF"))
Local nCount	:= 0

PRIVATE nIR := 0
//PRIVATE dBaixa	 := CTOD("")			//essa variแvel ้ utilizada pela fun็ใo de gera็ใo de impostos, precisa existir.
PRIVATE nDescont := 0
PRIVATE aDadosRef := Array(7)
PRIVATE aDadosRet := Array(7)
PRIVATE aRecnosSE2 := ()
PRIVATE nOldValPgto := 0
PRIVATE dBxDt_Venc
PRIVATE dOldData := CTOD("")
PRIVATE nOldDescont := 0
PRIVATE nOldMulta := 0
PRIVATE nOldJuros := 0
PRIVATE nOldIRRF := 0
PRIVATE nOldPIS := 0
PRIVATE nOldCofins := 0
PRIVATE nOldCSLL := 0
PRIVATE ABAIXASE5 := {} // Utilizada na fun็ใo SEL080BAIXA
PRIVATE nValPgto  := 0

DbSelectArea("SE2")
DbSetOrder(1)
DbGoTop()    

If !File("RegIR.TXT")
	nHdlArqIR := MSFCREATE( "RegIR.TXT" )                    
Else 
    nHdlArqIR := fOpen("RegIR.TXT",2)
    fSeek(nHdlArqIR,0,2)
EndIf

fWrite(nHdlArqIR, Chr(13)+Chr(10) + DToC(Date()) +" "+ Time() + Chr(13)+Chr(10))
fWrite(nHdlArqIR, "PREFIXO  NUM  PARCELA  TIPO  FORNECEDOR  LOJA" + Chr(13)+Chr(10))

ProcRegua(SE2->(RecCount()))
While !SE2->(Eof()) 
	IncProc("Processando...")
	
    //1. se o tํtulo nใo ้ de imposto
	If !(SE2->E2_TIPO $ MVISS+"/"+MVTAXA+"/"+MVTXA+"/"+MVINSS+"/"+"SES"+"/"+"AB-") .AND. SE2->E2_EMISSAO > CToD("01/01/2008")

		//2. verifica se o tํtulo tem natureza que calcula IR
		If NatCalcIR(SE2->E2_NATUREZ, SE2->E2_FORNECE, @lGeraIR)

		 	// 3. grava qual ้ o registro e as informa็๕es do tํtulo que serใo utilizadas na pesquisa dos impostos.
		 	nCount++
		 	lExistIR 	:= .F.
		 	nRecTitP 	:= SE2->(Recno())
		 	cPrefixo 	:= SE2->E2_PREFIXO
		 	cNumero  	:= SE2->E2_NUM
		 	cFornece 	:= SE2->E2_FORNECE
		 	nMoeda	 	:= SE2->E2_MOEDA
		 	cValorTot	:= SE2->E2_VALOR
		 	cTitPai  	:= SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECEDOR+E2_LOJA)
		 	cParcIR 	:= SE2->E2_PARCIR
			nIR 		:= SE2->E2_IRRF	 	
            
	 		// 3.3. Efetua o tratamento da variavel lGeraIR 
	 		// de acordo com o valor de nIR para desconsiderar zeros (0.00)
	 		lGeraIR 	:= IIF(nIR == 0	, .F., lGeraIR)
	 		
	 		// 4.varre o arquivo em busca de tํtulos de impostos que correspondem com o titulo pai.
			GeraTRB(cPrefixo, cNumero, cParcIR)    
	
			While !TRB->(Eof())
				//5.se encontrou t๚itulos de IR relacionado ao principal   	
				If (TRB->E2_TIPO $ MVTAXA)						
					
					//VERIFICAR A AMARRACAO DO TITULO DE IMPOSTO COM O TITULO PAI	    		    
	    		    If 	( TRB->E2_PARCELA == cParcIR .AND. ;
	    		    	(ROUND(TRB->E2_VALOR,2) == ROUND(nIR,2)) .AND. ;
	    		    	(Trim(TRB->E2_NATUREZ) == cMVIRNAT .OR. '"'+Trim(TRB->E2_NATUREZ)+'"' == cMVIRNAT))

						nRecFound := TRB->RECN
																
						SE2->(DbGoTo(nRecFound)) 
	       				
	       				// 6.2. AVALIAR SE O E2_TITPAI DO IMPOSTO Jม ESTม PREENCHIDO
	       				// PARA EVITAR UMA "VINCULAวรO" INDEVIDA
	       				IF SE2->(FieldPos("E2_TITPAI")) > 0 .AND. !Empty(SE2->E2_TITPAI)			
		       				IF !(SE2->(FieldPos("E2_TITPAI")) > 0) 
								cLinha := SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECEDOR+E2_LOJA)+"| Titulo desconsiderado por nao ter campo E2_TITPAI na tabela SE2."
							ElseIf !Empty(SE2->E2_TITPAI)
								cLinha := SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECEDOR+E2_LOJA)+"| Titulo desconsiderado por estar com o campo E2_TITPAI preenchido: "+SE2->E2_TITPAI
							EndIf
							fWrite(nHdlArqIR, cLinha + Chr(13)+Chr(10))
	       					TRB->(DbSkip())
	       					Loop
	       				ENDIF

	       				//7.preenche E2_TITPAI      		
						If SE2->(FieldPos("E2_TITPAI")) > 0 .AND. Empty(SE2->E2_TITPAI)
							RecLock("SE2",.F.)
							SE2->E2_TITPAI := cTitPai				
							SE2->(MsUnLock())
							cLinha := SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECEDOR+E2_LOJA) + "| cTitPai gravado corretamente : "+SE2->E2_TITPAI
							fWrite(nHdlArqIR, cLinha + Chr(13)+Chr(10))							
						EndIf
					    
                       	SE2->(DbGoto(nRecFound))						
					EndIf		
				EndIf
				TRB->(DbSkip())
			EndDo
			TRB->(dbCloseArea())
			
			DbSelectArea("SE2")
    	   	//8.retorna para o registro armazenado do passo 3 para que possa continuar a validacao
       		SE2->(DbGoTo(nRecTitP))
   		EndIf
	EndIf
    SE2->(DbSkip())
EndDo
fClose(nHdlArqIR)

SE2->(dbCloseArea())

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNatCalcImpบAutor  ณMicrosiga           บ Data ณ  20/02/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

//Fun็ใo para verificar se a natureza calcula imposto
STATIC Function NatCalcIR(cNat, cFornece,lGeraIR)
cRet := .F.           
lGeraIR := .F.

SED->(DbSetOrder(1)) 
SA2->(DbSetOrder(1))
If SED->(DbSeek(xFilial("SED")+cNat)) .and. SA2->(DbSeek(xFilial("SA2")+cFornece))
	If (SED->ED_CALCIRF == "S")
		cRet := .T.		
		lGeraIR := .T.
	EndIf
EndIf

Return cRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGeraTRB   บAutor  ณMicrosiga           บ Data ณ  20/02/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GeraTRB(cPrefixo, cNumero, cParcIR)

Local cQuery 	:= ""
Local aFields 	:= {}
Local nX		:= 0

cQuery := "SELECT E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_VALOR, E2_NATUREZ, "
cQuery += " R_E_C_N_O_ RECN  FROM " + RetSQLname("SE2")
cQuery += " WHERE E2_FILIAL  = '"  + xFilial("SE2") + "'"
cQuery += " AND E2_PREFIXO = '" + cPrefixo +"'"
cQuery += " AND E2_NUM = '" + cNumero +"'" 
cQuery += " AND E2_PARCELA = '" + cParcIR +"'" 
cQuery += " AND E2_TIPO IN ('" + MVTAXA + "')"
cQuery += " AND D_E_L_E_T_ <> '*'"
cQuery += " ORDER BY E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_FORNECE, E2_LOJA, D_E_L_E_T_"
cQuery := ChangeQuery(cQuery)

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "TRB", .F., .T.)
DbSelectArea("TRB")
DbGotop()

AADD(aFields,{"E2_VALOR","N",18,2})

For nX := 1 To Len(aFields)
	TcSetField("TRB",aFields[nX][1],aFields[nX][2],aFields[nX][3],aFields[nX][4])
Next nX

Return

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

User Function RegeraPCC

Local cMens 	:= ""
Local lPCCBaixa := SuperGetMv("MV_BX10925",.T.,"2") == "1"

//USO APENAS PARA TOP
#IFDEF TOP
	If TcSrvType() == "AS/400"
		HELP("REGERARPCC",1,"HELP","Atualizacao Financeiro","Esta rotina somente estแ disponํvel para uso com TOPCONNECT",1,0)
		Return .F.
	Endif	
#ELSE
	HELP("REGERARPCC",1,"HELP","Atualizacao Financeiro","Esta rotina somente estแ disponํvel para uso com TOPCONNECT",1,0)
	Return .F.
#ENDIF

cMens := "Atencao !" + CRLF +;
"Esta rotina ira corrigir a base de dados do contas a pagar" + CRLF +; 
"caso possua registros de impostos apagados erroneamente." + CRLF +; 
"pela rotina de exclusใo de border๔s." + CRLF +;
"Somente para reten็ใo pela baixa."

IF !lPCCBaixa
	RETURN
ENDIF

If Aviso("Atualizacao de Dados", cMens,{"Ok","Cancela"},3) <> 1
	Aviso("Atualizacao de Dados","Atencao !" + CRLF +"A opera็ใo foi abortada pelo operador.",{"Ok"})
	Break 
Else
	Processa({|| RefazPCC()},,"Avaliando Tํtulos ") 
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

Static Function RefazPCC
Local nRecTitP := 0    	//registro do tํtulo principal que estแ sendo analisado
Local cPrefixo			// armazena o prefixo do tํtulo principal que estแ sendo pesquisado
Local cNumero			// armazena o numero do tํtulo principal que estแ sendo pesquisado
Local cFornece			// armazena o fornecedor do tํtulo principal que estแ sendo pesquisado
Local cValorTot			// armazena o valor total do tํtulo principal que estแ sendo pesquisado
Local nRecFound := 0    
Local nMoeda
Local cTitPai      
Local lGeraPIS := .T.
Local lGeraCof := .T.
Local lGeraCSLL := .T.	 
Local nHdlArqPCC     
Local cParcPis := ""
Local cParcCof := ""
Local cParcCsl := ""
Local nVlMinImp := GetNewPar("MV_VL10925",5000)
Local nBaseRet	:= 0
Local nRecSE5	:= 0
Local lExistPIS := .F.
Local lExistCOF := .F.
Local lExistCSLL:= .F.
Local cMVPISNAT := Alltrim(GetMv("MV_PISNAT",.F.,"PIS"))
Local cMVCOFINS := Alltrim(GetMv("MV_COFINS",.F.,"COFINS"))
Local cMVCSLL	:= Alltrim(GetMv("MV_CSLL"	,.F.,"CSLL"))
Local nCount	:= 0

PRIVATE nPis := 0
PRIVATE nCofins := 0
PRIVATE nCSLL := 0
PRIVATE dBaixa	 := CTOD("")			//essa variแvel ้ utilizada pela fun็ใo de gera็ใo de impostos, precisa existir.
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
PRIVATE ABAIXASE5 := {} // UTILIZADA NA FUNวรO SEL080BAIXA
PRIVATE nValPgto  := 0

DbSelectArea("SE2")
DbSetOrder(1)
DbGoTop()    

If !File("RegPCC.TXT")
	nHdlArqPCC := MSFCREATE( "RegPCC.TXT" )                    
Else 
    nHdlArqPCC := fOpen("RegPCC.TXT",2)
    fSeek(nHdlArqPCC,0,2)
EndIf

fWrite(nHdlArqPCC, Chr(13)+Chr(10) + DToC(Date()) +" "+ Time() + Chr(13)+Chr(10))
fWrite(nHdlArqPCC, "PREFIXO  NUM  PARCELA  TIPO  FORNECEDOR  LOJA" + Chr(13)+Chr(10))

ProcRegua(SE2->(RecCount()))
While !SE2->(Eof()) 
	IncProc("Processando...")
	
    //1. se o tํtulo nใo ้ de imposto, e tem border๔, verifica se tem amarra็๕es // tํtulo principal 
	If !(SE2->E2_TIPO $ MVISS+"/"+MVTAXA+"/"+MVTXA+"/"+MVINSS+"/"+"SES"+"/"+"AB-") .and. Trim(SE2->E2_NUMBOR) <> "" 

		//2. verifica se o tํtulo tem natureza que calcula imposto 
		If NatCalcImp(SE2->E2_NATUREZ, SE2->E2_FORNECE, @lGeraPis, @lGeraCof, @lGeraCsLL)

		 	// 3. grava qual ้ o registro e as informa็๕es do tํtulo que serใo utilizadas na pesquisa dos impostos.
		 	nCount++
		 	lExistPIS 	:= .F.
			lExistCOF 	:= .F.
			lExistCSL 	:= .F.
		 	nRecTitP 	:= SE2->(Recno())
		 	cPrefixo 	:= SE2->E2_PREFIXO
		 	cNumero  	:= SE2->E2_NUM
		 	cFornece 	:= SE2->E2_FORNECE
		 	nMoeda	 	:= SE2->E2_MOEDA
		 	cValorTot	:= SE2->E2_VALOR
		 	cTitPai  	:= SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECEDOR+E2_LOJA)
		 	cParcPis 	:= SE2->E2_PARCPIS
		 	cParcCof 	:= SE2->E2_PARCCOF
		 	cParcCsl 	:= SE2->E2_PARCSLL
		 	SEA->(DbSetOrder(1))
    		SEA->(DBSeek(xFilial("SEA")+SE2->E2_NUMBOR))
    		dBaixa := SEA->EA_DATABOR

            // 3.1. Nใo podem ser considerados titulos com baixas parciais, dado a complexidade
            IF FaParcBx()
				// Gravacao de log para falar que o titulo foi desconsiderado por ter baixas parciais
				cLinha := cTitPai + "| Titulo desconsiderado por possuir baixas parciais."
				fWrite(nHdlArqPCC, cLinha + Chr(13)+Chr(10))
               	SE2->(DbSkip())
               	Loop
            ENDIF

            // 3.2. Verificar se possui uma baixa do tipo PCC no SE5
			// Caso possua, jแ atualiza o conteudo de nPis, nCofins e nCSLL
            IF !FaPCCBaixa(@nRecSE5)
            	// Gravacao de log para falar que o titulo foi desconsiderado por nใo ter baixas
				cLinha := cTitPai + "| Titulo desconsiderado por nใo ser o retentor pela baixa do Border๔ - motivo PCC"
				fWrite(nHdlArqPCC, cLinha + Chr(13)+Chr(10))
            	SE2->(DbSkip())
            	Loop
            ENDIF
            
	 		// 3.3. Efetua o tratamento das variaveis lGeraPis, lGeraCof, lGeraCSLL 
	 		// de acordo com o valor de nPis, nCofins e nCSLL, para desconsiderar zeros (0.00)
	 		lGeraPis 	:= IIF(nPis == 0	, .F., lGeraPis)
	 		lGeraCof 	:= IIF(nCofins == 0	, .F., lGeraCof)
	 		lGeraCsLL 	:= IIF(nCSLL == 0	, .F., lGeraCsLL)
	 		
	 		// 4.varre o arquivo em busca de tํtulos de impostos apagados.
	 		//colocar os nomes dos campos para acelerar a busca
			GeraTRB(cPrefixo, cNumero)    
	
			While !TRB->(Eof())
				//5.se encontrou t๚itulos de impostos relacionado ao principal que jแ estejam apagados  
				
				If (TRB->E2_TIPO $ MVISS+"/"+MVTAXA+"/"+MVTXA+"/"+MVINSS+"/"+"SES")						
	    		    // 6. Somente pode ser considerada a parcela quando o cliente utiliza o conceito de baixa ๚nica
	    		    // pois pode-se ter vแrias baixas parciais, e cada baixa parcial gerar o seu conjunto de tํtulos
	    		    // de reten็ใo.
	    		    
	    		    // 6.1. Deve ser considerado se o campo parcela do imposto no titulo pai estแ vazio, devido
	    		    // a situa็ใo de erro detectada na base do cliente na qual o titulo de PCC foi gerado, mas
	    		    // nใo foi preenchido o campo de parcela no PAI. 
	    		    If 	( (TRB->E2_PARCELA == cParcPis .OR. Empty(cParcPis)) .AND. ROUND(TRB->E2_VALOR,2) == ROUND(nPis,2)		.AND. Trim(TRB->E2_NATUREZ) == cMVPISNAT) .OR.;
		    		    ( (TRB->E2_PARCELA == cParcCof .OR. Empty(cParcCof)) .AND. ROUND(TRB->E2_VALOR,2) == ROUND(nCofins,2) 	.AND. Trim(TRB->E2_NATUREZ) == cMVCOFINS) .OR.;
						( (TRB->E2_PARCELA == cParcCsl .OR. Empty(cParcCsl)) .AND. ROUND(TRB->E2_VALOR,2) == ROUND(nCSLL,2)		.AND. Trim(TRB->E2_NATUREZ) == cMVCSLL)

						nRecFound := TRB->RECN
																
						SE2->(DbGoTo(nRecFound)) 
	       				
	       				// 6.2. COMO O CAMPO PARCELA DO TITULO PAI PODE ESTAR EM BRANCO
	       				// DEVERม SER AVALIADO SE O E2_TITPAI DO IMPOSTO Jม ESTม PREENCHIDO
	       				// PARA EVITAR UMA "VINCULAวรO" INDEVIDA
	       				IF SE2->(FieldPos("E2_TITPAI")) > 0 .AND. !Empty(SE2->E2_TITPAI) .AND.;
	       					ALLTRIM(SE2->E2_TITPAI) != ALLTRIM(cTitPai)
	       					TRB->(DbSkip())
	       					Loop
	       				ENDIF

	       				//7.preenche E2_TITPAI      		
						If SE2->(FieldPos("E2_TITPAI")) > 0 .AND. Empty(SE2->E2_TITPAI)
							RecLock("SE2",.F.)
							SE2->E2_TITPAI := cTitPai				
							SE2->(MsUnLock())
						EndIf
					    
   						// 7.1. ATUALIZA O CAMPO PARCELA E NO TITULO PAI
   						// PARA GARANTIR A PARIDADE COM AS INFORMACOES ENCONTRADAS
   						
                       	SE2->(DbGoto(nRecTitP))
                       	RECLOCK("SE2",.F.)
						If AllTrim(TRB->E2_NATUREZ) == cMVPISNAT
							lGeraPIS 		:= .F.
							lExistPIS 		:= .T.
							SE2->E2_PARCPIS := TRB->E2_PARCELA
						ElseIf AllTrim(TRB->E2_NATUREZ) == cMVCOFINS
							lGeraCof 		:= .F.
							lExistCof 		:= .T.
							SE2->E2_PARCCOF := TRB->E2_PARCELA
						ElseIf AllTrim(TRB->E2_NATUREZ) == cMVCSLL
							lGeraCSLL 		:= .F.						
							lExistCSLL 		:= .T.
							SE2->E2_PARCSLL := TRB->E2_PARCELA
						EndIf
                       	MSUNLOCK()
                       	SE2->(DbGoto(nRecFound))						
					EndIf		
				EndIf
				TRB->(DbSkip())
			EndDo
			TRB->(dbCloseArea())
			
			If lGeraPis .or. lGeraCof .or. lGeraCSLL

				DbSelectArea("SE2")
				SE2->(DbGoTo(nRecTitP))
				nBaseRet := SE2->(E2_VALOR+E2_PIS+E2_COFINS+E2_CSLL+E2_IRRF+E2_INSS+E2_ISS)+Iif(SE2->(FieldPos("E2_SEST")) > 0, SE2->E2_SEST, 0)
                
				//8. fAPCCDATA() -> fA080DATA() / fAPCCToMes() -> f080TotMes()
				IF nBaseRet >= nVlMinImp .OR. (fAPCCData() .AND. fAPCCTotMes(dBaixa,.T.,.F.,.T.,.F.))
				   
					//8.1. Para reten็ใo pela baixa
					FGrvImpPcc(	If(lGeraPis ,nPis   ,0),;
								If(lGeraCof ,nCofins,0),;
								If(lGeraCSLL,nCsll  ,0),nRecTitP,.F.,,,"FINA240",nMoeda)
								
					cLinha := cTitPai + " - Gerou " + If(lGeraPis ," PIS ","") + If(lGeraCof ," COFINS ","") + If(lGeraCSLL ," CSLL ","")
					fWrite(nHdlArqPCC, cLinha + Chr(13)+Chr(10))
					
					// Atualizar os dados de retencao do titulo principal
					SE2->(DbGoTo(nRecTitP))
					RecLock("SE2",.F.)
						IF lGeraPis 
							SE2->E2_VRETPIS := nPis
							SE2->E2_PRETPIS := "4"
						ENDIF
	                    
						IF lGeraCof
							SE2->E2_VRETCOF := nCofins
							SE2->E2_PRETCOF := "4"
						ENDIF
						
						IF lGeraCSLL
							SE2->E2_VRETCSL := nCsll
							SE2->E2_PRETCSL := "4"
						ENDIF
					MsUnLock()

				Endif

			ElseIF !lExistPIS .OR. !lExistCOF .OR. !lExistCSL 
				 // Se nใo gerar os impostos, limpar os campos de PIS/COFINS/CSLL e Parcelas
				SE2->(DbGoTo(nRecTitP))
				RecLock("SE2",.F.)
				IF !lExistPIS	
					SE2->E2_VRETPIS := 0.00
					SE2->E2_PRETPIS := "1"
					SE2->E2_PARCPIS := ""
					SE2->E2_PIS		:= nPis
				ENDIF
				IF !lExistCOF
					SE2->E2_VRETCOF := 0.00
					SE2->E2_PRETCOF := "1"
					SE2->E2_PARCCOF := ""
					SE2->E2_COFINS  := nCofins
				ENDIF
				IF !lExistCSLL 
					SE2->E2_VRETCSL := 0.00
					SE2->E2_PRETCSL := "1"
					SE2->E2_PARCSLL := ""
					SE2->E2_CSLL	:= nCsll
				ENDIF
				MsUnLock()
			EndIf
			
			DbSelectArea("SE2")
    	   	//8.retorna para o registro armazenado do passo 3 para que possa continuar a validacao
       		SE2->(DbGoTo(nRecTitP))
   		EndIf
	EndIf
    SE2->(DbSkip())
EndDo
fClose(nHdlArqPCC)

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
STATIC Function NatCalcImp(cNat, cFornece,lGeraCSLL, lGeraCof, lGeraPIS)
cRet := .F.

SED->(DbSetOrder(1)) 
SA2->(DbSetOrder(1))
If SED->(DbSeek(xFilial("SED")+cNat)) .and. SA2->(DbSeek(xFilial("SA2")+cFornece))
	If (SED->ED_CALCCSL == "S" .and. SA2->A2_RECCSLL == "2").or.;
	   (SED->ED_CALCCOF == "S" .and. SA2->A2_RECCOFI == "2").or.;
	   (SED->ED_CALCPIS == "S" .and. SA2->A2_RECPIS  == "2")
	
			cRet := .T.
				
			If SED->ED_CALCCSL == "S" .and. SA2->A2_RECCSLL == "2" // JROBERTO - ESTAVA SA2->A2_RECCSLL== "1" (CORRETO "2")
				lGeraCSLL:= .T.
			Else 
				lGeraCSLL:= .F.
			EndIf

			If SED->ED_CALCCOF == "S" .and. SA2->A2_RECCOFI == "2" // JROBERTO - ESTAVA SA2->A2_RECCOFI== "1" (CORRETO "2")
				lGeraCof := .T.
			Else
				lGeraCof := .F.
			EndIf

			If SED->ED_CALCPIS == "S" .and. SA2->A2_RECPIS  == "2"  // JROBERTO - ESTAVA SA2->A2_RECPIS== "1" (CORRETO "2")
				lGeraPIS := .T.
			Else
				lGeraPIS := .F.
			EndIf

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

Static Function GeraTRB(cPrefixo, cNumero) 

Local cQuery 	:= ""
Local aFields 	:= {}
Local nX		:= 0

cQuery := "SELECT E2_TIPO, E2_PARCELA, E2_VALOR, E2_NATUREZ, "
cQuery += " R_E_C_N_O_ RECN  FROM " + RetSQLname("SE2")
cQuery += " WHERE E2_FILIAL  = '"  + xFilial("SE2") + "'"
cQuery += " AND E2_PREFIXO = '" + cPrefixo +"'"
cQuery += " AND E2_NUM = '" + cNumero +"'" 
cQuery += " AND E2_TIPO IN ('" + MVISS + "','" + MVTAXA + "','" + MVTXA + "','" + MVINSS +"','SES')"
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

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfAPCCDATA บAutor  ณMicrosiga           บ Data ณ  20/02/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

STATIC FUNCTION fAPCCDATA()

LOCAL lRet := .T.

IF dBaixa < SE2->E2_EMISSAO
	lRet := .F.
Endif

RETURN lRet
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfAPCCToMesบAutor  ณMicrosiga           บ Data ณ  20/02/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

STATIC FUNCTION fAPCCTotMes(dReferencia,lCalcRet,lCalcPA,lSE2,lAltData) 

Local aAreaSE2  := SE2->( GetArea() ) 
Local aRecnos   := {}      
Local dDataIni  := FirstDay( dReferencia )   
Local dDataFim  := LastDay( dReferencia ) 
Local nVlMinImp := GetNewPar("MV_VL10925",5000)
Local nValorPg := 0
Local nValTit := 0
Local nVlrTit := 0
Local lSest := SE2->(FieldPos("E2_SEST"))	> 0  //Verifica campo de SEST
Local cModRetPIS := GetNewPar( "MV_RT10925", "1" ) 
Local lContrRet := !Empty( SE2->( FieldPos( "E2_VRETPIS" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_VRETCOF" ) ) ) .And. ; 
				 !Empty( SE2->( FieldPos( "E2_VRETCSL" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_PRETPIS" ) ) ) .And. ;
				 !Empty( SE2->( FieldPos( "E2_PRETCOF" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_PRETCSL" ) ) )
//Considero juros multa ou desconto na base do imposto.
// 1 = Considera valores juros multa ou desconto                    
// 2 = Nao considera valores juros multa ou desconto
Local lJurMulDes := (SuperGetMv("MV_IMPBAIX",.t.,"1") == "1")
Local lAltValor := STR(nValPgto,17,2) != STR(nOldValPgto,17,2)
//Controla o Pis Cofins e Csll na baixa
Local lPCCBaixa := SuperGetMv("MV_BX10925",.T.,"2") == "1"  .and. (!Empty( SE5->( FieldPos( "E5_VRETPIS" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_VRETCOF" ) ) ) .And. ; 
				 !Empty( SE5->( FieldPos( "E5_VRETCSL" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETPIS" ) ) ) .And. ;
				 !Empty( SE5->( FieldPos( "E5_PRETCOF" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETCSL" ) ) ) .And. ;
				 !Empty( SE2->( FieldPos( "E2_SEQBX"   ) ) ) .And. !Empty( SFQ->( FieldPos( "FQ_SEQDES"  ) ) ) )

Local nValOutImp := 0

Local cModTot   := GetNewPar( "MV_MT10925", "1" ) 

Local lBaseSE2 := SuperGetMv("MV_BS10925",.T.,"1") == "1"  .and. ;
						(	!Empty( SE1->( FieldPos( "E1_BASEPIS" ) ) ) .And.;
							!Empty( SE1->( FieldPos( "E1_BASECOF" ) ) ) .And. ; 
							!Empty( SE1->( FieldPos( "E1_BASECSL" ) ) ) .And. ; 
							!Empty( SE2->( FieldPos( "E2_BASEPIS" ) ) ) .And.;
							!Empty( SE2->( FieldPos( "E2_BASECOF" ) ) ) .And. ; 
							!Empty( SE2->( FieldPos( "E2_BASECSL" ) ) )	)

Local nProp := 1
Local nProp2 := 1
Local nBaseRet := 0  //Base de retencao
Local nSE2Reg := SE2->(RECNO())
Local lFa080PCC	:= ExistBlock("FA080PCC")

Local lIrfMp232 := !Empty( SA2->( FieldPos( "A2_CALCIRF" ) ) ) .and. SA2->A2_CALCIRF == "2" .and. ;
				 !Empty( SE2->( FieldPos( "E2_VRETIRF" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_PRETIRF" ) ) ) .And. ;
				 !Empty( SE5->( FieldPos( "E5_VRETIRF" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETIRF" ) ) )

//1-Cria NCC/NDF referente a diferenca de impostos entre emitidos (SE2) e retidos (SE5)
//2-Nao Cria NCC/NDF, ou seja, controla a diferenca num proximo titulo
//3-Nao Controla
Local cNccRet  := SuperGetMv("MV_NCCRET",.F.,"1")

Local nVlMinIrf := 0

Local cChaveTit := SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)

Local nX := 0 
Local lTodasFil := ExistBlock("MT103FRT")
Local aFil10925 := {}
Local cFilAtu	:= SM0->M0_CODFIL
Local aArea		:= GetArea()

Local aFor10925	:= {}
Local lVerForLj	:= ExistBlock("F080LOJA")
Local cQuery    := "" 	
Local nLoop		:= 0
Local aValorBx := {}
Local lPendPA  := .F.
Local lPaComp  := .F.
Local lAbatPA  := .F.                                          
Local lAltBxVal := .F.

// Considera baixas que geram ou nao movimento bancario.
// 1 = Somente os motivos que geram movimento bancario
// 2 = Considera todos os motivos de baixa.
Local lMotBxMBco  := (SuperGetMv("MV_MB10925",.t.,"2") == "1")
Local lCalcIssBx := !Empty( SE5->( FieldPos( "E5_VRETISS" ) ) ) .and. !Empty( SE2->( FieldPos( "E2_SEQBX"   ) ) ) .and. ;
							!Empty( SE2->( FieldPos( "E2_TRETISS" ) ) ) .and. GetNewPar("MV_MRETISS","1") == "2"  //Retencao do ISS pela emissao (1) ou baixa (2)

Local lAplVlMin := .T.
Local aDadosImp := Array(5)    
Local aTitBsImp := {}
Local lGravou := .F.
Local lLojaAtu  := ( GetNewPar( "MV_LJ10925", "1" ) == "1" )   
Local nTamTit  := TamSX3("E5_PREFIXO")[1]+TamSX3("E5_NUMERO")[1]+TamSX3("E5_PARCELA")[1]+TamSX3("E5_TIPO")[1]
Local nTamTit2  := TamSX3("E5_PREFIXO")[1]+TamSX3("E5_NUMERO")[1]+TamSX3("E5_PARCELA")[1]
Local lImp10925 := ExistBlock("FA080IMP")
Local lAchouPa  := .F.
Local lValPgto := SuperGetMv("MV_BP10925",.T.,"1") == "2" //1- Valor bruto da baixa parcial / 2- Valor da baixa parcial menos os impostos
Local nValProp := 0
Local nTotAdto := 0		
Local lBaixaAbat := .F.
Local lBxCec := .F.
Local lNotBax := .F.
Local nTotImpost := 0
Local lAglImp := .F.
Local aBaixa := {}
Local nY
Local cChaveBx := ""
Local lDigitado := .F.
Local aTitulos	:= {}
Local	lImpInFat := .F.	
Local nImpRetEmi := 0
Local lCpoVlMin := !Empty( SE2->( FieldPos( "E2_APLVLMN" ) ) )
Local lSE2DtBor := !Empty( SE2->( FieldPos( "E2_DTBORDE" ) ) )

#IFDEF TOP
	Local aStruct   := {} 
	Local aCampos   := {} 
	Local cAliasQry := ""  
	Local cSepNeg   := If("|"$MV_CPNEG,"|",",")
	Local cSepPag   := If("|"$MVPAGANT,"|",",")
	Local cSepProv  := If("|"$MVPROVIS,"|",",") 
	Local cAliasSE2 := ""
#ELSE
	Local cIndexSE5
	Local nIndexSe5
	Local nLenNumBor := TamSx3("E2_NUMBOR")[1]
#ENDIF 
               
aFill(aDadosImp,0)

Default lCalcRet := .F.
Default lCalcPA  := .F.
Default lSE2  := .T.   //Variavel para controle do uso do alias alternativo __SE2 para alguns posicionamentos.
Default lAltData := .F.

nIss     := If(Type("nIss") != "N",0,nIss)
nValComp := If(Type("nValComp") != "N",0,nValComp)
nValLiq  := If(Type("nValLiq") != "N",0,nValLiq)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ POR MAIS ESTRANHO QUE PARE€A, ESTA FUNCAO DEVE SER CHAMADA AQUI! ณ
//ณ                                                                  ณ
//ณ A funo SomaAbat reabre o SE2 com outro nome pela ChkFile para  ณ
//ณ efeito de performance. Se o alias auxiliar para a SumAbat() no  ณ
//ณ estiver aberto antes da IndRegua, ocorre Erro de & na ChkFile,   ณ
//ณ pois o Filtro do SE2 uptrapassa 255 Caracteres.                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
SomaAbat("","","","P")

//Verificar ou nao o limite de 5000 para Pis cofins Csll
// 1 = Verifica o valor minimo de retencao
// 2 = Nao verifica o valor minimo de retencao
If !Empty( SE2->( FieldPos( "E2_APLVLMN" ) ) ) .and. SE2->E2_APLVLMN == "2"
	lAplVlMin := .F.
Endif	  

nDiferImp := 0

//Garanto o tamanho dos arrays de retencao
If Len(aDadosRef) < 7
	aDadosRef := Array(7)
	AFill( aDadosRef, 0 ) 
Endif
If Len(adadosRet) < 7
	aDadosRet := Array(7)
	AFill( aDadosRet, 0 ) 
Endif	        

If Type("aRecnosSE2") == "U"
	aRecnosSE2 := {}
Endif

aValorBx := Array(3)
AFill( aValorBx, 0 ) 

If !lPccBaixa
	Return .T.
Endif

//Titulo ja teve retencao na emissao
If !lCalcPA .And. (!(SE2->E2_PRETPIS $ "1#3") .OR. !(SE2->E2_PRETCOF $ "1#3") .OR. !(SE2->E2_PRETCSL $ "1#3"))
	Return .T.
Endif

// Verificar se eh PA para nใo gerar recalculo de impostos.
If !lCalcPA .And. (SE2->E2_TIPO $ MVPAGANT)
	Return .T.
Endif
        
// Faz verificacao das baixas do titulo.
// Consiste se o motivo gera ou nao movimento bancario.
If lMotBxMBco .And. !lCalcPA .And. !FaPCCMovBc() 
	nValPgto += nPis+nCofins+nCsll+nIrrf+nIss
	nOldValPgto := nValPgto
	nPis := 0
	nCofins := 0
	nCsll := 0
	nIrrf := 0
	Return .T.	
Endif

//Se o valor liquidado for diferente do valor da baixa total, foi um valor digitado
If nValLiq > 0 .and. nValLiq != SE2->E2_SALDO .and. !lMotBxMbco 
	lDigitado := .T.
	If !lAltValor
		Return .T.	
	Endif
Endif

//Se a valida็ใo nao partiu do campo de valor
If !lDigitado .and. !lAltValor .and. ( Type('lF080Auto') =='U' .or. ! lF080Auto)
	nValPgto += nPis+nCofins+nCsll+nIrrf+nIss
Endif

If lCalcRet .and. lAplVlMin

	//Verifico todas as filiais apenas quando SA2 compartilhado
	If lTodasFil
		aFil10925 := ExecBlock( "MT103FRT", .F., .F. ) 
	Else
		aFil10925 := { cFilant }
	Endif

	If lVerForLj
		aFor10925 := ExecBlock("F080LOJA",.F.,.F.)
	Endif
	
	AFill( aDadosRef, 0 ) 
	AFill( aDadosRet, 0 ) 

	For nX := 1 to Len(aFil10925)
	
		dbSelectArea("SE5")
		cFilAnt := aFil10925[nX]
		
		#IFDEF TOP 
		        
			If lIrfMP232
				aCampos := { "E5_VALOR","E5_VRETPIS","E5_VRETCOF","E5_VRETCSL","E5_VLJUROS","E5_VLMULTA","E5_VLDESCO","E5_VRETIRF"} 
	   	Else
				aCampos := { "E5_VALOR","E5_VRETPIS","E5_VRETCOF","E5_VRETCSL","E5_VLJUROS","E5_VLMULTA","E5_VLDESCO"}    	
			Endif

			If lCalcIssBx
				aadd(aCampos,"E5_VRETISS")
			Endif				
			
			aStruct := SE5->( dbStruct() ) 	
		
			SE5->( dbCommit() ) 
		   
		  	cAliasQry := GetNextAlias()
		
			cQuery := "SELECT E5_PREFIXO,E5_NUMERO,E5_PARCELA,E5_TIPO,E5_CLIFOR,E5_LOJA,"
			cQuery += "E5_SEQ,E5_VALOR,E5_VRETPIS,E5_VRETCOF,E5_VRETCSL,E5_DATA,E5_VLJUROS,"
			cQuery += "E5_VLMULTA,E5_VLDESCO,E5_PRETPIS,E5_PRETCOF,E5_PRETCSL,E5_MOTBX,"
			cQuery += "E5_DOCUMEN,E5_FORNADT,E5_LOJAADT,E5_RECPAG,"
	
			If lIrfMP232
				cQuery += "E5_VRETIRF,E5_PRETIRF,"
			Endif
	
			If lCalcIssBx
				cQuery += "E5_VRETISS,"
			Endif

			cQuery += "R_E_C_N_O_ RECNO FROM "
			cQuery += RetSqlName( "SE5" ) + " SE5 " 
			cQuery += "WHERE " 
			cQuery += "E5_FILIAL='"    + xFilial("SE5")       + "' AND " 		

			If Len(aFor10925) > 0  //Verificar determinados fornecedores (raiz do CNPJ)
				cQuery += "( " 	
				For nLoop := 1 to Len(aFor10925) 
					cQuery += "(E5_CLIFOR ='"   + aFor10925[nLoop,1]  + "' AND " 	
					cQuery += "E5_LOJA='"       + aFor10925[nLoop,2]  + "') OR "
				Next			
				//Retiro o ultimo OR
				cQuery := Left( cQuery, Len( cQuery ) - 4 ) 
				cQuery += ") AND " 	
			Else  //Apenas o Fornecedor Atual
				If !lCalcPA
					cQuery += "E5_CLIFOR='"		+ SE2->E2_FORNECE			+ "' AND " 	
					If lLojaAtu  //Considero apenas a loja atual
						cQuery += "E5_LOJA='"		+ SE2->E2_LOJA				+ "' AND "
					EndIf
				Else                                                            
					cQuery += "E5_CLIFOR='"		+ M->E2_FORNECE			+ "' AND " 	
					If lLojaAtu  //Considero apenas a loja atual					
						cQuery += "E5_LOJA='"		+ M->E2_LOJA				+ "' AND "
					EndIf
				Endif
			Endif
			
			cQuery += "E5_DATA>= '"		+ DToS( dDataIni )      + "' AND "		
			cQuery += "E5_DATA<= '"		+ DToS( dDataFim )      + "' AND " 
			cQuery += "E5_TIPO NOT IN " + FormatIn(MVABATIM,"|") + " AND "
			cQuery += "E5_TIPO NOT IN " + FormatIn(MV_CPNEG,cSepNeg)  + " AND "
			cQuery += "E5_TIPO NOT IN " + FormatIn(MVPROVIS,cSepProv) + " AND "
			cQuery += "E5_RECPAG = 'P' AND "
			cQuery += "E5_MOTBX <> 'FAT' AND "	
			cQuery += "E5_SITUACA <> 'C' AND "	
	
			//Apenas titulos que tem retencao de PIS,Cofins e CSLL
			If cModTot == "2"
				If lIrfMP232
					cQuery += " ((E5_VRETPIS > 0 OR E5_VRETCOF > 0 OR E5_VRETCSL > 0 OR E5_VRETIRF > 0) .OR. "
					cQuery += " (E5_MOTBX = 'CMP')) AND "
				Else
					cQuery += " ((E5_VRETPIS > 0 OR E5_VRETCOF > 0 OR E5_VRETCSL > 0) OR (E5_MOTBX = 'CMP')) AND "
				Endif
	   	Endif
			
			cQuery += "D_E_L_E_T_=' '"                                             
			cQuery += "AND NOT EXISTS ( "
			cQuery += "SELECT A.E5_NUMERO "
			cQuery += "FROM "+RetSqlName("SE5")+" A "
			cQuery += "WHERE A.E5_FILIAL='"+xFilial("SE5")+"' AND "
			cQuery +=		"A.E5_PREFIXO=SE5.E5_PREFIXO AND "
			cQuery +=		"A.E5_NUMERO=SE5.E5_NUMERO AND "
			cQuery +=		"A.E5_PARCELA=SE5.E5_PARCELA AND "
			cQuery +=		"A.E5_TIPO=SE5.E5_TIPO AND "
			cQuery +=		"A.E5_CLIFOR=SE5.E5_CLIFOR AND "
			cQuery +=		"A.E5_LOJA=SE5.E5_LOJA AND "
			cQuery +=		"A.E5_SEQ=SE5.E5_SEQ AND "
			cQuery +=		"A.E5_TIPODOC='ES' AND "
			cQuery +=		"A.E5_RECPAG<>'P' AND "
			cQuery +=		"A.D_E_L_E_T_<>'*')"
			
			cQuery := ChangeQuery( cQuery ) 
			
			dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasQry, .F., .T. )
			
			For nLoop := 1 To Len( aStruct ) 
				If !Empty( AScan( aCampos, AllTrim( aStruct[nLoop,1] ) ) ) 
					TcSetField( cAliasQry, aStruct[nLoop,1], aStruct[nLoop,2],aStruct[nLoop,3],aStruct[nLoop,4])
				EndIf 			
			Next
			
			While !( cAliasQRY )->( Eof()) 

				nImpRetEmi := 0

				// Consiste se o motivo gera ou nao movimento bancario.
				If lMotBxMBco              
					If !FaPCCMovBc((cAliasQRY)->E5_MOTBX)
						(cAliasQRY)->(DbSkip())
						Loop
					Endif
				Endif
				
				//Verificar ou nao o limite de 5000 para Pis cofins Csll
				// 1 = Verifica o valor minimo de retencao
				// 2 = Nao verifica o valor minimo de retencao (estes nao serao considerados na soma dos 5000)
				If !Empty( SE2->( FieldPos( "E2_APLVLMN" ) ) ) .and. SE2->E2_APLVLMN == "2"
					(cAliasQRY)->(DbSkip())
					Loop
				Endif	  

				//Verifico se as compensacoes foram realizados com PA ou NDF e que nao retem PCC
         	If !F241CmpPcc(cAliasQRY,cChaveTit)
					(cAliasQRY)->(DbSkip())
					Loop
				Endif         		

				nProp := 1			
				nProp2 := 1
				If ( cAliasQRY )->E5_VRETPIS + ( cAliasQRY )->E5_VRETCOF + ( cAliasQRY )->E5_VRETCSL + IF(lIrfMP232, ( cAliasQRY )->E5_VRETIRF , 0 ) > 0
					If lSE2
						cAliasSE2 := "SE2"
					Else
						cAliasSE2 := "__SE2"					
					Endif					
					(cAliasSE2)->(dbSetOrder(1))
					(cAliasSE2)->(MsSeek(xFilial("SE2")+(cAliasQRY)->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)))
               
					//Se for PA, verifica se houve baixa parcial para carregar varivael
					//nProp2 com o percentual proporcional para recalcular os impostos.
					If (cAliasSE2)->E2_TIPO $ MVPAGANT
						If (cAliasSE2)->E2_VALOR - (cAliasSE2)->E2_SALDO > 0
							nProp2 := (((cAliasSE2)->E2_VALOR - (cAliasSE2)->E2_SALDO) / (cAliasSE2)->E2_VALOR)
						Endif
					Endif
      			
					If lIrfMP232
						nVlrTit := (cAliasSE2)->(E2_VALOR+E2_ISS+E2_INSS)
					Else
						nVlrTit := (cAliasSE2)->(E2_VALOR+E2_IRRF+E2_ISS+E2_INSS)
					Endif

					If lSest
						nVlrTit += (cAliasSE2)->E2_SEST
					Endif					

					If lCalcIssBx
						nVlrTit -= (cAliasSE2)->E2_ISS
					Endif

					nImpRetEmi := nVlrTit - (cAliasSE2)->(E2_VALOR)

					//aTitulos
					//[1] Chave do titulo
					//[2]	Valor Baixado bruto
					//[3]	PCC Retido
					//[4]	PCC Retido em baixa intermediaria (sera somado para compor a proporcao na ultima baixa)
															
					//Array para somar os valores de titulo e valores baixados
					If (nX := Ascan(aTitulos,{|x| x[1] == (cAliasQRY)->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)})) == 0
						aadd(aTitulos,{(cAliasQRY)->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA),nVlrTit,0,0})
						nX := Len(aTitulos)
						aTitulos[nX,2] := nVlrTit		//Somo as bases
					Endif
					
					nValProp := (cAliasQRY)->(E5_VALOR+E5_VLDESCO-E5_VLJUROS-E5_VLMULTA)
					
					aTitulos[nX,3]+= nValProp

					//Baixa pelo valor bruto digitado nao devo somar os impostos exceto na baixa final (saldo = 0)
					//(MV_BP10925 = 1)
					If !lValPgto .and. (Empty( ( cAliasQRY )->E5_PRETPIS ) .Or. Empty( ( cAliasQRY )->E5_PRETCOF ) .Or. Empty( ( cAliasQRY )->E5_PRETCSL ))
						If (aTitulos[nX,2] == nImpRetEmi+ aTitulos[nX,3]+(cAliasQRY)->(E5_VRETPIS+E5_VRETCOF+E5_VRETCSL)) .OR.;
								(cAliasQry)->E5_TIPO $ MVPAGANT
							nValProp += aTitulos[nX,4]+(cAliasQRY)->(E5_VRETPIS+E5_VRETCOF+E5_VRETCSL)
						Else
							aTitulos[nX,4]+= (cAliasQRY)->(E5_VRETPIS+E5_VRETCOF+E5_VRETCSL)
						Endif
						aTitulos[nX,3]+= (cAliasQRY)->(E5_VRETPIS+E5_VRETCOF+E5_VRETCSL)

					//Baixa pelo valor liquido da baixa digitada devo somar os impostos quando retidos
					//(MV_BP10925 = 2)
					ElseIF Empty( ( cAliasQRY )->E5_PRETPIS ) .Or. Empty( ( cAliasQRY )->E5_PRETCOF ) .Or. Empty( ( cAliasQRY )->E5_PRETCSL )
						nValProp += (cAliasQRY)->(E5_VRETPIS+E5_VRETCOF+E5_VRETCSL)
					EndIf						

					//Somo o valor dos impostos retidos na emissao para proporcionalizar corretamente
					If (aTitulos[nX,2] == aTitulos[nX,3] + nImpRetEmi )
						nValProp += nImpRetEmi
					Endif

					nProp := nValProp /nVlrTit

					//Incrementa a base de calculo para gerar os titulos se nao for
					//compensa็ใo entre carteiras e baixa de impostos via bordero
					If !(cAliasQRY)->E5_MOTBX $ "PCC#CEC"
						nVlrTit := nVlrTit * nProp
						aDadosRef[1] += nVlrTit * nProp2					
					EndIf
				Else				
					If !(cAliasQRY)->E5_MOTBX $ "PCC#CEC" .and. ;
						!((cAliasQRY)->E5_MOTBX $ "CMP" .and. SUBSTR((cAliasQRY)->E5_DOCUMEN,nTamTit2+1,3) $ MV_CPNEG) //Desconsiderar compensacoes com NDF
						aDadosRef[1] += (cAliasQRY)->(E5_VALOR+E5_VLDESCO-E5_VLJUROS-E5_VLMULTA)					
					EndIf
				Endif

				//Incrementa a base de calculo para gerar os titulos          
				If (cAliasQRY)->E5_MOTBX == "PCC" 
					aDadosRef[1] += nVlrTit - (cAliasQRY)->(E5_VRETPIS+E5_VRETCOF+E5_VRETCSL) 
				EndIf
				
				//Guardo os valores compensados entre carteiras para recompor a base de calculo
				If (cAliasQRY)->E5_MOTBX == "CEC" .And. (cAliasQRY)->E5_RECPAG == "P" .And.;
					(cAliasQRY)->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA) == cChaveTit
					nValComp += (cAliasQRY)->E5_VALOR
				EndIf
				
				//Recalcula o valor do titulo principal para adicionar no campo
				// com os valores de titulos retidos
				If AliasIndic("SFQ")
					aAreaQry := GetArea()
					SFQ->(dbSetOrder(1))
					cChaveSE5 := (cAliasQRY)->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)
					If SFQ->(MsSeek(xFilial("SFQ")+cAliasSE2+cChaveSE5))
						While SFQ->(!Eof()) .and. SFQ->FQ_FILIAL == xFilial("SFQ") .And.;
								SFQ->(FQ_PREFORI+FQ_NUMORI+FQ_PARCORI+FQ_TIPOORI+FQ_CFORI+FQ_LOJAORI) == cChaveSE5
							cChaveSFQ := SFQ->(FQ_PREFDES+FQ_NUMDES+FQ_PARCDES+FQ_TIPODES+FQ_CFDES+FQ_LOJADES)
							(cAliasSE2)->(dbSetOrder(1))
							If (cAliasSE2)->(MsSeek(xFilial(cAliasSE2)+cChaveSFQ))
								aDadosRef[1] += (cAliasSE2)->E2_VALOR 
							EndIf							
							SFQ->(dbSkip())        	
						EndDo
					EndIf							
					RestArea(aAreaQry)
				EndIf
				
				If (cAliasQRY)->E5_MOTBX == "CMP" .OR. ( cAliasQRY )->E5_VRETPIS + ( cAliasQRY )->E5_VRETCOF + ( cAliasQRY )->E5_VRETCSL + IF(lIrfMP232, ( cAliasQRY )->E5_VRETIRF , 0 ) > 0

					If lSE2
						cAliasSE2 := "SE2"
					Else
						cAliasSE2 := "__SE2"
					Endif					

					(cAliasSE2)->(dbSetOrder(1))
					(cAliasSE2)->(MsSeek(xFilial("SE2")+(cAliasQRY)->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)))
				
					//aTitulos
					//[1] Chave do titulo
					//[2]	Valor Baixado bruto
					//[3]	PCC Retido
					//[4]	PCC Retido em baixa intermediaria (sera somado para compor a proporcao na ultima baixa)
															
					If (cAliasQRY)->E5_MOTBX == "CMP" .AND. !(cAliasQRY)->E5_TIPO $ MVPAGANT

						If lIrfMP232
							nVlrTit := (cAliasSE2)->(E2_VALOR+E2_ISS+E2_INSS)
						Else
							nVlrTit := (cAliasSE2)->(E2_VALOR+E2_IRRF+E2_ISS+E2_INSS)
						Endif
	
						If lSest
							nVlrTit += (cAliasSE2)->E2_SEST
						Endif					
	
						If lCalcIssBx
							nVlrTit -= (cAliasSE2)->E2_ISS
						Endif
	
						//Array para somar os valores de titulo e valores baixados
						If (nX := Ascan(aTitulos,{|x| x[1] == (cAliasQRY)->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)})) == 0
							aadd(aTitulos,{(cAliasQRY)->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA),nVlrTit,0,0})
							nX := Len(aTitulos)
							aTitulos[nX,2] := nVlrTit		//Somo as bases
						Endif
						aTitulos[nX,3]+= (cAliasQRY)->(E5_VALOR+E5_VLDESCO-E5_VLJUROS-E5_VLMULTA)
					EndIf

					If (Ascan(aTitBsImp,{|x| x == (cAliasQRY)->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ)})) = 0
						
						If !((cAliasQRY)->E5_MOTBX $ "PCC#CMP#FAT")
							//Armazeno os valores calculados por titulo.
							If (cAliasSE2)->E2_PIS > 0 .AND. !(cAliasQRY)->E5_TIPO $ MVPAGANT
								aDadosImp[1] += (cAliasSE2)->E2_PIS * nProp
								lGravou := .T.
							EndIf	
				
							If (cAliasSE2)->E2_COFINS > 0 .aND. !(cAliasQRY)->E5_TIPO $ MVPAGANT 
								aDadosImp[2] += (cAliasSE2)->E2_COFINS * nProp
								lGravou := .T.							
							EndIf	
			
							If (cAliasSE2)->E2_CSLL > 0 .aND. !(cAliasQRY)->E5_TIPO $ MVPAGANT
								aDadosImp[3] += (cAliasSE2)->E2_CSLL * nProp
								lGravou := .T.							
							EndIf	
						EndIf
						
						//Somo valores dos impostos de IRRF/ISS/INSS dos titulos que foram compensados
						//por PA que nใo reteve impostos, para recompor a base de calculo
						If (cAliasSE2)->(E2_IRRF+E2_ISS+E2_INSS) > 0 .AND. !(cAliasQRY)->E5_TIPO $ MVPAGANT .And.;
							(cAliasQRY)->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA) != cChaveTit
							aAreaSE5 := (cAliasQRY)->(GetArea())
							dbSelectArea("SE5")
							dbSetOrder(7)
							If MsSeek(xFilial("SE5")+SUBSTR((cAliasQRY)->E5_DOCUMEN,1,nTamTit)+(cAliasQRY)->E5_FORNADT+;
								(cAliasQRY)->E5_LOJAADT)
								If	SE5->E5_PRETPIS == "1" .Or. SE5->E5_PRETCOF == "1" .Or. SE5->E5_PRETCSL == "1" 
									aDadosImp[4] += (cAliasSE2)->(E2_IRRF+E2_ISS+E2_INSS)
									lGravou := .T.							
								EndIf
							EndIf
							RestArea(aAreaSE5)
						EndIf	
						
						//Somo valores dos impostos de IRRF/ISS/INSS dos titulos do tipo PA (Pagto Adiantado) 
						//que foram compensados, para recompor a base de calculo(nBaseImp) do PIS/COF/CSL
						If (cAliasSE2)->(E2_IRRF+E2_ISS+E2_INSS) > 0 .AND. (cAliasQRY)->E5_TIPO $ MVPAGANT .And.;
							SUBSTR((cAliasQRY)->E5_DOCUMEN,1,nTamTit)+(cAliasQRY)->(E5_FORNADT+E5_LOJAADT) == cChaveTit
							aAreaSE5 := (cAliasQRY)->(GetArea())
							dbSelectArea("SE5")
							dbSetOrder(7)
							If MsSeek(xFilial("SE5")+(cAliasQRY)->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA))
								If AliasIndic("SFQ")
									SFQ->(dbSetOrder(2))
									cChaveSE5 := SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)
									If SFQ->(MsSeek(xFilial("SFQ")+"SE5"+cChaveSE5))
										lAchouPa := .T.
									EndIf							
								EndIf
								If	(SE5->E5_PRETPIS $ "1# " .Or. SE5->E5_PRETCOF $ "1# " .Or. SE5->E5_PRETCSL $ "1# ") .And.;
									!lAchouPa									
									aDadosImp[5] += (cAliasSE2)->(E2_IRRF+E2_ISS+E2_INSS)
									lGravou := .T.							
									AAdd( aRecnos, ( cAliasQRY )->RECNO ) 
								EndIf
							EndIf
							RestArea(aAreaSE5)
						EndIf	
						
						If lGravou
							AADD(aTitBsImp,(cAliasQRY)->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ))
							lGravou := .F.
						Endif		  
					Endif
				EndIf				
					
				nImpostos := 0						
	         
				If ( cAliasQRY )->E5_PRETPIS $ " #2#4"
					aDadosRef[1] += (cAliasQRY)->E5_VRETPIS * nProp2
					nImpostos += (cAliasQRY)->E5_VRETPIS * nProp2
					//Armazeno os valores calculados por titulo, retirando os valores retidos
					If ( cAliasQRY )->E5_VRETPIS + ( cAliasQRY )->E5_VRETCOF + ( cAliasQRY )->E5_VRETCSL + IF(lIrfMP232, ( cAliasQRY )->E5_VRETIRF , 0 ) > 0 .And.;
						!((cAliasQRY)->E5_MOTBX $ "PCC#CMP#FAT") .AND. !(cAliasQRY)->E5_TIPO $ MVPAGANT
						aDadosImp[1] -= (cAliasQRY)->E5_VRETPIS * nProp2
					Endif					
				EndIf 								
		
				If ( cAliasQRY )->E5_PRETCOF $ " #2#4"
					aDadosRef[1] += ( cAliasQRY )->E5_VRETCOF * nProp2
					nImpostos += (cAliasQRY)->E5_VRETCOF * nProp2
					//Armazeno os valores calculados por titulo, retirando os valores retidos
					If ( cAliasQRY )->E5_VRETPIS + ( cAliasQRY )->E5_VRETCOF + ( cAliasQRY )->E5_VRETCSL + IF(lIrfMP232, ( cAliasQRY )->E5_VRETIRF , 0 ) > 0 .And.;
						!((cAliasQRY)->E5_MOTBX $ "PCC#CMP#FAT") .aND. !(cAliasQRY)->E5_TIPO $ MVPAGANT
						aDadosImp[2] -= (cAliasQRY)->E5_VRETCOF * nProp2
					Endif					
				EndIf 								
		
				If ( cAliasQRY )->E5_PRETCSL $ " #2#4"
					aDadosRef[1] += ( cAliasQRY )->E5_VRETCSL * nProp2 
					nImpostos += (cAliasQRY)->E5_VRETCSL * nProp2
					//Armazeno os valores calculados por titulo, retirando os valores retidos
					If ( cAliasQRY )->E5_VRETPIS + ( cAliasQRY )->E5_VRETCOF + ( cAliasQRY )->E5_VRETCSL + IF(lIrfMP232, ( cAliasQRY )->E5_VRETIRF , 0 ) > 0 .And.;
						!((cAliasQRY)->E5_MOTBX $ "PCC#CMP#FAT") .aND. !(cAliasQRY)->E5_TIPO $ MVPAGANT
						aDadosImp[3] -= (cAliasQRY)->E5_VRETCSL * nProp2
					Endif					
				EndIf 								
				
				If lIrfMP232 .and. Empty( ( cAliasQRY )->E5_PRETIRF )
					aDadosRef[1] += ( cAliasQRY )->E5_VRETIRF
					nImpostos += (cAliasQRY)->E5_VRETIRF
				EndIf 								
	
				If lCalcIssBx
					aDadosRef[1] += SE5->E5_VRETISS
				Endif

	
				//Guardo o valor dos impostos descontados para que seja recomposta a base de calculo
				If (cAliasQRY)->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA) == cChaveTit
					//Caso o sistema gravar como valor de pagamento na baixa parcial, o valor da baixa menos os impostos
					//calculados, nใo ha a necessidade de recompor a base de calculo
					If lValPgto
						aDadosRef[7] += nImpostos
					EndIf
				Endif
	
				If ( cAliasQRY )->E5_PRETPIS == "1" .Or. ( cAliasQry )->E5_PRETCOF == "1" .Or. ( cAliasQry )->E5_PRETCSL == "1" 
					
					If ( cAliasQRY )->E5_PRETPIS == "1"
						aDadosRef[2] += ( cAliasQRY )->E5_VRETPIS * nProp2
					EndIf	
		
					If ( cAliasQRY )->E5_PRETCOF == "1"
						aDadosRef[3] += ( cAliasQRY )->E5_VRETCOF * nProp2 
					EndIf	
							
					If ( cAliasQRY )->E5_PRETCSL == "1"
						aDadosRef[4] += ( cAliasQRY )->E5_VRETCSL * nProp2        
					EndIf 	
	
					If lIrfMP232 .and. ( cAliasQRY )->E5_PRETIRF == "1"
						aDadosRef[5] += ( cAliasQRY )->E5_VRETIRF       
					EndIf 	                                

					// Caso exista titulo de PA com pendencia de 
					// retencao, marco o flag para ser usado na baixa.					
					If (cAliasQRY)->E5_TIPO $ MVPAGANT
						lPendPA := .T.
					Endif					
					
					AAdd( aRecnos, ( cAliasQRY )->RECNO ) 
			
				// Acumula os valores das baixas realizadas parcialmente
				// para ser utilizada na analise de possiveis problemas 
				// de arredondamento que ocorrem na baixa total.
				ElseIf  Empty((cAliasQRY)->E5_PRETPIS) .Or. Empty((cAliasQry)->E5_PRETCOF) .Or. Empty((cAliasQry)->E5_PRETCSL)

					If Empty((cAliasQRY)->E5_PRETPIS)
						aValorBx[1] += ( cAliasQRY )->E5_VRETPIS
					EndIf	
		
					If Empty((cAliasQRY)->E5_PRETCOF)
						aValorBx[2] += ( cAliasQRY )->E5_VRETCOF
					EndIf	
							
					If Empty((cAliasQRY)->E5_PRETCSL)
						aValorBx[3] += ( cAliasQRY )->E5_VRETCSL
					EndIf 	
	
				Endif
                 
				// Caso exista uma CMP envolvendo um PA, marco flag para uso
				//	no momento da baixa para compor o valor a ser baixado.
				If (cAliasQRY)->E5_MOTBX = "CMP"
					lPaComp := .T.               
				Endif
			
				( cAliasQRY )->( dbSkip()) 
				
		   EndDo 
		   
			// Fecha a area de trabalho da query 
		   ( cAliasQRY )->( dbCloseArea() ) 
		   dbSelectArea( "SE2" ) 
			

			//Titulos em bordero que tem retencao de PCC pendente
			//Exemplo:
			//3 titulos de 4000 com calculo de PCC
			//Coloque o primeiro titulo em bordero e ao baixar o segundo, o imposto devera
			//ser calculado por 8000 (soma dois titulos)
			//Se baixar ou gerar bordero para o terceiro, este devera reter apenas sobre a sua base
			If lSE2DtBor	

				aStruct := SE2->( dbStruct() ) 	
			
				SE2->( dbCommit() ) 
			   
			  	cAliasQry := GetNextAlias()
			
				cQuery := "SELECT E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO,E2_FORNECE,E2_LOJA,"
				cQuery += "E2_VALOR,E2_VRETPIS,E2_VRETCOF,E2_VRETCSL,E2_PRETPIS,E2_PRETCOF,E2_PRETCSL,"
				cQuery += "E2_NUMBOR,E2_PIS,E2_COFINS,E2_CSLL,E2_IRRF,E2_ISS,E2_INSS,"
		
				If lSE2DtBor	
					cQuery += "E2_DTBORDE,"		
				Endif
				If lCpoVlMin         
					cQuery += "E2_APLVLMN,"		
				Endif

				If lSest	
					cQuery += "E2_SEST,"		
				Endif

				cQuery += "	R_E_C_N_O_ RECNO FROM "
				cQuery += RetSqlName( "SE2" ) + " SE2 " 
				cQuery += "WHERE " 
				cQuery += "E2_FILIAL='"    + xFilial("SE2")       + "' AND " 
		
				If Len(aFor10925) > 0  //Verificar determinados fornecedores (raiz do CNPJ)
					cQuery += "( " 	
					For nLoop := 1 to Len(aFor10925) 
						cQuery += "(E2_FORNECE ='"   + aFor10925[nLoop,1]  + "' AND " 	
						cQuery += "E2_LOJA='"       + aFor10925[nLoop,2]  + "') OR "
					Next			
					//Retiro o ultimo OR
					cQuery := Left( cQuery, Len( cQuery ) - 4 ) 
					cQuery += ") AND " 	
				Else  //Apenas Fornecedor e Loja atuais
					cQuery += "E2_FORNECE ='"     + SE2->E2_FORNECE        + "' AND " 	
					cQuery += "E2_LOJA='"        + SE2->E2_LOJA           + "' AND "
				Endif

				cQuery += "(E2_DTBORDE >= '" + DToS( dDataIni )					+ "' AND "		
				cQuery += "E2_DTBORDE <= '" + DToS( dDataFim )					+ "') AND " 
				cQuery += "E2_TIPO NOT IN " + FormatIn(MVABATIM,"|")			+ " AND "
				cQuery += "E2_TIPO NOT IN " + FormatIn(MV_CPNEG,cSepNeg)		+ " AND "
				cQuery += "E2_TIPO NOT IN " + FormatIn(MVPROVIS,cSepProv)	+ " AND "
				cQuery += "E2_TIPO NOT IN " + FormatIn(MVPAGANT,cSepPag)		+ " AND "
				cQuery += "(E2_SALDO>0 OR E2_NUMBOR <> '"+SPACE(LEN(E2_NUMBOR))+"') AND "
				cQuery += "E2_NUMBOR <> '"+SPACE(LEN(E2_NUMBOR))+"' AND " 	
				cQuery += "(E2_PRETPIS = '1' OR E2_PRETCOF = '1' OR E2_PRETCSL = '1' ) AND "		

				If lIrfMP232
					cQuery += " (E2_PIS > 0 OR E2_COFINS > 0 OR E2_CSLL > 0 OR E2_IRRF > 0 ) AND "
				Else
					cQuery += " (E2_PIS > 0 OR E2_COFINS > 0 OR E2_CSLL > 0 ) AND "
				Endif

				//Verificar ou nao o limite de 5000 para Pis cofins Csll
				// 1 = Verifica o valor minimo de retencao
				// 2 = Nao verifica o valor minimo de retencao (NAO SERAO CONSIDERADOS PARA A SOMA DOS 5000)
				If lCpoVlMin
					cQuery += " E2_APLVLMN <> '2' AND "
				Endif	  
		
				cQuery += "D_E_L_E_T_=' '"                                             

				cQuery := ChangeQuery( cQuery ) 
				
				dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasQry, .F., .T. )
				
				For nLoop := 1 To Len( aStruct ) 
					If !Empty( AScan( aCampos, AllTrim( aStruct[nLoop,1] ) ) ) 
						TcSetField( cAliasQry, aStruct[nLoop,1], aStruct[nLoop,2],aStruct[nLoop,3],aStruct[nLoop,4])
					EndIf 			
				Next nLoop 
				
				While !( cAliasQRY )->( Eof()) 
					
					If lIrfMP232
						nVlrTit := ( cAliasQRY )->(E2_VALOR+E2_ISS+E2_INSS)
					Else
						nVlrTit := ( cAliasQRY )->(E2_VALOR+E2_IRRF+E2_ISS+E2_INSS)
					Endif
		
					If lSest
						nVlrTit += ( cAliasQRY )->E2_SEST
					Endif					
		
					If lCalcIssBx
						nVlrTit -= ( cAliasQRY )->E2_ISS
					Endif			

					aDadosRef[1] += nVlrTit

					//Armazeno os valores calculados por titulo.
					aDadosImp[1] += (cAliasQRY)->E2_PIS
					aDadosRef[2] += (cAliasQRY)->E2_PIS

					aDadosImp[2] += (cAliasQRY)->E2_COFINS
					aDadosRef[3] += (cAliasQRY)->E2_COFINS							

					aDadosImp[3] += (cAliasQRY)->E2_CSLL
					aDadosRef[4] += (cAliasQRY)->E2_CSLL							
	
					//Guardo registros para acertar a pendencia de retencao
					AAdd( aRecnosSE2, (cAliasQRY)->RECNO ) 
					( cAliasQRY )->( dbSkip()) 

				EndDo 
				   
				// Fecha a area de trabalho da query 
				( cAliasQRY )->( dbCloseArea() ) 
				dbSelectArea( "SE2" ) 
				dbSetOrder(1)

		    Endif
		
		#ELSE 
		
			ChkFile("SE5",.F.,"NEWSE5")
			cIndexSE5 := CriaTrab(,.f.)
				
			cQuery := "E5_FILIAL='"      + xFilial( "SE5" )     + "' .AND. "
			If Len(aFor10925) > 0  //Verificar determinados fornecedores (raiz do CNPJ)
				cQuery += "( " 	
				For nLoop := 1 to Len(aFor10925) 
					cQuery += "(E5_CLIFOR ='"   + aFor10925[nLoop,1]  + "' .AND. " 	
					cQuery += "E5_LOJA='"       + aFor10925[nLoop,2]  + "') .OR."
				Next			
				cQuery := Left( cQuery, Len( cQuery ) - 5 ) 
				cQuery += ") .AND. " 	
			Else  //Apenas Fornecedor atual
				If !lCalcPA
					cQuery += "E5_CLIFOR='"     + SE2->E2_FORNECE        + "' .AND. " 	
					If lLojaAtu  //Considero apenas a loja atual
						cQuery += "E5_LOJA='"        + SE2->E2_LOJA           + "' .AND. "
					EndIf
				Else
					cQuery += "E5_CLIFOR='"     + M->E2_FORNECE        + "' .AND. " 	
					If lLojaAtu  //Considero apenas a loja atual
						cQuery += "E5_LOJA='"        + M->E2_LOJA           + "' .AND. "			
					EndIf
				Endif
			Endif
			cQuery += "DTOS(E5_DATA)>='" + DToS( dDataIni ) + "' .AND. "		
			cQuery += "DTOS(E5_DATA)<='" + DToS( dDataFim ) + "' .AND. "
			cQuery += "E5_RECPAG == 'P' .AND. "
			cQuery += "E5_MOTBX <> 'FAT' .AND. "	
			cQuery += "E5_SITUACA <> 'C' .AND. "	
			//Apenas titulos que tem retencao de PIS,Cofins e CSLL
			If cModTot == "2"
				If lIrfMP232
					cQuery += " ((E5_VRETPIS > 0 .OR. E5_VRETCOF > 0 .OR. E5_VRETCSL > 0 .OR. E5_VRETIRF > 0  ) .OR. "
					cQuery += " (E5_MOTBX = 'CMP')) .AND. "				
				Else
					cQuery += " ((E5_VRETPIS > 0 .OR. E5_VRETCOF > 0 .OR. E5_VRETCSL > 0 ) .OR. (E5_MOTBX = 'CMP')) .AND. "			
				Endif
	   	Endif
                    
			cQuery += "!(E5_TIPO $ '"+MVABATIM + "/" + MV_CPNEG + "/" + MVPROVIS + "')"
			
			IndRegua("SE5",cIndexSE5,"DTOS(E5_DATA)",, cQuery ,"")
			nIndexSE5 :=RetIndex("SE5")+1
			dbSetIndex(cIndexSE5+OrdBagExt())
			dbSetorder(nIndexSe5)
			SE5->( dbSetOrder( nIndexSE5 ) )
			SE5->( dbSeek( DTOS( dDataIni ), .T. ) ) 
			
			While !SE5->( Eof() ) .And. SE5->E5_DATA >= dDataIni .And. SE5->E5_DATA <= dDataFim 
								
				nImpRetEmi := 0

				//Verifica se tem baixa cancelada
				If TemBxCanc(SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ))
					SE5->( dbskip())
					loop
				EndIf
				
				// Consiste se o motivo gera ou nao movimento bancario.
				If lMotBxMBco              
					If !FaPCCMovBc(SE5->E5_MOTBX)
						SE5->(DbSkip())
						Loop
					Endif
				Endif
	
				//Verificar ou nao o limite de 5000 para Pis cofins Csll
				// 1 = Verifica o valor minimo de retencao
				// 2 = Nao verifica o valor minimo de retencao (estes nao serao considerados na soma dos 5000)
				If !Empty( SE2->( FieldPos( "E2_APLVLMN" ) ) ) .and. SE2->E2_APLVLMN == "2"
					SE5->(DbSkip())
					Loop
				Endif	  

				//Verifico se as compensacoes foram realizados com PA ou NDF e que nao retem PCC
				If !F241CmpPcc("SE5",cChaveTit)
					(cAliasQRY)->(DbSkip())
					Loop
				Endif         		

				nProp := 1			
				nProp2 := 1			
				If lBaseSE2 .and. SE5->(E5_VRETPIS + E5_VRETCOF + E5_VRETCSL)+ If(lIrfMP232,SE5->E5_VRETIRF,0) > 0
					SE2->(dbSetOrder(1))
					SE2->(MsSeek(xFilial("SE2")+SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)))

					//Se for PA, verifica se houve baixa parcial para carregar varivael
					//nProp2 com o percentual proporcional para recalcular os impostos.
					If SE2->E2_TIPO $ MVPAGANT
						If SE2->E2_VALOR - SE2->E2_SALDO > 0
							nProp2 := ((SE2->E2_VALOR - SE2->E2_SALDO) / SE2->E2_VALOR)
						Endif
					Endif

					If lIrfMP232
						nVlrTit := SE2->(E2_VALOR+E2_ISS+E2_INSS)
					Else
						nVlrTit := SE2->(E2_VALOR+E2_IRRF+E2_ISS+E2_INSS)
					Endif

					If lSest
						nVlrTit += SE2->E2_SEST
					Endif					

					If lCalcIssBx
						nVlrTit -= SE2->E2_ISS
					Endif

					nImpRetEmi := nVlrTit - SE2->E2_VALOR

					//aTitulos
					//[1] Chave do titulo
					//[2]	Valor Baixado bruto
					//[3]	PCC Retido
					//[4]	PCC Retido em baixa intermediaria (sera somado para compor a proporcao na ultima baixa)

					//Array para somar os valores de titulo e valores baixados
					If (nX := Ascan(aTitulos,{|x| x[1] == SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)})) == 0
						aadd(aTitulos,{SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA),nVlrTit,0,0})
						nX := Len(aTitulos)
						aTitulos[nX,2] := nVlrTit		//Somo as bases
					Endif

					nValProp := SE5->(E5_VALOR+E5_VLDESCO-E5_VLJUROS-E5_VLMULTA)

					//Somo o valor dos impostos retidos na emissao para proporcionalizar corretamente
					If (aTitulos[nX,2] == aTitulos[nX,3]+SE5->(E5_VRETPIS+E5_VRETCOF+E5_VRETCSL)+ nImpRetEmi )
						nValProp += nImpRetEmi
					Endif

					aTitulos[nX,3]+= nValProp

					//Baixa pelo valor bruto digitado nao devo somar os impostos exceto na baixa final (saldo = 0)
					//(MV_BP10925 = 1)
					If !lValPgto .and. (Empty( SE5->E5_PRETPIS ) .Or. Empty( SE5->E5_PRETCOF ) .Or. Empty( SE5->E5_PRETCSL ))
						If aTitulos[nX,2] == nImpRetEmi + aTitulos[nX,3] + SE5->(E5_VRETPIS+E5_VRETCOF+E5_VRETCSL)
							nValProp += aTitulos[nX,4]+SE5->(E5_VRETPIS+E5_VRETCOF+E5_VRETCSL)
						Else
							aTitulos[nX,4]+= SE5->(E5_VRETPIS+E5_VRETCOF+E5_VRETCSL)
						Endif
						aTitulos[nX,3]+= SE5->(E5_VRETPIS+E5_VRETCOF+E5_VRETCSL)


					//Baixa pelo valor liquido da baixa digitada devo somar os impostos quando retidos
					//(MV_BP10925 = 2)
					ElseIF Empty( SE5->E5_PRETPIS ) .Or. Empty( SE5->E5_PRETCOF ) .Or. Empty( SE5->E5_PRETCSL )
						nValProp += SE5->(E5_VRETPIS+E5_VRETCOF+E5_VRETCSL)
					EndIf						

					nProp := nValProp /nVlrTit

					//Incrementa a base de calculo para gerar os titulos se nao for
					//compensa็ใo entre carteiras e baixa de impostos via bordero
					If !SE5->E5_MOTBX $ "PCC#CEC"
						nVlrTit := nVlrTit * nProp
						aDadosRef[1] += nVlrTit * nProp2					
					EndIf
				Else				                                                     
					If !SE5->E5_MOTBX $ "PCC#CEC" .and. ;
						!(SE5->E5_MOTBX $ "CMP" .and. SUBSTR(SE5->E5_DOCUMEN,nTamTit2+1,3) $ MV_CPNEG) //Desconsiderar compensacoes com NDF
						aDadosRef[1] += SE5->(E5_VALOR+E5_VLDESCO-E5_VLJUROS-E5_VLMULTA)
					EndIf
				Endif

				//Incrementa a base de calculo para gerar os titulos          
				If SE5->E5_MOTBX == "PCC" 
					aDadosRef[1] += nVlrTit - SE5->(E5_VRETPIS+E5_VRETCOF+E5_VRETCSL) 
				EndIf
				
				//Guardo os valores compensados entre carteiras para recompor a base de calculo
				If SE5->E5_MOTBX == "CEC" .And. SE5->E5_RECPAG == "P" .And.;
					SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA) == cChaveTit
					nValComp += SE5->E5_VALOR
				EndIf

				//Recalcula o valor do titulo principal para adicionar no campo
				// com os valores de titulos retidos
				If AliasIndic("SFQ")
					aAreaQry := GetArea()
					SFQ->(dbSetOrder(1))
					cChaveSE5 := SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)
					If SFQ->(MsSeek(xFilial("SFQ")+"SE2"+cChaveSE5))
						While SFQ->(!Eof()) .and. SFQ->FQ_FILIAL == xFilial("SFQ") .And.;
								SFQ->(FQ_PREFORI+FQ_NUMORI+FQ_PARCORI+FQ_TIPOORI+FQ_CFORI+FQ_LOJAORI) == cChaveSE5
							cChaveSFQ := SFQ->(FQ_PREFDES+FQ_NUMDES+FQ_PARCDES+FQ_TIPODES+FQ_CFDES+FQ_LOJADES)
							SE2->(dbSetOrder(1))
							If SE2->(MsSeek(xFilial("SE2")+cChaveSFQ))
								aDadosRef[1] += SE2->E2_VALOR 
							EndIf							
							SFQ->(dbSkip())        	
						EndDo
					EndIf							
					RestArea(aAreaQry)
				EndIf

				If SE5->E5_MOTBX == "CMP" .OR. SE5->(E5_VRETPIS + E5_VRETCOF + E5_VRETCSL)+ If(lIrfMP232,SE5->E5_VRETIRF,0) > 0
					
					SE2->(dbSetOrder(1))
					SE2->(MsSeek(xFilial("SE2")+SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)))
               
					//aTitulos
					//[1] Chave do titulo
					//[2]	Valor Baixado bruto
					//[3]	PCC Retido
					//[4]	PCC Retido em baixa intermediaria (sera somado para compor a proporcao na ultima baixa)
															
					If SE5->E5_MOTBX == "CMP" .AND. !SE5->E5_TIPO $ MVPAGANT

						If lIrfMP232
							nVlrTit := SE2->(E2_VALOR+E2_ISS+E2_INSS)
						Else
							nVlrTit := SE2->(E2_VALOR+E2_IRRF+E2_ISS+E2_INSS)
						Endif
	
						If lSest
							nVlrTit += SE2->E2_SEST
						Endif					
	
						If lCalcIssBx
							nVlrTit -= SE2->E2_ISS
						Endif
	
						//Array para somar os valores de titulo e valores baixados
						If (nX := Ascan(aTitulos,{|x| x[1] == SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)})) == 0
							aadd(aTitulos,{SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA),nVlrTit,0,0})
							nX := Len(aTitulos)
							aTitulos[nX,2] := nVlrTit		//Somo as bases
						Endif
						aTitulos[nX,3]+= SE5->(E5_VALOR+E5_VLDESCO-E5_VLJUROS-E5_VLMULTA)
					EndIf

					If (Ascan(aTitBsImp,{|x| x == SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ)})) = 0
						
						If !(SE5->E5_MOTBX $ "PCC#CMP#FAT")
							//Armazeno os valores calculados por titulo.
							If SE2->E2_PIS > 0 .And. !SE5->E5_TIPO $ MVPAGANT  
								aDadosImp[1] += SE2->E2_PIS * nProp
								lGravou := .T.
							EndIf	
				
							If SE2->E2_COFINS > 0 .And. !SE5->E5_TIPO $ MVPAGANT  
								aDadosImp[2] += SE2->E2_COFINS * nProp
								lGravou := .T.							
							EndIf	
		
							If SE2->E2_CSLL > 0 .And. !SE5->E5_TIPO $ MVPAGANT  
								aDadosImp[3] += SE2->E2_CSLL * nProp
								lGravou := .T.							
							EndIf
						EndIf	       
						
						//Somo valores dos impostos de IRRF/ISS/INSS dos titulos que foram compensados
						//por PA que nใo reteve impostos, para recompor a base de calculo
						If SE2->(E2_IRRF+E2_ISS+E2_INSS) > 0 .AND. !SE5->E5_TIPO $ MVPAGANT .And.;
							SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)!= cChaveTit
							aAreaSE5 := SE5->(GetArea())                                 
							//Seleciono SE5 sem Indregua (NEWSE5)
							dbSelectArea("NEWSE5")
							dbSetOrder(7)
							If MsSeek(xFilial("SE5")+SUBSTR(SE5->E5_DOCUMEN,1,nTamTit)+SE5->E5_FORNADT+SE5->E5_LOJAADT)							  
								If	NEWSE5->E5_PRETPIS == "1" .Or. NEWSE5->E5_PRETCOF == "1" .Or. NEWSE5->E5_PRETCSL == "1" 
									aDadosImp[4] += SE2->(E2_IRRF+E2_ISS+E2_INSS)
									lGravou := .T.							
								EndIf
							EndIf                    
							RestArea(aAreaSE5)
						EndIf							
						
						//Somo valores dos impostos de IRRF/ISS/INSS dos titulos do tipo PA (Pagto Adiantado) 
						//que foram compensados, para recompor a base de calculo(nBaseImp) do PIS/COF/CSL
						If SE2->(E2_IRRF+E2_ISS+E2_INSS) > 0 .AND. SE5->E5_TIPO $ MVPAGANT .And.;
							SUBSTR(SE5->E5_DOCUMEN,1,nTamTit)+SE5->(E5_FORNADT+E5_LOJAADT) == cChaveTit							  
							aAreaSE5 := SE5->(GetArea())
							//Seleciono SE5 sem Indregua (NEWSE5)
							dbSelectArea("NEWSE5")
							dbSetOrder(7)
							If MsSeek(xFilial("SE5")+SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA))
								If AliasIndic("SFQ")
									SFQ->(dbSetOrder(2))
									cChaveSE5 := NEWSE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)
									If SFQ->(MsSeek(xFilial("SFQ")+"SE5"+cChaveSE5))
										lAchouPa := .T.
									EndIf							
								EndIf
								If	NEWSE5->E5_PRETPIS $ "1# " .Or. NEWSE5->E5_PRETCOF $ "1# " .Or. NEWSE5->E5_PRETCSL $ "1# " 
									aDadosImp[5] += SE2->(E2_IRRF+E2_ISS+E2_INSS)
									lGravou := .T.						
									AAdd( aRecnos, SE5->( RECNO() ) )	
								EndIf
							EndIf
							RestArea(aAreaSE5)
						EndIf							

						If lGravou
							AADD(aTitBsImp,SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ))
							lGravou := .F.
						Endif
					Endif				
				EndIf      
				
				nImpostos := 0  

				If SE5->E5_PRETCOF $ " #2#4"
					aDadosRef[1] += SE5->E5_VRETPIS * nProp2                                
					nImpostos += SE5->E5_VRETPIS * nProp2                                   
					//Armazeno os valores calculados por titulo, retirando os valores retidos
					If SE5->(E5_VRETPIS + E5_VRETCOF + E5_VRETCSL)+ If(lIrfMP232,SE5->E5_VRETIRF,0) > 0 .And.;
						!(SE5->E5_MOTBX $ "PCC#CMP#FAT") .And. !SE5->E5_TIPO $ MVPAGANT  
						aDadosImp[1] -= SE5->E5_VRETPIS * nProp2
					Endif
				EndIf 								

				If SE5->E5_PRETCOF $ " #2#4"
					aDadosRef[1] += SE5->E5_VRETCOF * nProp2
					nImpostos += SE5->E5_VRETCOF * nProp2
					//Armazeno os valores calculados por titulo, retirando os valores retidos
					If SE5->(E5_VRETPIS + E5_VRETCOF + E5_VRETCSL)+ If(lIrfMP232,SE5->E5_VRETIRF,0) > 0 .And.;
						!(SE5->E5_MOTBX $ "PCC#CMP#FAT") .And. !SE5->E5_TIPO $ MVPAGANT  					
						aDadosImp[2] -= SE5->E5_VRETCOF * nProp2
					Endif					
				EndIf 								
	
				If SE5->E5_PRETCSL  $ " #2#4"
					aDadosRef[1] += SE5->E5_VRETCSL * nProp2
					nImpostos += SE5->E5_VRETCSL * nProp2
					//Armazeno os valores calculados por titulo, retirando os valores retidos
					If SE5->(E5_VRETPIS + E5_VRETCOF + E5_VRETCSL)+ If(lIrfMP232,SE5->E5_VRETIRF,0) > 0 .And.;
						!(SE5->E5_MOTBX $ "PCC#CMP#FAT") .And. !SE5->E5_TIPO $ MVPAGANT  
						aDadosImp[3] -= SE5->E5_VRETCSL * nProp2
					Endif					
				EndIf 								
	
				If lIrfMP232
					If Empty( SE5->E5_PRETIRF )
						aDadosRef[1] += SE5->E5_VRETIRF
						nImpostos += SE5->E5_VRETIRF
					Endif
				EndIf 								

				If lCalcIssBx
					aDadosRef[1] += SE5->E5_VRETISS
				Endif
	
				//Guardo o valor dos impostos descontados para que seja recomposta a base de calculo
				If SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA) == cChaveTit
					//Caso o sistema gravar como valor de pagamento na baixa parcial, o valor da baixa menos os impostos
					//calculados, nใo ha a necessidade de recompor a base de calculo
					If lValPgto
						aDadosRef[7] += nImpostos
					EndIf
				Endif
	
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ	
				//ณ Adiciona ao array apenas os titulos que calcularam retencao         ณ  
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
						
				If	SE5->E5_PRETPIS == "1" .Or. SE5->E5_PRETCOF == "1" .Or. SE5->E5_PRETCSL == "1" 
					      
					If SE5->E5_PRETPIS == "1"
						aDadosRef[2] += SE5->E5_VRETPIS * nProp2
					EndIf	
	
					If SE5->E5_PRETCOF == "1"
						aDadosRef[3] += SE5->E5_VRETCOF * nProp2
					EndIf	
						
					If SE5->E5_PRETCSL == "1"
						aDadosRef[4] += SE5->E5_VRETCSL * nProp2       
					EndIf 	
					
					If lIrfMP232 .and. SE5->E5_PRETIRF == "1"
						aDadosRef[5] += SE5->E5_VRETIRF       
					EndIf 	
                     
					// Caso exista titulo de PA com pendencia de 
					// retencao, marco o flag para ser usado na baixa.					
					If SE5->E5_TIPO $ MVPAGANT
						lPendPA := .T.
					Endif					

					AAdd( aRecnos, SE5->( RECNO() ) )			

				// Acumula os valores das baixas realizadas parcialmente
				// para ser utilizada na analise de possiveis problemas 
				// de arredondamento que ocorrem na baixa total.
				ElseIf  Empty(SE5->E5_PRETPIS) .Or. Empty(SE5->E5_PRETCOF) .Or. Empty(SE5->E5_PRETCSL)

					If Empty(SE5->E5_PRETPIS)
						aValorBx[1] += SE5->E5_VRETPIS
					EndIf	
		
					If Empty(SE5->E5_PRETCOF)
						aValorBx[2] += SE5->E5_VRETCOF
					EndIf	
							
					If Empty(SE5->E5_PRETCSL)
						aValorBx[3] += SE5->E5_VRETCSL
					EndIf 	

				EndIf	

				// Caso exista uma CMP envolvendo um PA, marco flag para uso
				//	no momento da baixa para compor o valor a ser baixado.
				If SE5->E5_MOTBX = "CMP"
					lPaComp := .T.               
				Endif

				SE5->( dbSkip() ) 								
						 
			EndDo          
			NEWSE5->(dbCloseArea())			
			dbSelectArea("SE5")
			dbClearFil()
			RetIndex( "SE5" )
			If !Empty(cIndexSE5)
				FErase (cIndexSE5+OrdBagExt())
			Endif
			dbSetOrder(1)

			//Titulos em bordero que tem retencao de PCC pendente
			//Exemplo:
			//3 titulos de 4000 com calculo de PCC
			//Coloque o primeiro titulo em bordero e ao baixar o segundo, o imposto devera
			//ser calculado por 8000 (soma dois titulos)
			//Se baixar ou gerar bordero para o terceiro
			If lSE2DtBor				

				dbSelectArea("SE2")
				dbSetOrder(1)
				cQuery := "E2_FILIAL='"      + xFilial( "SE2" )     + "' .AND. "
				
				If Len(aFor10925) > 0  //Verificar determinados fornecedores (raiz do CNPJ)
					cQuery += "( " 	
					For nLoop := 1 to Len(aFor10925) 
						cQuery += "(E2_FORNECE ='"   + aFor10925[nLoop,1]  + "' .AND. " 	
						cQuery += "E2_LOJA='"       + aFor10925[nLoop,2]  + "') .OR."
					Next			
					// Retiro o ultimo OR
					cQuery := Left( cQuery, Len( cQuery ) - 5 ) 
					cQuery += ") .AND. " 	
				Else  //Apenas Fornecedor e Loja atuais
					cQuery += "E2_FORNECE ='"     + SE2->E2_FORNECE        + "' .AND. " 	
					cQuery += "E2_LOJA='"        + SE2->E2_LOJA           + "' .AND. "
				Endif
				
				//Verifico o parametro e se o campo existe na base
				cQuery += "(DTOS(E2_DTBORDE)>='" + DToS( dDataIni ) + "' .AND. "		
				cQuery += "DTOS(E2_DTBORDE)<= '" + DToS( dDataFim ) + "') " 
				cQuery += ".AND. !(E2_TIPO $ '"+MVABATIM + "/" + MV_CPNEG + "/" + MVPROVIS + "/" + MVPAGANT+"') .AND."
				cQuery += "(E2_SALDO>0 .OR. E2_NUMBOR <> '"+SPACE(nLenNumBor)+"') .AND. "
				cQuery += "(E2_SALDO>0 .OR. E2_NUMBOR <> '"+SPACE(nLenNumBor)+"') .AND. "
				cQuery += "E2_NUMBOR <> '"+SPACE(nLenNumBor)+"' .AND. " 	
				cQuery += "(E2_PRETPIS = '1' .OR. E2_PRETCOF = '1' .OR. E2_PRETCSL = '1' ) .AND. "		

				If lIrfMP232
					cQuery += " (E2_PIS > 0 .OR. E2_COFINS > 0 .OR. E2_CSLL > 0 .OR. E2_IRRF > 0 ) .AND. "
				Else
					cQuery += " (E2_PIS > 0 .OR. E2_COFINS > 0 .OR. E2_CSLL > 0 ) .AND. "
				Endif

				//Verificar ou nao o limite de 5000 para Pis cofins Csll
				// 1 = Verifica o valor minimo de retencao
				// 2 = Nao verifica o valor minimo de retencao (NAO SERAO CONSIDERADOS PARA A SOMA DOS 5000)
				If lCpoVlMin
					cQuery += " E2_APLVLMN <> '2' "
				Endif	  

				cAliasQRY := "TRBSE2"				
				ChkFile("SE2",.F.,cAliasQRY)
				cIndexSe2	:= CriaTrab(nil,.f.)
				IndRegua(cAliasQRY,cIndexSe2,"DTOS(E2_VENCREA)",,cQuery,"")
				nIndexSe2 := RetIndex("SE2",cAliasQRY)
				dbSetIndex(cIndexSe2+OrdBagExt())
				(cAliasQRY)->(dbSetOrder(nIndexSe2+1))
				(cAliasQRY)->(dbGoTop()) 
				
				While !( cAliasQRY )->( Eof()) 
					
					If lIrfMP232
						nVlrTit := ( cAliasQRY )->(E2_VALOR+E2_ISS+E2_INSS)
					Else
						nVlrTit := ( cAliasQRY )->(E2_VALOR+E2_IRRF+E2_ISS+E2_INSS)
					Endif
		
					If lSest
						nVlrTit += ( cAliasQRY )->E2_SEST
					Endif					
		
					If lCalcIssBx
						nVlrTit -= ( cAliasQRY )->E2_ISS
					Endif			

					aDadosRef[1] += nVlrTit

					//Armazeno os valores calculados por titulo.
					aDadosImp[1] += (cAliasQRY)->E2_PIS
					aDadosRef[2] += (cAliasQRY)->E2_PIS

					aDadosImp[2] += (cAliasQRY)->E2_COFINS
					aDadosRef[3] += (cAliasQRY)->E2_COFINS							

					aDadosImp[3] += (cAliasQRY)->E2_CSLL
					aDadosRef[4] += (cAliasQRY)->E2_CSLL							
	
					//Guardo registros para acertar a pendencia de retencao
					AAdd( aRecnosSE2, (cAliasQRY)->(RECNO())) 
					( cAliasQRY )->( dbSkip()) 
			
				EndDo 

				// Fecha a area de trabalho da query 
				( cAliasQRY )->( dbCloseArea() ) 
				dbSelectArea( "SE2" ) 
				dbSetOrder(1)				
			Endif	

		#ENDIF    

	Next	

	aDadosRef[ 6 ] := AClone( aRecnos )            

	// Caso exista algum PA com pendencia de reten็ใo mesmo 
	// apos uma compensa็ใo (que ainda nao gerou os impostos), 
	// marcar flag para q seja verificado a diferenca baixada.
	If lPendPA .And. lPaComp
		lAbatPA := .T.
	Endif
Endif
cFilAnt := cFilAtu
RestArea(aArea)
aDadosRet := aClone(aDadosRef)

//Calculo do Pis, Cofins e Csll
If !lCalcPA //Se nao for inclusao de PA
	SE2->(dbGoto(nSE2Reg))
	SED->(dbSetOrder(1))
	SED->(MsSeek(xFilial("SED")+SE2->E2_NATUREZ))
	SA2->(dbSetOrder(1))
	SA2->(MsSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA))
	
	//Se considera valores de multa juros desconto ou se a valida็ใo partiu do campo de valor
	If lJurMulDes .or. lAltValor 
		nBaseImp := nValPgto+nValComp
	Else	
		nBaseImp := nValPgto+nDescont+nTotAbat-nJuros-nMulta-nAcresc+nDecresc
	Endif
	
	lImpInFat := .F.	

	If lIrfMP232
		nValOutImp := SE2->(E2_INSS+E2_ISS)
	ElseIf 'NOTFAT' $ SE2->E2_FATURA
		nValOutImp := f080OutImp(nValPgto)
		lImpInFat := .T.	
	Else
		nValOutImp := SE2->(E2_IRRF+E2_INSS+E2_ISS)
	Endif

	If !lImpInFat	
		If lSest
			nValOutImp += SE2->E2_SEST
		Endif
		
		If lCalcIssBx
			nValOutImp -= SE2->E2_ISS 
		Endif			
	Endif

	//Verifica็ใo para diferenciar se for baixa parcial
	lAltBxVal := STR(SE2->E2_VALOR,17,2) != STR(SE2->E2_SALDO,17,2)

	If !lAltValor                                            
		nBaseImp += nValOutImp + aDadosRet[7] + aDadosImp[4] - aDadosImp[5] + nValComp
	Endif
	
	//Caso o titulo possua o valor de base dos impostos preenchidos, considero
	//esse valor com base para calculo, desprezando o valor da nota fiscal
	nValTit := SE2->E2_VALOR + nValOutImp		//valor bruto do titulo reconstituido (valor + outros impostos)
	If SE2->E2_BASEPIS > 0
		nProp := SE2->E2_BASEPIS/nValtit				//Proporcao entre a base e o valor bruto do titulo
		nValTit := SE2->E2_BASEPIS
		If !lAltValor
			nBaseImp := SE2->E2_BASEPIS				//Base liquida para calculo dos impostos
		Else
			nBaseImp	:= nBaseImp * nProp
		EndIf
	Else
		nProp := 1
		If !lAltValor
			nBaseImp := nValTit				//Base liquida para calculo dos impostos
		Else
			nBaseImp	:= nBaseImp * nProp
		EndIf
	Endif	

	//Procura pelas baixas deste titulo caso seja baixa parcial e esteja baixando em mes diferente
	If lAltBxVal .And. !lAltValor
		aBaixa := Sel080Baixa("VL /BA /CP /",SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,@nTotAdto,@lBaixaAbat,SE2->E2_FORNECE,SE2->E2_LOJA,@lBxCec,.F.,@lNotBax,@nTotImpost,@lAglImp,.T.)	
		For nY := 1 to Len(aBaixaSE5)
			If !aBaixaSE5[nY][4] $ MVPAGANT
				nBaseImp -= ((aBaixaSE5[nY][8] * nProp) + If(lValPgto,aBaixaSE5[nY][15]+aBaixaSE5[nY][16]+aBaixaSE5[nY][17],0))
			EndIf
		Next
	Endif 
		
	//Base diferenciada para calculo dos impostos
	nBaseRet := nBaseImp += nValComp
	

	//Se for fatura, a base de impostos deve considerar o somatorio dos outros impostos
	//para verificacao do valor acima de 5000.
	//Isto jแ eh feito normalmente para os titulos nao gerados por fatura
	If lImpInFat
		nBaseRet += nValOutImp
	Endif

	//IRRF
	If lIrfMP232 .and. SE2->E2_IRRF > 0
		nIrrf := NoRound(( nBaseImp * SE2->E2_IRRF ) / nValTit ,2)
	EndIf

	//PIS
	If SE2->E2_PIS > 0 
		nPis := NoRound(( nBaseImp * SE2->E2_PIS ) / nValTit ,2)
		If cNCCRet == "2" .And. aDadosImp[1] <> aDadosRet[2] .And. SE2->E2_SALDO > 0  //!lAltValor .And. 
			nPis += If (aDadosImp[1] > 0, aDadosImp[1], 0)
			If nPis < 0
				nPis := 0
			EndIf
		EndIf
	EndIf

   // COFINS
	If SE2->E2_COFINS > 0  
		nCofins := NoRound(( nBaseImp * SE2->E2_COFINS ) / nValTit ,2)
		If cNCCRet == "2" .And. aDadosImp[2] <> aDadosRet[3] .And. SE2->E2_SALDO > 0  // !lAltValor .And.
			nCofins += If (aDadosImp[2] > 0, aDadosImp[2], 0)
			If nCofins < 0
				nCofins := 0
			EndIf
		EndIf
	EndIf

	// CSLL
	If SE2->E2_CSLL > 0  
		nCsll := NoRound(( nBaseImp * SE2->E2_CSLL ) / nValTit ,2) 
		If cNCCRet == "2" .And. aDadosImp[3] <> aDadosRet[4] .And. SE2->E2_SALDO > 0  // !lAltValor .And.
			nCsll += If (aDadosImp[3] > 0, aDadosImp[3], 0)
			If nCsll < 0
				nCsll := 0
			EndIf
		EndIf
	EndIf
Else
	SED->(dbSetOrder(1))
	SED->(MsSeek(xFilial("SED")+M->E2_NATUREZ))
	SA2->(dbSetOrder(1))
	SA2->(MsSeek(xFilial("SA2")+M->E2_FORNECE+M->E2_LOJA))

	//Se considera valores de multa juros desconto ou se a valida็ใo partiu do campo de valor
	If lJurMulDes .or. lAltValor 
		nBaseImp := nValPgto
	Else	
		nBaseImp := nValPgto+nDescont+nTotAbat-nJuros-nMulta-nAcresc+nDecresc
	Endif

	lImpInFat := .F.	

	If lIrfMP232
		nValOutImp := M->(E2_INSS+E2_ISS)
	ElseIf 'NOTFAT' $ M->E2_FATURA
		nValOutImp := f080OutImp(nValPgto)
		lImpInFat := .T.	
	Else
		nValOutImp := M->(E2_IRRF+E2_INSS+E2_ISS)
	Endif

	If !lImpInFat	
		If lSest
			nValOutImp += M->E2_SEST
		Endif
		
		If lCalcIssBx
			nValOutImp -= M->E2_ISS 
		Endif			
	Endif
	
	If !lCalcPA
		nValTit := M->E2_VALOR + nValOutImp
	Else
	   If M->E2_BASEPIS > 0
			nValTit := M->E2_BASEPIS + nValOutImp
		Else
			nValTit := M->E2_VALOR + nValOutImp			
		Endif
		If !M->E2_TIPO $ MVPAGANT		
			nBaseImp := nBaseImp - nValOutImp
		Endif
	Endif

	If !lAltValor
		nBaseImp += nValOutImp + aDadosRef[7]
	Endif
	
	//Verifica็ใo para diferenciar se for baixa parcial
	lAltBxVal := STR(SE2->E2_VALOR,17,2) != STR(SE2->E2_SALDO,17,2) 
	
	//Base diferenciada para calculo dos impostos
	nBaseRet := nBaseImp
	If lBaseSe2
		If M->E2_BASEPIS > 0
			nBaseRet := (M->E2_BASEPIS * nBaseImp) / nValTit
		Endif 
	Endif			
	//Se for fatura, a base de impostos deve considerar o somatorio dos outros impostos
	//para verificacao do valor acima de 5000.
	//Isto jแ eh feito normalmente para os titulos nao gerados por fatura
	If lImpInFat
		nBaseRet += nValOutImp
	Endif

	//IRRF
	If lIrfMP232 .and. M->E2_IRRF > 0
		nIrrf := ( nBaseImp * M->E2_IRRF ) / nValTit
	EndIf

	//PIS
	If M->E2_PIS > 0
		nPis := ( nBaseImp * M->E2_PIS ) / nValTit
		If !lAltValor .And. cNCCRet == "2" .And. aDadosImp[1] <> aDadosRet[2] .And.	SE2->E2_SALDO > 0
			nPis += If (aDadosImp[1] > 0, aDadosImp[1], 0)
			If nPis < 0
				nPis := 0
			EndIf
		EndIf
	EndIf

   // COFINS
	If M->E2_COFINS > 0
		nCofins := ( nBaseImp * M->E2_COFINS ) / nValTit
		If !lAltValor .And. cNCCRet == "2" .And. aDadosImp[2] <> aDadosRet[3] .And. SE2->E2_SALDO > 0 
			nCofins += If (aDadosImp[2] > 0, aDadosImp[2], 0)
			If nCofins < 0
				nCofins := 0
			EndIf
		EndIf
	EndIf

	// CSLL
	If M->E2_CSLL > 0
		nCsll := ( nBaseImp * M->E2_CSLL ) / nValTit
		If !lAltValor .And. cNCCRet == "2" .And. aDadosImp[3] <> aDadosRet[4] .And. SE2->E2_SALDO > 0 
			nCsll += If (aDadosImp[3] > 0, aDadosImp[3], 0)
			If nCsll < 0
				nCsll := 0
			EndIf
		EndIf
	EndIf

Endif	

If lFa080PCC
	ExecBlock("FA080PCC",.F.,.F.,{nPis, nCofins, nCsll, nIrrf, nValTit})
Endif

//Verifico o valor a reter
If lContrRet
   //Nao retem Pis,Cofins,CSLL
	If cModRetPis == "3"  //Nao retem PIS
		nVlRetPis := nPis
		nVlRetCof := nCofins
		nVlRetCsl := nCsll
		nPis := 0
		nCofins := 0
		nCsll := 0
		If lIrfMP232
			nVlRetIrf := nIrrf
			nIrrf := 0
		Endif			
	Else
		//Calculo do Sistema
		IF cModRetPis == "1"
			If aDadosRet[1]+ (nBaseRet) <= nVlMinImp .and. lAplVlMin
				nVlRetPis := nPis
				nVlRetCof := nCofins
				nVlRetCsl := nCsll
				nPis := 0
				nCofins := 0
				nCsll := 0
				aDadosRet[2] := 0 
				aDadosRet[3] := 0 
				aDadosRet[4] := 0
			Endif			
			If lIrfMP232
				//Verifico o valor de retencao variando entre pessoa fisica
				// e juridica
				If SA2->A2_TIPO == "F"
					nVlMinIrf := MaTbIrfPF(nIrrf)[4]
				Else
					nVlMinIrf := nVlMinImp
				Endif
				
				If aDadosRet[1]+ (nBaseRet) <= nVlMinIrf
					nVlRetIrf := nIrrf
					nIrrf := 0
				Endif			
			Endif
		Endif

		If nPis+nCofins+nCsll+nIrrf+ aDadosRet[2]+ aDadosRet[3]+ aDadosRet[4] > 0
			If nPis+nCofins+nCsll+aDadosRet[2]+ aDadosRet[3]+ aDadosRet[4] > 0
				nVlRetPis := nPis
				nVlRetCof := nCofins
				nVlRetCsl := nCsll
				nPis    := nVlRetPis + aDadosRet[2]
				nCofins := nVlRetCof + aDadosRet[3]
				nCsll   := nVlRetCsl + aDadosRet[4]
				// Caso nใo seja inclusใo de PA
				If !lCalcPa                 
					// Se o valor a ser baixado for igual ao saldo, e se
					// existiu uma compensacao, cuido para que nao ocorra
					// problemas de arredondamento na baixa.
					If nValPgto == SE2->E2_SALDO .And. (aValorBx[1]+aValorBx[2]+aValorBx[3] > 0)
						If nPis <> SE2->E2_PIS .And. lAbatPA
							nPis := nPis + (SE2->E2_PIS - (nPis + aValorBx[1]))
						Endif								
						If nCofins <> SE2->E2_COFINS .And. lAbatPA
							nCofins := nCofins + (E2_COFINS - (nCofins + aValorBx[2]))
						Endif
						If nCsll <> SE2->E2_CSLL .And. lAbatPA
							nCsll := nCsll + (SE2->E2_CSLL - (nCsll + aValorBx[3]))
						Endif						                      
					Endif
				Endif
			Endif
			If lIrfMP232 .and. nIrrf > 0
				nVlRetIrf := nIrrf
				nIrrf := nVlRetIrf+ aDadosRet[5]
			Endif			
			nValorPg := nValPgto - nPis - nCofins - nCsll - nIrrf - nIss

			If nValorPg < 0
				nValorPg += nPis + nCofins + nCsll + nIrrf + nIss
			
				nTotARet := nPis + nCofins + nCsll + nIrrf + nIss
						
				nDiferImp := nValorPg - nTotARet
					
				If nDiferImp < 0                                                           
					nFatorRed := 1 - ( Abs( nDiferImp ) / nTotARet ) 
					nPis  := NoRound( nPis * nFatorRed, 2 ) 
					nCofins := NoRound( nCofins * nFatorRed, 2 )  						
					nIrrf	:= NoRound( nIrrf * nFatorRed, 2 )
					nCsll := nValorPg - ( nPis + nCofins + nIrrf )
				Endif		
			EndIf 
		Else
			//Natureza nao calculou Pis/Cofins/Csll
			aDadosRet[1] := 0
		Endif
	Endif
Endif	

SE2->( RestArea( aAreaSE2 ) ) 

//Ponto de entrada para manipular os valores de impostos(nPis, nCofins, nCsll)
If lImp10925
	ExecBlock("FA080IMP",.F.,.F.)
EndIf

If !lAltValor .or. lAltData
	nValPgto -= nPis+nCofins+nCsll+nIrrf+nIss
Endif

nOldValPgto := nValPgto
nOldPIS		:= nPis
nOldCofins	:= nCofins
nOldCSLL	:= nCsll

RETURN lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณFaPCCMovBcณ Autor ณNilton Pereira         ณ Data ณ31/05/05  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Funcao para verificar o nao se o motivo de baixa gerou     ณฑฑ
ฑฑณ          ณ movimento bancario                                         ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ Tratamento da lei 10925                                    ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FaPCCMovBc(cMotInfo)

// Considera baixas que geram ou nao movimento bancario.
// 1 = Somente os motivos que geram movimento bancario
// 2 = Considera todos os motivos de baixa.
Local lMotBxMBco  := (SuperGetMv("MV_MB10925",.t.,"2") == "1")
Local lMovBco  := .F.     

Default cMotInfo := ""

// Consiste se o motivo gera ou nao movimento bancario.
If lMotBxMBco              
	If Empty(cMotInfo) 
		//Se movimenta banco (motivo completo)
		If MovBcoBx(cMotBx,.T.) 
			lMovBco := .T. 
		Endif
	Else
		//Se movimenta banco (motivo resumido)      
		If MovBcoBx(cMotInfo,.F.) 
			lMovBco := .T. 
		Endif
	Endif
Endif

Return lMovBco

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณFaPCCBaixaณ Autor ณ --------------------- ณ Data ณ -------- ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Verifica se existe a baixa por PCC para o titulo posicio-  ณฑฑ
ฑฑณ          ณ nado.                                                      ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ AP                                                         ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FaPCCBaixa(nRecSE5)

LOCAL lRet	 	:= .F.
LOCAL aArea		:= GetArea()
LOCAL cQuery 	:= ""
LOCAL aFields	:= {}
LOCAL nX		:= 0

// Regra dos campos PRET
// Pelo SE2
// "1" - Pendente / "2" - Retido em outro titulo / "3" - Retentor
// Pelo SE5
// " " - Retentor / "1" - Pendente / "2" - Retido em outro titulo

cQuery := "SELECT SE5.E5_FILIAL, SE5.E5_PREFIXO, SE5.E5_NUMERO, SE5.E5_PARCELA, SE5.E5_TIPO, SE5.E5_FORNECE, SE5.E5_LOJA, "
cQuery += "SE5.E5_VALOR, SE5.E5_VRETPIS, SE5.E5_VRETCOF, SE5.E5_VRETCSL, SE5.E5_PRETPIS, SE5.E5_PRETCOF, SE5.E5_PRETCSL, "
cQuery += "SE5.E5_SITUACA, SE5.R_E_C_N_O_ SE5RECNO "
cQuery += "FROM "+RetSqlName("SE5")+" SE5 WHERE "
cQuery += "SE5.E5_FILIAL = '"	+SE2->E2_FILIAL+	"' AND "
cQuery += "SE5.E5_PREFIXO = '"	+SE2->E2_PREFIXO+	"' AND "
cQuery += "SE5.E5_NUMERO = '"	+SE2->E2_NUM+		"' AND "
cQuery += "SE5.E5_PARCELA = '"	+SE2->E2_PARCELA+	"' AND "
cQuery += "SE5.E5_TIPO = '"		+SE2->E2_TIPO+		"' AND "
cQuery += "SE5.E5_CLIFOR = '"	+SE2->E2_FORNECE+	"' AND "
cQuery += "SE5.E5_LOJA = '"		+SE2->E2_LOJA+		"' AND "
cQuery += "SE5.E5_DOCUMEN = '"	+SE2->E2_NUMBOR+	"' AND " // PROTEวรO A BAIXAS POR PCC "SEM PAI" E QUE NรO ESTEJAM CANCELADAS
cQuery += "SE5.E5_MOTBX = 'PCC' AND "
cQuery += "SE5.E5_SITUACA != 'C' AND "
cQuery += "SE5.E5_PRETPIS NOT IN ('1','2') AND "
cQuery += "SE5.E5_PRETCOF NOT IN ('1','2') AND "
cQuery += "SE5.E5_PRETCSL NOT IN ('1','2') "
cQuery += "ORDER BY SE5.R_E_C_N_O_"
cQuery := ChangeQuery(cQuery)

IF Select("SE5QRY") > 0
	DbSelectArea("SE5QRY")
	DbCloseArea()
ENDIF

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "SE5QRY", .F., .T.)

AADD(aFields,{"E5_VRETPIS"	,"N",18,2})
AADD(aFields,{"E5_VRETCOF"	,"N",18,2})
AADD(aFields,{"E5_VRETCSL"	,"N",18,2})
AADD(aFields,{"E5_VALOR"	,"N",18,2})

For nX := 1 To Len(aFields)
	TcSetField("SE5QRY",aFields[nX][1],aFields[nX][2],aFields[nX][3],aFields[nX][4])
Next nX

DbSelectArea("SE5QRY")
DbGoTop()
WHILE SE5QRY->(!EOF())
	nPis 	:= SE5QRY->E5_VRETPIS
	nCofins := SE5QRY->E5_VRETCOF
	nCSLL	:= SE5QRY->E5_VRETCSL
	nValPgto:= SE5QRY->E5_VALOR
	nRecSE5 := SE5QRY->SE5RECNO
	lRet := .T.
	EXIT
END

IF Select("SE5QRY") > 0
	DbSelectArea("SE5QRY")
	DbCloseArea()
ENDIF

RestArea(aArea)
RETURN lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณFaParcBx  ณ Autor ณ --------------------- ณ Data ณ -------- ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Verifica se o titulo baixa por PCC para o titulo posicio-  ณฑฑ
ฑฑณ          ณ nado.                                                      ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ AP                                                         ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
STATIC FUNCTION FaParcBx()

LOCAL aBaixa	:= {}

ABAIXASE5		:= {}
aBaixa := Sel080Baixa("VL /BA /CP /",SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,0,.F.,SE2->E2_FORNECE,SE2->E2_LOJA,.F.,.T.,.F.,0,.F.)

RETURN Len(aBaixa) > 1
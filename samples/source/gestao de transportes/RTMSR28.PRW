#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³RTMSR28   ³ Autor ³Katia                  ³ Data ³07/05/13  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao responsavel por imprimir o DAMDFE                    ³±±
±±³          ³                                                            ³±±
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
User Function RTMSR28()
Local aCab			:= {}
Local oFont08		:= TFont():New("Times New Roman",08,08,,.F.,,,,.T.,.F.)
Local oFont08N		:= TFont():New("Times New Roman",08,08,,.T.,,,,.T.,.F.)
Local oFont10		:= TFont():New("Times New Roman",10,10,,.F.,,,,.T.,.F.)
Local oFont10N		:= TFont():New("Times New Roman",10,10,,.T.,,,,.T.,.F.)
Local cPerg			:= 'RTMSR28'
Local nCont			:= 0
Local lSeqDes		:= .F.
//-- Buscar dados XML
Local aNotas		:= {}
Local aXML			:= {}
Local cAviso		:= ""
Local cErro			:= ""
Local cAutoriza		:= ""
Local cModalidade	:= ""
Local cIdEnt		:= ""
Local nX			:= 0
Local cStartPath
Local cSerie        := Padr(0,Len(DT6->DT6_SERIE))
Local cModelo		:= "58"
Local nLinha		:= 0
Local nCount		:= 0
Local cFilePrint    := ""
Local nQCTE         := 0
Local nQCT          := 0
Local cHoraBase     := ""
Local cCiot			:= ""

//-- Variaveis Private
Private cAliasMDF	:= GetNextAlias()
Private oDamdfe
Private nLInic		:= 0	// Linha Inicial
Private nLFim		:= 0	// Linha Inicial
Private nDifEsq		:= 0	// Variavel com Diferenca para alinhar os Print da Esquerda com os da Direita
Private cInsRemOpc	:= ''	// Remetente com sequencia de IE
Private nFolhas		:= 0
Private nFolhAtu	:= 1
Private PixelX		:= nil
Private PixelY		:= nil
Private nMM			:= 0
Private lXml		:= .T.
Private lComp		:= .F.	//CTE Complementar
Private oNfe        
                                                                                  
//Verifica se o arquivo sera gerado em Remote Linux
cStartPath := GetTempPath(.t.)

AjustaSX1()

//-- MV_PAR01 - Informe lote inicial.
//-- MV_PAR02 - Informe lote final.
//-- MV_PAR03 - Informe documento inicial.
//-- MV_PAR04 - Informe documento final.
//-- MV_PAR05 - Informe serie do documento inicial.
//-- MV_PAR06 - Informe serie do documento final.
//-- MV_PAR07 - Informe tipo do documento.
//-- MV_PAR08 - Buscar XML do WebService.
If !Pergunte(cPerg,.T.)
	Return()
EndIf
                    
If	!TMSSpedNFe(@cIdEnt,@cModalidade,,,cModelo)
	Return()
EndIf

//Se for contingencia nao busca do XML
If SubStr(cModalidade,1,1) == '2'
	lXml = .F.                   	
EndIf

// Cria Arquivo de Trabalho - Documentos de Transporte
cAliasMDF := DataSource( 'DTX' )
                         
cFilePrint:= "DAMDFE_"+cIdEnt+Dtos(MSDate())+StrTran(Time(),":","")

oDamdfe:=FWMSPrinter():New(cFilePrint,IMP_PDF,.F.,cStartPath,.T.,,@oDamdfe,,,,,.T.)
oDamdfe:SetResolution(72)
oDamdfe:SetLandscape()
oDamdfe:SetPaperSize(DMPAPER_A4)
oDamdfe:SetMargin(60,60,60,60)

PixelX  := oDamdfe:nLogPixelX()
PixelY  := oDamdfe:nLogPixelY()
nMM     := 0

While !(cAliasMDF)->(Eof())
	nCount:= 1
	oDamdfe:StartPage()

	//-- Buscar XML do WebService
	If lXml
		aNotas := {}
		aadd(aNotas,{})
		aAdd(Atail(aNotas),.F.)

		aadd(Atail(aNotas),"") 
		aAdd(Atail(aNotas),"")
		aAdd(Atail(aNotas),cSerie) 
		aAdd(Atail(aNotas),(cAliasMDF)->DTX_MANIFE) //Documento
		aadd(Atail(aNotas),"")
		aadd(Atail(aNotas),"")
	   
		nX   := 1
		aXml := {}
		aXml := TMSGetXML(cIdEnt,aNotas,@cModalidade,cModelo)
		If !Empty(aXML[nX][2])
			If !Empty(aXml[nX])
				cAutoriza   := aXML[nX][1]
				cCodAutDPEC := aXML[nX][5]
			Else
				cAutoriza   := ""
				cCodAutDPEC := ""
			EndIf
			cAviso := ""
			cErro  := ""
			oNfe := XmlParser(aXML[nX][2],"_",@cAviso,@cErro)
			oNfeDPEC := XmlParser(aXML[nX][4],"_",@cAviso,@cErro)
		EndIf
	EndIf

	nFolhas := 1
	
	If Type( 'oNFE' ) == 'U'
		lXml := .F. //Restricao de errorlog devido ao xml retornado
	EndIf                                        
	
	cHoraBase:= StrTran(Left(Time(),5),':','')
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Controla o documento a ser enviado para montagem do cabecalho.         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nCont += 1
	If lXml
		aAdd(aCab, {;
		AllTrim((cAliasMDF)->DTX_MANIFE),;
		AllTrim(oNfe:_MDFE:_INFMDFE:_IDE:_SERIE:TEXT),;
		AllTrim(STRTRAN( SUBSTR( oNfe:_MDFE:_INFMDFE:_IDE:_dhEmi:TEXT, 1, AT('T', oNfe:_MDFE:_INFMDFE:_IDE:_dhEmi:TEXT) - 1) , '-', '')),;
		AllTrim(STRTRAN( SUBSTR( oNfe:_MDFE:_INFMDFE:_IDE:_dhEmi:TEXT, AT('T', oNfe:_MDFE:_INFMDFE:_IDE:_dhEmi:TEXT) + 1, 5) , ':', '')),;
		AllTrim(STRTRAN(UPPER(oNFE:_MDFE:_INFMDFE:_ID:TEXT),'MDFE','')),;
		AllTrim(aXML[nX][1]),;
		AllTrim((cAliasMDF)->DTX_CTGMDF),;
		aXML[nX][7],; 
		aXML[nX][6] })	
	Else
		aAdd(aCab, {;
		AllTrim((cAliasMDF)->DTX_MANIFE),;
		cSerie,;
		AllTrim((cAliasMDF)->DTX_DATMAN),;
		AllTrim((cAliasMDF)->DTX_HORMAN),;
		AllTrim((cAliasMDF)->DTX_CHVMDF),;
				(cAliasMDF)->DTX_PRIMDF,;
		AllTrim((cAliasMDF)->DTX_CTGMDF),;
		Iif((cAliasMDF)->DTX_FIMP == StrZero(1, Len(DTX->DTX_FIMP)), (cAliasMDF)->DTX_DATIMP, DtoS(dDataBase)),;
		Iif((cAliasMDF)->DTX_FIMP == StrZero(1, Len(DTX->DTX_FIMP)), (cAliasMDF)->DTX_HORIMP, cHoraBase) })
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Funcao responsavel por montar o cabecalho do relatorio                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nFolhAtu := 1
	lSeqDes  :=.F.
	TMSR28Cab(aCab[nCont],lXml)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ BOX: MODAL RODOVIARIO DE CARGA										   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	                                    
	oDamdfe:Box(0165, 0000, 180, 0800)                                    
	oDamdfe:Say(0175, 0350, "Modal Rodoviário de Carga", oFont08N)
	                                                                                                                                     
	oDamdfe:Box(0180, 0000, 230, 0800)                            
	oDamdfe:Say(0188, 0005, "CIOT", oFont08) 
	If lXml .And. Type("oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_CIOT") <> "U"
		cCiot:= oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_CIOT:TEXT
	Else  
		If DTR->(FieldPos("DTR_CIOT")) > 0  
			cCiot:= (cAliasMDF)->DTR_CIOT
		EndIf	
	EndIf	                         
	oDamdfe:Say(0208, 0010, cCiot, oFont10)	     
	
	oDamdfe:Box(0180, 0150, 230, 0800)              
	oDamdfe:Say(0188, 0155, "Qtd. CT-e", oFont08)	
	If lXml 
		If Type("oNfe:_MDFE:_INFMDFE:_TOT:_QCTE") <> "U"
			nQCTE:= oNfe:_MDFE:_INFMDFE:_TOT:_QCTE:TEXT
		EndIf	
	Else
		nQCTE:= (cAliasMDF)->DTX_QTDCTE
	EndIf	
	oDamdfe:Say(0208, 0160, cValtoChar( nQCTE ), oFont10)	
			                      
	oDamdfe:Box(0180, 0280, 230, 0800)                                    
	oDamdfe:Say(0188, 0285, "Qtd. CTRC", oFont08)
	If lXml 
		If Type("oNfe:_MDFE:_INFMDFE:_TOT:_QCT") <> "U"
			nQCT:= oNfe:_MDFE:_INFMDFE:_TOT:_QCT:TEXT
		EndIf                                                        		
	Else		                                                     
		nQCT:= ((cAliasMDF)->DTX_QTDDOC - (cAliasMDF)->DTX_QTDCTE)
	EndIf	                                                                    
	oDamdfe:Say(0208, 0295, cValtoChar(nQCT), oFont10)	
	
	oDamdfe:Box(0180, 0410, 230, 0800)                                    
	oDamdfe:Say(0188, 0415, "Qtd. NF-e", oFont08)                         
	
	oDamdfe:Box(0180, 0540, 230, 0800)                                    
	oDamdfe:Say(0188, 0545, "Qtd. NF", oFont08)
	
	oDamdfe:Box(0180, 0670, 230, 0800)                                    
	oDamdfe:Say(0188, 0675, "Peso Total (Kg)", oFont08)        
	If lXML
		nQCarga:= oNfe:_MDFE:_INFMDFE:_TOT:_QCARGA:TEXT
	Else
		nQCarga:= (cAliasMDF)->DTX_PESO
	EndIf	
	oDamdfe:Say(0208, 0685, cValtoChar(nQCarga), oFont10)        			

	oDamdfe:Box(0230, 0000, 245, 0300)                         
	oDamdfe:Say(0237, 0005, "Veículo", oFont08)                   
	
	oDamdfe:Box(0230, 0300, 245, 0800)                                    
	oDamdfe:Say(0237, 0305, "Condutor", oFont08)        

	oDamdfe:Box(0245, 0000, 260, 0150)                                    
	oDamdfe:Say(0252, 0005, "Placa", oFont08)        
	
	oDamdfe:Box(0245, 0150, 260, 0300)               
	oDamdfe:Say(0252, 0155, "RNTRC", oFont08)                   	

	oDamdfe:Box(0245, 0300, 260, 0400)                                    	
	oDamdfe:Say(0252, 0305, "CPF", oFont08)             
	
	oDamdfe:Box(0245, 0400, 260, 0800)                                    	
	oDamdfe:Say(0252, 0405, "Nome", oFont08)                             	                                                            

    //-- Dados da Placa
	oDamdfe:Box(0260, 0000, 310, 0150)            
	If lXml                        
		oDamdfe:Say(0270, 0005, AllTrim(oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_VEICTRACAO:_PLACA:TEXT), oFont08)
		If Type( 'oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_VEICREBOQUE:_PLACA' ) <> 'U'
			oDamdfe:Say(0278, 0005, AllTrim(oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_VEICREBOQUE:_PLACA:TEXT), oFont08)
		EndIf	
	Else
		cAliasDTR := DataSource( 'DTR' )	
		cCodVei:= ''
		cCodVei := (cAliasDTR)->DTR_CODVEI
		cAliasDA3 := DataSource( 'DA3' )			

		oDamdfe:Say(0270, 0005, AllTrim((cAliasDA3)->DA3_PLACA), oFont08)		

        //--- Reboque 1
		cCodVei := (cAliasDTR)->DTR_CODRB1
		cAliasDA3 := DataSource( 'DA3' )			
		oDamdfe:Say(0278, 0005, AllTrim((cAliasDA3)->DA3_PLACA), oFont08)		

        //--- Reboque 2
		cCodVei := (cAliasDTR)->DTR_CODRB2
		cAliasDA3 := DataSource( 'DA3' )			
		oDamdfe:Say(0286, 0005, AllTrim((cAliasDA3)->DA3_PLACA), oFont08)		

	EndIf	
	                   
	//--- Dados do RNTRC
	oDamdfe:Box(0260, 0150, 310, 0300)            
	If lXml                                                                                                                
	 	If Type('oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_VEICTRACAO:_PROP:_RNTRC') <> 'U'     
			oDamdfe:Say(0270, 0155, AllTrim(oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_VEICTRACAO:_PROP:_RNTRC:TEXT), oFont08)     
		EndIf	
		If Type( 'oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_VEICREBOQUE:_PROP:_RNTRC' ) <> 'U'
			oDamdfe:Say(0278, 0155, AllTrim(oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_VEICREBOQUE:_PROP:_RNTRC:TEXT), oFont08)     
		EndIf	
	Else
		oDamdfe:Say(0270, 0155, AllTrim((cAliasDA3)->A2_RNTRC), oFont08)				
	EndIf	
	
	//--- Vale Pedagio
	oDamdfe:Box(0310, 0000, 325, 0300)               
	oDamdfe:Say(0320, 0005, "Vale Pedágio", oFont08)                             	
	                                                
	oDamdfe:Box(0325, 0000, 390, 0300)               
	oDamdfe:Say(0335, 0005, "Responsável CNPJ", oFont08)                             	
	
	oDamdfe:Box(0325, 0100, 390, 0300)                                                 
	oDamdfe:Say(0335, 0105, "Fornecedora CNPJ", oFont08)                             	
		
	oDamdfe:Box(0325, 0200, 390, 0300)               	                                
	oDamdfe:Say(0335, 0205, "Nro Comprovante", oFont08)                             	

    //--- Dados Condutor CPF  e Nome
	oDamdfe:Box(0260, 0300, 390, 0400)  
	oDamdfe:Box(0260, 0400, 390, 0800)                                    	
                                       
 	If lXML
		If Type( "oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_VEICTRACAO:_CONDUTOR" ) <> "A" 
			oDamdfe:Say(0270, 0305, Transform(AllTrim(oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_VEICTRACAO:_CONDUTOR:_CPF:TEXT),"@r 999.999.999-99"), oFont08)
			oDamdfe:Say(0270, 0405, AllTrim(oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_VEICTRACAO:_CONDUTOR:_XNOME:TEXT), oFont08)                        	
		Else                                                                                                                   
			nLinha:= 270
			For nCount := 1 To Len( oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_VEICTRACAO:_CONDUTOR )
				oDamdfe:Say(nLinha, 0305, Transform(AllTrim(oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_VEICTRACAO:_CONDUTOR[nCount]:_CPF:TEXT),"@r 999.999.999-99"), oFont08)
				oDamdfe:Say(nLinha, 0405, AllTrim(oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_VEICTRACAO:_CONDUTOR[nCount]:_XNOME:TEXT), oFont08)
				nLinha+= 10
			Next nCount
		EndIf	
	Else
		cCodMoto := Posicione("DUP",1,xFilial('DUP')+(cAliasMDF)->DTX_FILORI+(cAliasMDF)->DTX_VIAGEM,'DUP_CODMOT')

		oDamdfe:Say(0270, 0305, Transform(AllTrim(Posicione("DA4",1,xFilial('DA4')+cCodMoto,'DA4_CGC')),"@r 999.999.999-99"), oFont08)
		oDamdfe:Say(0270, 0405, AllTrim(Posicione("DA4",1,xFilial('DA4')+cCodMoto,'DA4_NOME')), oFont08)                        		
	EndIf
	
	//--- Observacoes
	oDamdfe:Box(0390, 0000, 500, 0800)
	oDamdfe:Say(0400, 0005, "Observação", oFont08)    
	If (lXML .And. oNfe:_MDFE:_INFMDFE:_IDE:_TPAMB:TEXT == '2') .Or. ((cAliasMDF)->DTX_AMBIEN == 2) 
		oDamdfe:Say(0420, 0005, "MANIFESTO GERADO EM AMBIENTE DE HOMOLOGAÇÃO", oFont10N)    
	EndIf	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualizar o Status de Impressao no DAMDFE                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
	DTX->(dbSetOrder(1))
	If	DTX->(MsSeek(xFilial('DTX')+(cAliasMDF)->DTX_MANIFE)) .And. DTX->DTX_FIMP <> StrZero(1, Len(DTX->DTX_FIMP))
		RecLock('DTX',.F.)
		DTX->DTX_FIMP  := StrZero(1, Len(DTX->DTX_FIMP)) 
		DTX->DTX_DATIMP:= dDataBase
		DTX->DTX_HORIMP:= cHoraBase
		MsUnLock()
	EndIf                         	                                   	           
                         	                                   	
	oDamdfe:EndPage()
	
	(cAliasMDF)->(DbSkip())
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TERMINO ROTINA DE IMPRESSAO                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oDamdfe:Preview()

(cAliasMDF)->(dbCloseArea())

Return(.T.)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ TMSR28Cab³ Autor ³Katia                  ³ Data ³07/05/13  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao responsavel por montar o cabecalho do relatorio      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   |                                                            ³±±
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
Static Function TMSR28Cab(aCab,lXML)
Local oFont07    	:= TFont():New("Times New Roman",07,07,,.F.,,,,.T.,.F.)	//Fonte Times New Roman 07
Local oFont08    	:= TFont():New("Times New Roman",08,08,,.F.,,,,.T.,.F.)	//Fonte Times New Roman 08
Local oFont08N   	:= TFont():New("Times New Roman",08,08,,.T.,,,,.T.,.F.)	//Fonte Times New Roman 08 Negrito
Local oFont12N   	:= TFont():New("Times New Roman",12,12,,.T.,,,,.T.,.F.)	//Fonte Times New Roman 12 Negrito
Local cStartPath	:= GetSrvProfString("Startpath","")
Local cTmsAntt		:= SuperGetMv( "MV_TMSANTT", .F., .F. )	//Numero do registro na ANTT com 14 dígitos
Local cLogoTp		:= cStartPath + "logoCte.bmp"				//Insira o caminho do Logo da empresa, na variavel cLogoTp.
Local cUF           := ""
Local cCodEst       := ""
Local aUF           := {}
Local aAreaSM0      := {}
                                                    
If IsSrvUnix() .And. GetRemoteType() == 1
	cLogoTp := StrTran(cLogoTp,"/","\")
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Preenchimento do Array de UF                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd(aUF,{"RO","11"})
aAdd(aUF,{"AC","12"})
aAdd(aUF,{"AM","13"})
aAdd(aUF,{"RR","14"})
aAdd(aUF,{"PA","15"})
aAdd(aUF,{"AP","16"})
aAdd(aUF,{"TO","17"})
aAdd(aUF,{"MA","21"})
aAdd(aUF,{"PI","22"})
aAdd(aUF,{"CE","23"})
aAdd(aUF,{"RN","24"})
aAdd(aUF,{"PB","25"})
aAdd(aUF,{"PE","26"})
aAdd(aUF,{"AL","27"})
aAdd(aUF,{"MG","31"})
aAdd(aUF,{"ES","32"})
aAdd(aUF,{"RJ","33"})
aAdd(aUF,{"SP","35"})
aAdd(aUF,{"PR","41"})
aAdd(aUF,{"SC","42"})
aAdd(aUF,{"RS","43"})
aAdd(aUF,{"MS","50"})
aAdd(aUF,{"MT","51"})
aAdd(aUF,{"GO","52"})
aAdd(aUF,{"DF","53"})
aAdd(aUF,{"SE","28"})
aAdd(aUF,{"BA","29"})
aAdd(aUF,{"EX","99"})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ BOX: Empresa 						                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oDamdfe:Box(0036, 0000, 0140, 0400)
oDamdfe:SayBitmap(0038, 0005,cLogoTp,0300,0040 )		//Logo
oDamdfe:Say(0098, 0005, 'CNPJ: ' + Iif(lXML,(Transform(oNfe:_MDFE:_INFMDFE:_EMIT:_CNPJ:TEXT,"@r 99.999.999/9999-99")), Transform(AllTrim(SM0->M0_CGC),"@r 99.999.999/9999-99") ), oFont08)
oDamdfe:Say(0098, 0110, 'IE: ' + Iif(lXML,oNfe:_MDFE:_INFMDFE:_EMIT:_IE:TEXT,AllTrim(SM0->M0_INSC)), oFont08)	//CNPJ e IE
oDamdfe:Say(0098, 0190, 'RNTRC: '   + AllTrim( cTmsAntt)		,oFont08)	//RNTRC da Empresa

oDamdfe:Say(0108, 0005, Iif(lXML,oNfe:_MDFE:_INFMDFE:_EMIT:_XNOME:TEXT,AllTrim(SM0->M0_NOMECOM))              ,oFont08) 	//Nome Comercial
oDamdfe:Say(0118, 0005, Iif(lXML,oNfe:_MDFE:_INFMDFE:_EMIT:_ENDEREMIT:_XLGR:TEXT,AllTrim(SM0->M0_ENDCOB))     ,oFont08)	//Endereco
oDamdfe:Say(0128, 0005, Iif(lXML,oNfe:_MDFE:_INFMDFE:_EMIT:_ENDEREMIT:_XBAIRRO:TEXT,AllTrim(SM0->M0_BAIRCOB)) ,oFont08)	//Bairro      
oDamdfe:Say(0138, 0005, Iif(lXML,oNfe:_MDFE:_INFMDFE:_EMIT:_ENDEREMIT:_UF:TEXT + ' - ' + oNfe:_MDFE:_INFMDFE:_EMIT:_ENDEREMIT:_XMUN:TEXT + '  -  ' + oNfe:_MDFE:_INFMDFE:_EMIT:_ENDEREMIT:_CEP:TEXT,;
                             AllTrim(SM0->M0_ESTCOB) + ' - ' + AllTrim(SM0->M0_CIDCOB) + '  CEP.:  ' + AllTrim(SM0->M0_CEPCOB)) ,oFont08)	//Cidade, UF, CEP

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ BOX: DACTE 															   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oDamdfe:Box(0036, 402, 0053, 0800)	
oDamdfe:Say(0046, 430, "DAMDFE", oFont12N)
oDamdfe:Say(0042, 490, "Documento Auxiliar de Manifesto Eletrônico de",oFont08)
oDamdfe:Say(0050, 490, "Documentos Fiscais",oFont08) 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ BOX: Controle do Fisco                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oDamdfe:Box(0055, 402, 0140, 0800)       
If	AllTrim(aCab[7])<>''
	oDamdfe:Code128C(100.6,425,aCab[5], 29)	
//	oDamdfe:Code128C(150.4,425,aCab[7], 29)
Else
	oDamdfe:Code128C(100.6,425,aCab[5], 29)	
EndIf	
oDamdfe:Line(0110, 0402, 0110, 0800 )	//Linha Separadora
oDamdfe:Say( 0118, 0425,"CHAVE DE ACESSO",oFont07)
oDamdfe:Say( 0128, 0425, Transform(AllTrim(aCab[5]),"@r 99.9999.99.999.999/9999-99-99-999-999.999.999.999.999.999.9"), oFont08N) 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³BOX: Modelo / Serie / Numero / Folha / Emis / UF                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oDamdfe:Box(0142, 000, 162, 0400)

oDamdfe:Say(0150, 0005, "Modelo" , oFont08N)	//Modelo
oDamdfe:Say(0158, 0005, "58",oFont08)

oDamdfe:Say(0150, 0045, "Serie"  , oFont08N)	//Serie
oDamdfe:Say(0158, 0050, cValtoChar( Val(aCab[2]) ), oFont08)

oDamdfe:Say(0150, 0090, "Número" , oFont08N)	//Numero
oDamdfe:Say(0158, 0095, cValtoChar( Val(aCab[1]) ), oFont08)

oDamdfe:Say(0150, 0145, "Folha"  , oFont08N)	//Folha
oDamdfe:Say(0158, 0149, AllTrim(Str(nFolhAtu)) + " / " + AllTrim(Str(nFolhas)), oFont08)
nFolhAtu ++

oDamdfe:Say(0150, 0199, "Emissão", oFont08N)//Emissao
oDamdfe:Say(0158, 0192, SubStr(AllTrim(aCab[3]), 7, 2) + '/'   +;
						SubStr(AllTrim(aCab[3]), 5, 2) + "/"   +; 
						SubStr(AllTrim(aCab[3]), 1, 4) + " - " +;
						SubStr(AllTrim(aCab[4]), 1, 2) + ":"   +;	
						SubStr(AllTrim(aCab[4]), 3, 2) + ":00", oFont08)

oDamdfe:Say(0150, 0284, "UF Carreg."  , oFont08N)	//Folha                          
If lXml
	cCodEst:= Substr(oNfe:_MDFE:_INFMDFE:_IDE:_INFMUNCARREGA:_CMUNCARREGA:TEXT,1,2)
	If aScan(aUF,{|x| x[2] ==  AllTrim(cCodEst) }) != 0 
		cUF := aUF[ aScan(aUF,{|x| x[2] == AllTrim(cCodEst) }), 1]
	EndIf	
Else      
	aAreaSM0:= SM0->(GetArea())
	cUF:= Posicione("SM0",1,cEmpAnt+DTX->DTX_FILMAN,"M0_ESTENT")      			
	RestArea(aAreaSM0)
EndIf	

oDamdfe:Say(0158, 0288,cUF, oFont08)           

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³BOX: PROTOCOLO 														   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oDamdfe:Box(0142, 0402, 162, 0800)
oDamdfe:Say(0150, 0425, "PROTOCOLO DE AUTORIZACAO DE USO"  , oFont08N)
If Empty(aCab[7])  //Chave Contingencia
	oDamdfe:Say(0158, 0425,aCab[6], oFont08)
	oDamdfe:Say(0158, 0495,cValToChar(aCab[8]), oFont08)
	oDamdfe:Say(0158, 0535,cValToChar(aCab[9]), oFont08)
Else 
	oDamdfe:Say(0158, 0425,'Impressão em contingência. Obrigatória a autorização em 24 horas após esta impressão.', oFont08)
	
	oDamdfe:Say(0158, 0700, "(" + SubStr(AllTrim(aCab[8]), 7, 2) + '/'   +;
						SubStr(AllTrim(aCab[8]), 5, 2) + "/"   +; 
						SubStr(AllTrim(aCab[8]), 1, 4) + " - " +;
						SubStr(AllTrim(aCab[9]), 1, 2) + ":"   +;	
						SubStr(AllTrim(aCab[9]), 3, 2) + ")", oFont08)
EndIf	

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³AjustaSX1     ³ Autor ³Katia                 ³ Data ³07/05/13  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Ajusta o X1_GSC                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³AjustaSX1()                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
Static Function AjustaSX1()

Local aArea     := GetArea() 
Local cTamMan   := TamSX3("DTX_MANIFE")[1]
Local cTamVia   := TamSX3("DTX_VIAGEM")[1]
Local cFilMan   := TamSX3("DTX_FILMAN")[1]
Local cFilVia   := TamSX3("DTX_FILORI")[1]                               
Local aHelpPor1 := {'Informe a Filial de Origem da Viagem.'}
Local aHelpEng1 := {'Enter the Trip Origin Branch.'}
Local aHelpSpa1 := {'Informe la Sucursal de origen del viaje.'}
Local aHelpPor2 := {'Informe o No. da Viagem Inicial.'}
Local aHelpEng2 := {'Enter the Initial Trip No.'}
Local aHelpSpa2 := {'Informe el Nº del Viaje Inicial.'}
Local aHelpPor3 := {'Informe a Filial Inicial do Manifesto.'}
Local aHelpEng3 := {'Enter the Initial Branch of Manisfest.'}
Local aHelpSpa3 := {'Informe la sucursal inicial del Manifiesto. '}
Local aHelpPor4 := {'Informe a Filial Final do Manifesto.'}
Local aHelpEng4 := {'Enter the Final Branch of Manifest.'}
Local aHelpSpa4 := {'Informe la Sucursal Final del Manifiesto.'}
Local aHelpPor5 := {'Informe o No. Inicial do Manifesto.'}
Local aHelpEng5 := {'Enter the Manifest Initial No.'}
Local aHelpSpa5 := {'Informe el Nº Inicial del Manifiesto. '}
Local aHelpPor6 := {'Informe o No. Final do Manifesto.'}
Local aHelpEng6 := {'Enter the Manifest Final No. '}
Local aHelpSpa6 := {'Informe el Nº Final del Manifiesto. '}

PutSx1( 	"RTMSR28","01","Filial Origem ?","Origem branch ?","Sucursal origem ?",;
			"mv_ch1","C",cFilVia,0,0,"G","","DL5","","N",;
			"mv_par01","","","","","","","",;
			,,,,,,,,,aHelpPor1,aHelpEng1,aHelpSpa1)

PutSx1( 	"RTMSR28","02","Viagem ?","Trip ?","Viaje ?",;
			"mv_ch2","C",cTamVia,0,0,"G","","","","N",;
			"mv_par02","","","","","","","",;
			,,,,,,,,,aHelpPor2,aHelpEng2,aHelpSpa2)

PutSx1( 	"RTMSR28","03","Fil. Manifesto De ?","From Manisfest branch ?","De Suc. Manifiesto ?",;
			"mv_ch3","C",cFilMan,0,0,"G","","","","N",;
			"mv_par03","","","","","","","",;
			,,,,,,,,,aHelpPor3,aHelpEng3,aHelpSpa3)

PutSx1( 	"RTMSR28","04","Fil. Manifesto Ate ?","To Manisfest branch ?","A Suc. Manifiesto ?",;
			"mv_ch4","C",cFilMan,0,0,"G","","","","N",;
			"mv_par04","","","","","","","",;
			,,,,,,,,,aHelpPor4,aHelpEng4,aHelpSpa4)

PutSx1( 	"RTMSR28","05","Manifesto De ?","From Manisfest ?","De Manifiesto ?",;
			"mv_ch5","C",cTamMan,0,0,"G","","","","N",;
			"mv_par05","","","","","","","",;
			,,,,,,,,,aHelpPor5,aHelpEng5,aHelpSpa5)

PutSx1( 	"RTMSR28","06","Manifesto Ate ?","To Manisfest ?","A Manifiesto ?",;
			"mv_ch6","C",cTamMan,0,0,"G","","","","N",;
			"mv_par06","","","","","","","",;
			,,,,,,,,,aHelpPor6,aHelpEng6,aHelpSpa6)

RestArea(aArea)
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RTMSR28   ³ Autor ³Katia               ³ Data ³07/05/13     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function DataSource( cSource )
Local cNewArea	:= GetNextAlias()
Local cQuery	:= ""

cQuery := GetSQL( cSource )
DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cNewArea, .F., .T.)

Return ( cNewArea )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RTMSR28   ³ Autor ³Katia               ³ Data ³07/05/13     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³  Cria DACTE sem utilizar o XML, utilizando tabela.         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GetSQL( cSource )
Local cQuery      := ""

If	cSource == 'DTX'
	cQuery += "    SELECT DTX_FILMAN, DTX_MANIFE, DTX_FILORI, DTX_VIAGEM, DTX_DATMAN, DTX_HORMAN, DTX_QTDDOC, DTX_PESO, " +CRLF
	cQuery += "        DTX_QTDCTE, DTX_PRIMDF, DTX_CHVMDF, DTX_CTGMDF, DTX_DATIMP, DTX_HORIMP, DTX_AMBIEN, DTX_FIMP, " +CRLF
	If DTR->(FieldPos("DTR_CIOT")) > 0
		cQuery += "    DTR_CODVEI, DTR_CIOT " + CRLF
	Else                                                                                                        
		cQuery += "    DTR_CODVEI " + CRLF
	EndIf	

	cQuery += "   FROM " + RetSqlName('DTX') + " DTX " + CRLF
	cQuery += "        INNER JOIN " + RetSqlName('DTR') + " DTR ON(DTR_FILORI = DTX_FILORI AND DTR_VIAGEM = DTX_VIAGEM AND DTX.D_E_L_E_T_='' ) " + CRLF

	cQuery += "  WHERE DTX_FILIAL = '" + xFilial('DTX') + "'" + CRLF
	cQuery += "    AND DTX_FILORI = '" + MV_PAR01 + "'" + CRLF
	cQuery += "    AND DTX_VIAGEM = '" + MV_PAR02 + "'" + CRLF
	cQuery += "    AND DTX_FILMAN >= '" + MV_PAR03 + "'" + CRLF
	cQuery += "    AND DTX_FILMAN <= '" + MV_PAR04 + "'" + CRLF

	cQuery += "    AND (DTX_IDIMDF  = '100' OR (DTX_CTGMDF  <> ' ' AND SUBSTRING(DTX_RTIMDF,1,3) = '004'))" + CRLF

	cQuery += "    AND DTX_MANIFE    >= '" + MV_PAR05 + "'" + CRLF
	cQuery += "    AND DTX_MANIFE    <= '" + MV_PAR06 + "'" + CRLF
	cQuery += "    AND DTX.D_E_L_E_T_  = ' ' " + CRLF

	cQuery += "  AND DTR_FILIAL = '" + xFilial('DTR') + "'" + CRLF

	cQuery += "  ORDER BY DTX.DTX_FILIAL, DTX_FILORI, DTX_VIAGEM, DTX_FILMAN, DTX_MANIFE " + CRLF

ElseIf cSource == 'DA3'

	cQuery += " SELECT DA3_COD, DA3_PLACA, DA3_RENAVA, DA3_TARA, DA3_CAPACM, DA3_FROVEI, " + CRLF
	cQuery += "   DA3_ESTPLA, DA3_CODFOR, DA3_LOJFOR, DUT_DESCRI,DUT_TIPROD, DUT_TIPCAR, " + CRLF
	cQuery += "   DA3_ALTINT, DA3_LARINT, DA3_COMINT, " + CRLF
	cQuery += "   A2_CGC, A2_NOME, A2_INSCR, A2_EST, A2_TIPO, A2_RNTRC " + CRLF
	cQuery += " FROM " + RetSqlName("DA3") + " DA3 " + CRLF
	cQuery += "   INNER JOIN " + RetSqlName("DUT") + " DUT " + CRLF
	cQuery += "   ON DUT.DUT_TIPVEI = DA3.DA3_TIPVEI " + CRLF
	cQuery += "   AND DUT.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += "   INNER JOIN " + RetSqlName("SA2") + " SA2 ON " + CRLF
	cQuery += "   SA2.A2_COD = DA3.DA3_CODFOR AND " + CRLF
	cQuery += "   SA2.A2_LOJA   = DA3.DA3_LOJFOR AND " + CRLF
	cQuery += "   SA2.D_E_L_E_T_= '' " + CRLF
	cQuery += " WHERE DA3.DA3_FILIAL = '"+xFilial("DA3")+"'" + CRLF
	cQuery += "   AND DA3.DA3_COD    = '"+cCodVei+"'" + CRLF
	cQuery += "   AND DA3.D_E_L_E_T_ = ' '" + CRLF
	cQuery += "   AND DUT.DUT_FILIAL = '"+xFilial('DUT')+"'" + CRLF
	cQuery += "   AND SA2.A2_FILIAL  = '"+xFilial('SA2')+"'" + CRLF

ElseIf cSource == 'DTC'

	cQuery += " SELECT DTC_NFEID, SUM(DTC_PESO) NPESO, COUNT(*) NDOC " + CRLF
	cQuery += "   FROM " + RetSqlName('DTC') + " DTC " + CRLF
	cQuery += "  WHERE DTC.DTC_FILIAL	= '" + xFilial('DTC') + "'" + CRLF	

	cQuery += " SELECT DA3_COD, DA3_PLACA, DA3_RENAVA, DA3_TARA, DA3_CAPACM, DA3_FROVEI, " + CRLF
	cQuery += "   DA3_ESTPLA, DA3_CODFOR, DA3_LOJFOR, DUT_DESCRI,DUT_TIPROD, DUT_TIPCAR, " + CRLF
	cQuery += "   DA3_ALTINT, DA3_LARINT, DA3_COMINT, " + CRLF
	cQuery += "   A2_CGC, A2_NOME, A2_INSCR, A2_EST, A2_TIPO, A2_RNTRC " + CRLF
	cQuery += " FROM " + RetSqlName("DA3") + " DA3 " + CRLF
	cQuery += "   INNER JOIN " + RetSqlName("DUT") + " DUT " + CRLF
	cQuery += "   ON DUT.DUT_TIPVEI = DA3.DA3_TIPVEI " + CRLF
	cQuery += "   AND DUT.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += "   INNER JOIN " + RetSqlName("SA2") + " SA2 ON " + CRLF
	cQuery += "   SA2.A2_COD = DA3.DA3_CODFOR AND " + CRLF
	cQuery += "   SA2.A2_LOJA   = DA3.DA3_LOJFOR AND " + CRLF
	cQuery += "   SA2.D_E_L_E_T_= '' " + CRLF
	cQuery += " WHERE DA3.DA3_FILIAL = '"+xFilial("DA3")+"'" + CRLF
	cQuery += "   AND DA3.DA3_COD    = '"+cCodVei+"'" + CRLF
	cQuery += "   AND DA3.D_E_L_E_T_ = ' '" + CRLF
	cQuery += "   AND DUT.DUT_FILIAL = '"+xFilial('DUT')+"'" + CRLF
	cQuery += "   AND SA2.A2_FILIAL  = '"+xFilial('SA2')+"'" + CRLF

ElseIf cSource == 'DTR'

	cQuery    := " SELECT DTR_CODVEI, DTR_CODRB1, DTR_CODRB2 "
	cQuery    += " FROM " + RetSqlName("DTR")+" DTR "
	cQuery    += " WHERE DTR_FILIAL = '"+xFilial('DTR')+"'"
	cQuery    += "   AND DTR_FILORI = '"+ MV_PAR01+"'"
	cQuery    += "   AND DTR_VIAGEM = '"+ MV_PAR02+"'"
	cQuery    += "   AND D_E_L_E_T_ = ' '"

EndIf

cQuery := ChangeQuery( cQuery )

Return ( cQuery )


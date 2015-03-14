#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TBICONN.CH" 


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³NfdsXml002³ Autor ³ Roberto Souza         ³ Data ³21/05/2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Exemplo de geracao da Nota Fiscal Digital de Serviços       ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Xml para envio                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Tipo da NF                                           ³±±
±±³          ³       [0] Entrada                                          ³±±
±±³          ³       [1] Saida                                            ³±±
±±³          ³ExpC2: Serie da NF                                          ³±±
±±³          ³ExpC3: Numero da nota fiscal                                ³±±
±±³          ³ExpC4: Codigo do cliente ou fornecedor                      ³±±
±±³          ³ExpC5: Loja do cliente ou fornecedor                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function NfseM002(cCodMun,cTipo,dDtEmiss,cSerie,cNota,cClieFor,cLoja)

Local nX        := 0

Local oWSNfe   

Local cString    := ""
Local cAliasSE1  := "SE1"
Local cAliasSD1  := "SD1"
Local cAliasSD2  := "SD2"
Local cNatOper   := ""
Local cModFrete  := ""
Local cScan      := ""
Local cEspecie   := ""
Local cMensCli   := ""
Local cMensFis   := ""
Local cNFe       := ""
Local cMV_LJTPNFE:= SuperGetMV("MV_LJTPNFE", ," ")
lOCAL cMVSUBTRIB := SuperGetMv("MV_SUBTRIB")
Local cLJTPNFE	 := ""
Local cWhere	 := ""
Local cMunISS	 := ""
Local cTipoPcc   := "PIS','COF','CSL','CF-','PI-','CS-"
Local cCodCli 	 := ""
Local cLojCli 	 := "" 
Local cDescMunP	 := ""
Local cCdMun     := ""
Local cEstMun 	 := ""
Local cMunPrest  := ""
Local cF4Agreg	 := ""
Local cDescrNFSe := ""
Local cDiscrNFSe := ""
Local cMVBENEFRJ:= AllTrim(GetNewPar("MV_BENEFRJ"," "))

Local nRetPis	 := 0
Local nRetCof	 := 0
Local nRetCsl	 := 0
Local nPosI		 :=	0
Local nPosF	     :=	0
Local nAliq	     :=	0
Local nCont		 := 0
Local nDescon	 := 0

Local lQuery    := .F.
Local lCalSol	:= .F.
Local lEasy		:= SuperGetMV("MV_EASY") == "S" 
Local lEECFAT	:= SuperGetMv("MV_EECFAT")
Local lNatOper  := GetNewPar("MV_NFESERV","1") == "1"
Local lAglutina	 := AllTrim(GetNewPar("MV_ITEMAGL","N")) == "S"
Local lNFeDesc  := GetNewPar("MV_NFEDESC",.F.)
Local lNfsePcc  := GetNewPar("MV_NFSEPCC",.F.)

Local aNota     := {}
Local aConstr	:= {}
Local aDupl     := {}
Local aDest     := {}
Local aEntrega  := {}
Local aProd     := {}
Local aICMS     := {}
Local aICMSST   := {}
Local aIPI      := {}
Local aPIS      := {}
Local aCOFINS   := {}
Local aPISST    := {}
Local aCOFINSST := {}
Local aISSQN    := {}
Local aISS      := {}
Local aCST      := {}
Local aRetido   := {}
Local aTransp   := {}
Local aImp      := {}
Local aVeiculo  := {}
Local aReboque  := {}
Local aEspVol   := {}
Local aNfVinc   := {}
Local aPedido   := {}
Local aTotal    := {0,0,""}
Local aOldReg   := {}
Local aOldReg2  := {}
Local aMed		:= {}
Local aArma		:= {}
Local aveicProd	:= {}
Local aIEST		:= {}
Local aDI		:= {}
Local aAdi		:= {}
Local aExp		:= {}
Local aPisAlqZ	:= {}
Local aCofAlqZ	:= {} 
Local aDeducao  := {} 
Local aRetServ  := {}

Private aUF     := {}         

DEFAULT cCodMun := PARAMIXB[1]
DEFAULT cTipo   := PARAMIXB[2]
DEFAULT cSerie  := PARAMIXB[4]
DEFAULT cNota   := PARAMIXB[5]
DEFAULT cClieFor:= PARAMIXB[6]
DEFAULT cLoja   := PARAMIXB[7]

 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Preenchimento do Array de UF                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aadd(aUF,{"RO","11"})
aadd(aUF,{"AC","12"})
aadd(aUF,{"AM","13"})
aadd(aUF,{"RR","14"})
aadd(aUF,{"PA","15"})
aadd(aUF,{"AP","16"})
aadd(aUF,{"TO","17"})
aadd(aUF,{"MA","21"})
aadd(aUF,{"PI","22"})
aadd(aUF,{"CE","23"})
aadd(aUF,{"RN","24"})
aadd(aUF,{"PB","25"})
aadd(aUF,{"PE","26"})
aadd(aUF,{"AL","27"})
aadd(aUF,{"MG","31"})
aadd(aUF,{"ES","32"})
aadd(aUF,{"RJ","33"})
aadd(aUF,{"SP","35"})
aadd(aUF,{"PR","41"})
aadd(aUF,{"SC","42"})
aadd(aUF,{"RS","43"})
aadd(aUF,{"MS","50"})
aadd(aUF,{"MT","51"})
aadd(aUF,{"GO","52"})
aadd(aUF,{"DF","53"})
aadd(aUF,{"SE","28"})
aadd(aUF,{"BA","29"})
aadd(aUF,{"EX","99"})

If cTipo == "1"
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Posiciona NF                                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SF2")
	dbSetOrder(1)// F2_FILIAL, F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA, F2_FORMUL, R_E_C_N_O_, D_E_L_E_T_
	DbGoTop()
	If DbSeek(xFilial("SF2")+cNota+cSerie+cClieFor+cLoja)	

		aadd(aNota,SF2->F2_SERIE)
		aadd(aNota,IIF(Len(SF2->F2_DOC)==6,"000","")+SF2->F2_DOC)
		aadd(aNota,SF2->F2_EMISSAO)
		aadd(aNota,cTipo)
		aadd(aNota,SF2->F2_TIPO)
		aadd(aNota,"1")
		If SF2->(FieldPos("F2_NFSUBST"))<>0 
			aadd(aNota,IIF(Len(SF2->F2_DOC)==6,"000","")+SF2->F2_NFSUBST)
		Endif
		If SF2->(FieldPos("F2_SERSUBS"))<>0
			aadd(aNota,SF2->F2_SERSUBS)
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Posiciona cliente ou fornecedor                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
		If !SF2->F2_TIPO $ "DB" 
			If IntTMS()
				DT6->(DbSetOrder(1)) 
				If DT6->(DbSeek(xFilial("DT6")+SF2->(F2_FILIAL+F2_DOC+F2_SERIE)))
					cCodCli := DT6->DT6_CLIDEV
					cLojCli := DT6->DT6_LOJDEV
				Else
					cCodCli := SF2->F2_CLIENTE
					cLojCli := SF2->F2_LOJA
				EndIf
			Else
				cCodCli := SF2->F2_CLIENTE
				cLojCli := SF2->F2_LOJA
			EndIf
		
		    dbSelectArea("SA1")
			dbSetOrder(1)
			DbSeek(xFilial("SA1")+cCodCli+cLojCli)
			
			aadd(aDest,AllTrim(SA1->A1_CGC))
			aadd(aDest,SA1->A1_NOME)
			aadd(aDest,MyGetEnd2(SA1->A1_END,"SA1")[1])
			aadd(aDest,ConvType2(IIF(MyGetEnd2(SA1->A1_END,"SA1")[2]<>0,MyGetEnd2(SA1->A1_END,"SA1")[2],"SN")))
			aadd(aDest,IIF(SA1->(FieldPos("A1_COMPLEM")) > 0 .And. !Empty(SA1->A1_COMPLEM),SA1->A1_COMPLEM,MyGetEnd2(SA1->A1_END,"SA1")[4]))
			aadd(aDest,SA1->A1_BAIRRO)
			If !Upper(SA1->A1_EST) == "EX"
				aadd(aDest,SA1->A1_COD_MUN)
				aadd(aDest,SA1->A1_MUN)				
			Else
				aadd(aDest,"99999")			
				aadd(aDest,"EXTERIOR")
			EndIf
			aadd(aDest,Upper(SA1->A1_EST))
			aadd(aDest,SA1->A1_CEP)
			aadd(aDest,IIF(Empty(SA1->A1_PAIS),"1058"  ,Posicione("SYA",1,xFilial("SYA")+SA1->A1_PAIS,"YA_SISEXP")))
			aadd(aDest,IIF(Empty(SA1->A1_PAIS),"BRASIL",Posicione("SYA",1,xFilial("SYA")+SA1->A1_PAIS,"YA_DESCR" )))
			aadd(aDest,SA1->A1_DDD+SA1->A1_TEL)
			aadd(aDest,VldIE2(SA1->A1_INSCR,IIF(SA1->(FIELDPOS("A1_CONTRIB"))>0,SA1->A1_CONTRIB<>"2",.T.)))
			aadd(aDest,SA1->A1_SUFRAMA)
			aadd(aDest,SA1->A1_EMAIL)          
			aadd(aDest,SA1->A1_INSCRM) 
			aadd(aDest,SA1->A1_CODSIAF)
			aadd(aDest,SA1->A1_NATUREZ)            
			aadd(aDest,Iif(!Empty(SA1->A1_SIMPNAC),SA1->A1_SIMPNAC,"2"))
			aadd(aDest,Iif(SA1->(FieldPos("A1_INCULT"))> 0 , Iif(!Empty(SA1->A1_INCULT),SA1->A1_INCULT,"2"), "2"))
			aadd(aDest,SA1->A1_TPESSOA)
			aadd(aDest,Iif(SA1->(FieldPos("A1_OUTRMUN"))> 0 ,SA1->A1_OUTRMUN,""))
						
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Posiciona Natureza                                                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			DbSelectArea("SED")
			DbSetOrder(1)
			DbSeek(xFilial("SED")+SA1->A1_NATUREZ) 			
			
			If SF2->(FieldPos("F2_CLIENT"))<>0 .And. !Empty(SF2->F2_CLIENT+SF2->F2_LOJENT) .And. SF2->F2_CLIENT+SF2->F2_LOJENT<>SF2->F2_CLIENTE+SF2->F2_LOJA
			    dbSelectArea("SA1")
				dbSetOrder(1)
				DbSeek(xFilial("SA1")+SF2->F2_CLIENT+SF2->F2_LOJENT)
				
				aadd(aEntrega,SA1->A1_CGC)
				aadd(aEntrega,MyGetEnd2(SA1->A1_END,"SA1")[1])
				aadd(aEntrega,ConvType2(IIF(MyGetEnd2(SA1->A1_END,"SA1")[2]<>0,MyGetEnd2(SA1->A1_END,"SA1")[2],"SN")))
				aadd(aEntrega,MyGetEnd2(SA1->A1_END,"SA1")[4])
				aadd(aEntrega,SA1->A1_BAIRRO)
				aadd(aEntrega,SA1->A1_COD_MUN)
				aadd(aEntrega,SA1->A1_MUN)
				aadd(aEntrega,Upper(SA1->A1_EST))
				
			EndIf
					
		Else
		    dbSelectArea("SA2")
			dbSetOrder(1)
			DbSeek(xFilial("SA2")+SF2->F2_CLIENTE+SF2->F2_LOJA)	
	
			aadd(aDest,AllTrim(SA2->A2_CGC))
			aadd(aDest,SA2->A2_NOME)
			aadd(aDest,MyGetEnd2(SA2->A2_END,"SA2")[1])
			aadd(aDest,ConvType2(IIF(MyGetEnd2(SA2->A2_END,"SA2")[2]<>0,MyGetEnd2(SA2->A2_END,"SA2")[2],"SN")))
			aadd(aDest,IIF(SA2->(FieldPos("A2_COMPLEM")) > 0 .And. !Empty(SA2->A2_COMPLEM),SA2->A2_COMPLEM,MyGetEnd2(SA2->A2_END,"SA2")[4]))				
			aadd(aDest,SA2->A2_BAIRRO)
			If !Upper(SA2->A2_EST) == "EX"
				aadd(aDest,SA2->A2_COD_MUN)
				aadd(aDest,SA2->A2_MUN)				
			Else
				aadd(aDest,"99999")			
				aadd(aDest,"EXTERIOR")
			EndIf			
			aadd(aDest,Upper(SA2->A2_EST))
			aadd(aDest,SA2->A2_CEP)
			aadd(aDest,IIF(Empty(SA2->A2_PAIS),"1058"  ,Posicione("SYA",1,xFilial("SYA")+SA2->A2_PAIS,"YA_SISEXP")))
			aadd(aDest,IIF(Empty(SA2->A2_PAIS),"BRASIL",Posicione("SYA",1,xFilial("SYA")+SA2->A2_PAIS,"YA_DESCR")))
			aadd(aDest,SA2->A2_DDD+SA2->A2_TEL)
			aadd(aDest,VldIE2(SA2->A2_INSCR))
			aadd(aDest,"")//SA2->A2_SUFRAMA
			aadd(aDest,SA2->A2_EMAIL)
			aadd(aDest,SA2->A2_INSCRM) 
			aadd(aDest,SA2->A2_CODSIAF)
			aadd(aDest,SA2->A2_NATUREZ)	  
			aadd(aDest,SA2->A2_SIMPNAC)	  
					
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Posiciona Natureza                                                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			DbSelectArea("SED")
			DbSetOrder(1)
			DbSeek(xFilial("SED")+SA2->A2_NATUREZ) 
			
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Posiciona transportador                                                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(SF2->F2_TRANSP)
			dbSelectArea("SA4")
			dbSetOrder(1)
			DbSeek(xFilial("SA4")+SF2->F2_TRANSP)
			
			aadd(aTransp,AllTrim(SA4->A4_CGC))
			aadd(aTransp,SA4->A4_NOME)
			aadd(aTransp,SA4->A4_INSEST)
			aadd(aTransp,SA4->A4_END)
			aadd(aTransp,SA4->A4_MUN)
			aadd(aTransp,Upper(SA4->A4_EST)	)
	
			If !Empty(SF2->F2_VEICUL1)
				dbSelectArea("DA3")
				dbSetOrder(1)
				DbSeek(xFilial("DA3")+SF2->F2_VEICUL1)
				
				aadd(aVeiculo,DA3->DA3_PLACA)
				aadd(aVeiculo,DA3->DA3_ESTPLA)
				aadd(aVeiculo,"")//RNTC
				
				If !Empty(SF2->F2_VEICUL2)
				
					dbSelectArea("DA3")
					dbSetOrder(1)
					DbSeek(xFilial("DA3")+SF2->F2_VEICUL2)
				
					aadd(aReboque,DA3->DA3_PLACA)
					aadd(aReboque,DA3->DA3_ESTPLA)
					aadd(aReboque,"") //RNTC
					
				EndIf					
			EndIf
		EndIf
		dbSelectArea("SF2")
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Volumes                                                                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cScan := "1"
		While ( !Empty(cScan) )
			cEspecie := Upper(FieldGet(FieldPos("F2_ESPECI"+cScan)))
			If !Empty(cEspecie)
				nScan := aScan(aEspVol,{|x| x[1] == cEspecie})
				If ( nScan==0 )
					aadd(aEspVol,{ cEspecie, FieldGet(FieldPos("F2_VOLUME"+cScan)) , SF2->F2_PLIQUI , SF2->F2_PBRUTO})
				Else
					aEspVol[nScan][2] += FieldGet(FieldPos("F2_VOLUME"+cScan))
				EndIf
			EndIf
			cScan := Soma1(cScan,1)
			If ( FieldPos("F2_ESPECI"+cScan) == 0 )
				cScan := ""
			EndIf
		EndDo  
						
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Procura duplicatas                                                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If !Empty(SF2->F2_DUPL)	
			cLJTPNFE := (StrTran(cMV_LJTPNFE," ,"," ','"))+" "
			cWhere := cLJTPNFE
			dbSelectArea("SE1")
			dbSetOrder(1)	
			#IFDEF TOP
				lQuery  := .T.
				cAliasSE1 := GetNextAlias()
				BeginSql Alias cAliasSE1
					COLUMN E1_VENCORI AS DATE
					SELECT E1_FILIAL,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO,E1_VENCORI,E1_VALOR,E1_ORIGEM,E1_CSLL,E1_COFINS,E1_PIS
					FROM %Table:SE1% SE1
					WHERE
					SE1.E1_FILIAL = %xFilial:SE1% AND
					SE1.E1_PREFIXO = %Exp:SF2->F2_PREFIXO% AND 
					SE1.E1_NUM = %Exp:SF2->F2_DUPL% AND 
					((SE1.E1_TIPO = %Exp:MVNOTAFIS%) OR
					 SE1.E1_TIPO IN (%Exp:cTipoPcc%) OR
					 (SE1.E1_ORIGEM = 'LOJA701' AND SE1.E1_TIPO IN (%Exp:cWhere%))) AND
					SE1.%NotDel%
					ORDER BY %Order:SE1%
				EndSql
				
			#ELSE
				DbSeek(xFilial("SE1")+SF2->F2_PREFIXO+SF2->F2_DOC)
			#ENDIF
			While !Eof() .And. xFilial("SE1") == (cAliasSE1)->E1_FILIAL .And.;
				SF2->F2_PREFIXO == (cAliasSE1)->E1_PREFIXO .And.;
				SF2->F2_DOC == (cAliasSE1)->E1_NUM
				If 	(cAliasSE1)->E1_TIPO = MVNOTAFIS .OR. ((cAliasSE1)->E1_ORIGEM = 'LOJA701' .AND. (cAliasSE1)->E1_TIPO $ cWhere)
				
					aadd(aDupl,{(cAliasSE1)->E1_PREFIXO+(cAliasSE1)->E1_NUM+(cAliasSE1)->E1_PARCELA,(cAliasSE1)->E1_VENCORI,(cAliasSE1)->E1_VALOR})
				
				EndIf
				  
				//Tratamento para saber se existem titulos de retenção de PIS,COFINS e CSLL
				If lNfsePcc
					If Alltrim((cAliasSE1)->E1_TIPO) $ "NF"
						nRetCsl := (cAliasSE1)->E1_CSLL 
						nRetCof	:= (cAliasSE1)->E1_COFINS
						nRetPis := (cAliasSE1)->E1_PIS
					EndIf	
				Else
					If 	(cAliasSE1)->E1_TIPO $ cTipoPcc
						If (cAliasSE1)->E1_TIPO $ "PIS,PI-"
							nRetPis	+= 	(cAliasSE1)->E1_VALOR
						ElseIf (cAliasSE1)->E1_TIPO $ "COF,CF-"
							nRetCof	+= 	(cAliasSE1)->E1_VALOR						
						ElseIf (cAliasSE1)->E1_TIPO $ "CSL,CS-"
							nRetCsl	+= 	(cAliasSE1)->E1_VALOR
						EndIf				 							
					EndIf
				EndIf	
				dbSelectArea(cAliasSE1)
				dbSkip()
		    EndDo
		    If lQuery
		    	dbSelectArea(cAliasSE1)
		    	dbCloseArea()
		    	dbSelectArea("SE1")
		    EndIf
		Else
			aDupl := {}
		EndIf  
		
		dbSelectArea("SF3")
		dbSetOrder(4)
		If DbSeek(xFilial("SF3")+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_DOC+SF2->F2_SERIE)
				
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica se recolhe ISS Retido ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If SF3->(FieldPos("F3_RECISS"))>0
				If SF3->F3_RECISS $"1S"       
					dbSelectArea("SD2")
					dbSetOrder(3)
   					dbSeek(xFilial("SD2")+SF3->F3_NFISCAL+SF3->F3_SERIE+SF3->F3_CLIEFOR+SF3->F3_LOJA)
					
					aadd(aRetido,{"ISS",0,SF3->F3_VALICM,SD2->D2_ALIQISS,SF3->F3_RECISS})
		   		Endif
			EndIf 
				
	  	        
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Pega as deduções ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
			  If SF3->(FieldPos("F3_ISSSUB"))>0  .And. SF3->F3_ISSSUB > 0
			  	If len(aDeducao) > 0
                	aDeducao [len(aDeducao)] := SF3->F3_ISSSUB  
			 	Else
			  		aadd(aDeducao,{SF3->F3_ISSSUB})
			  	EndIF
			  EndIf
		
			  If SF3->(FieldPos("F3_ISSMAT"))>0 .And. SF3->F3_ISSMAT > 0 
				If len(aDeducao) > 0	
				  	aDeducao[len(aDeducao)] := SF3->F3_ISSMAT  
				Else
				   	aadd(aDeducao,{SF3->F3_ISSMAT})
				EndIf
			  EndIf
		 EndIf
		 	  
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Analisa os impostos de retencao                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		

		aadd(aRetido,{"PIS",0,nRetPis,SED->ED_PERCPIS})
		
		aadd(aRetido,{"COFINS",0,nRetCof,SED->ED_PERCCOF})
		
		aadd(aRetido,{"CSLL",0,nRetCsl,SED->ED_PERCCSL})
		
		If SF2->(FieldPos("F2_VALIRRF"))<>0 .and. SF2->F2_VALIRRF>0
			aadd(aRetido,{"IRRF",SF2->F2_BASEIRR,SF2->F2_VALIRRF,SED->ED_PERCIRF})
		EndIf	
		If SF2->(FieldPos("F2_BASEINS"))<>0 .and. SF2->F2_BASEINS>0
			aadd(aRetido,{"INSS",SF2->F2_BASEINS,SF2->F2_VALINSS,SED->ED_PERCINS})
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Pesquisa itens de nota                                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
		dbSelectArea("SD2")
		dbSetOrder(3)	
		#IFDEF TOP
			lQuery  := .T.
			cAliasSD2 := GetNextAlias()
			BeginSql Alias cAliasSD2
				SELECT D2_FILIAL,D2_SERIE,D2_DOC,D2_CLIENTE,D2_LOJA,D2_COD,D2_TES,D2_NFORI,D2_SERIORI,D2_ITEMORI,D2_TIPO,D2_ITEM,D2_CF,
					D2_QUANT,D2_TOTAL,D2_DESCON,D2_VALFRE,D2_SEGURO,D2_PEDIDO,D2_ITEMPV,D2_DESPESA,D2_VALBRUT,D2_VALISS,D2_PRUNIT,
					D2_CLASFIS,D2_PRCVEN,D2_CODISS,D2_DESCZFR,D2_PREEMB,D2_BASEISS,D2_PROJPMS,D2_DESCICM,D2_ORIGLAN
				FROM %Table:SD2% SD2
				WHERE
				SD2.D2_FILIAL = %xFilial:SD2% AND
				SD2.D2_SERIE = %Exp:SF2->F2_SERIE% AND 
				SD2.D2_DOC = %Exp:SF2->F2_DOC% AND 
				SD2.D2_CLIENTE = %Exp:SF2->F2_CLIENTE% AND 
				SD2.D2_LOJA = %Exp:SF2->F2_LOJA% AND 
				SD2.%NotDel%
				ORDER BY %Order:SD2%
			EndSql
				
		#ELSE
			DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)
		#ENDIF

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Posiciona na Construção Cilvil                                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty((cAliasSD2)->D2_PROJPMS)
			dbSelectArea("AF8")
			dbSetOrder(1)
			DbSeek(xFilial("AF8")+((cAliasSD2)->D2_PROJPMS))
			If !Empty(AF8->AF8_ART)
				aadd(aConstr,(AF8->AF8_PROJET))
				aadd(aConstr,(AF8->AF8_ART))
			EndIf
					
		ElseIf  ( SC5->(FieldPos("C5_OBRA")) > 0 .And. !Empty(SC5->C5_OBRA) ) .And. ( SC5->(FieldPos("C5_ARTOBRA")) > 0 .And. !Empty(SC5->C5_ARTOBRA) )
			aadd(aConstr,(SC5->C5_OBRA))
			aadd(aConstr,(SC5->C5_ARTOBRA))	
		EndIf
				
		While !Eof() .And. xFilial("SD2") == (cAliasSD2)->D2_FILIAL .And.;
			SF2->F2_SERIE == (cAliasSD2)->D2_SERIE .And.;
			SF2->F2_DOC == (cAliasSD2)->D2_DOC
			
			nCont++
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica a natureza da operacao                                         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SC5")
			dbSetOrder(1)
			If DbSeek(xFilial("SC5")+(cAliasSD2)->D2_PEDIDO)
				lSC5 := .T.
			Else
				lSC5 := .F.			
			EndIf	
				
			//TRATAMENTO - INTEGRACAO COM TMS-GESTAO DE TRANSPORTES
			If IntTms()
				DT6->(DbSetOrder(1))
				If DT6->(DbSeek(xFilial("DT6")+SF2->(F2_FILIAL+F2_DOC+F2_SERIE)))
					cModFrete := DT6->DT6_TIPFRE
					
					cCdMun 		:= Subs(Alltrim(Posicione("SM0",1, cEmpAnt+DT6->DT6_FILORI, "M0_CODMUN")),3,5) //CodMun da Empresa/filial
					cEstMun 	:= Posicione("SM0",1, cEmpAnt+DT6->DT6_FILORI, "M0_ESTENT") // Uf da Filial
					cMunPrest 	:= UFCodIBGE2(cEstMun) + Posicione("CC2",1, xFilial("CC2")+cEstMun+PadR(cCdMun,TamSx3("CC2_CODMUN")[1]) , "CC2_CODMUN")// codigo CODMUN do CC2
					cDescMunP	:= Posicione("CC2",1, xFilial("CC2")+cEstMun+PadR(cCdMun,TamSx3("CC2_CODMUN")[1]) , "CC2_MUN")// Descricao Municipio
					
				Else
					If lSC5 .And. SC5->(FieldPos("C5_MUNPRES")) > 0 .And. !Empty(SC5->C5_MUNPRES)
						cMunPrest := SC5->C5_MUNPRES
						cDescMunP := SC5->C5_DESCMUN
					Else
						If cCodMun == "5208707" //Goiania
							cMunPrest := Alltrim(aDest[23])
							cDescMunP := aDest[08] 
						Else
							If ((cAliasSD2)->D2_ORIGLAN $ "LO-VD")
								cMunPrest := SM0->M0_CODMUN
						    Else 
						    	cMunPrest := aDest[07]
						    EndIf	
							cDescMunP := aDest[08]
						EndIf
					EndIf
				EndIf			
			Else
				If lSC5 .And. SC5->(FieldPos("C5_MUNPRES")) > 0 .And. !Empty(SC5->C5_MUNPRES)
					cMunPrest := SC5->C5_MUNPRES
					cDescMunP := SC5->C5_DESCMUN
				Else
					If cCodMun == "5208707" //Goiania
						cMunPrest := Alltrim(aDest[23])
						cDescMunP := aDest[08] 
					Else
						IF ((cAliasSD2)->D2_ORIGLAN $ "LO-VD")
							cMunPrest := SM0->M0_CODMUN
						Else
							cMunPrest := aDest[07]
						EndIF						
						cDescMunP := aDest[08]
					EndIf
				EndIf
			EndIf

			dbSelectArea("SF4")
			dbSetOrder(1)
			DbSeek(xFilial("SF4")+(cAliasSD2)->D2_TES)				
			
			cF4Agreg:= SF4->F4_AGREG
							
			//Pega descricao do pedido de venda-Parametro MV_NFESERV 
			If !lNFeDesc
				If lNatOper .And. lSC5 .And. !Empty(SC5->C5_MENNOTA).And. nCont == 1
					If cCodmun == "3300704-3156700"
						cNatOper+="$$$"
					Else
						cNatOper+=" "
					EndIF
					cNatOper += If(FindFunction('CleanSpecChar'),CleanSpecChar(Alltrim(SC5->C5_MENNOTA)),SC5->C5_MENNOTA)+" "
				EndIf
			Else 
				If lSC5 .And. !Empty(SC5->C5_MENNOTA).And. nCont == 1
					cDiscrNFSe := If(FindFunction('CleanSpecChar'),CleanSpecChar(Alltrim(SC5->C5_MENNOTA)),SC5->C5_MENNOTA)+" "
				EndIf
			EndIf
				
			
			//Pega a descricao da SX5 tabela 60
			dbSelectArea("SB1")
			dbSetOrder(1)
			DbSeek(xFilial("SB1")+(cAliasSD2)->D2_COD)

			dbSelectArea("SX5")
			dbSetOrder(1)
			If dbSeek(xFilial("SX5")+"60"+RetFldProd(SB1->B1_COD,"B1_CODISS"))
				If !lNFeDesc  .And. nCont == 1
					If  cCodmun == "3300704-3156700"
						cNatOper := If(FindFunction('CleanSpecChar'),CleanSpecChar(AllTrim(SubStr(SX5->X5_DESCRI,1,55))),AllTrim(SubStr(SX5->X5_DESCRI,1,55))) + cNatOper
	    			Else
						cNatOper += If(FindFunction('CleanSpecChar'),CleanSpecChar(AllTrim(SubStr(SX5->X5_DESCRI,1,55))),AllTrim(SubStr(SX5->X5_DESCRI,1,55)))    			
	    			EndIf
	    	    ElseIf nCont == 1 
	    	        If cCodmun == "3300704-3156700"
						cDescrNFSe := If(FindFunction('CleanSpecChar'),CleanSpecChar(AllTrim(SubStr(SX5->X5_DESCRI,1,55))),AllTrim(SubStr(SX5->X5_DESCRI,1,55))) + cNatOper
	    			Else
						cDescrNFSe := If(FindFunction('CleanSpecChar'),CleanSpecChar(AllTrim(SubStr(SX5->X5_DESCRI,1,55))),AllTrim(SubStr(SX5->X5_DESCRI,1,55)))    			
	    			EndIf
	    	    EndIf 
    		EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica as notas vinculadas                                            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !Empty((cAliasSD2)->D2_NFORI) 
				If (cAliasSD2)->D2_TIPO $ "DBN"
					dbSelectArea("SD1")
					dbSetOrder(1)
					If DbSeek(xFilial("SD1")+(cAliasSD2)->D2_NFORI+(cAliasSD2)->D2_SERIORI+(cAliasSD2)->D2_CLIENTE+(cAliasSD2)->D2_LOJA+(cAliasSD2)->D2_COD+(cAliasSD2)->D2_ITEMORI)
						dbSelectArea("SF1")
						dbSetOrder(1)
						DbSeek(xFilial("SF1")+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_TIPO)
						If SD1->D1_TIPO $ "DB"
							dbSelectArea("SA1")
							dbSetOrder(1)
							DbSeek(xFilial("SA1")+SD1->D1_FORNECE+SD1->D1_LOJA)
						Else
							dbSelectArea("SA2")
							dbSetOrder(1)
							DbSeek(xFilial("SA2")+SD1->D1_FORNECE+SD1->D1_LOJA)
						EndIf
						
						aadd(aNfVinc,{SD1->D1_EMISSAO,SD1->D1_SERIE,SD1->D1_DOC,IIF(SD1->D1_TIPO $ "DB",IIF(SD1->D1_FORMUL=="S",SM0->M0_CGC,SA1->A1_CGC),IIF(SD1->D1_FORMUL=="S",SM0->M0_CGC,SA2->A2_CGC)),SM0->M0_ESTCOB,SF1->F1_ESPECIE})
					EndIf
				Else
					aOldReg  := SD2->(GetArea())
					aOldReg2 := SF2->(GetArea())
					dbSelectArea("SD2")
					dbSetOrder(3)
					If DbSeek(xFilial("SD2")+(cAliasSD2)->D2_NFORI+(cAliasSD2)->D2_SERIORI+(cAliasSD2)->D2_CLIENTE+(cAliasSD2)->D2_LOJA+(cAliasSD2)->D2_COD+(cAliasSD2)->D2_ITEMORI)
						dbSelectArea("SF2")
						dbSetOrder(1)
						DbSeek(xFilial("SF2")+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA)
						If !SD2->D2_TIPO $ "DB"
							dbSelectArea("SA1")
							dbSetOrder(1)
							DbSeek(xFilial("SA1")+SD2->D2_CLIENTE+SD2->D2_LOJA)
						Else
							dbSelectArea("SA2")
							dbSetOrder(1)
							DbSeek(xFilial("SA2")+SD2->D2_CLIENTE+SD2->D2_LOJA)
						EndIf
						
						aadd(aNfVinc,{SF2->F2_EMISSAO,SD2->D2_SERIE,SD2->D2_DOC,SM0->M0_CGC,SM0->M0_ESTCOB,SF2->F2_ESPECIE})
					EndIf
					RestArea(aOldReg)
					RestArea(aOldReg2)
				EndIf
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Obtem os dados do produto                                               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
			dbSelectArea("SB1")
			dbSetOrder(1)
			DbSeek(xFilial("SB1")+(cAliasSD2)->D2_COD)
			
			dbSelectArea("SB5")
			dbSetOrder(1)
			DbSeek(xFilial("SB5")+(cAliasSD2)->D2_COD)
			//Veiculos Novos
			If AliasIndic("CD9")			
				dbSelectArea("CD9")
				dbSetOrder(1)
				DbSeek(xFilial("CD9")+"S"+(cAliasSD2)->D2_SERIE+(cAliasSD2)->D2_DOC+(cAliasSD2)->D2_CLIENTE+(cAliasSD2)->D2_LOJA+(cAliasSD2)->D2_ITEM)
			EndIf			
			//Medicamentos
			If AliasIndic("CD7")			
				dbSelectArea("CD7")
				dbSetOrder(1)
				DbSeek(xFilial("CD7")+"S"+(cAliasSD2)->D2_SERIE+(cAliasSD2)->D2_DOC+(cAliasSD2)->D2_CLIENTE+(cAliasSD2)->D2_LOJA+(cAliasSD2)->D2_ITEM)
			EndIf
			// Armas de Fogo
			If AliasIndic("CD8")						
				dbSelectArea("CD8")
				dbSetOrder(1) 
				DbSeek(xFilial("CD8")+"S"+(cAliasSD2)->D2_SERIE+(cAliasSD2)->D2_DOC+(cAliasSD2)->D2_CLIENTE+(cAliasSD2)->D2_LOJA+(cAliasSD2)->D2_ITEM)
			EndIf
			// Msg Zona Franca de Manaus / ALC
			dbSelectArea("SF3")
			dbSetOrder(4)
			If DbSeek(xFilial("SF3")+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_DOC+SF2->F2_SERIE)			
				If !SF3->F3_DESCZFR == 0
					cMensFis := "Total do desconto Ref. a Zona Franca de Manaus / ALC. R$ "+str(SF3->F3_VALOBSE-SF2->F2_DESCONT,13,2)
				EndIf 			
			EndIf			
			
			dbSelectArea("SC6")
			dbSetOrder(1)
			DbSeek(xFilial("SC6")+(cAliasSD2)->D2_PEDIDO+(cAliasSD2)->D2_ITEMPV+(cAliasSD2)->D2_COD)
			
			If !AllTrim(SC5->C5_MENNOTA) $ cMensCli
				cMensCli +=If(FindFunction('CleanSpecChar'),CleanSpecChar(AllTrim(SC5->C5_MENNOTA)),AllTrim(SC5->C5_MENNOTA))
			EndIf
			If !Empty(SC5->C5_MENPAD) .And. !AllTrim(FORMULA(SC5->C5_MENPAD)) $ cMensFis
				cMensFis += If(FindFunction('CleanSpecChar'),CleanSpecChar(AllTrim(FORMULA(SC5->C5_MENPAD))),AllTrim(FORMULA(SC5->C5_MENPAD)))
			EndIf
						
			cModFrete := IIF(SC5->C5_TPFRETE=="C","0","1")
			
			If Empty(aPedido)
				aPedido := {"",AllTrim(SC6->C6_PEDCLI),""}
			EndIf
			
			
			dbSelectArea("CD2")
			If !(cAliasSD2)->D2_TIPO $ "DB"
				dbSetOrder(1)
			Else
				dbSetOrder(2)
			EndIf
			If !DbSeek(xFilial("CD2")+"S"+SF2->F2_SERIE+SF2->F2_DOC+SF2->F2_CLIENTE+SF2->F2_LOJA+PadR((cAliasSD2)->D2_ITEM,4)+(cAliasSD2)->D2_COD)

			EndIf
			aadd(aISSQN,{0,0,0,"","",0})
			While !Eof() .And. xFilial("CD2") == CD2->CD2_FILIAL .And.;
				"S" == CD2->CD2_TPMOV .And.;
				SF2->F2_SERIE == CD2->CD2_SERIE .And.;
				SF2->F2_DOC == CD2->CD2_DOC .And.;
				SF2->F2_CLIENTE == IIF(!(cAliasSD2)->D2_TIPO $ "DB",CD2->CD2_CODCLI,CD2->CD2_CODFOR) .And.;
				SF2->F2_LOJA == IIF(!(cAliasSD2)->D2_TIPO $ "DB",CD2->CD2_LOJCLI,CD2->CD2_LOJFOR) .And.;
				(cAliasSD2)->D2_ITEM == SubStr(CD2->CD2_ITEM,1,Len((cAliasSD2)->D2_ITEM)) .And.;
				(cAliasSD2)->D2_COD == CD2->CD2_CODPRO
				
				Do Case
					Case AllTrim(CD2->CD2_IMP) == "ICM"
						aTail(aICMS) := {CD2->CD2_ORIGEM,CD2->CD2_CST,CD2->CD2_MODBC,CD2->CD2_PREDBC,CD2->CD2_BC,CD2->CD2_ALIQ,CD2->CD2_VLTRIB,0,CD2->CD2_QTRIB,CD2->CD2_PAUTA}
					Case AllTrim(CD2->CD2_IMP) == "SOL"
						aTail(aICMSST) := {CD2->CD2_ORIGEM,CD2->CD2_CST,CD2->CD2_MODBC,CD2->CD2_PREDBC,CD2->CD2_BC,CD2->CD2_ALIQ,CD2->CD2_VLTRIB,CD2->CD2_MVA,CD2->CD2_QTRIB,CD2->CD2_PAUTA}
						lCalSol := .T.
					Case AllTrim(CD2->CD2_IMP) == "IPI"
						aTail(aIPI) := {"","",0,"999",CD2->CD2_CST,CD2->CD2_BC,CD2->CD2_QTRIB,CD2->CD2_PAUTA,CD2->CD2_ALIQ,CD2->CD2_VLTRIB,CD2->CD2_MODBC,CD2->CD2_PREDBC}
					Case AllTrim(CD2->CD2_IMP) == "PS2"
						If (cAliasSD2)->D2_VALISS==0
							aTail(aPIS) := {CD2->CD2_CST,CD2->CD2_BC,CD2->CD2_ALIQ,CD2->CD2_VLTRIB,CD2->CD2_QTRIB,CD2->CD2_PAUTA}
						Else
							If Empty(aISS)
								aISS := {0,0,0,0,0}
							EndIf
							aISS[04]+= CD2->CD2_VLTRIB	
						EndIf
					Case AllTrim(CD2->CD2_IMP) == "CF2"
						If (cAliasSD2)->D2_VALISS==0
							aTail(aCOFINS) := {CD2->CD2_CST,CD2->CD2_BC,CD2->CD2_ALIQ,CD2->CD2_VLTRIB,CD2->CD2_QTRIB,CD2->CD2_PAUTA}
						Else
							If Empty(aISS)
								aISS := {0,0,0,0,0}
							EndIf
							aISS[05] += CD2->CD2_VLTRIB	
						EndIf
					Case AllTrim(CD2->CD2_IMP) == "PS3" .And. (cAliasSD2)->D2_VALISS==0
						aTail(aPISST) := {CD2->CD2_CST,CD2->CD2_BC,CD2->CD2_ALIQ,CD2->CD2_VLTRIB,CD2->CD2_QTRIB,CD2->CD2_PAUTA}
					Case AllTrim(CD2->CD2_IMP) == "CF3" .And. (cAliasSD2)->D2_VALISS==0
						aTail(aCOFINSST) := {CD2->CD2_CST,CD2->CD2_BC,CD2->CD2_ALIQ,CD2->CD2_VLTRIB,CD2->CD2_QTRIB,CD2->CD2_PAUTA}
					Case AllTrim(CD2->CD2_IMP) == "ISS"
						If Empty(aISS)
							aISS := {0,0,0,0,0}
						EndIf
						aISS[01] += (cAliasSD2)->D2_TOTAL+(cAliasSD2)->D2_DESCON
						aISS[02] += CD2->CD2_BC
						aISS[03] += CD2->CD2_VLTRIB	
						// São Bernardo - Tratamento para não apresentar error log quando UF e Codigo de municipio nao estiverem preenchidos 
						//Obs.: A obrigatoriedade dos campos do cadastro de cliente devem ser removidos para enviar o XML sem nenhum dado do tomador
						If (cCodMun $ "3548708" .and. !Empty(cMunPrest)) .and. (Empty(aDest[01]) .and. Empty(aDest[02]) .and. Empty(aDest[07]) .and. Empty(aDest[09]))
							cMunISS := cMunPrest
						Else
							cMunISS := ConvType2(aUF[aScan(aUF,{|x| x[1] == aDest[09]})][02]+aDest[07])
						EndIf
						If nAliq > 0
							If nAliq == CD2->CD2_ALIQ .And. lAglutina
								aISSQN[1][1] += CD2->CD2_BC 
								aISSQN[1][3] += CD2->CD2_VLTRIB
								aISSQN[1][6] += (cAliasSD2)->D2_DESCON
							Else
								lAglutina := .F.	                                                                                                       
								aTail(aISSQN) := {CD2->CD2_BC,CD2->CD2_ALIQ,CD2->CD2_VLTRIB,cMunISS,AllTrim((cAliasSD2)->D2_CODISS),(cAliasSD2)->D2_DESCON}
							EndIf
						Else
						    aTail(aISSQN) := {CD2->CD2_BC,CD2->CD2_ALIQ,CD2->CD2_VLTRIB,cMunISS,AllTrim((cAliasSD2)->D2_CODISS),(cAliasSD2)->D2_DESCON}
							nAliq := CD2->CD2_ALIQ
						EndIf	
				EndCase
				dbSelectArea("CD2")
				dbSkip()
			EndDo
			If lAglutina
				If Len(aProd) > 0			
					nX := aScan(aProd,{|x| x[24] == (cAliasSD2)->D2_CODISS .And. x[23] == IIF(SB1->(FieldPos("B1_TRIBMUN"))<>0,RetFldProd(SB1->B1_COD,"B1_TRIBMUN"),"")})
					If nX > 0						
						aProd[nx][13]+= (cAliasSD2)->D2_VALFRE // Valor Frete						
						aProd[nx][14]+= (cAliasSD2)->D2_SEGURO // Valor Seguro
						aProd[nx][15]+= ((cAliasSD2)->D2_DESCON+(cAliasSD2)->D2_DESCZFR) // Valor Desconto
						aProd[nx][21]+= SF3->F3_ISSSUB                       						
						aProd[nx][22]+= SF3->F3_ISSMAT
						aProd[nx][25]+= (cAliasSD2)->D2_BASEISS               
						aProd[nx][26]+= (cAliasSD2)->D2_VALFRE               						
						aProd[nx][27]+=	IIF(!(cAliasSD2)->D2_TIPO$"IP",(cAliasSD2)->D2_PRCVEN,0) * (cAliasSD2)->D2_QUANT // Valor Liquido
						aProd[nx][28]+=	IIF(!(cAliasSD2)->D2_TIPO$"IP",(cAliasSD2)->D2_PRCVEN,0) * (cAliasSD2)->D2_QUANT+((cAliasSD2)->D2_DESCON+(cAliasSD2)->D2_DESCZFR) //Valor Total						
						//aProd[nx][29]+=	SF3->F3_ISSSUB + SF3->F3_ISSMAT	//Valor Total de deducoes       Comentado para não duplicar o valor na tag ValorDeducoes
					Else
						lAglutina := .F.
					EndIF			                                                                                                                        					
				EndIf	
			EndIF
			If !lAglutina .Or. Len(aProd) == 0
				aadd(aProd,	{Len(aProd)+1,;
							(cAliasSD2)->D2_COD,;
							IIf(Val(SB1->B1_CODBAR)==0,"",Str(Val(SB1->B1_CODBAR),Len(SB1->B1_CODBAR),0)),;
							IIF(Empty(SC6->C6_DESCRI),SB1->B1_DESC,SC6->C6_DESCRI),;
							SB1->B1_POSIPI,;
							SB1->B1_EX_NCM,;
							(cAliasSD2)->D2_CF,;
							SB1->B1_UM,;
							(cAliasSD2)->D2_QUANT,;
							IIF(!(cAliasSD2)->D2_TIPO$"IP",(cAliasSD2)->D2_PRCVEN,0),;
							IIF(Empty(SB5->B5_UMDIPI),SB1->B1_UM,SB5->B5_UMDIPI),;
							IIF(Empty(SB5->B5_CONVDIPI),(cAliasSD2)->D2_QUANT,SB5->B5_CONVDIPI*(cAliasSD2)->D2_QUANT),;
							(cAliasSD2)->D2_VALFRE,;
							(cAliasSD2)->D2_SEGURO,;
							((cAliasSD2)->D2_DESCON+(cAliasSD2)->D2_DESCZFR),;
							IIF(!(cAliasSD2)->D2_TIPO$"IP",(cAliasSD2)->D2_PRCVEN+(((cAliasSD2)->D2_DESCON+(cAliasSD2)->D2_DESCZFR)/(cAliasSD2)->D2_QUANT),0),;
							IIF(SB1->(FieldPos("B1_CODSIMP"))<>0,SB1->B1_CODSIMP,""),; //codigo ANP do combustivel
							IIF(SB1->(FieldPos("B1_CODIF"))<>0,SB1->B1_CODIF,""),; //CODIF
							RetFldProd(SB1->B1_COD,"B1_CNAE"),;
							SF3->F3_RECISS,;
							SF3->F3_ISSSUB,;
							SF3->F3_ISSMAT,;   
							IIF(SB1->(FieldPos("B1_TRIBMUN"))<>0,RetFldProd(SB1->B1_COD,"B1_TRIBMUN"),""),;
							(cAliasSD2)->D2_CODISS,; 
							(cAliasSD2)->D2_BASEISS,;
							(cAliasSD2)->D2_VALFRE,;
							IIF(!(cAliasSD2)->D2_TIPO$"IP",(cAliasSD2)->D2_PRCVEN,0) * (cAliasSD2)->D2_QUANT,; // Valor Liquido
							IIF(!(cAliasSD2)->D2_TIPO$"IP",(cAliasSD2)->D2_PRCVEN,0) * (cAliasSD2)->D2_QUANT+((cAliasSD2)->D2_DESCON+(cAliasSD2)->D2_DESCZFR),; //Valor Total
							SF3->F3_ISSSUB + SF3->F3_ISSMAT,; //Valor Total de deducoes. 
							IIF(SF4->(FieldPos(cMVBENEFRJ))<> 0,SF4->(&(cMVBENEFRJ)),"" )}) // Código Beneficio Fiscal - NFS-e RJ
							
			EndIf											 

			aadd(aCST,{IIF(!Empty((cAliasSD2)->D2_CLASFIS),SubStr((cAliasSD2)->D2_CLASFIS,2,2),'50'),;
			           IIF(!Empty((cAliasSD2)->D2_CLASFIS),SubStr((cAliasSD2)->D2_CLASFIS,1,1),'0')})
			aadd(aICMS,{})
			aadd(aIPI,{})
			aadd(aICMSST,{})
			aadd(aPIS,{})
			aadd(aPISST,{})
			aadd(aCOFINS,{})
			aadd(aCOFINSST,{})
			//aadd(aISSQN,{0,0,0,"","",0})
			aadd(aAdi,{})
			aadd(aDi,{})				
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Tratamento para TAG Exportação quando existe a integração com a EEC     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ				
			If lEECFAT .And. !Empty((cAliasSD2)->D2_PREEMB)
				aadd(aExp,(GETNFEEXP((cAliasSD2)->D2_PREEMB)))				
			Else
				aadd(aExp,{})
			EndIf
			If AliasIndic("CD7")
				aadd(aMed,{CD7->CD7_LOTE,CD7->CD7_QTDLOT,CD7->CD7_FABRIC,CD7->CD7_VALID,CD7->CD7_PRECO})
			Else
				aadd(aMed,{})
   			EndIf
   			If AliasIndic("CD8")
				aadd(aArma,{CD8->CD8_TPARMA,CD8->CD8_NUMARMA,CD8->CD8_DESCR})                       
			Else
				aadd(aArma,{})
			EndIf			
			If AliasIndic("CD9")
				aadd(aveicProd,{IIF(CD9->CD9_TPOPER$"03",1,IIF(CD9->CD9_TPOPER$"1",2,IIF(CD9->CD9_TPOPER$"2",3,IIF(CD9->CD9_TPOPER$"9",0,"")))),;
								CD9->CD9_CHASSI,CD9->CD9_CODCOR,CD9->CD9_DSCCOR,CD9->CD9_POTENC,CD9->CD9_CM3POT,CD9->CD9_PESOLI,;
				                CD9->CD9_PESOBR,CD9->CD9_SERIAL,CD9->CD9_TPCOMB,CD9->CD9_NMOTOR,CD9->CD9_CMKG,CD9->CD9_DISTEI,CD9->CD9_RENAVA,;
				                CD9->CD9_ANOMOD,CD9->CD9_ANOFAB,CD9->CD9_TPPINT,CD9->CD9_TPVEIC,CD9->CD9_ESPVEI,CD9->CD9_CONVIN,CD9->CD9_CONVEI,;
				                CD9->CD9_CODMOD})
			Else
			    aadd(aveicProd,{})
			EndIf			
			
			aTotal[01] += (cAliasSD2)->D2_DESPESA
			aTotal[02] += (cAliasSD2)->D2_TOTAL	
			aTotal[03] := SF4->F4_ISSST			
			If lCalSol			
				dbSelectArea("SF3")
				dbSetOrder(4)
				If DbSeek(xFilial("SF3")+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_DOC+SF2->F2_SERIE)
					nPosI	:=	At (SF3->F3_ESTADO, cMVSUBTRIB)+2
					nPosF	:=	At ("/", SubStr (cMVSUBTRIB, nPosI))-1
					nPosF	:=	IIf(nPosF<=0,len(cMVSUBTRIB),nPosF)
					aAdd (aIEST, SubStr (cMVSUBTRIB, nPosI, nPosF))	//01 - IE_ST
				EndIf
			EndIf
			IF Empty(aPis[Len(aPis)]) .And. SF4->F4_CSTPIS=="06"
				aadd(aPisAlqZ,{SF4->F4_CSTPIS})
			Else
				aadd(aPisAlqZ,{})
			EndIf
			IF Empty(aCOFINS[Len(aCOFINS)]) .And. SF4->F4_CSTCOF=="06"
				aadd(aCofAlqZ,{SF4->F4_CSTCOF})
			Else 
				aadd(aCofAlqZ,{})
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Tratamento para Calcular o Desconto para  Belo Horizonte     		   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ				
			
			nDescon += (cAliasSD2)->D2_DESCICM
							
			dbSelectArea(cAliasSD2)
			dbSkip()
	    EndDo
	    If lQuery
	    	dbSelectArea(cAliasSD2)
	    	dbCloseArea()
	    	dbSelectArea("SD2")
	    EndIf
	
	EndIf
Else
	dbSelectArea("SF1")
	dbSetOrder(1)
	If DbSeek(xFilial("SF1")+cNota+cSerie+cClieFor+cLoja)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Tratamento temporario do CTe                                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
		If FunName() == "SPEDCTE" .Or. AModNot(SF1->F1_ESPECIE)=="57"
			cNFe := "CTe35080944990901000143570000000000200000168648"
			cString := '<infNFe versao="T02.00" modelo="57" >'
			cString += '<CTe xmlns="http://www.portalfiscal.inf.br/cte"><infCte Id="CTe35080944990901000143570000000000200000168648" versao="1.02"><ide><cUF>35</cUF><cCT>000016864</cCT><CFOP>6353</CFOP><natOp>ENTREGA NORMAL</natOp><forPag>1</forPag><mod>57</mod><serie>0</serie><nCT>20</nCT><dhEmi>2008-09-12T10:49:00</dhEmi><tpImp>2</tpImp><tpEmis>2</tpEmis><cDV>8</cDV><tpAmb>2</tpAmb><tpCTe>0</tpCTe><procEmi>0</procEmi><verProc>1.12a</verProc><cMunEmi>3550308</cMunEmi><xMunEmi>Sao Paulo</xMunEmi><UFEmi>SP</UFEmi><modal>01</modal><tpServ>0</tpServ><cMunIni>3550308</cMunIni><xMunIni>Sao Paulo</xMunIni><UFIni>SP</UFIni><cMunFim>3550308</cMunFim><xMunFim>Sao Paulo</xMunFim><UFFim>SP</UFFim><retira>1</retira><xDetRetira>TESTE</xDetRetira><toma03><toma>0</toma></toma03></ide><emit><CNPJ>44990901000143</CNPJ><IE>00000000000</IE><xNome>FILIAL SAO PAULO</xNome><xFant>Teste</xFant><enderEmit><xLgr>Av. Teste, S/N</xLgr><nro>0</nro><xBairro>Teste</xBairro><cMun>3550308</cMun><xMun>Sao Paulo</xMun><CEP>00000000</CEP><UF>SP</UF></enderEmit></emit><rem><CNPJ>58506155000184</CNPJ><IE>115237740114</IE><xNome>CLIENTE SP</xNome><xFant>CLIENTE SP</xFant><enderReme><xLgr>R</xLgr><nro>0</nro><xBairro>BAIRRO NAO CADASTRADO</xBairro><cMun>3550308</cMun><xMun>SAO PAULO</xMun><CEP>77777777</CEP><UF>SP</UF></enderReme><infOutros><tpDoc>00</tpDoc><dEmi>2008-09-17</dEmi></infOutros></rem><dest><CNPJ></CNPJ><IE></IE><xNome>CLIENTE RJ</xNome><enderDest><xLgr>R</xLgr><nro>0</nro><xBairro>BAIRRO NAO CADASTRADO</xBairro><cMun>3550308</cMun><xMun>RIO DE JANEIRO</xMun><CEP>44444444</CEP><UF>RJ</UF></enderDest></dest><vPrest><vTPrest>1.93</vTPrest><vRec>1.93</vRec></vPrest><imp><ICMS><CST00><CST>00</CST><vBC>250.00</vBC><pICMS>18.00</pICMS><vICMS>450.00</vICMS></CST00></ICMS></imp><infCteComp><chave>35080944990901000143570000000000200000168648</chave><vPresComp><vTPrest>10.00</vTPrest></vPresComp><impComp><ICMSComp><CST00Comp><CST>00</CST><vBC>10.00</vBC><pICMS>10.00</pICMS><vICMS>10.00</vICMS></CST00Comp></ICMSComp></impComp></infCteComp></infCte></CTe>'
			cString += '</infNFe>'
		Else				
			aadd(aNota,SF1->F1_SERIE)
			aadd(aNota,IIF(Len(SF1->F1_DOC)==6,"000","")+SF1->F1_DOC)
			aadd(aNota,SF1->F1_EMISSAO)
			aadd(aNota,cTipo)
			aadd(aNota,SF1->F1_TIPO)
			aadd(aNota,"1")			
			If SF1->F1_TIPO $ "DB" 
			    dbSelectArea("SA1")
				dbSetOrder(1)
				DbSeek(xFilial("SA1")+cClieFor+cLoja)
				
				aadd(aDest,AllTrim(SA1->A1_CGC))
				aadd(aDest,SA1->A1_NOME)
				aadd(aDest,MyGetEnd2(SA1->A1_END,"SA1")[1])
				aadd(aDest,ConvType2(IIF(MyGetEnd2(SA1->A1_END,"SA1")[2]<>0,MyGetEnd2(SA1->A1_END,"SA1")[2],"SN")))
				aadd(aDest,MyGetEnd2(SA1->A1_END,"SA1")[4])
				aadd(aDest,SA1->A1_BAIRRO)
				If !Upper(SA1->A1_EST) == "EX"
					aadd(aDest,SA1->A1_COD_MUN)
					aadd(aDest,SA1->A1_MUN)				
				Else
					aadd(aDest,"99999")			
					aadd(aDest,"EXTERIOR")
				EndIf
				aadd(aDest,Upper(SA1->A1_EST))
				aadd(aDest,SA1->A1_CEP)
				aadd(aDest,IIF(Empty(SA1->A1_PAIS),"1058"  ,Posicione("SYA",1,xFilial("SYA")+SA1->A1_PAIS,"YA_SISEXP")))
				aadd(aDest,IIF(Empty(SA1->A1_PAIS),"BRASIL",Posicione("SYA",1,xFilial("SYA")+SA1->A1_PAIS,"YA_DESCR" )))
				aadd(aDest,SA1->A1_DDD+SA1->A1_TEL)
				aadd(aDest,VldIE2(SA1->A1_INSCR,IIF(SA1->(FIELDPOS("A1_CONTRIB"))>0,SA1->A1_CONTRIB<>"2",.T.)))
				aadd(aDest,SA1->A1_SUFRAMA)
				aadd(aDest,SA1->A1_EMAIL)
									
			Else
			    dbSelectArea("SA2")
				dbSetOrder(1)
				DbSeek(xFilial("SA2")+cClieFor+cLoja)
		
				aadd(aDest,AllTrim(SA2->A2_CGC))
				aadd(aDest,SA2->A2_NOME)
				aadd(aDest,MyGetEnd2(SA2->A2_END,"SA2")[1])
				aadd(aDest,ConvType2(IIF(MyGetEnd2(SA2->A2_END,"SA2")[2]<>0,MyGetEnd2(SA2->A2_END,"SA2")[2],"SN")))
				aadd(aDest,MyGetEnd2(SA2->A2_END,"SA2")[4])
				aadd(aDest,SA2->A2_BAIRRO)
				If !Upper(SA2->A2_EST) == "EX"
					aadd(aDest,SA2->A2_COD_MUN)
					aadd(aDest,SA2->A2_MUN)				
				Else
					aadd(aDest,"99999")			
					aadd(aDest,"EXTERIOR")
				EndIf			
				aadd(aDest,Upper(SA2->A2_EST))
				aadd(aDest,SA2->A2_CEP)
				aadd(aDest,IIF(Empty(SA2->A2_PAIS),"1058"  ,Posicione("SYA",1,xFilial("SYA")+SA2->A2_PAIS,"YA_SISEXP")))
				aadd(aDest,IIF(Empty(SA2->A2_PAIS),"BRASIL",Posicione("SYA",1,xFilial("SYA")+SA2->A2_PAIS,"YA_DESCR")))
				aadd(aDest,SA2->A2_DDD+SA2->A2_TEL)
				aadd(aDest,VldIE2(SA2->A2_INSCR))
				aadd(aDest,"")//SA2->A2_SUFRAMA
				aadd(aDest,SA2->A2_EMAIL)
		
			EndIf
					
			If SF1->F1_TIPO $ "DB" 
			    dbSelectArea("SA1")
				dbSetOrder(1)
				DbSeek(xFilial("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA)	
			Else
			    dbSelectArea("SA2")
				dbSetOrder(1)
				DbSeek(xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA)	
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Analisa os impostos de retencao                                         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If SF1->(FieldPos("F1_VALPIS"))<>0 .And. SF1->F1_VALPIS>0
				aadd(aRetido,{"PIS",0,SF1->F1_VALPIS})
			EndIf
			If SF1->(FieldPos("F1_VALCOFI"))<>0 .And. SF1->F1_VALCOFI>0
				aadd(aRetido,{"COFINS",0,SF1->F1_VALCOFI})
			EndIf
			If SF1->(FieldPos("F1_VALCSLL"))<>0 .And. SF1->F1_VALCSLL>0
				aadd(aRetido,{"CSLL",0,SF1->F1_VALCSLL})
			EndIf
			If SF1->(FieldPos("F1_IRRF"))<>0 .And. SF1->F1_IRRF>0
				aadd(aRetido,{"IRRF",0,SF1->F1_IRRF})
			EndIf	
		If SF1->(FieldPos("F1_INSS"))<>0 .and. SF1->F1_INSS>0
				aadd(aRetido,{"INSS",SF1->F1_BASEINS,SF1->F1_INSS})
			EndIf
			dbSelectArea("SD1")
			dbSetOrder(1)	
			#IFDEF TOP
				lQuery  := .T.
				cAliasSD1 := GetNextAlias()
				BeginSql Alias cAliasSD1
					SELECT D1_FILIAL,D1_DOC,D1_SERIE,D1_FORNECE,D1_LOJA,D1_COD,D1_ITEM,D1_TES,D1_TIPO,
							D1_NFORI,D1_SERIORI,D1_ITEMORI,D1_CF,D1_QUANT,D1_TOTAL,D1_VALDESC,D1_VALFRE,
							D1_SEGURO,D1_DESPESA,D1_CODISS,D1_VALISS,D1_VALIPI,D1_ICMSRET,D1_VUNIT,D1_CLASFIS,
							D1_VALICM,D1_TIPO_NF,D1_PEDIDO,D1_ITEMPC,D1_VALIMP5,D1_VALIMP6,D1_CODISS,D1_BASEISS
					FROM %Table:SD1% SD1
					WHERE
					SD1.D1_FILIAL = %xFilial:SD1% AND
					SD1.D1_SERIE = %Exp:SF1->F1_SERIE% AND 
					SD1.D1_DOC = %Exp:SF1->F1_DOC% AND 
					SD1.D1_FORNECE = %Exp:SF1->F1_FORNECE% AND 
					SD1.D1_LOJA = %Exp:SF1->F1_LOJA% AND 
					SD1.D1_FORMUL = 'S' AND 
					SD1.%NotDel%
					ORDER BY %Order:SD1%
				EndSql
					
			#ELSE
				DbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
			#ENDIF
			While !Eof() .And. xFilial("SD1") == (cAliasSD1)->D1_FILIAL .And.;
				SF1->F1_SERIE == (cAliasSD1)->D1_SERIE .And.;
				SF1->F1_DOC == (cAliasSD1)->D1_DOC .And.;
				SF1->F1_FORNECE == (cAliasSD1)->D1_FORNECE .And.;
				SF1->F1_LOJA ==  (cAliasSD1)->D1_LOJA
				
	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Verifica a natureza da operacao                                         ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        
				//Pega descricao do pedido de venda-Parametro MV_NFESERV 
				dbSelectArea("SC5")
				dbSetOrder(1)
				DbSeek(xFilial("SC5")+(cAliasSD1)->D1_PEDIDO)

				dbSelectArea("SF4")
				dbSetOrder(1)
				DbSeek(xFilial("SF4")+(cAliasSD1)->D1_TES)				
				If lNatOper .And. !Empty(SC5->C5_MENNOTA)
					If cCodmun == "3300704-3156700"
						cNatOper+="$$$"
					Else	
						cNatOper+=" "
					EndIf
					cNatOper += Alltrim(If(FindFunction('CleanSpecChar'),CleanSpecChar(Alltrim(SC5->C5_MENNOTA)),SC5->C5_MENNOTA))+" "
				EndIf

				//Pega a descricao da SX5 tabela 60	
				dbSelectArea("SB1")
				dbSetOrder(1)
				DbSeek(xFilial("SB1")+(cAliasSD1)->D1_COD)

				dbSelectArea("SX5")
				dbSetOrder(1)
				
				If dbSeek(xFilial("SX5")+"60"+RetFldProd(SB1->B1_COD,"B1_CODISS"))	
					If cCodmun == "3300704-3156700"
						cNatOper :=If(FindFunction('CleanSpecChar'),CleanSpecChar(AllTrim(SubStr(SX5->X5_DESCRI,1,55))),AllTrim(SubStr(SX5->X5_DESCRI,1,55))) + cNatOper
					Else
						cNatOper += If(FindFunction('CleanSpecChar'),CleanSpecChar(AllTrim(SubStr(SX5->X5_DESCRI,1,55))),AllTrim(SubStr(SX5->X5_DESCRI,1,55)))
                    EndIf
	    		EndIf 
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Verifica as notas vinculadas                                            ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
				If !Empty((cAliasSD1)->D1_NFORI) 
					If !(cAliasSD1)->D1_TIPO $ "DBN"
						aOldReg  := SD1->(GetArea())
						aOldReg2 := SF1->(GetArea())
						dbSelectArea("SD1")
						dbSetOrder(1)
						If DbSeek(xFilial("SD1")+(cAliasSD1)->D1_NFORI+(cAliasSD1)->D1_SERIORI+(cAliasSD1)->D1_FORNECE+(cAliasSD1)->D1_LOJA+(cAliasSD1)->D1_COD+(cAliasSD1)->D1_ITEMORI)
							dbSelectArea("SF1")
							dbSetOrder(1)
							DbSeek(xFilial("SF1")+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_TIPO)
							If SD1->D1_TIPO $ "DB"
								dbSelectArea("SA1")
								dbSetOrder(1)
								DbSeek(xFilial("SA1")+SD1->D1_FORNECE+SD1->D1_LOJA)
							Else
								dbSelectArea("SA2")
								dbSetOrder(1)
								DbSeek(xFilial("SA2")+SD1->D1_FORNECE+SD1->D1_LOJA)
							EndIf
							
							aadd(aNfVinc,{SD1->D1_EMISSAO,SD1->D1_SERIE,SD1->D1_DOC,IIF(SD1->D1_TIPO $ "DB",IIF(SD1->D1_FORMUL=="S",SM0->M0_CGC,SA1->A1_CGC),IIF(SD1->D1_FORMUL=="S",SM0->M0_CGC,SA2->A2_CGC)),SM0->M0_ESTCOB,SF1->F1_ESPECIE})
						EndIf
						RestArea(aOldReg)
						RestArea(aOldReg2)
					Else					
						dbSelectArea("SD2")
						dbSetOrder(3)
						If DbSeek(xFilial("SD2")+(cAliasSD1)->D1_NFORI+(cAliasSD1)->D1_SERIORI+(cAliasSD1)->D1_FORNECE+(cAliasSD1)->D1_LOJA+(cAliasSD1)->D1_COD+(cAliasSD1)->D1_ITEMORI)
							dbSelectArea("SF2")
							dbSetOrder(1)
							DbSeek(xFilial("SF2")+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA)
							If !SD2->D2_TIPO $ "DB"
								dbSelectArea("SA1")
								dbSetOrder(1)
								DbSeek(xFilial("SA1")+SD2->D2_CLIENTE+SD2->D2_LOJA)
							Else
								dbSelectArea("SA2")
								dbSetOrder(1)
								DbSeek(xFilial("SA2")+SD2->D2_CLIENTE+SD2->D2_LOJA)
							EndIf
							
							aadd(aNfVinc,{SD2->D2_EMISSAO,SD2->D2_SERIE,SD2->D2_DOC,SM0->M0_CGC,SM0->M0_ESTCOB,SF2->F2_ESPECIE})
							
						EndIf
					EndIf
				
				EndIf
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Obtem os dados do produto                                               ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
				dbSelectArea("SB1")
				dbSetOrder(1)
				DbSeek(xFilial("SB1")+(cAliasSD1)->D1_COD)
				//Veiculos Novos
				If AliasIndic("CD9")			
					dbSelectArea("CD9")
					dbSetOrder(1)
					DbSeek(xFilial("CD9")+"E"+(cAliasSD1)->D1_SERIE+(cAliasSD1)->D1_DOC+(cAliasSD1)->D1_FORNECE+(cAliasSD1)->D1_LOJA+(cAliasSD1)->D1_ITEM)
				EndIf			
				//Medicamentos
				If AliasIndic("CD7")
					dbSelectArea("CD7")
					dbSetOrder(1)
					DbSeek(xFilial("CD7")+"E"+(cAliasSD1)->D1_SERIE+(cAliasSD1)->D1_DOC+(cAliasSD1)->D1_FORNECE+(cAliasSD1)->D1_LOJA+(cAliasSD1)->D1_ITEM)
				EndIf
	            // Armas de Fogo
	            If AliasIndic("CD8")
					dbSelectArea("CD8")
					dbSetOrder(1)
					DbSeek(xFilial("CD8")+"E"+(cAliasSD1)->D1_SERIE+(cAliasSD1)->D1_DOC+(cAliasSD1)->D1_FORNECE+(cAliasSD1)->D1_LOJA+(cAliasSD1)->D1_ITEM)
				EndIf
				
				dbSelectArea("SB5")
				dbSetOrder(1)
				DbSeek(xFilial("SB5")+(cAliasSD1)->D1_COD)
									
				cModFrete := IIF(SF1->F1_FRETE>0,"0","1")
							
				aadd(aProd,	{Len(aProd)+1,;
								(cAliasSD1)->D1_COD,;
								IIf(Val(SB1->B1_CODBAR)==0,"",Str(Val(SB1->B1_CODBAR),Len(SB1->B1_CODBAR),0)),;
								SB1->B1_DESC,;
								SB1->B1_POSIPI,;
								SB1->B1_EX_NCM,;
								(cAliasSD1)->D1_CF,;
								SB1->B1_UM,;
								(cAliasSD1)->D1_QUANT,;
								IIF(!(cAliasSD1)->D1_TIPO$"IP",(cAliasSD1)->D1_VUNIT,0),;
								IIF(Empty(SB5->B5_UMDIPI),SB1->B1_UM,SB5->B5_UMDIPI),;
								IIF(Empty(SB5->B5_CONVDIPI),(cAliasSD1)->D1_QUANT,SB5->B5_CONVDIPI*(cAliasSD1)->D1_QUANT),;
								(cAliasSD1)->D1_VALFRE,;
								(cAliasSD1)->D1_SEGURO,;
								(cAliasSD1)->D1_VALDESC,;
								IIF(!(cAliasSD1)->D1_TIPO$"IP",(cAliasSD1)->D1_VUNIT,0),;
								IIF(SB1->(FieldPos("B1_CODSIMP"))<>0,SB1->B1_CODSIMP,""),; //codigo ANP do combustivel
								IIF(SB1->(FieldPos("B1_CODIF"))<>0,SB1->B1_CODIF,""),; //CODIF
								RetFldProd(SB1->B1_COD,"B1_CNAE"),;
								SF3->F3_RECISS,;
								SF3->F3_ISSSUB,;
								SF3->F3_ISSMAT,;
								IIF(SB1->(FieldPos("B1_TRIBMUN"))<>0,RetFldProd(SB1->B1_COD,"B1_TRIBMUN"),""),;
								(cAliasSD1)->D1_CODISS,; 
								(cAliasSD1)->D1_BASEISS,;
								}) 

				aadd(aCST,{IIF(!Empty((cAliasSD1)->D1_CLASFIS),SubStr((cAliasSD1)->D1_CLASFIS,2,2),'50'),;
							IIF(!Empty((cAliasSD1)->D1_CLASFIS),SubStr((cAliasSD1)->D1_CLASFIS,1,1),'0')})
				aadd(aICMS,{})
				aadd(aIPI,{})
				aadd(aICMSST,{})
				aadd(aPIS,{})
				aadd(aPISST,{})
				aadd(aCOFINS,{})
				aadd(aCOFINSST,{})
				aadd(aISSQN,{})
				aadd(aExp,{})				
				If lEasy				
					If !(cAliasSD1)->D1_TIPO$"IP" 
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Tratamento para TAG Importação quando existe a integração com a EIC  (Se a nota for primeira ou unica)|
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						aadd(aDI,(GetNFEIMP(.F.,(cAliasSD1)->D1_DOC,(cAliasSD1)->D1_SERIE,(cAliasSD1)->D1_FORNECE,(cAliasSD1)->D1_LOJA,(cAliasSD1)->D1_TIPO_NF,(cAliasSD1)->D1_PEDIDO,(cAliasSD1)->D1_ITEMPC)))
					Else
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Tratamento para TAG Importação quando existe a integração com a EIC  (Se a nota for complementar)     |
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						aadd(aDI,(GetNFEIMP(.F.,(cAliasSD1)->D1_NFORI,(cAliasSD1)->D1_SERIORI,(cAliasSD1)->D1_FORNECE,(cAliasSD1)->D1_LOJA ,(cAliasSD1)->D1_TIPO_NF, ,(cAliasSD1)->D1_ITEMORI)))
					EndIf
					aAdi := aDI				
				Else
					aadd(aAdi,{})
					aadd(aDi,{})
				EndIf



				If AliasIndic("CD7")
					aadd(aMed,{CD7->CD7_LOTE,CD7->CD7_QTDLOT,CD7->CD7_FABRIC,CD7->CD7_VALID,CD7->CD7_PRECO})
				Else
					aadd(aMed,{})
				EndIf
				If AliasIndic("CD8")
					aadd(aArma,{CD8->CD8_TPARMA,CD8->CD8_NUMARMA,CD8->CD8_DESCR})
				Else
					aadd(aArma,{})
				EndIf
				If AliasIndic("CD9")
					aadd(aveicProd,{CD9->CD9_TPOPER,CD9->CD9_CHASSI,CD9->CD9_CODCOR,CD9->CD9_DSCCOR,CD9->CD9_POTENC,CD9->CD9_CM3POT,CD9->CD9_PESOLI,;
					                CD9->CD9_PESOBR,CD9->CD9_SERIAL,CD9->CD9_TPCOMB,CD9->CD9_NMOTOR,CD9->CD9_CMKG,CD9->CD9_DISTEI,CD9->CD9_RENAVA,;
					                CD9->CD9_ANOMOD,CD9->CD9_ANOFAB,CD9->CD9_TPPINT,CD9->CD9_TPVEIC,CD9->CD9_ESPVEI,CD9->CD9_CONVIN,CD9->CD9_CONVEI,;
					                CD9->CD9_CODMOD})
				Else
				    aadd(aveicProd,{})
				EndIf
				dbSelectArea("CD2")
				If !(cAliasSD1)->D1_TIPO $ "DB"			
					dbSetOrder(2)
				Else
					dbSetOrder(1)
				EndIf
				DbSeek(xFilial("CD2")+"E"+SF1->F1_SERIE+SF1->F1_DOC+SF1->F1_FORNECE+SF1->F1_LOJA+PadR((cAliasSD1)->D1_ITEM,4)+(cAliasSD1)->D1_COD)
				While !Eof() .And. xFilial("CD2") == CD2->CD2_FILIAL .And.;
					"E" == CD2->CD2_TPMOV .And.;
					SF1->F1_SERIE == CD2->CD2_SERIE .And.;
					SF1->F1_DOC == CD2->CD2_DOC .And.;
					SF1->F1_FORNECE == IIF(!(cAliasSD1)->D1_TIPO $ "DB",CD2->CD2_CODFOR,CD2->CD2_CODCLI) .And.;
					SF1->F1_LOJA == IIF(!(cAliasSD1)->D1_TIPO $ "DB",CD2->CD2_LOJFOR,CD2->CD2_LOJCLI) .And.;				
					(cAliasSD1)->D1_ITEM == SubStr(CD2->CD2_ITEM,1,Len((cAliasSD1)->D1_ITEM)) .And.;
					(cAliasSD1)->D1_COD == CD2->CD2_CODPRO
					
					Do Case
						Case AllTrim(CD2->CD2_IMP) == "ICM"
							aTail(aICMS) := {CD2->CD2_ORIGEM,CD2->CD2_CST,CD2->CD2_MODBC,CD2->CD2_PREDBC,CD2->CD2_BC,CD2->CD2_ALIQ,CD2->CD2_VLTRIB,0,CD2->CD2_QTRIB,CD2->CD2_PAUTA}
						Case AllTrim(CD2->CD2_IMP) == "SOL"
							aTail(aICMSST) := {CD2->CD2_ORIGEM,CD2->CD2_CST,CD2->CD2_MODBC,CD2->CD2_PREDBC,CD2->CD2_BC,CD2->CD2_ALIQ,CD2->CD2_VLTRIB,CD2->CD2_MVA,CD2->CD2_QTRIB,CD2->CD2_PAUTA}
						Case AllTrim(CD2->CD2_IMP) == "IPI"
							aTail(aIPI) := {"","",0,"999",CD2->CD2_CST,CD2->CD2_BC,CD2->CD2_QTRIB,CD2->CD2_PAUTA,CD2->CD2_ALIQ,CD2->CD2_VLTRIB,CD2->CD2_MODBC,CD2->CD2_PREDBC}
						Case AllTrim(CD2->CD2_IMP) == "ISS"
							If Empty(aISS)
								aISS := {0,0,0,0,0}
							EndIf
							aISS[01] += (cAliasSD1)->D1_TOTAL
							aISS[02] += CD2->CD2_BC
							aISS[03] += CD2->CD2_VLTRIB					
						Case AllTrim(CD2->CD2_IMP) == "PS2"
							If (cAliasSD1)->D1_VALISS==0
								aTail(aPIS) := {CD2->CD2_CST,CD2->CD2_BC,CD2->CD2_ALIQ,CD2->CD2_VLTRIB,CD2->CD2_QTRIB,CD2->CD2_PAUTA}
							Else
								If Empty(aISS)
									aISS := {0,0,0,0,0}
								EndIf
								aISS[04]          += CD2->CD2_VLTRIB	
							EndIf
						Case AllTrim(CD2->CD2_IMP) == "CF2"
							If (cAliasSD1)->D1_VALISS==0
								aTail(aCOFINS) := {CD2->CD2_CST,CD2->CD2_BC,CD2->CD2_ALIQ,CD2->CD2_VLTRIB,CD2->CD2_QTRIB,CD2->CD2_PAUTA}
							Else
								If Empty(aISS)
									aISS := {0,0,0,0,0}
								EndIf
								aISS[05] += CD2->CD2_VLTRIB	
							EndIf
						Case AllTrim(CD2->CD2_IMP) == "PS3" .And. (cAliasSD1)->D1_VALISS==0
							aTail(aPISST) := {CD2->CD2_CST,CD2->CD2_BC,CD2->CD2_ALIQ,CD2->CD2_VLTRIB,CD2->CD2_QTRIB,CD2->CD2_PAUTA}
						Case AllTrim(CD2->CD2_IMP) == "CF3" .And. (cAliasSD1)->D1_VALISS==0
							aTail(aCOFINSST) := {CD2->CD2_CST,CD2->CD2_BC,CD2->CD2_ALIQ,CD2->CD2_VLTRIB,CD2->CD2_QTRIB,CD2->CD2_PAUTA}
						Case AllTrim(CD2->CD2_IMP) == "ISS"
							If Empty(aISS)
								aISS := {0,0,0,0,0}
							EndIf
							aISS[01] += (cAliasSD1)->D1_TOTAL
							aISS[02] += CD2->CD2_BC
							aISS[03] += CD2->CD2_VLTRIB	
							aTail(aISSQN) := {CD2->CD2_BC,CD2->CD2_ALIQ,CD2->CD2_VLTRIB,"",AllTrim((cAliasSD1)->D1_CODISS),AllTrim((cAliasSD1)->D1_VALDESC)}
					EndCase
					
					dbSelectArea("CD2")
					dbSkip()
				EndDo

				IF Empty(aPis[Len(aPis)]) .And. SF4->F4_CSTPIS=="06"
					aadd(aPisAlqZ,{SF4->F4_CSTPIS})
				Else
					aadd(aPisAlqZ,{})
				EndIf
				IF Empty(aCOFINS[Len(aCOFINS)]) .And. SF4->F4_CSTCOF=="06"
					aadd(aCofAlqZ,{SF4->F4_CSTCOF})
				Else 
					aadd(aCofAlqZ,{})
				EndIf								

				aTotal[01] += (cAliasSD1)->D1_DESPESA
				aTotal[02] += (cAliasSD1)->D1_TOTAL-(cAliasSD1)->D1_VALDESC+(cAliasSD1)->D1_VALFRE+(cAliasSD1)->D1_SEGURO+(cAliasSD1)->D1_DESPESA;
								+IIF((cAliasSD1)->D1_TIPO$"IP",0,(cAliasSD1)->D1_VALIPI)+(cAliasSD1)->D1_ICMSRET;
								+IIF(SF4->F4_AGREG$"I",(cAliasSD1)->D1_VALICM,0);
								+IIF(SF4->F4_AGRPIS=="1",(cAliasSD1)->D1_VALIMP6,0);
								+IIF(SF4->F4_AGRCOF=="1",(cAliasSD1)->D1_VALIMP5,0)
				aTotal[03] := SF4->F4_ISSST
				dbSelectArea(cAliasSD1)
				dbSkip()
		    EndDo	
		    If lQuery
		    	dbSelectArea(cAliasSD1)
		    	dbCloseArea()
		    	dbSelectArea("SD1")
		    EndIf
		EndIf
	EndIf
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Geracao do arquivo XML                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If !Empty(aNota)
	cString := '<RPS Id="rps:'+AllTrim(Str(Val(aNota[02])))+'">'
	cString += NFSEAssina2(cCodMun,aNota,aProd,aTotal,aDest)
	cString += NFSECab2(cCodMun,aNota)	
	If cCodMun $ "3548708" .and. (Empty(aDest[01]) .and. Empty(aDest[02]))
		cString += "" 
	Else
		cString += NFSEDest2(cCodMun,aDest)
	EndIf
	cString += NFSEConstr(cCodmun,aConstr)
	cString += NFSEFat2(cCodMun,aDupl)	
	cString += NFSEItem2(cCodMun,aProd,aICMS,aICMSST,aIPI,aPIS,aPISST,aCOFINS,aCOFINSST,aISSQN,aCST,aMed,aArma,aveicProd,aDI,aAdi,aExp,aPisAlqZ,aCofAlqZ,aDest, aNota,aTotal,aRetido,aRetServ,aDeducao,cMunPrest,cDescMunP,cNatOper,cF4Agreg,lNFeDesc,cDescrNFSe,cDiscrNFSe,@nDescon)
	cString += NFSETransp2(cCodMun)
	cString += '</RPS>' 

EndIf	

Return({EncodeUTF8(cString),cNfe})

Static Function NFSEAssina2(cCodMun,aNota,aProd,aTotal,aDest)
Local cAssinatura := ""  

cAssinatura += StrZero(Val(SM0->M0_INSCM),11) 
cAssinatura += "NF   "  
cAssinatura += Strzero(Val(aNota[02]),12)       
cAssinatura += Dtos(aNota[03])
                        
If cCodMun == "3550308" .or. cCodMun == "2611606"
	Do Case
		Case aTotal[3] $ "1"    //Tributação no municipio
			cAssinatura += "T " 
	    Case aTotal[3] $ "2"    //Tributação fora do municipio
			cAssinatura += "F "
		Case aTotal[3] $ "3"    //Isento
			cAssinatura += "I "
	    Case aTotal[3] $ "5"    //ISS Suspenso por Decisão Judicial
			cAssinatura += "J "
		OtherWise
			cAssinatura += "T "
	EndCase		
Else

	Do Case
		Case aTotal[3] $ "2"
			cAssinatura += "E "
	    Case aTotal[3] $ "3"
			cAssinatura += "C "
		Case aTotal[3] $ "4"
			cAssinatura += "F "
	    Case aTotal[3] $ "5"
			cAssinatura += "K "
	    Case aTotal[3] $ "6"
			cAssinatura += "K "
		OtherWise
			cAssinatura += "T "
	EndCase
EndIf

cAssinatura += "N"
cAssinatura += Iif((aProd[1][20])=='1',"S","N")
cAssinatura += StrZero(aTotal[2] *100,15)  //valor do servico
cAssinatura += "000000000000000"    // valor da deducao
cAssinatura += AllTrim(StrZero(Val(aProd[1][19]),10))
cAssinatura += AllTrim(StrZero(Val(aDest[01]),14))

//MemoWrite("c:\p10\xml\"+"RPS"+Strzero(Val(aNota[02]),9)+".TXT",cAssinatura)

cAssinatura := AllTrim(Lower(Sha1(AllTrim(cAssinatura),2)))
cAssinatura := '<Assinatura>'+cAssinatura+'</Assinatura>'

Return(cAssinatura)             

//Cabeçalho
Static Function NfseCab2(cCodMun,aNota)
Local cString := ""
Local cImPrestador:=AllTrim(SM0->M0_INSCM)
Local cEmail:=""  
Local lUsaGesEmp := IIF(FindFunction("FWFilialName") .And. FindFunction("FWSizeFilial") .And. FWSizeFilial() > 2,.T.,.F.)
                                       

cImPrestador := StrTran(cImPrestador,"-","")
cImPrestador := StrTran(cImPrestador,"/","")
 
cString += '<InscricaoMunicipalPrestador>'+ cImPrestador+'</InscricaoMunicipalPrestador>'
cString += '<CPFCNPJPrestador>'+AllTrim(SM0->M0_CGC)+'</CPFCNPJPrestador>'
cString += '<RazaoSocialPrestador>'+AllTrim(SM0->M0_NOMECOM)+'</RazaoSocialPrestador>' 
If cCodMun $ '4303905-4307906'
	cString += '<LogradouroPrestador>'+AllTrim(SM0->M0_ENDCOB)+'</LogradouroPrestador>' 
	cString += '<NumeroEnderecoPrestador>'+Substr(AllTrim(SM0->M0_ENDCOB),RAT(",",AllTrim(SM0->M0_ENDCOB))+1,5)+'</NumeroEnderecoPrestador>' 
	cString += '<BairroPrestador>'+AllTrim(SM0->M0_BAIRCOB)+'</BairroPrestador>' 
Endif
cString += '<NFantasiaPrestador>'+IIF(lUsaGesEmp,FWFilialName(),Alltrim(SM0->M0_NOME))+'</NFantasiaPrestador>'
cString += '<CidadePrestador>'+AllTrim(SM0->M0_CODMUN)+'</CidadePrestador>'  
cString += '<UFPrestador>'+AllTrim(SM0->M0_ESTCOB)+'</UFPrestador>'  
cString += '<EmailPrestador>'+cEmail+'</EmailPrestador>'  
cString += '<TipoRPS>1</TipoRPS>'
cString += '<SerieRPS>'+AllTrim(aNota[01])+'</SerieRPS>'
cString += '<NumeroRPS>'+AllTrim(Str(Val(aNota[02])))+'</NumeroRPS>'  
If cCodMun $ '4303905-4307906'
	cString += '<DataEmissaoRPS>'+Substr(Dtos(aNota[03]),1,4)+"-"+  Substr(Dtos(aNota[03]),5,2)+"-"+ Substr(Dtos(aNota[03]),7,2)+'</DataEmissaoRPS>'
Else
	cString += '<DataEmissaoRPS>'+Substr(Dtos(aNota[03]),1,4)+"-"+  Substr(Dtos(aNota[03]),5,2)+"-"+ Substr(Dtos(aNota[03]),7,2)+'T'+Time()+'</DataEmissaoRPS>'
EndIf
cString += '<SituacaoRPS>N</SituacaoRPS>'
cString += '<NumeroRPSSubstituido>'+aNota[07]+'</NumeroRPSSubstituido>'
cString += '<SerieRPSSubstituido>'+AllTrim(aNota[08])+'</SerieRPSSubstituido>'
cString += '<TipoRPSSubstituido>1</TipoRPSSubstituido>'
cString += '<NfseIdSubstituido>'+aNota[08]+aNota[07]+'</NfseIdSubstituido>'
cString += '<DataEmissaoNFSeSubstituida>1900-01-01</DataEmissaoNFSeSubstituida>'
cString += '<SeriePrestacao>99</SeriePrestacao>'

Return(cString)


//Tomador
Static Function NFSEDest2(cCodMun,aDest)
Local cString := ""  
Local cCodTom := ""

If cCodMun == "3550308" // Para o município de SP a tag deve ser gerada com 8 zeros nos casos abaixo
	cString += '<InscricaoMunicipalTomador>'+Iif(Upper(aDest[17])=='ISENTO' .OR. Empty(aDest[17]),"00000000",aDest[17])+'</InscricaoMunicipalTomador>'
ElseIf cCodMun == "4113700"  //Londrina
	cString += '<InscricaoMunicipalTomador>'+Iif(Upper(aDest[17])=='ISENTO' .OR. Empty(aDest[17]),"",aDest[17])+'</InscricaoMunicipalTomador>'
Else
	cString += '<InscricaoMunicipalTomador>'+Iif(Upper(aDest[17])=='ISENTO' .OR. Empty(aDest[17]),"0000000",aDest[17])+'</InscricaoMunicipalTomador>'
EndIf		

If aDest[09]<> "EX" 
	If  cCodMun == "3304557" .And. Empty(aDest[01])
		cString += ''
	ElseIf  cCodMun $ '4108304' .And. Empty(aDest[01])
		cString += '<CPFCNPJTomador>99999999999</CPFCNPJTomador>'
	Else
		cString += '<CPFCNPJTomador>'+AllTrim(aDest[01])+'</CPFCNPJTomador>'
	EndIf
Endif
cString += '<RazaoSocialTomador>'+AllTrim(aDest[02])+'</RazaoSocialTomador>'
cString += '<TipoLogradouroTomador>Rua</TipoLogradouroTomador>'
cString += '<LogradouroTomador>'+AllTrim(aDest[03])+'</LogradouroTomador>'
cString += '<NumeroEnderecoTomador>'+AllTrim(aDest[04])+'</NumeroEnderecoTomador>'

If !Empty(aDest[05])
	cString += '<ComplementoEnderecoTomador>'+AllTrim(aDest[05])+'</ComplementoEnderecoTomador>'
Else
	cString += '<ComplementoEnderecoTomador>-</ComplementoEnderecoTomador>'
EndIf

cCodTom := aDest[07] // SA1->A1_COD_MUN
If Len( cCodTom ) <= 5 .And. (!(cCodTom$'99999').Or. (cCodTom$'99999' .And. SM0->M0_CODMUN == '3550308'))
	cCodTom := UFCodIBGE2(aDest[09]) + cCodTom
EndIf
	
cString += '<TipoBairroTomador>Bairro</TipoBairroTomador>'
cString += '<BairroTomador>'+AllTrim(aDest[06])+'</BairroTomador>'

If cCodMun == "5208707"  //Goiania
	cString += '<CidadeTomadorPrefeitura>'+AllTrim(aDest[23])+'</CidadeTomadorPrefeitura>' 
EndIf

cString += '<CidadeTomador>'+ cCodTom +'</CidadeTomador>'
cString += '<CidadeTomadorDescricao>'+AllTrim(aDest[08])+'</CidadeTomadorDescricao>'
cString += '<UFTomador>'+AllTrim(aDest[09])+'</UFTomador>'
cString += '<CEPTomador>'+AllTrim(aDest[10])+'</CEPTomador>'
cString += '<EmailTomador>'+AllTrim(aDest[16])+'</EmailTomador>'
cString += '<DescrPaisTomador>'+AllTrim(aDest[12])+'</DescrPaisTomador>'                                           

Return(cString)

/* Construção Civil */
Static Function NFSEConstr(cCodmun,aConstr)
Local cString := ""

	If !Empty(aConstr)
		cString += '<CodigoObra>'+AllTrim(aConstr[01])+'</CodigoObra>'
		cString += '<Art>'+AllTrim(aConstr[02])+'</Art>'
	EndIf 
	
Return(cString)


//Fatura
Static Function NFSEFat2(cCodMun,aDupl)
Local cString := ""

Return(cString)


//Serviço
Static Function NFSEItem2(cCodMun,aProd,aICMS,aICMSST,aIPI,aPIS,aPISST,aCOFINS,aCOFINSST,aISSQN,aCST,aMed,aArma,aveicProd,aDI,aAdi,aExp,aPisAlqZ,aCofAlqZ, aDest, aNota, aTotal,aRetido,aRetServ,aDeducao,cMunPrest,cDescMunP,cNatOper,cF4Agreg,lNFeDesc,cDescrNFSe,cDiscrNFSe,nDescon)
                      
Local cXml       := ""
Local cString    := ""
Local Nx         := 0
Local nDeduz     := 0
Local aPisXml    := {0,0}
Local aCofinsXml := {0,0}
Local aCSLLXml   := {0,0}
Local aIrrfXml   := {0,0}
Local aInssXml   := {0,0} 
Local aIssRet    := {0,"",0}
Local cIncCult   := ""   
Local nBaseIss   := 0
Local nOutRet    := 0  
Local nValLiq    := 0
Local cMVREGIESP :=	AllTrim(GetNewPar("MV_REGIESP",""))
Local cMVOPTSIMP :=	AllTrim(GetNewPar("MV_OPTSIMP","2"))
Local cMVINCECUL :=	AllTrim(GetNewPar("MV_INCECUL","2"))
Local cMVINCEFIS := AllTrim(GetNewPar("MV_INCEFIS","2"))
Local cMVNumProc := AllTrim(GetNewPar("MV_NUMPROC"," "))
Local cAuxMun    := ""  
Local cTributa   := ""
//Local cCodPres := ""

DEFAULT aICMS    := {}
DEFAULT aICMSST  := {}
DEFAULT aIPI     := {}
DEFAULT aPIS     := {}
DEFAULT aPISST   := {}
DEFAULT aCOFINS  := {}
DEFAULT aCOFINSST:= {}
DEFAULT aISSQN   := {}
DEFAULT aMed     := {}
DEFAULT aArma    := {}
DEFAULT aveicProd:= {}
DEFAULT aDI		 := {}
DEFAULT aAdi	 := {}
DEFAULT aExp	 := {}
DEFAULT cMunPrest:= ""
DEFAULT cDescMunP:= ""
DEFAULT lNFeDesc := .F.

If Len( cMunPrest ) <= 5 .And. cCodMun <> "5208707" //Goiania
	cMunPrest := UFCodIBGE2(aDest[09]) + cMunPrest
elseif cCodMun == "5208707" .and. !Empty(aTotal[03])  	//Goiania
	cMunPrest := ( iif(aTotal[03]=='1', "025300" , cMunPrest ))
	cDescMunP := ( iif(aTotal[03]=='1', "Goiania", cDescMunP ))		
EndIf 
aDest[13] := AllTrim(StrTran(aDest[13],"-",""))

cString := '' 
	
cString += '<CodigoAtividade>'+AllTrim(aProd[1][19])+'</CodigoAtividade>'                                                        
cString += '<AliquotaAtividade>'+ConvType2(Iif(!Empty(aISSQN[1][02]),aISSQN[1][02],aIssRet[3])/100,15,4)+'</AliquotaAtividade>'
cString += '<TipoRecolhimento>'+Iif((aProd[1][20])=='1',"R","A")+'</TipoRecolhimento>'
cString += '<MunicipioPrestacao>'+cMunPrest+'</MunicipioPrestacao>'
cString += '<MunicipioPrestacaoDescricao>'+cDescMunP+'</MunicipioPrestacaoDescricao>'
Do Case
	Case aNota[4] $ "DB"
		cString += '<Operacao>D</Operacao>'
    Case aISSQN[1][02] <= 0
		cString += '<Operacao>C</Operacao>'
	OtherWise
		cString += '<Operacao>A</Operacao>'
EndCase

If cCodMun $ "3550308-2611606-4208203" //São Paulo # Recife # Itajaí
	Do Case
		Case aTotal[3] $ "1"    //Tributação no municipio
			cTributa := "1" 
	    Case aTotal[3] $ "2"    //Tributação fora do municipio
			cTributa := "2"
		Case aTotal[3] $ "3"  .Or. (cCodMun == "4208203" .And. aTotal[3] $ "3-4-5-6" )  //Isento
			cTributa := "3"
	    Case aTotal[3] $ "5"  //ISS Suspenso por Decisão Judicial
			cTributa := "4"
	EndCase

ElseIf cCodMun $ "4318705"

	lRetido:= aScan(aRetido,{|x| x[1] == "ISS"}) > 0
	
	Do Case
		Case aDest[11] == "EX"
			cTributa :="78"			
		Case cCodMun == cMunPrest
			If aTotal[3] == "1"
				If lRetido
					cTributa :="51"
				Else
					cTributa :="52"	
				EndIF										
		    ElseIf aTotal[03] == "7"
				cTributa :="58"	
		    ElseIf aTotal[03] == "8" 
				cTributa :="59"	
		    EndIF
		Case cCodMun <> cMunPrest
			If aTotal[3] == "1" 
				If lRetido
					cTributa :="61"
				Else
					cTributa :="62"		
				EndIF
			ElseIf aTotal[03] == "2"
				If lRetido
					cTributa:="63"	
				Else
					cTributa:="64"	
				EndIF		
			ElseIf aTotal[03] == "7"
				cTributa :="68"
		    ElseIf aTotal[03] == "8"
				cTributa :="69"	
			EndIF
	EndCase
Else
	cTributa := aTotal[3]
EndIf
			
If  cCodMun <> "4318705"
	cString += '<Tributacao>'+  Iif(Empty(cTributa), "1", cTributa)+'</Tributacao>'
Else
	cString += '<Tributacao>'+  Iif(Empty(cTributa), "51", cTributa)+'</Tributacao>'
EndIF
    If !Empty(cMVREGIESP)
		cString += '<RegimeEspecialTributacao>'+cMVREGIESP+'</RegimeEspecialTributacao>'
	EndIf	
	cString += '<OptanteSimplesNacional>'+cMVOPTSIMP+'</OptanteSimplesNacional>'
    cString += '<IncentivadorCultural>'+cMVINCECUL+'</IncentivadorCultural>'
	cString += '<Status>'+"1"+'</Status>'
	
nScan := aScan(aRetido,{|x| x[1] == "ISS"})
If nScan > 0
	aIssRet[1] += aRetido[nScan][3] 
	aIssRet[2] += aRetido[nScan][5] 
	aIssRet[3] += aRetido[nScan][4]
EndIf

nScan := aScan(aRetido,{|x| x[1] == "PIS"})
If nScan > 0
	aPisXml[1] := aRetido[nScan][3]
	aPisXml[2] += aRetido[nScan][4]
EndIf

nScan := aScan(aRetido,{|x| x[1] == "COFINS"})
If nScan > 0
	aCofinsXml[1] := aRetido[nScan][3]
	aCofinsXml[2] += aRetido[nScan][4]
EndIf
                                     
nScan := aScan(aRetido,{|x| x[1] == "IRRF"})
If nScan > 0
	aIrrfXml[1] := aRetido[nScan][3]
	aIrrfXml[2] += aRetido[nScan][4]
EndIf
                                    
nScan := aScan(aRetido,{|x| x[1] == "CSLL"})
If nScan > 0
	aCSLLXml[1] := aRetido[nScan][3]
	aCSLLXml[2] += aRetido[nScan][4]
EndIf
     
nScan := aScan(aRetido,{|x| x[1] == "INSS"})
If nScan > 0
	aInssXml[1] := aRetido[nScan][3]
	aInssXml[2] += aRetido[nScan][4]
EndIf
     
//Outras retenções, sera colocado o valor 0 (zero), pois atualmente nao existe valor de Outras retencoes 
If Len(aRetido)>0     
	nOutRet    := 0
EndIf

If cCodMun $ "4318705" .And.  cTributa $ "58|63|64|68|59|78|69" 
	cString += '<ValorISS>0.00</ValorISS>'
ElseIf cCodMun $ "4303905-4307906"
	cString += '<ValorISS>'+ConvType2(aISSQN[1][03],13,2)+'</ValorISS>'
Else
	cString += '<ValorISS>'+ConvType2(aISSQN[1][03],15,2)+'</ValorISS>'
EndiF
cString += '<ISSRetido>'+ConvType2(aIssRet[1],15,2)+'</ISSRetido>'
cString += '<OutrasRetencoes>'+ConvType2(nOutRet,15,2)+'</OutrasRetencoes>'

cString += '<ValorPIS>'+ConvType2(aPisXml[1],15,2)+'</ValorPIS>'
cString += '<ValorCOFINS>'+ConvType2(aCofinsXml[1],15,2)+'</ValorCOFINS>'
cString += '<ValorINSS>'+ConvType2(aInssXml[1],15,2)+'</ValorINSS>'
cString += '<ValorIR>'+ConvType2(aIRRFXml[1],15,2)+'</ValorIR>'
cString += '<ValorCSLL>'+ConvType2(aCSLLXml[1],15,2)+'</ValorCSLL>'
cString += '<AliquotaISS>'+ConvType2((Iif(!Empty(aISSQN[1][02]),aISSQN[1][02],aIssRet[3])/100),15,4)+'</AliquotaISS>'
cString += '<AliquotaPIS>'+ConvType2(aPisXml[2],15,4)+'</AliquotaPIS>'
cString += '<AliquotaCOFINS>'+ConvType2(aCofinsXml[2],15,4)+'</AliquotaCOFINS>'
cString += '<AliquotaINSS>'+ConvType2(aInssXml[2],15,4)+'</AliquotaINSS>'
cString += '<AliquotaIR>'+ConvType2(aIrrfXml[2],15,4)+'</AliquotaIR>'
cString += '<AliquotaCSLL>'+ConvType2(aCSLLXml[2],15,4)+'</AliquotaCSLL>'

If !lNFeDesc
	cString += '<DescricaoRPS>'+AllTrim(cNatOper)+'</DescricaoRPS>' 
Else 
	cString += '<DescricaoRPS>'+AllTrim(cDescrNFSe)+'</DescricaoRPS>'
EndIf
cString += '<DDDPrestador>'+AllTrim(Str(FisGetTel(SM0->M0_TEL)[2],3))+'</DDDPrestador>'
cString += '<TelefonePrestador>'+AllTrim(Str(FisGetTel(SM0->M0_TEL)[3],15))+'</TelefonePrestador>'
cString += '<DDDTomador>'+AllTrim(Str(Val(SubsTr(aDest[13],1,3))))+'</DDDTomador>'
cString += '<TelefoneTomador>'+AllTrim(Str(Val(SubsTr(aDest[13],4,15))))+'</TelefoneTomador>'

cString += '<MotCancelamento></MotCancelamento>'

//A operação J-Intermediação é utilizada apenas na prefeitura de Campo Grande, nas demais
//prefeituras não deve ser utilizada. Quando informado o tipo de operação J-Intermediação deve se
//informar o CPF/CNPJ do Intermediário

If cCodMun == "5002704" .And. cString $ '<Tributacao>J</Tributacao>'
	cString += '<CpfCnpjIntermediario>'+'00000000000191'+'</CpfCnpjIntermediario>'
EndIf
 
atel:= FisGetTel(aDest[13])

For Nx := 1 to Len(aProd)   
	//nBaseIss := (aProd[Nx][10] * aProd[Nx][09]) - aProd[Nx][15] - aProd[Nx][21] - aProd[Nx][22]
	nBaseIss := aProd[Nx][25]	
	//Valor Líquido, foi retirado o "nOutRet" do Valor Liquido, pois atualmente nao existe valor de Outras retencoes
	If cCodMun $ "3106200" .And. aDest[22] == "EP" .And. cF4Agreg == "D"  
				nValLiq    := (aProd[Nx][27]) - aPisXml[1] - aCofinsXml[1]  - aInssXml[1] - aIRRFXml[1] - aCSLLXml[1] - IiF (aISSQN[1][03]> 0, aISSQN[1][03],nDescon)
	Else
		nValLiq    := (aProd[Nx][27]) - aPisXml[1] - aCofinsXml[1]  - aInssXml[1] - aIRRFXml[1] - aCSLLXml[1] - aIssRet[1]  
	EndIf

	cXml += '<Item>'  
	If cCodMun == "2611606"      
		cXml += '<ItemListaServico>'+ConvType2(aProd[Nx][24],7)+'</ItemListaServico>' 
	ElseIf cCodMun == "3501608" 
	    cAuxMun := AllTrim(StrTran(aProd[Nx][24],".",""))
	    aProd[Nx][24] := cAuxMun	    
		cXml += '<ItemListaServico>'+ConvType2(aProd[Nx][24],5)+'</ItemListaServico>'   
	Else 
		cXml += '<ItemListaServico>'+ConvType2(aProd[Nx][24],5)+'</ItemListaServico>'   
	Endif
	If cCodMun $ "5201108-4104808-5103403-3524709-3300704-4313409-1400100-3156700" // Anápolis-GO, Cascavel-PR, Cuiabá-MT, Boa Vista-RR     
		cXml += '<Aliquota>'+ConvType2((Iif(!Empty(aISSQN[1][02]),aISSQN[1][02],aIssRet[3])),15,4)+'</Aliquota>'
	ElseIf cCodMun $ "3503307-3515004-3538709" //MODELO SIMPLISS
		cXml += '<Aliquota>'+ConvType2((Iif(!Empty(aISSQN[1][02]),aISSQN[1][02],aIssRet[3])),15,2)+'</Aliquota>'
	ElseIf cCodMun $ "3106200" .And. aDest[22] == "EP" .And. cF4Agreg == "D"   // Tratamento realizado para Belo Horizonte - MG quando o tomador é Empresa Pública e contém dedução de ISS.
		cXml += '<Aliquota>0.00</Aliquota>'	     	 
    ElseIf cCodMun $ "4303905-4307906" 
    	cXml += '<Aliquota>'+ConvType2((Iif(!Empty(aISSQN[1][02]),aISSQN[1][02],aIssRet[3])/100),13,2)+'</Aliquota>'
    Else
		cXml += '<Aliquota>'+ConvType2((Iif(!Empty(aISSQN[1][02]),aISSQN[1][02],aIssRet[3])/100),15,4)+'</Aliquota>'
    EndIf
	If !lNFeDesc
		cXml += '<DiscriminacaoServico>'+AllTrim(cNatOper)+'</DiscriminacaoServico>'
	Else
		cXml += '<DiscriminacaoServico>'+AllTrim(cDiscrNFSe)+'</DiscriminacaoServico>'
	EndIf
	cXml += '<Quantidade>'+AllTrim(Str(aProd[Nx][09]))+'</Quantidade>'
	cXml += '<ValorUnitario>'+AllTrim(ConvType2(aProd[Nx][10],15,2))+'</ValorUnitario>'
	cXml += '<ValorTotal>'+AllTrim(ConvType2((aProd[Nx][28]),15,2))+'</ValorTotal>'     
	cXml += '<BaseCalculo>'+Alltrim(ConvType2(nBaseIss ,15,2))+'</BaseCalculo>'     
	cXml += '<ISSRetido>'+Iif(!Empty(aIssRet[2]),"1","2")+'</ISSRetido>'   
	cXml += '<ValorDeducoes>'+ConvType2(aProd[Nx][29],15,2)+'</ValorDeducoes>' 
	cXml += '<ValorPIS>'+ConvType2(aPisXml[1],15,2)+'</ValorPIS>'
	cXml += '<ValorCOFINS>'+ConvType2(aCofinsXml[1],15,2)+'</ValorCOFINS>'
	cXml += '<ValorINSS>'+ConvType2(aInssXml[1],15,2)+'</ValorINSS>'
	cXml += '<ValorIR>'+ConvType2(aIRRFXml[1],15,2)+'</ValorIR>'
	cXml += '<ValorCSLL>'+ConvType2(aCSLLXml[1],15,2)+'</ValorCSLL>'
	If (cCodMun $ "4318705" .And.  cTributa $ "58|63|64|59|68|69|78") .Or. (cCodMun $ "3106200" .And. aDest[22] == "EP" .And. cF4Agreg == "D")
		cXml += '<ValorISS>0.00</ValorISS>'
	Else
		If cCodMun $ "3503307"
		
			cXml += '<ValorISS>'+ConvType2(aISSQN[nX][03],15,2)+'</ValorISS>'
		
		Else 
			cXml += '<ValorISS>'+ConvType2(aISSQN[1][03],15,2)+'</ValorISS>'
		Endif
	Endif
	If cCodMun $ "3106200" .And. aDest[22] == "EP" .And. cF4Agreg == "D"
		cXml += '<ValorISSRetido>0.00</ValorISSRetido>' 
	Else
		cXml += '<ValorISSRetido>'+ConvType2(aIssRet[1],15,2)+'</ValorISSRetido>'
	EndIf
	cXml += '<OutrasRetencoes>'+ConvType2(nOutRet,15,2)+'</OutrasRetencoes>'
	cXml += '<ValorLiquido>'+ConvType2(nValLiq,15,2)+'</ValorLiquido>'
	If cCodMun $ "3106200" .And. aDest[22] == "EP" .And. cF4Agreg == "D"
		cXml += '<DescontoCondicionado>'+ IiF (aISSQN[1][03]> 0, ConvType2(aISSQN[1][03],15,2),ConvType2(nDescon,15,2)) +'</DescontoCondicionado>' 		 
	Else
		cXml += '<DescontoCondicionado>0</DescontoCondicionado>'
	EndIf
	cXml += '<DescontoIncondicionado>'+ConvType2(aISSQN[1][06],15,2)+'</DescontoIncondicionado>'
	cXml += '<CodigoCnae>'+ConvType2(aProd[Nx][19],7)+'</CodigoCnae>'
	If cCodMun $ "3304557" .And. Len(aProd[Nx]) >= 30
		cXml += '<CodigoTribMunic>'+ConvType2(aProd[Nx][30],3)+ConvType2(aProd[Nx][23],17)+'</CodigoTribMunic>'
	Else
		cXml += '<CodigoTribMunic>'+ConvType2(aProd[Nx][23],20)+'</CodigoTribMunic>'
	EndIf	

	cXml += '</Item>'
	nDeduz += aProd[Nx][21] + aProd[Nx][22]
Next                                   
          
If nDeduz > 0
	For Nx := 1 to Len(aProd)
		cXml += '<Deducao>'          
		cXml += '<CodigoObra> </CodigoObra>'
		cXml += '<Art> </Art>'
		cXml += '<DeducaoPor>Valor</DeducaoPor>'
		cXml += '<TipoDeducao>Despesas com Materiais</TipoDeducao>'
		cXml += '<CPFCNPJReferencia>00000000000191</CPFCNPJReferencia>'
		cXml += '<NumeroNFReferencia>1</NumeroNFReferencia><ValorTotalReferencia>0.00</ValorTotalReferencia>'
		cXml += '<NumeroNFReferencia>1</NumeroNFReferencia><ValorTotalReferencia>0.00</ValorTotalReferencia>'
		cXml += '<PercentualDeduzir>0.00</PercentualDeduzir>'
   		cXml += '<ValorDeduzir>0.00</ValorDeduzir>'
		cXml += '</Deducao>'
		If Nx >=5
			Break
		EndIf
	Next
EndIf                                

cString += '<Deducoes>'         
cString += ''
cString += '</Deducoes>'
cString += '<CodigoPais>'+aDest[11]+'</CodigoPais>'
cString += '<NumeroProcesso>'+cMVNumProc+'</NumeroProcesso>'
cString += '<IncentivoFiscal>'+cMVINCEFIS+'</IncentivoFiscal>'

cString += '<Itens>'                  
cString += cXml
cString += '</Itens>'       

Return(cString)

//Transportadora - Adicionais
Static Function NFSETransp2()
Local cString := ""

Return(cString)

Static Function ConvType2(xValor,nTam,nDec)
Local cNovo := ""
DEFAULT nDec := 0
Do Case
	Case ValType(xValor)=="N"
		If xValor <> 0
			cNovo := AllTrim(Str(xValor,nTam,nDec))
			cNovo := StrTran(cNovo,",",".")
		Else
			cNovo := "0"
		EndIf
	Case ValType(xValor)=="D"
		cNovo := FsDateConv(xValor,"YYYYMMDD")
		cNovo := SubStr(cNovo,1,4)+"-"+SubStr(cNovo,5,2)+"-"+SubStr(cNovo,7)
	Case ValType(xValor)=="C"
		If nTam==Nil
			xValor := AllTrim(xValor)
		EndIf
		DEFAULT nTam := 60
		cNovo := AllTrim(EnCodeUtf8(NoAcento2(SubStr(xValor,1,nTam))))
EndCase
Return(cNovo)

Static Function VldIE2(cInsc,lContr)
Local cRet	:=	""
Local nI	:=	1
DEFAULT lContr  :=      .T.
For nI:=1 To Len(cInsc)
	If Isdigit(Subs(cInsc,nI,1)) .Or. IsAlpha(Subs(cInsc,nI,1))
		cRet+=Subs(cInsc,nI,1)
	Endif
Next
cRet := AllTrim(cRet)
If "ISENT"$Upper(cRet)
	cRet := ""
EndIf
If !(lContr) .And. !Empty(cRet)
	cRet := "ISENTO"
EndIf
Return(cRet)
                                   



static FUNCTION NoAcento2(cString)
Local cChar  := ""
Local nX     := 0 
Local nY     := 0
Local cVogal := "aeiouAEIOU"
Local cAgudo := "áéíóú"+"ÁÉÍÓÚ"
Local cCircu := "âêîôû"+"ÂÊÎÔÛ"
Local cTrema := "äëïöü"+"ÄËÏÖÜ"
Local cCrase := "àèìòù"+"ÀÈÌÒÙ" 
Local cTio   := "ãõ"
Local cCecid := "çÇ"

For nX:= 1 To Len(cString)
	cChar:=SubStr(cString, nX, 1)
	IF cChar$cAgudo+cCircu+cTrema+cCecid+cTio+cCrase
		nY:= At(cChar,cAgudo)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cCircu)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cTrema)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cCrase)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf		
		nY:= At(cChar,cTio)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr("ao",nY,1))
		EndIf		
		nY:= At(cChar,cCecid)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr("cC",nY,1))
		EndIf
	Endif
Next
For nX:=1 To Len(cString)
	cChar:=SubStr(cString, nX, 1)
	If Asc(cChar) < 32 .Or. Asc(cChar) > 123
		cString:=StrTran(cString,cChar,".")
	Endif
Next nX
cString := _NoTags(cString)
Return cString

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MyGetEnd  ³ Autor ³ Liber De Esteban             ³ Data ³ 19/03/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica se o participante e do DF, ou se tem um tipo de endereco ³±±
±±³          ³ que nao se enquadra na regra padrao de preenchimento de endereco  ³±±
±±³          ³ por exemplo: Enderecos de Area Rural (essa verificção e feita     ³±±
±±³          ³ atraves do campo ENDNOT).                                         ³±±
±±³          ³ Caso seja do DF, ou ENDNOT = 'S', somente ira retornar o campo    ³±±
±±³          ³ Endereco (sem numero ou complemento). Caso contrario ira retornar ³±±
±±³          ³ o padrao do FisGetEnd                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Obs.     ³ Esta funcao so pode ser usada quando ha um posicionamento de      ³±±
±±³          ³ registro, pois será verificado o ENDNOT do registro corrente      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIS                                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function MyGetEnd2(cEndereco,cAlias)

Local cCmpEndN	:= SubStr(cAlias,2,2)+"_ENDNOT"
Local cCmpEst	:= SubStr(cAlias,2,2)+"_EST"
Local aRet		:= {"",0,"",""}

//Campo ENDNOT indica que endereco participante mao esta no formato <logradouro>, <numero> <complemento>
//Se tiver com 'S' somente o campo de logradouro sera atualizado (numero sera SN)
If (&(cAlias+"->"+cCmpEst) == "DF") .Or. ((cAlias)->(FieldPos(cCmpEndN)) > 0 .And. &(cAlias+"->"+cCmpEndN) == "1")
	aRet[1] := cEndereco
	aRet[3] := "SN"
Else
	aRet := FisGetEnd(cEndereco)
EndIf

Return aRet    
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |UfCodIBGE ³ Autor ³ Microsiga             ³ Data ³26.05.2008³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao que retorna o codigo da UF do participante, de acordo³±±
±±³          ³com a tabela disponibilizada pelo IBGE.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³cCod -> Codigo da UF                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|cUf  -> Sigla da UF do cliente/fornecedor                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function UfCodIBGE2 (cUf,lForceUF)
Local nX         := 0
Local cRetorno   := ""
Local aUF        := {}

DEFAULT lForceUF := .T.

aadd(aUF,{"RO","11"})
aadd(aUF,{"AC","12"})
aadd(aUF,{"AM","13"})
aadd(aUF,{"RR","14"})
aadd(aUF,{"PA","15"})
aadd(aUF,{"AP","16"})
aadd(aUF,{"TO","17"})
aadd(aUF,{"MA","21"})
aadd(aUF,{"PI","22"})
aadd(aUF,{"CE","23"})
aadd(aUF,{"RN","24"})
aadd(aUF,{"PB","25"})
aadd(aUF,{"PE","26"})
aadd(aUF,{"AL","27"})
aadd(aUF,{"SE","28"})
aadd(aUF,{"BA","29"})
aadd(aUF,{"MG","31"})
aadd(aUF,{"ES","32"})
aadd(aUF,{"RJ","33"})
aadd(aUF,{"SP","35"})
aadd(aUF,{"PR","41"})
aadd(aUF,{"SC","42"})
aadd(aUF,{"RS","43"})
aadd(aUF,{"MS","50"})
aadd(aUF,{"MT","51"})
aadd(aUF,{"GO","52"})
aadd(aUF,{"DF","53"})
aadd(aUF,{"EX","99"})

If !Empty(cUF)
	nX := aScan(aUF,{|x| x[1] == cUF})
	If nX == 0
		nX := aScan(aUF,{|x| x[2] == cUF})
		If nX <> 0
			cRetorno := aUF[nX][1]
		EndIf
	Else
		cRetorno := aUF[nX][2]
	EndIf
Else
	cRetorno := IIF(lForceUF,"",aUF)
EndIf

Return(cRetorno)

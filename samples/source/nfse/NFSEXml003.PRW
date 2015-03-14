#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TBICONN.CH"

//-----------------------------------------------------------------------
/*/{Protheus.doc} NFSEXml003
Geração de XML para a Nota Fiscal de Serviços Eletrônica modelo 003.

@author Marcos Taranta
@since 16/06/2011
@version 1.0

@param  cCodMun  Código do município.
        cTipo    Tipo de nota (0 = entrada; 1 = saída).
        dDtEmiss Data da emissão da nota.
        cSerie   Série da nota.
        cNota    Número da nota.
        cClieFor Código do cliente/fornecedor.
        cLoja    Número da loja do cliente/fornecedor.

@return Array    {1} = XML da nota; {2} = Chave da nota
/*/
//-----------------------------------------------------------------------
User Function NfseM003(cCodMun,cTipo,dDtEmiss,cSerie,cNota,cClieFor,cLoja)

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
Local nPosI		 :=	0
Local nPosF	     :=	0

Local lQuery    := .F.
Local lCalSol	:= .F.
Local lEasy		:= SuperGetMV("MV_EASY") == "S"
Local lEECFAT	:= SuperGetMv("MV_EECFAT")
Local lNatOper  := GetNewPar("MV_SPEDNAT",.F.)

Local aNota     := {}
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
Local aDeduz    := {}
Local cMunPrest := ""
Local cCodCli   := ""
Local cLojCli   := ""
Local cDescMunP := ""

DEFAULT cCodMun := PARAMIXB[1]
DEFAULT cTipo   := PARAMIXB[2]
DEFAULT cSerie  := PARAMIXB[4]
DEFAULT cNota   := PARAMIXB[5]
DEFAULT cClieFor:= PARAMIXB[6]
DEFAULT cLoja   := PARAMIXB[7]

Private aUF     := {}

// Preenchimento do Array de UF
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
	// Posiciona NF
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
		// Posiciona cliente ou fornecedor
		If !SF2->F2_TIPO $ "DB" 

			If IntTMS()
				DT6->(DbSetOrder(1)) //--DT6_FILIAL+DT6_FILDOC+DT6_DOC+DT6_SERIE
				If DT6->(DbSeek(xFilial("DT6")+SF2->(F2_FILIAL+F2_DOC+F2_SERIE)))
					cCodCli := DT6->DT6_CLIDES
					cLojCli := DT6->DT6_LOJDES
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
			aadd(aDest,MyGetEnd(SA1->A1_END,"SA1")[1])
			aadd(aDest,ConvType(IIF(MyGetEnd(SA1->A1_END,"SA1")[2]<>0,MyGetEnd(SA1->A1_END,"SA1")[2],"SN")))
			aadd(aDest,IIF(SA1->(FieldPos("A1_COMPLEM")) > 0 .And. !Empty(SA1->A1_COMPLEM),SA1->A1_COMPLEM,MyGetEnd(SA1->A1_END,"SA1")[4]))
			aadd(aDest,SA1->A1_BAIRRO)
			If !Upper(SA1->A1_EST) == "EX"
				aadd(aDest,SA1->A1_COD_MUN)
				aadd(aDest,SA1->A1_MUN)				
			Else
				aadd(aDest,"9999999")			
				aadd(aDest,"EXTERIOR")
			EndIf
			aadd(aDest,Upper(SA1->A1_EST))
			aadd(aDest,SA1->A1_CEP)
			aadd(aDest,IIF(Empty(SA1->A1_PAIS),"1058"  ,Posicione("SYA",1,xFilial("SYA")+SA1->A1_PAIS,"YA_SISEXP")))
			aadd(aDest,IIF(Empty(SA1->A1_PAIS),"BRASIL",Posicione("SYA",1,xFilial("SYA")+SA1->A1_PAIS,"YA_DESCR" )))
			aadd(aDest,SA1->A1_DDD+SA1->A1_TEL)
			aadd(aDest,VldIE(SA1->A1_INSCR,IIF(SA1->(FIELDPOS("A1_CONTRIB"))>0,SA1->A1_CONTRIB<>"2",.T.)))
			aadd(aDest,SA1->A1_SUFRAMA)
			aadd(aDest,SA1->A1_EMAIL)          
			aadd(aDest,SA1->A1_INSCRM) 
			aadd(aDest,SA1->A1_CODSIAF)
			aadd(aDest,SA1->A1_NATUREZ)            
			If SA1->A1_PAIS = "105"
				aadd(aDest,"BRASIL")
			ELSE
				aadd(aDest,"EXTERIOR")
			ENDIF
			//--Retorna para o cliente do SF2:
			SA1->(DbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA))
			
			// Posiciona Natureza
			DbSelectArea("SED")
			DbSetOrder(1)
			DbSeek(xFilial("SED")+SA1->A1_NATUREZ) 			
			
			If SF2->(FieldPos("F2_CLIENT"))<>0 .And. !Empty(SF2->F2_CLIENT+SF2->F2_LOJENT) .And. SF2->F2_CLIENT+SF2->F2_LOJENT<>SF2->F2_CLIENTE+SF2->F2_LOJA
			    dbSelectArea("SA1")
				dbSetOrder(1)
				DbSeek(xFilial("SA1")+SF2->F2_CLIENT+SF2->F2_LOJENT)
				
				aadd(aEntrega,SA1->A1_CGC)
				aadd(aEntrega,MyGetEnd(SA1->A1_END,"SA1")[1])
				aadd(aEntrega,ConvType(IIF(MyGetEnd(SA1->A1_END,"SA1")[2]<>0,MyGetEnd(SA1->A1_END,"SA1")[2],"SN")))
				aadd(aEntrega,MyGetEnd(SA1->A1_END,"SA1")[4])
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
			aadd(aDest,MyGetEnd(SA2->A2_END,"SA2")[1])
			aadd(aDest,ConvType(IIF(MyGetEnd(SA2->A2_END,"SA2")[2]<>0,MyGetEnd(SA2->A2_END,"SA2")[2],"SN")))
			aadd(aDest,IIF(SA2->(FieldPos("A2_COMPLEM")) > 0 .And. !Empty(SA2->A2_COMPLEM),SA2->A2_COMPLEM,MyGetEnd(SA2->A2_END,"SA2")[4]))				
			aadd(aDest,SA2->A2_BAIRRO)
			If !Upper(SA2->A2_EST) == "EX"
				aadd(aDest,SA2->A2_COD_MUN)
				aadd(aDest,SA2->A2_MUN)				
			Else
				aadd(aDest,"9999999")			
				aadd(aDest,"EXTERIOR")
			EndIf			
			aadd(aDest,Upper(SA2->A2_EST))
			aadd(aDest,SA2->A2_CEP)
			aadd(aDest,IIF(Empty(SA2->A2_PAIS),"1058"  ,Posicione("SYA",1,xFilial("SYA")+SA2->A2_PAIS,"YA_SISEXP")))
			aadd(aDest,IIF(Empty(SA2->A2_PAIS),"BRASIL",Posicione("SYA",1,xFilial("SYA")+SA2->A2_PAIS,"YA_DESCR")))
			aadd(aDest,SA2->A2_DDD+SA2->A2_TEL)
			aadd(aDest,VldIE(SA2->A2_INSCR))
			aadd(aDest,"")//SA2->A2_SUFRAMA
			aadd(aDest,SA2->A2_EMAIL)
			aadd(aDest,SA2->A2_INSCRM) 
			aadd(aDest,SA2->A2_CODSIAF)
			aadd(aDest,SA2->A2_NATUREZ)			
	   		If SA2->A2_PAIS = "105"
				aadd(aDest,"BRASIL")
			ELSE
				aadd(aDest,"EXTERIOR")
			ENDIF
			// Posiciona Natureza
			DbSelectArea("SED")
			DbSetOrder(1)
			DbSeek(xFilial("SED")+SA2->A2_NATUREZ) 
			
		EndIf
		// Posiciona transportador
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
		// Volumes
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
		// Procura duplicatas
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
					SELECT E1_FILIAL,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO,E1_VENCORI,E1_VALOR,E1_ORIGEM
					FROM %Table:SE1% SE1
					WHERE
					SE1.E1_FILIAL = %xFilial:SE1% AND
					SE1.E1_PREFIXO = %Exp:SF2->F2_PREFIXO% AND 
					SE1.E1_NUM = %Exp:SF2->F2_DUPL% AND 
					((SE1.E1_TIPO = %Exp:MVNOTAFIS%) OR
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
		// Analisa os impostos de retencao
		If SF2->(FieldPos("F2_VALPIS"))<>0 .and. SF2->F2_VALPIS>0
			aadd(aRetido,{"PIS",0,SF2->F2_VALPIS,SED->ED_PERCPIS})
		EndIf
		If SF2->(FieldPos("F2_VALCOFI"))<>0 .and. SF2->F2_VALCOFI>0
			aadd(aRetido,{"COFINS",0,SF2->F2_VALCOFI,SED->ED_PERCCOF})
		EndIf
		If SF2->(FieldPos("F2_VALCSLL"))<>0 .and. SF2->F2_VALCSLL>0
			aadd(aRetido,{"CSLL",0,SF2->F2_VALCSLL,SED->ED_PERCCSL})
		EndIf
		If SF2->(FieldPos("F2_VALIRRF"))<>0 .and. SF2->F2_VALIRRF>0
			aadd(aRetido,{"IRRF",SF2->F2_BASEIRR,SF2->F2_VALIRRF,SED->ED_PERCIRF})
		EndIf	
		If SF2->(FieldPos("F2_BASEINS"))<>0 .and. SF2->F2_BASEINS>0
			aadd(aRetido,{"INSS",SF2->F2_BASEINS,SF2->F2_VALINSS,SED->ED_PERCINS})
		EndIf
		If SF2->(FieldPos("F2_VALISS"))<>0 .and. SF2->F2_BASEISS>0
			aadd(aRetido,{"ISS",SF2->F2_BASEISS,SF2->F2_VALISS})
		EndIf
		// Pesquisa itens de nota
		dbSelectArea("SD2")
		dbSetOrder(3)	
		#IFDEF TOP
			lQuery  := .T.
			cAliasSD2 := GetNextAlias()
			BeginSql Alias cAliasSD2
				SELECT D2_FILIAL,D2_SERIE,D2_DOC,D2_CLIENTE,D2_LOJA,D2_COD,D2_TES,D2_NFORI,D2_SERIORI,D2_ITEMORI,D2_TIPO,D2_ITEM,D2_CF,
					D2_QUANT,D2_TOTAL,D2_DESCON,D2_VALFRE,D2_SEGURO,D2_PEDIDO,D2_ITEMPV,D2_DESPESA,D2_VALBRUT,D2_VALISS,D2_PRUNIT,
					D2_CLASFIS,D2_PRCVEN,D2_CODISS,D2_DESCZFR,D2_PREEMB,D2_ALIQISS,D2_BASEISS,D2_VALIMP1,D2_VALIMP2,D2_VALIMP3,D2_VALIMP4,D2_VALIMP5
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
		While !Eof() .And. xFilial("SD2") == (cAliasSD2)->D2_FILIAL .And.;
			SF2->F2_SERIE == (cAliasSD2)->D2_SERIE .And.;
			SF2->F2_DOC == (cAliasSD2)->D2_DOC
			// Verifica a natureza da operacao
			dbSelectArea("SF4")
			dbSetOrder(1)
			DbSeek(xFilial("SF4")+(cAliasSD2)->D2_TES)				
			If !lNatOper
				If Empty(cNatOper)
					cNatOper := SF4->F4_TEXTO
				EndIf
			Else	
				dbSelectArea("SX5")
				dbSetOrder(1)
				dbSeek(xFilial("SX5")+"13"+SF4->F4_CF)
				If Empty(cNatOper)
					cNatOper := AllTrim(SubStr(SX5->X5_DESCRI,1,55))
    			EndIf
    		EndIf 
			// Verifica as notas vinculadas
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
			// Obtem os dados do produto
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
			
			dbSelectArea("SC5")
			dbSetOrder(1)
			DbSeek(xFilial("SC5")+(cAliasSD2)->D2_PEDIDO)
			
			dbSelectArea("SC6")
			dbSetOrder(1)
			DbSeek(xFilial("SC6")+(cAliasSD2)->D2_PEDIDO+(cAliasSD2)->D2_ITEMPV+(cAliasSD2)->D2_COD)
			
			If !AllTrim(SC5->C5_MENNOTA) $ cMensCli
				cMensCli += If(FindFunction('CleanSpecChar'),CleanSpecChar(AllTrim(SC5->C5_MENNOTA)),AllTrim(SC5->C5_MENNOTA))
			EndIf
			If !Empty(SC5->C5_MENPAD) .And. !AllTrim(FORMULA(SC5->C5_MENPAD)) $ cMensFis
				cMensFis += If(FindFunction('CleanSpecChar'),CleanSpecChar(AllTrim(FORMULA(SC5->C5_MENPAD))),AllTrim(FORMULA(SC5->C5_MENPAD)))
			EndIf
			
			// TRATAMENTO - INTEGRACAO COM TMS-GESTAO DE TRANSPORTES
			If IntTms()
				DT6->(DbSetOrder(1)) //--DT6_FILIAL+DT6_FILDOC+DT6_DOC+DT6_SERIE
				If DT6->(DbSeek(xFilial("DT6")+SF2->(F2_FILIAL+F2_DOC+F2_SERIE)))
					cModFrete := DT6->DT6_TIPFRE
					If DUY->(FieldPos("DUY_CODMUN")) > 0
						DUY->(DbSetOrder(1)) //--DUY_FILIAL+DUY_GRPVEN
						If DUY->(DbSeek(xFilial("DUY")+DT6->DT6_CDRDES))
							cMunPrest := DUY->DUY_CODMUN
						EndIf							
					Else
						SA1->(DbSetOrder(1))
						If SA1->(DbSeek(xFilial("SA1")+DT6->(DT6_CLIDES+DT6_LOJDES)))
							cMunPrest := SA1->A1_COD_MUN
						EndIf
					EndIf					
				Else
					If SC5->(FieldPos("C5_MUNPRES")) > 0 
						cMunPrest := SC5->C5_MUNPRES
						cDescMunP := SC5->C5_DESCMUN
					Else
						cMunPrest := aDest[18]
						cDescMunP := aDest[08]
						cModFrete := IIF(SC5->C5_TPFRETE=="C","0","1")
					EndIf
				EndIf			
			Else
				If SC5->(FieldPos("C5_MUNPRES")) > 0 
					cMunPrest := SC5->C5_MUNPRES
					cDescMunP := SC5->C5_DESCMUN
				Else
					cMunPrest := aDest[18]
					cDescMunP := aDest[08]
					cModFrete := IIF(SC5->C5_TPFRETE=="C","0","1")
				EndIf
			EndIf
			
			If Empty(aPedido)
				aPedido := {"",AllTrim(SC6->C6_PEDCLI),""}
			EndIf
		
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
							SF3->F3_CODISS,;  //23
							(cAliasSD2)->D2_ALIQISS,; //24
							(cAliasSD2)->D2_VALISS,;  //25
							(cAliasSD2)->D2_BASEISS,; //26
							(cAliasSD2)->D2_VALIMP1,; //27
							(cAliasSD2)->D2_VALIMP2,; //28
							(cAliasSD2)->D2_VALIMP3,; //29
							(cAliasSD2)->D2_VALIMP4,; //30
							(cAliasSD2)->D2_VALIMP5,; //31
							RetFldProd(SB1->B1_COD,"B1_TRIBMUN"),; //32
							}) 
            If SC6->(FieldPos("C6_TPDEDUZ")) > 0 .And. !Empty(SC6->C6_TPDEDUZ)
	            aadd(aDeduz,{SC6->C6_TPDEDUZ,;
	            			 SC6->C6_MOTDED ,;
	            			 SC6->C6_FORDED ,;
	            			 SC6->C6_LOJDED ,;
	            			 SC6->C6_SERDED ,;
	            			 SC6->C6_NFDED  ,;
	            			 SC6->C6_VLNFD  ,;
	            			 SC6->C6_PCDED  ,;
	            			 SC6->C6_VLDED ,;
	            			 })
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
			aadd(aISSQN,{0,0,0,"",""})
			aadd(aAdi,{})
			aadd(aDi,{})
			// Tratamento para TAG Exportação quando existe a integração com a EEC
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
			dbSelectArea("CD2")
			If !(cAliasSD2)->D2_TIPO $ "DB"
				dbSetOrder(1)
			Else
				dbSetOrder(2)
			EndIf
			If !DbSeek(xFilial("CD2")+"S"+SF2->F2_SERIE+SF2->F2_DOC+SF2->F2_CLIENTE+SF2->F2_LOJA+PadR((cAliasSD2)->D2_ITEM,4)+(cAliasSD2)->D2_COD)

			EndIf
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
						cMunISS := ConvType(aUF[aScan(aUF,{|x| x[1] == aDest[09]})][02]+aDest[07])
						aTail(aISSQN) := {CD2->CD2_BC,CD2->CD2_ALIQ,CD2->CD2_VLTRIB,cMunISS,AllTrim((cAliasSD2)->D2_CODISS)}
				EndCase
				dbSelectArea("CD2")
				dbSkip()
			EndDo
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
		// Tratamento temporario do CTe
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
				aadd(aDest,MyGetEnd(SA1->A1_END,"SA1")[1])
				aadd(aDest,ConvType(IIF(MyGetEnd(SA1->A1_END,"SA1")[2]<>0,MyGetEnd(SA1->A1_END,"SA1")[2],"SN")))
				aadd(aDest,MyGetEnd(SA1->A1_END,"SA1")[4])
				aadd(aDest,SA1->A1_BAIRRO)
				If !Upper(SA1->A1_EST) == "EX"
					aadd(aDest,SA1->A1_COD_MUN)
					aadd(aDest,SA1->A1_MUN)				
				Else
					aadd(aDest,"9999999")			
					aadd(aDest,"EXTERIOR")
				EndIf
				aadd(aDest,Upper(SA1->A1_EST))
				aadd(aDest,SA1->A1_CEP)
				aadd(aDest,IIF(Empty(SA1->A1_PAIS),"1058"  ,Posicione("SYA",1,xFilial("SYA")+SA1->A1_PAIS,"YA_SISEXP")))
				aadd(aDest,IIF(Empty(SA1->A1_PAIS),"BRASIL",Posicione("SYA",1,xFilial("SYA")+SA1->A1_PAIS,"YA_DESCR" )))
				aadd(aDest,SA1->A1_DDD+SA1->A1_TEL)
				aadd(aDest,VldIE(SA1->A1_INSCR,IIF(SA1->(FIELDPOS("A1_CONTRIB"))>0,SA1->A1_CONTRIB<>"2",.T.)))
				aadd(aDest,SA1->A1_SUFRAMA)
				aadd(aDest,SA1->A1_EMAIL)
									
			Else
			    dbSelectArea("SA2")
				dbSetOrder(1)
				DbSeek(xFilial("SA2")+cClieFor+cLoja)
		
				aadd(aDest,AllTrim(SA2->A2_CGC))
				aadd(aDest,SA2->A2_NOME)
				aadd(aDest,MyGetEnd(SA2->A2_END,"SA2")[1])
				aadd(aDest,ConvType(IIF(MyGetEnd(SA2->A2_END,"SA2")[2]<>0,MyGetEnd(SA2->A2_END,"SA2")[2],"SN")))
				aadd(aDest,MyGetEnd(SA2->A2_END,"SA2")[4])
				aadd(aDest,SA2->A2_BAIRRO)
				If !Upper(SA2->A2_EST) == "EX"
					aadd(aDest,SA2->A2_COD_MUN)
					aadd(aDest,SA2->A2_MUN)				
				Else
					aadd(aDest,"9999999")			
					aadd(aDest,"EXTERIOR")
				EndIf			
				aadd(aDest,Upper(SA2->A2_EST))
				aadd(aDest,SA2->A2_CEP)
				aadd(aDest,IIF(Empty(SA2->A2_PAIS),"1058"  ,Posicione("SYA",1,xFilial("SYA")+SA2->A2_PAIS,"YA_SISEXP")))
				aadd(aDest,IIF(Empty(SA2->A2_PAIS),"BRASIL",Posicione("SYA",1,xFilial("SYA")+SA2->A2_PAIS,"YA_DESCR")))
				aadd(aDest,SA2->A2_DDD+SA2->A2_TEL)
				aadd(aDest,VldIE(SA2->A2_INSCR))
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
			// Analisa os impostos de retencao
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
			If SF1->(FieldPos("F1_VALISS"))<>0 .and. SF1->F1_BASEISS>0
				aadd(aRetido,{"ISS",SF1->F1_BASEISS,SF1->F1_VALISS})
			EndIf
			
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
							D1_VALICM,D1_TIPO_NF,D1_PEDIDO,D1_ITEMPC,D1_VALIMP5,D1_VALIMP6
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
				
	
				dbSelectArea("SF4")
				dbSetOrder(1)
				DbSeek(xFilial("SF4")+(cAliasSD1)->D1_TES)
				If !lNatOper
					If Empty(cNatOper)
						cNatOper := SF4->F4_TEXTO					
					EndIf
				Else
					dbSelectArea("SX5")
					dbSetOrder(1)
					dbSeek(xFilial("SX5")+"13"+SF4->F4_CF)
					If Empty(cNatOper)
						cNatOper := AllTrim(SubStr(SX5->X5_DESCRI,1,55))
	    			EndIf
	    		EndIf
				// Verifica as notas vinculadas
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
				
				// Obtem os dados do produto
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
								SF3->F3_CODISS,;
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
					If !(cAliasSD1)->D1_TIPO $ "IP"
						// Tratamento para TAG Importação quando existe a integração com a EIC  (Se a nota for primeira ou unica)
						aadd(aDI,(GetNFEIMP(.F.,(cAliasSD1)->D1_DOC,(cAliasSD1)->D1_SERIE,(cAliasSD1)->D1_FORNECE,(cAliasSD1)->D1_LOJA,(cAliasSD1)->D1_TIPO_NF,(cAliasSD1)->D1_PEDIDO,(cAliasSD1)->D1_ITEMPC)))
					Else
						// Tratamento para TAG Importação quando existe a integração com a EIC  (Se a nota for complementar)
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
							aTail(aISSQN) := {CD2->CD2_BC,CD2->CD2_ALIQ,CD2->CD2_VLTRIB,"",AllTrim((cAliasSD1)->D1_CODISS)}
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

// Geracao do arquivo XML
If !Empty(aNota)
	cString := '<RPS Id="rps:'+AllTrim(Str(Val(aNota[02])))+'">'
	cString += NFSEAssina(cCodMun,aNota,aProd,aTotal,aDest,aDeduz)
	cString += NFSECab(cCodMun,aNota)
	cString += NFSEDest(cCodMun,aDest,cMunPrest)
	cString += NFSEFat(cCodMun,aDupl)
	cString += NFSEItem(cCodMun,aProd,aICMS,aICMSST,aIPI,aPIS,aPISST,aCOFINS,aCOFINSST,aISSQN,aCST,aMed,aArma,aveicProd,aDI,aAdi,aExp,aPisAlqZ,aCofAlqZ,aDest, aNota,aTotal,aRetido,cMensCli,cMensFis,cMunPrest,cDescMunP,aDeduz)
	cString += NFSETransp(cCodMun)
	cString += '</RPS>'
EndIf

Return({EncodeUTF8(cString),cNfe})

    

Static Function NFSEAssina(cCodMun,aNota,aProd,aTotal,aDest,aDeduz)
Local cAssinatura := ""  
Local Nx := 0
Local nDeduz := 0

For Nx:=1 to Len(aDeduz)
	nDeduz += Iif(aDeduz[nx][1]=="2",aDeduz[nx][8],0)
Next
cAssinatura += StrZero(Val(SM0->M0_INSCM),11) 
cAssinatura += "NF   "  
cAssinatura += Strzero(Val(aNota[02]),12)       
cAssinatura += Dtos(aNota[03])

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
    Case aTotal[3] $ "7"
		cAssinatura += "N "
    Case aTotal[3] $ "8"
		cAssinatura += "M "		
	OtherWise
		cAssinatura += "T "
EndCase

cAssinatura += "N" 
cAssinatura += Iif((aProd[1][20])=='1',"S","N")
cAssinatura += StrZero((aTotal[2] - nDeduz )*100,15)  //"000000001200012"
cAssinatura += StrZero(nDeduz *100,15)
cAssinatura += AllTrim(StrZero(Val(aProd[1][19]),10))
cAssinatura += AllTrim(StrZero(Val(aDest[01]),14))

//MemoWrite("c:\p10\xml\"+"RPS"+Strzero(Val(aNota[02]),9)+".TXT",cAssinatura)

cAssinatura := AllTrim(Lower(Sha1(AllTrim(cAssinatura),2)))
cAssinatura := '<Assinatura>'+cAssinatura+'</Assinatura>'

Return(cAssinatura)             

//Cabeçalho
Static Function NfseCab(cCodMun,aNota)

Local cString      := ""
Local cImPrestador := AllTrim(SM0->M0_INSCM)

cImPrestador := StrTran(cImPrestador, "-", "")
cImPrestador := StrTran(cImPrestador, "/", "")

cString += '<InscricaoMunicipalPrestador>'+StrZero(val(cImPrestador),8)+'</InscricaoMunicipalPrestador>'
cString += "<CPFCNPJPrestador>" + AllTrim(SM0->M0_CGC) + "</CPFCNPJPrestador>"
cString += '<RazaoSocialPrestador>'+AllTrim(SM0->M0_NOMECOM)+'</RazaoSocialPrestador>'
cString += '<TipoRPS>1</TipoRPS>'
cString += '<SerieRPS>' + AllTrim(aNota[01]) + '</SerieRPS>'
cString += '<NumeroRPS>'+AllTrim(Str(Val(aNota[02])))+'</NumeroRPS>'
cString += '<DataEmissaoRPS>'+Substr(Dtos(aNota[03]),1,4)+"-"+  Substr(Dtos(aNota[03]),5,2)+"-"+ Substr(Dtos(aNota[03]),7,2)+'T'+Time()+'</DataEmissaoRPS>'
cString += '<SituacaoRPS>N</SituacaoRPS>'
cString += '<DataEmissaoNFSeSubstituida>1900-01-01</DataEmissaoNFSeSubstituida>'
cString += '<SeriePrestacao>99</SeriePrestacao>'

Return(cString)

//Tomador
Static Function NFSEDest(cCodMun,aDest,cMunPrest)
	
	Local cString := ""
	
	cString += '<InscricaoMunicipalTomador>'+Iif(Upper(aDest[17])=='ISENTO' .OR. Empty(aDest[17]),"0000000",aDest[17])+'</InscricaoMunicipalTomador>'
	cString += '<CPFCNPJTomador>'+AllTrim(aDest[01])+'</CPFCNPJTomador>'
	cString += '<RazaoSocialTomador>'+AllTrim(aDest[02])+'</RazaoSocialTomador>'
	cString += '<TipoLogradouroTomador>Rua</TipoLogradouroTomador>'
	cString += '<LogradouroTomador>'+AllTrim(aDest[03])+'</LogradouroTomador>'
	cString += '<NumeroEnderecoTomador>'+AllTrim(aDest[04])+'</NumeroEnderecoTomador>'
	If !Empty(aDest[05])
		cString += '<ComplementoEnderecoTomador>'+AllTrim(aDest[05])+'</ComplementoEnderecoTomador>'
	Else
		cString += '<ComplementoEnderecoTomador>-</ComplementoEnderecoTomador>'
	EndIf
	cString += '<TipoBairroTomador>Bairro</TipoBairroTomador>'
	cString += '<BairroTomador>'+AllTrim(aDest[06])+'</BairroTomador>'
	cString += '<CidadeTomador>'+StrZero(Val( Iif( Empty(cMunPrest), aDest[07] ,cMunPrest ) ),7)+'</CidadeTomador>'
	cString += '<CidadeTomadorDescricao>'+AllTrim(aDest[08])+'</CidadeTomadorDescricao>'
	cString += '<UfTomador>'+AllTrim(aDest[09])+'</UfTomador>'
	cString += '<CEPTomador>'+AllTrim(aDest[10])+'</CEPTomador>'
	cString += '<EmailTomador>'+AllTrim(aDest[16])+'</EmailTomador>'
	If Empty (aDest[16])
		cString += '<NotificaTomador>false</NotificaTomador>' //Manter o conteúdo em minúsculo
	Else
		cString += '<NotificaTomador>true</NotificaTomador>'
	EndIf		
	cString += '<SituacaoEspecial>FALSE</SituacaoEspecial>'
	cString += '<DescrPaisTomador>'+AllTrim(aDest[12])+'</DescrPaisTomador>'
	
Return(cString)


//Fatura
Static Function NFSEFat(cCodMun,aDupl)
	
	Local cString := ""
	
Return(cString)


//Serviço
Static Function NFSEItem(cCodMun,aProd,aICMS,aICMSST,aIPI,aPIS,aPISST,aCOFINS,aCOFINSST,aISSQN,aCST,aMed,aArma,aveicProd,aDI,aAdi,aExp,aPisAlqZ,aCofAlqZ, aDest, aNota, aTotal,aRetido,cMensCli,cMensFis,cMunPrest,cDescMunP,aDeduz)
                      
Local cXml       := ""
Local cString    := ""
Local Nx         := 0
Local nDeduz     := 0
Local aPisXml    := {0,0}
Local aCofinsXml := {0,0}
Local aCSLLXml   := {0,0}
Local aIrrfXml   := {0,0}
Local aInssXml   := {0,0}
Local aISSXml	 :=	{0,0}
Local cDeduz     := ""          
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

cString := ''
cString += '<CodigoAtividade>'+AllTrim(aProd[1][19])+'</CodigoAtividade>'
cString += '<AliquotaAtividade>'+ConvType(aISSQN[1][02],5)+'</AliquotaAtividade>'
cString += '<TipoRecolhimento>'+Iif((aProd[1][20])=='1',"R","A")+'</TipoRecolhimento>'
cString += '<MunicipioPrestacao>'+StrZero(Val( Iif( Empty(cMunPrest), aDest[18] ,cMunPrest ) ),10)+'</MunicipioPrestacao>'
cString += '<MunicipioPrestacaoDescricao>'+AllTrim(Iif( Empty(cDescMunP), aDest[08] ,cDescMunP))+'</MunicipioPrestacaoDescricao>'

Do Case
	Case aNota[4] $ "DB"
		cString += '<Operacao>D</Operacao>'
    Case aISSQN[1][02] <= 0
		cString += '<Operacao>C</Operacao>'
	OtherWise
		cString += '<Operacao>A</Operacao>'
EndCase
       
Do Case
	Case aTotal[3] $ "2"
		cString += '<Tributacao>E</Tributacao>'
    Case aTotal[3] $ "3"
		cString += '<Tributacao>C</Tributacao>'
	Case aTotal[3] $ "4"
		cString += '<Tributacao>F</Tributacao>'
    Case aTotal[3] $ "5"
		cString += '<Tributacao>K</Tributacao>'
    Case aTotal[3] $ "6"
		cString += '<Tributacao>K</Tributacao>'
    Case aTotal[3] $ "7"
		cString += '<Tributacao>N</Tributacao>'
    Case aTotal[3] $ "8"
		cString += '<Tributacao>M</Tributacao>'
	OtherWise
		cString += '<Tributacao>T</Tributacao>'
EndCase


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

nScan := aScan(aRetido,{|x| x[1] == "ISS"})
If nScan > 0
	aISSXml[1] := aRetido[nScan][3] //Valor ISS
	aISSXml[1] += aRetido[nScan][2] //Base ISS
EndIf
/*
cString += '<ValorPIS>'+ConvType(aPisXml[1],15,2)+'</ValorPIS>'
cString += '<ValorCOFINS>'+ConvType(aCofinsXml[1],15,2)+'</ValorCOFINS>'
cString += '<ValorINSS>'+ConvType(aInssXml[1],15,2)+'</ValorINSS>'
cString += '<ValorIR>'+ConvType(aIRRFXml[1],15,2)+'</ValorIR>'
cString += '<ValorCSLL>'+ConvType(aCSLLXml[1],15,2)+'</ValorCSLL>'
cString += '<ValorISS>'+ConvType(aISSXml[1],15,2)+'</ValorISS>'

cString += '<AliquotaPIS>'+ConvType(aPisXml[2],15,4)+'</AliquotaPIS>'
cString += '<AliquotaCOFINS>'+ConvType(aCofinsXml[2],15,4)+'</AliquotaCOFINS>'
cString += '<AliquotaINSS>'+ConvType(aInssXml[2],15,4)+'</AliquotaINSS>'
cString += '<AliquotaIR>'+ConvType(aIrrfXml[2],15,4)+'</AliquotaIR>'
cString += '<AliquotaCSLL>'+ConvType(aCSLLXml[2],15,4)+'</AliquotaCSLL>'
*/
cString += '<DescricaoRPS>'+cMensCli+Space(1)+cMensFis+'</DescricaoRPS>'
cString += '<DDDPrestador>'+AllTrim(Str(FisGetTel(SM0->M0_TEL)[2],3))+'</DDDPrestador>'
cString += '<TelefonePrestador>'+AllTrim(Str(FisGetTel(SM0->M0_TEL)[3],15))+'</TelefonePrestador>'
cString += '<DDDTomador>'+AllTrim(Str(Val(SubsTr(aDest[13],1,3))))+'</DDDTomador>'
cString += '<TelefoneTomador>'+AllTrim(Str(Val(SubsTr(aDest[13],4,15))))+'</TelefoneTomador>'
cString += '<MotCancelamento></MotCancelamento>'
cString += '<observacao>'+cMensCli+Space(1)+cMensFis+'</observacao>'

//A operação J-Intermediação é utilizada apenas na prefeitura de Campo Grande, nas demais
//prefeituras não deve ser utilizada. Quando informado o tipo de operação J-Intermediação deve se
//informar o CPF/CNPJ do Intermediário

If cCodMun == "5002704" .And. cString $ '<Tributacao>J</Tributacao>'
	cString += '<CpfCnpjIntermediario>'+'00000000000191'+'</CpfCnpjIntermediario>'
EndIf
 
atel:= FisGetTel(aDest[13])

//ITAJUBA

For Nx := 1 to Len(aProd)
	cXml += '<Item>'
	cXml += '<DiscriminacaoServico>'+ConvType(aProd[Nx][04],120)+'</DiscriminacaoServico>'
	cXml += '<Quantidade>'+AllTrim(Str(aProd[Nx][09]))+'</Quantidade>'
	cXml += '<Aliquota>'+AllTrim(Str(aProd[Nx][24]))+'</Aliquota>'	
	cXml += '<ValorISS>'+AllTrim(ConvType(aProd[Nx][25],15,2))+'</ValorISS>'	
	cXml += '<ValorUnitario>'+AllTrim(ConvType(aProd[Nx][10],15,2))+'</ValorUnitario>'
	cXml += '<ValorTotal>'+AllTrim(ConvType((aProd[Nx][10] * aProd[Nx][09]),15,2))+'</ValorTotal>'
	cXml += '<ItemListaServico>'+AllTrim(aProd[Nx][23])+'</ItemListaServico>'
	cXml += '<ISSRetido>'+AllTrim(aProd[Nx][20])+'</ISSRetido>'
	If ( Len(aProd[Nx]) >= 25 ) 
		cXml += '<ValorISSRetido>'+AllTrim(aProd[Nx][25])+'</ValorISSRetido>'
	EndIf
	cXml += '<ValorIR>'+AllTrim(ConvType(aProd[Nx][27],15,2))+'</ValorIR>'
	cXml += '<ValorPIS>'+AllTrim(ConvType(aProd[Nx][28],15,2))+'</ValorPIS>'
	cXml += '<ValorCOFINS>'+AllTrim(ConvType(aProd[Nx][29],15,2))+'</ValorCOFINS>'
	cXml += '<ValorINSS>'+AllTrim(ConvType(aProd[Nx][30],15,2))+'</ValorINSS>'
	cXml += '<ValorCSLL>'+AllTrim(ConvType(aProd[Nx][31],15,2))+'</ValorCSLL>'
	cXml +=	'<BaseCalculo>'+AllTrim(ConvType(aProd[Nx][26],15,2))+'</BaseCalculo>'
	cXml += "<CodigoTribMunic>" + AllTrim(aProd[nX][32]) + "</CodigoTribMunic>"
	cXml += '<ValorDeducoes>0.00</ValorDeducoes>' //Retirar
	cXml += '</Item>'
Next

If Len(aDeduz) > 0

	For Nx := 1 to Len(aDeduz)

		cdeduz += '<Deducao>'
		cdeduz += '<DeducaoPor>'+Iif(aDeduz[nx][1]=="1","Percentual","Valor")+'</DeducaoPor>'
		cdeduz += '<TipoDeducao>'+Iif(aDeduz[nx][2]=="1","Despesas com Materiais","Despesas com Sub-empreitada")+'</TipoDeducao>'
		cdeduz += '<CPFCNPJReferencia>'+Posicione("SA2",1,xFilial("SA2")+aDeduz[nx][3]+aDeduz[nx][4],"A2_CGC")+'</CPFCNPJReferencia>'
		cdeduz += '<NumeroNFReferencia>'+aDeduz[nx][6]+'</NumeroNFReferencia>
		cdeduz += '<ValorTotalReferencia>'+AllTrim(ConvType(aDeduz[nx][7],15,2))+'</ValorTotalReferencia>'
		cdeduz += '<PercentualDeduzir>'+Iif(aDeduz[nx][1]=="1",AllTrim(ConvType(aDeduz[nx][8],15,2)),"0.00")+'</PercentualDeduzir>'
		cdeduz += '<ValorDeduzir>'+Iif(aDeduz[nx][1]=="2",AllTrim(ConvType(aDeduz[nx][8],15,2)),"0.00")+'</ValorDeduzir>'
		cdeduz += '</Deducao>'
		If Nx >=5
			Break
		EndIf
	Next
EndIf	
cString += '<Deducoes>'         
cString += cdeduz
cString += '</Deducoes>'

cString += '<Itens>'                  
cString += cXml
cString += '</Itens>'       

Return(cString)

//Transportadora - Adicionais
Static Function NFSETransp()
	
	Local cString := ""
	
Return(cString)

Static Function ConvType(xValor,nTam,nDec)
	
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
			cNovo := AllTrim(EnCodeUtf8(NoAcento(SubStr(xValor,1,nTam))))
	EndCase
	
Return(cNovo)

Static Function VldIE(cInsc,lContr)
	
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

Static Function NoAcento(cString)
	
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

//-----------------------------------------------------------------------
/*/{Protheus.doc} NFSEXml003
Verifica se o participante e do DF, ou se tem um tipo de endereco
  que nao se enquadra na regra padrao de preenchimento de endereco
  por exemplo: Enderecos de Area Rural (essa verificção e feita
  atraves do campo ENDNOT).
Caso seja do DF, ou ENDNOT = 'S', somente ira retornar o campo
  Endereco (sem numero ou complemento). Caso contrario ira retornar
  o padrao do FisGetEnd
Esta funcao so pode ser usada quando ha um posicionamento de
  registro, pois será verificado o ENDNOT do registro corrente

@author Liber De Esteban
@since 19/03/09
@version 1.0 

@param  cEndereco Endereço
        cAlias    Alias posicionado no registro

@return Array    {1} = Logradouro; {2} = Número
/*/
//-----------------------------------------------------------------------
Static Function MyGetEnd(cEndereco,cAlias)
	
	Local cCmpEndN	:= SubStr(cAlias,2,2)+"_ENDNOT"
	Local cCmpEst	:= SubStr(cAlias,2,2)+"_EST"
	Local aRet		:= {"",0,"",""}
	
	// Campo ENDNOT indica que endereco participante mao esta no formato <logradouro>, <numero> <complemento>
	// Se tiver com 'S' somente o campo de logradouro sera atualizado (numero sera SN)
	If (&(cAlias+"->"+cCmpEst) == "DF") .Or. ((cAlias)->(FieldPos(cCmpEndN)) > 0 .And. &(cAlias+"->"+cCmpEndN) == "1")
		aRet[1] := cEndereco
		aRet[3] := "SN"
	Else
		aRet := FisGetEnd(cEndereco)
	EndIf
	
Return aRet

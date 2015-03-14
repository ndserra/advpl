#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TBICONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³NfdsXml102³ Autor ³ Vitor Felipe          ³ Data ³24/11/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Exemplo de geracao da Nota Fiscal Digital de Serviços, para ³±±
±±³          ³geracao de XML arquivo.                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Xml arquivo para envio.                                     ³±±
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

User Function NFseM102(cCodMun,cTipo,dDtEmiss,cSerie,cNota,cClieFor,cLoja,cMotCanc)
                	
Local aNota     	:= {}
Local aDupl     	:= {}
Local aDest     	:= {}
Local aPrest     	:= {}
Local aEndPrest		:= {"","","","","","",""}
Local aEntrega  	:= {}
Local aProd     	:= {}
Local aICMS     	:= {}
Local aICMSST   	:= {}
Local aIPI      	:= {}
Local aPIS      	:= {}
Local aCOFINS   	:= {}
Local aPISST    	:= {}
Local aCOFINSST 	:= {}
Local aISSQN    	:= {}
Local aISS      	:= {}
Local aCST      	:= {}
Local aRetido   	:= {}
Local aTransp   	:= {}
Local aImp      	:= {}
Local aVeiculo  	:= {}
Local aReboque  	:= {}
Local aEspVol   	:= {}
Local aNfVinc   	:= {}
Local aPedido   	:= {} 
Local aTotal    	:= {0,0,""}
Local aOldReg   	:= {}
Local aOldReg2  	:= {}
Local aMed			:= {}
Local aArma			:= {}
Local aveicProd		:= {}
Local aIEST			:= {}
Local aDI			:= {}
Local aAdi			:= {}
Local aExp			:= {}
Local aPisAlqZ		:= {}
Local aCofAlqZ		:= {} 
Local aDeduz    	:= {}
Local aTelDest		:= {}
Local aConstr 		:= {} 
Local aMVNFSOBRA	:= &(GetNewPar("MV_NFSOBRA","{}"))
   
Local cString    	:= ""
Local cAliasSE1  	:= "SE1"
Local cAliasSD1  	:= "SD1"
Local cAliasSD2  	:= "SD2"
Local cNatOper   	:= ""
Local cModFrete  	:= ""
Local cScan      	:= ""
Local cEspecie   	:= ""
Local cMensCli   	:= ""
Local cMensFis   	:= ""
Local cNFe       	:= ""
Local cMV_LJTPNFE	:= SuperGetMV("MV_LJTPNFE", ," ")
Local cMVSUBTRIB 	:= SuperGetMv("MV_SUBTRIB")
Local cLJTPNFE	 	:= ""
Local cWhere	 	:= ""
Local cMunISS	 	:= ""    
Local cMunPrest 	:= ""
Local cCodCli   	:= ''
Local cLojCli   	:= ''
Local cDescMunP 	:= '' 
Local cFoneDest		:= ''
Local cCFPS			:=""
Local cCodObra		:= ""
Local cArtObra		:= "" 
Local cField		:= "" 

Local lQuery    	:= .F.
Local lCalSol		:= .F.
Local lEasy			:= SuperGetMV("MV_EASY") == "S" 
Local lEECFAT		:= SuperGetMv("MV_EECFAT")
Local lNatOper  	:= GetNewPar("MV_SPEDNAT",.F.)       
Local lCmpFin  		:= .F.

Local nX        	:= 0
Local nPosI		 	:=	0
Local nPosF	     	:=	0
Local nBaseIrrf 	:=	0
Local nValIrrf  	:= 	0

Local oWSNfe 

Private aUF     	:= {}

DEFAULT cCodMun 	:= PARAMIXB[1]
DEFAULT cTipo   	:= PARAMIXB[2] 
DEFAULT dDtEmiss	:= PARAMIXB[3] 
DEFAULT cSerie  	:= PARAMIXB[4]
DEFAULT cNota   	:= PARAMIXB[5]
DEFAULT cClieFor	:= PARAMIXB[6]
DEFAULT cLoja   	:= PARAMIXB[7]
DEFAULT cMotCanc   	:= PARAMIXB[8]


//Preenchimento do Array de UF
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


lCmpFin := ( SE2->(FieldPos('E2_FIMP') ) > 0 .And. SE2->( FieldPos('E2_NFELETR') ) > 0 .And. FIM->( FieldPos('FIM_CDTRIB') ) > 0 )

If cTipo == "3" //Titulo contas à pagar - NFTS
	
	if lCmpFin
		SE2->( dbSetOrder(6) )
		SE2->( DbGoTop() )
		If SE2->( DbSeek(xFilial("SE2")+cClieFor+cLoja+cSerie+cNota) .And. !Empty( SE2->E2_CODISS ) )
			//Carrega array do cabeçalho da NFTS			
			aadd(aNota,SE2->E2_PREFIXO)
			aadd(aNota,IIF(Len(SE2->E2_NUM)==6,"000","")+SE2->E2_NUM)
			aadd(aNota,SE2->E2_EMISSAO)
			aadd(aNota,cTipo)
			aadd(aNota,SE2->E2_TIPO)
			aadd(aNota,"1")
		    
	   		FIM->( DbSetOrder( 1 ) )
	   		FIM->( DbSeek( xFilial( "FIM" ) + SE2->E2_CODISS ) )
	   				    
			aadd(aProd,	{Len(aProd)+1,;
								"",;
								"",;
								iif( Empty(FIM->FIM_DESCRI), SE2->E2_HIST , FIM->FIM_DESCRI ),;
								"",;
								"",;
								"",;
								"",;
								1,;                      		
								SE2->E2_VALOR,;
								0,;
								0,;
								0,;
								0,;
								0,;
								0,;
								"",; //codigo ANP do combustivel
								"",; //CODIF
								"",;
								"1",;
								0,;
								0,;
								FIM->FIM_CDISSM ,;  //23 -- CODISS verificar no financeiro
								FIM->FIM_ALQISS,; //24 --Aliquota do ISS
								SE2->E2_ISS,;  //25
								SE2->E2_BASEISS,; //26
								0,; //27
								0,; //28
								0,; //29
								0,; //30
								0,; //31
								FIM->FIM_CDTRIB,;//"2301",; //32 - Codigo de Tributação Municipio - B1_TRIBMUN
								"",;//Codigop fiscal de prestacao de servico							
								}) 
				
				aTotal[01] := 0
				aTotal[02] := 0
				aTotal[03] := '1'
								           
				aadd(aCST,{"",;
				           ""})
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
				aadd(aExp,{})
				aadd(aMed,{}) 
				aadd(aArma,{})
				aadd(aveicProd,{})
				
	            //Carrega dados do prestador
			    dbSelectArea("SA2")
				dbSetOrder(1)
				DbSeek(xFilial("SA2")+cClieFor+cLoja)
				
				aadd(aPrest,AllTrim(SA2->A2_CGC))
				aadd(aPrest,SA2->A2_NOME)
				aadd(aPrest,MyGetEnd(SA2->A2_END,"SA2")[1])
				aadd(aPrest,ConvType(IIF(MyGetEnd(SA2->A2_END,"SA2")[2]<>0,MyGetEnd(SA2->A2_END,"SA2")[2],"SN")))
				aadd(aPrest,IIF(SA2->(FieldPos("A2_COMPLEM")) > 0 .And. !Empty(SA2->A2_COMPLEM),SA2->A2_COMPLEM,MyGetEnd(SA2->A2_END,"SA2")[4]))
				aadd(aPrest,SA2->A2_BAIRRO)
				If !Upper(SA2->A2_EST) == "EX"
					aadd(aPrest,SA2->A2_COD_MUN)
					aadd(aPrest,SA2->A2_MUN)				
				Else
					aadd(aPrest,"99999")			
					aadd(aPrest,"EXTERIOR")
				EndIf
				aadd(aPrest,Upper(SA2->A2_EST))
				aadd(aPrest,SA2->A2_CEP)
				aadd(aPrest,IIF(Empty(SA2->A2_PAIS),"1058"  ,Posicione("SYA",1,xFilial("SYA")+SA2->A2_PAIS,"YA_SISEXP")))
				aadd(aPrest,IIF(Empty(SA2->A2_PAIS),"BRASIL",Posicione("SYA",1,xFilial("SYA")+SA2->A2_PAIS,"YA_DESCR" )))
				aadd(aPrest,SA2->A2_DDD+SA2->A2_TEL)
				aadd(aPrest,VldIE(SA2->A2_INSCR,IIF(SA2->(FIELDPOS("A2_CONTRIB"))>0,SA2->A2_CONTRIB<>"2",.T.)))
				aadd(aPrest,"")//SA2->A2_SUFRAMA
				aadd(aPrest,SA2->A2_EMAIL)          
				aadd(aPrest,SA2->A2_INSCRM) 
				aadd(aPrest,SA2->A2_CODSIAF)
				aadd(aPrest,SA2->A2_NATUREZ)            
				If SA2->A2_PAIS = "105"
					aadd(aPrest,"BRASIL")
				ELSE
					aadd(aPrest,"EXTERIOR")
				ENDIF
										            			
				//Carrega dados do Tomador
				aadd(aDest,AllTrim(SM0->M0_CGC))
				aadd(aDest,SM0->M0_NOME)
				aadd(aDest,FisGetEnd(SM0->M0_ENDCOB)[1])
				aadd(aDest,ConvType(IIF(FisGetEnd(SM0->M0_ENDCOB)[2]<>0,FisGetEnd(SM0->M0_ENDCOB)[2],"SN")))
				aadd(aDest,IIF(SM0->(FieldPos("M0_COMPCOB")) > 0 .And. !Empty(SM0->M0_COMPCOB),SM0->M0_COMPCOB,FisGetEnd(SM0->M0_ENDCOB)[4]))
				aadd(aDest,SM0->M0_BAIRENT)
				aadd(aDest,SM0->M0_CODMUN)
				aadd(aDest,SM0->M0_CIDCOB)				
				aadd(aDest,Upper(SM0->M0_ESTCOB))
				aadd(aDest,SM0->M0_CEPCOB)
				aadd(aDest,"1058")
				aadd(aDest,"BRASIL")               
				//Informacoes de telefone
				aTelDest:= FisGetTel(SM0->M0_TEL)
			    cFoneDest := IIF(aTelDest[1] > 0,ConvType(aTelDest[1],3),"") // Código do Pais
			    cFoneDest += IIF(aTelDest[2] > 0,ConvType(aTelDest[2],3),"") // Código da Área
			    cFoneDest += IIF(aTelDest[3] > 0,ConvType(aTelDest[3],9),"") // Código do Telefone			
				aadd(aDest,cFoneDest)
				aadd(aDest,VldIE(SM0->M0_INSC))
				aadd(aDest,"")//SM0->M0_SUFRAMA
				aadd(aDest,"")          
				aadd(aDest,SM0->M0_INSCM) 
				aadd(aDest,"")
				aadd(aDest,"")            
				aadd(aDest,"BRASIL")
							
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Posiciona Natureza                                                      ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				DbSelectArea("SED")
				DbSetOrder(1)
				DbSeek(xFilial("SED")+SA2->A2_NATUREZ)		    
				aadd(aRetido,{"ISS",0,SE2->E2_ISS,aProd[1][24],"1"})
									 
			   	aProd[1][10] += SE2->E2_ISS
			   	
				// Analisa os impostos de retencao 
				If SE2->(FieldPos("E2_PIS"))<>0 .and. SE2->E2_PIS>0
					aadd(aRetido,{"PIS",0,SE2->E2_PIS,SED->ED_PERCPIS})
					aProd[1][10] += SE2->E2_PIS 
				EndIf
				If SE2->(FieldPos("E2_COFINS"))<>0 .and. SE2->E2_COFINS>0
					aadd(aRetido,{"COFINS",0,SE2->E2_COFINS,SED->ED_PERCCOF})
					aProd[1][10] += SE2->E2_COFINS
				EndIf
				If SE2->(FieldPos("E2_CSLL"))<>0 .and. SE2->E2_CSLL>0
					aadd(aRetido,{"CSLL",0,SE2->E2_CSLL,SED->ED_PERCCSL})
					aProd[1][10] += SE2->E2_CSLL
				EndIf
				If SE2->(FieldPos("E2_IRRF"))<>0 .and. SE2->E2_IRRF>0
					aadd(aRetido,{"IRRF",0,SE2->E2_IRRF,SED->ED_PERCIRF})
					aProd[1][10] += SE2->E2_IRRF
				EndIf	
				If SE2->(FieldPos("E2_INSS"))<>0 .and. SE2->E2_INSS>0
					aadd(aRetido,{"INSS",0,SE2->E2_INSS,SED->ED_PERCINS})
					aProd[1][10] += SE2->E2_INSS
				EndIf							
		Endif
		
	endif	
	
ElseIf cTipo == "1"

	//Posiciona NF 
	dbSelectArea("SF2")
	dbSetOrder(1)
	DbGoTop()
	If DbSeek(xFilial("SF2")+cNota+cSerie+cClieFor+cLoja)	

		aadd(aNota,SF2->F2_SERIE)
		aadd(aNota,IIF(Len(SF2->F2_DOC)==6,"000","")+SF2->F2_DOC)
		aadd(aNota,SF2->F2_EMISSAO)
		aadd(aNota,cTipo)
		aadd(aNota,SF2->F2_TIPO)
		aadd(aNota,"1")
		If SF2->(FieldPos("F2_NFSUBST")) > 0 
			aadd(aNota,IIF(Len(SF2->F2_DOC)==6,"000","")+SF2->F2_NFSUBST)
		Endif
		If SF2->(FieldPos("F2_SERSUBS")) > 0 
			aadd(aNota,SF2->F2_SERSUBS)
		Endif
				
		//Posiciona cliente ou fornecedor
		If !SF2->F2_TIPO $ "DB" 

			If IntTMS()
				DT6->(DbSetOrder(1))
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
				aadd(aDest,"99999")			
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
			
			//Carrega dados do Prestador
			aadd(aPrest,AllTrim(SM0->M0_CGC))
			aadd(aPrest,SM0->M0_NOME)
			aadd(aPrest,FisGetEnd(SM0->M0_ENDCOB)[1])
			aadd(aPrest,ConvType(IIF(FisGetEnd(SM0->M0_ENDCOB)[2]<>0,FisGetEnd(SM0->M0_ENDCOB)[2],"SN")))
			aadd(aPrest,IIF(SM0->(FieldPos("M0_COMPCOB")) > 0 .And. !Empty(SM0->M0_COMPCOB),SM0->M0_COMPCOB,FisGetEnd(SM0->M0_ENDCOB)[4]))
			aadd(aPrest,SM0->M0_BAIRENT)
			aadd(aPrest,SM0->M0_CODMUN)
			aadd(aPrest,SM0->M0_CIDCOB)				
			aadd(aPrest,Upper(SM0->M0_ESTCOB))
			aadd(aPrest,SM0->M0_CEPCOB)
			aadd(aPrest,"1058")
			aadd(aPrest,"BRASIL")               
			//Informacoes de telefone
			aTelDest:= FisGetTel(SM0->M0_TEL)
		    cFoneDest := IIF(aTelDest[1] > 0,ConvType(aTelDest[1],3),"") // Código do Pais
		    cFoneDest += IIF(aTelDest[2] > 0,ConvType(aTelDest[2],3),"") // Código da Área
		    cFoneDest += IIF(aTelDest[3] > 0,ConvType(aTelDest[3],9),"") // Código do Telefone			
			aadd(aPrest,cFoneDest)
			aadd(aPrest,VldIE(SM0->M0_INSC))
			aadd(aPrest,"")//SM0->M0_SUFRAMA
			aadd(aPrest,"")          
			aadd(aPrest,SM0->M0_INSCM) 
			aadd(aPrest,"")
			aadd(aPrest,"")            
			aadd(aPrest,"BRASIL")
			
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Posiciona Natureza                                                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
				aadd(aDest,"99999")			
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
				
					aadd(aDupl,{(cAliasSE1)->E1_PREFIXO+(cAliasSE1)->E1_NUM+(cAliasSE1)->E1_PARCELA,(cAliasSE1)->E1_VENCORI,(cAliasSE1)->E1_VALOR,(cAliasSE1)->E1_PARCELA})
				
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

			// Verifica se recolhe ISS Retido 
			If SF3->(FieldPos("F3_RECISS"))>0
				If SF3->F3_RECISS $"1S"       
					dbSelectArea("SD2")
					dbSetOrder(3)
   					dbSeek(xFilial("SD2")+SF3->F3_NFISCAL+SF3->F3_SERIE+SF3->F3_CLIEFOR+SF3->F3_LOJA)
					
					aadd(aRetido,{"ISS",0,SF3->F3_VALICM,SD2->D2_ALIQISS,SF3->F3_RECISS})
		   		Endif
			EndIf 
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
			aadd(aRetido,{"ISSQN",SF2->F2_BASEISS,SF2->F2_VALISS})
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
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica a natureza da operacao                                         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
			If SF4->(FieldPos("F4_CFPS")) > 0
				cCFPS:=SF4->F4_CFPS
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

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³TRATAMENTO - INTEGRACAO COM TMS-GESTAO DE TRANSPORTES³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
		    	aEndPrest :=  GetPresEnd(aDest)			
			Else
	   		If Alltrim(SM0->M0_CODMUN) == "4299599" // Teixeira de Freitas -BA
	   			If SC5->(FieldPos("C5_MUNPRES")) > 0 
					cMunPrest := SC5->C5_MUNPRES
					cDescMunP := SC5->C5_DESCMUN
				End
	   		Endif
	   		aEndPrest := GetPresEnd(aDest)
				
	   			If Empty(aEndPrest)
					If SC5->(FieldPos("C5_MUNPRES")) > 0 
						cMunPrest := SC5->C5_MUNPRES
						cDescMunP := SC5->C5_DESCMUN
					Else
						If !cCodMun $ "4205407-3305505"
							cMunPrest := aDest[18]
						Else
							cMunPrest := aDest[07]
						EndIF
						cDescMunP := aDest[08]
						cModFrete := IIF(SC5->C5_TPFRETE=="C","0","1")
					EndIf		
												
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
							RetFldProd(SB1->B1_COD,"B1_CNAE"),;   //19
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
							If(SF4->(FieldPos("F4_CFPS")) > 0,SF4->F4_CFPS,""),;//33 
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
	Else
		If ( !Empty(cMotCanc) )  		
			aadd(aNota,cSerie)
			aadd(aNota,IIF(Len(cNota)==6,"000","")+cNota)
			aadd(aNota,dDtEmiss)
			aadd(aNota,cTipo)
			aadd(aNota,"")
			aadd(aNota,"1")	
			
			cString := '<RPS Id="rps:'+AllTrim(Str(Val(aNota[02])))+'">'
			cString += NFSECab(cCodMun,aNota)
			cString += '<MotCancelamento>'+cMotCanc+'</MotCancelamento>'
			cString += '</RPS>' 							
		EndIf
	EndIf
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Posiciona NF                                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SF1")
	dbSetOrder(1)
	DbGoTop()
	If DbSeek(xFilial("SF1")+cNota+cSerie+cClieFor+cLoja)	

		aadd(aNota,SF1->F1_SERIE)
		aadd(aNota,IIF(Len(SF1->F1_DOC)==6,"000","")+SF1->F1_DOC)
		aadd(aNota,SF1->F1_EMISSAO)
		aadd(aNota,cTipo)
		aadd(aNota,SF1->F1_TIPO)
		aadd(aNota,"1")
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Posiciona cliente ou fornecedor                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
		If !SF1->F1_TIPO $ "DB" 

			cCodCli := SF1->F1_FORNECE
			cLojCli := SF1->F1_LOJA

            //Carrega dados do prestador
		    dbSelectArea("SA2")
			dbSetOrder(1)
			DbSeek(xFilial("SA2")+cCodCli+cLojCli)
			
			aadd(aPrest,AllTrim(SA2->A2_CGC))
			aadd(aPrest,SA2->A2_NOME)
			aadd(aPrest,MyGetEnd(SA2->A2_END,"SA2")[1])
			aadd(aPrest,ConvType(IIF(MyGetEnd(SA2->A2_END,"SA2")[2]<>0,MyGetEnd(SA2->A2_END,"SA2")[2],"SN")))
			aadd(aPrest,IIF(SA2->(FieldPos("A2_COMPLEM")) > 0 .And. !Empty(SA2->A2_COMPLEM),SA2->A2_COMPLEM,MyGetEnd(SA2->A2_END,"SA2")[4]))
			aadd(aPrest,SA2->A2_BAIRRO)
			If !Upper(SA2->A2_EST) == "EX"
				aadd(aPrest,SA2->A2_COD_MUN)
				aadd(aPrest,SA2->A2_MUN)				
			Else
				aadd(aPrest,"99999")			
				aadd(aPrest,"EXTERIOR")
			EndIf
			aadd(aPrest,Upper(SA2->A2_EST))
			aadd(aPrest,SA2->A2_CEP)
			aadd(aPrest,IIF(Empty(SA2->A2_PAIS),"1058"  ,Posicione("SYA",1,xFilial("SYA")+SA2->A2_PAIS,"YA_SISEXP")))
			aadd(aPrest,IIF(Empty(SA2->A2_PAIS),"BRASIL",Posicione("SYA",1,xFilial("SYA")+SA2->A2_PAIS,"YA_DESCR" )))
			aadd(aPrest,SA2->A2_DDD+SA2->A2_TEL)
			aadd(aPrest,VldIE(SA2->A2_INSCR,IIF(SA2->(FIELDPOS("A2_CONTRIB"))>0,SA2->A2_CONTRIB<>"2",.T.)))
			aadd(aPrest,"")//SA2->A2_SUFRAMA
			aadd(aPrest,SA2->A2_EMAIL)          
			aadd(aPrest,SA2->A2_INSCRM) 
			aadd(aPrest,SA2->A2_CODSIAF)
			aadd(aPrest,SA2->A2_NATUREZ)            
			If SA2->A2_PAIS = "105"
				aadd(aPrest,"BRASIL")
			ELSE
				aadd(aPrest,"EXTERIOR")
			ENDIF
			
			            
			//--Retorna para o cliente do SF1:
			SA2->(DbSeek(xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA))
			
			//Carrega dados do Tomador
			aadd(aDest,AllTrim(SM0->M0_CGC))
			aadd(aDest,SM0->M0_NOME)
			aadd(aDest,FisGetEnd(SM0->M0_ENDCOB)[1])
			aadd(aDest,ConvType(IIF(FisGetEnd(SM0->M0_ENDCOB)[2]<>0,FisGetEnd(SM0->M0_ENDCOB)[2],"SN")))
			aadd(aDest,IIF(SM0->(FieldPos("M0_COMPCOB")) > 0 .And. !Empty(SM0->M0_COMPCOB),SM0->M0_COMPCOB,FisGetEnd(SM0->M0_ENDCOB)[4]))
			aadd(aDest,SM0->M0_BAIRENT)
			aadd(aDest,SM0->M0_CODMUN)
			aadd(aDest,SM0->M0_CIDCOB)				
			aadd(aDest,Upper(SM0->M0_ESTCOB))
			aadd(aDest,SM0->M0_CEPCOB)
			aadd(aDest,"1058")
			aadd(aDest,"BRASIL")               
			//Informacoes de telefone
			aTelDest:= FisGetTel(SM0->M0_TEL)
		    cFoneDest := IIF(aTelDest[1] > 0,ConvType(aTelDest[1],3),"") // Código do Pais
		    cFoneDest += IIF(aTelDest[2] > 0,ConvType(aTelDest[2],3),"") // Código da Área
		    cFoneDest += IIF(aTelDest[3] > 0,ConvType(aTelDest[3],9),"") // Código do Telefone			
			aadd(aDest,cFoneDest)
			aadd(aDest,VldIE(SM0->M0_INSC))
			aadd(aDest,"")//SM0->M0_SUFRAMA
			aadd(aDest,"")          
			aadd(aDest,SM0->M0_INSCM) 
			aadd(aDest,"")
			aadd(aDest,"")            
			aadd(aDest,"BRASIL")
						
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Posiciona Natureza                                                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			DbSelectArea("SED")
			DbSetOrder(1)
			DbSeek(xFilial("SED")+SA2->A2_NATUREZ) 			
										
		Else
		    dbSelectArea("SA2")
			dbSetOrder(1)
			DbSeek(xFilial("SA2")+SF1->F1_FORNECEE+SF1->F1_LOJA)	
	
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
				aadd(aDest,"99999")			
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
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Posiciona Natureza                                                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			DbSelectArea("SED")
			DbSetOrder(1)
			DbSeek(xFilial("SED")+SA2->A2_NATUREZ) 
			
		EndIf
		
		dbSelectArea("SF1")
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Procura duplicatas                                                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If !Empty(SF1->F1_DUPL)	
			cLJTPNFE := (StrTran(cMV_LJTPNFE," ,"," ','"))+" "
			cWhere := cLJTPNFE
			dbSelectArea("SE2")
			dbSetOrder(1)	
			#IFDEF TOP
				lQuery  := .T.
				cAliasSE2 := GetNextAlias()
				BeginSql Alias cAliasSE2
					COLUMN E2_VENCORI AS DATE
					SELECT E2_FILIAL,E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO,E2_VENCORI,E2_VALOR,E2_ORIGEM
					FROM %Table:SE2% SE2
					WHERE
					SE2.E2_FILIAL = %xFilial:SE2% AND
					SE2.E2_PREFIXO = %Exp:SF1->F1_PREFIXO% AND 
					SE2.E2_NUM = %Exp:SF1->F1_DUPL% AND 
					((SE2.E2_TIPO = %Exp:MVNOTAFIS%) OR
					 (SE2.E2_ORIGEM = 'LOJA701' AND SE2.E2_TIPO IN (%Exp:cWhere%))) AND
					SE2.%NotDel%
					ORDER BY %Order:SE2%
				EndSql
				
			#ELSE
				DbSeek(xFilial("SE2")+SF1->F1_PREFIXO+SF1->F1_DOC)
			#ENDIF
			While !Eof() .And. xFilial("SE2") == (cAliasSE2)->E2_FILIAL .And.;
				SF1->F1_PREFIXO == (cAliasSE2)->E2_PREFIXO .And.;
				SF1->F1_DOC == (cAliasSE2)->E2_NUM
				If 	(cAliasSE2)->E2_TIPO = MVNOTAFIS .OR. ((cAliasSE2)->E2_ORIGEM = 'LOJA701' .AND. (cAliasSE2)->E2_TIPO $ cWhere)
				
					aadd(aDupl,{(cAliasSE2)->E2_PREFIXO+(cAliasSE2)->E2_NUM+(cAliasSE2)->E2_PARCELA,(cAliasSE2)->E2_VENCORI,(cAliasSE2)->E2_VALOR})
				
				EndIf
				dbSelectArea(cAliasSE2)
				dbSkip()
		    EndDo
		    If lQuery
		    	dbSelectArea(cAliasSE2)
		    	dbCloseArea()
		    	dbSelectArea("SE2")
		    EndIf
		Else
			aDupl := {}
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Analisa os impostos de retencao                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		

		If SF1->(FieldPos("F1_VALPIS"))<>0 .and. SF1->F1_VALPIS>0
			aadd(aRetido,{"PIS",0,SF1->F1_VALPIS,SED->ED_PERCPIS})
		EndIf
		If SF1->(FieldPos("F1_VALCOFI"))<>0 .and. SF1->F1_VALCOFI>0
			aadd(aRetido,{"COFINS",0,SF1->F1_VALCOFI,SED->ED_PERCCOF})
		EndIf
		If SF1->(FieldPos("F1_VALCSLL"))<>0 .and. SF1->F1_VALCSLL>0
			aadd(aRetido,{"CSLL",0,SF1->F1_VALCSLL,SED->ED_PERCCSL})
		EndIf
		/*
		If SF1->(FieldPos("F1_IRRF"))<>0 .and. SF1->F1_IRRF>0
			aadd(aRetido,{"IRRF",SF1->F1_BASEIRR,SF1->F1_IRRF,SED->ED_PERCIRF})
		EndIf	
		*/
		If SF1->(FieldPos("F1_INSS"))<>0 .and. SF1->F1_BASEINS>0
			aadd(aRetido,{"INSS",SF1->F1_BASEINS,SF1->F1_INSS,SED->ED_PERCINS})
		EndIf   
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Expressão para incluir campos na pesquisa de itens da nota ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		

		cField := "%"
		// Codigo Obra e ART NFTS
		dbSelectArea("SD1")
		dbSetOrder(1)
		If aMVNFSOBRA <> nil
			if Len(aMVNFSOBRA) == 2  
				cCodObra	:= aMVNFSOBRA[1] 
				cArtObra	:= aMVNFSOBRA[2] 
			  
				If SD1->(FieldPos(cCodObra)) <> 0 .AND. SD1->(FieldPos(cArtObra)) <> 0
					cField += ","+cCodObra+","+cArtObra 
				EndIf
			endif
		EndIf
		CField += "%"
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Pesquisa itens de nota                                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
		dbSelectArea("SD1")
		dbSetOrder(3)	
		#IFDEF TOP
			lQuery  := .T.
			cAliasSD1 := GetNextAlias()
			BeginSql Alias cAliasSD1
				SELECT D1_FILIAL,D1_SERIE,D1_DOC,D1_FORNECE,D1_LOJA,D1_COD,D1_TES,D1_NFORI,D1_SERIORI,D1_ITEMORI,D1_TIPO,D1_ITEM,D1_CF,					
					D1_QUANT,D1_TOTAL,D1_DESC,D1_VALFRE,D1_SEGURO,D1_PEDIDO,D1_ITEMPV,D1_DESPESA,D1_VALISS,D1_VUNIT,
					D1_CLASFIS,D1_CODISS,D1_ALIQISS,D1_BASEISS,D1_VALIMP1,D1_VALIMP2,D1_VALIMP3,D1_VALIMP4,D1_VALIMP5,D1_BASEIRR,D1_VALIRR %Exp:cField%  
															                                                                                                                   										
				FROM %Table:SD1% SD1
				WHERE
				SD1.D1_FILIAL = %xFilial:SD1% AND
				SD1.D1_SERIE = %Exp:SF1->F1_SERIE% AND 
				SD1.D1_DOC = %Exp:SF1->F1_DOC% AND 
				SD1.D1_FORNECE = %Exp:SF1->F1_FORNECEE% AND 
				SD1.D1_LOJA = %Exp:SF1->F1_LOJA% AND 
				SD1.%NotDel%
				ORDER BY %Order:SD1%
			EndSql
				
		#ELSE
			DbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECEE+SF1->F1_LOJA)
		#ENDIF
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Posiciona na Construção Cilvil                                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
		
		If ( SD1->(FieldPos(cCodObra)) > 0 .And. !Empty(&(cCodObra)) ) .And. ( SD1->(FieldPos(cArtObra)) > 0 .And. !Empty(&(cArtObra)) )
				aadd(aConstr,(&(cCodObra)))
				aadd(aConstr,(&(cArtObra)))	
		EndIf
				
		While !Eof() .And. xFilial("SD1") == (cAliasSD1)->D1_FILIAL .And.;
			SF1->F1_SERIE == (cAliasSD1)->D1_SERIE .And.;
			SF1->F1_DOC == (cAliasSD1)->D1_DOC
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica a natureza da operacao                                         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
    		
    		If (cAliasSD1)->D1_BASEIRR > 0  .And. (cAliasSD1)->D1_VALIRR > 0 
				nBaseIrrf += (cAliasSD1)->D1_BASEIRR
				nValIrrf  += (cAliasSD1)->D1_VALIRR 
			EndIf 
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica as notas vinculadas                                            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !Empty((cAliasSD1)->D1_NFORI) 
				If (cAliasSD1)->D1_TIPO $ "DBN"
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
				Else
					aOldReg  := SD1->(GetArea())
					aOldReg2 := SF1->(GetArea())
					dbSelectArea("SD1")
					dbSetOrder(3)
					If DbSeek(xFilial("SD1")+(cAliasSD1)->D1_NFORI+(cAliasSD1)->D1_SERIORI+(cAliasSD1)->D1_FORNECE+(cAliasSD1)->D1_LOJA+(cAliasSD1)->D1_COD+(cAliasSD1)->D1_ITEMORI)
						dbSelectArea("SF1")
						dbSetOrder(1)
						DbSeek(xFilial("SF1")+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA)
						If !SD1->D1_TIPO $ "DB"
							dbSelectArea("SA2")
							dbSetOrder(1)
							DbSeek(xFilial("SA2")+SD1->D1_FORNECE+SD1->D1_LOJA)
						Else
							dbSelectArea("SA1")
							dbSetOrder(1)
							DbSeek(xFilial("SA1")+SD1->D1_FORNECE+SD1->D1_LOJA)
						EndIf
						
						aadd(aNfVinc,{SF1->F1_EMISSAO,SD1->D1_SERIE,SD1->D1_DOC,SM0->M0_CGC,SM0->M0_ESTCOB,SF1->F1_ESPECIE})
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
			DbSeek(xFilial("SB1")+(cAliasSD1)->D1_COD)
			
			dbSelectArea("SB5")
			dbSetOrder(1)
			DbSeek(xFilial("SB5")+(cAliasSD1)->D1_COD)
								
			dbSelectArea("SF3")
			dbSetOrder(4)
			DbSeek(xFilial("SF3")+SF1->F1_FORNECEE+SF1->F1_LOJA+SF1->F1_DOC+SF1->F1_SERIE)								
		
		
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
							((cAliasSD1)->D1_DESC),;
							IIF(!(cAliasSD1)->D1_TIPO$"IP",(cAliasSD1)->D1_VUNIT+((cAliasSD1)->D1_DESC/(cAliasSD1)->D1_QUANT),0),;
							IIF(SB1->(FieldPos("B1_CODSIMP"))<>0,SB1->B1_CODSIMP,""),; //codigo ANP do combustivel
							IIF(SB1->(FieldPos("B1_CODIF"))<>0,SB1->B1_CODIF,""),; //CODIF
							RetFldProd(SB1->B1_COD,"B1_CNAE"),;
							IIf(Alltrim(SF3->F3_RECISS) $ "1S","2","1"),;
							SF3->F3_ISSSUB,;
							SF3->F3_ISSMAT,;
							SF3->F3_CODISS,;  //23
							(cAliasSD1)->D1_ALIQISS,; //24
							(cAliasSD1)->D1_VALISS,;  //25
							(cAliasSD1)->D1_BASEISS,; //26
							(cAliasSD1)->D1_VALIMP1,; //27
							(cAliasSD1)->D1_VALIMP2,; //28
							(cAliasSD1)->D1_VALIMP3,; //29
							(cAliasSD1)->D1_VALIMP4,; //30
							(cAliasSD1)->D1_VALIMP5,; //31
							RetFldProd(SB1->B1_COD,"B1_TRIBMUN"),; //32
							If(SF4->(FieldPos("F4_CFPS")) > 0,SF4->F4_CFPS,""),;//Codigop fiscal de prestacao de servico							
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
			aadd(aISSQN,{0,0,0,"",""})
			aadd(aAdi,{})
			aadd(aDi,{})
			aadd(aExp,{})
			aadd(aMed,{}) 
			aadd(aArma,{})
			aadd(aveicProd,{})				
					
			dbSelectArea("CD2")
			If !(cAliasSD1)->D1_TIPO $ "DB"
				dbSetOrder(2)
			Else
				dbSetOrder(1)
			EndIf
			dbSeek(xFilial("CD2")+"E"+SF1->F1_SERIE+SF1->F1_DOC+SF1->F1_FORNECEE+SF1->F1_LOJA+PadR((cAliasSD1)->D1_ITEM,4)+Rtrim((cAliasSD1)->D1_COD))
			While !Eof() .And. xFilial("CD2") == CD2->CD2_FILIAL .And.;
				"E" == CD2->CD2_TPMOV .And.;
				SF1->F1_SERIE == CD2->CD2_SERIE .And.;
				SF1->F1_DOC == CD2->CD2_DOC .And.;
				SF1->F1_FORNECE == IIF(!(cAliasSD1)->D1_TIPO $ "DB",CD2->CD2_CODFOR,CD2->CD2_CODCLI) .And.;
				SF1->F1_LOJA == IIF(!(cAliasSD1)->D1_TIPO $ "DB",CD2->CD2_LOJFOR,CD2->CD2_LOJCLI) .And.;
				(cAliasSD1)->D1_ITEM == SubStr(CD2->CD2_ITEM,1,Len((cAliasSD1)->D1_ITEM)) .And.;
				Rtrim((cAliasSD1)->D1_COD) == Rtrim(CD2->CD2_CODPRO)
				
				Do Case
					Case AllTrim(CD2->CD2_IMP) == "ICM"
						aTail(aICMS) := {CD2->CD2_ORIGEM,CD2->CD2_CST,CD2->CD2_MODBC,CD2->CD2_PREDBC,CD2->CD2_BC,CD2->CD2_ALIQ,CD2->CD2_VLTRIB,0,CD2->CD2_QTRIB,CD2->CD2_PAUTA}
					Case AllTrim(CD2->CD2_IMP) == "SOL"
						aTail(aICMSST) := {CD2->CD2_ORIGEM,CD2->CD2_CST,CD2->CD2_MODBC,CD2->CD2_PREDBC,CD2->CD2_BC,CD2->CD2_ALIQ,CD2->CD2_VLTRIB,CD2->CD2_MVA,CD2->CD2_QTRIB,CD2->CD2_PAUTA}
						lCalSol := .T.
					Case AllTrim(CD2->CD2_IMP) == "IPI"
						aTail(aIPI) := {"","",0,"999",CD2->CD2_CST,CD2->CD2_BC,CD2->CD2_QTRIB,CD2->CD2_PAUTA,CD2->CD2_ALIQ,CD2->CD2_VLTRIB,CD2->CD2_MODBC,CD2->CD2_PREDBC}
					Case AllTrim(CD2->CD2_IMP) == "PS2"
						If (cAliasSD1)->D1_VALISS==0
							aTail(aPIS) := {CD2->CD2_CST,CD2->CD2_BC,CD2->CD2_ALIQ,CD2->CD2_VLTRIB,CD2->CD2_QTRIB,CD2->CD2_PAUTA}
						Else
							If Empty(aISS)
								aISS := {0,0,0,0,0}
							EndIf
							aISS[04]+= CD2->CD2_VLTRIB	
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
						aISS[01] += (cAliasSD1)->D1_TOTAL+(cAliasSD1)->D1_DESC
						aISS[02] += CD2->CD2_BC
						aISS[03] += CD2->CD2_VLTRIB	
						cMunISS := ConvType(aUF[aScan(aUF,{|x| x[1] == aDest[09]})][02]+aDest[07])
						aTail(aISSQN) := {CD2->CD2_BC,CD2->CD2_ALIQ,CD2->CD2_VLTRIB,cMunISS,AllTrim((cAliasSD1)->D1_CODISS)}
				EndCase
				dbSelectArea("CD2")
				dbSkip()
			EndDo
			aTotal[01] += (cAliasSD1)->D1_DESPESA
			aTotal[02] += (cAliasSD1)->D1_TOTAL	
			aTotal[03] := SF4->F4_ISSST			
						
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
							
			dbSelectArea(cAliasSD1)
			dbSkip()
	    EndDo
	    
    	If nBaseIrrf > 0 .And. nValIrrf > 0
			aadd(aRetido,{"IRRF",0,nValIrrf,SED->ED_PERCIRF})
		EndIf
		
	    If lQuery
	    	dbSelectArea(cAliasSD1)
	    	dbCloseArea()
	    	dbSelectArea("SD1")
	    EndIf
	Else
		If ( !Empty(cMotCanc) )  		
			aadd(aNota,cSerie)
			aadd(aNota,IIF(Len(cNota)==6,"000","")+cNota)
			aadd(aNota,dDtEmiss)
			aadd(aNota,cTipo)
			aadd(aNota,"")
			aadd(aNota,"1")	
			
			cString := '<RPS Id="rps:'+AllTrim(Str(Val(aNota[02])))+'">'
			cString += NFSECab(cCodMun,aNota)
			cString += '<MotCancelamento>'+cMotCanc+'</MotCancelamento>'
			cString += '</RPS>' 							
		EndIf        
	
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Geracao do arquivo XML                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If !Empty(aNota) .And. Empty(cMotCanc)
	cString := '<RPS Id="rps:'+AllTrim(Str(Val(aNota[02])))+'">'
	cString += NFSEAssina(cCodMun,aNota,aProd,aTotal,aDest,aDeduz)
	cString += NFSECab(cCodMun,aNota)	
	cString += NFSEDest(cCodMun,aDest,cMunPrest)
	cString += NFSEConstr(cCodmun,aConstr)
	cString += NFSEPrest(cCodMun,aPrest)
	cString += NFSEMunPre(cCodMun,aEndPrest,cTipo)
	cString += NFSEItem(cCodMun,aProd,aICMS,aICMSST,aIPI,aPIS,aPISST,aCOFINS,aCOFINSST,aISSQN,aCST,aMed,aArma,aveicProd,aDI,aAdi,aExp,aPisAlqZ,aCofAlqZ,aDest, aNota,aTotal,aRetido,cMensCli,cMensFis,cMunPrest,cDescMunP,aDeduz,cMotCanc)
	cString += NFSEFat(cCodMun,aDupl)
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

cAssinatura := AllTrim(Lower(Sha1(AllTrim(cAssinatura),2)))
cAssinatura := '<Assinatura>'+cAssinatura+'</Assinatura>'

Return(cAssinatura)             

//Cabeçalho
Static Function NfseCab(cCodMun,aNota)

Local cString 		:= ""
Local cTipDoc 		:= ""
Local aMVTitNFT		:= &(GetNewPar("MV_TITNFTS","{}"))
                                       
If Alltrim(SM0->M0_CODMUN) $ "2607208-3305505" //IPOJUCA-PE # SAQUAREMA-RJ
	cString += '<TipoRPS>1</TipoRPS>'
ElseIf Alltrim(SM0->M0_CODMUN) $ "3550308-3304557" .And. aNota[04] == "0" .or. aNota[04] == "3" // NFTS - SP , Nfts - Rio de Janeiro-RJ
	cString += '<TipoRPS>4</TipoRPS>'
Else
	cString += '<TipoRPS>RPS</TipoRPS>'
EndIf
cString += '<SerieRPS>'+AllTrim(aNota[01])+'</SerieRPS>'
cString += '<NumeroRPS>'+AllTrim(Str(Val(aNota[02])))+'</NumeroRPS>'
cString += '<DataEmissaoRPS>'+Substr(Dtos(aNota[03]),1,4)+"-"+  Substr(Dtos(aNota[03]),5,2)+"-"+ Substr(Dtos(aNota[03]),7,2)+'T'+Time()+'</DataEmissaoRPS>'
cString += '<SituacaoRPS>N</SituacaoRPS>'
If !cCodMun $ "4205407-3305505"
	cString += '<SerieRPSSubstituido></SerieRPSSubstituido>'
	cString += '<NumeroRPSSubstituido>0</NumeroRPSSubstituido>'
	cString += '<NumeroNFSeSubstituida>0</NumeroNFSeSubstituida>'
	cString += '<DataEmissaoNFSeSubstituida>1900-01-01</DataEmissaoNFSeSubstituida>'
Else
	cString += '<SerieRPSSubstituido>'+AllTrim(aNota[08])+'</SerieRPSSubstituido>'
	cString += '<NumeroRPSSubstituido>'+aNota[07]+'</NumeroRPSSubstituido>'
	cString += '<NumeroNFSeSubstituida>0</NumeroNFSeSubstituida>'
	cString += '<DataEmissaoNFSeSubstituida>1900-01-01</DataEmissaoNFSeSubstituida>'
	cString += '<NfseIdSubstituido>'+aNota[08]+aNota[07]+'</NfseIdSubstituido>'
	cString += '<TipoRPSSubstituido>1</TipoRPSSubstituido>'
EndIf
cString += '<SeriePrestacao>99</SeriePrestacao>'
if aNota[4] == "0"
	cString += '<TipoDoDocumento>02</TipoDoDocumento>'
else
 	if aScan(aMVTitNFT,{|x| x[1] == aNota[5]}) == 1
   		cString += '<TipoDoDocumento>01</TipoDoDocumento>'
   	else
		cString += '<TipoDoDocumento>03</TipoDoDocumento>'   	
   	endif 	
endif	

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
If Alltrim(SM0->M0_CODMUN) == "2607208" //IPOJUCA - PE
	cString += '<CidadeTomador>'+StrZero(Val( Iif( Empty(cMunPrest), aDest[07] ,cMunPrest ) ),10)+'</CidadeTomador>'
ElseIf Alltrim(SM0->M0_CODMUN) $ "4205407-3305505" //Florianopolis # Saquarema-RJ
	cString += '<CidadeTomador>'+Iif( Empty(cMunPrest), UFCodIBGE2(aDest[09]) +aDest[07] ,cMunPrest )+'</CidadeTomador>'	
ElseIf Alltrim(SM0->M0_CODMUN) == "4299599" // Teixeira de Freitas -BA
	cString += '<CidadeTomador>'+aDest[07]+'</CidadeTomador>'
Else
	cString += '<CidadeTomador>'+StrZero(Val(aDest[18]),10)+'</CidadeTomador>'
EndIf
cString += '<CidadeTomadorDescricao>'+AllTrim(aDest[08])+'</CidadeTomadorDescricao>'
cString += '<CEPTomador>'+AllTrim(aDest[10])+'</CEPTomador>'
cString += '<EmailTomador>'+AllTrim(aDest[16])+'</EmailTomador>'
If cCodMun <> "3168705"	
	If SA1->(FieldPos("A1_TPNFSE")) > 0 
		cString += '<SituacaoEspecial>'+AllTrim(SA1->A1_TPNFSE)+'</SituacaoEspecial>'
	Else
		cString += '<SituacaoEspecial>0</SituacaoEspecial>'
	Endif
EndIf
cString += '<UfTomador>'+AllTrim(aDest[09])+'</UfTomador>'
If cCodMun <> "4205407"
	cString += '<PaisTomador>'+AllTrim(aDest[20])+'</PaisTomador>'
Else
	cString += '<PaisTomador>'+AllTrim(aDest[11])+'</PaisTomador>'
EndIf                                            

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
Static Function NFSEFat(cCodMun,aDupl)

	Local nX:=0
	Local cString := ""
	If cCodMun $ "3201308" //Cariacica-3201308  
		For nX:=1 To Len(aDupl)
			cString+='<Pagamentos>'
			cString+='<Pagamento>'
			cString+='<Parcela>'+If(!Empty(Alltrim(aDupl[nX][4])),Alltrim(aDupl[nX][4]),"1")+'</Parcela>'
			cString+='<DtVencimento>'+Substr(Dtos(aDupl[nX][2]),1,4)+"-"+  Substr(Dtos(aDupl[nX][2]),5,2)+"-"+ Substr(Dtos(aDupl[nX][2]),7,2)+'</DtVencimento>'
			cString+='<Valor>'+Alltrim(Str(aDupl[nX][3]))+'</Valor>'
			cString+='</Pagamento>'
			cString+='</Pagamentos>'
		Next
	EndIf
Return(cString)


//Serviço
Static Function NFSEItem(cCodMun,aProd,aICMS,aICMSST,aIPI,aPIS,aPISST,aCOFINS,aCOFINSST,aISSQN,aCST,aMed,aArma,aveicProd,aDI,aAdi,aExp,aPisAlqZ,aCofAlqZ, aDest, aNota, aTotal,aRetido,cMensCli,cMensFis,cMunPrest,cDescMunP,aDeduz,cMotCanc)
                      
Local aPisXml    := {0,0}
Local aCofinsXml := {0,0}
Local aCSLLXml   := {0,0}
Local aIrrfXml   := {0,0}
Local aInssXml   := {0,0}
Local aISSXml	 := {0,0}
Local aIssRet    := {0,"",0}	

Local cXml       := ""
Local cString    := ""
Local cDeduz     := "" 
Local cMVREGIESP :=	AllTrim(GetNewPar("MV_REGIESP",""))
Local cMVOPTSIMP :=	AllTrim(GetNewPar("MV_OPTSIMP","2"))
Local cMVINCECUL :=	AllTrim(GetNewPar("MV_INCECUL","2"))
Local cTributa   := ""

Local Nx         := 0
Local nDeduz     := 0
Local nOutRet	 := 0
         
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
DEFAULT cMotCanc := ""

cString := ''
If Alltrim(SM0->M0_CODMUN) == "2607208" //IPOJUCA - PE
	cString += '<CodigoAtividade>'+AllTrim(aProd[1][32])+'</CodigoAtividade>'                                                        
Else
	cString += '<CodigoAtividade>'+AllTrim(aProd[1][19])+'</CodigoAtividade>'                                                        
EndIf
cString += '<AliquotaAtividade>'+ConvType(aISSQN[1][02],5)+'</AliquotaAtividade>'
cString += '<TipoRecolhimento>'+Iif((aProd[1][20])=='1',"R","A")+'</TipoRecolhimento>'   
If Alltrim(SM0->M0_CODMUN) == "3168705"
	cString += '<MunicipioPrestacao>'+StrZero(Val( Iif( Empty(cMunPrest), aDest[18] ,cMunPrest ) ),7)+'</MunicipioPrestacao>'
ElseIf Alltrim(SM0->M0_CODMUN) == "4299599" //Teixeira de freitas 
  	cString += '<MunicipioPrestacao>'+ Iif( Empty(cMunPrest),aDest[18],cMunPrest) +'</MunicipioPrestacao>'
ElseIf Alltrim(SM0->M0_CODMUN) $ "3305505-3152501" //Saquarema-RJ # Pouso Alegre
	cString += '<MunicipioPrestacao>'+Iif( Empty(cMunPrest), UFCodIBGE2(aDest[09]) +aDest[07] ,cMunPrest )+'</MunicipioPrestacao>'
Else	
	cString += '<MunicipioPrestacao>'+StrZero(Val( Iif( Empty(cMunPrest), aDest[18] ,cMunPrest ) ),10)+'</MunicipioPrestacao>'
EndIf
cString += '<MunicipioPrestacaoDescricao>'+AllTrim(Iif( Empty(cDescMunP), aDest[08] ,cDescMunP))+'</MunicipioPrestacaoDescricao>'

Do Case
	Case aNota[4] $ "DB"
		cString += '<Operacao>D</Operacao>'
    Case aISSQN[1][02] <= 0
		cString += '<Operacao>C</Operacao>'
	OtherWise
		cString += '<Operacao>A</Operacao>'
EndCase
 
If !Alltrim(SM0->M0_CODMUN) $ "3305505-3152501"       
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
Else
	cTributa := aTotal[3]
	cString += '<Tributacao>'+  Iif(Empty(cTributa), "1", cTributa)+'</Tributacao>'
EndIf
	
If Alltrim(SM0->M0_CODMUN) $ "3168705-3305505" // Timoteo-MG # Saquarema-RJ
	If !Empty(cMVREGIESP)
		cString += '<RegimeEspecialTributacao>'+cMVREGIESP+'</RegimeEspecialTributacao>'
	EndIf	
	cString += '<OptanteSimplesNacional>'+cMVOPTSIMP+'</OptanteSimplesNacional>'
	cString += '<IncentivadorCultural>'+cMVINCECUL+'</IncentivadorCultural>'
	If Alltrim(SM0->M0_CODMUN) == "3305505"  //Saquarema-RJ
		cString += '<Status>'+"1"+'</Status>'
	EndIf
EndIf	

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

nScan := aScan(aRetido,{|x| x[1] == "ISSQN"})
If nScan > 0
	aISSXml[1] := aRetido[nScan][3] //Valor ISS
	aISSXml[2] += aRetido[nScan][2] //Base ISS
EndIf

cString += '<DescricaoRPS>'+cMensCli+Space(1)+cMensFis+'</DescricaoRPS>'
cString += '<DDDTomador>'+AllTrim(Str(Val(SubsTr(aDest[13],1,3))))+'</DDDTomador>'
cString += '<TelefoneTomador>'+AllTrim(Str(Val(SubsTr(aDest[13],4,15))))+'</TelefoneTomador>'
cString += '<MotCancelamento>'+cMotCanc+'</MotCancelamento>'    
//Inserida a mesma informação da tag <DescricaoRPS>, pois alguns municipios utiilizam a TAG Observacao, para levar a informacao.
cString += '<Observacao>'+cMensCli+Space(1)+cMensFis+'</Observacao>'

//Outras retenções, sera colocado o valor 0 (zero), pois atualmente nao existe valor de Outras retencoes 
If Len(aRetido)>0     
	nOutRet    := 	SF3->F3_ISSMAT
EndIf

cString += '<ValorISS>'+ConvType(aISSXml[1],15,2)+'</ValorISS>'
cString += '<ISSRetido>'+ConvType(aIssRet[1],15,2)+'</ISSRetido>'
cString += '<OutrasRetencoes>'+ConvType(nOutRet,15,2)+'</OutrasRetencoes>'
cString += '<ValorPIS>'+ConvType(aPisXml[1],15,2)+'</ValorPIS>'
cString += '<ValorCOFINS>'+ConvType(aCofinsXml[1],15,2)+'</ValorCOFINS>'
cString += '<ValorINSS>'+ConvType(aInssXml[1],15,2)+'</ValorINSS>'
cString += '<ValorIR>'+ConvType(aIRRFXml[1],15,2)+'</ValorIR>'
cString += '<ValorCSLL>'+ConvType(aCSLLXml[1],15,2)+'</ValorCSLL>'
cString += '<AliquotaISS>'+ConvType((Iif(!Empty(aISSQN[1][02]),aISSQN[1][02],aIssRet[3])/100),15,4)+'</AliquotaISS>'
cString += '<AliquotaPIS>'+ConvType(aPisXml[2],15,4)+'</AliquotaPIS>'
cString += '<AliquotaCOFINS>'+ConvType(aCofinsXml[2],15,4)+'</AliquotaCOFINS>'
cString += '<AliquotaINSS>'+ConvType(aInssXml[2],15,4)+'</AliquotaINSS>'
cString += '<AliquotaIR>'+ConvType(aIrrfXml[2],15,4)+'</AliquotaIR>'
cString += '<AliquotaCSLL>'+ConvType(aCSLLXml[2],15,4)+'</AliquotaCSLL>'

//A operação J-Intermediação é utilizada apenas na prefeitura de Campo Grande, nas demais
//prefeituras não deve ser utilizada. Quando informado o tipo de operação J-Intermediação deve se
//informar o CPF/CNPJ do Intermediário

If cCodMun == "5002704" .And. cString $ '<Tributacao>J</Tributacao>'
	cString += '<CpfCnpjIntermediario>'+'00000000000191'+'</CpfCnpjIntermediario>'
EndIf
 
atel:= FisGetTel(aDest[13])

//ITAJUBA

For Nx := 1 to Len(aProd)

	//nBaseIss := (aProd[Nx][10] * aProd[Nx][09]) - aProd[Nx][15] - aProd[Nx][21] - aProd[Nx][22]
	nBaseIss := aProd[Nx][25]	
	//Valor Líquido, foi retirado o "nOutRet" do Valor Liquido, pois atualmente nao existe valor de Outras retencoes
	nValLiq    := (aProd[Nx][27]) - aPisXml[1] - aCofinsXml[1]  - aInssXml[1] - aIRRFXml[1] - aCSLLXml[1] - aIssRet[1]  

	cXml += '<Item>'
	cXml += '<DiscriminacaoServico>'+ConvType(aProd[Nx][04],120)+'</DiscriminacaoServico>'
	cXml += '<Quantidade>'+AllTrim(Str(aProd[Nx][09]))+'</Quantidade>'
	If cCodMun $ "3201308"
		cXml += '<UnidMedida>'+Alltrim(aProd[Nx][08])+'</UnidMedida>'
	EndIF
	If Ccodmun <> "4205407"
		cXml += '<Aliquota>'+AllTrim(Str(aProd[Nx][24]))+'</Aliquota>'	
	Else
		cXml += '<Aliquota>'+AllTrim(Str(aProd[Nx][24]/100))+'</Aliquota>'			
	EndIf
	cXml += '<ValorISS>'+AllTrim(ConvType(aProd[Nx][25],15,2))+'</ValorISS>'	
	cXml += '<ValorUnitario>'+AllTrim(ConvType(aProd[Nx][10],15,2))+'</ValorUnitario>'
	cXml += '<ValorTotal>'+AllTrim(ConvType((aProd[Nx][10] * aProd[Nx][09]),15,2))+'</ValorTotal>'
	If !cCodMun $"4205407-3132404"
		cXml += '<ItemListaServico>'+AllTrim(aProd[Nx][23])+'</ItemListaServico>'
	Else
		cXml += '<ItemListaServico>'+AllTrim(aProd[Nx][19])+'</ItemListaServico>'	
	EndIf
	If Alltrim(SM0->M0_CODMUN) $ "2607208-3550308-3304557" //IPOJUCA - PE # Sao Paulo - SP  # Rio de Janeiro - RJ
		cXml += '<ISSRetido>'+AllTrim(aProd[Nx][20])+'</ISSRetido>'
	ElseIf Alltrim(SM0->M0_CODMUN) $ "3168705-3305505-3152501"  // Timoteo-MG # Saquarema-RJ # Pouso Alegre
		cXml += '<ISSRetido>'+Iif(!Empty(aIssRet[2]),"1","2")+'</ISSRetido>' 
	Else
		cXml += '<ISSRetido>0</ISSRetido>'  //Alterar
	EndIf 
	
	If ( Len(aProd[Nx]) >= 25 ) .And. aIssRet[1] > 0
		cXml += '<ValorISSRetido>'+AllTrim(ConvType(aProd[Nx][25],15,2))+'</ValorISSRetido>'
	EndIf
	
	cXml += '<ValorIR>'+ConvType(aIRRFXml[1],15,2)+'</ValorIR>'
	cXml += '<ValorPIS>'+ConvType(aPisXml[1],15,2)+'</ValorPIS>'
	cXml += '<ValorCOFINS>'+ConvType(aCofinsXml[1],15,2)+'</ValorCOFINS>'
	cXml += '<ValorINSS>'+ConvType(aInssXml[1],15,2)+'</ValorINSS>'
	cXml += '<ValorCSLL>'+ConvType(aCSLLXml[1],15,2)+'</ValorCSLL>'
	cXml +=	'<BaseCalculo>'+AllTrim(ConvType(aProd[Nx][26],15,2))+'</BaseCalculo>'
	cXml += '<ValorDeducoes>'+AllTrim(ConvType(aProd[Nx][22],15,2))+'</ValorDeducoes>' 
	cXml += '<OutrasRetencoes>0</OutrasRetencoes>'
	cXml += '<CodigoTribMunic>'+Alltrim(ConvType(aProd[Nx][32],20))+'</CodigoTribMunic>'	
	cXml += '<CFPS>'+Alltrim(aProd[Nx][33])+'</CFPS>
	cXml += '<CST>'+Alltrim(aCST[Nx][2])+'</CST>
	cXml += '<IdCNAE>'+Alltrim(aProd[Nx][32])+'</IdCNAE>'
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
cString += cDeduz
cString += '</Deducoes>'

cString += '<Itens>'                  
cString += cXml
cString += '</Itens>'       

Return(cString)

//Informações do Prestador
Static Function NFSEPrest(cCodMun,aPrest)

Local cString    	:= ""
Local cImPrestador	:= aPrest[17]

cImPrestador := StrTran(cImPrestador,"-","")
cImPrestador := StrTran(cImPrestador,"/","")

If Alltrim(SM0->M0_CODMUN) <> "3305505"
	cString += '<InscricaoMunicipalPrestador>'+StrZero(val(cImPrestador),8)+'</InscricaoMunicipalPrestador>'
Else
    cString += '<InscricaoMunicipalPrestador>'+cImPrestador+'</InscricaoMunicipalPrestador>'
EndIf
cString += '<CpfCnpjPrestador>'+Alltrim(aPrest[1])+'</CpfCnpjPrestador>'
cString += '<RazaoSocialPrestador>'+aPrest[2]+'</RazaoSocialPrestador>'                         
cString += '<DDDPrestador>'+AllTrim(Str(FisGetTel(aPrest[13])[2],3))+'</DDDPrestador>'
cString += '<TelefonePrestador>'+AllTrim(Str(FisGetTel(aPrest[13])[3],15))+'</TelefonePrestador>'
cString += '<TipoLogradouroPrestador>Rua</TipoLogradouroPrestador>'
cString += '<LogradouroPrestador>'+aPrest[03]+'</LogradouroPrestador>'
cString += '<NumeroEnderecoPrestador>'+aPrest[04]+'</NumeroEnderecoPrestador>
cString += '<ComplementoEnderecoPrestador>'+aPrest[05]+'</ComplementoEnderecoPrestador>
cString += '<BairroPrestador>'+aPrest[06]+'</BairroPrestador>
cString += '<CidadePrestadorDescricao>'+aPrest[08]+'</CidadePrestadorDescricao>
cString += '<CidadePrestador>'+aPrest[07]+'</CidadePrestador>
cString += '<UFPrestador>'+aPrest[09]+'</UFPrestador>
cString += '<CEPPrestador>'+aPrest[10]+'</CEPPrestador>
cString += '<EmailPrestador>'+aPrest[16]+'</EmailPrestador>

Return(cString)

//Informações do Endereço da Prestação do Serviço
Static Function NFSEMunPre(cCodMun,aEndPrest,cTipo)

Local cString  	:= ""

If cTipo == "1"
	If !Empty(aEndPrest[5]) 
		cString += '<EnderecoPrestacao>'+aEndPrest[1]+'</EnderecoPrestacao>'
		cString += '<NumeroPrestacao>'+aEndPrest[2]+'</NumeroPrestacao>'
		cString += '<ComplementoPrestacao>'+aEndPrest[3]+'</ComplementoPrestacao>'
		cString += '<BairroPrestacao>'+aEndPrest[4]+'</BairroPrestacao>'
		cString += '<CidadePrestacao>'+aEndPrest[5]+'</CidadePrestacao>'
		cString += '<UFPrestacao>'+aEndPrest[7]+'</UFPrestacao>'
		cString += '<CEPPrestacao>'+aEndPrest[6]+'</CEPPrestacao>'
	EndIf
EndIf
	
Return( cString )
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




Static Function NFSETag(cTag,cConteudo)   
  

Local cRetorno := ""

If (!Empty(AllTrim(cConteudo)) .And. IsAlpha(AllTrim(cConteudo))) .Or. Val(AllTrim(cConteudo))<>0
	cRetorno := cTag+AllTrim(cConteudo)+SubStr(cTag,1,1)+"/"+SubStr(cTag,2)
ElseIf Empty(AllTrim(cConteudo))
	cRetorno := cTag+AllTrim(cConteudo)+SubStr(cTag,1,1)+"/"+SubStr(cTag,2)
EndIf

Return(cRetorno)




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
                            



Static FUNCTION NoAcento(cString)
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
Static Function MyGetEnd(cEndereco,cAlias)

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


//-------------------------------------------------------------------
/*/{Protheus.doc} GetPresEnd
Função que monta as informações de onde será prestado o serviço

@author Eduardo Silva             
@since 27/04/2012
@version 1.0
                                   
@param	aDest		Dados do destinatário


@return	aEndPres	Array com as informações de onde será prestado o serviço
/*/
//-------------------------------------------------------------------
Static Function GetPresEnd( aDest )      

Local aMvEndPres	:= &(SuperGetMV("MV_ENDPRES",,"{}"))
Local aMvEndSer		:= &(SuperGetMV("MV_ENDSER",, "{}"))  
Local aEndPres		:= {}
Local cEndPres		:= ""


If Len(aMvEndPres) > 0 .And. !Empty(aMvEndPres[1]) .And. SC5->(FieldPos("C5_MUNPRES")) > 0
	aAdd(aEndPres, IIF(!Empty(FisGetEnd(aMvEndPres[1])[1]), FisGetEnd(aMvEndPres[1])[1], aDest[3] ))
	aAdd(aEndPres, ConvType(IIF(FisGetEnd(aMvEndPres[1])[2]<>0, FisGetEnd(aMvEndPres[1])[2], aDest[4] )))
	aAdd(aEndPres, IIF(!Empty(aMvEndPres[2]),aMvEndPres[2], aDest[5] ))
	aAdd(aEndPres, IIF(!Empty(aMvEndPres[3]),aMvEndPres[3], aDest[6] ))
	aAdd(aEndPres, IIF(!Empty(aMvEndPres[4]),aMvEndPres[4], aDest[8] ))
	aAdd(aEndPres, IIF(!Empty(aMvEndPres[6]),aMvEndPres[5], aDest[10]))
	aAdd(aEndPres, IIF(!Empty(aMvEndPres[5]),aMvEndPres[6], aDest[9] ))

ElseIf Len(aMvEndPres) > 0  .And. Empty(aMvEndPres[1]) .And. SC5->(FieldPos("C5_MUNPRES")) > 0 .And. !Empty(SC5->C5_MUNPRES)
	aAdd(aEndPres,IIF ( !Empty(FisGetEnd(SC5->C5_ENDPRES)[1] ), FisGetEnd(SC5->C5_ENDPRES)[1], aDest[3] ))
	aAdd(aEndPres,ConvType (IIF(FisGetEnd(SC5->C5_ENDPRES)[2]<> 0, FisGetEnd(SC5->C5_ENDPRES)[2], aDest[4] )))  	
	aAdd(aEndPres,IIF ( !Empty(SC5->C5_COMPRES), SC5->C5_COMPRES, aDest[5] ))
	aAdd(aEndPres,IIF ( !Empty(SC5->C5_BAIPRES), SC5->C5_BAIPRES, aDest[6] ))
	aAdd(aEndPres,IIF ( !Empty(SC5->C5_MUNPRES), SC5->C5_MUNPRES, aDest[8] ))		
	aAdd(aEndPres,IIF ( !Empty(SC5->C5_CEPPRES), SC5->C5_CEPPRES, aDest[10]))
	aAdd(aEndPres,IIF ( !Empty(SC5->C5_ESTPRES), SC5->C5_ESTPRES, aDest[9] ))
	
ElseIf Len(aMvEndSer) > 0 .And. !Empty(aMvEndSer[1]) .And.  SC5->(FieldPos("C5_MUNPRES")) > 0 .And. Empty(SC5->C5_MUNPRES)
	aAdd(aEndPres,IIF(!Empty(FisGetEnd(aMvEndSer[1])[1]), FisGetEnd(aMvEndSer[1])[1], aDest[3] ))
	aAdd(aEndPres, ConvType(IIF(FisGetEnd(aMvEndSer[1])[2]<>0, FisGetEnd(aMvEndSer[1])[2], aDest[4] )))
	aAdd(aEndPres, IIF(!Empty(aMvEndSer[2]),aMvEndSer[2], aDest[5] ))
	aAdd(aEndPres, IIF(!Empty(aMvEndSer[3]),aMvEndSer[3], aDest[6] ))
	aAdd(aEndPres, IIF(!Empty(aMvEndSer[4]),aMvEndSer[4], aDest[8] ))
	aAdd(aEndPres, IIF(!Empty(aMvEndSer[5]),aMvEndSer[5], aDest[10]))
	aAdd(aEndPres, IIF(!Empty(aMvEndSer[6]),aMvEndSer[6], aDest[9] ))

ElseIf Len(aMvEndPres) > 0 .And. Empty(aMvEndSer[1]) .And. SC5->(FieldPos("C5_MUNPRES")) > 0 .And. !Empty(SC5->C5_MUNPRES)
	aAdd(aEndPres,IIF ( !Empty(FisGetEnd(SA1->A1_END)[1] ), FisGetEnd(SA1->A1_END)[1], aDest[3] ))
	aAdd(aEndPres,ConvType (IIF(FisGetEnd(SA1->A1_END)[2]<> 0, FisGetEnd(SA1->A1_END)[2], aDest[4] )))  	
	aAdd(aEndPres,IIF ( !Empty(SA1->A1_COMPLEM), SA1->A1_COMPLEM, 	aDest[5] ))
	aAdd(aEndPres,IIF ( !Empty(SA1->A1_BAIRRO),  SA1->A1_BAIRRO, 	aDest[6] ))
	aAdd(aEndPres,IIF ( !Empty(SA1->A1_MUN), 	  SA1->A1_MUN, 		aDest[8] ))		
	aAdd(aEndPres,IIF ( !Empty(SA1->A1_CEP), 	  SA1->A1_CEP, 		aDest[10]))
	aAdd(aEndPres,IIF ( !Empty(SA1->A1_EST),     SA1->A1_EST, 		aDest[9] ))

Else
	aEndPres:= {"","","","","","",""}
EndIf

Return (aEndPres)
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

#include "RwMake.ch"
#include "RGPER02.ch"
#INCLUDE "PROTHEUS.CH"

/*

±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programador  ³ Data     ³ FNC            ³  Motivo da Alteracao                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³±±
±±³Tatiane V. M.³25/08/2009³00000020388/2009³Compatibilizacao dos fontes para aumento do³±±
±±³             ³          ³                ³campo filial e gestão corporativa.         ³±±
±±³Francisco Jr.³05/11/2009³00000026616/2009³Compatibilizacao dos fontes para aumento do³±±
±±³             ³          ³                ³campo filial e gestão corporativa.         ³±± 
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RGPER02   ºAutor  ³Silvia Taguti       º Data ³  23/11/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Hace la impresion de los libros de sueldos y jornales       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION RGPER02()

Local cString := "SRA"  // alias do arquivo principal (Base)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Private(Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private NomeProg := "RGPER02"
Private cPerg    := "RGPR02"
Private Titulo
Private aCodFol:= {}
Private cPict1	:= TM(9999999999,16,MsDecimais(1))


pergunte("RGPR02",.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01        //  Filial De                                ³
//³ mv_par02        //  Filial Ate                               ³
//³ mv_par03        //  Centro de Custo De                       ³
//³ mv_par04        //  Centro de Custo Ate                      ³
//³ mv_par05        //  Matricula De                             ³
//³ mv_par06        //  Matricula Ate                            ³
//³ mv_par07        //  Nome De                                  ³
//³ mv_par08        //  Nome Ate                                 ³
//³ mv_par09        //  Chapa De                                 ³
//³ mv_par10        //  Chapa Ate                                ³
//³ mv_par11        //  Situa‡äes                                ³
//³ mv_par12        //  Categorias                               ³
//³ mv_par13        //  Data Referencia                          ³
//³ mv_par14        //  Ordem                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   

wnrel:="RGPER02"            //Nome Default do relatorio em Disco

RptStatus({|lEnd| GR02Imp(@lEnd,wnRel,cString)},Titulo)

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GR02IMP   ºAutor  ³Silvia Taguti       º Data ³  23/11/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatorio                                                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GR02IMP(lEnd,WnRel,cString)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Locais (Programa)                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nLin      := 0
Local aDados    := {}
Local cNome
Local cFPag
Local cFormaPag
Local nImpUnit  := 0
Local nDiasTrab := 0
Local nHorasTrab:= 0
Local nImporte  := 0
Local nExtra50  := 0
Local nExtra100 := 0
Local nExtraImp := 0
Local nVacacion := 0
Local nBonif    := 0
Local nAguinaldo:= 0
Local nOtBenef  := 0
Local nTotGeral := 0
Local cSemesRef := " "
Local cSemesDem := " "
Local cAnoRef:= cAnoAdm:= cAnoDem := "    "
Local cMesIni,cMesFim                      
Local nDias  := 0
Local nHoras := 0
Local aInfo
Private	aDescFil := {}

cFilDe     := mv_par01
cFilAte    := mv_par02
cCcDe      := mv_par03
cCcAte     := mv_par04
cMatDe     := mv_par05
cMatAte    := mv_par06
cNomeDe    := mv_par07
cNomeAte   := mv_par08
cChapaDe   := mv_par09
cChapaAte  := mv_par10
cSituacao  := mv_par11
cCategoria := mv_par12
dDataref   := mv_par13
nOrdem     := mv_par14

dbSelectArea( "SRA" )
If nOrdem == 1
	dbSetOrder( 1 )
ElseIf nOrdem == 2
	dbSetOrder( 2 )
ElseIf nOrdem == 3
	dbSetOrder(3)
Endif

dbGoTop()

If nOrdem == 1
	dbSeek(cFilDe + cMatDe,.T.)
	cInicio := "SRA->RA_FILIAL + SRA->RA_MAT"
	cFim    := cFilAte + cMatAte
ElseIf nOrdem == 2
	dbSeek(cFilDe + cCcDe + cMatDe,.T.)
	cInicio := "SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_MAT"
	cFim    := cFilAte + cCcAte + cMatAte
ElseIf nOrdem == 3
	DbSeek(cFilDe + cNomeDe + cMatDe,.T.)
	cInicio := "SRA->RA_FILIAL + SRA->RA_NOME + SRA->RA_MAT"
	cFim    := cFilAte + cNomeAte + cMatAte
Endif

dbSelectArea( "SRA" )
SetRegua(SRA->(RecCount()))

cFilialAnt := Space(FWGETTAMFILIAL)
cFuncaoAnt := "    "
cCcAnt     := Space(9)
cMatAnt    := Space(6)

If Month(dDataRef)< 6
   cSemesRef := "1"
Else
   cSemesRef := "2"
Endif
cAnoRef := Alltrim(Str(Year(dDataRef)))

dbSelectArea("SRA")

While !EOF() .And. &cInicio <= cFim .And.(SRA->RA_FILIAL+SRA->RA_MAT <> cFilialAnt+cMatAnt)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Movimenta Regua Processamento                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  	IncRegua()  // Anda a regua
    If lEnd
		@Prow()+1,0 PSAY cCancel
		Exit
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste Parametrizacao do Intervalo de Impressao            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (SRA->RA_CHAPA < cChapaDe).Or. (SRA->Ra_CHAPa > cChapaAte).Or. ;
	   (SRA->RA_NOME < cNomeDe)  .Or. (SRA->Ra_NOME > cNomeAte)  .Or. ;
	   (SRA->RA_MAT < cMatDe)    .Or. (SRA->Ra_MAT > cMatAte)    .Or. ;
	   (SRA->RA_CC < cCcDe)      .Or. (SRA->Ra_CC > cCcAte)
		SRA->(dbSkip(1))
		Loop
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o tipo de Afastamento ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cTipAfas := " "
	dDtAfas  := dDtRet := ctod("")
	fChkAfas(SRA->RA_FILIAL,SRA->RA_MAT,dDataRef,@dDtAfas,@dDtRet,@cTipAfas)
	If cTipAfas $"OPQRXY"
		cTipAfas := "A"
	ElseiF cTipAfas $"HIJKLMNSUV" .Or.;
		(!Empty(SRA->RA_DEMISSA) .And. MesAno(dDataRef) >= MesAno(SRA->RA_DEMISSA))
		cTipAfas := "D"
	ElseIf cTipAfas == "F"
		cTipAfas := "F"
	Else
		cTipAfas := " "
	EndIf

	If MesAno(dDtAfas) > MesAno(dDataRef)
		cTipAfas := " "
	EndIf

	If cTipAFas $ "D" .And. Mesano(SRA->RA_DEMISSA) # Mesano(dDataRef)
		dbSkip()
		Loop
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste situacao e categoria dos funcionarios			     |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !( SRA->RA_SITFOLH $ cSituacao ) .OR. !( SRA->RA_CATFUNC $ cCategoria )
	   dbSkip()
	   Loop
	Endif

	If SRA->RA_FILIAL # cFilialAnt
		If ! Fp_CodFol(@aCodFol,Sra->Ra_Filial)
	       Exit
	   Endif
    	If ! fInfo(@aInfo,SRA->RA_FILIAL)
			Exit
		Endif
		AADD(aDescFil,{SRA->RA_FILIAL,aInfo[3],aInfo[4]})
		// Nome Completo
		// Endereco Cobranca
	   dbSelectArea( "SRA" )
	   cFilialAnt := SRA->RA_FILIAL
	Endif

	If SRA->RA_CODFUNC # cFuncaoAnt           // Descricao da Funcao
		DescFun(Sra->Ra_Codfunc,Sra->Ra_Filial)
		cFuncaoAnt:= Sra->Ra_CodFunc
	Endif

	If SRA->RA_CC # cCcAnt                   // Centro de Custo
		DescCC(Sra->Ra_Cc,Sra->Ra_Filial)
		cCcAnt:=SRA->RA_CC
	Endif

	cNome     := SRA->RA_NOME
 	cFPag := fDesc("SX5","28"+SRA->RA_CATFUNC,"Substr(X5DESCRI(),1,9)")
  	nImpUnit  := SRA->RA_SALARIO
    
	dbSelectArea("SRD")
 	If dbSeek(SRA->RA_FILIAL + SRA->RA_MAT )
	 	While !Eof() .And. (SRA->RA_FILIAL+SRA->RA_MAT == SRD->RD_FILIAL+SRD->RD_MAT)
   		If (SRD->RD_DATARQ == MesAno(dDataRef)) .or. (SRD->RD_MES == "13" .And. (MONTH(dDataRef)= 12 .And. (LEFT(SRD->RD_DATARQ,4) == StrZero(YEAR(dDataRef),4))))
     			If SRA->RA_CATFUNC $ "M*C*D" .And. SRA->RA_TIPOPGT = "M" .And. SRD->RD_PD == aCodFol[031,1]
		      	nImporte  := SRD->RD_VALOR
		         If SRD->RD_HORAS == 30
		         	LocGHabRea(Ctod("01/"+SubStr(DTOC(dDataRef),4)),Ctod(StrZero(F_ULTDIA(dDataRef),2)+"/"+Substr(dtoc(dDataRef),4,5),"ddmmyy"),@nDias,,,@nHoras)
			     	ElseIf SRD->RD_HORAS < 30
			        	dBSelectArea("SR8")
			        	If dbSeek(SRA->RA_FILIAL + SRA->RA_MAT+MesAno(dDataRef))
			           	LocDiaHora(Ctod("01/"+SubStr(DTOC(dDataRef),4)),Ctod(StrZero(F_ULTDIA(dDataRef),2)+"/"+Substr(dtoc(dDataRef),4,5),"ddmmyy"),SR8->R8_DATAINI,SR8->R8_DATAFIM,@nDias,@nHoras)
			    		Else
		       			IF YEAR(SRA->RA_ADMISSAO)==YEAR(dDataRef).AND.MONTH(SRA->RA_ADMISSAO)==MONTH(dDataRef).AND.DAY(SRA->RA_ADMISSAO) # 1
 								LocGHabRea(SRA->RA_ADMISSAO,Ctod(StrZero(F_ULTDIA(dDataRef),2)+"/"+Substr(dtoc(dDataRef),4,5),"ddmmyy"),@nDias,,,@nHoras)
			            Endif
			         Endif
			  		Endif
			    	If nDias == 0 .and. SRD->RD_HORAS <> 0
			        	nDias := SRD->RD_HORAS
			     	Endif
			     	nDiasTrab	:= nDias                                                                                                                         
			     	nHorasTrab := nHoras
			  		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 			  		//³ Pro-Labore                                                   ³
			  		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 			  	Elseif SRA->RA_CATFUNC $ "P" .And. SRA->RA_TIPOPGT = "M" .And. SRD->RD_PD == aCodFol[217,1]
		     		nImporte  := SRD->RD_VALOR
			     	nDiasTrab	:= SRD->RD_HORAS
			  		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	 		  		//³ Autonomo                                                     ³
			  		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			  	Elseif SRA->RA_CATFUNC $ "A" .And. SRA->RA_TIPOPGT = "M" .And.SRD->RD_PD == aCodFol[218,1]
		    		nImporte  := SRD->RD_VALOR
		         nDiasTrab	:= SRD->RD_HORAS
		    		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			  		//³ Estagiario Mensalista                                        ³
			  		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			  	Elseif SRA->RA_CATFUNC $ "E" .And. SRA->RA_TIPOPGT = "M" .And. SRD->RD_PD ==aCodFol[219,1]
			     	nImporte  := SRD->RD_VALOR
		         nDiasTrab	:= SRD->RD_HORAS
		      	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		      	//³ Salario Horista + DSR                                        ³
      		  	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		    	Elseif SRA->RA_CATFUNC $ "H" .And. SRA->RA_TIPOPGT = "M" .And. SRD->RD_PD == aCodfol[32,1]
			     	nImporte  := SRD->RD_VALOR
			     	If (SRD->RD_HORAS / 8) == 30
		       		LocGHabRea(Ctod("01/"+SubStr(DTOC(dDataRef),4)),Ctod(StrZero(F_ULTDIA(dDataRef),2)+"/"+Substr(dtoc(dDataRef),4,5),"ddmmyy"),@nDias,,,@nHoras)
			    	ElseIf (SRD->RD_HORAS /8) < 30
			     		dBSelectArea("SR8")
			       	If dbSeek(SRA->RA_FILIAL + SRA->RA_MAT+MesAno(dDataRef))
			           	LocDiaHora(Ctod("01/"+SubStr(DTOC(dDataRef),4)),Ctod(StrZero(F_ULTDIA(dDataRef),2)+"/"+Substr(dtoc(dDataRef),4,5),"ddmmyy"),SR8->R8_DATAINI,SR8->R8_DATAFIM,@nDias,@nHoras)
			    		Else
		       			IF YEAR(SRA->RA_ADMISSAO)==YEAR(dDataRef).AND.MONTH(SRA->RA_ADMISSAO)==MONTH(dDataRef).AND.DAY(SRA->RA_ADMISSAO) # 1
 								LocGHabRea(SRA->RA_ADMISSAO,Ctod(StrZero(F_ULTDIA(dDataRef),2)+"/"+Substr(dtoc(dDataRef),4,5),"ddmmyy"),@nDias,,,@nHoras)
			            Endif
			         Endif
			      Endif
					If nDias == 0 .and. SRD->RD_HORAS <> 0
			        	nDias := SRD->RD_HORAS
			     	Endif
			     	nDiasTrab	:= nDias                                                                                                                         
			     	nHorasTrab := nHoras
			  		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      		  	//³ Estagiario Horista                                           ³
		      	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			  	Elseif SRA->RA_CATFUNC $ "G" .And. SRA->RA_TIPOPGT = "M" .And. SRD->RD_PD == aCodfol[220,1]
			     	nImporte  := SRD->RD_VALOR
		         nDiasTrab	:= SRD->RD_HORAS
			  		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			  		//³ Salario Horista                                              ³
			  		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				ElseIf SRA->RA_CATFUNC $ "H" .And. SRA->RA_TIPOPGT = "M" .And. SRD->RD_PD == aCodfol[32,1] .or. SRD->RD_PD == aCodfol[33,1]
			     	nImporte  := SRD->RD_VALOR
					If (SRD->RD_HORAS / 8 ) == 30
		            LocGHabRea(Ctod("01/"+SubStr(DTOC(dDataRef),4)),Ctod(StrZero(F_ULTDIA(dDataRef),2)+"/"+Substr(dtoc(dDataRef),4,5),"ddmmyy"),@nDias,,,@nHoras)
			     	ElseIf (SRD->RD_HORAS /8) < 30
			      	dBSelectArea("SR8")
			        	If dbSeek(SRA->RA_FILIAL + SRA->RA_MAT+MesAno(dDataRef))
			           	LocDiaHora(Ctod("01/"+SubStr(DTOC(dDataRef),4)),Ctod(StrZero(F_ULTDIA(dDataRef),2)+"/"+Substr(dtoc(dDataRef),4,5),"ddmmyy"),SR8->R8_DATAINI,SR8->R8_DATAFIM,@nDias,@nHoras)
			    		Else
		       			IF YEAR(SRA->RA_ADMISSAO)==YEAR(dDataRef).AND.MONTH(SRA->RA_ADMISSAO)==MONTH(dDataRef).AND.DAY(SRA->RA_ADMISSAO) # 1
 								LocGHabRea(SRA->RA_ADMISSAO,Ctod(StrZero(F_ULTDIA(dDataRef),2)+"/"+Substr(dtoc(dDataRef),4,5),"ddmmyy"),@nDias,,,@nHoras)
			            Endif
			         Endif
			  		Endif
					If nDias == 0 .and. SRD->RD_HORAS <> 0
			        	nDias := SRD->RD_HORAS
			     	Endif
			     	nDiasTrab	:= nDias                                                                                                                         
			     	nHorasTrab := nHoras	
		   	EndIf

			  	If SRD->RD_PD == "201"
			     	nExtra50  := SRD->RD_HORAS
			     	nExtraImp += SRD->RD_VALOR
				Endif

			  	If SRD->RD_PD == "202"
			   	nExtra100  := SRD->RD_HORAS
			     	nExtraImp += SRD->RD_VALOR
				Endif

			  	If SRD->RD_PD $ aCodFol[072,1]+"|"+aCodFol[224,1]+"|"+aCodFol[087,1]
			     	nVacacion += SRD->RD_VALOR  //Ferias vencidas/proporc/dobro
				Endif

				If SRD->RD_PD $ aCodFol[34,1]          //Salario Familia
 					nBonif += SRD->RD_VALOR
 				Endif

 			  	If SRD->RD_PD $ aCodFol[22,1]+"|"+aCodFol[24,1]  //Aguinaldo
 			     	nAguinaldo+= SRD->RD_VALOR
 			  	Endif

 			  	If SRD->RD_PD $ aCodFol[110,1]+"|"+aCodFol[111,1]  //Indeniz.pre aviso
 			     	nOtBenef += SRD->RD_VALOR
 			  	Endif

 			  	nTotGeral := nImporte+nExtraImp+nVacacion+nBonif+nAguinaldo+nOtBenef

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			   //³Carrega Dados do Funcionario no Array³
			   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      		dbSelectArea("SRD")
			Endif	    
   		dbSkip()
   	Enddo
	Endif
   AaDD(aDados,{GetFilxCC(SRA->RA_CC),cNome,cFPag,alltrim(str(nImpUnit)),;
   	alltrim(str(nDiasTrab)),alltrim(str(nHorasTrab)),alltrim(str(nImporte)),;
    	alltrim(str(nExtra50)),alltrim(str(nExtra100)),alltrim(str(nExtraImp)),;
     	alltrim(str(nVacacion)),alltrim(str(nBonif)),alltrim(str(nAguinaldo)),;
      alltrim(str(nOtBenef)),alltrim(str(nTotGeral))})

	nImpUnit := nDiasTrab := nHorasTrab := nImporte := nExtra50 := nExtra100 := 0
 	nExtraImp := nVacacion := nBonif := nAguinaldo := nOtBenef := nTotGeral:=0
 	nDias := 0
  	dbSelectArea("SRA")
	dbSkip()
Enddo
aSort(aDados,,,{|x,y| x[1] < y[1] })

Libro(aDados,dDataRef)  	// Funcao que monta o cabecalho

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Libro     ºAutor  ³Silvia Taguti       º Data ³  23/11/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Impressao do Relatorio                                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Libro(aDados,dDataREf)
Local nX, nY, nLinDet, nTamLin
Local aColunas := {}
Local nSoma1:=nSoma2:=nSoma3:=nSoma4:=nSoma5:=nSoma6:=nSoma7:=nSoma8:=0
Local nNumero := 0
Private cFilQueb
// Crea los objetos con las configuraciones de fuentes
oFont08  := TFont():New( "Times New Roman",,08,,.f.,,,,,.f. )
oFont08b := TFont():New( "Times New Roman",,08,,.t.,,,,,.f. )
oFont10  := TFont():New( "Times New Roman",,10,,.f.,,,,,.f. )
oFont10b := TFont():New( "Times New Roman",,10,,.t.,,,,,.f. )
oFont11  := TFont():New( "Times New Roman",,11,,.f.,,,,,.f. )
oFont11b := TFont():New( "Times New Roman",,11,,.t.,,,,,.f. )
oFont12  := TFont():New( "Times New Roman",,12,,.f.,,,,,.f. )
oFont24b := TFont():New( "Times New Roman",,24,,.t.,,,,,.f. )


// Crea un nuevo objeto para impresion
oPrn := TMSPrinter():New()

// Inicia un nueva pagina
oPrn:StartPage()

// Imprime la inicializacon de la impresora
oPrn:Say(20,20," ",oFont12,100)

aColunas := {0,310,1105,1320,1610,1770,1930,2210,2310,2420,2630,2870,3110,3350,3630}
nLinTot := 1
nLinDet := 3500
nTamLin := 55
cFilQueb := Space(FWGETTAMFILIAL)

For nX := nLinTot to Len(aDados)
	If cFilQueb <> aDados[nX][1] .and. cFilQueb <> Space(FWGETTAMFILIAL)
		cFilQueb := aDados[nX][1] 
		nNumero := 0
    	oPrn:Say(nLinDet,1300,Transform(nSoma1,cPict1),oFont11,50)
     	oPrn:Say(nLinDet,1900,Transform(nSoma2,cPict1),oFont11,50)
		oPrn:Say(nLinDet,2420,Transform(nSoma3,cPict1),oFont11,50)
		oPrn:Say(nLinDet,2620,Transform(nSoma4,cPict1),oFont11,50)
		oPrn:Say(nLinDet,2860,Transform(nSoma5,cPict1),oFont11,50)
		oPrn:Say(nLinDet,3110,Transform(nSoma6,cPict1),oFont11,50)
		oPrn:Say(nLinDet,3340,Transform(nSoma7,cPict1),oFont11,50)
		oPrn:Say(nLinDet,3600,Transform(nSoma8,cPict1),oFont11,50)
  		oPrn:EndPage()
	   nLinDet := 3090                                                    
	   nSoma1:=nSoma2:=nSoma3:=nSoma4:=nSoma5:=nSoma6:=nSoma7:=nSoma8:=0
  	Endif
   If nLinDet > 3080
   	// Inicia un nueva pagina
    	oPrn:StartPage()
     	// Imprime la inicializacon de la impresora
      oPrn:Say(20,20," ",oFont12,100)
  		cFilQueb := aDados[nX][1]

      Cabec(dDataRef)
      nLinDet := 560
      If nSoma1 > 0 .or. nSoma2 > 0 .or. nSoma3 > 0 .or. nSoma4 > 0 .or. nSoma5 > 0;
      	.or. nSoma6 > 0 .or. nSoma7 > 0 .or. nSoma8 > 0
       	oPrn:Say(nLinDet,320,OemToAnsi(STR0039),oFont11b,50) //  Transporte
        	oPrn:Say(nLinDet,1300,Transform(nSoma1,cPict1),oFont11,50)
         oPrn:Say(nLinDet,1900,Transform(nSoma2,cPict1),oFont11,50)
		  	oPrn:Say(nLinDet,2420,Transform(nSoma3,cPict1),oFont11,50)
		  	oPrn:Say(nLinDet,2620,Transform(nSoma4,cPict1),oFont11,50)
		  	oPrn:Say(nLinDet,2860,Transform(nSoma5,cPict1),oFont11,50)
		  	oPrn:Say(nLinDet,3110,Transform(nSoma6,cPict1),oFont11,50)
		  	oPrn:Say(nLinDet,3340,Transform(nSoma7,cPict1),oFont11,50)
		  	oPrn:Say(nLinDet,3600,Transform(nSoma8,cPict1),oFont11,50)
	      nLinDet := nLinDet + nTamLin
		Endif
  	Endif
   nNumero += 1
   oPrn:Say( nLinDet ,210 ,StrZero(nNumero,4),oFont11)
   For nY := 2 to 15
   	If nY == 4 .or. nY == 7 .or. nY == 10 .or. nY == 11 .or. nY == 12 .or.;
    		nY == 13 .or. nY == 14 .or. nY == 15
      	oPrn:Say( nLinDet ,aColunas[nY],Transform(Val(aDados[nX][nY]),cPict1),oFont11)
   	Else
    		oPrn:Say( nLinDet ,aColunas[nY],aDados[nX][nY],oFont11)
      Endif
      If nY == 4 .And. !Empty(aDados[nX][4])
      	nSoma1 += Val(aDados[nX][4])
     	Elseif nY== 7 .And. !Empty(aDados[nX][7])
      	nSoma2 += Val(aDados[nX][7])
     	Elseif nY == 10 .And. !Empty(aDados[nX][10])
      	nSoma3 += Val(aDados[nX][10])
      Elseif nY == 11 .And. !Empty(aDados[nX][11])
      	nSoma4 += Val(aDados[nX][11])
     	Elseif nY == 12 .And. !Empty(aDados[nX][12])
      	nSoma5 += Val(aDados[nX][12])
    	Elseif nY ==13 .And. !Empty(aDados[nX][13])
     		nSoma6 += Val(aDados[nX][13])
    	Elseif nY ==14 .And. !Empty(aDados[nX][14])
     		nSoma7 += Val(aDados[nX][14])
     	Elseif nY== 15 .And. !Empty(aDados[nX][15])
      	nSoma8 += Val(aDados[nX][15])
   	Endif
	Next
 	nLinDet := nLinDet + nTamLin

	If nLinDet >= 3023 .or. nX == Len(aDados)
 		oPrn:Line(3023,200,3023,3900)
	  	If nLinDet >=3035
		  	oPrn:Say(3035,320,OemToAnsi(STR0038),oFont11b,50) // A Transportar
    	Endif
		oPrn:Say(nLinDet,1300,Transform(nSoma1,cPict1),oFont11,50)
  		oPrn:Say(nLinDet,1900,Transform(nSoma2,cPict1),oFont11,50)
		oPrn:Say(nLinDet,2420,Transform(nSoma3,cPict1),oFont11,50)
		oPrn:Say(nLinDet,2620,Transform(nSoma4,cPict1),oFont11,50)
		oPrn:Say(nLinDet,2860,Transform(nSoma5,cPict1),oFont11,50)
		oPrn:Say(nLinDet,3110,Transform(nSoma6,cPict1),oFont11,50)
		oPrn:Say(nLinDet,3340,Transform(nSoma7,cPict1),oFont11,50)
		oPrn:Say(nLinDet,3600,Transform(nSoma8,cPict1),oFont11,50)
	 	oPrn:Box(3080,200,3132,3900)
		oPrn:Line(3078,200,3078,3900)
		oPrn:Line(3133,200,3133,3900)
	 	nLinDet := 3090
		oPrn:Say(nLinDet,450,OemToAnsi(STR0033),oFont11b,50) // OBSERVACIONES
        // Cerra la pagina
  		oPrn:EndPage()
		nLinTot:= nX
 	Endif
Next

// Cerra la pagina
oPrn:EndPage()
// Mostra la pentalla de Setup
oPrn:Setup()
// Mostra la pentalla de preview
oPrn:Preview()

MS_FLUSH()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CABEC     ºAutor  ³Silvia Taguti       º Data ³  23/11/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cabecalho do Relatorio                                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Cabec(dDataRef)
Local cMesRef  :=UPPER(MesExtenso(Month(dDataRef)))
Local cSem
Local cAnoRef  := Alltrim(Str(Year(dDataRef)))
Local nTamLin
Local nLin
Local cExplot:="Imp.-Vta. de Rulemanes y Rtos. en Gral"
Local cNumPat := ""
Local nLinha :=0

If Month(dDataRef)< 6
   cSem := "1o"
Else
   cSem := "2o"
Endif
SRX->(dbsetorder(1))

If FPHIST82( xFilial("SRX") , "99" , cFilQueb)
   cNumPat := SubStr ( SRX->RX_TXT ,  1 , 10 ) 
Else
	Help(" ",1,"NUMPATRINV")
	Return .F.
Endif

// Empeza la impresion del cabezallo
oPrn:Say(200,1700,OemToAnsi(STR0001),oFont24b,100)   // Sueldos y Jornales
oPrn:Say(300,1350,OemToAnsi(STR0002),oFont12 ,100)   // Mes de :
oPrn:Say(300,1500,cMesRef,oFont12 ,100)
oPrn:Say(300,2000,OemToAnsi(STR0003),oFont12 ,100)   // Semetre :
oPrn:Say(300,2160,cSem,oFont12 ,100)
oPrn:Say(300,2500,OemToAnsi(STR0004),oFont12 ,100)   // Ano :
oPrn:Say(300,2600,cAnoRef,oFont12 ,100)

oPrn:Say(200,2900,OemToAnsi(STR0005),oFont10b,100)    // Razon Social o Prp :
oPrn:Say(250,2900,OemToAnsi(STR0006),oFont10b,100)    // Explotacion :
oPrn:Say(300,2900,OemToAnsi(STR0007),oFont10b,100)    // Domicilio :
oPrn:Say(350,2900,OemToAnsi(STR0008),oFont10b,100)    // Registro Patronal N. :

nPos := ASCAN(aDescFil,{ |X| X[1] = cFilQueb }) 
If nPos > 0
	// Empeza la impresion de los datos de la empresa
	oPrn:Say(200,3260,Substr(aDescFil[nPos,2],1,30)	,oFont10b,100)
	oPrn:Say(250,3260,cExplot                         ,oFont10b,100)
	oPrn:Say(300,3260,aDescFil[nPos,3]             	,oFont10b,100)
	oPrn:Say(350,3260,cNumPat 	                     ,oFont10b,100)
Endif
// Empeza la impresion del cabezallo de la grade
oPrn:Line(398,200,398,3900)
oPrn:Box( 400, 200,3078, 300)   // N.
oPrn:Box( 400, 300,3078,1100)   // Nombra y Apelido

oPrn:Box( 400,1100, 550,1600)   // Salario
oPrn:Box( 450,1100,3078,1300)   // Forma de Pago
oPrn:Box( 450,1300,3078,1600)   // Importe Unitario

oPrn:Box( 400,1600, 550,1900)   // Total
oPrn:Box( 450,1600,3078,1730)   // Dias de Trabajo
oPrn:Box( 450,1730,3078,1900)   // Horas de Trabajo

oPrn:Box( 400,1900,3078,2200)   // Importe

oPrn:Box( 400,2200, 550,2650)   // Horas Extras
oPrn:Box( 450,2200,3078,2300)   // 50%
oPrn:Box( 450,2300,3078,2400)   // 100%
oPrn:Box( 450,2400,3078,2650)   // Importe

oPrn:Box( 400,2650, 550,3600)   // Beneficios Sociales
oPrn:Box( 450,2650,3078,2870)   // Vacacion
oPrn:Box( 450,2870,3078,3100)   // Bonificacion Fliar.
oPrn:Box( 450,3100,3078,3400)   // Aguinaldo
oPrn:Box( 450,3400,3078,3600)   // Otros Beneficios

oPrn:Box( 400,3600,3078,3900)   // Total General

oPrn:Say( 480, 240,OemToAnsi(STR0032),oFont12,50) // N.
oPrn:Say( 480, 510,OemToAnsi(STR0009),oFont12,50) // NOMBRE Y APELIDO

oPrn:Say( 420,1280,OemToAnsi(STR0010),oFont10b,50) // SALARIO
oPrn:Say( 470,1130,OemToAnsi(STR0011),oFont10b,50) // Forma de
oPrn:Say( 510,1155,OemToAnsi(STR0012),oFont10b,50) // Pago
oPrn:Say( 470,1380,OemToAnsi(STR0013),oFont10b,50) // Importe
oPrn:Say( 510,1380,OemToAnsi(STR0014),oFont10b,50) // Unitario

oPrn:Say( 420,1700,OemToAnsi(STR0015),oFont10b,50) // TOTAL
oPrn:Say( 470,1610,OemToAnsi(STR0016),oFont10b,50) // Dias de
oPrn:Say( 510,1610,OemToAnsi(STR0017),oFont10b,50) // Trabajo
oPrn:Say( 470,1750,OemToAnsi(STR0018),oFont10b,50) // Horas de
oPrn:Say( 510,1760,OemToAnsi(STR0019),oFont10b,50) // Trabajo

oPrn:Say( 480,1960,Upper(OemToAnsi(STR0020)),oFont12,50) // Importe

oPrn:Say( 420,2300,OemToAnsi(STR0021),oFont10b,50) // HORAS EXTRAS
oPrn:Say( 500,2215,OemToAnsi(STR0022),oFont10b,50) // 50%
oPrn:Say( 500,2306,OemToAnsi(STR0023),oFont10b,50) // 100%
oPrn:Say( 500,2450,OemToAnsi(STR0020),oFont10b,50) // Importe

oPrn:Say( 420,2900,OemToAnsi(STR0024),oFont10b,50) // BENEFICIOS SOCIALES
oPrn:Say( 500,2700,OemToAnsi(STR0025),oFont10b,50) // Vacacion
oPrn:Say( 470,2895,OemToAnsi(STR0026),oFont10b,50) // Bonificacion
oPrn:Say( 510,2960,OemToAnsi(STR0027),oFont10b,50) // Fliar.
oPrn:Say( 500,3185,OemToAnsi(STR0028),oFont10b,50) // Aguinaldo
oPrn:Say( 470,3465,OemToAnsi(STR0029),oFont10b,50) // Otros
oPrn:Say( 510,3425,OemToAnsi(STR0030),oFont10b,50) // Beneficios

oPrn:Say( 450,3700,OemToAnsi(STR0015),oFont12,50) // TOTAL
oPrn:Say( 500,3685,OemToAnsi(STR0031),oFont12,50) // GENERAL

// Empeza la impresion de las lineas
nTamLin := 55
nLin:=552

For nLinha := 1 to 47
	oPrn:Line(nLin,200,nLin,3900)
	nLin:=nLin+nTamLin
Next

Return


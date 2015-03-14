#include "RwMake.ch"
#include "RGPER01.CH"
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
±±ºPrograma  ³RGPER01   ºAutor  ³Silvia Taguti       º Data ³  03/12/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Hace la impresion de los libros de sueldos y jornales       º±±
±±º          ³Semestral                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Paraguai                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User FUNCTION RGPER01()

Local cString := "SRA"  // alias do arquivo principal (Base)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Private(Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private NomeProg := "RGPER01"
Private cPerg    := "RGPR01"
Private Titulo
Private aCodFol:= {}
Private cPict1	:= TM(9999999999,16,MsDecimais(1))


pergunte("RGPR01",.T.)                                               



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
//³ mv_par13        //  Ano Referencia                          ³
//³ mv_par14        //  Semestre                                 ³
//³ mv_par15        //  Ordem                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:="RGPER01"            //Nome Default do relatorio em Disco

RptStatus({|lEnd| RGPE01Imp(@lEnd,wnRel,cString)},Titulo)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RGPE01IMP ºAutor  ³Silvia Taguti       º Data ³  03/12/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatorio                                                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RGPE01IMP(lEnd,WnRel,cString)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Locais (Programa)                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nLin      := 0
Local aDados    := {}
Local cNome
Local cFPag
Local cFormaPag
Local nImpUnit  := nRemPerc1 := nRemPerc2 := 0
Local nRemPerc3 := nRemPerc4 := nRemPerc5 := 0
Local nRemPerc6 := nExtra50  := nExtra100 := nExtraImp := nTotHrs   := nTotSal   := 0
Local nAguinaldo:= 0
Local nBonif    := 0
Local nVacacion := 0
Local nOtBenef  := 0
Local nTotGeral := 0
Local cSemesRef := " "
Local cSemesAfas := " "
Local cSemesDem := " "
Local cAnoDem := "    "
Local cMesIni,cMesFim,dMesAtu
Local nDias1  := nDias2 := nDias3 := nDias4 :=nDias5 := nDias6 := 0
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
cAnoRef    := mv_par13
nSemRef    := mv_par14
nOrdem     := mv_par15

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

Iif(nSemRef == 1, cSemesRef := "06",cSemesRef := "12")

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
 	If !Empty(SRA->RA_DEMISSA)
  		If Month(SRA->RA_DEMISSA) < 6
	   	cSemesDem :="1"
	   Else
	      cSemesDem := "2"
	   Endif
    	cAnoDem := Alltrim(Str(Year(SRA->RA_DEMISSA)))
  	Endif
	cTipAfas := " "
	dDtAfas  := dDtRet := ctod("")
	fChkAfas(SRA->RA_FILIAL,SRA->RA_MAT,ctod("01/"+cSemesRef+"/"+cAnoRef),@dDtAfas,@dDtRet,@cTipAfas)
	If cTipAfas $"OPQRXY"
		cTipAfas := "A"
	ElseiF cTipAfas $"HIJKLMNSUV" .Or.;
		(!Empty(SRA->RA_DEMISSA) .And. cAnoRef+cSemesRef >=  MesAno(SRA->RA_DEMISSA))
		cTipAfas := "D"
	ElseIf cTipAfas == "F"
		cTipAfas := "F"
	Else
		cTipAfas := " "
	EndIf

	If Month(dDtAfas)< 6
 		cSemesAfas := "1"
   Else
   	cSemesAfas := "2"
   Endif

	If cSemesAfas+Alltrim(Str(Year(dDtAfas))) > cSemesRef +cAnoRef
 		cTipAfas := " "
   Endif

	If cTipAfas $ "D" .And. cSemesDem+cAnoDem # cSemesRef+cAnoRef  .And.;
 		cSemesDem+cAnoDem < cSemesRef+cAnoRef
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
 	cFPag := fDesc("SX5","28"+SRA->RA_CATFUNC,"Substr(X5DESCRI(),1,1)")
  	nImpUnit  := SRA->RA_SALARIO

	If nSemRef == 1
		cMesIni := "01"
	   cMesFim := "06"
	Else
 		cMesIni := "07"
	   cMesFim := "12"
	Endif

	dbSelectArea("SRD")
	If dbSeek(SRA->RA_FILIAL + SRA->RA_MAT)
		While !Eof() .And. (SRA->RA_FILIAL+SRA->RA_MAT == SRD->RD_FILIAL+SRD->RD_MAT);
			.And. (SRD->RD_DATARQ >=cAnoRef+cMesIni .And. SRD->RD_DATARQ <=cAnoRef+cMesFim)
   		IF ALLTRIM(STR(YEAR(SRA->RA_ADMISSA)))==SUBSTR(SRD->RD_DATARQ,1,4).AND. STRZERO(MONTH(SRA->RA_ADMISSA),2)==Substr(SRD->RD_DATARQ,5,2).AND.DAY(SRA->RA_ADMISSA) # 1
 				dMesAtu := SRA->RA_ADMISSAO
     		Else
   			dMesAtu := Ctod("01/"+SubStr(SRD->RD_DATARQ,5,2)+"/"+Substr(SRD->RD_DATARQ,1,4))
   		Endif
			If Substr(SRD->RD_DATARQ,5,2)=="01" .or. Substr(SRD->RD_DATARQ,5,2)=="07"
      		If SRA->RA_CATFUNC $ "M*C*D" .And. SRA->RA_TIPOPGT = "M" .And. SRD->RD_PD == aCodFol[031,1]
				 	nRemPerc1 := SRD->RD_VALOR
		   		LocGHabRea(dMesAtu,Ctod(StrZero(F_ULTDIA(dMesAtu),2)+"/"+Substr(dtoc(dMesAtu),4,5),"ddmmyy"),@nDias1,,,)
			  	Elseif SRA->RA_CATFUNC $ "P" .And. SRA->RA_TIPOPGT = "M" .And. SRD->RD_PD == aCodFol[217,1]
				 	nRemPerc1 := SRD->RD_VALOR
		   		LocGHabRea(dMesAtu,Ctod(StrZero(F_ULTDIA(dMesAtu),2)+"/"+Substr(dtoc(dMesAtu),4,5),"ddmmyy"),@nDias1,,,)
			  	Elseif SRA->RA_CATFUNC $ "A" .And. SRA->RA_TIPOPGT = "M" .And.SRD->RD_PD == aCodFol[218,1]
				 	nRemPerc1 := SRD->RD_VALOR
		   		LocGHabRea(dMesAtu,Ctod(StrZero(F_ULTDIA(dMesAtu),2)+"/"+Substr(dtoc(dMesAtu),4,5),"ddmmyy"),@nDias1,,,)
			  	Elseif SRA->RA_CATFUNC $ "E" .And. SRA->RA_TIPOPGT = "M" .And. SRD->RD_PD ==aCodFol[219,1]
				 	nRemPerc1 := SRD->RD_VALOR
		   		LocGHabRea(dMesAtu,Ctod(StrZero(F_ULTDIA(dMesAtu),2)+"/"+Substr(dtoc(dMesAtu),4,5),"ddmmyy"),@nDias1,,,)
		      Elseif SRA->RA_CATFUNC $ "H" .And. SRA->RA_TIPOPGT = "M" .And. SRD->RD_PD == aCodfol[32,1]
				 	nRemPerc1 := SRD->RD_VALOR
		   		LocGHabRea(dMesAtu,Ctod(StrZero(F_ULTDIA(dMesAtu),2)+"/"+Substr(dtoc(dMesAtu),4,5),"ddmmyy"),@nDias1,,,)
			  	Elseif SRA->RA_CATFUNC $ "G" .And. SRA->RA_TIPOPGT = "M" .And. SRD->RD_PD == aCodfol[220,1]
				 	nRemPerc1 := SRD->RD_VALOR
		   		LocGHabRea(dMesAtu,Ctod(StrZero(F_ULTDIA(dMesAtu),2)+"/"+Substr(dtoc(dMesAtu),4,5),"ddmmyy"),@nDias1,,,)
			  	ElseIf SRA->RA_CATFUNC $ "H" .And. SRA->RA_TIPOPGT = "M" .And. SRD->RD_PD == aCodfol[32,1] .or. SRD->RD_PD == aCodfol[33,1]
				 	nRemPerc1 := SRD->RD_VALOR
		   		LocGHabRea(dMesAtu,Ctod(StrZero(F_ULTDIA(dMesAtu),2)+"/"+Substr(dtoc(dMesAtu),4,5),"ddmmyy"),@nDias,,,)
		      EndIf
        ElseIf Substr(SRD->RD_DATARQ,5,2)=="02" .or. Substr(SRD->RD_DATARQ,5,2)== "08"
         	If SRA->RA_CATFUNC $ "M*C*D" .And. SRA->RA_TIPOPGT = "M" .And. SRD->RD_PD == aCodFol[031,1]
				 	nRemPerc2 := SRD->RD_VALOR
		   		LocGHabRea(dMesAtu,Ctod(StrZero(F_ULTDIA(dMesAtu),2)+"/"+Substr(dtoc(dMesAtu),4,5),"ddmmyy"),@nDias2,,,)
			  	Elseif SRA->RA_CATFUNC $ "P" .And. SRA->RA_TIPOPGT = "M" .And. SRD->RD_PD == aCodFol[217,1]
				 	nRemPerc2 := SRD->RD_VALOR
		   		LocGHabRea(dMesAtu,Ctod(StrZero(F_ULTDIA(dMesAtu),2)+"/"+Substr(dtoc(dMesAtu),4,5),"ddmmyy"),@nDias2,,,)
			  	Elseif SRA->RA_CATFUNC $ "A" .And. SRA->RA_TIPOPGT = "M" .And.SRD->RD_PD == aCodFol[218,1]
				 	nRemPerc2 := SRD->RD_VALOR
		   		LocGHabRea(dMesAtu,Ctod(StrZero(F_ULTDIA(dMesAtu),2)+"/"+Substr(dtoc(dMesAtu),4,5),"ddmmyy"),@nDias2,,,)
			  	Elseif SRA->RA_CATFUNC $ "E" .And. SRA->RA_TIPOPGT = "M" .And. SRD->RD_PD ==aCodFol[219,1]
				 	nRemPerc2 := SRD->RD_VALOR
		   		LocGHabRea(dMesAtu,Ctod(StrZero(F_ULTDIA(dMesAtu),2)+"/"+Substr(dtoc(dMesAtu),4,5),"ddmmyy"),@nDias2,,,)
		     	Elseif SRA->RA_CATFUNC $ "H" .And. SRA->RA_TIPOPGT = "M" .And. SRD->RD_PD == aCodfol[32,1]
				 	nRemPerc2 := SRD->RD_VALOR
		   		LocGHabRea(dMesAtu,Ctod(StrZero(F_ULTDIA(dMesAtu),2)+"/"+Substr(dtoc(dMesAtu),4,5),"ddmmyy"),@nDias2,,,)
			  	Elseif SRA->RA_CATFUNC $ "G" .And. SRA->RA_TIPOPGT = "M" .And. SRD->RD_PD == aCodfol[220,1]
				 	nRemPerc2 := SRD->RD_VALOR
		   		LocGHabRea(dMesAtu,Ctod(StrZero(F_ULTDIA(dMesAtu),2)+"/"+Substr(dtoc(dMesAtu),4,5),"ddmmyy"),@nDias2,,,)
				ElseIf SRA->RA_CATFUNC $ "H" .And. SRA->RA_TIPOPGT = "M" .And. SRD->RD_PD == aCodfol[32,1] .or. SRD->RD_PD == aCodfol[33,1]
				 	nRemPerc2 := SRD->RD_VALOR
		   		LocGHabRea(dMesAtu,Ctod(StrZero(F_ULTDIA(dMesAtu),2)+"/"+Substr(dtoc(dMesAtu),4,5),"ddmmyy"),@nDias2,,,)
		     	EndIf

			ElseIf Substr(SRD->RD_DATARQ,5,2)=="03" .or. Substr(SRD->RD_DATARQ,5,2)== "09"
   			If SRA->RA_CATFUNC $ "M*C*D" .And. SRA->RA_TIPOPGT = "M" .And. SRD->RD_PD == aCodFol[031,1]
				 	nRemPerc3 := SRD->RD_VALOR
		   		LocGHabRea(dMesAtu,Ctod(StrZero(F_ULTDIA(dMesAtu),2)+"/"+Substr(dtoc(dMesAtu),4,5),"ddmmyy"),@nDias3,,,)
				Elseif SRA->RA_CATFUNC $ "P" .And. SRA->RA_TIPOPGT = "M" .And. SRD->RD_PD == aCodFol[217,1]
				 	nRemPerc3 := SRD->RD_VALOR
		   		LocGHabRea(dMesAtu,Ctod(StrZero(F_ULTDIA(dMesAtu),2)+"/"+Substr(dtoc(dMesAtu),4,5),"ddmmyy"),@nDias3,,,)
			  	Elseif SRA->RA_CATFUNC $ "A" .And. SRA->RA_TIPOPGT = "M" .And.SRD->RD_PD == aCodFol[218,1]
				 	nRemPerc3 := SRD->RD_VALOR
		   		LocGHabRea(dMesAtu,Ctod(StrZero(F_ULTDIA(dMesAtu),2)+"/"+Substr(dtoc(dMesAtu),4,5),"ddmmyy"),@nDias3,,,)
			 	Elseif SRA->RA_CATFUNC $ "E" .And. SRA->RA_TIPOPGT = "M" .And. SRD->RD_PD ==aCodFol[219,1]
				 	nRemPerc3 := SRD->RD_VALOR
		   		LocGHabRea(dMesAtu,Ctod(StrZero(F_ULTDIA(dMesAtu),2)+"/"+Substr(dtoc(dMesAtu),4,5),"ddmmyy"),@nDias3,,,)
		     	Elseif SRA->RA_CATFUNC $ "H" .And. SRA->RA_TIPOPGT = "M" .And. SRD->RD_PD == aCodfol[32,1]
				 	nRemPerc3 := SRD->RD_VALOR
		   		LocGHabRea(dMesAtu,Ctod(StrZero(F_ULTDIA(dMesAtu),2)+"/"+Substr(dtoc(dMesAtu),4,5),"ddmmyy"),@nDias3,,,)
			  	Elseif SRA->RA_CATFUNC $ "G" .And. SRA->RA_TIPOPGT = "M" .And. SRD->RD_PD == aCodfol[220,1]
				 	nRemPerc3 := SRD->RD_VALOR
		   		LocGHabRea(dMesAtu,Ctod(StrZero(F_ULTDIA(dMesAtu),2)+"/"+Substr(dtoc(dMesAtu),4,5),"ddmmyy"),@nDias3,,,)
			  	ElseIf SRA->RA_CATFUNC $ "H" .And. SRA->RA_TIPOPGT = "M" .And. SRD->RD_PD == aCodfol[32,1] .or. SRD->RD_PD == aCodfol[33,1]
				 	nRemPerc3 := SRD->RD_VALOR
		   		LocGHabRea(dMesAtu,Ctod(StrZero(F_ULTDIA(dMesAtu),2)+"/"+Substr(dtoc(dMesAtu),4,5),"ddmmyy"),@nDias3,,,)
		     	EndIf
       	ElseIf Substr(SRD->RD_DATARQ,5,2)=="04" .or. Substr(SRD->RD_DATARQ,5,2)== "10"
        		If SRA->RA_CATFUNC $ "M*C*D" .And. SRA->RA_TIPOPGT = "M" .And. SRD->RD_PD == aCodFol[031,1]
				 	nRemPerc4 := SRD->RD_VALOR
		   		LocGHabRea(dMesAtu,Ctod(StrZero(F_ULTDIA(dMesAtu),2)+"/"+Substr(dtoc(dMesAtu),4,5),"ddmmyy"),@nDias4,,,)
			  	Elseif SRA->RA_CATFUNC $ "P" .And. SRA->RA_TIPOPGT = "M" .And. SRD->RD_PD == aCodFol[217,1]
				 	nRemPerc4 := SRD->RD_VALOR
		   		LocGHabRea(dMesAtu,Ctod(StrZero(F_ULTDIA(dMesAtu),2)+"/"+Substr(dtoc(dMesAtu),4,5),"ddmmyy"),@nDias4,,,)
			  	Elseif SRA->RA_CATFUNC $ "A" .And. SRA->RA_TIPOPGT = "M" .And.SRD->RD_PD == aCodFol[218,1]
				 	nRemPerc4 := SRD->RD_VALOR
		   		LocGHabRea(dMesAtu,Ctod(StrZero(F_ULTDIA(dMesAtu),2)+"/"+Substr(dtoc(dMesAtu),4,5),"ddmmyy"),@nDias4,,,)
			  	Elseif SRA->RA_CATFUNC $ "E" .And. SRA->RA_TIPOPGT = "M" .And. SRD->RD_PD ==aCodFol[219,1]
				 	nRemPerc4 := SRD->RD_VALOR
		   		LocGHabRea(dMesAtu,Ctod(StrZero(F_ULTDIA(dMesAtu),2)+"/"+Substr(dtoc(dMesAtu),4,5),"ddmmyy"),@nDias4,,,)
		     	Elseif SRA->RA_CATFUNC $ "H" .And. SRA->RA_TIPOPGT = "M" .And. SRD->RD_PD == aCodfol[32,1]
				 	nRemPerc4 := SRD->RD_VALOR
		   		LocGHabRea(dMesAtu,Ctod(StrZero(F_ULTDIA(dMesAtu),2)+"/"+Substr(dtoc(dMesAtu),4,5),"ddmmyy"),@nDias4,,,)
			 	Elseif SRA->RA_CATFUNC $ "G" .And. SRA->RA_TIPOPGT = "M" .And. SRD->RD_PD == aCodfol[220,1]
				 	nRemPerc4 := SRD->RD_VALOR
		   		LocGHabRea(dMesAtu,Ctod(StrZero(F_ULTDIA(dMesAtu),2)+"/"+Substr(dtoc(dMesAtu),4,5),"ddmmyy"),@nDias4,,,)
			  	ElseIf SRA->RA_CATFUNC $ "H" .And. SRA->RA_TIPOPGT = "M" .And. SRD->RD_PD == aCodfol[32,1] .or. SRD->RD_PD == aCodfol[33,1]
				 	nRemPerc4 := SRD->RD_VALOR
		   		LocGHabRea(dMesAtu,Ctod(StrZero(F_ULTDIA(dMesAtu),2)+"/"+Substr(dtoc(dMesAtu),4,5),"ddmmyy"),@nDias4,,,)
		     	EndIf
      	ElseIf Substr(SRD->RD_DATARQ,5,2)=="05" .or. Substr(SRD->RD_DATARQ,5,2)== "11"
         	If SRA->RA_CATFUNC $ "M*C*D" .And. SRA->RA_TIPOPGT = "M" .And. SRD->RD_PD == aCodFol[031,1]
				 	nRemPerc6 := SRD->RD_VALOR
		   		LocGHabRea(dMesAtu,Ctod(StrZero(F_ULTDIA(dMesAtu),2)+"/"+Substr(dtoc(dMesAtu),4,5),"ddmmyy"),@nDias5,,,)
			  	Elseif SRA->RA_CATFUNC $ "P" .And. SRA->RA_TIPOPGT = "M" .And. SRD->RD_PD == aCodFol[217,1]
				 	nRemPerc5 := SRD->RD_VALOR
		   		LocGHabRea(dMesAtu,Ctod(StrZero(F_ULTDIA(dMesAtu),2)+"/"+Substr(dtoc(dMesAtu),4,5),"ddmmyy"),@nDias5,,,)
			  	Elseif SRA->RA_CATFUNC $ "A" .And. SRA->RA_TIPOPGT = "M" .And.SRD->RD_PD == aCodFol[218,1]
				 	nRemPerc5 := SRD->RD_VALOR
		   		LocGHabRea(dMesAtu,Ctod(StrZero(F_ULTDIA(dMesAtu),2)+"/"+Substr(dtoc(dMesAtu),4,5),"ddmmyy"),@nDias5,,,)
			  	Elseif SRA->RA_CATFUNC $ "E" .And. SRA->RA_TIPOPGT = "M" .And. SRD->RD_PD ==aCodFol[219,1]
				 	nRemPerc5 := SRD->RD_VALOR
		   		LocGHabRea(dMesAtu,Ctod(StrZero(F_ULTDIA(dMesAtu),2)+"/"+Substr(dtoc(dMesAtu),4,5),"ddmmyy"),@nDias5,,,)
		     	Elseif SRA->RA_CATFUNC $ "H" .And. SRA->RA_TIPOPGT = "M" .And. SRD->RD_PD == aCodfol[32,1]
				 	nRemPerc5 := SRD->RD_VALOR
		   		LocGHabRea(dMesAtu,Ctod(StrZero(F_ULTDIA(dMesAtu),2)+"/"+Substr(dtoc(dMesAtu),4,5),"ddmmyy"),@nDias5,,,)
			 	Elseif SRA->RA_CATFUNC $ "G" .And. SRA->RA_TIPOPGT = "M" .And. SRD->RD_PD == aCodfol[220,1]
				 	nRemPerc5 := SRD->RD_VALOR
		   		LocGHabRea(dMesAtu,Ctod(StrZero(F_ULTDIA(dMesAtu),2)+"/"+Substr(dtoc(dMesAtu),4,5),"ddmmyy"),@nDias5,,,)
			 	ElseIf SRA->RA_CATFUNC $ "H" .And. SRA->RA_TIPOPGT = "M" .And. SRD->RD_PD == aCodfol[32,1] .or. SRD->RD_PD == aCodfol[33,1]
				 	nRemPerc5 := SRD->RD_VALOR
		   		LocGHabRea(dMesAtu,Ctod(StrZero(F_ULTDIA(dMesAtu),2)+"/"+Substr(dtoc(dMesAtu),4,5),"ddmmyy"),@nDias5,,,)
		     	EndIf
        	ElseIf Substr(SRD->RD_DATARQ,5,2)== "06" .or. Substr(SRD->RD_DATARQ,5,2)== "12"
         	If SRA->RA_CATFUNC $ "M*C*D" .And. SRA->RA_TIPOPGT = "M" .And. SRD->RD_PD == aCodFol[031,1]
				 	nRemPerc6 := SRD->RD_VALOR
				 	
		   		LocGHabRea(dMesAtu,Ctod(StrZero(F_ULTDIA(dMesAtu),2)+"/"+Substr(dtoc(dMesAtu),4,5),"ddmmyy"),@nDias6,,,)
			 	Elseif SRA->RA_CATFUNC $ "P" .And. SRA->RA_TIPOPGT = "M" .And. SRD->RD_PD == aCodFol[217,1]
				   	nRemPerc6 := SRD->RD_VALOR  
				 	
		   		LocGHabRea(dMesAtu,Ctod(StrZero(F_ULTDIA(dMesAtu),2)+"/"+Substr(dtoc(dMesAtu),4,5),"ddmmyy"),@nDias6,,,)
			 	Elseif SRA->RA_CATFUNC $ "A" .And. SRA->RA_TIPOPGT = "M" .And.SRD->RD_PD == aCodFol[218,1]
				 	nRemPerc6 := SRD->RD_VALOR
				 	
		   		LocGHabRea(dMesAtu,Ctod(StrZero(F_ULTDIA(dMesAtu),2)+"/"+Substr(dtoc(dMesAtu),4,5),"ddmmyy"),@nDias6,,,)
			 	Elseif SRA->RA_CATFUNC $ "E" .And. SRA->RA_TIPOPGT = "M" .And. SRD->RD_PD ==aCodFol[219,1]
                      
				 	nRemPerc6 := SRD->RD_VALOR
		   		LocGHabRea(dMesAtu,Ctod(StrZero(F_ULTDIA(dMesAtu),2)+"/"+Substr(dtoc(dMesAtu),4,5),"ddmmyy"),@nDias6,,,)
		     	Elseif SRA->RA_CATFUNC $ "H" .And. SRA->RA_TIPOPGT = "M" .And. SRD->RD_PD == aCodfol[32,1]
				 	nRemPerc6 := SRD->RD_VALOR
		   		LocGHabRea(dMesAtu,Ctod(StrZero(F_ULTDIA(dMesAtu),2)+"/"+Substr(dtoc(dMesAtu),4,5),"ddmmyy"),@nDias6,,,)
			 	Elseif SRA->RA_CATFUNC $ "G" .And. SRA->RA_TIPOPGT = "M" .And. SRD->RD_PD == aCodfol[220,1]
				 	nRemPerc6 := SRD->RD_VALOR
		   		LocGHabRea(dMesAtu,Ctod(StrZero(F_ULTDIA(dMesAtu),2)+"/"+Substr(dtoc(dMesAtu),4,5),"ddmmyy"),@nDias6,,,)
				ElseIf SRA->RA_CATFUNC $ "H" .And. SRA->RA_TIPOPGT = "M" .And. SRD->RD_PD == aCodfol[32,1] .or. SRD->RD_PD == aCodfol[33,1]
					nRemPerc6 := SRD->RD_VALOR
		   		LocGHabRea(dMesAtu,Ctod(StrZero(F_ULTDIA(dMesAtu),2)+"/"+Substr(dtoc(dMesAtu),4,5),"ddmmyy"),@nDias6,,,)
		     	EndIf
       	Endif

			If SRD->RD_PD == "201"  
		 		nExtra50  += SRD->RD_HORAS
			  	nExtraImp += SRD->RD_VALOR
		   Endif
		   If SRD->RD_PD == "202"
		      nExtra100 += SRD->RD_HORAS
		      nExtraImp += SRD->RD_VALOR
		   Endif                    
		   
			nTotHrs := nDias1+nDias2+nDias3+nDias4+nDias5+nDias6+nExtra50+nExtra100
   		    nTotSal := nRemPerc1+nRemPerc2+nRemPerc3+nRemPerc4+nRemPerc5+nRemPerc6+nExtraImp

			If SRD->RD_PD $ aCodFol[22,1]+"|"+aCodFol[24,1]  //Aguinaldo
 				nAguinaldo+= SRD->RD_VALOR
 		    Endif

    	   If SRD->RD_PD $ aCodFol[34,1]          //Salario Familia
 		      nBonif += SRD->RD_VALOR
 		   Endif

		   If SRD->RD_PD $ aCodFol[072,1]+"|"+aCodFol[224,1]+"|"+aCodFol[087,1]
		      nVacacion += SRD->RD_VALOR  //Ferias vencidas/proporc/dobro
		   Endif

			If SRD->RD_PD $ aCodFol[110,1]+"|"+aCodFol[111,1]  //Indeniz.pre aviso
 				nOtBenef += SRD->RD_VALOR
 		   Endif

 		   nTotGeral := nTotSal+nExtraImp+nVacacion+nBonif+nAguinaldo+nOtBenef
 	    	dbSelectArea("SRD")
		   dbSkip()
     	Enddo
	Endif
  	AaDD(aDados,{GetFilxCC(SRA->RA_CC),cNome,cFPag,alltrim(str(nImpUnit)),;
   		alltrim(str(nDias1)),alltrim(str(nRemPerc1)),alltrim(str(nDias2)),;
	     	alltrim(str(nRemPerc2)),alltrim(str(nDias3)),alltrim(str(nRemPerc3)),;
         alltrim(str(nDias4)),alltrim(str(nRemPerc4)),alltrim(str(nDias5)),;
	     	alltrim(str(nRemPerc5)),alltrim(str(nDias6)),alltrim(str(nRemPerc6)),;
         alltrim(str(nExtra50)),alltrim(str(nExtra100)),alltrim(str(nExtraImp)),;
         alltrim(str(nTotHrs)),alltrim(str(nTotSal)),alltrim(str(nAguinaldo)),;
         alltrim(str(nBonif)),alltrim(str(nVacacion)),alltrim(str(nOtBenef)),;
         alltrim(str(nTotGeral))})

	nDias1 := nRemPerc1:=nDias2 := nRemPerc2:=nDias3 := nRemPerc3:=0
 	nDias4 := nRemPerc4:=nDias5 := nRemPerc5:=nDias6 := nRemPerc6:=0
 	nTotHrs := nTotSal:= nExtra50 := nExtra100 := nExtraImp := nVacacion := 0
 	nBonif := nAguinaldo := nOtBenef := nTotGeral:=0
  	dbSelectArea("SRA")
	dbSkip()
Enddo
aSort(aDados,,,{|x,y| x[1] < y[1]})
Libro5(aDados,cAnoRef,nSemRef)  	// Funcao que monta o cabecalho

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Libro5    ºAutor  ³Silvia Taguti       º Data ³  04/12/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Impressao do Relatorio                                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Libro5(aDados,cAnoRef,nSemRef)
Local nX, nY, nLinDet, nTamLin
Local aColunas := {}
Local nSoma1:=nSoma2:=nSoma3:=nSoma4:=nSoma5:=nSoma6:=nSoma7:=nSoma8:=0
Local nSoma9:=nSoma10:=nSoma11:=nSoma12:=nSoma13:=nSoma14:=nSoma15:=nSoma16:=0
Local nSoma17:=nSoma18:=nSoma19:=nSoma20:=nSoma21:=nSoma22:=0
Local nNumero := 0
Private cFilQueb
// Crea los objetos con las configuraciones de fuentes
oFont08  := TFont():New( "Arial",,08,,.f.,,,,,.f. )
oFont08b := TFont():New( "Arial",,08,,.t.,,,,,.f. )
oFont09  := TFont():New( "Arial",,09,,.f.,,,,,.f. )
oFont09b := TFont():New( "Arial",,09,,.t.,,,,,.f. )
oFont10  := TFont():New( "Arial",,10,,.f.,,,,,.f. )
oFont10b := TFont():New( "Times New Roman",,10,,.t.,,,,,.f. )
oFont11  := TFont():New( "Arial",,11,,.f.,,,,,.f. )
oFont11b := TFont():New( "Arial",,11,,.t.,,,,,.f. )
oFont12  := TFont():New( "Arial",,12,,.f.,,,,,.f. )
oFont12B := TFont():New( "Times New Roman",,12,,.t.,,,,,.f. )
oFont12BI:= TFont():New( "Arial",,12,,.t.,,,,,.t. )
oFont20b := TFont():New( "Times New Roman",,20,,.t.,,,,,.f. )
oFont22b := TFont():New( "Times New Roman",,22,,.t.,,,,,.f. )
oFont24b := TFont():New( "Times New Roman",,24,,.t.,,,,,.f. )

// Crea un nuevo objeto para impresion
oPrn := TMSPrinter():New()

// Inicia un nueva pagina
oPrn:StartPage()

// Imprime la inicializacon de la impresora
oPrn:Say(20,20," ",oFont12,100)

aColunas := {0,190,740,760,1000,1020,1260,1285,1530,1540,1780,1800,2045,2060,2315,;
              2330,2560,2620,2590,2795,2880,3060,3240,3400,3570,3790}
nLinTot := 1
nLinDet := 3500
nTamLin := 57
cFilQueb := Space(FWGETTAMFILIAL)

For nX := nLinTot to Len(aDados)
	If cFilQueb <> aDados[nX][1] .and. cFilQueb <> Space(FWGETTAMFILIAL) 
		cFilQueb := aDados[nX][1] 
		nNumero := 0
  		oPrn:Say(nLinDet,0890,Transform(nSoma1,cPict1),oFont08,50)
  		oPrn:Say(nLinDet,1010,Transform(nSoma2,cPict1),oFont08,50)
		oPrn:Say(nLinDet,1150,Transform(nSoma3,cPict1),oFont08,50)
		oPrn:Say(nLinDet,1275,Transform(nSoma4,cPict1),oFont08,50)
		oPrn:Say(nLinDet,1415,Transform(nSoma5,cPict1),oFont08,50)
		oPrn:Say(nLinDet,1535,Transform(nSoma6,cPict1),oFont08,50)
		oPrn:Say(nLinDet,1670,Transform(nSoma7,cPict1),oFont08,50)
		oPrn:Say(nLinDet,1795,Transform(nSoma8,cPict1),oFont08,50)
		oPrn:Say(nLinDet,1930,Transform(nSoma9,cPict1),oFont08,50)
		oPrn:Say(nLinDet,2060,Transform(nSoma10,cPict1),oFont08,50)
		oPrn:Say(nLinDet,2190,Transform(nSoma11,cPict1),oFont08,50)
		oPrn:Say(nLinDet,2335,Transform(nSoma12,cPict1),oFont08,50)
		oPrn:Say(nLinDet,2430,Transform(nSoma13,cPict1),oFont08,50)
		oPrn:Say(nLinDet,2495,Transform(nSoma14,cPict1),oFont08,50)
		oPrn:Say(nLinDet,2585,Transform(nSoma15,cPict1),oFont08,50)
		oPrn:Say(nLinDet,2700,Transform(nSoma16,cPict1),oFont08,50)
		oPrn:Say(nLinDet,2875,Transform(nSoma17,cPict1),oFont08,50)
		oPrn:Say(nLinDet,3060,Transform(nSoma18,cPict1),oFont08,50)
		oPrn:Say(nLinDet,3230,Transform(nSoma19,cPict1),oFont08,50)
		oPrn:Say(nLinDet,3400,Transform(nSoma20,cPict1),oFont08,50)
		oPrn:Say(nLinDet,3570,Transform(nSoma21,cPict1),oFont08,50)
		oPrn:Say(nLinDet,3780,Transform(nSoma22,cPict1),oFont08,50)
      // Cerra la pagina
      oPrn:EndPage()
  		nLinDet := 2700
 		nSoma1:=nSoma2:=nSoma3:=nSoma4:=nSoma5:=nSoma6:=nSoma7:=nSoma8:=0
 		nSoma9:=nSoma10:=nSoma11:=nSoma12:=nSoma13:=nSoma14:=nSoma15:=nSoma16:=0
		nSoma17:=nSoma18:=nSoma19:=nSoma20:=nSoma21:=nSoma22:=0
 	Endif

	If nLinDet > 2690
 		// Inicia un nueva pagina
      oPrn:StartPage()
      // Imprime la inicializacon de la impresora
      oPrn:Say(20,20," ",oFont08,100)
  		cFilQueb := aDados[nX][1]
      Cabec(cAnoRef,nSemRef)
      nLinDet := 647
      If nSoma1 > 0 .or. nSoma2 > 0 .or. nSoma3 > 0 .or. nSoma4 > 0 .or. nSoma5 > 0 .or.;
      	nSoma6 > 0 .or. nSoma7 > 0 .or. nSoma8 > 0 .or. nSoma9 > 0 .or. nSoma10 > 0 .or.;
         nSoma11 > 0 .or. nSoma12 > 0 .or. nSoma13 > 0 .or. nSoma14 > 0 .or. nSoma15 > 0 .or.;
         nSoma16 > 0 .or. nSoma17 > 0 .or. nSoma18 > 0 .or. nSoma19 > 0 .or. nSoma20 > 0 .or.;
         nSoma21 > 0 .or. nSoma22 > 0
        	oPrn:Say(nLinDet, 190,OemToAnsi(STR0047),oFont08B ,50) // TRANSPORTe
			oPrn:Say(nLinDet,0890,Transform(nSoma1,cPict1),oFont08,50)
        	oPrn:Say(nLinDet,1010,Transform(nSoma2,cPict1),oFont08,50)
			oPrn:Say(nLinDet,1150,Transform(nSoma3,cPict1),oFont08,50)
			oPrn:Say(nLinDet,1275,Transform(nSoma4,cPict1),oFont08,50)
			oPrn:Say(nLinDet,1415,Transform(nSoma5,cPict1),oFont08,50)
			oPrn:Say(nLinDet,1535,Transform(nSoma6,cPict1),oFont08,50)
			oPrn:Say(nLinDet,1670,Transform(nSoma7,cPict1),oFont08,50)
			oPrn:Say(nLinDet,1795,Transform(nSoma8,cPict1),oFont08,50)
			oPrn:Say(nLinDet,1930,Transform(nSoma9,cPict1),oFont08,50)
			oPrn:Say(nLinDet,2060,Transform(nSoma10,cPict1),oFont08,50)
			oPrn:Say(nLinDet,2190,Transform(nSoma11,cPict1),oFont08,50)
			oPrn:Say(nLinDet,2335,Transform(nSoma12,cPict1),oFont08,50)
			oPrn:Say(nLinDet,2430,Transform(nSoma13,cPict1),oFont08,50)
			oPrn:Say(nLinDet,2495,Transform(nSoma14,cPict1),oFont08,50)
			oPrn:Say(nLinDet,2585,Transform(nSoma15,cPict1),oFont08,50)
			oPrn:Say(nLinDet,2700,Transform(nSoma16,cPict1),oFont08,50)
			oPrn:Say(nLinDet,2875,Transform(nSoma17,cPict1),oFont08,50)
			oPrn:Say(nLinDet,3060,Transform(nSoma18,cPict1),oFont08,50)
			oPrn:Say(nLinDet,3230,Transform(nSoma19,cPict1),oFont08,50)
			oPrn:Say(nLinDet,3400,Transform(nSoma20,cPict1),oFont08,50)
			oPrn:Say(nLinDet,3570,Transform(nSoma21,cPict1),oFont08,50)
			oPrn:Say(nLinDet,3780,Transform(nSoma22,cPict1),oFont08,50)
	    	nLinDet := nLinDet + nTamLin
   	Endif
 	Endif
  	
	nNumero += 1
   oPrn:Say( nLinDet ,110 ,StrZero(nNumero,4),oFont08)
	For nY := 2 to 26
 		If nY == 4 .or. nY == 6 .or. nY ==  8 .or. nY == 10 .or. nY == 12 .or.;
   		nY == 14 .or. nY == 16 .or. nY == 19 .or. nY==21 .or. nY==22 .or.;
		   nY==23 .or. nY== 24 .or. nY==25 .or. nY==26
         oPrn:Say( nLinDet ,aColunas[nY],Transform(Val(aDados[nX][nY]),cPict1),oFont08)
      Else
      	oPrn:Say( nLinDet ,aColunas[nY],aDados[nX][nY],oFont08)
   	Endif
    	If nY == 5 .And. !Empty(aDados[nX][5])
	    	nSoma1 += Val(aDados[nX][5])
 		Elseif nY== 6 .And. !Empty(aDados[nX][6])
   		nSoma2 += Val(aDados[nX][6])
	  	Elseif nY == 7 .And. !Empty(aDados[nX][7])
   		nSoma3 += Val(aDados[nX][7])
     	Elseif nY == 8 .And. !Empty(aDados[nX][8])
	     	nSoma4 += Val(aDados[nX][8])
	   Elseif nY == 09 .And. !Empty(aDados[nX][9])
   		nSoma5 += Val(aDados[nX][9])
     	Elseif nY ==10 .And. !Empty(aDados[nX][10])
	     	nSoma6 += Val(aDados[nX][10])
   	Elseif nY ==11 .And. !Empty(aDados[nX][11])
    		nSoma7 += Val(aDados[nX][11])
	   Elseif nY== 12 .And. !Empty(aDados[nX][12])
   	  	nSoma8 += Val(aDados[nX][12])
	   Elseif nY== 13 .And. !Empty(aDados[nX][13])
   	  	nSoma9 += Val(aDados[nX][13])
	   Elseif nY== 14 .And. !Empty(aDados[nX][14])
   	  	nSoma10+= Val(aDados[nX][14])
	   Elseif nY== 15 .And. !Empty(aDados[nX][15])
   	  	nSoma11+= Val(aDados[nX][15])
      Elseif nY== 16 .And. !Empty(aDados[nX][16])
	     	nSoma12+= Val(aDados[nX][16])
   	Elseif nY== 17 .And. !Empty(aDados[nX][17])
      	nSoma13+= Val(aDados[nX][17])
	   Elseif nY== 18 .And. !Empty(aDados[nX][18])
   	  	nSoma14+= Val(aDados[nX][18])
	   Elseif nY== 19 .And. !Empty(aDados[nX][19])
   	  	nSoma15+= Val(aDados[nX][19])
      Elseif nY== 20 .And. !Empty(aDados[nX][20])
	     	nSoma16+= Val(aDados[nX][20])
   	Elseif nY== 21 .And. !Empty(aDados[nX][21])
      	nSoma17+= Val(aDados[nX][21])
	   Elseif nY== 22 .And. !Empty(aDados[nX][22])
   	  	nSoma18+= Val(aDados[nX][22])
      Elseif nY== 23 .And. !Empty(aDados[nX][23])
	     	nSoma19+= Val(aDados[nX][23])
   	Elseif nY== 24 .And. !Empty(aDados[nX][24])
      	nSoma20+= Val(aDados[nX][24])
	   Elseif nY== 25 .And. !Empty(aDados[nX][25])
   	  	nSoma21+= Val(aDados[nX][25])
     	Elseif nY== 26 .And. !Empty(aDados[nX][26])
	     	nSoma22+= Val(aDados[nX][26])
    	Endif
	Next
 	nLinDet := nLinDet + nTamLin

	If nLinDet >= 2645 .or. nX == Len(aDados)
		If nLinDet >=2645
			oPrn:Say(2700,190,OemToAnsi(STR0046),oFont08b,50) // A Transportar
  		Endif
		oPrn:Say(nLinDet,0890,Transform(nSoma1,cPict1),oFont08,50)
  		oPrn:Say(nLinDet,1010,Transform(nSoma2,cPict1),oFont08,50)
		oPrn:Say(nLinDet,1150,Transform(nSoma3,cPict1),oFont08,50)
		oPrn:Say(nLinDet,1275,Transform(nSoma4,cPict1),oFont08,50)
		oPrn:Say(nLinDet,1415,Transform(nSoma5,cPict1),oFont08,50)
		oPrn:Say(nLinDet,1535,Transform(nSoma6,cPict1),oFont08,50)
		oPrn:Say(nLinDet,1670,Transform(nSoma7,cPict1),oFont08,50)
		oPrn:Say(nLinDet,1795,Transform(nSoma8,cPict1),oFont08,50)
		oPrn:Say(nLinDet,1930,Transform(nSoma9,cPict1),oFont08,50)
		oPrn:Say(nLinDet,2060,Transform(nSoma10,cPict1),oFont08,50)
		oPrn:Say(nLinDet,2190,Transform(nSoma11,cPict1),oFont08,50)
		oPrn:Say(nLinDet,2335,Transform(nSoma12,cPict1),oFont08,50)
		oPrn:Say(nLinDet,2430,Transform(nSoma13,cPict1),oFont08,50)
		oPrn:Say(nLinDet,2495,Transform(nSoma14,cPict1),oFont08,50)
		oPrn:Say(nLinDet,2585,Transform(nSoma15,cPict1),oFont08,50)
		oPrn:Say(nLinDet,2700,Transform(nSoma16,cPict1),oFont08,50)
		oPrn:Say(nLinDet,2875,Transform(nSoma17,cPict1),oFont08,50)
		oPrn:Say(nLinDet,3060,Transform(nSoma18,cPict1),oFont08,50)
		oPrn:Say(nLinDet,3230,Transform(nSoma19,cPict1),oFont08,50)
		oPrn:Say(nLinDet,3400,Transform(nSoma20,cPict1),oFont08,50)
		oPrn:Say(nLinDet,3570,Transform(nSoma21,cPict1),oFont08,50)
		oPrn:Say(nLinDet,3780,Transform(nSoma22,cPict1),oFont08,50)
	 	nLinDet := 2700
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

Static Function Cabec(cAnoRef,nSemRef)
Local nTamLin
Local nLin,  cNumPat := ""
Local cExplot:="Imp.-Vta. de Rulemanes y Rtos. en Gral"
Local nx := 0

nLin	:=	500

SRX->(dbsetorder(1))
If FPHIST82( xFilial("SRX") , "99" , cFilQueb )
   cNumPat := SubStr ( SRX->RX_TXT ,  1 , 10 ) 
Else
	Help(" ",1,"NUMPATRINV")
	Return .F.
	lProcessa	:=	.F.
Endif

//Imprime linhas
For nX:=1 To 40
	If nX == 1
 		oPrn:Line(nLin,100,nLin,4000)
		nLin+=	82
 	ElseIf nX==2
		oPrn:Line(582,730,582,2530)
		oPrn:Line(582,3080,582,3778)
		nLin+=	57
    Else
		oPrn:Line(nLin,100,nLin,4000)
		nLin+=	57
 	Endif
Next
//Imprime Colunas
nCol:= 100
For nX:=1 To 36
	If nX ==1 .or. nX==6 .or. nX==9 .or. nX==12 .or. nX==15 .or. nX==18 .or. nX== 21
		oPrn:Line(500,nCol,2750,nCol)
		nCol+= 80
  	ElseIf nX ==3 .Or. nX ==24
		oPrn:Line(500,nCol,2750,nCol)
		nCol+= 60
	ElseIf  nX==26
		oPrn:Line(500,nCol,2750,nCol)
		nCol+=	100
	ElseIf   nX ==27
		oPrn:Line(500,nCol,2750,nCol)
		nCol+= 140
	ElseIf  nX ==28 .or. nX ==29
		oPrn:Line(500,nCol,2750,nCol)
		nCol+= 180
	ElseIf 	nX ==2
		oPrn:Line(500,nCol,2750,nCol)
		nCol+=	550
	ElseIf 	nX ==35 .or. nX ==36
		oPrn:Line(500,nCol,2750,nCol)
		nCol+=	226
	ElseIf nX==4 .or. nX==7 .or. nX==10 .or. nX==13 .or. nX==16 .or. nX==19 .or. nX==22
		oPrn:Line(641,nCol,2750,nCol)
		nCol+=	170
	ElseIf nX==5 .or. nX==8 .or. nX==11 .or. nX==14 .or. nX==17 .or. nX==20 .or.;
		nX==23 .or. nX== 32 .or. nX== 34
		oPrn:Line(641,nCol,2750,nCol)
		nCol+=	10
	ElseIf nX==30 .or. nX==31  .or. nX = 33
		oPrn:Line(582,nCol,2750,nCol)
		nCol+=	166
	ElseIf nX==25
		oPrn:Line(641,nCol,2750,nCol)
		nCol+=	70
 	Endif
Next

// Empeza la impresion del cabezallo
oPrn:Say(200,1700,OemToAnsi(STR0001),oFont20b,100)   // Sueldos y Jornales
oPrn:Say(350,1300,OemToAnsi(STR0002),oFont12b ,100)   // REGISTRO PATRONAL No
oPrn:Say(350,1850,cNumPat           ,oFont12b ,100)   //                      
oPrn:Say(350,2100,Alltrim(Str(nSemRef))+"o",oFont12b ,100)                  // 1o/2o
oPrn:Say(350,2150,OemToAnsi(STR0003),oFont12b ,100)   // Semetre Ano :
oPrn:Say(350,2550,cAnoRef,oFont12b ,100)

oPrn:Say(250,2900,OemToAnsi(STR0004),oFont10b,100)    // Razon Social o Prp :
oPrn:Say(300,2900,OemToAnsi(STR0005),oFont10b,100)    // Explotacion :
oPrn:Say(350,2900,OemToAnsi(STR0006),oFont10b,100)    // Domicilio :

// Empeza la impresion de los datos de la empresa
nPos := ASCAN(aDescFil,{ |X| X[1] = cFilQueb })
                                   
If nPos > 0
	oPrn:Say(250,3330,aDescFil[nPos,2]     	,oFont10b,100)
	oPrn:Say(300,3230,cExplot 					,oFont10b,100)
	oPrn:Say(350,3230,aDescFil[nPos,3]      ,oFont10b,100)
Endif

oPrn:Say( 520, 105,OemToAnsi(STR0007),oFont09b,50) // N.de
oPrn:Say( 560, 105,OemToAnsi(STR0008),oFont09b,50) // Or-
oPrn:Say( 600, 105,OemToAnsi(STR0009),oFont09b,50) // den
oPrn:Say( 550, 250,OemToAnsi(STR0010),oFont09b,50) // Nombre Y Apellido
oPrn:Say( 510, 800,OemToAnsi(STR0011),oFont09b,50) // SALARIO
oPrn:Say( 510,1060,OemToAnsi(STR0012),oFont09b,50) // Mes de
oPrn:Say( 540,1050,Iif(nSemRef==1,MesExtenso("01"),MesExtenso("07")),oFont09b,50) // enero\julho
oPrn:Say( 510,1310,OemToAnsi(STR0012),oFont09b,50) // Mes de
oPrn:Say( 540,1300,Iif(nSemRef==1,MesExtenso("02"),MesExtenso("08")),oFont09b,50) // enero\julho
oPrn:Say( 510,1560,OemToAnsi(STR0012),oFont09b,50) // Mes de
oPrn:Say( 540,1550,Iif(nSemRef==1,MesExtenso("03"),MesExtenso("09")),oFont09b,50) // enero\julho
oPrn:Say( 510,1830,OemToAnsi(STR0012),oFont09b,50) // Mes de
oPrn:Say( 540,1820,Iif(nSemRef==1,MesExtenso("04"),MesExtenso("10")),oFont09b,50) // enero\julho
oPrn:Say( 510,2110,OemToAnsi(STR0012),oFont09b,50) // Mes de
oPrn:Say( 540,2100,Iif(nSemRef==1,MesExtenso("05"),MesExtenso("11")),oFont09b,50) // enero\julho
oPrn:Say( 510,2370,OemToAnsi(STR0012),oFont09b,50) // Mes de
oPrn:Say( 540,2360,Iif(nSemRef==1,MesExtenso("06"),MesExtenso("12")),oFont09b,50) // enero\julho
oPrn:Say( 580, 730,OemToAnsi(STR0013),oFont08b,50) // Forma de Importe
oPrn:Say( 610, 730,OemToAnsi(STR0014),oFont08b,50) // Pago
oPrn:Say( 610, 855,OemToAnsi(STR0015),oFont08b,50) // unitario
oPrn:Say( 580, 975,OemToAnsi(STR0016),oFont08b,50) // Horas
oPrn:Say( 610, 975,OemToAnsi(STR0017),oFont08b,50) // Trab.
oPrn:Say( 580,1090,OemToAnsi(STR0018),oFont08b,50) // Remuner.
oPrn:Say( 610,1110,OemToAnsi(STR0019),oFont08b,50) // Percib
oPrn:Say( 580,1235,OemToAnsi(STR0016),oFont08b,50) // Horas
oPrn:Say( 610,1235,OemToAnsi(STR0017),oFont08b,50) // Trab.
oPrn:Say( 580,1350,OemToAnsi(STR0018),oFont08b,50) // Remuner.
oPrn:Say( 610,1370,OemToAnsi(STR0019),oFont08b,50) // Percib
oPrn:Say( 580,1495,OemToAnsi(STR0016),oFont08b,50) // Horas
oPrn:Say( 610,1495,OemToAnsi(STR0017),oFont08b,50) // Trab.
oPrn:Say( 580,1610,OemToAnsi(STR0018),oFont08b,50) // Remuner.
oPrn:Say( 610,1650,OemToAnsi(STR0019),oFont08b,50) // Percib
oPrn:Say( 580,1755,OemToAnsi(STR0016),oFont08b,50) // Horas
oPrn:Say( 610,1755,OemToAnsi(STR0017),oFont08b,50) // Trab.
oPrn:Say( 580,1870,OemToAnsi(STR0018),oFont08b,50) // Remuner.
oPrn:Say( 610,1880,OemToAnsi(STR0019),oFont08b,50) // Percib
oPrn:Say( 580,2015,OemToAnsi(STR0016),oFont08b,50) // Horas
oPrn:Say( 610,2015,OemToAnsi(STR0017),oFont08b,50) // Trab.
oPrn:Say( 580,2120,OemToAnsi(STR0018),oFont08b,50) // Remuner.
oPrn:Say( 610,2140,OemToAnsi(STR0019),oFont08b,50) // Percib
oPrn:Say( 580,2275,OemToAnsi(STR0016),oFont08b,50) // Horas
oPrn:Say( 610,2275,OemToAnsi(STR0017),oFont08b,50) // Trab.
oPrn:Say( 580,2390,OemToAnsi(STR0018),oFont08b,50) // Remuner.
oPrn:Say( 610,2400,OemToAnsi(STR0019),oFont08b,50) // Percib
oPrn:Say( 520,2535,OemToAnsi(STR0020),oFont08b,50) // Total Hs
oPrn:Say( 560,2535,OemToAnsi(STR0021),oFont08b,50) // Extras
oPrn:Say( 600,2527,OemToAnsi(STR0022),oFont08b,50) // 50% 100%
oPrn:Say( 510,2665,OemToAnsi(STR0023),oFont08b,50) // IMPOR
oPrn:Say( 540,2670,OemToAnsi(STR0024),oFont08b,50) // TE
oPrn:Say( 570,2665,OemToAnsi(STR0025),oFont08b,50) // HS.Ex-
oPrn:Say( 600,2665,OemToAnsi(STR0026),oFont08b,50) // tras
oPrn:Say( 510,2765,OemToAnsi(STR0027),oFont08b,50) // Tot.hs.en
oPrn:Say( 540,2765,OemToAnsi(STR0028),oFont08b,50) // el semes-
oPrn:Say( 570,2775,OemToAnsi(STR0029),oFont08b,50) // tre incluy.
oPrn:Say( 600,2775,OemToAnsi(STR0030),oFont08b,50) // Hs.ext.
oPrn:Say( 510,2920,OemToAnsi(STR0031),oFont08b,50) // Total de
oPrn:Say( 540,2920,OemToAnsi(STR0032),oFont08b,50) // Salario
oPrn:Say( 570,2920,OemToAnsi(STR0033),oFont08b,50) // Inncluyndo
oPrn:Say( 600,2920,OemToAnsi(STR0034),oFont08b,50) // hs.extras
oPrn:Say( 520,3290,OemToAnsi(STR0035),oFont09b,50) // BENEFICIOS SOCIALES
oPrn:Say( 590,3100,OemToAnsi(STR0036),oFont08b,50) // Aguinaldo
oPrn:Say( 580,3260,OemToAnsi(STR0037),oFont08b,50) // Bonificacion
oPrn:Say( 610,3265,OemToAnsi(STR0038),oFont08b,50) // Fliar
oPrn:Say( 590,3450,OemToAnsi(STR0039),oFont08b,50) // Vacacion
oPrn:Say( 580,3610,OemToAnsi(STR0040),oFont08b,50) // Otros
oPrn:Say( 610,3610,OemToAnsi(STR0041),oFont08b,50) // Beneficios
oPrn:Say( 510,3780,OemToAnsi(STR0042),oFont08b,50) // TOTAL GENERAL
oPrn:Say( 540,3783,OemToAnsi(STR0043),oFont08b,50) // Incluyndo hs.
oPrn:Say( 570,3783,OemToAnsi(STR0044),oFont08b,50) // extras y bene-
oPrn:Say( 600,3783,OemToAnsi(STR0045),oFont08b,50) // ficios sociales

Return

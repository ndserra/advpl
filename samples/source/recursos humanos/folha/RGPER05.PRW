#include "RwMake.ch"
#include "RGPER05.ch"
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
±±ºPrograma  ³RGPER05   ºAutor  ³Silvia Taguti       º Data ³  29/11/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Hace la impresion de Resumem de Personas Ocupadas           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION RGPER05()

Local cString := "SRA"  // alias do arquivo principal (Base)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Private(Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private NomeProg := "RGPER05"
Private cPerg    := "RGPR05"
Private Titulo
Private aCodFol:= {}            

If SRA->(FieldPos('RA_TPOCUP')) == 0
	MsgAlert('Debe ser criado el campo RA_TPOCUP. Entre en contacto con Soporte Microsiga.' )
	Return .F.
Endif

Pergunte("RGPR05",.T.)                     

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
//³ mv_par13        //  Ano Referencia                           ³
//³ mv_par14        //  Semestre                                 ³
//³ mv_par15        //  Ordem                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:="RGPER05"            //Nome Default do relatorio em Disco

RptStatus({|lEnd| GR05Imp(@lEnd,wnRel,cString)},Titulo)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GR05IMP   ºAutor  ³Silvia Taguti       º Data ³  29/11/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatorio                                                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GR05IMP(lEnd,WnRel,cString)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Locais (Programa)                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nLin      := 0
Local aDados    := {}



Local cMatAnt  := Space(6)
Local cSemesAdm := " "
Local cSemesRef := " "
Local cSemesDem := " "
Local cSemesAfas:= " "
Local cAnoAdm:= cAnoDem := "    "
Local aInfo
Private	aDescFil := {} 
Private nNrSupMa := nNrSupFe:=nHrSupMa:=nHrSupFe:=nSalSupMa:=nSalSupFe:= 0
Private nEntSupFe:= nEntSupMa := nSaiSupFe:=nSaiSupMa  := 0

Private nNrEmpMa := nNrEmpFe:= nHrEmpMa:= nHrEmpFe:= nSalEmpMa:= nSalEmpFe:= 0
Private nEntEmpMa:= nEntEmpFe := nSaiEmpFe:= nSaiEmpMa := 0
Private nNrObrMa := nNrObrFe:= nHrObrMa:= nHrObrFe:= nSalObrMa:= nSalObrFe := 0
Private nEntObrMa:= nEntObrFe:= nSaiObrFe:= nSaiObrMa:= 0
Private nNrMenMa := nNrMenFe:= nHrMenMa:= nHrMenFe:= nSalMenMa:= nSalMenFe := 0
Private nEntMenMa:= nEntMenFe:= nSaiMenFe:= nSaiMenMa  := 0
Private nNrTotMa := nNrTotFe:= nHrTotMa:= nHrTotFe:= nSalTotMa:= nSalTotFe := 0
Private nEntTotMa:= nEntTotFe:= nSaiTotFe:= nSaiTotMa  := 0
Private nNrTotGe:= nHrTotGe:= nSalTotGe:= nEntTotGe:= nSaiTotGe:= 0

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
nSemref    := mv_par14
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

if(nSemRef == 1, cSemesRef := "06",cSemesRef := "12")

dbSelectArea("SRA")

While !EOF() .And. &cInicio <= cFim .And.(SRA->RA_FILIAL+SRA->RA_MAT <> cFilialAnt+cMatAnt)
	If SRA->RA_FILIAL <> cFilialAnt .and. cFilialAnt <> Space(FWGETTAMFILIAL)

		nNrTotMa := nNrMenMa + nNrSupMa + nNrEmpMa + nNrObrMa
		nNrTotFe := nNrMenFe + nNrSupFe + nNrEmpFe + nNrObrFe
		nHrTotMa := nHrMenMa + nHrSupMa + nHrEmpMa + nHrObrMa
		nHrTotFe := nHrMenFe + nHrSupFe + nHrEmpFe + nHrObrFe
		nSalTotMa:= nSalMenMa + nSalSupMa + nSalEmpMa + nSalObrMa
		nSalTotFe:= nSalMenFe + nSalSupFe + nSalEmpFe + nSalObrFe
		nEntTotMa:= nEntMenMa + nEntSupMa + nEntEmpMa + nEntObrMa
		nEntTotFe:= nEntMenFe + nEntSupFe + nEntEmpFe + nEntObrFe
		nSaiTotFe:= nSaiMenMa + nSaiSupMa + nSaiEmpMa + nSaiObrMa
		nSaiTotMa :=nSaiMenFe + nSaiSupFe + nSaiEmpFe + nSaiObrFe

		nNrTotGe:= nNrTotMa + nNrTotFe
		nHrTotGe:= nHrTotMa + nHrTotFe
		nSalTotGe:=nSalTotMa + nSalTotFe
		nEntTotGe:=nEntTotMa + nEntTotFe
		nSaiTotGe:=nSaiTotMa + nSaiTotFe

		AADD(aDados,{GetFilxCC(SRA->RA_CC),nNrTotMa,nNrMenMa,nNrSupMa,nNrEmpMa,nNrObrMa,;
		nNrTotFe,nNrMenFe,nNrSupFe,nNrEmpFe,nNrObrFe,nHrTotMa,nHrMenMa,;
		nHrSupMa,nHrEmpMa,nHrObrMa,nHrTotFe,nHrMenFe,nHrSupFe,nHrEmpFe,;
		nHrObrFe,nSalTotMa,nSalMenMa,nSalSupMa,nSalEmpMa,nSalObrMa,nSalTotFe,;
		nSalMenFe,nSalSupFe,nSalEmpFe,nSalObrFe,nEntTotMa,nEntMenMa,nEntSupMa,;
		nEntEmpMa,nEntObrMa,nEntTotFe,nEntMenFe,nEntSupFe,nEntEmpFe,nEntObrFe,;
		nSaiTotFe,nSaiMenMa,nSaiSupMa,nSaiEmpMa,nSaiObrMa,nSaiTotMa,nSaiMenFe,;
		nSaiSupFe,nSaiEmpFe,nSaiObrFe,nNrTotGe,nHrTotGe,nSalTotGe,nEntTotGe,;
		nSaiTotGe})
 		
 		nNrEmpMa := nNrEmpFe:= nHrEmpMa:= nHrEmpFe:= nSalEmpMa:= nSalEmpFe:= 0
		nEntEmpMa:= nEntEmpFe := nSaiEmpFe:= nSaiEmpMa := 0
 		nNrObrMa := nNrObrFe:= nHrObrMa:= nHrObrFe:= nSalObrMa:= nSalObrFe := 0
 		nEntObrMa:= nEntObrFe:= nSaiObrFe:= nSaiObrMa:= 0
 		nNrMenMa := nNrMenFe:= nHrMenMa:= nHrMenFe:= nSalMenMa:= nSalMenFe := 0
 		nEntMenMa:= nEntMenFe:= nSaiMenFe:= nSaiMenMa  := 0
 		nNrTotMa := nNrTotFe:= nHrTotMa:= nHrTotFe:= nSalTotMa:= nSalTotFe := 0
 		nEntTotMa:= nEntTotFe:= nSaiTotFe:= nSaiTotMa  := 0
 		nNrTotGe:= nHrTotGe:= nSalTotGe:= nEntTotGe:= nSaiTotGe:= 0
	Endif
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
	fChkAfas(SRA->RA_FILIAL,SRA->RA_MAT,ctod("01/"+cSemesRef+"/"+cAnoRef),@dDtAfas,@dDtRet,@cTipAfas)
	If cTipAfas $"OPQRXY"
		cTipAfas := "A"
	ElseiF cTipAfas $"HIJKLMNSUV" .Or.;
		(!Empty(SRA->RA_DEMISSA) .And. cAnoRef+cSemesRef >= MesAno(SRA->RA_DEMISSA))
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

	If cSemesAfas+Alltrim(Str(Year(dDtAfas))) > Alltrim(Str(nSemRef)) +cAnoRef
		cTipAfas := " "
	EndIf
	If !Empty(SRA->RA_DEMISSA)
		If Month(SRA->RA_DEMISSA) < 6
			cSemesDem :="1"
		Else
			cSemesDem := "2"
		Endif
		cAnoDem := Alltrim(Str(Year(SRA->RA_DEMISSA)))
	Endif

	If cTipAfas $ "D" .And. cSemesDem+cAnoDem # Alltrim(Str(nSemRef))+cAnoRef  .And.;
		cSemesDem+cAnoDem < Alltrim(Str(nSemRef))+cAnoRef
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
		If ! fInfo(@aInfo,Substr(mv_par03,2,2))
			Exit
		Endif
		AADD(aDescFil,{SRA->RA_FILIAL,aInfo[3],aInfo[4],aInfo[5],aInfo[6]})
		// Nome Completo
		// Endereco Cobranca
		// Cidade Cobranca
		// Estado Cobranca
		dbSelectArea("SRA")
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
	If !Empty(SRA->RA_ADMISSA)
		If Month(SRA->RA_ADMISSA) < 6
			cSemesAdm :="1"
		Else
			cSemesAdm := "2"
		Endif
		cAnoAdm := Alltrim(Str(Year(SRA->RA_ADMISSA)))
	Endif

	If Int((ctod("01/"+cSemesRef+"/"+cAnoRef) - SRA->RA_NASC) / 365) < 18 //Menores
		If SRA->RA_SEXO == "M"
			nNrMenMa  += 1
			nHrMenMa  := nHrMenMa+ SRA->RA_HRSMES
			nSalMenMa := nSalMenMa + SRA->RA_SALARIO
			If cSemesAdm + cAnoAdm == Alltrim(Str(nSemRef)) +cAnoRef
				nEntMenMa += 1
			Endif
			If cSemesDem + cAnoDem == Alltrim(Str(nSemRef)) +cAnoRef
				nSaiMenMa += 1
			Endif
		Else
			nNrMenFe += 1
			nHrMenFe := nHrMenFe+ SRA->RA_HRSMES
			nSalMenFe:= nSalMenFe + SRA->RA_SALARIO
			If cSemesAdm + cAnoAdm == Alltrim(Str(nSemRef)) +cAnoRef
				nEntMenFe += 1
			Endif
			If cSemesDem + cAnoDem == Alltrim(Str(nSemRef)) +cAnoRef
				nSaiMenFe += 1
			Endif
		Endif

	ElseIf SRA->RA_TPOCUP == "1"   //Supervisor
		If SRA->RA_SEXO == "M"
			nNrSupMa  += 1
			nHrSupMa  := nHrSupMa+ SRA->RA_HRSMES
			nSalSupMa := nSalSupMa + SRA->RA_SALARIO
			If cSemesAdm + cAnoAdm == Alltrim(Str(nSemRef)) +cAnoRef
				nEntSupMa += 1
			Endif
			If cSemesDem + cAnoDem == Alltrim(Str(nSemRef)) +cAnoRef
				nSaiSupMa += 1
			Endif
		Else
			nNrSupFe += 1
			nHrSupFe := nHrSupFe+ SRA->RA_HRSMES
			nSalSupFe:= nSalSupFe + SRA->RA_SALARIO
			If cSemesAdm + cAnoAdm == Alltrim(Str(nSemRef)) +cAnoRef
				nEntSupFe += 1
			Endif
			If cSemesDem + cAnoDem == Alltrim(Str(nSemRef)) +cAnoRef
				nSaiSupFe += 1
			Endif
		Endif
	ElseIf SRA->RA_TPOCUP == "2" //Empleado
		If SRA->RA_SEXO == "M"
			nNrEmpMa  += 1
			nHrEmpMa  := nHrEmpMa+ SRA->RA_HRSMES
			nSalEmpMa := nSalEmpMa + SRA->RA_SALARIO
			If cSemesAdm + cAnoAdm == Alltrim(Str(nSemRef)) +cAnoRef
				nEntEmpMa += 1
			Endif
			If cSemesDem + cAnoDem == Alltrim(Str(nSemRef)) +cAnoRef
				nSaiEmpMa += 1
			Endif
		Else
			nNrEmpFe += nNrEmpFe + 1
			nHrEmpFe := nHrEmpFe+ SRA->RA_HRSMES
			nSalEmpFe:= nSalEmpFe + SRA->RA_SALARIO
			If cSemesAdm + cAnoAdm == Alltrim(Str(nSemRef)) +cAnoRef
				nEntEmpFe += 1
			Endif
			If cSemesDem + cAnoDem == Alltrim(Str(nSemRef)) +cAnoRef
				nSaiEmpFe += 1
			Endif
		Endif
	ElseIf SRA->RA_TPOCUP == "3" //Obrero
		If SRA->RA_SEXO == "M"
			nNrObrMa += 1
			nHrObrMa := nHrObrMa+SRA->RA_HRSMES
			nSalObrMa:= nSalObrMa + SRA->RA_SALARIO
			If cSemesAdm + cAnoAdm == Alltrim(Str(nSemRef)) +cAnoRef
				nEntObrMa += 1
			Endif
			If cSemesDem + cAnoDem == Alltrim(Str(nSemRef)) +cAnoRef
				nSaiObrMa += 1
			Endif
		Else
			nNrObrFe +=  1
			nHrObrFe := nHrObrFe+SRA->RA_HRSMES
			nSalObrFe:= nSalObrFe + SRA->RA_SALARIO
			If cSemesAdm + cAnoAdm == Alltrim(Str(nSemRef)) +cAnoRef
				nEntObrFe +=  1
			Endif
			If cSemesDem + cAnoDem == Alltrim(Str(nSemRef)) +cAnoRef
				nSaiObrFe += 1
			Endif
		Endif
	Endif
	cMatAnt := SRA->RA_MAT
	cFilialAnt := SRA->RA_FILIAL
	cSemAdm := cSemDem := " "
	cAnoAdm := cAnoDem := "    "
	dbSelectArea("SRA")
	dbSkip()

Enddo


nNrTotMa := nNrMenMa + nNrSupMa + nNrEmpMa + nNrObrMa
nNrTotFe := nNrMenFe + nNrSupFe + nNrEmpFe + nNrObrFe
nHrTotMa := nHrMenMa + nHrSupMa + nHrEmpMa + nHrObrMa
nHrTotFe := nHrMenFe + nHrSupFe + nHrEmpFe + nHrObrFe
nSalTotMa:= nSalMenMa + nSalSupMa + nSalEmpMa + nSalObrMa
nSalTotFe:= nSalMenFe + nSalSupFe + nSalEmpFe + nSalObrFe
nEntTotMa:= nEntMenMa + nEntSupMa + nEntEmpMa + nEntObrMa
nEntTotFe:= nEntMenFe + nEntSupFe + nEntEmpFe + nEntObrFe
nSaiTotFe:= nSaiMenMa + nSaiSupMa + nSaiEmpMa + nSaiObrMa
nSaiTotMa :=nSaiMenFe + nSaiSupFe + nSaiEmpFe + nSaiObrFe
nNrTotGe:= nNrTotMa + nNrTotFe
nHrTotGe:= nHrTotMa + nHrTotFe
nSalTotGe:=nSalTotMa + nSalTotFe
nEntTotGe:=nEntTotMa + nEntTotFe
nSaiTotGe:=nSaiTotMa + nSaiTotFe

AADD(aDados,{GetFilxCC(SRA->RA_CC),nNrTotMa,nNrMenMa,nNrSupMa,nNrEmpMa,nNrObrMa,;
	nNrTotFe,nNrMenFe,nNrSupFe,nNrEmpFe,nNrObrFe,nHrTotMa,nHrMenMa,;
	nHrSupMa,nHrEmpMa,nHrObrMa,nHrTotFe,nHrMenFe,nHrSupFe,nHrEmpFe,;
	nHrObrFe,nSalTotMa,nSalMenMa,nSalSupMa,nSalEmpMa,nSalObrMa,nSalTotFe,;
	nSalMenFe,nSalSupFe,nSalEmpFe,nSalObrFe,nEntTotMa,nEntMenMa,nEntSupMa,;
	nEntEmpMa,nEntObrMa,nEntTotFe,nEntMenFe,nEntSupFe,nEntEmpFe,nEntObrFe,;
	nSaiTotFe,nSaiMenMa,nSaiSupMa,nSaiEmpMa,nSaiObrMa,nSaiTotMa,nSaiMenFe,;
	nSaiSupFe,nSaiEmpFe,nSaiObrFe,nNrTotGe,nHrTotGe,nSalTotGe,nEntTotGe,;
	nSaiTotGe})

aSort(aDados,,,{|x,y| x[1] < y[1]})
If Len(aDados) > 0
   Cabec(aDados)
Endif
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

Static Function Cabec(aDados)
           
Local cNumPat:=""
Local cExplot:="Imp.-Vta. de Rulemanes y Rtos. en Gral"
Local nX:=0
Local ny := 0

// Crea los objetos con las configuraciones de fuentes
oFont08  := TFont():New( "Times New Roman",,08,,.f.,,,,,.f. )
oFont08b := TFont():New( "Times New Roman",,08,,.t.,,,,,.f. )
oFont10  := TFont():New( "Times New Roman",,10,,.f.,,,,,.f. )
oFont10b := TFont():New( "Times New Roman",,10,,.t.,,,,,.f. )
oFont10b := TFont():New( "Times New Roman",,10,,.t.,,,,,.f. )
oFont11b := TFont():New( "Times New Roman",,11,,.t.,,,,,.f. )
oFont12  := TFont():New( "Times New Roman",,12,,.f.,,,,,.f. )
oFont12B := TFont():New( "Times New Roman",,12,,.t.,,,,,.f. )
oFont13  := TFont():New( "Times New Roman",,13,,.f.,,,,,.f. )
oFont13b := TFont():New( "Times New Roman",,13,,.t.,,,,,.f. )
oFont15b := TFont():New( "Times New Roman",,15,,.t.,,,,,.f. )
oFont18B := TFont():New( "Times New Roman",,18,,.t.,,,,,.f. )
oFont18BS:= TFont():New( "Times New Roman",,18,,.t.,,,,,.t. )
oFont20bs:= TFont():New( "Times New Roman",,20,,.t.,,,,,.t. )
oFont22b := TFont():New( "Times New Roman",,22,,.t.,,,,,.f. )


// Crea un nuevo objeto para impresion
oPrn := TMSPrinter():New()
oPrn:SetLandscape()

// Mostra la pentalla de Setup
oPrn:Setup()

// Mostra la pentalla de Setup
oPrn:SetLandscape()

For nY := 1 to Len(aDados)
	SRX->(dbsetorder(1))
	If FPHIST82( xFilial("SRX") , "99",aDados[nY][1])
		cNumPat := SubStr ( SRX->RX_TXT ,  1 , 10 ) 
	Else
		Help(" ",1,"NUMPATRINV")
		lProcessa	:=	.F.
	Endif

// Inicia un nueva pagina
oPrn:StartPage()

// Imprime la inicializacon de la impresora
oPrn:Say(20,20," ",oFont12,100)
nLin	:=	680

//Imprime linhas
For nX:=1 To 9
	If nX==2
		oPrn:Line(757,410,757,3976)
		nLin+=	100
	ElseIf nX == 3
		oPrn:Line(857,410,857,3646)
		nLin+=	100
	Else
		oPrn:Line(nLin,100,nLin,3976)
		nLin+=	100
	Endif
Next
//Imprime Colunas
nCol:= 100
For nX:=1 To 13
	If	nX == 1 .Or. nX == 2 .Or. nX == 10 .Or. nX ==13
		oPrn:Line(680,nCol,1480,nCol)
		nCol+=	310
	ElseIf nX<> 13 .And. nX <> 1 .And. Mod(nX,2) > 0
		oPrn:Line(857,nCol,1480,nCol)
		nCol+=	325
	Else
		oPrn:Line(757,nCol,1480,nCol)
		nCol+=	329
	Endif
Next

// Empeza la impresion del cabezallo
oPrn:Say(300,1100,OemToAnsi(STR0001),oFont18bs,100)   // Resumen de Personas Ocupadas
oPrn:Say(250,3300,OemToAnsi(STR0002),oFont18b,100)    // R.G.P.
oPrn:Say(425,0120,OemToAnsi(STR0003),oFont15b,100)    // Semestre
oPrn:Say(425,0390,Alltrim(Str(nSemRef))+"o",oFont15b,100)    // Semestre
oPrn:Say(425,0590,OemToAnsi(STR0004),oFont15b,100)    // Ano
oPrn:Say(425,0750,cAnoRef,oFont15b,100)    // Ano
oPrn:Say(425,0900,OemToAnsi(STR0005),oFont15b,100)    // Registro Patronal N. :
oPrn:Say(485,0120,OemToAnsi(STR0006),oFont15b,100)    // Razon Social-Empleador
oPrn:Say(485,1300,OemToAnsi(STR0007),oFont15b,100)    // -Sucursal N.
oPrn:Say(485,1700,OemToAnsi(STR0008),oFont15b,100)    // Rama de Actividad
oPrn:Say(545,0120,OemToAnsi(STR0009),oFont15b,100)    // Localidad
oPrn:Say(545,0700,OemToAnsi(STR0010),oFont15b,100)    // Domicilio
oPrn:Say(545,1600,OemToAnsi(STR0011),oFont15b,100)    // Departamento

nPos := ASCAN(aDescFil,{ |X| X[1] = aDados[nY][1] }) 

// Empeza la impresion de los datos de la empresa
If nPos > 0
	oPrn:Say(485,1600,aDescFil[nPos,1]               	,oFont15b,100)
	oPrn:Say(485,0700,Substr(aDescFil[nPos,2],1,30) ,oFont15b,100)
	oPrn:Say(545,0350,Substr(aDescFil[nPos,4],1,13)	,oFont15b,100)
	oPrn:Say(545,0980,Substr(aDescFil[nPos,3],1,25) ,oFont15b,100)
	oPrn:Say(545,2000,aDescFil[nPos,5]               ,oFont15b,100)
Endif
oPrn:Say(425,1550,cNumPat                         	,oFont15b,100)
oPrn:Say(485,2150,cExplot                         	,oFont15b,100)

oPrn:Say( 700,1110,OemToAnsi(STR0012),oFont13b,50) // DISCRIMINACION DE PERSONAS OCUPADAS
oPrn:Say( 700,3310,OemToAnsi(STR0013),oFont13b,50) // PERSONAS OCUPADAD
oPrn:Say( 770, 730,OemToAnsi(STR0014),oFont13b,50) // 1
oPrn:Say( 770,1410,OemToAnsi(STR0015),oFont13b,50) // 2
oPrn:Say( 770,2020,OemToAnsi(STR0016),oFont13b,50) // 3
oPrn:Say( 770,2610,OemToAnsi(STR0017),oFont13b,50) // 4
oPrn:Say( 770,3280,OemToAnsi(STR0018),oFont13b,50) // 5
oPrn:Say( 770,3820,OemToAnsi(STR0019),oFont13b,50) // 6

oPrn:Say( 805,0480,OemToAnsi(STR0020),oFont13b,50) //Supervisores Jefes
oPrn:Say( 805,1180,OemToAnsi(STR0021),oFont13b,50) //Empleados
oPrn:Say( 805,1910,OemToAnsi(STR0022),oFont13b,50) //Obreros
oPrn:Say( 805,2490,OemToAnsi(STR0023),oFont13b,50) //Menores
oPrn:Say( 805,3130,OemToAnsi(STR0024),oFont13b,50) //Totales

oPrn:Say( 930,0500,OemToAnsi(STR0025),oFont12b,50) //VARONES
oPrn:Say( 930,0830,OemToAnsi(STR0026),oFont12b,50) //MUJERES
oPrn:Say( 930,1150,OemToAnsi(STR0025),oFont12b,50) //VARONES
oPrn:Say( 930,1480,OemToAnsi(STR0026),oFont12b,50) //MUJERES
oPrn:Say( 930,1800,OemToAnsi(STR0025),oFont12b,50) //VARONES
oPrn:Say( 930,2100,OemToAnsi(STR0026),oFont12b,50) //MUJERES
oPrn:Say( 930,2420,OemToAnsi(STR0025),oFont12b,50) //VARONES
oPrn:Say( 930,2730,OemToAnsi(STR0026),oFont12b,50) //MUJERES
oPrn:Say( 930,3060,OemToAnsi(STR0025),oFont12b,50) //VARONES
oPrn:Say( 930,3390,OemToAnsi(STR0026),oFont12b,50) //MUJERES
oPrn:Say( 870,3655,OemToAnsi(STR0027),oFont13b,50) //Total General

oPrn:Say( 1030,120,OemToAnsi(STR0028),oFont13b,50) //Numero
oPrn:Say( 1080,120,OemToAnsi(STR0029),oFont13b,50) //Horas
oPrn:Say( 1130,120,OemToAnsi(STR0030),oFont13b,50) //Trabajadas
oPrn:Say( 1185,120,OemToAnsi(STR0031),oFont13b,50) //Sueldo
oPrn:Say( 1235,120,OemToAnsi(STR0032),oFont13b,50) //o Salario
oPrn:Say( 1330,120,OemToAnsi(STR0033),oFont13b,50) // Entrados
oPrn:Say( 1430,120,OemToAnsi(STR0034),oFont13b,50) // Salidos

oPrn:Say( 1025, 510,Alltrim(Str(aDados[nY][04])),oFont13,50)
oPrn:Say( 1025, 840,Alltrim(Str(aDados[nY][09])),oFont13,50)
oPrn:Say( 1025,1160,Alltrim(Str(aDados[nY][05])),oFont13,50)
oPrn:Say( 1025,1490,Alltrim(Str(aDados[nY][10])),oFont13,50)
oPrn:Say( 1025,1810,Alltrim(Str(aDados[nY][06])),oFont13,50)
oPrn:Say( 1025,2110,Alltrim(Str(aDados[nY][11])),oFont13,50)
oPrn:Say( 1025,2430,Alltrim(Str(aDados[nY][03])),oFont13,50)
oPrn:Say( 1025,2740,Alltrim(Str(aDados[nY][08])),oFont13,50)
oPrn:Say( 1025,3070,Alltrim(Str(aDados[nY][02])),oFont13,50)
oPrn:Say( 1025,3400,Alltrim(Str(aDados[nY][07])),oFont13,50)
oPrn:Say( 1025,3710,Alltrim(Str(aDados[nY][52])),oFont13,50)

oPrn:Say( 1125, 510,Alltrim(Str(aDados[nY][14])),oFont13,50)
oPrn:Say( 1125, 840,Alltrim(Str(aDados[nY][19])),oFont13,50)
oPrn:Say( 1125,1160,Alltrim(Str(aDados[nY][15])),oFont13,50)
oPrn:Say( 1125,1490,Alltrim(Str(aDados[nY][20])),oFont13,50)
oPrn:Say( 1125,1810,Alltrim(Str(aDados[nY][16])),oFont13,50)
oPrn:Say( 1125,2110,Alltrim(Str(aDados[nY][21])),oFont13,50)
oPrn:Say( 1125,2430,Alltrim(Str(aDados[nY][13])),oFont13,50)
oPrn:Say( 1125,2740,Alltrim(Str(aDados[nY][18])),oFont13,50)
oPrn:Say( 1125,3070,Alltrim(Str(aDados[nY][12])),oFont13,50)
oPrn:Say( 1125,3400,Alltrim(Str(aDados[nY][17])),oFont13,50)
oPrn:Say( 1125,3710,Alltrim(Str(aDados[nY][53])),oFont13,50)

oPrn:Say( 1230, 510,Alltrim(Str(aDados[nY][24])),oFont13,50)
oPrn:Say( 1230, 840,Alltrim(Str(aDados[nY][29])),oFont13,50)
oPrn:Say( 1230,1160,Alltrim(Str(aDados[nY][25])),oFont13,50)
oPrn:Say( 1230,1490,Alltrim(Str(aDados[nY][30])),oFont13,50)
oPrn:Say( 1230,1810,Alltrim(Str(aDados[nY][26])),oFont13,50)
oPrn:Say( 1230,2110,Alltrim(Str(aDados[nY][31])),oFont13,50)
oPrn:Say( 1230,2430,Alltrim(Str(aDados[nY][23])),oFont13,50)
oPrn:Say( 1230,2740,Alltrim(Str(aDados[nY][28])),oFont13,50)
oPrn:Say( 1230,3070,Alltrim(Str(aDados[nY][22])),oFont13,50)
oPrn:Say( 1230,3400,Alltrim(Str(aDados[nY][27])),oFont13,50)
oPrn:Say( 1230,3710,Alltrim(Str(aDados[nY][54])),oFont13,50)

oPrn:Say( 1325, 510,Alltrim(Str(aDados[nY][34])),oFont13,50)
oPrn:Say( 1325, 840,Alltrim(Str(aDados[nY][39])),oFont13,50)
oPrn:Say( 1325,1160,Alltrim(Str(aDados[nY][35])),oFont13,50)
oPrn:Say( 1325,1490,Alltrim(Str(aDados[nY][40])),oFont13,50)
oPrn:Say( 1325,1810,Alltrim(Str(aDados[nY][36])),oFont13,50)
oPrn:Say( 1325,2110,Alltrim(Str(aDados[nY][41])),oFont13,50)
oPrn:Say( 1325,2430,Alltrim(Str(aDados[nY][33])),oFont13,50)
oPrn:Say( 1325,2740,Alltrim(Str(aDados[nY][38])),oFont13,50)
oPrn:Say( 1325,3070,Alltrim(Str(aDados[nY][32])),oFont13,50)
oPrn:Say( 1325,3400,Alltrim(Str(aDados[nY][37])),oFont13,50)
oPrn:Say( 1325,3710,Alltrim(Str(aDados[nY][55])),oFont13,50)

oPrn:Say( 1425, 510,Alltrim(Str(aDados[nY][44])),oFont13,50)
oPrn:Say( 1425, 840,Alltrim(Str(aDados[nY][49])),oFont13,50)
oPrn:Say( 1425,1160,Alltrim(Str(aDados[nY][45])),oFont13,50)
oPrn:Say( 1425,1490,Alltrim(Str(aDados[nY][50])),oFont13,50)
oPrn:Say( 1425,1810,Alltrim(Str(aDados[nY][46])),oFont13,50)
oPrn:Say( 1425,2110,Alltrim(Str(aDados[nY][51])),oFont13,50)
oPrn:Say( 1425,2430,Alltrim(Str(aDados[nY][43])),oFont13,50)
oPrn:Say( 1425,2740,Alltrim(Str(aDados[nY][48])),oFont13,50)
oPrn:Say( 1425,3070,Alltrim(Str(aDados[nY][42])),oFont13,50)
oPrn:Say( 1425,3400,Alltrim(Str(aDados[nY][47])),oFont13,50)
oPrn:Say( 1425,3710,Alltrim(Str(aDados[nY][56])),oFont13,50)

oPrn:Say( 1680,3070,"Digite aca su Contador",oFont15b,50)
oPrn:Say( 1755,3070,STR0035,oFont15b,50)

// Cerra la pagina
oPrn:EndPage()
Next

// Mostra la pentalla de preview
oPrn:Preview()

Return


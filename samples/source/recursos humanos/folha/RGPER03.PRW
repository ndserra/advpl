#include "RwMake.ch"
#include "rgper03.ch"
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
±±ºPrograma  ³RGPER03   ºAutor  ³Silvia Taguti       º Data ³  23/11/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Hace la impresion de los libros de Empleados Y Obreros      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User FUNCTION RGPER03()

Local cString := "SRA"  // alias do arquivo principal (Base)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Private(Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private NomeProg := "RGPER03"
Private cPerg    := "RGPR03"
Private Titulo
Private aCodFol:= {}

pergunte("RGPR03",.T.)

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
wnrel:="RGPER03"            //Nome Default do relatorio em Disco

RptStatus({|lEnd| GR03Imp(@lEnd,wnRel,cString)},Titulo)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GR03IMP   ºAutor  ³Microsiga           º Data ³  11/20/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatorio                                                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GR03IMP(lEnd,WnRel,cString)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Locais (Programa)                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nLin      := 0
Local aDados    := {}
Local cNome
Local cEndereco
Local cNaciona
Local nIdade    := 0
Local cEstCivil
Local nFilhos   := 0
Local dDtNasc   := ctod("")
Local cSitEscol := Space(10)
Local cCertCap  := Space(12)
Local nHorTrab  := Space(18)
Local cProf     := Space(10)
Local cCargo
Local dDtAdmiss := ctod("")
Local dDtDemiss := ctod("")
Local cObserv  := Space(30)
Local cMatAnt  := Space(6)
Local cSemesRef := "  "
Local cSemesAfas := " "
Local cSemesDem := " "
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
Iif(nSemRef == 1, cSemesRef := "06",cSemesRef := "12")

dbSelectArea("SRA")

While !EOF() .And. &cInicio <= cFim .And.(SRA->RA_FILIAL+SRA->RA_MAT <> cFilialAnt+cMatAnt)
	If (SRA->RA_FILIAL+SRA->RA_MAT <> cFilialAnt+cMatAnt)
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
	   	If Month(SRA->RA_DEMISSA)< 6
          	cSemesDem := "1"
       	Else
          	cSemesDem := "2"
       	Endif
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

		If cTipAFas $ "D" .And. cSemesDem+Alltrim(Str(Year(SRA->RA_DEMISSA))) # cSemesRef+cAnoRef
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

    	cNome := SRA->RA_NOME
    	cEndereco := SRA->RA_ENDEREC+" "+SRA->RA_COMPLEM
    	cNaciona  := fDesc("SX5","34"+SRA->RA_NACIONA,"X5DESCRI()")
    	If !Empty(SRA->RA_NASC)
       	nIdade    := Int((ctod("01/"+cSemesRef+"/"+cAnoRef) - SRA->RA_NASC) / 365)
    	Endif
    	cEstCivil := fDesc("SX5","33"+SRA->RA_ESTCIVI,"X5DESCRI()")

    	DbSelectArea("SRB")
    	DbSeek( SRA->RA_FILIAL+SRA->RA_MAT)
    	While !Eof() .And.(SRA->RA_FILIAL+SRA->RA_MAT == SRB->RB_FILIAL+SRB->RB_MAT)
     		If Int((ctod("01/"+cSemesRef+"/"+cAnoRef) - SRB->RB_DTNASC) / 365) < 18
       		nFilhos := nFilhos + 1
			Endif
			dbSelectArea("SRB")
		  	dbSkip()
		Enddo
    	If Int((ctod("01/"+cSemesRef+"/"+cAnoRef) - SRA->RA_NASC) / 365) < 18
       	dDtNasc := dtoc(SRA->RA_NASC)
	   	cSitEscol := fDesc("SX5","26"+SRA->RA_GRINRAI,"X5DESCRI()")
  			//   cCertCap  :=
       	nHorTrab  := " "
    	Endif
  		//   cProf  :=
		cCargo := fDesc("SRJ",SRA->RA_CODFUNC,"SRJ->RJ_DESC")
		dDtAdmiss := dtoc(SRA->RA_ADMISSA)
		dDtDemiss := dtoc(SRA->RA_DEMISSA)
  		If cTipAfas == "D"
	   	DbselectArea("SRG")
	   	If DbSeek( SRA->RA_FILIAL+SRA->RA_MAT)
	      	If !Empty(SRG->RG_TIPORES)
              	cObserv := Subst(fDesc("SRX","61"+SRG->RG_TIPORES,"RX_TXT",,SRA->RA_FILIAL),1,30)
          	Endif
       	Endif
    	Endif
		If SRA->RA_SITFOLH == "T" .AND. ( SRA->RA_SITFOLH $ cSituacao )
	   	cObserv := fDesc("SX5","31"+SRA->RA_SITFOLH,"X5DESCRI()")
		Endif
		cFilialAnt := SRA->RA_FILIAL
		cMatAnt := SRA->RA_MAT
	Endif
 	If Empty(dDtNasc)
  		dDtNasc := Space(08)
  	Endif
   If Empty(dDtAdmiss)
   	dDtAdmiss := Space(08)
 	Endif
 	If Empty(dDtDemiss)
  		dDtDemiss := Space(08)
 	Endif
   AaDd(aDados,{GetFilxCC(SRA->RA_CC),Substr(cNome,1,28),Substr(cEndereco,1,27),Substr(cNaciona,1,9),Alltrim(str(nIdade)),;
   	Substr(cEstCivil,1,3),Alltrim(str(nFilhos)),dDtNasc,Substr(cSitEscol,1,7),cCertCap,alltrim(nHorTrab),;
    	cProf,Substr(cCargo,1,8),dDtAdmiss,dDtDemiss,cObserv})
     	nFilhos := 0
      cSitEscol := Space(10)
      nHorTrab  := space(18)
		cObserv   := Space(30)
  		dDtAdmiss := dDtDemiss := dDtNasc :=  ctod("")

	dbSelectArea("SRA")
	dbSkip()
Enddo
aSort(aDados,,,{|x,y| x[1] < y[1]})
Libro1(aDados,cAnoRef,nSemRef)  	// Funcao que monta o cabecalho

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Libro1    ºAutor  ³Silvia Taguti       º Data ³  23/11/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Impressao do Relatorio                                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Libro1(aDados,cAnoRef,nSemRef)
Local nX, nY, nLinDet, nTamLin
Local aColunas := {}
Local nNumero := 0
Private cFilQueb 

// Crea los objetos con las configuraciones de fuentes
oFont08  := TFont():New( "Arial",,08,,.f.,,,,,.f. )
oFont08b := TFont():New( "Arial",,08,,.t.,,,,,.f. )
oFont09  := TFont():New( "Arial",,09,,.f.,,,,,.f. )
oFont10  := TFont():New( "Arial",,10,,.f.,,,,,.f. )
oFont10b := TFont():New( "Arial",,10,,.t.,,,,,.f. )
oFont10b := TFont():New( "Arial",,10,,.t.,,,,,.f. )
oFont11  := TFont():New( "Arial",,11,,.f.,,,,,.f. )
oFont11b := TFont():New( "Arial",,11,,.t.,,,,,.f. )
oFont12  := TFont():New( "Arial",,12,,.f.,,,,,.f. )
oFont12BI:= TFont():New( "Arial",,12,,.t.,,,,,.t. )
oFont24b := TFont():New( "Arial",,24,,.t.,,,,,.f. )


// Crea un nuevo objeto para impresion
oPrn := TMSPrinter():New()

// Inicia un nueva pagina
oPrn:StartPage()

// Imprime la inicializacon de la impresora
oPrn:Say(20,20," ",oFont12,100)

aColunas := {0,150,810,1410,1630,1700,1810,1880,2030,2250,2390,2500,2835,3050,3240,3400}
nLinTot := 1
nLinDet := 3500
nTamLin := 55
cFilQueb := Space(FWGETTAMFILIAL)

For nX := nLinTot to Len(aDados)
	If cFilQueb <> aDados[nX][1] .and. cFilQueb <> Space(FWGETTAMFILIAL) 
		cFilQueb := aDados[nX][1] 
		nNumero := 0
  		oPrn:EndPage()
      nLinDet := 3500
 	Endif   
  	If nLinDet > 2915
   	// Inicia un nueva pagina
    	oPrn:StartPage()
     	// Imprime la inicializacon de la impresora
      oPrn:Say(20,20," ",oFont12,100)
		cFilQueb := aDados[nX][1]
  		Cabec1(cAnoRef,nSemRef)
    	nLinDet := 528
  	Endif
	nNumero += 1
   oPrn:Say( nLinDet ,055 ,StrZero(nNumero,4),oFont10)
   For nY := 2 to 16
   	If nY == 11
			oPrn:Say( nLinDet ,aColunas[nY],aDados[nX][nY],oFont08)
		Else
  			oPrn:Say( nLinDet ,aColunas[nY],aDados[nX][nY],oFont10)
  		Endif
 	Next
  	nLinDet := nLinDet + nTamLin

	If nLinDet >= 2915 .or. nX == Len(aDados)

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
±±ºPrograma  ³CABEC1    ºAutor  ³Silvia Taguti       º Data ³  23/11/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cabecalho do Relatorio                                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Cabec1(cAnoRef,nSemRef)

Local nTamLin
Local nLin,  cNumPat := ""
Local cExplot:="Imp.-Vta. de Rulemanes y Rtos. en Gral"
Local nLinha := 0

SRX->(dbsetorder(1))
If FPHIST82( xFilial("SRX") , "99" , cFilQueb )
   cNumPat := SubStr ( SRX->RX_TXT ,  1 , 10 ) 
Else
	Help(" ",1,"NUMPATRINV")
	Return .F.
	lProcessa	:=	.F.
Endif

// Empeza la impresion del cabezallo
oPrn:Say(100,1600,OemToAnsi(STR0001),oFont12bi,100)   // Registro de Empleados y Obreros
oPrn:Say(200,1750,OemToAnsi(STR0002),oFont10b ,100)   // Semetre :
oPrn:Say(200,1960,Alltrim(Str(nSemRef))+"o",oFont10b ,100)
oPrn:Say(200,2250,OemToAnsi(STR0035),oFont10b ,100)   // Ano :
oPrn:Say(200,2350,cAnoRef,oFont10b ,100)

oPrn:Say(100,2800,OemToAnsi(STR0005),oFont08b,100)    // Razon Social o Prp :
oPrn:Say(150,2800,OemToAnsi(STR0006),oFont08b,100)    // Explotacion :
oPrn:Say(200,2800,OemToAnsi(STR0007),oFont08b,100)    // Domicilio :
oPrn:Say(250,2800,OemToAnsi(STR0008),oFont08b,100)    // Registro Patronal N. :

nPos := ASCAN(aDescFil,{ |X| X[1] = cFilQueb }) 
// Empeza la impresion de los datos de la empresa
If nPos > 0
	oPrn:Say(100,3160,aDescFil[nPos,2]    ,oFont10b,100)
	oPrn:Say(150,3160,cExplot					,oFont10b,100)
	oPrn:Say(200,3160,aDescFil[nPos,3]    ,oFont10b,100)
	oPrn:Say(250,3160,cNumPat             ,oFont10b,100)
Endif

// Empeza la impresion del cabezallo de la grade
oPrn:Line(298,050,398,3900)
oPrn:Box( 300, 050,2945, 140)  // N.
oPrn:Box( 300, 140,2945, 795)   // Nombra y Apelido

oPrn:Box( 300, 795,2945,1405)   // Domicilio
oPrn:Box( 300,1405,2945,1600)   // Nacionalidad
oPrn:Box( 300,1600,2945,1690)   // Edad

oPrn:Box( 300,1690,2945,1780)   // Estado civil
oPrn:Box( 300,1780,2945,1870)   // N. de Hijos

oPrn:Box( 300,1870, 400,2640)   // Menores
oPrn:Box( 402,1870,2945,2020)   // Fecha de Nascimiento
oPrn:Box( 402,2020,2945,2190)   // Situacion escolar
oPrn:Box( 402,2190,2945,2385)   // Certif. de Cap. Exp. Fecha
oPrn:Box( 402,2385,2945,2640)   // Horario de trabajo

oPrn:Box( 300,2640,2945,2830)   // Professional

oPrn:Box( 300,2830,2945,3030)   // Cargo Desempenhado
oPrn:Box( 300,3030,2945,3230)   // Fecha de Entrada
oPrn:Box( 300,3230,2945,3390)   // Fecha de Salida
oPrn:Box( 300,3390,2945,4000)   // OBSERVACIONES

oPrn:Say( 400, 080,OemToAnsi(STR0003),oFont10b,50) // N.
oPrn:Say( 400, 295,OemToAnsi(STR0009),oFont10b,50) // NOMBRE Y APELIDO
oPrn:Say( 400,1000,OemToAnsi(STR0010),oFont10b,50) // DOMICILIO

oPrn:Say( 400,1435,OemToAnsi(STR0011),oFont10,50) // NACIONA
oPrn:Say( 440,1465,OemToAnsi(STR0012),oFont10,50) // LIDAD

oPrn:Say( 400,1615,OemToAnsi(STR0013),oFont08b,50) // EDAD

oPrn:Say( 400,1713,OemToAnsi(STR0014),oFont08b,50) // EST
oPrn:Say( 425,1703,OemToAnsi(STR0015),oFont08b,50) // CIVIL

oPrn:Say( 400,1793,OemToAnsi(STR0016),oFont08b,50) // N. DE
oPrn:Say( 425,1790,OemToAnsi(STR0017),oFont08b,50) // HIJOS

oPrn:Say( 350,2170,OemToAnsi(STR0018),oFont10b,50) // MENORES
oPrn:Say( 440,1895,OemToAnsi(STR0019),oFont08b,50) // FEC.DE
oPrn:Say( 470,1910,OemToAnsi(STR0020),oFont08b,50) // NAC
oPrn:Say( 440,2050,OemToAnsi(STR0021),oFont08b,50) // SITUAC
oPrn:Say( 470,2035,OemToAnsi(STR0022),oFont08b,50) // ESCOLAR
oPrn:Say( 415,2235,OemToAnsi(STR0023),oFont08b,50) // CERT.DE
oPrn:Say( 450,2245,OemToAnsi(STR0024),oFont08b,50) // CAPAC.
oPrn:Say( 480,2195,OemToAnsi(STR0025),oFont08b,50) // EXP.EN FECHA
oPrn:Say( 440,2445,OemToAnsi(STR0026),oFont08b,50) // HORARIO
oPrn:Say( 470,2418,OemToAnsi(STR0027),oFont08b,50) // DE TRABAJO

oPrn:Say( 400,2655,OemToAnsi(STR0028),oFont08b,50) // PROFECION

oPrn:Say( 400,2850,OemToAnsi(STR0029),oFont08b,50) // CARGO
oPrn:Say( 440,2830,OemToAnsi(STR0030),oFont08b,50) // DESEMPENADO

oPrn:Say( 380,3060,OemToAnsi(STR0031),oFont10b,50) // FECHA
oPrn:Say( 410,3085,OemToAnsi(STR0032),oFont10b,50) // DE
oPrn:Say( 440,3045,OemToAnsi(STR0033),oFont10b,50) // ENTRADA

oPrn:Say( 380,3240,OemToAnsi(STR0031),oFont10b,50) // FECHA
oPrn:Say( 410,3270,OemToAnsi(STR0032),oFont10b,50) // DE
oPrn:Say( 440,3250,OemToAnsi(STR0034),oFont10b,50) // SALIDA
oPrn:Say( 400,3540,OemToAnsi(STR0004),oFont10b,50) // OBSERVACIONES

// Empeza la impresion de las lineas
nLin:=520
nTamLin := 55

For nLinha := 1 to 44
	oPrn:Line(nLin,050,nLin,4000)
	nLin:=nLin+nTamLin
Next

Return


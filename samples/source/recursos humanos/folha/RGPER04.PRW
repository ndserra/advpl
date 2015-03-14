#include "RwMake.ch"
#include "RGPER04.ch"
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
±±ºPrograma  ³RGPER04   ºAutor  ³Silvia Taguti       º Data ³  28/11/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Hace la impresion de los registros de vacaciones anuales    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION RGPER04()

Local cString := "SRA"  // alias do arquivo principal (Base)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Private(Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private NomeProg := "RGPER04"
Private aLinha   := {}
Private nLastKey := 0
Private cPerg    := "RGPR04"
Private Titulo
Private aInfo := {}
Private aCodFol:= {}
Private cPict1	:= TM(9999999999,16,MsDecimais(1))


pergunte("RGPR04",.T.)
 

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
//³ mv_par14        //  Ordem                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:="RGPER04"            //Nome Default do relatorio em Disco

RptStatus({|lEnd| GR04Imp(@lEnd,wnRel,cString)},Titulo)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GR04IMP  ºAutor  ³Silvia Taguti       º Data ³  23/11/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatorio                                                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GR04IMP(lEnd,WnRel,cString)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Locais (Programa)                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nLin      := 0
Local aDados    := {}
Local cNome
Local dDtAdmiss := ctod("")
Local dDtIniF   := ctod("")
Local dDtFimF   := ctod("")
Local nDiasF    := 0
Local nRemuFe   := 0
Local cObserv   := Space(30)
Local cMatAnt  := Space(6)
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

dbSelectArea("SRA")
While !EOF() .And. &cInicio <= cFim.And.(SRA->RA_FILIAL+SRA->RA_MAT <> cFilialAnt+cMatAnt)

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
	If (SRA->RA_CHAPA < cChapaDe) .Or. (SRA->Ra_CHAPa > cChapaAte) .Or. ;
		(SRA->RA_NOME < cNomeDe)    .Or. (SRA->Ra_NOME > cNomeAte)    .Or. ;
		(SRA->RA_MAT < cMatDe)     .Or. (SRA->Ra_MAT > cMatAte)     .Or. ;
		(SRA->RA_CC < cCcDe)       .Or. (SRA->Ra_CC > cCcAte)
		SRA->(dbSkip(1))
		Loop
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o tipo de Afastamento ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cTipAfas := " "
	dDtAfas  := dDtRet := ctod("")
	fChkAfas(SRA->RA_FILIAL,SRA->RA_MAT,ctod("31/12/"+cAnoRef),@dDtAfas,@dDtRet,@cTipAfas)
	If cTipAfas $"OPQRXY"
		cTipAfas := "A"
	ElseiF cTipAfas $"HIJKLMNSUV" .Or.;
		(!Empty(SRA->RA_DEMISSA) .And. cAnoRef >= Alltrim(str(year(SRA->RA_DEMISSA))))
		cTipAfas := "D"
	ElseIf cTipAfas == "F"
		cTipAfas := "F"
	Else
		cTipAfas := " "
	EndIf

	If Alltrim(str(year(dDtAfas))) > cAnoRef
		cTipAfas := " "
	EndIf

	If cTipAFas $ "D" .And. Alltrim(str(year(SRA->RA_DEMISSA))) # cAnoRef
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
	dDtAdmiss := dtoc(SRA->RA_ADMISSA)

	DbSelectArea("SRH")
 	If DbSeek( SRA->RA_FILIAL+SRA->RA_MAT)
  		While !Eof() .And. (SRA->RA_FILIAL+SRA->RA_MAT == SRH->RH_FILIAL+SRH->RH_MAT);
    		.And. cAnoRef == Alltrim(STr(Year(SRH->RH_DATAINI)))
      	cNome := SRA->RA_NOME
	      dDtAdmiss := dtoc(SRA->RA_ADMISSA)

			DbSelectArea("SRR")
    	   IF dbSeek(SRA->RA_FILIAL + SRA->RA_MAT +"F" )
   			While !Eof() .and. (SRA->RA_FIlIAL+SRA->RA_MAT+"F") == (SRR->RR_FILIAL+SRR->RR_MAT+SRR->RR_TIPO3)
	     			IF SRR->RR_DATA == SRH->RH_DTRECIB
         			If SRR->RR_PD $ aCodFol[072,1]+"|"+aCodFol[224,1]
			         	nDiasF  := SRH->RH_DFERIAS
           				dDtIniF := Dtoc(SRH->RH_DATAINI)
		             	dDtFimF := Dtoc(SRH->RH_DATAFIM)
                		nRemuFe += SRR->RR_VALOR
                  	cObserv := ""
               	Endif
   				Endif
       			dbSelectArea("SRR")
			      dbSkip()
				Enddo
			Endif
		 	DbSelectArea("SRH")
    		DbSkip()
   	Enddo
	Endif
 	If Empty(dDtAdmiss)
  		dDtAdmiss := Space(08)
  	Endif
   If Empty(dDtIniF)
   	dDtIniF  := Space(08)
   Endif
   If Empty(dDtFimF)
   	dDtFimF := Space(08)
  	Endif

   AaDd(aDados,{GetFilxCC(SRA->RA_CC),Substr(cNome,1,40),dDtAdmiss,Alltrim(Str(nDiasF)),dDtIniF,;
   	dDtFimF,Alltrim(Str(nRemuFe)),cObserv})

	dDtAdmiss := dDtIniF := dDtFimf := ctod("")
 	nRemuFe := nDiasF := 0
  	cObserv := Space(30)
   cMatAnt := SRA->RA_MAT
   cFilialAnt := SRA->RA_FILIAL
   dbSelectArea("SRA")
	dbSkip()
Enddo

aSort(aDados,,,{|x,y| x[1] < y[1]})
Libro2(aDados,cAnoRef)  	// Funcao que monta o cabecalho

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Libro     ºAutor  ³Silvia TAguti       º Data ³  23/11/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Impressao do Relatorio                                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Libro2(aDados)
Local nX, nY, nLinDet, nTamLin
Local aColunas := {}
Local nNumero := 0
Private cFilQueb

// Crea los objetos con las configuraciones de fuentes
oFont08  := TFont():New( "Times New Roman",,08,,.f.,,,,,.f. )
oFont08b := TFont():New( "Times New Roman",,08,,.t.,,,,,.f. )
oFont10  := TFont():New( "Times New Roman",,10,,.f.,,,,,.f. )
oFont10b := TFont():New( "Times New Roman",,10,,.t.,,,,,.f. )
oFont10b := TFont():New( "Times New Roman",,10,,.t.,,,,,.f. )
oFont11  := TFont():New( "Times New Roman",,11,,.f.,,,,,.f. )
oFont11b := TFont():New( "Times New Roman",,11,,.t.,,,,,.f. ) //negrito(t)
oFont12  := TFont():New( "Times New Roman",,12,,.f.,,,,,.f. )
oFont12B := TFont():New( "Times New Roman",,12,,.t.,,,,,.f. )
oFont18B := TFont():New( "Times New Roman",,18,,.t.,,,,,.f. )
oFont18BS:= TFont():New( "Times New Roman",,18,,.t.,,,,,.t. )
oFont24b := TFont():New( "Times New Roman",,24,,.t.,,,,,.f. )

// Crea un nuevo objeto para impresion
oPrn := TMSPrinter():New()

// Inicia un nueva pagina
oPrn:StartPage()

// Imprime la inicializacon de la impresora
oPrn:Say(20,20," ",oFont12,100)

aColunas := {0,310,1410,1780,2150,2500,3000,3330}
nLinTot := 1
nLinDet := 3500
nTamLin := 65
cFilQueb := Space(FWGETTAMFILIAL)

For nX := nLinTot to Len(aDados)
	If cFilQueb <> aDados[nX][1] .and. cFilQueb <> Space(FWGETTAMFILIAL) 
		cFilQueb := aDados[nX][1] 
	 	nNumero := 0
  		oPrn:EndPage()
      nLinDet := 3150
 	Endif
  	If nLinDet > 3110
   	// Inicia un nueva pagina
    	oPrn:StartPage()
     	// Imprime la inicializacon de la impresora
      oPrn:Say(20,20," ",oFont12,100)
  		cFilQueb := aDados[nX][1]
    	Cabec2()
     	nLinDet := 823
 	Endif
  	nNumero += 1
   oPrn:Say( nLinDet ,150 ,StrZero(nNumero,4),oFont11)
   For nY := 2 to 8
   	If nY == 7
			oPrn:Say( nLinDet ,aColunas[nY],TRANSFORM(Val(aDados[nX][nY]),cPict1),oFont11)
		Else
  			oPrn:Say( nLinDet ,aColunas[nY],aDados[nX][nY],oFont11)
 		Endif
  	Next
   nLinDet := nLinDet + nTamLin

	If nLinDet >= 3110 .or. nX == Len(aDados)
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
±±ºPrograma  ³CABEC2    ºAutor  ³Silvia Taguti       º Data ³  23/11/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cabecalho do Relatorio                                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Cabec2()

Local nTamLin
Local nLin,cNumPat:=""
Local cExplot:="Imp.-Vta. de Rulemanes y Rtos. en Gral"
Local nLinha := 0

SRX->(dbsetorder(1))
If FPHIST82( xFilial("SRX") , "99",cFilQueb ) 
   cNumPat := SubStr ( SRX->RX_TXT ,  1 , 10 ) 
Else
	Help(" ",1,"NUMPATRINV")
	lProcessa	:=	.F.
Endif

// Empeza la impresion del cabezallo
oPrn:Say(400,1300,OemToAnsi(STR0005),oFont18bs,100)   // Registro de Vacaciones Anuales

oPrn:Say(250,2820,OemToAnsi(STR0001),oFont18b,100)    // Razon Social :
oPrn:Say(320,2820,OemToAnsi(STR0002),oFont18b,100)    // Explotacion :
oPrn:Say(390,2820,OemToAnsi(STR0003),oFont18b,100)    // Domicilio :
oPrn:Say(460,2820,OemToAnsi(STR0004),oFont18b,100)    // Registro Patronal N. :

nPos := ASCAN(aDescFil,{ |X| X[1] = cFilQueb }) 
// Empeza la impresion de los datos de la empresa
If nPos > 0
	oPrn:Say(258,3225,aDescFil[nPos,2]                ,oFont12,100)
	oPrn:Say(393,3215,aDescFil[nPos,3]                ,oFont12,100)
oPrn:Say(328,3225,cExplot                         ,oFont12,100)
oPrn:Say(463,3400,cNumPat                         ,oFont12,100)
Endif

// Empeza la impresion del cabezallo de la grade
oPrn:Line(600,100,600,4000)
oPrn:Line(602,100,602,4000)

oPrn:Box( 605,100,3150,300)   // N. de Ordem
oPrn:Box( 605, 300,3150,1290)   // NOMBRE Y APELIDO
oPrn:Box( 605,1290,3150,1700)   // FECHA DE ENTRADA

oPrn:Box( 605,1700, 680,2800)   // DURACION DE VACACIONES
oPrn:Box( 683,1700,3150,2020)   // DIA
oPrn:Box( 683,2020,3150,2410)   // DESDE
oPrn:Box( 683,2410,3150,2800)   // HASTA

oPrn:Box( 605,2800,3150,3300)   // REMUNERACION
oPrn:Box( 605,3300,3150,4000)   // OBSERVACIONES

oPrn:Say( 650, 180,OemToAnsi(STR0006),oFont12b,50) // N.
oPrn:Say( 700, 170,OemToAnsi(STR0007),oFont12b,50) // DE
oPrn:Say( 750, 130,OemToAnsi(STR0008),oFont12b,50) // Orden

oPrn:Say( 700, 550,OemToAnsi(STR0009),oFont12b,50) //  NOMBRE Y APELIDO

oPrn:Say( 650,1430,OemToAnsi(STR0010),oFont12b,50)        // FECHA
oPrn:Say( 700,1475,Upper(OemToAnsi(STR0007)),oFont12b,50) // DE
oPrn:Say( 750,1400,OemToAnsi(STR0011),oFont12b,50)        // ENTRADA

oPrn:Say( 630,1950,OemToAnsi(STR0012),oFont12b,50) // DURACION DE VACACIONES
oPrn:Say( 750,1810,OemToAnsi(STR0013),oFont12b,50) // DIA
oPrn:Say( 750,2170,OemToAnsi(STR0014),oFont12b,50) // DESDE
oPrn:Say( 750,2550,OemToAnsi(STR0015),oFont12b,50) // HASTA
oPrn:Say( 700,2900,OemToAnsi(STR0016),oFont12b,50) // REMUNERACION
oPrn:Say( 700,3500,OemToAnsi(STR0017),oFont12b,50) // OBSERVACIONES

// Empeza la impresion de las lineas
nLin:=820
nTamLin := 65

For nLinha := 1 to 36
	oPrn:Line(nLin,100,nLin,4000)
	nLin:=nLin+nTamLin
Next

Return


#include "RwMake.ch"
#include "RGPER08.ch"
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
±±ºPrograma  ³RGPER08   ºAutor  ³Silvia Taguti       º Data ³  16/06/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Hace la impresion de Informe de Liquidacion                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION RGPER08()

Local cString := "SRA"  // alias do arquivo principal (Base)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Private(Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private NomeProg := "RGPER08"
Private cPerg    := "RGPR08"
Private Titulo
Private aCodFol:= {}
Private cPict1	:= TM(9999999999,16,MsDecimais(1))
Private cPict2	:= PesqPict("SRC","RC_HORAS",10)

pergunte("RGPR08",.T.)

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
//³ mv_par11        //  Categorias                               ³
//³ mv_par12        //  Data de Demissao                         ³
//³ mv_par13        //  semana                                   ³
//³ mv_par14        //  Tipo de Demissao                         ³
//³ mv_par15        //  Nivel de Centro de Custo                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:="RGPER08"            //Nome Default do relatorio em Disco

RptStatus({|lEnd| GPR08Imp(@lEnd,wnRel,cString)},Titulo)

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GR08IMP   ºAutor  ³Silvia Taguti       º Data ³  16/04/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatorio                                                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function GPR08IMP(lEnd,WnRel,cString)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Locais (Programa)                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aInfo	 	:= {}
Local nSubTot := 0              
Local aOrdBag     := {}
Local cArqMov     := ""
Local cAnoMes   
Local cMesAnoRef 
Local dChkDtRef
Local cDataREf  
Local cMapa       := 0
Local nLaco       := 0
Local nByte := 0
Local nQ := 0
Local Nx := 0

Private cMascCus  := GetMv("MV_MASCCUS")
Private aNiveis   := {}
Private cMatr
Private cNome
Private cFPag
Private nSalMes  := 0
Private nSalAno  := 0
Private aDescFil := {}
Private nLinDet   := 2400
Private cSemana
Private nQtdEmpl := 0
Private oPrn := TMSPrinter():New()
Private aFunc 	 := {0,0,0,0,0,0,0,0,0,0,0,0}
Private aSubTot := {0,0,0,0,0,0,0,0,0,0,0,0}
Private aSubCc  := {0,0,0,0,0,0,0,0,0,0,0,0}
Private aTotal  := {0,0,0,0,0,0,0,0,0,0,0,0}
Private cAliasMov     := ""
Private nPag	:= 0
Private lFirst := .T.
Private dDtAdmissa:= ctod("  /  /  ")          
Private nMesesTrab := 0
Private nDiasTrab  := 0
// Crea los objetos con las configuraciones de fuentes
oFont07  := TFont():New( "Times New Roman",,07,,.f.,,,,,.f. )
oFont08  := TFont():New( "Times New Roman",,08,,.f.,,,,,.f. )
oFont08b := TFont():New( "Times New Roman",,08,,.t.,,,,,.f. )
oFont09b := TFont():New( "Times New Roman",,09,,.t.,,,,,.f. )
oFont10b := TFont():New( "Times New Roman",,10,,.t.,,,,,.f. )
oFont12  := TFont():New( "Times New Roman",,12,,.f.,,,,,.f. )
oFont12b := TFont():New( "Times New Roman",,12,,.t.,,,,,.f. )
oFont14  := TFont():New( "Times New Roman",,14,,.f.,,,,,.f. )
oFont14b := TFont():New( "Times New Roman",,14,,.t.,,,,,.f. )
oFont16  := TFont():New( "Times New Roman",,16,,.f.,,,,,.f. )
oFont19b := TFont():New( "Times New Roman",,19,,.t.,,,,,.f. )

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
cCategoria := mv_par11
dDataDem   := mv_par12        //  Data Referencia                          
csemana    := mv_par13        //  Semana                                   
cTipoRes   := mv_par14			// Tipo de Rescisao 
lImpNiv  := If(mv_par15 == 1,.T.,.F.)
nOrdem := 2
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ aNiveis -  Armazena as chaves de quebra.                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lImpNiv
	cMapa := 0
	For nLaco := 1 to 1            //Len( cMascCus )
		nByte := Val( SubStr( cMascCus , nLaco , 1 ) )
		cMapa += nByte
		If nByte > 0
			Aadd( aNiveis, cMapa )
		Endif
	Next
	
	//--Criar os Arrays com os Niveis de Quebras
	For nQ := 1 to Len(aNiveis)
		cQ := STR(NQ,1)
		cCcAnt&cQ       := ""    //Variaveis c.custo dos niveis de quebra
	Next nQ
Endif

dbSelectArea( "SRA" )
dbSetOrder( 2 )
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
cAnoMes    := AnoMes(dDataDem)
cMesAnoRef := StrZero(Month(dDataDem),2) + StrZero(Year(dDataDem),4)
dChkDtRef   := CTOD("01/"+Left(cMesAnoRef,2)+"/"+Right(cMesAnoRef,4),"DDMMYY")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Verifica se existe o arquivo de fechamento do mes informado  |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !OpenSrc( cMesAnoRef, @cAliasMov, @aOrdBag, @cArqMov, dChkDtRef)
	Return .f.
Endif

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
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste  categoria dos funcionarios			     |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If  !( SRA->RA_CATFUNC $ cCategoria )
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
	   dbSelectArea( "SRA" )
	   cFilialAnt := SRA->RA_FILIAL
	Endif
  
   cMatr		 := SRA->RA_MAT
	cNome     := SRA->RA_NOME
 	cFPag 	:= Substr(DescFun(Sra->Ra_Codfunc,Sra->Ra_Filial),1,15)

	If SRA->RA_CATFUNC == "M"
		nSalMes  := SRA->RA_SALARIO
		nSalDia  := SRA->RA_SALARIO / (SRA->RA_HRSMES/SRA->RA_HRSDIA)
	ElseIf SRA->RA_CATFUNC $ "H*T*G"
		nSalMes  := SRA->RA_SALARIO * SRA->RA_HRSMES
		nSalDia  := ( SRA->RA_SALARIO * SRA->RA_HRSDIA)
	ElseIf SRA->RA_CATFUNC $ "D"
		nSalMes  := ( SRA->RA_SALARIO * (SRA->RA_HRSMES/SRA->RA_HRSDIA) )
		nSalDia  := SRA->RA_SALARIO
	Endif
  	nSalAno := nSalMes * 12	
   dDtAdmissa := SRA->RA_ADMISSA

	nMesesTrab:= Int((dDataDem - SRA->RA_ADMISSA) / 30)
	nDiasTrab := dDataDem - SRA->RA_ADMISSA
	If nMesesTrab > 12
		nMesesTrab:= 12.0
	Else	
		nMesesTrab += (nDiasTrab-(nMesesTrab * 30))/100
   Endif
	dbSelectArea("SRG") 
	dbSetOrder(1)
	If dbSeek( SRA->RA_FILIAL + SRA->RA_MAT ) 
		While !Eof() .And. (SRA->RA_FILIAL+SRA->RA_MAT==SRG->RG_FILIAL+SRG->RG_MAT)
 			If(SRA->RA_FILIAL+SRA->RA_MAT==SRG->RG_FILIAL+SRG->RG_MAT) .And.;
 				SRG->RG_DATADEM==dDataDem .And. SRG->RG_TIPORES == cTipoRes 
				If  SRG->RG_SEMANA <> cSemana 
 					DbSkip()
		 			Loop
 				Endif	
  				dbSelectArea("SRR")
				If SRR->( dbSeek( SRA->RA_FILIAL+SRA->RA_MAT+ "R" ) )
					While SRR->( !Eof() .And. ( SRA->RA_FILIAL+SRA->RA_MAT + "R" ) == ( RR_FILIAL + RR_MAT + RR_TIPO3 ) )
						If ( SRR->RR_DATA == SRG->RG_DTGERAR )
		  	 				If PosSrv(SRR->RR_PD,SRR->RR_FILIAL,"RV_TIPOCOD") == "1"
								If SRR->RR_PD == aCodFol[110,1] 									//Cesantia
		      	   			aFunc[01] := (SRR->RR_HORAS/SRA->RA_HRSDIA)
									aFunc[02] := SRR->RR_VALOR             			
		   				  	ElseIf SRR->RR_PD $ aCodFol[024,1]+"|"+ aCodFol[025,1]	//Salario Navidad
		      	   			aFunc[03] := SRR->RR_HORAS
	   		  					aFunc[04] := SRR->RR_VALOR
 							   ElseIf SRR->RR_PD $ aCodFol[072,1]+"|"+ aCodFol[087,1]+"|"+aCodFol[086,1] //Vacaciones  
		      	   			aFunc[05] := (SRR->RR_HORAS/SRA->RA_HRSDIA)
			   					aFunc[06] := SRR->RR_VALOR
								Else
		      	   			aFunc[07] := (SRR->RR_HORAS/SRA->RA_HRSDIA)
									aFunc[08] := SRR->RR_VALOR	           				//Outros Proventos
								Endif
							ElseIf PosSrv(SRR->RR_PD,SRR->RR_FILIAL,"RV_TIPOCOD") == "2" .And.;
									SRR->RR_PD <> aCodFol[126,1]
			     					aFunc[09] += SRR->RR_HORAS
      					  		aFunc[10] += SRR->RR_VALOR
      					Endif
	   				Endif
						dbSelectArea("SRR")
	   				dbSkip()
	   			Enddo	
	   		Endif	
			   aFunc[11] := aFunc[02]+aFunc[04]+aFunc[06]+aFunc[08]
			  	aFunc[12] := aFunc[10]
				If aFunc[11] <> 0 .OR. aFunc[12] <> 0
					GperImp()
				Endif	
			Endif
			dbSelectArea("SRG")
			dbSkip()
	   Enddo
	Endif	
	dbSelectArea("SRA")
	dbSkip()
Enddo
nSubTot := 0
For Nx:=1 to Len(aSubTot)
 	nSubTot+= aSubTot[nX]
Next	
If nSubTot <> 0
	GperSub()
	GperCc()
Endif	
GperTot()

dbSelectArea("SRG")
dbSetOrder(1)          // Retorno a ordem 1
dbSelectArea("SRA")
dbSetOrder(1)          // Retorno a ordem 1

// Cerra la pagina
oPrn:EndPage()
// Mostra la pentalla de Setup
oPrn:Setup()
// Mostra la pentalla de preview
oPrn:Preview()

MS_FLUSH()


Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GperImp   ºAutor  ³Silvia Taguti       º Data ³  14/04/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Impressao do Relatorio                                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GperImp()             

Local nX, nY,  nTamLin
Local nSubTot := 0
Local nQ :=0

// Crea un nuevo objeto para impresion
oPrn:SetLandscape()
// Imprime la inicializacon de la impresora
//oPrn:Say(20,20," ",oFont12,100)
If nLinDet > 2300 
	// Cerra la pagina
	oPrn:EndPage()
 	oPrn:StartPage()
	Cabec()
Endif
If SRA->RA_CC <> cCcAnt                   // Centro de Custo
   For Nx:=1 to Len(aSubTot)
   	nSubTot+= aSubTot[nX]
   Next	
   If !lFirst
	   GperSub()
		For nQ := Len(aNiveis) to 1 Step -1           //Imprime Niveis de Centro de custo
			cQ := Str(nQ,1)
			If Subs(SRA->RA_CC,1,aNiveis[nQ]) # cCcAnt&cQ 
				GperCC()
			Endif		        
		Next nQ
	Endif
	lFirst := .F.
	oPrn:Say(nLinDet,200,SRA->RA_CC+ " - " +DescCc(SRA->RA_CC,SRA->RA_FILIAL),oFont09b,50)  //Centro de Custo
	cCcAnt := SRA->RA_CC
	If lImpNiv .And. Len(aNiveis) > 0
		For nQ = 1 TO Len(aNiveis)
			cQ        := Str(nQ,1)
			cCcAnt&cQ := Subs(cCcAnt,1,aNiveis[nQ])
		Next nQ
	Endif
Endif       

oPrn:Say(nLinDet+=50,200,cMatr,oFont07,50)
oPrn:Say(nLinDet,360,cNome,oFont07,50)
oPrn:Say(nLinDet,0900,cFPag,oFont07,50)                      //cargo
oPrn:Say(nLinDet,1230,dtoc(dDtAdmissa),oFont07,50)           //Admissao
oPrn:Say(nLinDet,1360,Transform(nMesesTrab,cPict1),oFont07,50)  //MES
oPrn:Say(nLinDet,1520,Transform(nSalAno,cPict1),oFont07,50)  //Salario Ano
oPrn:Say(nLinDet,1700,Transform(nSalMes,cPict1),oFont07,50)  //Salario Mensal
oPrn:Say(nLinDet,1860,Transform(nSalDia,cPict1),oFont07,50)  //Salario dia
oPrn:Say(nLinDet,2000,Transform(aFunc[01],cpict2),oFont07,50)//Horas
oPrn:Say(nLinDet,2100,Transform(aFunc[02],cPict1),oFont07,50)//Cesantia
oPrn:Say(nLinDet,2270,Transform(aFunc[03],cPict2),oFont07,50)//Horas
oPrn:Say(nLinDet,2380,Transform(aFunc[04],cPict1),oFont07,50)//Salario Navidad
oPrn:Say(nLinDet,2560,Transform(aFunc[05],cPict2),oFont07,50)//Horas
oPrn:Say(nLinDet,2680,Transform(aFunc[06],cPict1),oFont07,50)//Vacaciones
oPrn:Say(nLinDet,2860,Transform(aFunc[07],cPict2),oFont07,50)//Horas
oPrn:Say(nLinDet,2960,Transform(aFunc[08],cPict1),oFont07,50)//Outros Proventos 
oPrn:Say(nLinDet,3120,Transform(aFunc[11],cPict1),oFont07,50)//Total

oPrn:Say(nLinDet,3320,Transform(aFunc[09],cPict2),oFont07,50)//Hora
oPrn:Say(nLinDet,3420,Transform(aFunc[10],cPict1),oFont07,50)//descontos
oPrn:Say(nLinDet,3600,Transform(aFunc[12],cPict1),oFont07,50)//Total
oPrn:Say(nLinDet,3750,Transform((aFunc[11]-aFunc[12]),cPict1),oFont07,50)

For nX := 1 to Len(aFunc)
	aSubTot[nX]+= aFunc[nX]
	aTotal[nX] += aFunc[nX]
	aSubCC[nX] += aFunc[nX]
Next	
nQtdEmpl += 1
aFunc := {0,0,0,0,0,0,0,0,0,0,0,0}

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

Static Function Cabec()

Local cDtCabec

nLinDet := 100
nPag+=1 
cDtCabec := StrZero(Day(dDataDem),2)+OemToAnsi(STR0004)+MesExtenso(Month(dDataDem))+OemToAnsi(STR0030)+Str(Year(dDataDem),4)

oPrn:Say(100,3750,OemToAnsi(STR0031)+StrZero(nPag,5),oFont08,50) // pagina
// Empeza la impresion del cabezallo
oPrn:Say(nLinDet+=050,1500,OemToAnsi(STR0001),oFont19b,100)   // Corp.Avic.y Gan,Jarabacoa,
oPrn:Say(nLinDet+=080,1670,OemToAnsi(STR0002),oFont12b,100)   // "Relacion de Prestaciones Laborales Y Regalia
oPrn:Say(nLinDet+=040,1770,OemToAnsi(STR0003)+cDtCabec,oFont12b ,100)   // Al 
oPrn:Box(nLinDet+=70,190,2400,3920)

oPrn:Say(nLinDet+=010,1800,OemToAnsi(STR0005),oFont10b ,100)   // Ingresos
oPrn:Say(nLinDet,3200,OemToAnsi(STR0006),oFont10b ,100)   // Descuentos
oPrn:Line(nLinDet+=50,190,nLinDet,3920)

oPrn:Say(nLinDet+=020, 200,OemToAnsi(STR0007),oFont09b,50) // N.
oPrn:Say(nLinDet,0360,OemToAnsi(STR0008),oFont08b,50) // NOME              
oPrn:Say(nLinDet,0900,OemToAnsi(STR0009),oFont08b,50) // cargo  
oPrn:Say(nLinDet,1220,OemToAnsi(STR0032),oFont08b,50) // admissao 
oPrn:Say(nLinDet,1400,OemToAnsi(STR0033),oFont08b,50) // MES      
//oPrn:Say(nLinDet,1470,OemToAnsi(STR0011),oFont08b,50) // dias     
oPrn:Say(nLinDet,1540,OemToAnsi(STR0015),oFont08b,50) // TOT.GANA.
oPrn:Say(nLinDet,1720,OemToAnsi(STR0010),oFont08b,50) // salario 
oPrn:Say(nLinDet,1890,OemToAnsi(STR0019),oFont08b,50) // salario dia
oPrn:Say(nLinDet,2030,OemToAnsi(STR0011),oFont08b,50) // dias
oPrn:Say(nLinDet,2100,OemToAnsi(STR0012),oFont08b,50) // Cesantia
oPrn:Say(nLinDet,2280,OemToAnsi(STR0011),oFont08b,50) // dias
oPrn:Say(nLinDet,2390,OemToAnsi(STR0013),oFont08b,50) // Salario Navidad
oPrn:Say(nLinDet,2570,OemToAnsi(STR0011),oFont08b,50) // dias
oPrn:Say(nLinDet,2670,OemToAnsi(STR0014),oFont08b,50) // Vacacion
oPrn:Say(nLinDet,2870,OemToAnsi(STR0011),oFont08b,50) // dias
oPrn:Say(nLinDet,2990,OemToAnsi(STR0016),oFont08b,50) // $otros 
oPrn:Say(nLinDet,3150,OemToAnsi(STR0017),oFont08b,50) // TOTAL   

oPrn:Say(nLinDet,3320,OemToAnsi(STR0011),oFont08b,50) // dias
oPrn:Say(nLinDet,3420,OemToAnsi(STR0018),oFont08b,50) // DESCONTOS
oPrn:Say(nLinDet,3630,OemToAnsi(STR0020),oFont08b,50) // TOTAL   
oPrn:Say(nLinDet,3780,OemToAnsi(STR0021),oFont08b,50) // NETO            

oPrn:Line(nLinDet+=60,190,nLinDet,3920)

Return
   
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GperSub   ºAutor  ³Silvia Taguti       º Data ³  04/17/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Imprime Sub-Totais                                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GperSub()

If nLinDet > 2200 
	// Cerra la pagina
	oPrn:EndPage()
 	oPrn:StartPage()
	Cabec()
Endif

oPrn:Line(nLinDet+50,190,nLinDet+50,3920)
oPrn:Say(nLinDet+=50,1500,OemToAnsi(STR0028),oFont08b,50)      //Sub-total
oPrn:Say(nLinDet,2000,Transform(aSubTot[01],cpict2),oFont07,50)//Horas
oPrn:Say(nLinDet,2100,Transform(aSubTot[02],cPict1),oFont07,50)//Cesantia
oPrn:Say(nLinDet,2270,Transform(aSubTot[03],cPict2),oFont07,50)//Horas
oPrn:Say(nLinDet,2380,Transform(aSubTot[04],cPict1),oFont07,50)//Salario Navidad
oPrn:Say(nLinDet,2560,Transform(aSubTot[05],cPict2),oFont07,50)//Horas
oPrn:Say(nLinDet,2680,Transform(aSubTot[06],cPict1),oFont07,50)//Vacaciones
oPrn:Say(nLinDet,2860,Transform(aSubTot[07],cPict2),oFont07,50)//Horas
oPrn:Say(nLinDet,2960,Transform(aSubTot[08],cPict1),oFont07,50)//Outros Proventos 
oPrn:Say(nLinDet,3120,Transform(aSubTot[11],cPict1),oFont07,50)//Total

oPrn:Say(nLinDet,3320,Transform(aSubTot[09],cPict2),oFont07,50)//Hora
oPrn:Say(nLinDet,3420,Transform(aSubTot[10],cPict1),oFont07,50)//DESCONTOS
oPrn:Say(nLinDet,3600,Transform(aSubTot[12],cPict1),oFont07,50)//Total
oPrn:Say(nLinDet,3750,Transform((aSubTot[11]-aSubTot[12]),cPict1),oFont07,50)
oPrn:Line(nLinDet+=50,190,nLinDet,3920)

aSubTot := {0,0,0,0,0,0,0,0,0,0,0,0}

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GperTot   ºAutor  ³Silvia Taguti       º Data ³  04/17/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Imprime valores totais                                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GperTot()

If nLinDet > 2200 
	// Cerra la pagina
	oPrn:EndPage()
 	oPrn:StartPage()
	Cabec()      
Endif
oPrn:Say(nLinDet+=50,1500,OemToAnsi(STR0029),oFont08b,50)      // Total
oPrn:Say(nLinDet,2000,Transform(aTotal[01],cpict2),oFont07,50)//Horas
oPrn:Say(nLinDet,2100,Transform(aTotal[02],cPict1),oFont07,50)//Cesantia
oPrn:Say(nLinDet,2270,Transform(aTotal[03],cPict2),oFont07,50)//Horas
oPrn:Say(nLinDet,2380,Transform(aTotal[04],cPict1),oFont07,50)//Salario Navidad
oPrn:Say(nLinDet,2560,Transform(aTotal[05],cPict2),oFont07,50)//Horas
oPrn:Say(nLinDet,2680,Transform(aTotal[06],cPict1),oFont07,50)//Vacaciones
oPrn:Say(nLinDet,2860,Transform(aTotal[07],cPict2),oFont07,50)//Horas
oPrn:Say(nLinDet,2960,Transform(aTotal[08],cPict1),oFont07,50)//Outros Proventos 
oPrn:Say(nLinDet,3120,Transform(aTotal[11],cPict1),oFont07,50)//Total

oPrn:Say(nLinDet,3320,Transform(aTotal[09],cPict2),oFont07,50)//Hora
oPrn:Say(nLinDet,3420,Transform(aTotal[10],cPict1),oFont07,50)//DESCONTO 
oPrn:Say(nLinDet,3600,Transform(aTotal[12],cPict1),oFont07,50)//Total
oPrn:Say(nLinDet,3750,Transform((aTotal[11]-aTotal[12]),cPict1),oFont07,50)
oPrn:Line(nLinDet+=50,190,nLinDet,3920)

If nLinDet > 2200 
	// Cerra la pagina
	oPrn:EndPage()
 	oPrn:StartPage()
	Cabec()
Endif
oPrn:Line(nLinDet+=50,190,nLinDet,3920)
//oPrn:Say(nLinDet+=10,0920,OemToAnsi(STR0030),oFont08b,50) // Empleados
oPrn:Say(nLinDet,2030,OemToAnsi(STR0011),oFont08b,50) // hora
oPrn:Say(nLinDet,2100,OemToAnsi(STR0012),oFont08b,50) // Cesantia
oPrn:Say(nLinDet,2280,OemToAnsi(STR0011),oFont08b,50) // hora
oPrn:Say(nLinDet,2390,OemToAnsi(STR0013),oFont08b,50) // Salario Navidad
oPrn:Say(nLinDet,2570,OemToAnsi(STR0011),oFont08b,50) // hora
oPrn:Say(nLinDet,2670,OemToAnsi(STR0014),oFont08b,50) // Vacacion
oPrn:Say(nLinDet,2870,OemToAnsi(STR0011),oFont08b,50) // hora
oPrn:Say(nLinDet,2990,OemToAnsi(STR0016),oFont08b,50) // $otros 
oPrn:Say(nLinDet,3150,OemToAnsi(STR0017),oFont08b,50) // TOTAL   

oPrn:Say(nLinDet,3320,OemToAnsi(STR0011),oFont08b,50) // hora
oPrn:Say(nLinDet,3420,OemToAnsi(STR0018),oFont08b,50) // DESCONTO
oPrn:Say(nLinDet,3630,OemToAnsi(STR0020),oFont08b,50) // TOTAL   
oPrn:Say(nLinDet,3780,OemToAnsi(STR0021),oFont08b,50) // NETO            
oPrn:Line(nLinDet+=50,190,nLinDet,3920)

//oPrn:Say(nLinDet,0900,Transform(nQtdEmpl,cPict1),oFont07,50)   //Qtd Empleados
oPrn:Say(nLinDet,2000,Transform(atotal[01],cpict2),oFont07,50)//Horas
oPrn:Say(nLinDet,2100,Transform(atotal[02],cPict1),oFont07,50)//Cesantia
oPrn:Say(nLinDet,2270,Transform(atotal[03],cPict2),oFont07,50)//Horas
oPrn:Say(nLinDet,2380,Transform(atotal[04],cPict1),oFont07,50)//Salario Navidad
oPrn:Say(nLinDet,2560,Transform(atotal[05],cPict2),oFont07,50)//Horas
oPrn:Say(nLinDet,2680,Transform(atotal[06],cPict1),oFont07,50)//Vacaciones
oPrn:Say(nLinDet,2860,Transform(atotal[07],cPict2),oFont07,50)//Horas
oPrn:Say(nLinDet,2960,Transform(atotal[08],cPict1),oFont07,50)//Outros Proventos 
oPrn:Say(nLinDet,3120,Transform(atotal[11],cPict1),oFont07,50)//Total

oPrn:Say(nLinDet,3320,Transform(atotal[09],cPict2),oFont07,50)//Hora
oPrn:Say(nLinDet,3420,Transform(atotal[10],cPict1),oFont07,50)//IDSS
oPrn:Say(nLinDet,3600,Transform(atotal[12],cPict1),oFont07,50)//Total
oPrn:Say(nLinDet,3750,Transform((atotal[11]-atotal[12]),cPict1),oFont07,50)
oPrn:Line(nLinDet+=50,190,nLinDet,3920)

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Gpercc   ºAutor  ³Silvia Taguti       º Data ³  04/17/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Imprime Sub-Totais Centro de Custo                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GperCc()

If nLinDet > 2200 
	// Cerra la pagina
	oPrn:EndPage()
 	oPrn:StartPage()
	Cabec()
Endif
oPrn:Say(nLinDet,1500,cCcAnt&cQ+" - "+DescCc(cCcAnt&cQ,cFilialAnt),oFont09b,50)      //Centro Custo-Total
oPrn:Say(nLinDet,2000,Transform(aSubCc[01],cpict2),oFont07,50)//Horas
oPrn:Say(nLinDet,2100,Transform(aSubCc[02],cPict1),oFont07,50)//Cesantia
oPrn:Say(nLinDet,2270,Transform(aSubCc[03],cPict2),oFont07,50)//Horas
oPrn:Say(nLinDet,2380,Transform(aSubCc[04],cPict1),oFont07,50)//Salario Navidad
oPrn:Say(nLinDet,2560,Transform(aSubCc[05],cPict2),oFont07,50)//Horas
oPrn:Say(nLinDet,2680,Transform(aSubCc[06],cPict1),oFont07,50)//Vacaciones
oPrn:Say(nLinDet,2860,Transform(aSubCc[07],cPict2),oFont07,50)//Horas
oPrn:Say(nLinDet,2960,Transform(aSubCc[08],cPict1),oFont07,50)//Outros Proventos 
oPrn:Say(nLinDet,3120,Transform(aSubCc[11],cPict1),oFont07,50)//Total

oPrn:Say(nLinDet,3320,Transform(aSubCc[09],cPict2),oFont07,50)//Hora
oPrn:Say(nLinDet,3420,Transform(aSubCc[10],cPict1),oFont07,50)//DESCONTOS
oPrn:Say(nLinDet,3600,Transform(aSubCc[12],cPict1),oFont07,50)//Total
oPrn:Say(nLinDet,3750,Transform((aSubCc[11]-aSubCc[12]),cPict1),oFont07,50)
oPrn:Line(nLinDet+=50,190,nLinDet,3920)

aSubTot := {0,0,0,0,0,0,0,0,0,0,0,0}

Return


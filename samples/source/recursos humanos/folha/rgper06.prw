#include "RwMake.ch"
#include "RGPER06.ch"
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
±±ºPrograma  ³RGPER06   ºAutor  ³Silvia Taguti       º Data ³  14/04/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Hace la impresion de Informe de Nomina da Pago              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Republica Dominicana                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION RGPER06()

Local cString := "SRA"  // alias do arquivo principal (Base)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Private(Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private NomeProg 	:= "RGPER06"
Private cPerg    	:= "RGPR06"
Private Titulo
Private aCodFol		:= {}
Private cPict1		:= TM(9999999999,16,MsDecimais(1))
Private Desc_Emp

pergunte("RGPR06",.T.)

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
//³ mv_par13        //  Data de Referencia                       ³
//³ mv_par14        //  semana                                   ³
//³ mv_par15        //  Concepto para Horas Extras               ³
//³ mv_par16        //  Concepto para Horas Noturnas             ³
//³ mv_par17        //  Concepto para Horas Extraordinarias      ³
//³ mv_par18        //  Titulo coluna 1                          ³
//³ mv_par19        //  Conceptos Coluna 1                       ³
//³ mv_par20        //  Titulo coluna 2                          ³
//³ mv_par21        //  Conceptos Coluna 2                       ³
//³ mv_par22        //  Titulo coluna 3                          ³
//³ mv_par23        //  Conceptos Coluna 3                       ³
//³ mv_par24        //  Titulo coluna 4                          ³
//³ mv_par25        //  Conceptos Coluna 4                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:="RGPER06"            //Nome Default do relatorio em Disco

RptStatus({|lEnd| GPR06Imp(@lEnd,wnRel,cString)},Titulo)

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GR06IMP   ºAutor  ³Silvia Taguti       º Data ³  14/04/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatorio                                                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function GPR06IMP(lEnd,WnRel,cString)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Locais (Programa)                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aInfo	 	:= {}
Local aOrdBag   := {}
Local cArqMov	:= ""
Local cAnoMes   
Local cMesAnoRef 
Local dChkDtRef
Local cDataREf  
Local cMapa     := 0
Local nLaco     := 0
Local nByte 	:= 0
Local nQ		:= 0	
Private cMascCus:= GetMv("MV_MASCCUS")
Private aNiveis := {}
Private cMatr
Private cNome
Private cFPag
Private nSalQuin:= 0
Private aDescFil:= {}
Private nLinDet := 2400
Private cSemana 
Private nQtdEmpl:= 0
Private oPrn 	:= TMSPrinter():New()
Private aFunc 	:= {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
Private aSubTot := {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
Private aSubCc  := {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
Private aTotal  := {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
Private cAliasMov     := ""
Private nPag	:= 0
Private lFirst 	:= .T.
// Crea los objetos con las configuraciones de fuentes
oFont07  := TFont():New( "Times New Roman",,07,,.f.,,,,,.f. )
oFont08  := TFont():New( "Times New Roman",,08,,.f.,,,,,.f. )
oFont09b := TFont():New( "Times New Roman",,09,,.t.,,,,,.f. )
oFont10b := TFont():New( "Times New Roman",,10,,.t.,,,,,.f. )
oFont12  := TFont():New( "Times New Roman",,12,,.f.,,,,,.f. )
oFont12b := TFont():New( "Times New Roman",,12,,.t.,,,,,.f. )
oFont14  := TFont():New( "Times New Roman",,14,,.f.,,,,,.f. )
oFont14b := TFont():New( "Times New Roman",,14,,.t.,,,,,.f. )
oFont16  := TFont():New( "Times New Roman",,16,,.f.,,,,,.f. )
oFont19b := TFont():New( "Times New Roman",,19,,.t.,,,,,.f. )

cFilDe     	:= mv_par01
cFilAte    	:= mv_par02
cCcDe      	:= mv_par03
cCcAte     	:= mv_par04
cMatDe     	:= mv_par05
cMatAte    	:= mv_par06
cNomeDe    	:= mv_par07
cNomeAte   	:= mv_par08
cChapaDe   	:= mv_par09
cChapaAte  	:= mv_par10
cSituacao  	:= mv_par11
cCategoria 	:= mv_par12
dDataref   	:= mv_par13        //  Data Referencia                          
csemana    	:= mv_par14        //  Semana                                   
cHoraExt   	:= mv_par15        //  Concepto para Horas Extras               
cHoraNot   	:= mv_par16        //  Concepto para Horas Noturnas             
cHora100   	:= mv_par17        //  Concepto para Horas Extraordinarias      
cTitulo1	:= mv_par18
cVerbCol1	:= mv_par19
cTitulo2	:= mv_par20
cVerbCol2	:= mv_par21
cTitulo3	:= mv_par22
cVerbCol3	:= mv_par23
cTitulo4	:= mv_par24
cVerbCol4	:= mv_par25
lImpNiv  	:= If(mv_par26 == 1,.T.,.F.)
nOrdem 		:= 2
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
cAnoMes    := AnoMes(dDataRef)
cMesAnoRef := StrZero(Month(dDataRef),2) + StrZero(Year(dDataRef),4)
dChkDtRef  := CTOD("01/"+Left(cMesAnoRef,2)+"/"+Right(cMesAnoRef,4),"DDMMYY")
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

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica Data Demissao         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cSitFunc := SRA->RA_SITFOLH
	dDtPesqAf:= CTOD("01/" + Right(cAnoMes,2) + "/" + Left(cAnoMes,4),"DDMMYY")
	If cSitFunc == "D" .And. (!Empty(SRA->RA_DEMISSA) .And. MesAno(SRA->RA_DEMISSA) > MesAno(dDtPesqAf))
		cSitFunc := " "
	Endif	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste situacao e categoria dos funcionarios			     |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !( cSitFunc $ cSituacao ) .OR.  ! ( SRA->RA_CATFUNC $ cCategoria )
		dbSkip()
		Loop
	Endif
	If cSitFunc $ "D" .And. Mesano(SRA->RA_DEMISSA) # Mesano(dDataRef)
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
		Desc_Emp := aInfo[03]
	   dbSelectArea( "SRA" )
	   cFilialAnt := SRA->RA_FILIAL
	Endif

   	cMatr	:= SRA->RA_MAT
	cNome   := SRA->RA_NOME
 	cFPag	:= Substr(DescFun(Sra->Ra_Codfunc,Sra->Ra_Filial),1,15)
  	If SRA->RA_CATFUNC == "H"
  		nSalQuin  	:= (SRA->RA_SALARIO * SRA->RA_HRSMES) /2
  	ElseIf SRA->RA_CATFUNC == "D"
  		nSalQuin	:= (SRA->RA_SALARIO * 15) 
  	ElseIf SRA->RA_CATFUNC == "M"
  		nSalQuin  	:= SRA->RA_SALARIO/2
  	Endif	

	dbSelectArea("SRC")
	If dbSeek( SRA->RA_FILIAL + SRA->RA_MAT )
		While !Eof() .And. (SRA->RA_FILIAL+SRA->RA_MAT==SRC->RC_FILIAL+SRC->RC_MAT)
 			If(SRA->RA_FILIAL+SRA->RA_MAT==SRC->RC_FILIAL+SRC->RC_MAT)
 			   	If  SRC->RC_SEMANA <> cSemana 
 			   		DbSkip()
		 	   		Loop
 				Endif	
  	  			If PosSrv(SRC->RC_PD,SRC->RC_FILIAL,"RV_TIPOCOD") == "1"
					If SRC->RC_PD == aCodFol[31,1] .or. SRC->RC_PD == aCodFol[32,1]
		      	   aFunc[01] := SRC->RC_HORAS
						aFunc[02] := SRC->RC_VALOR             			//Salario 
		   	  	ElseIf SRC->RC_PD == cHoraExt							//Hora Extra
	   	  			aFunc[03] := SRC->RC_HORAS
	   	  			aFunc[04] := SRC->RC_VALOR 
					ElseIf SRC->RC_PD == cHoraNot             			//Hora Noturna
	   	  			aFunc[05] := SRC->RC_HORAS
			   		aFunc[06] := SRC->RC_VALOR
					ElseIf SRC->RC_PD == cHora100             			//Hora Extraordinaria 100%
	   	  		   		aFunc[07] := SRC->RC_HORAS
						aFunc[08]  := SRC->RC_VALOR
					Else
						aFunc[09] := SRC->RC_VALOR	           				//Outros Proventos
					Endif
				ElseIf PosSrv(SRC->RC_PD,SRC->RC_FILIAL,"RV_TIPOCOD") == "2"
   		     	If SRC->RC_PD == aCodFol[049,1]          				 //Assistencia Medica
      		     	aFunc[10] := SRC->RC_VALOR
				ElseIf SRC->RC_PD $ aCodFol[66,1]+"|"+aCodFol[67,1] //Imposto de Renda
		 			aFunc[11] := SRC->RC_VALOR
				ElseIf SRC->RC_PD $ aCodFol[64,1]+"|"+aCodFol[70,1] //IDSS
					aFunc[12]:= SRC->RC_VALOR
				ElseIf SRC->RC_PD $ cVerbCol1								 //Coluna 1      
					aFunc[13] += SRC->RC_VALOR
				ElseIf SRC->RC_PD $ cVerbCol2                       //Coluna 2         
 				   	aFunc[14] += SRC->RC_VALOR
				ElseIf SRC->RC_PD $ cVerbCol3                       //Coluna 3        
 		   	  		aFunc[15] += SRC->RC_VALOR
				ElseIf SRC->RC_PD $ cVerbCol4                       //Coluna 4         
					aFunc[16] := SRC->RC_VALOR	                      
				Endif                   
				
			
      		Endif
	   	Endif
			dbSelectArea("SRC")
			dbSkip()
	   	Enddo
   		aFunc[17] := aFunc[02]+aFunc[04]+aFunc[06]+aFunc[08]+aFunc[09]
	  	aFunc[18] := aFunc[10]+aFunc[11]+aFunc[12]+aFunc[13]+aFunc[14]+aFunc[15]+aFunc[16]
		GperImp()
	Endif	
	dbSelectArea("SRA")
	dbSkip()
Enddo
If cMatr <> Nil
	GperSub()
	GperCc()
	GperTot()
Endif	

dbSelectArea("SRC")
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

Local nX 		:= 0
Local nY 		:= 0
Local nQ		:= 0
// Crea un nuevo objeto para impresion
oPrn:SetLandscape()

// Imprime la inicializacon de la impresora
If nLinDet > 2300 
	oPrn:EndPage()
 	oPrn:StartPage()
	Cabec()
Endif
If SRA->RA_CC <> cCcAnt                   // Centro de Custo
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
oPrn:Say(nLinDet,0900,cFPag,oFont07,50)
oPrn:Say(nLinDet,1250,Transform(nSalQuin,cPict1),oFont07,50) //Salario
oPrn:Say(nLinDet,1390,Transform(aFunc[01],cpict1),oFont07,50)//Horas
oPrn:Say(nLinDet,1560,Transform(aFunc[02],cPict1),oFont07,50)//Sueldo  
oPrn:Say(nLinDet,1700,Transform(aFunc[03],cPict1),oFont07,50)//Hora 
oPrn:Say(nLinDet,1800,Transform(aFunc[04],cPict1),oFont07,50)//Hora Extra
oPrn:Say(nLinDet,1910,Transform(aFunc[05],cPict1),oFont07,50)//Hora 
oPrn:Say(nLinDet,2010,Transform(aFunc[06],cPict1),oFont07,50)//Hora Noturna
oPrn:Say(nLinDet,2110,Transform(aFunc[07],cPict1),oFont07,50)//Hora 
oPrn:Say(nLinDet,2250,Transform(aFunc[08],cPict1),oFont07,50)//Hora Extraordinaria 100%
oPrn:Say(nLinDet,2400,Transform(aFunc[09],cPict1),oFont07,50)//Outros Proventos
oPrn:Say(nLinDet,2540,Transform(aFunc[17],cPict1),oFont07,50)//Total Ingresos

oPrn:Say(nLinDet,2670,Transform(aFunc[10],cPict1),oFont07,50)//Assistencia Medica
oPrn:Say(nLinDet,2780,Transform(aFunc[11],cPict1),oFont07,50)//Imposto de Renda
oPrn:Say(nLinDet,2900,Transform(aFunc[12],cPict1),oFont07,50)//IDSS
oPrn:Say(nLinDet,3000,Transform(aFunc[13],cPict1),oFont07,50)//titulo1
oPrn:Say(nLinDet,3130,Transform(aFunc[14],cPict1),oFont07,50)//titulo2
oPrn:Say(nLinDet,3320,Transform(aFunc[15],cPict1),oFont07,50)//titulo3
oPrn:Say(nLinDet,3470,Transform(aFunc[16],cPict1),oFont07,50)//titulo4
oPrn:Say(nLinDet,3620,Transform(aFunc[18],cPict1),oFont07,50)//Total Descontos
oPrn:Say(nLinDet,3770,Transform((aFunc[17]-aFunc[18]),cPict1),oFont07,50)

For nX := 1 to Len(aFunc)
	aSubTot[nX] += aFunc[nX]
	aTotal[nX] += aFunc[nX]  
	aSubCC[nX]+= aFunc[nX]
Next	
nQtdEmpl+= 1
aFunc 	:= {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}

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

Local aPeriodo 	:= {}                            
Local nPosSem 	:= 0
Local dDataIni 	:= Ctod('  /  /  ')
Local dDataFim 	:= Ctod('  /  /  ')

nLinDet := 100
nPag+=1 
If cSemana # Space(2)
	If ! fCarPeriodo(dDataRef,@aPeriodo,,@nPosSem)
		Return
	Endif
	If nPosSem > 0
		dDataIni := aPeriodo[ nPosSem,3]
		dDataFim := aPeriodo[ nPosSem,4]
	Endif		
Endif	

oPrn:Say(100,3750,OemToAnsi(STR0031)+StrZero(nPag,5),oFont08,50) 	// pagina
// Empeza la impresion del cabezallo
oPrn:Say(nLinDet+=050,1500,Desc_Emp,oFont19b,100)   				// Corp.Avic.y Gan,Jarabacoa,
oPrn:Say(nLinDet+=080,1800,OemToAnsi(STR0002),oFont12b,100)   		// Informe de Nomina de pago 
oPrn:Say(nLinDet+=040,1450,OemToAnsi(STR0003),oFont12b ,100)   	// Periodo de pago desde
oPrn:Say(nLinDet,2020,dtoc(dDataIni),oFont12 ,100)   				// Data inicial
oPrn:Say(nLinDet,2200,OemToAnsi(STR0004),oFont12b ,100)   			// Hasta
oPrn:Say(nLinDet,2400,dtoc(dDataFim),oFont12 ,100)   				// Data Final
oPrn:Box(nLinDet+=70,190,2400,3920)

oPrn:Say(nLinDet+=010,1800,OemToAnsi(STR0005),oFont10b ,100)   	// Hasta
oPrn:Say(nLinDet,3000,OemToAnsi(STR0006),oFont10b ,100)  	 		// Descuentos
oPrn:Line(nLinDet+=50,190,nLinDet,3920)

oPrn:Say(nLinDet+=020, 200,OemToAnsi(STR0007),oFont09b,50) // N.
oPrn:Say(nLinDet, 360,OemToAnsi(STR0008),oFont09b,50) 		// NOME              
oPrn:Say(nLinDet,0950,OemToAnsi(STR0009),oFont09b,50) 		// cargo  
oPrn:Say(nLinDet,1250,OemToAnsi(STR0010),oFont09b,50) 		// salario 
oPrn:Say(nLinDet,1410,OemToAnsi(STR0011),oFont09b,50) 		// horas
oPrn:Say(nLinDet,1540,OemToAnsi(STR0012),oFont09b,50) 		// sueldos
oPrn:Say(nLinDet,1710,OemToAnsi(STR0011),oFont09b,50) 		// horas
oPrn:Say(nLinDet,1840,OemToAnsi(STR0013),oFont09b,50) 		// $HEN    
oPrn:Say(nLinDet,1930,OemToAnsi(STR0011),oFont09b,50) 		// horas
oPrn:Say(nLinDet,2070,OemToAnsi(STR0014),oFont09b,50) 		// $HEO  
oPrn:Say(nLinDet,2170,OemToAnsi(STR0011),oFont09b,50) 		// horas
oPrn:Say(nLinDet,2300,OemToAnsi(STR0015),oFont09b,50) 		// $hnoc  
oPrn:Say(nLinDet,2430,OemToAnsi(STR0016),oFont09b,50) 		// $otros 
oPrn:Say(nLinDet,2580,OemToAnsi(STR0017),oFont09b,50) 		// TOTAL   
oPrn:Say(nLinDet,2710,OemToAnsi(STR0018),oFont09b,50) 		// S.MED  
oPrn:Say(nLinDet,2840,OemToAnsi(STR0019),oFont09b,50) 		// ISRS

oPrn:Say(nLinDet,2930,OemToAnsi(STR0020),oFont09b,50) 		// IDSS         
oPrn:Say(nLinDet,3020,cTitulo1,oFont09b,50) 				// TITULO1
oPrn:Say(nLinDet,3170,cTitulo2,oFont09b,50) 				// TITULO2
oPrn:Say(nLinDet,3320,cTitulo3,oFont09b,50) 				// TITULO3 
                   
oPrn:Say(nLinDet,3490,cTitulo4,oFont09b,50) 				// TITULO4              
oPrn:Say(nLinDet,3625,OemToAnsi(STR0025),oFont09b,50) 		// TOTAL   
oPrn:Say(nLinDet,3790,OemToAnsi(STR0026),oFont09b,50) 		// NETO            
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
±±ºUso       ³ AP                                                        º±±
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
oPrn:Say(nLinDet+=50,700,OemToAnsi(STR0028),oFont09b,50)      //Sub-total
oPrn:Say(nLinDet,1390,Transform(aSubTot[01],cpict1),oFont07,50) //Horas
oPrn:Say(nLinDet,1560,Transform(aSubTot[02],cPict1),oFont07,50) //Sueldo 
oPrn:Say(nLinDet,1700,Transform(aSubTot[03],cPict1),oFont07,50)//Hora 
oPrn:Say(nLinDet,1800,Transform(aSubTot[04],cPict1),oFont07,50) //Hora Extra
oPrn:Say(nLinDet,1910,Transform(aSubTot[05],cPict1),oFont07,50)//Hora 
oPrn:Say(nLinDet,2010,Transform(aSubTot[06],cPict1),oFont07,50) //Hora Noturna
oPrn:Say(nLinDet,2110,Transform(aSubTot[07],cPict1),oFont07,50)//Hora 
oPrn:Say(nLinDet,2250,Transform(aSubTot[08],cPict1),oFont07,50) //Hora Extraordinaria 100%
oPrn:Say(nLinDet,2400,Transform(aSubTot[09],cPict1),oFont07,50) //Outros Proventos
oPrn:Say(nLinDet,2540,Transform(aSubTot[17],cPict1),oFont07,50) //Total Ingresos

oPrn:Say(nLinDet,2670,Transform(aSubTot[10],cPict1),oFont07,50) //Assistencia Medica
oPrn:Say(nLinDet,2780,Transform(aSubTot[11],cPict1),oFont07,50) //Imposto de Renda
oPrn:Say(nLinDet,2900,Transform(aSubTot[12],cPict1),oFont07,50) //IDSS
oPrn:Say(nLinDet,3000,Transform(aSubTot[13],cPict1),oFont07,50) //Alimentacao
oPrn:Say(nLinDet,3130,Transform(aSubTot[14],cPict1),oFont07,50) //Contas por Cobrar
oPrn:Say(nLinDet,3320,Transform(aSubTot[15],cPict1),oFont07,50) //Contas de Huegos
oPrn:Say(nLinDet,3470,Transform(aSubTot[16],cPict1),oFont07,50) //Outros Descontos
oPrn:Say(nLinDet,3620,Transform(aSubTot[18],cPict1),oFont07,50) //Total Descontos
oPrn:Say(nLinDet,3770,Transform((aSubTot[17]-aSubTot[18]),cPict1),oFont07,50)
oPrn:Line(nLinDet+=50,190,nLinDet,3920)

aSubTot := {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}

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
oPrn:Say(nLinDet,700,OemToAnsi(STR0029),oFont09b,50)      // Total
oPrn:Say(nLinDet,1390,Transform(aTotal[01],cpict1),oFont07,50) //Horas
oPrn:Say(nLinDet,1560,Transform(aTotal[02],cPict1),oFont07,50) //Salario 
oPrn:Say(nLinDet,1700,Transform(aTotal[03],cPict1),oFont07,50) //Hora 
oPrn:Say(nLinDet,1800,Transform(aTotal[04],cPict1),oFont07,50) //Hora Extra
oPrn:Say(nLinDet,1910,Transform(aTotal[05],cPict1),oFont07,50) //Hora 
oPrn:Say(nLinDet,2010,Transform(aTotal[06],cPict1),oFont07,50) //Hora Noturna
oPrn:Say(nLinDet,2110,Transform(aTotal[07],cPict1),oFont07,50) //Hora 
oPrn:Say(nLinDet,2250,Transform(aTotal[08],cPict1),oFont07,50) //Hora Extraordinaria 100%
oPrn:Say(nLinDet,2400,Transform(aTotal[09],cPict1),oFont07,50) //Outros Proventos
oPrn:Say(nLinDet,2540,Transform(aTotal[17],cPict1),oFont07,50) //Total Ingresos

oPrn:Say(nLinDet,2670,Transform(aTotal[10],cPict1),oFont07,50) //Assistencia Medica
oPrn:Say(nLinDet,2780,Transform(aTotal[11],cPict1),oFont07,50) //Imposto de Renda
oPrn:Say(nLinDet,2900,Transform(aTotal[12],cPict1),oFont07,50) //IDSS
oPrn:Say(nLinDet,3000,Transform(aTotal[13],cPict1),oFont07,50) //Alimentacao
oPrn:Say(nLinDet,3130,Transform(aTotal[14],cPict1),oFont07,50) //Contas por Cobrar
oPrn:Say(nLinDet,3320,Transform(aTotal[15],cPict1),oFont07,50) //Contas de Huegos
oPrn:Say(nLinDet,3470,Transform(aTotal[16],cPict1),oFont07,50) //Outros Descontos
oPrn:Say(nLinDet,3620,Transform(aTotal[18],cPict1),oFont07,50) //Total Descontos
oPrn:Say(nLinDet,3770,Transform((aTotal[17]-aTotal[18]),cPict1),oFont07,50)
oPrn:Line(nLinDet+=50,190,nLinDet,3920)

If nLinDet > 2200 
	// Cerra la pagina
	oPrn:EndPage()
 	oPrn:StartPage()
	Cabec()
Endif

//oPrn:Line(nLinDet,190,nLinDet,3920)
oPrn:Say(nLinDet+=10,1190,OemToAnsi(STR0030),oFont09b,50) // Empleados
oPrn:Say(nLinDet,1410,OemToAnsi(STR0011),oFont09b,50) // horas
oPrn:Say(nLinDet,1540,OemToAnsi(STR0012),oFont09b,50) // sueldos
oPrn:Say(nLinDet,1710,OemToAnsi(STR0011),oFont09b,50) // horas
oPrn:Say(nLinDet,1840,OemToAnsi(STR0013),oFont09b,50) // $HEN    
oPrn:Say(nLinDet,1930,OemToAnsi(STR0011),oFont09b,50) // horas
oPrn:Say(nLinDet,2070,OemToAnsi(STR0014),oFont09b,50) // $HEO  
oPrn:Say(nLinDet,2170,OemToAnsi(STR0011),oFont09b,50) // horas
oPrn:Say(nLinDet,2300,OemToAnsi(STR0015),oFont09b,50) // $hnoc  
oPrn:Say(nLinDet,2430,OemToAnsi(STR0016),oFont09b,50) // $otros 
oPrn:Say(nLinDet,2580,OemToAnsi(STR0017),oFont09b,50) // TOTAL   
oPrn:Say(nLinDet,2710,OemToAnsi(STR0018),oFont09b,50) // S.MED  
oPrn:Say(nLinDet,2840,OemToAnsi(STR0019),oFont09b,50) // ISRS
oPrn:Say(nLinDet,2930,OemToAnsi(STR0020),oFont09b,50) // IDSS         
oPrn:Say(nLinDet,3020,cTitulo1,oFont09b,50) 				 // TITULO1
oPrn:Say(nLinDet,3170,cTitulo2,oFont09b,50) 				 // TITULO2
oPrn:Say(nLinDet,3320,cTitulo3,oFont09b,50) 				 // TITULO3 
oPrn:Say(nLinDet,3490,cTitulo4,oFont09b,50) 				 // TITULO4              
oPrn:Say(nLinDet,3625,OemToAnsi(STR0025),oFont09b,50) // TOTAL   
oPrn:Say(nLinDet,3790,OemToAnsi(STR0026),oFont09b,50) // NETO            

oPrn:Line(nLinDet+=50,190,nLinDet,3920)

//Detalhe do Totalizador
oPrn:Say(nLinDet,1250,Transform(nQtdEmpl,cPict1),oFont07,50)   //Qtd Empleados
oPrn:Say(nLinDet,1390,Transform(aTotal[01],cpict1),oFont07,50) //Horas
oPrn:Say(nLinDet,1560,Transform(aTotal[02],cPict1),oFont07,50) //Salario 
oPrn:Say(nLinDet,1700,Transform(aTotal[03],cPict1),oFont07,50) //Hora
oPrn:Say(nLinDet,1800,Transform(aTotal[04],cPict1),oFont07,50) //Hora Extra
oPrn:Say(nLinDet,1910,Transform(aTotal[05],cPict1),oFont07,50) //Hora
oPrn:Say(nLinDet,2010,Transform(aTotal[06],cPict1),oFont07,50) //Hora Noturna
oPrn:Say(nLinDet,2110,Transform(aTotal[07],cPict1),oFont07,50) //Hora
oPrn:Say(nLinDet,2250,Transform(aTotal[08],cPict1),oFont07,50) //Hora Extraordinaria 100%
oPrn:Say(nLinDet,2400,Transform(aTotal[09],cPict1),oFont07,50) //Outros Proventos
oPrn:Say(nLinDet,2540,Transform(aTotal[17],cPict1),oFont07,50) //Total Ingresos

oPrn:Say(nLinDet,2670,Transform(aTotal[10],cPict1),oFont07,50) //Assistencia Medica
oPrn:Say(nLinDet,2780,Transform(aTotal[11],cPict1),oFont07,50) //Imposto de Renda
oPrn:Say(nLinDet,2900,Transform(aTotal[12],cPict1),oFont07,50) //IDSS
oPrn:Say(nLinDet,3000,Transform(aTotal[13],cPict1),oFont07,50) //Alimentacao
oPrn:Say(nLinDet,3130,Transform(aTotal[14],cPict1),oFont07,50) //Contas por Cobrar
oPrn:Say(nLinDet,3320,Transform(aTotal[15],cPict1),oFont07,50) //Contas de Huegos
oPrn:Say(nLinDet,3470,Transform(aTotal[16],cPict1),oFont07,50) //Outros Descontos
oPrn:Say(nLinDet,3620,Transform(aTotal[18],cPict1),oFont07,50) //Total Descontos
oPrn:Say(nLinDet,3770,Transform((aTotal[17]-aTotal[18]),cPict1),oFont07,50)
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

//oPrn:Line(nLinDet,190,nLinDet,3920)
oPrn:Say(nLinDet,700,cCcAnt&cQ+" - "+DescCc(cCcAnt&cQ,cFilialAnt),oFont09b,50)      //Centro Custo-Total
oPrn:Say(nLinDet,1390,Transform(aSubcc[01],cpict1),oFont07,50) //Horas
oPrn:Say(nLinDet,1560,Transform(aSubcc[02],cPict1),oFont07,50)	//Sueldo 
oPrn:Say(nLinDet,1700,Transform(aSubcc[03],cPict1),oFont07,50)	//Hora 
oPrn:Say(nLinDet,1800,Transform(aSubcc[04],cPict1),oFont07,50)	//Hora Extra
oPrn:Say(nLinDet,1910,Transform(aSubcc[05],cPict1),oFont07,50)	//Hora 
oPrn:Say(nLinDet,2010,Transform(aSubcc[06],cPict1),oFont07,50)	//Hora Noturna
oPrn:Say(nLinDet,2110,Transform(aSubcc[07],cPict1),oFont07,50)	//Hora 
oPrn:Say(nLinDet,2250,Transform(aSubcc[08],cPict1),oFont07,50)	//Hora Extraordinaria 100%
oPrn:Say(nLinDet,2400,Transform(aSubcc[09],cPict1),oFont07,50)	//Outros Proventos
oPrn:Say(nLinDet,2540,Transform(aSubcc[17],cPict1),oFont07,50)	//Total Ingresos

oPrn:Say(nLinDet,2670,Transform(aSubcc[10],cPict1),oFont07,50)	//Assistencia Medica
oPrn:Say(nLinDet,2780,Transform(aSubcc[11],cPict1),oFont07,50)	//Imposto de Renda
oPrn:Say(nLinDet,2900,Transform(aSubcc[12],cPict1),oFont07,50)	//IDSS
oPrn:Say(nLinDet,3000,Transform(aSubcc[13],cPict1),oFont07,50)	//Alimentacao
oPrn:Say(nLinDet,3130,Transform(aSubcc[14],cPict1),oFont07,50)	//Contas por Cobrar
oPrn:Say(nLinDet,3320,Transform(aSubcc[15],cPict1),oFont07,50)	//Contas de Huegos
oPrn:Say(nLinDet,3470,Transform(aSubcc[16],cPict1),oFont07,50)	//Outros Descontos
oPrn:Say(nLinDet,3620,Transform(aSubcc[18],cPict1),oFont07,50)	//Total Descontos
oPrn:Say(nLinDet,3770,Transform((aSubcc[17]-aSubcc[18]),cPict1),oFont07,50)
oPrn:Line(nLinDet+=50,190,nLinDet,3920)

aSubcc := {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}

If Substr(SRA->RA_CC,1,2) <> Substr(cCcAnt,1,2) // Qdo as 2 primeiras posicoes forem
	// Cerra la pagina                            // diferentes, pular a pagina
	oPrn:EndPage()
 	oPrn:StartPage()
	Cabec()
Endif
Return


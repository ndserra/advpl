#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"        
#INCLUDE "TRM040.CH"


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao       ³ TRM040   ³ Autor ³ Eduardo Ju            ³ Data ³ 09.06.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao    ³ Custo do Treinamento Anual                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso          ³ TRM030                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador  ³ Data	 ³ BOPS ³  Motivo da Alteracao 					     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Eduardo Ju  	³13/07/07³124525³Implementacao do Log de Inconsistencias.    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programador  ³ Data     ³ FNC            ³  Motivo da Alteracao                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³±±
±±³Rogerio R.   ³29/07/2009³00000018271/2009³Compatibilizacao dos fontes para aumento do³±±
±±³             ³          ³                ³campo filial e gestão corporativa.         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function TRM040()

Local oReport
Local aArea := GetArea()
Private aValor 	:= Array(12)
Private aHoras 	:= Array(12)

If FindFunction("TRepInUse") .And. TRepInUse()	//Verifica se relatorio personalizal esta disponivel 
	TR040RSX1()	//Criacao do Pergunte (SX1)
	Pergunte("TR040R",.F.)
	oReport := ReportDef()
	oReport:PrintDialog()	
Else
	U_TRM040R3()	
EndIf  

RestArea( aArea )

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ReportDef() ³ Autor ³ Eduardo Ju          ³ Data ³ 23.08.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Definicao do Componente de Impressao do Relatorio           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ReportDef()

Local oReport
Local oSection1	
Local oSection2
Local oSection3	 
Local oBreakCC  
Local aOrdem    := {}
Local nTotal	:= 0 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
//³ExpC5 : Descricao                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
oReport:=TReport():New("TRM040",STR0001,"TR040R",{|oReport| PrintReport(oReport)},STR0002+" "+STR0003)	//"Custo de Treinamento Anual"#"Será impresso de acordo com os parametros solicitados pelo usuario"
oReport:SetTotalInLine(.F.) //Totaliza em linha 
oReport:SetLandscape()		//Imprimir Somente Paisagem
Pergunte("TR040R",.F.)  

Aadd( aOrdem, STR0004)	// "Curso"
Aadd( aOrdem, STR0005)	// "Centro de Custo"

//******************* Relatorio por Curso **********************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao da Primeira Secao: "Curso" - Valor ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
oSection1 := TRSection():New(oReport,STR0035 + " -" + STR0011,{"RA4","RA1"},aOrdem,/*Campos do SX3*/,/*Campos do SIX*/)	//"Custo por Curso - Valor"
oSection1 :SetTotalInLine(.F.)   
oSection1:SetHeaderBreak(.T.) 

TRCell():New(oSection1,"RA4_CURSO","RA4",CRLF + STR0004,,,,{|| cCurso })		//Codigo do Curso
TRCell():New(oSection1,"RA1_DESC","RA1","")									//Descricao do Curso  
TRCell():New(oSection1,"JANEIRO"	,"   ",	STR0020 + CRLF + STR0033 ,"@R 9999,999.99",12,, {|| aValor[1] })
TRCell():New(oSection1,"FEVEREIRO"	,"   ", STR0021 + CRLF + STR0033 ,"@R 9999,999.99",12,, {|| aValor[2] })
TRCell():New(oSection1,"MARCO"		,"   ", STR0022 + CRLF + STR0033 ,"@R 9999,999.99",12,, {|| aValor[3] })
TRCell():New(oSection1,"ABRIL"		,"   ", STR0023 + CRLF + STR0033 ,"@R 9999,999.99",12,, {|| aValor[4] })
TRCell():New(oSection1,"MAIO"		,"   ", STR0024 + CRLF + STR0033 ,"@R 9999,999.99",12,, {|| aValor[5] })
TRCell():New(oSection1,"JUNHO"		,"   ", STR0025 + CRLF + STR0033 ,"@R 9999,999.99",12,, {|| aValor[6] })
TRCell():New(oSection1,"JULHO"		,"   ", STR0026 + CRLF + STR0033 ,"@R 9999,999.99",12,, {|| aValor[7] })
TRCell():New(oSection1,"AGOSTO"		,"   ", STR0027 + CRLF + STR0033 ,"@R 9999,999.99",12,, {|| aValor[8] })
TRCell():New(oSection1,"SETEMBRO"	,"   ", STR0028 + CRLF + STR0033 ,"@R 9999,999.99",12,, {|| aValor[9] })
TRCell():New(oSection1,"OUTUBRO"	,"   ", STR0029 + CRLF + STR0033 ,"@R 9999,999.99",12,, {|| aValor[10]})
TRCell():New(oSection1,"NOVEMBRO"	,"   ", STR0030 + CRLF + STR0033 ,"@R 9999,999.99",12,, {|| aValor[11]})
TRCell():New(oSection1,"DEZEMBRO"	,"   ", STR0031 + CRLF + STR0033 ,"@R 9999,999.99",12,, {|| aValor[12]})
TRCell():New(oSection1,"TOTAL"		,"   ", STR0032 ,"@R 9999,999.99",12,, {|| nTotal:= 0, aEval(aValor,{ |X| nTotal += X }), nTotal})	 	

TRPosition():New(oSection1,"RA1",1,{|| RhFilial("RA1",RA4->RA4_FILIAL)+ cCurso })

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao da Primeira Secao: "Curso" - Horas ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
oSection2 := TRSection():New(oReport,STR0035 + " -" + STR0012,{"RA4","RA1"},aOrdem,/*Campos do SX3*/,/*Campos do SIX*/)	//"Custo por Curso - Horas"
oSection2 :SetTotalInLine(.F.)   
oSection2:SetHeaderBreak(.T.)

TRCell():New(oSection2,"RA4_CURSO","RA4",CRLF + STR0004,,,,{|| cCurso })	//Codigo do Curso
TRCell():New(oSection2,"RA1_DESC","RA1","")									//Descricao do Curso  
TRCell():New(oSection2,"JANEIRO"	,"   ",	STR0020 + CRLF + STR0034,"@R 999,999",6,, {|| aHoras[1] })
TRCell():New(oSection2,"FEVEREIRO"	,"   ", STR0021 + CRLF + STR0034,"@R 999,999",6,, {|| aHoras[2] })
TRCell():New(oSection2,"MARCO"		,"   ", STR0022 + CRLF + STR0034,"@R 999,999",6,, {|| aHoras[3] })
TRCell():New(oSection2,"ABRIL"		,"   ", STR0023 + CRLF + STR0034,"@R 999,999",6,, {|| aHoras[4] })
TRCell():New(oSection2,"MAIO"		,"   ", STR0024 + CRLF + STR0034,"@R 999,999",6,, {|| aHoras[5] })
TRCell():New(oSection2,"JUNHO"		,"   ", STR0025 + CRLF + STR0034,"@R 999,999",6,, {|| aHoras[6] })
TRCell():New(oSection2,"JULHO"		,"   ", STR0026 + CRLF + STR0034,"@R 999,999",6,, {|| aHoras[7] })
TRCell():New(oSection2,"AGOSTO"		,"   ", STR0027 + CRLF + STR0034,"@R 999,999",6,, {|| aHoras[8] })
TRCell():New(oSection2,"SETEMBRO"	,"   ", STR0028 + CRLF + STR0034,"@R 999,999",6,, {|| aHoras[9] })
TRCell():New(oSection2,"OUTUBRO"	,"   ", STR0029 + CRLF + STR0034,"@R 999,999",6,, {|| aHoras[10]})
TRCell():New(oSection2,"NOVEMBRO"	,"   ", STR0030 + CRLF + STR0034,"@R 999,999",6,, {|| aHoras[11]})
TRCell():New(oSection2,"DEZEMBRO"	,"   ", STR0031 + CRLF + STR0034,"@R 999,999",6,, {|| aHoras[12]})
TRCell():New(oSection2,"TOTAL"		,"   ", STR0032,"@R 999,999",6,, {|| nTotal:= 0, aEval(aHoras,{ |X| nTotal += X }), nTotal})	 	
 
TRPosition():New(oSection2,"RA1",1,{|| RhFilial("RA1",RA4->RA4_FILIAL)+ cCurso })

//******************* Relatorio por CC **********************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao da Terceira Secao: "C.Custo" ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
oSection3 := TRSection():New(oReport, STR0001 ,{"RA4","SRA"},aOrdem,/*Campos do SX3*/,/*Campos do SIX*/)	//"Custo de Treinamento Anual"
oSection3 :SetTotalInLine(.F.)   
oSection3:SetHeaderBreak(.T.)  

TRCell():New(oSection3,"RA_CC","SRA",,,,,{|| TRA->TR_CC })	//Centro de Custo
TRCell():New(oSection3,"CTT_DESC01","CTT","")				//Descricao do Centro de Custo

TRPosition():New(oSection3,"SRA",1,{|| RhFilial("SRA",TRA->TR_FILIAL)+ TRA->TR_MAT })
TRPosition():New(oSection3,"CTT",1,{|| RhFilial("CTT",TRA->TR_FILIAL)+ TRA->TR_CC })

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao da Quarta Secao: C.Custo por Valor  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection4 := TRSection():New(oSection3,STR0037 + " -" + STR0011,{"RA4","RA1"},/*aOrdem*/,/*Campos do SX3*/,/*Campos do SIX*/)		//"Custo por C.Custo - Valor"
oSection4:SetTotalInLine(.F.)  
oSection4:SetHeaderBreak(.T.)  

TRCell():New(oSection4,"RA4_CURSO","RA4",CRLF + STR0004,,,,{|| cCurso })	//Codigo do Curso
TRCell():New(oSection4,"RA1_DESC","RA1","")									//Descricao do Curso  
TRCell():New(oSection4,"JANEIRO"	,"   ",	STR0020 + CRLF + STR0033,"@R 9999,999.99",12,, {|| aValor[1] })
TRCell():New(oSection4,"FEVEREIRO"	,"   ", STR0021 + CRLF + STR0033,"@R 9999,999.99",12,, {|| aValor[2] })
TRCell():New(oSection4,"MARCO"		,"   ", STR0022 + CRLF + STR0033,"@R 9999,999.99",12,, {|| aValor[3] })
TRCell():New(oSection4,"ABRIL"		,"   ", STR0023 + CRLF + STR0033,"@R 9999,999.99",12,, {|| aValor[4] })
TRCell():New(oSection4,"MAIO"		,"   ", STR0024 + CRLF + STR0033,"@R 9999,999.99",12,, {|| aValor[5] })
TRCell():New(oSection4,"JUNHO"		,"   ", STR0025 + CRLF + STR0033,"@R 9999,999.99",12,, {|| aValor[6] })
TRCell():New(oSection4,"JULHO"		,"   ", STR0026 + CRLF + STR0033,"@R 9999,999.99",12,, {|| aValor[7] })
TRCell():New(oSection4,"AGOSTO"		,"   ", STR0027 + CRLF + STR0033,"@R 9999,999.99",12,, {|| aValor[8] })
TRCell():New(oSection4,"SETEMBRO"	,"   ", STR0028 + CRLF + STR0033,"@R 9999,999.99",12,, {|| aValor[9] })
TRCell():New(oSection4,"OUTUBRO"	,"   ", STR0029 + CRLF + STR0033,"@R 9999,999.99",12,, {|| aValor[10]})
TRCell():New(oSection4,"NOVEMBRO"	,"   ", STR0030 + CRLF + STR0033,"@R 9999,999.99",12,, {|| aValor[11]})
TRCell():New(oSection4,"DEZEMBRO"	,"   ", STR0031 + CRLF + STR0033,"@R 9999,999.99",12,, {|| aValor[12]})
TRCell():New(oSection4,"TOTAL"		,"   ",STR0032,"@R 9999,999.99",12,, {|| nTotal:= 0, aEval(aValor,{ |X| nTotal += X }), nTotal})	 	

TRPosition():New(oSection4,"RA1",1,{|| RhFilial("RA1",TRA->TR_FILIAL)+ cCurso })

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao da Quinta Secao: C.Custo por Horas ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
oSection5 := TRSection():New(oSection3,STR0037 + " -" + STR0012,{"RA4","RA1"},aOrdem,/*Campos do SX3*/,/*Campos do SIX*/)	//"Custo do Treinamento Anual por Curso"
oSection5 :SetTotalInLine(.F.)   
oSection5:SetHeaderBreak(.T.) 

TRCell():New(oSection5,"RA4_CURSO","RA4",CRLF + "Curso",,,,{|| cCurso })	//Codigo do Curso
TRCell():New(oSection5,"RA1_DESC","RA1","")									//Descricao do Curso  
TRCell():New(oSection5,"JANEIRO"	,"   ",	STR0020 + CRLF + STR0034,"@R 999,999",6,, {|| aHoras[1] })
TRCell():New(oSection5,"FEVEREIRO"	,"   ", STR0021 + CRLF + STR0034,"@R 999,999",6,, {|| aHoras[2] })
TRCell():New(oSection5,"MARCO"		,"   ", STR0022 + CRLF + STR0034,"@R 999,999",6,, {|| aHoras[3] })
TRCell():New(oSection5,"ABRIL"		,"   ", STR0023 + CRLF + STR0034,"@R 999,999",6,, {|| aHoras[4] })
TRCell():New(oSection5,"MAIO"		,"   ", STR0024 + CRLF + STR0034,"@R 999,999",6,, {|| aHoras[5] })
TRCell():New(oSection5,"JUNHO"		,"   ", STR0025 + CRLF + STR0034,"@R 999,999",6,, {|| aHoras[6] })
TRCell():New(oSection5,"JULHO"		,"   ", STR0026 + CRLF + STR0034,"@R 999,999",6,, {|| aHoras[7] })
TRCell():New(oSection5,"AGOSTO"		,"   ", STR0027 + CRLF + STR0034,"@R 999,999",6,, {|| aHoras[8] })
TRCell():New(oSection5,"SETEMBRO"	,"   ", STR0028 + CRLF + STR0034,"@R 999,999",6,, {|| aHoras[9] })
TRCell():New(oSection5,"OUTUBRO"	,"   ", STR0029 + CRLF + STR0034,"@R 999,999",6,, {|| aHoras[10]})
TRCell():New(oSection5,"NOVEMBRO"	,"   ", STR0030 + CRLF + STR0034,"@R 999,999",6,, {|| aHoras[11]})
TRCell():New(oSection5,"DEZEMBRO"	,"   ", STR0031 + CRLF + STR0034,"@R 999,999",6,, {|| aHoras[12]})
TRCell():New(oSection5,"TOTAL"		,"   ",STR0032,"@R 999,999",6,, {|| nTotal:= 0, aEval(aHoras,{ |X| nTotal += X }), nTotal})	 	

TRPosition():New(oSection5,"RA1",1,{|| RhFilial("RA1",TRA->TR_FILIAL)+ cCurso })

Return oReport

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ReportDef() ³ Autor ³ Eduardo Ju          ³ Data ³ 30.05.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Impressao do Relatorio (Custo do Treinamento)               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function PrintReport(oReport) 

Local nOrdem  	:= oReport:Section(1):GetOrder() 
Local oSection1 
Local oSection2 
Local cFiltroRA4:= ""
Local cFiltroSRA:= ""
Local cFiltroSQ3:= ""
Local cArqDBF  	:= ""
Local aFields 	:= {}
Local cAcessaRA4:= 	 &("{ || " + ChkRH("TRM040","RA4","2") + "}")
Local cSituacao := ""
Local nFerProg  := 0
Local cSitFol   := "" 
Local cTit		:= ""
Local aLogCargo	:= {}    
Local aLogTitle	:= {}
Local lExcLogCargo:= .F.  
Local cMainTitle:= ""
Local cTitle1	:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao da celulas da secao do relatorio                                ³
//³TRCell():New                                                            ³
//³ExpO1 : Objeto TSection que a secao pertence                            ³
//³ExpC2 : Nome da celula do relatório. O SX3 será consultado              ³
//³ExpC3 : Nome da tabela de referencia da celula                          ³
//³ExpC4 : Titulo da celula                                                ³
//³        Default : X3Titulo()                                            ³
//³ExpC5 : Picture                                                         ³
//³        Default : X3_PICTURE                                            ³
//³ExpC6 : Tamanho                                                         ³
//³        Default : X3_TAMANHO                                            ³
//³ExpL7 : Informe se o tamanho esta em pixel                              ³
//³        Default : False                                                 ³
//³ExpB8 : Bloco de código para impressao.                                 ³
//³        Default : ExpC2                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ            
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                                   ³
//³ MV_PAR01        //  Filial?                                            ³
//³ MV_PAR02        //  Matricula ?                                        ³
//³ MV_PAR03        //  Centro de Custo?                                   ³
//³ MV_PAR04        //  Nome?                                              ³
//³ MV_PAR05        //  Curso?                                             ³
//³ MV_PAR06        //  Grupo?                                             ³
//³ MV_PAR07        //  Depto?                                             ³
//³ MV_PAR08        //  Cargo?                                             ³
//³ MV_PAR09        //  Ano?                                               ³
//³ MV_PAR10        //  Totais Em? 1- Valor; 2- Horas                      ³
//³ MV_PAR11        //  Situacoes?                                         ³ 
//³ MV_PAR12        //  Ferias Programadas?                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Transforma parametros Range em expressao (intervalo) ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MakeAdvplExpr("TR040R")	    

cSituacao 	:= MV_PAR11
nFerProg  	:= MV_PAR12
//cSitFol   := ""
               
If nOrdem = 1	//Relatorio por Curso

	oSection1 := If(MV_PAR10 = 1, oReport:Section(1), oReport:Section(2))	//Por Valor # Por Horas
	
	TRFunction():New(oSection1:Cell("JANEIRO")  ,/*cId*/,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F.,/*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oSection1:Cell("FEVEREIRO"),/*cId*/,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F.,/*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oSection1:Cell("MARCO")    ,/*cId*/,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F.,/*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oSection1:Cell("ABRIL")    ,/*cId*/,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F.,/*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oSection1:Cell("MAIO")     ,/*cId*/,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F.,/*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oSection1:Cell("JUNHO")    ,/*cId*/,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F.,/*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oSection1:Cell("JULHO")    ,/*cId*/,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F.,/*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oSection1:Cell("AGOSTO")   ,/*cId*/,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F.,/*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oSection1:Cell("SETEMBRO") ,/*cId*/,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F.,/*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oSection1:Cell("OUTUBRO")  ,/*cId*/,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F.,/*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oSection1:Cell("NOVEMBRO") ,/*cId*/,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F.,/*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oSection1:Cell("DEZEMBRO") ,/*cId*/,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F.,/*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oSection1:Cell("TOTAL")    ,/*cId*/,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F.,/*lEndReport*/,/*lEndPage*/)
		
Else			//Relatorio por C.Custo 

	oSection1 := oReport:Section(3)	
	oSection2 := If(MV_PAR10 = 1, oSection1:Section(1), oSection1:Section(2))

	oBreakCC := TRBreak():New(oReport,oSection1:Cell("RA_CC"),STR0036) // "Total por C.Custo"
	
	TRFunction():New(oSection2:Cell("JANEIRO")  ,/*cId*/,"SUM",oBreakCC,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F.,/*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oSection2:Cell("FEVEREIRO"),/*cId*/,"SUM",oBreakCC,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F.,/*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oSection2:Cell("MARCO")    ,/*cId*/,"SUM",oBreakCC,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F.,/*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oSection2:Cell("ABRIL")    ,/*cId*/,"SUM",oBreakCC,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F.,/*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oSection2:Cell("MAIO")     ,/*cId*/,"SUM",oBreakCC,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F.,/*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oSection2:Cell("JUNHO")    ,/*cId*/,"SUM",oBreakCC,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F.,/*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oSection2:Cell("JULHO")    ,/*cId*/,"SUM",oBreakCC,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F.,/*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oSection2:Cell("AGOSTO")   ,/*cId*/,"SUM",oBreakCC,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F.,/*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oSection2:Cell("SETEMBRO") ,/*cId*/,"SUM",oBreakCC,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F.,/*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oSection2:Cell("OUTUBRO")  ,/*cId*/,"SUM",oBreakCC,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F.,/*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oSection2:Cell("NOVEMBRO") ,/*cId*/,"SUM",oBreakCC,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F.,/*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oSection2:Cell("DEZEMBRO") ,/*cId*/,"SUM",oBreakCC,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F.,/*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oSection2:Cell("TOTAL")    ,/*cId*/,"SUM",oBreakCC,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F.,/*lEndReport*/,/*lEndPage*/) 

Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Filtra RA4   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(MV_PAR01)	//RA4_FILIAL
	cFiltroRA4 := MV_PAR01
EndIf 

If !Empty(MV_PAR02)	//RA4_MAT 
	cFiltroRA4 += IIF(!Empty(cFiltroRA4)," .And. ","")
	cFiltroRA4 += MV_PAR02 
EndIf

If !Empty(MV_PAR05)	//RA4_CURSO  
	cFiltroRA4 += IIF(!Empty(cFiltroRA4)," .And. ","")
	cFiltroRA4 += MV_PAR05
EndIf                                 

If !Empty(cFiltroRA4) 
	cFiltroRA4 += ' .And. Year(RA4_DATAIN) = ' + AllTrim(Str(MV_PAR09)) 	//Apenas Filtrar Registros do Ano definido no parametro.		
Else
	cFiltroRA4 += ' Year(RA4_DATAIN) = ' + AllTrim(Str(MV_PAR09)) 	//Apenas Filtrar Registros do Ano definido no parametro.		
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Filtra SRA   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(MV_PAR03)	//RA_CC
	cFiltroSRA := MV_PAR03 
EndIf

If !Empty(MV_PAR04)	//RA_NOME  
	cFiltroSRA += IIF(!Empty(cFiltroSRA)," .And. ","")
	cFiltroSRA += MV_PAR04
EndIf        

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Filtra SQ3   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(MV_PAR06)	//Q3_GRUPO
	cFiltroSQ3 := MV_PAR06
EndIf  

If !Empty(MV_PAR07)	//Q3_DEPTO 
	cFiltroSQ3 += IIF(!Empty(cFiltroSQ3)," .And. ","")
	cFiltroSQ3 += MV_PAR07 
EndIf

If !Empty(MV_PAR08)	//Q3_CARGO
	cFiltroSQ3 += IIF(!Empty(cFiltroSQ3)," .And. ","")
	cFiltroSQ3 += MV_PAR08 
EndIf        

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao do filtro para a Tabela Principal e Secundaria ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
oSection1:SetFilter(cFiltroRA4,,,"RA4")	
oSection1:SetFilter(cFiltroSRA,,,"SRA")		
oSection1:SetFilter(cFiltroSQ3,,,"SQ3") 
   
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Arquivo Principal: Cursos do Funcionario ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("RA4")	
dbSetOrder(2)	
RA4->( DbGoTop() )
oReport:SetMeter(RecCount()) 

//Inicializa
aFill(aHoras,0)	
aFill(aValor,0)

If nOrdem = 1   //Por Curso
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Centralizacao das Celulas do Relatorio ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
	oSection1:Cell("JANEIRO"):SetHeaderAlign("CENTER")
	oSection1:Cell("FEVEREIRO"):SetHeaderAlign("CENTER")
	oSection1:Cell("MARCO"):SetHeaderAlign("CENTER")
	oSection1:Cell("ABRIL"):SetHeaderAlign("CENTER")
	oSection1:Cell("MAIO"):SetHeaderAlign("CENTER")
	oSection1:Cell("JUNHO"):SetHeaderAlign("CENTER")
	oSection1:Cell("JULHO"):SetHeaderAlign("CENTER")
	oSection1:Cell("AGOSTO"):SetHeaderAlign("CENTER")
	oSection1:Cell("SETEMBRO"):SetHeaderAlign("CENTER")
	oSection1:Cell("OUTUBRO"):SetHeaderAlign("CENTER")
	oSection1:Cell("NOVEMBRO"):SetHeaderAlign("CENTER")
	oSection1:Cell("DEZEMBRO"):SetHeaderAlign("CENTER")
	oSection1:Cell("TOTAL"):SetHeaderAlign("CENTER")

	oSection1:Init() 

	While !RA4->(Eof())

		cCurso 	:= RA4->RA4_CURSO 
			
		oReport:IncMeter()
		
		If oReport:Cancel()
			Exit
		EndIf
		
		While !RA4->(Eof()) .And. cCurso == RA4->RA4_CURSO
			Begin Sequence
				If !Eval(cAcessaRA4)
				    break
				EndIf
				dbSelectArea("SRA")
				dbSetOrder(1)
				
				If dbSeek(RA4->RA4_FILIAL+RA4->RA4_MAT)
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Situacao do Funcionario  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					cSitFol := TrmSitFol()
					cCargo 	:= fGetCargo(SRA->RA_MAT)
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Alimenta array com os registros que não ha cargo ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
					If Empty(cCargo)
						aAdd( aLogCargo,SRA->RA_FILIAL + Space(05) + SRA->RA_MAT + Space(04) + SRA->RA_NOME + Space(01) + RA4->RA4_CALEND + Space(07) + RA4->RA4_CURSO) 
					EndIf
						
					If	(!(cSitfol $ cSituacao) 	.And.	(cSitFol <> "P")) .Or.;
						(cSitfol == "P" .And. nFerProg == 2)
					    Break
					EndIf    
					nMes := Month(RA4->RA4_DATAIN)
					aHoras[nMes] := aHoras[nMes]  + RA4->RA4_HORAS
					aValor[nMes] := aValor[nMes]  + RA4->RA4_VALOR
				EndIf    
			End Sequence
			dbSelectArea("RA4")
			dbSkip()
		EndDo  
		oSection1:PrintLine() 
		aFill(aHoras,0)	
		aFill(aValor,0)
	EndDo 
	oSection1:Finish() 
Else  //Relatorio do Centro de custo

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Centralizacao das Celulas do Relatorio ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
	oSection2:Cell("JANEIRO"):SetHeaderAlign("CENTER")
	oSection2:Cell("FEVEREIRO"):SetHeaderAlign("CENTER")
	oSection2:Cell("MARCO"):SetHeaderAlign("CENTER")
	oSection2:Cell("ABRIL"):SetHeaderAlign("CENTER")
	oSection2:Cell("MAIO"):SetHeaderAlign("CENTER")
	oSection2:Cell("JUNHO"):SetHeaderAlign("CENTER")
	oSection2:Cell("JULHO"):SetHeaderAlign("CENTER")
	oSection2:Cell("AGOSTO"):SetHeaderAlign("CENTER")
	oSection2:Cell("SETEMBRO"):SetHeaderAlign("CENTER")
	oSection2:Cell("OUTUBRO"):SetHeaderAlign("CENTER")
	oSection2:Cell("NOVEMBRO"):SetHeaderAlign("CENTER")
	oSection2:Cell("DEZEMBRO"):SetHeaderAlign("CENTER")
	oSection2:Cell("TOTAL"):SetHeaderAlign("CENTER")
	
	cArqDBF  	:= CriaTrab(NIL,.f.)

	AADD(aFields,{"TR_FILIAL", "C", FWGETTAMFILIAL,          0                       } )
	AADD(aFields,{"TR_MAT",    "C", TamSx3("RA_MAT")[1],     TamSx3("RA_MAT")[2]     } )
	AADD(aFields,{"TR_CC",     "C", TamSx3("RA_CC")[1],      TamSx3("RA_CC")[2]      } )
	AADD(aFields,{"TR_CURSO",  "C", TamSx3("RA4_CURSO")[1],  TamSx3("RA4_CURSO")[2]  } )  
	AADD(aFields,{"TR_CUSTO",  "N", TamSx3("RA4_VALOR")[1],  TamSx3("RA4_VALOR")[2]  } )  
	AADD(aFields,{"TR_HORAS",  "N", TamSx3("RA4_HORAS")[1],  TamSx3("RA4_HORAS")[2]  } )  
	AADD(aFields,{"TR_DATA",   "D", TamSx3("RA4_DATAIN")[1], TamSx3("RA4_DATAIN")[2]  } )  

	dbCreate(cArqDbf, aFields)
	dbUseArea(.T., NIL, cArqDbf, "TRA", .F.)
	cIndCond := "TR_CC + TR_CURSO"	// Centro de Custo + Curso  

	cArqNtx  := CriaTrab(NIL,.f.)
	IndRegua("TRA",cArqNtx,cIndCond,,,)

	dbGoTop()

	dbSelectArea("RA4")
	dbSetOrder(1)
	dbGoTop()

	While !RA4->(Eof())	    
		
		If !Eval(cAcessaRA4)
			dbSkip()
			Loop
		EndIf
		
		dbSelectArea("SRA")
		dbSetOrder(1)
	
		If dbSeek(RA4->RA4_FILIAL+RA4->RA4_MAT)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Situacao do Funcionario  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cSitFol := TrmSitFol()
			cCargo 	:= fGetCargo(SRA->RA_MAT)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Alimenta array com os registros que não ha cargo ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
			If Empty(cCargo)
				aAdd( aLogCargo,SRA->RA_FILIAL + Space(05) + SRA->RA_MAT + Space(04) + SRA->RA_NOME + Space(01) + RA4->RA4_CALEND + Space(07) + RA4->RA4_CURSO) 
			EndIf
			
			If	(!(cSitfol $ cSituacao) 	.And.	(cSitFol <> "P")) .Or.;
				(cSitfol == "P" .And. nFerProg == 2)
				
				dbSelectArea("RA4")
				dbSkip()
				Loop
			EndIf
							
			RecLock("TRA",.T.)
				TRA->TR_FILIAL	:= RA4->RA4_FILIAL 
				TRA->TR_MAT		:= SRA->RA_MAT
				TRA->TR_CC		:= SRA->RA_CC
				TRA->TR_CURSO	:= RA4->RA4_CURSO
				TRA->TR_CUSTO	:= RA4->RA4_VALOR
				TRA->TR_HORAS	:= RA4->RA4_HORAS
				TRA->TR_DATA 	:= RA4->RA4_DATAIN
			MsUnlock()
			dbSelectArea("RA4")
		  	dbSkip()
        Else
			dbSelectArea("RA4")
		  	dbSkip()
		EndIf		
		
	EndDo
		
	aHoras := Array(12)
	aValor := Array(12)
		
	aFill(aHoras,0)
	aFill(aValor,0)
	
	dbSelectArea("TRA")
	dbGotop()
		
	While !Eof() 
				
		oReport:IncMeter()
		
		If oReport:Cancel()
			Exit
		EndIf    
		
		cCC 	:= TRA->TR_CC 
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao da Secao Pai ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	   	oSection1:Init()
		oSection1:PrintLine()
		oSection1:Finish()  
		
		While !TRA->(Eof()) .And. cCC == TRA->TR_CC 
		 
			cCurso	:= TRA->TR_CURSO
						
			//While !Eof() .And. cCurso == TRA->TR_CURSO
			While !TRA->(Eof()) .And. cCc + cCurso == TRA->TR_CC + TRA->TR_CURSO
				 	
				nMes := Month(TRA->TR_DATA)
								
				aHoras[nMes] := aHoras[nMes]  + TRA->TR_HORAS
				aValor[nMes] := aValor[nMes]  + TRA->TR_CUSTO
				
			   	TRA->( dbSkip() )
			EndDo 
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Impressao da Secao Filha ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oSection2:Init()
			oSection2:PrintLine()
			
			aFill(aHoras,0)	
			aFill(aValor,0)
		EndDo
		
		oSection2:Finish()
		
	EndDo    
	
	dbSelectArea("TRA")
	dbCloseArea()
	fErase(cArqNtx + OrdBagExt())
	fErase(cArqDbf + GetDBExtension()) 
	
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera Arquivo Log com as Inconsistencias no vinculo Funcao x Cargo  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( lExcLogCargo := !Empty(aLogCargo) ) 

	cMainTitle 	:= STR0038			//"Inconsistências na função ou cargo"
	cTitle1		:= Upper(STR0039)	//"Filial Matricula Funcionario                    Calendario Curso"   
   
  	aAdd(aLogTitle,cTitle1)

	If ( lExcLogCargo := MsgNoYes(STR0040, STR0001 + " - " + cMainTitle ) )	//"Foram encontradas inconsistências no vínculo Função x Cargo. Deseja gerar Log?"
		FMakeLog( { aLogCargo } , aLogTitle , , NIL , NIL , STR0001 + Space(01)+ "("+ cMainTitle+")","M","P",,.F. )			
	EndIf	                            
	
EndIf

Return Nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³TR040RSX1 ³ Autor ³ Eduardo Ju            ³ Data ³ 24.08.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Criacao do Pergunte TR040R no Dicionario SX1                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³CSR50RSX1                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/ 
Static Function TR040RSX1()             

Local aRegs		:= {} 
Local cPerg		:= "TR040R"  
Local aHelp		:= {}
Local aHelpE	:= {}
Local aHelpI	:= {}   
Local cHelp		:= ""

aHelp := {	"Informe intervalo de filiais que ",;
			"deseja considerar para impressao ",;
			"do relatorio." }
aHelpE:= {	"Informe intervalo de sucursales que ",;
			"desea considerar para impresion del ",;
			"informe" }
aHelpI:= {	"Enter branch range to be considered ",;
			"to print report." }
cHelp := ".RHFILIAL."
PutSX1Help("P"+cHelp,aHelp,aHelpI,aHelpE)	 
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³           Grupo    Ordem   Pergunta Portugues      Pergunta Espanhol           Pergunta Ingles             Variavel    Tipo    Tamanho     Decimal Presel  GSC     Valid           Var01       Def01               DefSPA1             DefEng1             Cnt01               Var02   Def02               DefSpa2             DefEng2         Cnt02       Var03   Def03               DefSpa3             DefEng3         Cnt03   Var04   Def04       DefSpa4     DefEng4     Cnt04   Var05   Def05       DefSpa5     DefEng5     Cnt05   XF3   GrgSxg cPyme  aHelpPor    aHelpEng    aHelpSpa    cHelp  ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Aadd(aRegs,{cPerg	,"01"	,"Filial ?"	   		,"¿Sucursal?"  			,"Branch?"				,"mv_ch1"  	,"C"	,99			,0		,0		,"R"	,""		    ,"MV_PAR01"	,""					,""					,""					,"RA4_FILIAL"		,""		,""					,""					,""				,""			,""		,""					,""					,""				,""		,""		,""			,""			,""			,""		,""     ,""			,""			,""			,""		,"XM0",""  ,"S"	,{}			,{}			,{}			,cHelp})


/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Matricula       														³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
aHelp := {	"Informe intervalo de matriculas que ",;
			"deseja considerar para impressao do ",;
			"relatorio." }
aHelpE:= {	"Informe intervalo de matriculas que ",;
			"desea considerar para impresion del ",;
			"informe." }
aHelpI:= {	"Enter registration range to be ",;
			"considered for printing the report." }
cHelp := ".RHMATRIC."
PutSX1Help("P"+cHelp,aHelp,aHelpI,aHelpE)	 
Aadd(aRegs,{cPerg,"02","Matricula ?","¿Matricula ?","Registration ?","mv_ch2","C",99,0,0,"R","","MV_PAR02"	,"","","","RA4_MAT"	,"","","","","","","","","","","","","",""	,"","","","",""	,"","SRA","","S",{}	  ,{}	,{}	,cHelp})
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Centro de Custo											³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
aHelp := {	"Informe intervalo de Centros de Custo ",;
			"que deseja considerar para impressao ",;
			"do relatorio." }
aHelpE:= {	"Informe intervalo de centros de costo ",;
			"que desea considerar para impresion ",;
			"del informe." }
aHelpI:= {	"Enter the cost center range to be ",;
			"considered for printing the report." }
cHelp := ".RHCCUSTO."
PutSX1Help("P"+cHelp,aHelp,aHelpI,aHelpE)
Aadd(aRegs,{cPerg	,"03","Centro de Custo ?"	,"¿Centro de Costo ?"    ,"Cost Center ?"	       ,"mv_ch3","C",99		,0		,0	,"R"	,""	,"MV_PAR03"	,""	,""		,""		,"RA_CC"		,""	,""		,""		,""		,""						,""		,""		,""		,""		,""		,""	,""		,""		,""		,""		,"" ,""		,""		,""		,""		,"CTT",""   ,"S"	,{}			,{}			,{}			,cHelp})              

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Nome            											³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
aHelp := {	"Informe intervalo de nomes de funcio-",;
			"narios que deseja considerar para im-",;
			"pressao do relatorio." }
aHelpE:= {	"Informe intervalo de nombres de empleados ",;
			"que desea considerar para impresion del ",;
			"informe." }
aHelpI:= {	"Enter range of employee names to be ",;
			"considered for printing the report." }
cHelp := ".RHNOME."
PutSX1Help("P"+cHelp,aHelp,aHelpI,aHelpE)	 
Aadd(aRegs,{cPerg,"04","Nome ?"	,"¿Nombre?","Name ?","mv_ch4","C",99,0	,0,"R","","MV_PAR04",""	,"","","RA_NOME","","","","","","","","","","","","","","","",""     ,""			,""			,""			,""		,""	,"","S"	,{}			,{}			,{}			,cHelp})              
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Curso            											³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
aHelp := {	"Informe intervalo de curso que deseja",;
			" considerar para impressao do relatorio." }

aHelpE:= {	"Informe intervalo de curso que desea",;
			" considerar para impresion del informe." }
			
aHelpI:= {	"Enter range of course code  to be ",;
			"considered for printing the report." }

cHelp := ".TR040R05."
Aadd(aRegs,{cPerg,"05"	,"Curso ?"	,"¿Curso ?","Course ?","mv_ch5"  	,"C",99,0,0,"R","","MV_PAR05"	,""	,"","","RA4_CURSO","","","","","","","","","","","",""	,"","","","","","","","","RA1"    ,"","S"	,aHelp		,aHelpI		,aHelpE			,cHelp})

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Grupo                                                     ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
aHelp := {	"Informe intervalo de grupo que deseja",;
			" considerar para impressao do relatorio." }

aHelpE:= {	"Informe intervalo de grupo que desea",;
			" considerar para impresion del informe." }
			
aHelpI:= {	"Enter range of group  to be ",;
			"considered for printing the report." }

cHelp := ".TR040R06."
Aadd(aRegs,{cPerg	,"06"	,"Grupo ?"	   		,"¿Grupo ?"     		,"Group ?"				,"mv_ch6"  	,"C"	,99			,0		,0		,"R"	,""			,"MV_PAR06"	,""					,""					,""					,"Q3_GRUPO"			,""		,""					,""					,""				,""			,""		,""					,""					,""				,""		,""		,""			,""			,""			,""		,""     ,""			,""			,""			,""		,"SQ0"		,"","S"	,aHelp		,aHelpI		,aHelpE			,cHelp})

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Departamento                                              ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
aHelp := {	"Informe intervalo de departamento que deseja",;
			" considerar para impressao do relatorio." }

aHelpE:= {	"Informe intervalo de sector que desea",;
			" considerar para impresion del informe." }
			
aHelpI:= {	"Enter range of department to be ",;
			"considered for printing the report." }

cHelp := ".TR040R07."
Aadd(aRegs,{cPerg	,"07"	,"Departamento ?"	,"¿Sector ?"     		,"Department ?"			,"mv_ch7"  	,"C"	,99			,0		,0		,"R"	,""			,"MV_PAR07"	,""					,""					,""					,"Q3_DEPTO"			,""		,""					,""					,""				,""			,""		,""					,""					,""				,""		,""		,""			,""			,""			,""		,""     ,""			,""			,""			,""		,"SQB"	,"","S"	,aHelp		,aHelpI		,aHelpE			,cHelp})

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Cargo                                                     ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
aHelp := {	"Informe intervalo de cargo que deseja",;
			" considerar para impressao do relatorio." }

aHelpE:= {	"Informe intervalo de funcion que desea",;
			" considerar para impresion del informe." }
			
aHelpI:= {	"Enter range of job to be ",;
			"considered for printing the report." }

cHelp := ".TR040R08."
Aadd(aRegs,{cPerg	,"08"	,"Cargo ?"			,"¿Funcion ?"     		,"Job ?"				,"mv_ch8"  	,"C"	,99			,0		,0		,"R"	,""			,"MV_PAR08"	,""					,""					,""					,"Q3_CARGO"			,""		,""					,""					,""				,""			,""		,""					,""					,""				,""		,""		,""			,""			,""			,""		,""     ,""			,""			,""			,""		,""		,"","S"	,aHelp		,aHelpI		,aHelpE			,cHelp})
/*
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Usando o Help do R3                                       ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Aadd(aRegs,{cPerg	,"09"	,"Ano(AAAA) ?"		,"¿Año(AAAA) ?"     	,"Year (YYYY) ?"		,"mv_ch9"  	,"N"	,4			,0		,0		,"G"	,""			,"MV_PAR09"	,""					,""					,""					,""			  		,""		,""					,""					,""				,""			,""		,""					,""					,""				,""		,""		,""			,""			,""			,""		,""     ,""			,""			,""			,""		,""		,"","S"	,{}			,{}			,{}			,'.TRR06017.'}) 
Aadd(aRegs,{cPerg	,"10"	,"Totais em ?"		,"¿Totales en ?"    	,"Totals in ?"			,"mv_cha"  	,"N"	,1			,0		,1		,"C"	,""			,"MV_PAR10"	,"Valor"			,"Valor"			,"Value"			,""	   				,""		,"Horas"			,"Horas"			,"Hours"		,""			,""		,""					,""					,""				,""		,""		,""			,""			,""			,""		,""     ,""			,""			,""			,""		,""		,"","S"	,{}			,{}			,{}			,'.TRR06018.'})              
Aadd(aRegs,{cPerg	,"11"	,"Situacoes ?"		,"¿Situaciones ?"    	,"Status ?"		   		,"mv_chb"  	,"C"	,5			,0		,0		,"G"	,"fSituacao","MV_PAR11"	,""		   			,""					,""					,""	   				,""		,""					,""					,""				,""			,""		,""					,""					,""				,""		,""		,""			,""			,""			,""		,""     ,""			,""			,""			,""		,""		,"","S"	,{}			,{}			,{}			,'.RHSITUA.'})              
Aadd(aRegs,{cPerg	,"12"	,"Ferias Programadas ?"	,"¿Vacaciones Programadas ?","Scheduled Vacation ?"	,"mv_chc"  	,"N"	,1	,0		,1		,"C"	,""			,"MV_PAR12"	,"Sim"	   			,"Si"				,"Yes"				,""	   				,""		,"Nao"				,"No"				,"No"   		,""			,""		,""					,""					,""				,""		,""		,""			,""			,""			,""		,""     ,""			,""			,""			,""		,""		,"","S"	,{}			,{}			,{}			,'.TRR06020.'})  

ValidPerg(aRegs,cPerg)

Return Nil

/*
PROGRAMA FONTE ORIGINAL ABAIXO
*/

User Function TRM040R3()

SetPrvt("CDESC1,CDESC2,CDESC3,CSTRING,AORD,ARETURN")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,CPERG,LEND,COLUNAS")
SetPrvt("AT_PRG,CONTFL,LI,NPAG,NTAMANHO,ADRIVER")
SetPrvt("CTIT,TITULO,WNREL,NORDEM,CARQDBF")
SetPrvt("AFIELDS,CINDCOND,CARQNTX,CINICIO,CFIM,CFIL")
SetPrvt("LRET,AHORAS,AVALOR,ACHORAS,ACVALOR,ATHORAS")
SetPrvt("ATVALOR,CCURSO,CNOME,CCC,NMES,WCABEC0")
SetPrvt("WCABEC1,WCABEC2,NTOTAL,DET,NX,CAUX,LIMP")
SetPrvt("cAcessaRA4,nChar,cCargo,aLogCargo,aLogTitle,lExcLogCargo,cMainTitle,cTitle1") 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ TRM040   ³ Autor ³ Desenvolvimento R.H.  ³ Data ³ 16.03.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Custo do Treinamentos - Mensal                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ TRM040                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RdMake                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³  /  /  ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
cDesc1  := STR0001 //"Custo Treinamento Mensal"
cDesc2  := STR0002 //"Ser  impresso de acordo com os parametros solicitados pelo"
cDesc3  := STR0003 //"usu rio."
cString := "SRA"  			         //-- alias do arquivo principal (Base)
aOrd    := { STR0004,STR0005 } 		//"Curso"###"Centro de Custo"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis (Basicas)                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aReturn  := { STR0006,1,STR0007,2,2,1,"",1 } //"Zebrado"###"Administra‡„o"
NomeProg := "TRM040"
aLinha   := {}
nLastKey := 0
cPerg    := "TRR060"
lEnd     := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis (Programa)                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
COLUNAS  := 220
at_Prg   := "TRM040"
Contfl   := 1
Li       := 0
nPag     := 0
nTamanho := "G"
aDriver	 := ReadDriver()
nChar	 := 15
aLogCargo:= {}    
aLogTitle:= {}
lExcLogCargo:= .F.  
cMainTitle:= ""
cTitle1	:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("TRR060",.F.)

cTit   := STR0009 + Str(MV_PAR17,4) + STR0010 + IIf(MV_PAR18=1,STR0011,STR0012) //"Investimento em Treinamento no Ano de "###" em: "###" Valor"###" Horas"
Titulo := cTit
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ MV_PAR01        //  Filial  De                               ³
//³ MV_PAR02        //  Filial  Ate                              ³
//³ MV_PAR03        //  Matricula De                             ³
//³ MV_PAR04        //  Matricula Ate                            ³
//³ MV_PAR05        //  Centro de Custo                          ³
//³ MV_PAR06        //  Centro de Custo                          ³
//³ MV_PAR07        //  Nome De                                  ³
//³ MV_PAR08        //  Nome Ate                                 ³
//³ MV_PAR09        //  Curso De                                 ³
//³ MV_PAR10        //  Curso Ate                                ³
//³ MV_PAR11        //  Grupo De                                 ³
//³ MV_PAR12        //  Grupo Ate                                ³
//³ MV_PAR13        //  Departamento De                          ³
//³ MV_PAR14        //  Departamento Ate                         ³
//³ MV_PAR15        //  Cargo De                                 ³
//³ MV_PAR16        //  Cargo Ate                                ³
//³ MV_PAR17        //  Ano (AAAA)                               ³
//³ MV_PAR18        //  Treinamento em 1-Valor      2-Horas      ³
//³ MV_PAR19        //  Status Funcionario                       ³
//³ MV_PAR20        //  Ferias Programadas                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WnRel :="TRM040"	//-- Nome Default do relatorio em Disco.
WnRel :=SetPrint(cString,WnRel,cPerg,cTit,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,nTamanho)

If nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

RptStatus({|lEnd| Relato()},cTit)

Return

Static Function Relato()

nOrdem  	:= aReturn[8]
cArqDBF  	:= CriaTrab(NIL,.f.)
aFields 	:= {}
lImp		:= .F.
cTit   		:= STR0009 + Str(MV_PAR17,4) + STR0010 + IIf(MV_PAR18=1,STR0011,STR0012) //"Investimento em Treinamento no Ano de "###" em: "###" Valor"###" Horas"
Titulo 		:= cTit
cAcessaRA4	:= &("{ || " + ChkRH("TRM040","RA4","2") + "}")
cSituacao 	:= MV_PAR19
nFerProg  	:= MV_PAR20
cSitFol   	:= ""

AADD(aFields,{"TR_CC",     "C", TamSx3("RA_CC")[1],      TamSx3("RA_CC")[2]      } )
AADD(aFields,{"TR_CURSO",  "C", TamSx3("RA4_CURSO")[1],  TamSx3("RA4_CURSO")[2]  } )  
AADD(aFields,{"TR_DESCUR", "C", TamSx3("RA1_DESC")[1],   TamSx3("RA1_DESC")[2]   } )
AADD(aFields,{"TR_CUSTO",  "N", TamSx3("RA4_VALOR")[1],  TamSx3("RA4_VALOR")[2]  } )  
AADD(aFields,{"TR_HORAS",  "N", TamSx3("RA4_HORAS")[1],  TamSx3("RA4_HORAS")[2]  } )  
AADD(aFields,{"TR_DATA",   "D", TamSx3("RA4_DATAIN")[1], TamSx3("RA4_DATAIN")[2] } )  

dbCreate(cArqDbf, aFields)
dbUseArea(.T., NIL, cArqDbf, "TRA", .F.)

If nOrdem == 1 		// Curso     
	cIndCond := "TR_CURSO"
Else                 // Centro de Custo + Curso    
	cIndCond := "TR_CC + TR_CURSO"
EndIf

cArqNtx  := CriaTrab(NIL,.f.)
IndRegua("TRA",cArqNtx,cIndCond,,,STR0013) //"Selecionando Registros..."
dbGoTop()

dbSelectArea("RA4")
dbSetOrder(1) 
RA4->( DbGoTop() )
dbSeek(MV_PAR01+MV_PAR03+MV_PAR09,.T.)
cInicio	:= "RA4->RA4_FILIAL + RA4->RA4_MAT + RA4->RA4_CURSO" 
cFim	:= MV_PAR02 + MV_PAR04 + MV_PAR10

SetRegua(RecCount())

While !Eof() .And. &cInicio <= cFim

	If !Eval(cAcessaRA4)
		dbSkip()
		Loop
	EndIf

	If RA4->RA4_CURSO  < MV_PAR09 .Or. RA4->RA4_CURSO  > MV_PAR10 .Or.;
		Year(RA4->RA4_DATAIN) # MV_PAR17
		dbSkip()
		Loop
	EndIf
	
	dbSelectArea("RA2")
	dbSeek(xFilial("RA2")+RA4->RA4_CALEND+RA4->RA4_CURSO+RA4->RA4_TURMA)
	
	dbSelectArea("SRA")
	dbSetOrder(1)
	
	If dbSeek(RA4->RA4_FILIAL+RA4->RA4_MAT)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Situacao do Funcionario  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cSitFol := TrmSitFol()
		cCargo 	:= fGetCargo(SRA->RA_MAT)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Alimenta array com os registros que não ha cargo ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
		If Empty(cCargo)
			aAdd( aLogCargo,SRA->RA_FILIAL + Space(05) + SRA->RA_MAT + Space(04) + SRA->RA_NOME + Space(01) + RA4->RA4_CALEND + Space(07) + RA4->RA4_CURSO) 
		EndIf
		
		If 	(SRA->RA_MAT  	< MV_PAR03) .Or.	(SRA->RA_MAT 	> MV_PAR04)	.Or.;
			(SRA->RA_CC   	< MV_PAR05) .Or.	(SRA->RA_CC  	> MV_PAR06)	.Or.;
			(SRA->RA_NOME 	< MV_PAR07) .Or.	(SRA->RA_NOME 	> MV_PAR08)	.Or.;
			(cCargo 		< MV_PAR15)	.Or.	(cCargo		 	> MV_PAR16)	.Or.;
			(!(cSitfol $ cSituacao) 	.And.	(cSitFol <> "P"))   		.Or.;
			(cSitfol == "P" .And. nFerProg == 2)
			
			dbSelectArea("RA4")
			dbSkip()
			Loop
		EndIf
		
		dbSelectArea( "SQ3" )
		dbSetOrder(1)
		cFil := xFilial("SQ3", RA4->RA4_FILIAL)
		If dbSeek( cFil + cCargo + SRA->RA_CC ) .Or. dbSeek( cFil + cCargo )
			If 	SQ3->Q3_GRUPO < MV_PAR11 .Or. SQ3->Q3_GRUPO > MV_PAR12 .Or.;
				SQ3->Q3_DEPTO < MV_PAR13 .Or. SQ3->Q3_DEPTO > MV_PAR14
				dbSelectArea("RA4")
				dbSkip()
				Loop
			EndIf
		Else 
			dbSelectArea("RA4")
			dbSkip()
			Loop	
		EndIf
				
		dbSelectArea("RA1")
		dbSetOrder(1)
		cFil := xFilial("RA1", RA4->RA4_FILIAL)
		dbSeek(cFil+RA4->RA4_CURSO)

		RecLock("TRA",.T.)
			TRA->TR_CC		:= SRA->RA_CC
			TRA->TR_CURSO	:= RA4->RA4_CURSO
			TRA->TR_DESCUR	:= RA1->RA1_DESC
			TRA->TR_CUSTO	:= RA4->RA4_VALOR
			TRA->TR_HORAS	:= RA4->RA4_HORAS
			TRA->TR_DATA 	:= RA4->RA4_DATAIN
		MsUnlock()
		
	EndIf		
	
	dbSelectArea("RA4")
  	dbSkip()
EndDo

lRet := .T.

aHoras := Array(12)
aValor := Array(12)
aCHoras:= Array(12)
aCValor:= Array(12)
aTHoras:= Array(12)
aTValor:= Array(12)

aFill(aHoras,0)
aFill(aValor,0)
aFill(aCHoras,0)
aFill(aCValor,0)
aFill(aTHoras,0)
aFill(aTValor,0)

dbSelectArea("TRA")
dbGotop()

// Seta a impressao para comprimido
//@ 0,0 PSAY &(aDriver[5])

cCurso 	:= TRA->TR_CURSO
cNome	:= TRA->TR_DESCUR
cCC 	:= TRA->TR_CC

While !Eof()

	FImpCab()
	If lRet
		If nOrdem == 2
			FImpCC()
		EndIf
		lRet:= .F.
	EndIf	
	
	nMes := Month(TRA->TR_DATA)
		
	If cCurso # TRA->TR_CURSO
		FImpDet() 
		cCurso 	:= TRA->TR_CURSO
		cNome	:= TRA->TR_DESCUR
	EndIf
	
	If nOrdem == 2 .And. cCC # TRA->TR_CC
		FImpDet()
		FTotCC()
		cCC 	:= TRA->TR_CC
		cCurso:= TRA->TR_CURSO
		cNome	:= TRA->TR_DESCUR
		FImpCC()
	EndIf
		
	aHoras[nMes] := aHoras[nMes]  + TRA->TR_HORAS
	aValor[nMes] := aValor[nMes]  + TRA->TR_CUSTO
	aCHoras[nMes]:= aCHoras[nMes] + TRA->TR_HORAS
	aCValor[nMes]:= aCValor[nMes] + TRA->TR_CUSTO
	aTHoras[nMes]:= aTHoras[nMes] + TRA->TR_HORAS
	aTValor[nMes]:= aTValor[nMes] + TRA->TR_CUSTO
	
	dbSkip()
EndDo

If !lRet
	FImpDet()
	If nOrdem == 2		
		FTotCC()
	EndIf
	FTotGeral()
EndIf	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Termino do Relatorio                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("TRA")
dbCloseArea()
fErase(cArqNtx + OrdBagExt())
fErase(cArqDbf + GetDBExtension())

dbSelectArea("SRA")
dbSetOrder(1)

dbSelectArea("RA4")
dbSetOrder(1)

dbSelectArea("SQ3") 
dbSetOrder(1)

dbSelectArea("RA1")
dbSetOrder(1)

Set Device To Screen

If lImp
	Impr("","F")
EndIf	

If aReturn[5] == 1
   Set Printer To
   Commit
   ourspool(wnrel)
Endif

MS_FLUSH()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera Arquivo Log com as Inconsistencias no vinculo Funcao x Cargo  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( lExcLogCargo := !Empty(aLogCargo) ) 

	wCabec1 := ""
	wCabec2 := ""

	cMainTitle 	:= STR0038			//"Inconsistências na função ou cargo"
	cTitle1		:= Upper(STR0039)	//"Filial Matricula Funcionario                    Calendario Curso"   
   
  	aAdd(aLogTitle,cTitle1)

	If ( lExcLogCargo := MsgNoYes(STR0040, STR0001 + " - " + cMainTitle ) )	//"Foram encontradas inconsistências no vínculo Função x Cargo. Deseja gerar Log?"
		FMakeLog( { aLogCargo } , aLogTitle , , NIL , NIL , STR0001 + Space(01)+ "("+ cMainTitle+")","M","P",,.F. )			
	EndIf	                            
	
EndIf


Return Nil

// Imprime Cabecalho do relatorio
Static Function FImpCab()
wCabec0	:= 2
wCabec1	:= STR0017	//"                                           JAN         FEV         MAR         ABR         MAI         JUN         JUL         AGO         SET         OUT         NOV         DEZ "

If MV_PAR18 == 1		// Valor
	wCabec2  := STR0018	//"CURSO                                     VALOR       VALOR       VALOR       VALOR       VALOR       VALOR       VALOR       VALOR       VALOR       VALOR       VALOR       VALOR           TOTAL"
Else	
	wCabec2  := STR0019	//"CURSO                                     HORAS       HORAS       HORAS       HORAS       HORAS       HORAS       HORAS       HORAS       HORAS       HORAS       HORAS       HORAS           TOTAL"
EndIf	
Return Nil

// Imprime as linhas de detalhe do relatorio
Static Function FImpDet()

Local nx := 0

If LI > 60
	FImpCab()
EndIf

nTotal:= 0
DET 	:= ""
DET 	:= cCurso + SPACE(01) + cNome
DET 	:= DET + IIF(MV_PAR18==1,Space(01),Space(05))
For nx:= 1 To 12
	If MV_PAR18 == 1
		cAux 	:= Transform(aValor[nx],"@R 9999,999.99")
		nTotal	:= nTotal + aValor[nx]
	Else
		cAux 	:= Transform(aHoras[nx],"@R 999,999")
		nTotal	:= nTotal + aHoras[nx]
	EndIf	
	DET 	:= DET + cAux
	DET 	:= DET + IIF(MV_PAR18==1,Space(01),Space(05))
	cAux 	:= ""
Next nx 

DET := DET + IIF(MV_PAR18==1,Transform(nTotal,"@R 99999999,999.99"),Transform(nTotal,"999,999,999"))
IMPR(DET,"C")

aFill(aHoras,0)
aFill(aValor,0)
lImp := .T.
Return Nil

// Imprime o cabecalho da quebra por Centro de Custo
Static Function FImpCC()

If LI > 60
	FImpCab()
EndIf	

DET:=""
DET:= STR0014 + cCC + " - " + DescCC(cCC) //"CENTRO DE CUSTO: "
IMPR(DET,"C")

Return Nil

// Imprime os totais por Centro de custo
Static Function FTotCC()

Local nx := 0

If LI > 60
	FImpCab()
	FimpCC()
EndIf	

IMPR(Repl("-",COLUNAS),"C")

nTotal:=0
DET := ""
DET := STR0015 + IIF(MV_PAR18==1,Space(12),Space(16)) //"TOTAL DO CENTRO DE CUSTO"

For nx:=1 To 12
	If MV_PAR18 == 1
		cAux 	:= Transform(aCValor[nx],"@R 9999,999.99")
		nTotal:= nTotal + aCValor[nx]
	Else
		cAux 	:= Transform(aCHoras[nx],"999,999")
		nTotal:= nTotal + aCHoras[nx]
	EndIf	
	DET := DET + cAux
	DET := DET + IIF(MV_PAR18==1,Space(01),Space(05))
	cAux := ""
Next nx

DET := DET + IIF(MV_PAR18==1,Transform(nTotal,"@R 99999999,999.99"),Transform(nTotal,"999,999,999"))
IMPR(DET,"C")
IMPR("","C")

aFill(aCHoras,0)
aFill(aCValor,0)

Return Nil

// Imprime total geral dos meses
Static Function FTotGeral()

Local nx := 0

If LI > 60
	FImpCab()
EndIf	

nTotal:=0
DET := ""
DET := STR0016 + IIF(MV_PAR18==1,Space(12),Space(16)) //"TOTAL GERAL:            "

For nx:=1 To 12
	If MV_PAR18 == 1
		cAux 	:= Transform(aTValor[nx],"@R 9999,999.99")
		nTotal:= nTotal + aTValor[nx]
	Else
		cAux 	:= Transform(aTHoras[nx],"999,999")
		nTotal:= nTotal + aTHoras[nx]
	EndIf	
	DET := DET + cAux
	DET := DET + IIF(MV_PAR18==1,Space(01),Space(05))
	cAux := ""
Next nx

DET := DET + IIF(MV_PAR18==1,Transform(nTotal,"@R 99999999,999.99"),Transform(nTotal,"999,999,999"))
IMPR("","C")
IMPR(DET,"C")
IMPR("","C")

aFill(aTHoras,0)
aFill(aTValor,0)

Return Nil

#INCLUDE "Lj800rlt.ch"
#Include "RwMake.ch"



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LJ800RLT  ºAutor  ³Armando P. Waiteman º Data ³  03/27/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Modelo para a impressao de posicao financeira do Lay-Away   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function LJ800RLT(cNumLay)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³O programa LOJA800 passa como parametro o numero do Lay-Away³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local aArea 	:= GetArea()
Local aAreaSLO 	:= SLO->(GetArea())
Local aAreaSLP 	:= SLP->(GetArea())


// Cria o objeto de impressao
oPrn := TMSPrinter():New()

// Cria os objetos de fontes que serao utilizadas na impressao do relatorio
oFont09  := TFont():New( "Times New Roman",,09,,.f.,,,,.f.,.f. )
oFont09b := TFont():New( "Times New Roman",,09,,.t.,,,,.f.,.f. )
oFont09bi:= TFont():New( "Times New Roman",,09,,.t.,,,,.t.,.f. )
oFont10b := TFont():New( "Times New Roman",,10,,.t.,,,,.f.,.f. )
oFont10  := TFont():New( "Times New Roman",,10,,.f.,,,,.f.,.f. )
oFont14b := TFont():New( "Times New Roman",,14,,.t.,,,,.f.,.f. )


// Posiciona o Lay-Away
dbSelectArea("SLO")
dbSetOrder(1)
dbSeek(xFilial("SLO")+cNumLay,.T.)

CabRel()
CabLay()
DetLay()
TotLay()

oPrn:Print()
MS_FLUSH()



RestArea(aAreaSLO)
RestArea(aAreaSLP)
RestArea(aArea)

Return                                               


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CabRel    ºAutor  ³Armando P. Waiteman º Data ³  04/01/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Efetua a impressao do cabecalho do relatorio                º±±
±±º          ³(Nome da empresa, logotipo, Endereco...)                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CabRel()

Local cBitMap 	:= '\SIGAADV\LGRL99.BMP'
Local aArea		:= GetArea()

oPrn:Say(240,101, SM0->M0_NOMECOM, oFont14b, 100)
oPrn:Say(330,101, SM0->M0_ENDENT , ofont10 , 100)
oPrn:Say(330,750, SM0->M0_CIDENT , ofont10 , 100)
oPrn:Say(330,1150," -   " + SM0->M0_ESTENT , ofont10 , 100)
oPrn:Say(370,101, SM0->M0_BAIRENT, ofont10 , 100)
oPrn:Say(370,501, RetTitle("A1_CEP")+": "+SM0->M0_CEPENT , ofont10 , 100)
oPrn:Say(370,901, RetTitle("A1_TEL")+": "+SM0->M0_TEL    , ofont10 , 100)
oPrn:SayBitmap(100,1701,cBitMap,600,300 )
oPrn:Line(415,001,415,2900)


RestArea(aArea)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CABLAY    ºAutor  ³Armando P. Waiteman º Data ³  04/01/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Efetua a impressao do dados referentes ao cabecalho do      º±±
±±º          ³lay-away (informacoes comuns a todos os itens)              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CabLay()

Local cNomeCli  := ""
Local aArea		:= GetArea()

// Posiciona o cadastro de cliente
dbSelectArea("SA1")
dbSetOrder(1)
dbSeek(xFilial("SA1")+SLO->LO_CLIENTE+SLO->LO_LOJA)
cNomeCli := SA1->A1_NOME
oPrn:Say(500,101, STR0001+SLO->LO_CLIENTE,ofont10,100) //"Cliente : "
oPrn:Say(500,351, STR0002+SLO->LO_LOJA,ofont10,100) //"Loja : "
oPrn:Say(500,601, STR0003,ofont10,100) //"Nome : "
oPrn:Say(490,725, cNomeCli,oFont14b,100)
oPrn:Say(600,101, STR0004+SLO->LO_NUMLAY,ofont10,100) //"Lay-Away : "
oPrn:Say(600,701, STR0005+Transform(DTOS(SLO->LO_EMISSAO),"XX/XX/XX"),ofont10,100) //"Emissao : "
oPrn:Say(600,1401,STR0006+Transform(DTOS(SLO->LO_DTENT),"XX/XX/XX"),ofont10,100) //"Vencimento : "
oPrn:Say(600,2000,STR0007+Transform(SLO->LO_MOEDA,"@!"), ofont10, 100) //"Moeda : "
oPrn:Line(645,001,645,2900)


RestArea(aArea)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DETLAY    ºAutor  ³Armando P. Waiteman º Data ³  04/01/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Imprime os itens do lay-away                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


Static Function DetLay()
Local aArea 	:= GetArea()
Local cNumLay	:= ""
Local cFilSLO	:= ""
Local aDados	:= {}
Local aCab		:= {}
Local nX		:= 0

cNumLay := SLO->LO_NUMLAY
cFilSLO	:= xFilial("SLO")

// Monta array com cabecalho
aCab := {RetTitle("LO_ITEM"),;
          RetTitle("LO_PRODUTO"),;
          RetTitle("B1_DESC"),;
          STR0008,; //"U.M."
          RetTitle("LO_QUANT"),;
          RetTitle("LO_VUNIT"),;
          RetTitle("LO_TOTAL"),;
          RetTitle("LO_QUJE"),;
          RetTitle("LO_OBS")}
            
// Monta Array com todas as informacoes
While !EOF() .and. SLO->LO_FILIAL+SLO->LO_NUMLAY == cFilSLO+cNumLay
	aAdd(aDados,{Transform(LO_ITEM,PesqPict("SLO","LO_ITEM")),;
				 LO_PRODUTO,;
				 a800DescB1(LO_PRODUTO),;
				 LO_UM,;
				 Transform(LO_QUANT,PesqPict("SLO","LO_QUANT")),;
				 Transform(LO_VUNIT,PesqPict("SLO","LO_VUNIT")),;
				 TransForm(LO_TOTAL,PesqPict("SLO","LO_TOTAL")),;
				 Transform(LO_QUJE,PesqPict("SLO","LO_QUJE")),;
				 LO_OBS})
	dbSkip()
EndDo

// Inicia a Impressao 

// Cabecalho
oPrn:Say(730,116, aCab[1], oFont09b, 100)
oPrn:Say(730,216, aCab[2], oFont09b, 100)
oPrn:Say(730,465, aCab[3], oFont09b, 100)
oPrn:Say(730,1065,aCab[4], oFont09b, 100)
oPrn:Say(730,1165,aCab[5], oFont09b, 100)
oPrn:Say(730,1385,aCab[6], oFont09b, 100)
oPrn:Say(730,1635,aCab[7], oFont09b, 100)
oPrn:Say(730,1915,aCab[8], oFont09b, 100)

nLin := 790

// Itens
For nX:= 1 to Len(aDados)
	oPrn:Say(nLin,116, aDados[nX][1], oFont09, 100)
	oPrn:Say(nLin,216, aDados[nX][2], oFont09, 100)
	oPrn:Say(nLin,465, aDados[nX][3], oFont09, 100)
	oPrn:Say(nLin,1065, aDados[nX][4], oFont09, 100)
	oPrn:Say(nLin,1165, aDados[nX][5], oFont09, 100)
	oPrn:Say(nLin,1385, aDados[nX][6], oFont09, 100)
	oPrn:Say(nLin,1635, aDados[nX][7], oFont09, 100)
	oPrn:Say(nLin,1915, aDados[nX][8], oFont09, 100)
	If !Empty(aDados[nX][9])
		nLin:=nLin+60
		oPrn:Say(nLin,465, Alltrim(RetTitle("LO_OBS"))+": "+aDados[nX][9], oFont09bi, 100)
	EndIf
	nLin := nLin+60
	If nLin >= 2290 .and. nX < Len(aDados)

        // Imprime Rodape do relatorio
        RestArea(aArea) // Antes de imprimir reposiciona o SLO
        TotLay()

        // Inicia nova pagina
		oPrn:EndPage()

		// Imprime o cabecalho do relatorio
		CabRel()

		// Imprime o cabecalho do lay-away
		CabLay()

		// Imprime novamente o cabecalho das colunas
		oPrn:Say(730,116, aCab[1], oFont09b, 100)
		oPrn:Say(730,216, aCab[2], oFont09b, 100)
		oPrn:Say(730,465, aCab[3], oFont09b, 100)
		oPrn:Say(730,1065,aCab[4], oFont09b, 100)
		oPrn:Say(730,1165,aCab[5], oFont09b, 100)
		oPrn:Say(730,1385,aCab[6], oFont09b, 100)
		oPrn:Say(730,1635,aCab[7], oFont09b, 100)
		oPrn:Say(730,1915,aCab[8], oFont09b, 100)

		// Posiciona a linha e continua a impressao dos itens
		nLin := 790
	EndIf
Next

RestArea(aArea)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TOTLAY    ºAutor  ³Armando P. Waiteman º Data ³  04/01/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Totaliza e imprime o resumo da situacao atual do lay-away   º±±
±±º          ³(Valor total, Valor Pago, Saldo Devedor...)                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function TotLay()

Local aArea := GetArea()
Local aAreaSLP  := SLP->(GetArea())
Local aTesImpInf:= {}
Local cChaveSLP := xFilial("SLP")+SLO->LO_NUMLAY+"2"
Local cChaveSLO := xFilial("SLO")+SLO->LO_NUMLAY
Local cValIni	:= ""
Local cTotal	:= ""
Local cValPar	:= ""
Local cValPag	:= ""
Local cSaldo	:= ""
Local cCampo    := ""
Local nValIni	:= 0
Local nTotalLay := 0
Local nX
Local nRecnoSLO  := SLO->(Recno())

// Posiciona o SLP para extracao de dados
dbSelectArea("SLP")
dbSetOrder(1)
dbSeek(cChaveSLP)

//Totaliza os valor inicial pago
While !EOF() .and. cChaveSLP == LP_FILIAL+LP_NUMLAY+LP_TPAMAR
	If LP_PARCELA == "0"
		SE1->(DbSeek(xFilial("SE1")+SLP->LP_PREFIXO+SLP->LP_NUME1+SLP->LP_PARCELA+SLP->LP_TIPOE1))
		nValIni := nValIni+SE1->E1_VALOR
	EndIf
	dbSkip()
EndDo

dbSelectArea("SLO")
dbSetOrder(1)
dbSeek(cChaveSLO)
While !EOF() .and. cChaveSLO == SLO->LO_FILIAL+SLO->LO_NUMLAY
   nTotalLay += SLO->LO_TOTAL
   aTesImpInf  := TesImpInf(SLO->LO_TES)
   For nX := 1 to Len(aTesImpInf)
      If aTesImpInf[nX][3] == "1"  //Soma no Lay-Away
         cCampo := "SLO->LO_VALIMP"+Substr(aTesImpInf[nX][2],10)
         nTotalLay += &(cCampo) 
      EndIf      
   Next nX
   dbSkip()
EndDo	
DbGoto(nRecnoSLO)

// Reune as informacoes a serem impressas
cTotal := Transform(nTotalLay,PesqPict("SLO","LO_TOTAL"))
cValIni:= Transform(nValIni, PesqPict("SLO","LO_TOTAL"))
cValPar:= Transform((LO_VALPAG-nValIni),PesqPict("SLO","LO_TOTAL"))
cValPag:= Transform(LO_VALPAG,PesqPict("SLO","LO_TOTAL"))
cSaldo := Transform((nTotalLay-LO_VALPAG),PesqPict("SLO","LO_TOTAL"))


// Faz a impressao
nTam1:=4000
nTam2:=2400
oPrn:Box(2320,101 ,3000,1065)
oPrn:Box(2320,1065,3000,2299)
oPrn:Say(2500,180,STR0009, oFont10,100) //"Pagto Inicial :"
oPrn:Say(2500,380,cValIni, oFont10b, 100)
oPrn:Say(2580,180,STR0010, oFont10,100) //"Pagto em parcelas :"
oPrn:Say(2580,380,cValPar, oFont10b, 100)
oPrn:Say(2660,180,STR0011, oFont10,100) //"Total Pago :"
oPrn:Say(2660,380,cValPag, oFont10b, 100)
oPrn:Say(2740,180,STR0012, oFont10,100) //"Valor Total :"
oPrn:Say(2740,380,cTotal , oFont10b, 100)
oPrn:Say(2820,180,STR0013, oFont10,100) //"Saldo : "
oPrn:Say(2820,380,cSaldo , oFont10b, 100)
oPrn:Line(2580,1200,2580,2164)
oPrn:Say(2600,1200,STR0014, oFont10, 100) //"Consumidor"
oPrn:Line(2740,1200,2740,2164)
oPrn:Say(2760,1200, SM0->M0_NOMECOM, oFont10, 100)

RestArea(aArea)

Return

#INCLUDE "TOTVS.CH"
#INCLUDE "FONT.CH"

User Function RelVenda()

Local oDlg       := NIL
Local cString	  := "SC7"

Private titulo   := ""
Private nLastKey := 0
Private cPerg	  := "FATR05"
Private nomeProg := FunName()
Private nTotal	  := 0
Private nSubTot  := 0

AjustaSx1()
If ! Pergunte(cPerg,.T.)
	Return
Endif

wnrel := FunName()            //Nome Default do relatorio em Disco

Private cTitulo  := "Impressão do Pedido de Vendas"
Private oPrn     := NIL
Private oFont1   := NIL
Private oFont2   := NIL
Private oFont3   := NIL
Private oFont4   := NIL
Private oFont5   := NIL
Private oFont6   := NIL
Private nLastKey := 0
Private nLin     := 1650 // Linha de inicio da impressao das clausulas contratuais

DEFINE FONT oFont1 NAME "Times New Roman" SIZE 0,20 BOLD   Of oPrn
DEFINE FONT oFont2 NAME "Times New Roman" SIZE 0,14 BOLD   Of oPrn
DEFINE FONT oFont3 NAME "Times New Roman" SIZE 0,14        Of oPrn
DEFINE FONT oFont4 NAME "Times New Roman" SIZE 0,14 ITALIC Of oPrn
DEFINE FONT oFont5 NAME "Times New Roman" SIZE 0,14        Of oPrn
DEFINE FONT oFont6 NAME "Courier New" BOLD

oFont08	 := TFont():New("Arial",08,08,,.F.,,,,.T.,.F.)
oFont08N  := TFont():New("Arial",08,08,,.T.,,,,.T.,.F.)
oFont10	 := TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)
oFont11   := TFont():New("Arial",11,11,,.F.,,,,.T.,.F.)
oFont14	 := TFont():New("Arial",14,14,,.F.,,,,.T.,.F.)
oFont16	 := TFont():New("Arial",16,16,,.F.,,,,.T.,.F.)
oFont10N  := TFont():New("Arial",10,10,,.T.,,,,.T.,.F.)
oFont12   := TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)
oFont12N  := TFont():New("Arial",10,10,,.T.,,,,.T.,.F.)
oFont16N  := TFont():New("Arial",16,16,,.T.,,,,.T.,.F.)
oFont14N  := TFont():New("Arial",14,14,,.T.,,,,.T.,.F.)
oFont06	 := TFont():New("Arial",06,06,,.F.,,,,.T.,.F.)
oFont06N  := TFont():New("Arial",06,06,,.T.,,,,.T.,.F.)

nLastKey  := IIf(LastKey() == 27,27,nLastKey)

If nLastKey == 27

	Return( NIL )
	
Endif


oPrn := TMSPrinter():New( cTitulo )
oPrn:Setup()
oPrn:SetLandsCape()                //SetPortrait() //SetLansCape()
oPrn:StartPage()

Imprimir()

oPrn:EndPage()
oPrn:End()

DEFINE MSDIALOG oDlg FROM 264,182 TO 441,613 TITLE cTitulo OF oDlg PIXEL

@ 004,010 TO 082,157 LABEL "" OF oDlg PIXEL

@ 015,017 SAY "Esta rotina tem por objetivo imprimir"	OF oDlg PIXEL Size 150,010 FONT oFont6 COLOR CLR_HBLUE
@ 030,017 SAY "o impresso customizado:"					OF oDlg PIXEL Size 150,010 FONT oFont6 COLOR CLR_HBLUE
@ 045,017 SAY "Pedido de Venda" 						OF oDlg PIXEL Size 150,010 FONT oFont6 COLOR CLR_HBLUE

@ 06,167 BUTTON "&Imprime" 		SIZE 036,012 ACTION oPrn:Print()   	OF oDlg PIXEL
@ 28,167 BUTTON "Pre&view" 		SIZE 036,012 ACTION oPrn:Preview() 	OF oDlg PIXEL
@ 49,167 BUTTON "Sai&r"    		SIZE 036,012 ACTION oDlg:End()     	OF oDlg PIXEL

ACTIVATE MSDIALOG oDlg CENTERED

oPrn:End()

Return( NIL )

//--------------------------------------------------------------------------------------------

Static Function Imprimir()

Orcamento()
Ms_Flush()

Return( NIL )

//--------------------------------------------------------------------------------------------

Static Function Orcamento()

cDia := SubStr(DtoS(dDataBase),7,2)
cMes := SubStr(DtoS(dDataBase),5,2)
cAno := SubStr(DtoS(dDataBase),1,4)
cMesExt := MesExtenso(Month(dDataBase))
cDataImpressao := cDia+" de "+cMesExt+" de "+cAno

cPercICMS := GetMv("MV_ESTICM")

oPrn:StartPage()
//cBitMap := "P:\Logo1.Bmp"
//oPrn:SayBitmap(1200,1200,cBitMap,2400,1700)			// Imprime logo da Empresa: comprimento X altura

oPrn:Say(0030,0100,SM0->M0_NOMECOM,oFont14N)

oPrn:Box(0180,0050,0630,2300)

SC5->( dbSetOrder(1) )
SC5->( dbSeek( xFilial("SC5")+MV_PAR01 ) )

While ! SC5->( Eof() ) .AND. SC5->C5_NUM == MV_PAR01
	
	SA1->( dbSetOrder(1) )
	SA1->( dbSeek( xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI ) )
	
	SA4->( dbSetOrder(1) )
	SA4->( dbSeek( xFilial("SA4")+SC5->C5_TRANSP ) )
	
	SA3->( dbSetOrder(1) )
	SA3->( dbSeek( xFilial("SA3")+SC5->C5_VEND1 ) )
	
	DA0->( dbSetOrder(1) )
	DA0->( dbSeek( xFilial("DA0")+SC5->C5_TABELA ) )
	
	SF4->( dbSetOrder(1) )
	SF4->( dbSeek(xFilial("SF4")+SC6->C6_TES ) )
	
	SE4->( dbSetOrder(1) )
	SE4->( dbSeek( xFilial("SE4")+SC5->C5_CONDPAG ) )
	
	SC6->( dbSetOrder(1) )
	SC6->( dbSeek(xFilial("SC6")+SC5->C5_NUM) )

	SC9->( dbSetOrder(1) )
	SC9->( dbSeek(xFilial("SC9")+SC9->C9_PEDIDO) )
	
	cEstICM := SA1->A1_EST
	nPosICM := AT(cPercICMS,cEstICM)
	nPercICMS := VAL(SubStr(cPercICMS,(nPosICM+2),2))
	
	oPrn:Box(0030,1770,0130,2350)
	oPrn:Say(0030,1370, "Pedido No",oFont14N)
	oPrn:Say(0040,1890,OemToAnsi(SC5->C5_NUM),oFont14)
	
	dataHora:=Time()
	
	oPrn:Say(0030,2800,dataHora,oFont14N)
	
	oPrn:Box(0180,2350,0630,3350)
	
	oPrn:Say(0200,0100,"Cliente:",oFont12N)
	oPrn:Say(0200,0280,OemToAnsi(SA1->A1_COD),oFont12)
	oPrn:Say(0200,0480,OemToAnsi(SA1->A1_NOME),oFont12)
	
	oPrn:Say(0250,0100,"Endereco:",oFont12N)
	oPrn:Say(0250,0280,OemToAnsi(SA1->A1_END),oFont12)
	//oPrn:Say(0250,1050,"Bairro:",oFont12N)
	oPrn:Say(0250,1200,OemToAnsi(SA1->A1_BAIRRO),oFont12)
	oPrn:Say(0250,1600,OemToAnsi(SA1->A1_MUN),oFont12)
	cEstado:=SA1->A1_EST
	oPrn:Say(0250,2000,OemToAnsi(SA1->A1_EST),oFont12)
	
	oPrn:Say(0480,2500,"Data",oFont14N)
	dData:=Dtoc(SC5->C5_EMISSAO)
	oPrn:Say(0540,2500,OemToAnsi(Ddata),oFont14)
	
	oPrn:Say(0300,0100,"CNPJ:",oFont12N)
	oPrn:Say(0300,0280,Transform(Alltrim(SA1->A1_CGC),"@R 99.999.999/9999-99"),oFont12)
	
	oPrn:Say(0300,0800,"Inscricao Estadual:",oFont12N)
	oPrn:Say(0300,1150,Transform(Alltrim(SA1->A1_INSCR),"@R 999.999.999.999"),oFont12)
	
	oPrn:Say(0350,0100,"CEP:   ",oFont12N)
	oPrn:Say(0350,0280,OemToAnsi(SA1->A1_CEP),oFont12)
	
	oPrn:Say(0350,0940,"Telefone:"	,oFont12N)
	oPrn:Say(0350,1150,OemToAnsi(SA1->A1_DDD),oFont12)
	oPrn:Say(0350,1250,OemToAnsi(SA1->A1_TEL),oFont12)
	
	oPrn:Say(0400,0100,"Transp:",oFont12N)
	oPrn:Say(0400,0280,OemToAnsi(SA4->A4_COD),oFont12)
	oPrn:Say(0400,0460,OemToAnsi(SA4->A4_NOME),oFont12)
	oPrn:Say(0400,1100,OemToAnsi(SA4->A4_BAIRRO),oFont12)
	oPrn:Say(0400,1490,OemToAnsi(SA4->A4_TEL),oFont12)

	ncred:=0
	
	oPrn:Say(0280,2950,"CREDITO",oFont12N)
	ncred   := Posicione("SC9",1,xFilial("SC9")+SC6->C6_NUM,"C9_BLCRED")
	
	if !Empty(ncred)
		oPrn:Say(0340,2950,"BLOQUEADO",oFont14N)
	else
		oPrn:Say(0340,2950,"LIBERADO",oFont14N)
	Endif
	
	oPrn:Say(0480,2950,"ESTOQUE",oFont12N)
	nest   := Posicione("SC9",1,xFilial("SC9")+SC6->C6_NUM,"C9_BLEST")

	if !Empty(nest)
		oPrn:Say(0520,2950,"BLOQUEADO",oFont14N)
	Else
		oPrn:Say(0520,2950,"LIBERADO",oFont14N)
	EndIf
	
	oPrn:Say(0450,0100,"Vendedor:"	,oFont12N)
	oPrn:Say(0450,0280,OemToAnsi(SA3->A3_COD),oFont12)
	oPrn:Say(0450,0480,OemToAnsi(SA3->A3_NREDUZ),oFont12)
	
	oPrn:Say(0450,1000,"Tabela:" ,oFont12N)
	oPrn:Say(0450,0280,OemToAnsi(DA0->DA0_CODTAB),oFont12)
	oPrn:Say(0450,0460,OemToAnsi(DA0->DA0_DESCRI),oFont12)
	finalidade:=0
	oPrn:Say(0500,0100,"Natureza:"	,oFont12N)
	finalidade := Posicione("SF4",1,xFilial("SF4")+SC6->C6_TES,"F4_FINALID")
	oPrn:Say(0500,0460,finalidade,oFont12)
	
	oPrn:Say(0550,0100,"Frete:" ,oFont12N)
	oPrn:Say(0550,0300,OemToAnsi(SC5->C5_TPFRETE),oFont12)
	
	oPrn:Box(0650,0050,0750,3350) //Cabeçalho dos itens do produto
	
	oPrn:Say(0680,0100,"Codigo"  	        , oFont12N )
	oPrn:Say(0680,0330,"Descricao"	     , oFont12N )
	oPrn:Say(0680,1500,"Fabricante"	     , oFont12N )
	oPrn:Say(0680,1900,"Quantidade"  	  , oFont12N )
	oPrn:Say(0680,2180,"Pr.Unitario"      , oFont12N )
	oPrn:Say(0680,2380,"Pr. Total" 	     , oFont12N )
	oPrn:Say(0680,2570,"%Ipi"   	        , oFont12N )
	oPrn:Say(0680,2780,"Vlr Ipi"   	     , oFont12N )
	oPrn:Say(0680,2950,"Peso"    	        , oFont12N )
	oPrn:Say(0680,3080,"Classificacao"    , oFont12N )
	
	SC6->( dbSetOrder(1) )
	SC6->( dbSeek(xFilial("SC6")+SC5->C5_NUM) )
	
	nLin    := 0780
	
	nSubTot := nTotIPI := 	nVlrIPI := 	nICMS := nTotICMS := nTotalGeral := nPesoItem := nTotalItem := nTotalNota := 0
	
	While ! SC6->(Eof() ) .And. SC6->C6_NUM == SC5->C5_NUM
	
		nIPI        := Posicione("SF4",1,xFilial("SF4")+SC6->C6_TES,"F4_IPI")
		nICMS       := Posicione("SF4",1,xFilial("SF4")+SC6->C6_TES,"F4_ICM")
		nPesoItem   := Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_PESO")
		nPercIPI    := Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_IPI")
		cClassific  := Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_POSIPI")
		nPercICMS   := IIF(Empty(nPercICMS),Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_PICM"),nPercICMS)
		nVlrIPI     := IIF(nIPI=="S",(SC6->C6_VALOR*nPercIPI)/100,0)
	//	nICMS       := Iif(nICMS=="S",(SC6->C6_VALOR*nPercICMS)/100,0)
		nTotalItem  := (SC6->C6_QTDVEN * nPesoItem)
		nSubTot     := nSubTot + SC6->C6_VALOR
		nTotIPI     := nTotIPI + nVlrIPI
	//	nTotICMS    := nTotICMS + nICMS
		nTotalNota  := nTotalNota + nTotalItem

		oPrn:Say(nLin,0050,OemToAnsi(SC6->C6_PRODUTO),		   oFont08)
		oPrn:Say(nLin,0330,OemToAnsi(SC6->C6_DESCRI),		   oFont08)

	  	oPrn:Say(nLin,1750,Transform(SC6->C6_UNSVEN,"@E 9999"         ), oFont08 )
		oPrn:Say(nLin,1930,Transform(SC6->C6_QTDVEN,"@E 9,999,999.99" ), oFont08 )
		oPrn:Say(nLin,2200,Transform(SC6->C6_PRCVEN,"@E 9,999,999.99" ), oFont08 )
		oPrn:Say(nLin,2370,Transform(SC6->C6_VALOR,"@E 9,999,999.99"  ), oFont08 )

		If nIPI=="S"
			oPrn:Say(nLin,2550,Transform(nPercIpi,"@E 9,999,999.99",),			oFont08)
			oPrn:Say(nLin,2750,Transform(nVlrIPI,"@E 9,999,999.99",),			oFont08)
		Else
			nPerIPI:=0
			nVlrIpi:=0
			oPrn:Say(nLin,2550,Transform(nPercIpi,"@E 9,999,999.99",),			oFont08)
			oPrn:Say(nLin,2750,Transform(nVlrIPI,"@E 9,999,999.99",),			oFont08)
		Endif

		oPrn:Say(nLin,2900,Transform(nTotalItem,"@E 9,999,999.99"),       oFont10N)
		oPrn:Say(nLin,3170,OemToAnsi(cClassific),                         oFont10)

		nLin+=0050

		SC6->(dbSkip())

	EndDo
	
	oPrn:Say(1400,0680,OemToAnsi(SC5->C5_MENNOTA),oFont12)
	
	oPrn:Box(1600,0050,2300,1500)
	oPrn:Box(1600,1520,2300,3350)
		
	oPrn:Say(1650,0660,"Titulos Previsao"        ,oFont14N)
	oPrn:Say(1700,0150,"Prazo de Pagamento:"     ,oFont12N)
	oPrn:Say(1800,0150,OemToAnsi(SE4-> E4_DESCRI),oFont14)

	cprazo1:=substr(SE4->E4_COND,01,02)
	cPrazo2:=substr(SE4->E4_COND,04,02)
	cPrazo3:=substr(SE4->E4_COND,07,02)
	cPrazo4:=substr(SE4->E4_COND,10,02)
	cPrazo5:=substr(SE4->E4_COND,13,02)
	
	
	prazo1:=date() + VAL(cprazo1)
	prazo2:=date() + VAL(cprazo2)
	prazo3:=date() + VAL(cprazo3)
	prazo4:=date() + VAL(cprazo4)
	prazo5:=date() + VAL(cprazo5)
	
	oPrn:Say(2000,0100,"Titulos:  Vencimentos",oFont12N)
	
	if ! prazo1 == Date()
		oPrn:Say(2050,0140,"1",oFont12N)
		oPrn:Say(2050,0250,Transform(prazo1, "@E 99/99/9999",),  oFont12N)
	EndIf
	
	if ! prazo2 == Date()
		oPrn:Say(2100,0140,"2",oFont12N)
		oPrn:Say(2100,0250,Transform(prazo2, "@E 99/99/9999",),  oFont12N)
	EndIf
	
	if ! prazo3 == date()
		oPrn:Say(2150,0140,"3",oFont12N)
		oPrn:Say(2150,0250,Transform(prazo3, "@E 99/99/9999",),  oFont12N)
	EndIf
	
	if ! prazo4 == date()
		oPrn:Say(2200,0140,"4",oFont12N)
		oPrn:Say(2200,0250,Transform(prazo4, "@E 99/99/9999",),  oFont12N)
	Endif
	
	if ! prazo5 == date()
		oPrn:Say(2250,0140,"5",oFont12N)
		oPrn:Say(2250,0250,Transform(prazo5, "@E 99/99/9999",),  oFont12N)
	EndIf
	
	oPrn:Say(1700,1100,"CFOP:",oFont12N)
	oPrn:Say(1800,1100,OemToAnsi(SC6->C6_CF)                       , oFont14  )
	oPrn:Say(1630,1600,"Frete"                                  	, oFont12N )
	oPrn:Say(1630,3000,Transform(SC5->C5_FRETE,"@E 9,999,999.99",) , oFont12  )
	oPrn:Say(1700,1600,"Sub-Total"           	            	      , oFont12N )
	oPrn:Say(1700,3000,Transform(nSubTot,"@E 9,999,999.99",)       , oFont12  )
	oPrn:Say(1770,1600,"Total Geral"         	            	      , oFont12N )

	nTotalGeral := nSubTot + nTotIPI + SC5->C5_FRETE
	
	oPrn:Say(1770,3000,Transform(nTotalGeral,"@E 9,999,999.99",),oFont12  )
	oPrn:Say(1850,1600,"Base do ICMS"         	            	,oFont12N )
	
	nPercIcm:=0
	
	If cEstado $ ("SP,RS") .AND. nICMS == "S"
		oPrn:Say(1850,3100,OemToAnsi("18 %",),oFont12 )
		nPercIcm:=(nTotalGeral/100)*18
	EndIf
	
	If cEstado$("MG,RJ") .AND.  nICMS=="S"
		oPrn:Say(1850,3100,OemToAnsi("12 %",),oFont12 )
		nPercIcm:=(nTotalGeral/100)*12
	EndIf

	If cEstado $ ("AC,AL,AM,AP,BA,CE,DF,ES,GO,MA,MS,MT,PA,PB,PE,PI,PR,RN,RO,RR,SC,SE,TO") .AND. nICMS == "S"
		oPrn:Say(1850,3100,OemToAnsi("17 %",),oFont12 )
		nPercIcm:=(nTotalGeral/100)*17
	EndIf

	oPrn:Say(1920,1600,"ICMS"            	                	        ,oFont12N )
	oPrn:Say(1920,3000,Transform(nPercIcm,        "@E 9,999,999.99",),oFont12  )
	oPrn:Say(1990,1600,"IPI"                 	            	        ,oFont12N )
	oPrn:Say(1990,3000,Transform(nTotIPI,         "@E 9,999,999.99",),oFont12  )
	oPrn:Say(2060,1600,"Peso Liquido"         	                    ,oFont12N )
	oPrn:Say(2060,3000,Transform(nTotalNota,      "@E 9,999,999.99",),oFont12  )
	oPrn:Say(2130,1600,"Peso Bruto"         	            	        ,oFont12N )
	oPrn:Say(2130,3000,Transform(nTotalNota,      "@E 9,999,999.99",),oFont12  )
	oPrn:Say(2200,1600,"Volumes"             	            	        ,oFont12N )
	oPrn:Say(2200,3000,Transform(SC5->C5_VOLUME1, "@E 9,999,999.99",),oFont12  )

	SC5->( dbSkip() )
	
EndDo

oPrn:EndPage()

Return( NIL )

//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

Static Function AjustaSX1()

PutSx1(cPerg,"01","No Pedido Vendas               ?"," "," ","mv_ch1","C",6,0,0,	"G","","   ","","","mv_par01"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe numero do Pedido Vendas"},{"Informe o numero do Pedido de Vendas de"},{"Informe o Numero do Pedido de Vendas"})

Return( NIL )
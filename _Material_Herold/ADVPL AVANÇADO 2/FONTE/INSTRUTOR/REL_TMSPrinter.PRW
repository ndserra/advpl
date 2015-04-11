#INCLUDE "RWMAKE.CH"

User Function PedComPo()

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³PedComIR  ³ Autor ³Francisco Oliveira     ³ Data ³16.04.2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Emitir pedido de compras com informação de inspeção de      ³±±
±±º          ³recebimento    				                              º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Emitir pedido de compras                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Local nn
Local _cQueryPC := ""
Private aPerg :={}
Private cPerg := "PComPor"
Private OPrint
Private aDados
Private nTotal := 0
Private cObserv    := ""
Private nItem   := 0
Private cCCusto
Private cConta
Private cMapa

fAjustaSx1()

Pergunte(cPerg,.t.)

If Select("PEDCOMIR") <> 0
	PEDCOMIR->( DbCLoseArea() )
End

Processa({|lEnd|MontaRel(),"Imprimindo Pedido Compras","AGUARDE.."})

Return Nil


//********************************************************************************************


Static Function MontaRel()

Local nD, nP , nC, _cObs
Private _cObsItem := ""
Private nCont  := 0
Private nCont1 := 1
Private Cont   := 1
Private Cont1  := 15
Private oPrint,oFont8,oFont10,oFont16,oFont16n,oFont24
Private aDadosEmp	:=	{SM0->M0_NOMECOM,; //Nome da Empresa - 1
SM0->M0_ENDCOB ,; //Endereço - 2
AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB ,;//Complemento - 3
Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3),; //CEP - 4
SM0->M0_TEL,; //Telefones - 5
Subs(SM0->M0_CGC,1,2)+"."+Subs(SM0->M0_CGC,3,3)+"."+; // CNPJ - 6
Subs(SM0->M0_CGC,6,3)+"/"+Subs(SM0->M0_CGC,9,4)+"-"+;
Subs(SM0->M0_CGC,13,2),; //CGC
Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+; // INSCR. ESTADUAL - 7
Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3),;
Subs(SM0->M0_CIDENT,1,20)} //Cidade da 

//Parâmetros de TFont.New()
//1.Nome da Fonte (Windows)
//3.Tamanho em Pixels
//5.Bold (T/F)
oFont8  := TFont():New("Arial",9,8 ,.T.,.F.,5,.T.,5,.T.,.F.)
oFont10 := TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
oFont12 := TFont():New("Arial",9,12,.T.,.T.,5,.T.,5,.T.,.F.)
oFont14 := TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16 := TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16n:= TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
oFont24 := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)

//oBrush := TBrush():New("",4)
oPrint:= TMSPrinter():New("PedCom")
oPrint:SetPortrait() // ou SetLandscape()

oPrint:Setup() // para configurar impressora

DbSelectArea("SA2"); DbSetOrder(1)


cQuery := "SELECT C7_NUM, C7_FORNECE, C7_LOJA, C7_EMISSAO, C7_CONAPRO, C7_TOTAL, C7_ITEM, C7_PRODUTO, "
cQuery += "       C7_COND, C7_TPFRETE, C7_FRETE, C7_CC, C7_CONTA, C7_DESCRI, C7_QUANT, C7_PRECO, R_E_C_N_O_ NRECNO, "
cQuery += "       C7_DATPRF, C7_UM, C7_VALIPI, C7_USER, C7_APROV, C7_OBS, C7_DESC, C7_NUMSC "
cQuery += " FROM " + RetSQLName("SC7") + " SC7 "
cQuery += "WHERE C7_FILIAL = '" + XFILIAL("SC7") + "' AND "
cQuery += "C7_NUM     >= '" + MV_PAR01 + "' AND  "
cQuery += "C7_NUM     <= '" + MV_PAR02 + "' AND  "
cQuery += "C7_FORNECE >= '" + MV_PAR03 + "' AND  "
cQuery += "C7_FORNECE <= '" + MV_PAR04 + "' AND  "
cQuery += "C7_LOJA    >= '" + MV_PAR05 + "' AND  "
cQuery += "C7_LOJA    <= '" + MV_PAR06 + "' AND  "
cQuery += "C7_EMISSAO >= '" + DTOS(MV_PAR07) + "' AND  "
cQuery += "C7_EMISSAO <= '" + DTOS(MV_PAR08) + "' AND  "
cQuery += "C7_PRODUTO >= '" + MV_PAR03 + "' AND  "
cQuery += "C7_PRODUTO <= '" + MV_PAR04 + "' AND  "
cQuery += "C7_CONAPRO <> 'B' AND "
cQuery += "SC7.D_E_L_E_T_ <> '*'"
cQuery += "ORDER BY C7_NUM, C7_ITEM"
cQuery := ChangeQuery(cQuery)

dbUseArea( .T.,"TOPCONN", TCGENQRY(,,cQuery),"PEDCOMIR", .F., .T.)
TcSetField( "PEDCOMIR", "C7_EMISSAO" , "D", 8, 0 )
TcSetField( "PEDCOMIR", "C7_DATPRF"  , "D", 8, 0 )

DbSelectArea("PEDCOMIR")
DbGoTop()

_cObs := "1 - A mercadoria será aceita somente se, na sua Nota Fiscal constar o numero do nosso Pedido de Compra."
//_cObs := "1 - Somente aceitaremos a mercadoria se a na sua Nota Fiscal constar o numero do nosso Pedido de Compras."

Do While !PEDCOMIR->(Eof())
	SA2->(DbSeek( xFilial("SA2") + PEDCOMIR->C7_FORNECE + PEDCOMIR->C7_LOJA) )
	cCodCredor 		:= SA2->A2_COD
	cLojaCredor		:= SA2->A2_LOJA
	cNomeCredor 	:= Alltrim(SA2->A2_NOME)
	cCGC        	:= SA2->A2_CGC
	cEnd        	:= Alltrim(SA2->A2_END)
	cBairro			:= Alltrim(SA2->A2_BAIRRO)
	cTel        	:= Alltrim(SA2->A2_TEL)
	cMun        	:= Alltrim(SA2->A2_MUN)
	cEst        	:= SA2->A2_EST
	cTemCredor  	:= .T.
	cNaoBloqueado	:= .T.
	cTemCredor    	:= .F.
	cNumPed       	:= PEDCOMIR->C7_Num
	cCodFor       	:= PEDCOMIR->C7_Fornece
	cNumSC			:= PEDCOMIR->C7_NUMSC
	aDados        	:= {}
	cObserv       	:= PEDCOMIR->C7_OBS
	dDataEmi		:= PEDCOMIR->C7_EMISSAO
	dDataEnt		:= PEDCOMIR->C7_DATPRF
	_cCompr__		:= Posicione("SC1",1,xFilial("SC1") + PEDCOMIR->C7_NUMSC,"C1_SOLICIT")
	//	_cCompr__		:= Posicione("SY1",3,xFilial("SY1") + PEDCOMIR->C7_USER,"Y1_NOME")
	_cAprov__		:= Posicione("SAK",1,xFilial("SAK") + PEDCOMIR->C7_APROV,"AK_NOME")
	nTotalIPI 		:= 0
	nTotalDesc		:= 0
	nTotalProd		:= 0
	nTotalCom  		:= 0
	cCondPagto		:= Posicione("SE4",1,xFilial("SE4") + PEDCOMIR->C7_COND,"E4_DESCRI") 	//cCondPagto		:= PEDCOMIR->C7_COND + " - " + Posicione("SE4",1,xFilial("SE4") + PEDCOMIR->C7_COND,"E4_DESCRI")
	cTipoFrete		:= IF(PEDCOMIR->C7_TPFRETE = "F","FOB","CIF") + " - R$ " + Transform(PEDCOMIR->C7_FRETE,"@E 999,999.99")
	
	Do While !Eof() .And. PEDCOMIR->C7_NUM == cNumPed
		aAdd(aDados,{PEDCOMIR->C7_ITEM,;	// 1
		PEDCOMIR->C7_EMISSAO,;          	// 2
		Trim(PEDCOMIR->C7_DESCRI),;      	// 3
		PEDCOMIR->C7_QUANT,;             	// 4
		PEDCOMIR->C7_PRECO,;              	// 5
		PEDCOMIR->C7_TOTAL,;             	// 6
		PEDCOMIR->C7_PRODUTO,;          	// 7
		PEDCOMIR->C7_UM,;            		// 8
		PEDCOMIR->C7_VALIPI,;           	// 9
		PEDCOMIR->C7_DESC,;					// 10
		PEDCOMIR->C7_OBS})                	// 11
		DbSkip()
	EndDo
	
	nPos	:= 0
	lchk01	:= .T.
	nCont	:= 0
	//nCont := nCont + 1
	
	_cObsItem	:= ""
	
	For nC := 1 to Len(aDados)
		If !Empty(aDados[nc,11])
			If lchk01
				_cObsItem	:= Alltrim(aDados[nc,11]) + " - "
				lchk01 := .F.
			Else
				_cObsItem += Alltrim(aDados[nc,11]) + " - "
			Endif
		Endif
		
		If Cont > Cont1
			nCont1 := nCont1 + 1
			Cont := 1
		Endif
		Cont := Cont + 1
	Next
	
	lEmpCab := lEmpRoda := .t.
	// Controla Qtd de Numero de Linhas Por pedido de compras Maximo de 15 linhas nos itens de um pedido
	nLinMax	:= 12
	nLinAtu	:= 1
	lCrtPag	:= .T.
	
	For nP := 1 to len(aDados)
		
		If  nLinAtu > nLinMax
			nCont := nCont + 1
			//oPrint:Say  (0260,1900,Transform(StrZero(ncont,3),""),oFont10)
			//oPrint:Say  (0260,1970,"de",oFont10)
			//oPrint:Say  (0260,2020,Transform(StrZero(ncont1,3),""),oFont10)
			oPrint:EndPage() // Finaliza a página
			lEmpCab := .t.
			lCrtPag	:= .F.
			nLinAtu := 1
		Endif
		
		If lEmpCab
			EmpCab(_cObs)
			lEmpCab := .f.
			nPos := 0
			
			If lCrtPag
				nCont := nCont + 1
			Endif
			
			oPrint:Say  (0260,1900,Transform(StrZero(ncont,3),""),oFont10)
			oPrint:Say  (0260,1970,"de",oFont10)
			oPrint:Say  (0260,2020,Transform(StrZero(ncont1,3),""),oFont10)
			
		Endif
		
		_nTamStr	:= 38
		_lChkTam	:= .T.
		_nTamDesc	:= 38
		
		If nLinAtu <= nLinMax
			oPrint:Say  (0940+nPos,0110,aDados[nP,1],oFont8) //Item produto
			oPrint:Say  (0940+nPos,0195,aDados[nP,7],oFont8) //Codigo produto
			oPrint:Say  (0940+nPos,0410,Substr(aDados[nP,3],1,_nTamStr),oFont8) // Desc.Produto
			
			nLinAtu := nLinAtu + 1
			
			If Len(aDados[nP,3]) > _nTamDesc
				While _lChkTam
					nPos		+= 40
					//_nTamDesc	:= _nTamDesc + 1
					oPrint:Say  (0940+nPos,0410,Substr(aDados[nP,3],_nTamDesc + 1,_nTamStr),oFont8) // Desc.Produto
					If Len(aDados[nP,3]) > (_nTamDesc + _nTamStr) + 1
						_nTamDesc += _nTamStr
						nLinAtu := nLinAtu + 1
						Loop
					Else
						_lChkTam	:= .F.
					Endif
				Enddo
			Endif
			
			
			//oPrint:Say  (0940+nPos,0410,Posicione("SB1",1,xFilial("SB1") + aDados[nP,7],"B1_DESC"),oFont8) // Desc.Produto
			oPrint:Say  (0940+nPos,1300,Transform(aDados[nP,4],"@R 9999.99"),oFont8)//quantidade produto
			oPrint:Say  (0940+nPos,1130,aDados[nP,8],oFont8)//Unidade de medida
			oPrint:Say  (0940+nPos,1550,Transform(aDados[nP,5],"@E 999,999.99"),oFont8)//Preco do produto
			//oPrint:Say  (1160+nPos,1770,Transform(aDados[nP,9],"@E 999,999.99"),oFont8)//Valor IPI
			oPrint:Say  (0940+nPos,1850,transform(aDados[nP,6],"@E 999,999.99"),oFont8)//Valor Total
			
			//nTotalIPI 	+= aDados[nP,9] // Totalizando IPI
			nTotalDesc	+= aDados[nP,10]  //Totalizando Descontos
			//nTotalAcre	+= aDados[nP,]  //Totalizando Acrescimo
			nTotalProd	+= aDados[nP,5]	//Totalizando Valor do produto
			nTotalCom	+= aDados[nP,6] // Totalizando Valor do pedido de compras
			
			nPos  += 40
			//nLinAtu := nLinAtu + 1
		EndIf
	Next
	
	DbSelectArea("PEDCOMIR")
	
	//oPrint:Say  (1930,0150,transform(nTotalIPI ,"@E 999,999.99"),oFont10)//Valor Total IPI
	oPrint:Say  (1930,0150,transform(nTotalDesc,"@E 999,999.99"),oFont10)//Valor Total Desc
	//oPrint:Say  (1930,0450,transform(nTotalDesc,"@E 999,999.99"),oFont10)//Valor Total Desc
	oPrint:Say  (1930,0750,transform(0.00,"@E 999,999.99"),oFont10)//Valor Total Acrescimo
	oPrint:Say  (1930,1250,transform(nTotalProd,"@E 999,999.99"),oFont10)// Valor Total Produtos
	oPrint:Say  (1930,2100,transform(nTotalCom ,"@E 999,999.99"),oFont10)// Total do pedido de compras
	oPrint:Say  (2100,0700,cCondPagto,oFont10)// Condicao de pagamento
	oPrint:Say  (2150,0700,cTipoFrete,oFont10)// Frete
	
	//nCont := nCont + 1
	
	//oPrint:Say  (0260,1900,Transform(StrZero(ncont,3),""),oFont10)
	//oPrint:Say  (0260,1970,"de",oFont10)
	//oPrint:Say  (0260,2020,Transform(StrZero(ncont1,3),""),oFont10)
	
	nTotalIPI 	:= 0
	nTotalDesc	:= 0
	nTotalProd	:= 0
	nTotalCom	:= 0
	
	oPrint:EndPage() // Finaliza a página
	
Enddo

oPrint:EndPage() // Finaliza a página

PEDCOMIR->( DbCloseArea() )

If Mv_par11 == 2
	oPrint:Preview()  // Visualiza antes de imprimir
Else
	oPrint:Print() // Imprime direto na impressora default do AP5
End
Return nil


//*****************************************************************************************
//|------------------------------------------------------------------------|
//| Impressao do corpo do pedido de compras                                |
//|------------------------------------------------------------------------|
Static Function EMPCAB(_cObs)

//... Impressao do cabecalho
oPrint:StartPage()   // Inicia uma nova página

oPrint:Box	(0100,0100,0500,2300) //Box Cabeça
oPrint:Say  (0100,0820,"PEDIDO DE COMPRAS",oFont24)
oPrint:Line	(0200,0800,0200,2300) // Linha Separador pedido de compras

oPrint:Line	(0100,0800,0500,0800) //Linha vertical separando dados da Indusmack

//oPrint:SayBitmap (200 , 200,Mv_Par08,250 ,250 )
oPrint:Say  ( 0200,0150,aDadosEmp[1] ,oFont10) // Nome da empresa
oPrint:Say  ( 0240,0150,aDadosEmp[2] ,oFont10) // Endereco
oPrint:Say  ( 0280,0150,"C.E.P. - " + aDadosEmp[4] ,oFont10) // CEP
oPrint:Say  ( 0320,0150,"Tel.:" + Transform(aDadosEmp[5],"@R 99-9999.9999") ,oFont10) // TEL
oPrint:Say  ( 0360,0150,"C.N.P.J. - " + aDadosEmp[6] ,oFont10) // CNPJ
oPrint:Say  ( 0400,0150,"Insc.Est. - " + aDadosEmp[7] ,oFont10) // Incr. Estadual
oPrint:Say  ( 0440,0150,"Cidade: " + aDadosEmp[8] ,oFont10) // Cidade da empresa

oPrint:Line	(0500,0800,0500,2300) // Linha Horizontal separador da data de emissão e entrega
oPrint:Say  (0210,0810,"Data Emissão",oFont10)
oPrint:Say  (0220,1050,DTOC(dDataEmi),oFont14)
oPrint:Line	(0200,1300,0300,1300) // Linha separador total de paginas
oPrint:Say  (0210,1325,"Data Entrega",oFont10)
oPrint:Say 	(0220,1550,DTOC(dDataEnt), oFont14)
oPrint:Line	(0100,1800,0300,1800)
oPrint:Line	(0300,0800,0300,2300)

oPrint:Say  (0110,1810,"Pedido Nro",oFont10)
oPrint:Say  (0130,2100,cNumPed,oFont14)
oPrint:Say  (0210,1810,"Total de Paginas",oFont10)
oPrint:Say  (0310,0810,"Solicitante - ",oFont12)
oPrint:Say  (0310,1140,_cCompr__,oFont12)
oPrint:Say  (0310,1450,"Solicitação Nro: ",oFont12)
oPrint:Say  (0310,1800,cNumSC,oFont12)
oPrint:Say  (0400,0810,"Aprovador(a) - ",oFont12)
//oPrint:Say	(0400,1140,_cAprov__,oFont12)

DbSelectArea("SCR")
DbSetOrder(1)
DbGoTop()
If DbSeek(xFilial("SCR") + "PC" + cNumPed )
	While !SCR->(EOF()) .AND. CR_NUM = cNumPed
		oPrint:Say	(0400,1120 + 300,CR_APROV + " - ",oFont12)
		SCR->(DbSkip())
	Enddo
Else
	oPrint:Say	(0400,1120,"Aprovador(es) Não Encontrado(s)",oFont12)
Endif

SCR->(DbCloseArea())


oPrint:Box	(0550,0100,0780,2300) //Box Fornecedor / Local de entrega
oPrint:Line	(0550,1150,0780,1150) //Linha vertical dividando box acima
oPrint:Say  (0560,0110,"Fornecedor",oFont10)
oPrint:Say  (0600,0110,cCodCredor + "-" + cLojaCredor + " - " + cNomeCredor,oFont10)
oPrint:Say  (0640,0110,cEnd + "-" + cBairro ,oFont10)
oPrint:Say  (0680,0110,cMun + "-" + cEst ,oFont10)
oPrint:Say  (0720,0110,"C.N.P.J." + Transform(cCGC,"@R 99.999.999/9999-99") ,oFont10)

oPrint:Say  (0650,1250,"Pedido Aprovado Eletronicamente",oFont12)

oPrint:Box	(0820,0100,1800,2300) //Box corpo dados dos itens
oPrint:Line	(0900,0100,0900,2300) //Linha vertical dividando box cabecalho dos itens

oPrint:Say  (0845,0110,"Item",oFont10)
oPrint:Line	(0820,0190,1800,0190) //Linha vertical separando itens
oPrint:Say  (0845,0250,"Codigo",oFont10)
oPrint:Line	(0820,0400,1800,0400) //Linha vertical separando Codigo
oPrint:Say  (0845,0700,"Descrição",oFont10)
oPrint:Line	(0820,1100,1800,1100) //Linha vertical separando Descricao
oPrint:Say  (0845,1130,"Unid",oFont10)
oPrint:Line	(0820,1250,1800,1250) //Linha vertical separando Unidade
oPrint:Say  (0845,1300,"Quant",oFont10)
oPrint:Line	(0820,1450,1800,1450) //Linha vertical separando Quantidade
oPrint:Say  (0845,1550,"Vlr Unit",oFont10)
oPrint:Line	(0820,1750,1800,1750) //Linha vertical separando Valor Unitario
//oPrint:Say  (0845,1850,"IPI",oFont10)
//oPrint:Line	(0820,1950,1800,1950) //Linha vertical separando IPI
oPrint:Say  (0845,1880,"Valor Total",oFont10)

oPrint:Box	(1850,0100,2000,2300) //Box corpo dados dos totais
oPrint:Line	(1900,0100,1900,2300) //Linha vertical dividando box cabecalho dos itens

//oPrint:Say  (1860,0130,"Valor Total IPI",oFont10)
//oPrint:Line	(1850,0400,2000,0400) //Linha vertical separando itens
oPrint:Say  (1860,0200,"Descontos",oFont10)
oPrint:Line	(1850,0600,2000,0600) //Linha vertical separando Codigo
oPrint:Say  (1860,0750,"Acrescimos",oFont10)
oPrint:Line	(1850,1000,2000,1000) //Linha vertical separando Descricao
oPrint:Say  (1860,1300,"Valor Total Prod.",oFont10)
oPrint:Line	(1850,1700,2000,1700) //Linha vertical separando Unidade
oPrint:Say  (1860,1820,"Valor Pedido Compras",oFont10)

oPrint:Box	(2050,0100,2250,2300) //Box corpo dados condições de fornecimento
oPrint:Say  (2060,1000,"Condições Gerais de Fornecimento",oFont10)
oPrint:Say  (2100,0110,"Condição de Pagamento:",oFont10)
oPrint:Say  (2150,0110,"Frete:",oFont10)
//oPrint:Say  (2150,1350,"Prazo de Entrega:",oFont10)

oPrint:Box	(2300,0100,3000,2300) //Box corpo dados observacoes
oPrint:Say  (2310,0110,"Observações:",oFont10)
oPrint:Say  (2380,0110,_cObs,oFont10)

oPrint:Say  (2450,0110,"2 - Vencimento deverá estar de acordo com o nosso Pedido de Compras.",oFont10)

oPrint:Say  (2520,0110,"3 - Pedido de Compras emitido na condição de que o fornecedor aceita o Manual do Fornecedor  e os Termos e",oFont10)
oPrint:Say  (2590,0110,"Condição de Compra, disponíveis on line no site www.com.",oFont10)
oPrint:Say  (2660,0110,"Qualquer modificação necessita de acordo formal e aprovado por ambas as partes para se tornar efetiva.",oFont10)

_nColPc	:= 2720
_nSubDe	:= 1
_nSubAt	:= 125

For nP := 1 to 5
	
	oPrint:Say  (_nColPc,0110,substr(_cObsItem,_nSubDe,_nSubAt),oFont10)
	_nSubDe := _nSubAt
	_nColPc	+= 50
	
Next





/*
oPrint:Box	(2550,0100,3000,2300) //Box corpo dados inspeçao de recebimentos
oPrint:Say  (2560,0500, "Inspeção de Recebimentos",oFont14)
oPrint:Say  (2560,1500, "I.R. Nro",oFont14)
oPrint:Line	(2550,0150,3000,0150) //Linha vertical separando Inspecao de Recebimento
oPrint:Line	(2620,0150,2620,2300) //Linha horizontal separando Inspecao de Recebimento
oPrint:Say  (2650,0160,"Nota Fiscal Nro:",oFont10)
oPrint:Say  (2650,1100,"Certificado Materia Prima Nro:",oFont10)
oPrint:Say  (2750,1100,"Quantidade:",oFont10)
oPrint:Say  (2750,0160,"Validade:",oFont10)
oPrint:Say  (2850,0160,"Nome:",oFont10)
oPrint:Say  (2850,1100,"Visto:",oFont10)
oPrint:Say  (2850,1800,"Data:",oFont10)
*/

DbSelectArea("PEDCOMIR")

//oPrint:EndPage() // Finaliza a página

Return


//*************************************************************************************

Static Function fAjustaSx1()

cAlias	:= Alias()
_nPerg 	:= 1

dbSelectArea("SX1")
dbSetOrder(1)
If dbSeek(cPerg)
	DO WHILE ALLTRIM(SX1->X1_GRUPO) == ALLTRIM(cPerg)
		_nPerg := _nPerg + 1
		DBSKIP()
	ENDDO
ENDIF

aRegistro:= {}
//          Grupo/Ordem/Pergunt              		/SPA/ENG/Variavl/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/DefSPA1/DefENG1/Cnt01/Var02/Def02/DefSPA2/DefENG2/Cnt02/Var03/Def03/DefSPA3/DefENG3/Cnt03/Var04/Def04/DefSPA4/DefENG4/Cnt04/Var05/Def05/DefSPA5/DefENG5/Cnt05/F3/Pyme/GRPSXG/HELP/PICTURE
aAdd(aRegistro,{cPerg,"01","Do Pedido?		","","","mv_ch1","C",06,00,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SC7","","","",""})
aAdd(aRegistro,{cPerg,"02","Ate Pedido?		","","","mv_ch2","C",06,00,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SC7","","","",""})
aAdd(aRegistro,{cPerg,"03","Do Fornecedor?	","","","mv_ch3","C",06,00,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SA2","","","",""})
aAdd(aRegistro,{cPerg,"04","Ate Fornecedor?	","","","mv_ch4","C",06,00,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SA2","","","",""})
aAdd(aRegistro,{cPerg,"05","Da Loja?		","","","mv_ch5","C",02,00,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegistro,{cPerg,"06","Ate Loja? 		","","","mv_ch6","C",02,00,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegistro,{cPerg,"07","Da Emissao?		","","","mv_ch7","D",08,00,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegistro,{cPerg,"08","Ate Emissao?	","","","mv_ch8","D",08,00,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegistro,{cPerg,"09","Do Produto?		","","","mv_ch9","C",15,00,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","","",""})
aAdd(aRegistro,{cPerg,"10","Ate Produto?	","","","mv_cha","C",15,00,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","","",""})
aAdd(aRegistro,{cPerg,"11","Imprim./Visual?	","","","mv_chb","N",01,00,2,"N","","mv_par09","Imprimir","","","","","Visua.Impr.","","","","","","","","","","","","","","","","","","","   ","","","",""})


IF Len(aRegistro) >= _nPerg
	For i:= _nPerg  to Len(aRegistro)
		Reclock("SX1",.t.)
		For j:=1 to FCount()
			If J<= LEN (aRegistro[i])
				FieldPut(j,aRegistro[i,j])
			Endif
		Next
		MsUnlock()
	Next
EndIf
dbSelectArea(cAlias)
Return

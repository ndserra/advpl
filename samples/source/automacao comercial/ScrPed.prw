#INCLUDE "RWMAKE.CH"

User Function SCRPED()   

Local aArea := GetArea()
Local aAreaSL1 := SL1->(GetArea())
Local aAreaSL2 := SL2->(GetArea())
Local nOrcam
Local sTexto                      
Local nCheques
Local nCartao
Local nConveni
Local nVales
Local nFinanc
Local nCredito		:= 0
Local nOutros
Local cQuant 		:= ""
Local cVrUnit		:= "" 			// Valor unitแrio
Local cDesconto		:= ""
Local cVlrItem		:= ""
Local nVlrIcmsRet	:= 0			// Valor do icms retido (Substituicao tributaria)
Local nTroco		:= 0
Local lMvLjTroco    := SuperGetMV("MV_LJTROCO", ,.F. )	// Verifica se utiliza troco nas diferentes formas de pagamento
Local nGar			:= 0                                // Garantia Estendida
Local aProdGarantia	:= If(Len(PARAMIXB) > 0 .AND. ValType(PARAMIXB[1]) == "A" .AND. Len(PARAMIXB[1]) > 0, PARAMIXB[1], {}) // Array com os parโmetros do rkmake de impressใo do relat๓rio de Garantia


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRelease 11.5 - Chile - F1CHIณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If cPaisLoc $ "CHI|COL" .AND. GetRpoRelease("R5") .AND. SuperGetMv("MV_CTRLFOL",,.F.)		
	lRet:= u_LjPrtPdLoc ()
	Return lRet	
EndIf


sTexto:= 'Codigo         Descricao'+Chr(13)+Chr(10)
sTexto:= sTexto+ 'Qtd             VlrUnit                 VlrTot'+Chr(13)+Chr(10)
sTexto:= sTexto+'-----------------------------------------------'+Chr(13)+Chr(10)
dbSelectArea("SL1")                                                                  
dbSetOrder(1)  
nOrcam		:= SL1->L1_NUM
nDinheir	:= SL1->L1_DINHEIR
nCheques	:= SL1->L1_CHEQUES
nCartao 	:= SL1->L1_CARTAO
nConveni	:= SL1->L1_CONVENI
nVales  	:= SL1->L1_VALES  	
nFinanc		:= SL1->L1_FINANC
nCredito	:= SL1->L1_CREDITO
nOutros		:= SL1->L1_OUTROS
nTroco		:= Iif(SL1->(FieldPos("L1_TROCO1")) > 0, SL1->L1_TROCO1, 0)
           
dbSelectArea("SL2")
dbSetOrder(1)  
dbSeek(xFilial("SL2") + nOrcam)
	
While !SL2->(Eof()) .AND. SL2->L2_FILIAL + SL2->L2_NUM == cFilAnt + nOrcam

    If aScan(aProdGarantia, { |p| RTrim(p[1]) ==  RTRim(SL2->L2_PRODUTO)} ) > 0
		cGarantia := "*"
	Else
		If SL2->(FieldPos("L2_GARANT")) > 0 .AND.  !Empty(SL2->L2_GARANT)
			cGarantia := "#"
		Else 
			cGarantia := ""
		EndIf
	EndIf           
	
	If !Empty(SL2->L2_ENTREGA)
		If !Empty(cGarantia) 
			cGarantia += IIF(SL2->L2_ENTREGA == "3", " E", IIF(SL2->L2_ENTREGA == "1", " P", "")) 
		Else 
			cGarantia := IIF(SL2->L2_ENTREGA == "3", "E", IIF(SL2->L2_ENTREGA == "1", "P", "")) 
		EndIf	    
	
	EndIf

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Faz o tratamento do valor do ICMS ret.                       ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If SL2->(FieldPos("L2_ICMSRET")) > 0 
		nVlrIcmsRet	:= SL2->L2_ICMSRET
	Endif

	cQuant 		:= StrZero(SL2->L2_QUANT, 8, 3)

	If cGarantia == "*" .OR. (Posicione("SB1",1,xFilial("SB1")+SL2->L2_PRODUTO, "B1_TIPO") == SuperGetMV("MV_LJTPGAR",,"GE"))
		cVrUnit		:= Str(((SL2->L2_QUANT * SL2->L2_VLRITEM) + SL2->L2_VALIPI + nVlrIcmsRet) / SL2->L2_QUANT, 15, 2)
	Else
		cVrUnit		:= Str(((SL2->L2_QUANT * SL2->L2_PRCTAB) + SL2->L2_VALIPI + nVlrIcmsRet) / SL2->L2_QUANT, 15, 2)
	EndIf
	cDesconto	:= Str(SL2->L2_VALDESC, TamSx3("L2_VALDESC")[1], TamSx3("L2_VALDESC")[2])
	cVlrItem	:= Str(Val(cVrUnit) * SL2->L2_QUANT, 15, 2)

	sTexto		:= sTexto + SL2->L2_PRODUTO + SL2->L2_DESCRI + Chr(13) + Chr(10)
	sTexto		:= sTexto + cQuant + '  ' + cVrUnit + '      ' + cVlrItem + Chr(13) + Chr(10)
	If SL2->L2_VALDESC > 0 
		sTexto	:= sTexto + 'Desconto no Item:              ' + Str(SL2->L2_VALDESC, 15, 2) + Chr(13) + Chr(10)
	EndIf
	SL2->(DbSkip())
Enddo                      

If SL1->L1_DESCONTO > 0
	sTexto	:= sTexto + 'Desconto no Total:             ' + Str(SL1->L1_DESCONTO, 15, 2) + Chr(13) + Chr(10)
EndIf                                                                              
If SL1->L1_JUROS > 0
	sTexto	:= sTexto + 'Acrescimo no Total:            ' + Transform(SL1->L1_JUROS, "@R 99.99%") + Chr(13) + Chr(10)
EndIf

sTexto	:= sTexto + '-----------------------------------------------' + Chr(13) + Chr(10)
sTexto	:= sTexto + 'TOTAL                         ' + Str(SL1->L1_VLRLIQ+nCredito, 15, 2) + Chr(13) + Chr(10)

If nDinheir > 0 
	sTexto := sTexto + 'DINHEIRO' + '                       ' + Str( nDinheir + nTroco, 15, 2) + Chr(13) + Chr(10)
EndIf
If nCheques > 0 
	sTexto := sTexto + 'CHEQUE' + '                         ' + Str(nCheques, 15, 2) + Chr(13) + Chr(10)
EndIf
If nCartao > 0 
	sTexto := sTexto + 'CARTAO' + '                          ' + Str(nCartao, 15, 2) + Chr(13) + Chr(10)
EndIf
If nConveni > 0 
	sTexto := sTexto + 'CONVENIO' + '                        ' + Str(nConveni, 15, 2) + Chr(13) + Chr(10)
EndIf
If nVales > 0 
	sTexto := sTexto + 'VALES' + '                           ' + Str(nVales, 15, 2) + Chr(13) + Chr(10)
EndIf
If nFinanc > 0 
	sTexto := sTexto + 'FINANCIADO' + '                      ' + Str(nFinanc, 15, 2) + Chr(13) + Chr(10)
EndIf  
If nCredito > 0
	sTexto := sTexto + 'CREDITO ' + '                       ' + Str(nCredito, 15, 2) + Chr(13) + Chr(10)
EndIf			
If lMvLjTroco .And. nTroco > 0
	sTexto := sTexto + 'TROCO   ' + '                       ' + Str(nTroco, 15, 2) + Chr(13) + Chr(10)
EndIf			                                                                                        
sTexto := sTexto + '-----------------------------------------------' + Chr(13) + Chr(10)

RestArea(aAreaSL1)
RestArea(aAreaSL2)  
RestArea(aArea)

Return sTexto   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLjPrtPdLoc  บAutorณVendas CRM		     บ Data ณ 10/06/11    บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑณDescri…o ณRotina para impressao de Comprovante de Venda - Release 11.5ณฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบSintaxe   ณExpL1 := LjPrtPdLoc()                       				  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ											                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณSIGALOJA/SIGAFRT	                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/  
User Function LjPrtPdLoc ()
Local lRet := .T.


Local wnrel   	:= "SCRPED"
Local cString  	:= "SL1"
Local cDesc1   	:= "Comprobante de Venta"
Local cDesc2   	:= ""
Local cDesc3   	:= ""
Local nLastKey 	:= 0 
Local nOrcam    := 0          
Local nCheques	:= 0 
Local nCartao	:= 0 
Local nConveni	:= 0 
Local nVales	:= 0 
Local nFinanc	:= 0 
Local nCredito	:= 0
Local nOutros 	:= 0 
Local cQuant 	:= ""
Local cVrUnit	:= ""
Local cDesconto	:= ""
Local cVlrItem	:= "" 
Local cTpEntrega:= ""
Local nLinha	:= 10 
Local nMoedaCor	:= 1						//Moeda Corrente
Local nDecimais := MsDecimais(nMoedaCor)	//Decimais

Private cTitulo  	:= "Comprobante de Venta"
Private aReturn := { "Especial", 1,"Administracion", 1, 2, 1,"",1 }

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Envia controle para a funcao SETPRINTณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
wnrel:=SetPrint(cString,wnrel,"",@cTitulo,cDesc1,cDesc2,cDesc3,.F.)
If nLastKey == 27
	Return .F.
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return .F.
Endif
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica Posicao do Formulario na Impressoraณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
VerImp()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerificar os itens que atendem o tipo de ณ
//ณentrega de acordo com o pais.            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Do Case
	Case cPaisLoc == "COL"
		cTpEntrega := "1|3"		
	Case cPaisLoc == "CHI"
		cTpEntrega := "1"
EndCase


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ                                              CABECALHO                                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
@ nLinha, 001 PSAY "Codigo"
@ nLinha, 010 PSAY "Descripcion"
@ nLinha, 060 PSAY "Cantidad"
@ nLinha, 080 PSAY "Unitario"
@ nLinha, 100 PSAY "Total"

nLinha++
@ nLinha, 001 PSAY "----------------------------------------------------------------------------------------------------------------------------"
nLinha++

dbSelectArea("SL1")                                                                  
dbSetOrder(1)  
nOrcam		:= SL1->L1_NUM
nDinheir	:= SL1->L1_DINHEIR
nCheques	:= SL1->L1_CHEQUES
nCartao 	:= SL1->L1_CARTAO
nConveni	:= SL1->L1_CONVENI
nVales  	:= SL1->L1_VALES  	
nFinanc		:= SL1->L1_FINANC
nCredito	:= SL1->L1_CREDITO
nOutros		:= SL1->L1_OUTROS
           
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ                                              ITENS		                                         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("SL2")
dbSetOrder(1)  
dbSeek(xFilial("SL2") + nOrcam)
	
While !SL2->(Eof()) .AND. SL2->L2_FILIAL + SL2->L2_NUM == cFilAnt + nOrcam
	If SL2->L2_ENTREGA $ cTpEntrega	
		cQuant 		:= StrZero(SL2->L2_QUANT, 8, 3)
		cVrUnit		:= Str(((SL2->L2_QUANT * SL2->L2_PRCTAB) / SL2->L2_QUANT), 15, nDecimais)
		cDesconto	:= Str(SL2->L2_VALDESC, TamSx3("L2_VALDESC")[1], TamSx3("L2_VALDESC")[2])
		cVlrItem	:= Str(Val(cVrUnit) * SL2->L2_QUANT, 15, nDecimais)
	     
		@ nLinha, 001 PSAY SL2->L2_PRODUTO
		@ nLinha, 010 PSAY SL2->L2_DESCRI
		@ nLinha, 060 PSAY cQuant
		@ nLinha, 080 PSAY AllTrim(cVrUnit)
		@ nLinha, 100 PSAY AllTrim(cVlrItem)
		
		If SL2->L2_VALDESC > 0 
			nLinha++
			@ nLinha, 060 PSAY 'Descuento del Item: ' + Str(SL2->L2_VALDESC, 15, nDecimais)
		EndIf
	EndIf
	SL2->(DbSkip())
	nLinha++
Enddo                      

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ                                              RODAPE		                                         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
nLinha++
If SL1->L1_DESCONTO > 0
	@ nLinha, 080 PSAY 'Descuento Total: 	            ' + Str(SL1->L1_DESCONTO, 15, nDecimais)
	nLinha++
EndIf                                                                              
If SL1->L1_JUROS > 0
	@ nLinha, 080 PSAY 'Incremento Total:            	' + Transform(SL1->L1_JUROS, "@R 99.99%")
	nLinha++
EndIf

nLinha++
@ nLinha, 001 PSAY "----------------------------------------------------------------------------------------------------------------------------"
nLinha++

@ nLinha, 080 PSAY 'TOTAL                         ' + Str(SL1->L1_VLRLIQ+nCredito, 15, nDecimais)

If nDinheir > 0
	nLinha++ 
	@ nLinha, 080 PSAY 'DINERO' + '                      	 ' + Str(nDinheir, 15, nDecimais)
EndIf
If nCheques > 0 
	nLinha++
	@ nLinha, 080 PSAY 'CHEQUE' + '                         ' + Str(nCheques, 15, nDecimais)
EndIf
If nCartao > 0 
	nLinha++
	@ nLinha, 080 PSAY 'TARJETA' + '                          ' + Str(nCartao, 15, nDecimais)
EndIf
If nConveni > 0 
	nLinha++
	@ nLinha, 080 PSAY 'CONVENIO' + '                        ' + Str(nConveni, 15, nDecimais)
EndIf
If nVales > 0 
	nLinha++
	@ nLinha, 080 PSAY 'BONOS' + '                           ' + Str(nVales, 15, nDecimais)
EndIf
If nFinanc > 0 
	nLinha++
	@ nLinha, 080 PSAY 'FINANCIADO' + '                      ' + Str(nFinanc, 15, nDecimais)
EndIf  
If nCredito > 0
	nLinha++
	@ nLinha, 080 PSAY 'CREDITO' + '                       ' + Str(nCredito, 15, nDecimais)
EndIf			
			
nLinha++
@ nLinha, 001 PSAY "----------------------------------------------------------------------------------------------------------------------------"



Set Device To Screen
If aReturn[5] == 1
	Set Printer TO
	dbcommitAll()
	ourspool(wnrel)
Endif
MS_FLUSH()

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ VerImp   บAutor  ณVendas CRM		     บ Data ณ  10/06/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica posicionamento de papel na Impressora             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SCRPED	                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function VerImp()

Local aDriver  :=  ""
Local nOpc     

nLin:= 0                // Contador de Linhas
aDriver:=ReadDriver()
If aReturn[5]==2
	
	nOpc       := 1
	While .T.
		
		SetPrc(0,0)
		dbCommitAll()
		
		@ 00   ,000	PSAY aDriver[5]
		@ nLin ,000 PSAY " "
		@ nLin ,004 PSAY "*"
		@ nLin ,022 PSAY "."
		
		IF MsgYesNo(OemToAnsi("ฟFomulario esta en posicion? "))
		   nOpc := 1
		ElseIF MsgYesNo(OemToAnsi("ฟIntenta Nuevamente? "))
		   nOpc := 2
		Else
		   nOpc := 3
		Endif

		Do Case
		Case nOpc==1
			lContinua := .T.
			Exit
		Case nOpc==2
			Loop
		Case nOpc==3
			lContinua := .F.
			Return
		EndCase
	End
Endif
Return

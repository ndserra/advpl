#Include "Rwmake.ch"
         
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFa100Trf  บAutor  ณAndre Veiga         บ Data ณ  23/01/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณP.E. na Transferencia da Movimentacao Bancaria              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRegistrar a Sangria no ECF e abrir a gaveta.                บฑฑ 
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณ23/06/05  ณ083499ณMarcos  ณIncluido a funcao LJVLDSERIE para verificar ณฑฑ
ฑฑณ          ณ      ณ        ณse o nro de serie do ECF conectado e o mesmoณฑฑ 
ฑฑณ          ณ      ณ        ณcadastrado na estacao                       ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Fa100Trf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณParametros recebidos       ณ
//ณ====================       ณ
//ณ[1] Banco Origem           ณ
//ณ[2] Agencia Origem         ณ
//ณ[3] Conta Origem           ณ
//ณ[4] Banco Destino          ณ
//ณ[5] Agencia Destino        ณ
//ณ[6] Conta Destino          ณ
//ณ[7] Tipo Transerencia      ณ
//ณ[8] Tipo Documento         ณ
//ณ[9] Valor Transferencia    ณ
//ณ[10] Historico             ณ
//ณ[11] Beneficiario          ณ
//ณ[12] Natureza origem       ณ
//ณ[13] Natureza Destino      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local cBcoOrig 	:= ParamIxb[1]
Local cAgenOrig	:= ParamIxb[2]
Local cCtaOrig	:= ParamIxb[3]
Local cBcoDest	:= ParamIxb[4]
Local cAgenDest	:= ParamIxb[5]
Local cCtaDest	:= ParamIxb[6]
Local cTipoTran	:= ParamIxb[7]
Local cDocTran	:= ParamIxb[8]
Local nValorTran:= ParamIxb[9]
Local cHist100	:= ParamIxb[10]
Local cBenef100	:= ParamIxb[11]
Local cNaturOri	:= ParamIxb[12]
Local cNaturDes	:= ParamIxb[13]
Local iRet		:= -1       
Local lRetorno  := .T. // Retorno da funcao
Local cPortaGav	:= LJGetStation("PORTGAV")
Local ccaixa    := xNumCaixa()

If lFiscal  
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณConsiste o numero de serie do equipamento conforme arq. sigaloja.bin ณ 
	//ณsomente se o parametro MV_LJNSECF = .T.                              ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If	LJVLDSERIE() 
		If cBcoOrig == cCaixa
			// Faz a sangria
			iRet := IFSupr( nHdlECF, 3, Str(nValorTran,14,2), '', '' )
		ElseIf cBcoDest == cCaixa
			// Faz o troco
			iRet := IFSupr( nHdlECF, 2, Str(nValorTran,14,2), '', '' )
		Endif
	
		If iRet = 0 
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณVerifica se ha gaveta configurada na porta COMณ
			//ณCaso nao tenha envia o comando pelo ECF       ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If lGaveta
				iRet := GavetaAci( nHdlGaveta, cPortaGav )
			Else
				iRet := IFGaveta( nHdlECF )
			Endif
		Else
			MsgStop("Nใo foi possํvel registrar " + If( cBcoOrig == cCaixa, "Sangria", "Troco") + " no ECF. Opera็ใo nใo efetuada.", "Aten็ใo")	
			lRetorno := .F.
		Endif	     
	Else
		lRetorno := .F.
	EndIf	
EndIf

Return lRetorno

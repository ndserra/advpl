#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRDMAKE    ³SCRFISCC  ºAutor  ³Microsiga Software S/Aº Data ³ 02/08/04  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Faz a impressao do cupom fiscal na Venda Balcao Concomitan-º±±
±±º          ³ te                                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGALOJA                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ScrFisCC()
Local _nDescLoj   	:= ParamIxb[1]
Local _nTroco     	:= ParamIxb[10]
Local _nCredito   	:= ParamIxb[12]
Local _Vinculado  	:= ParamIxb[13]
Local _nDescFin   	:= ParamIxb[14]
Local _lFound     	:= .F.
Local _nOldOrder  	:= _nOldRecno := 0
Local _iRetorno    	:= 0
Local _cAcrescimo
Local _aTotForm
Local _sFormaPagto
Local _aFormPag
Local _nTrocoAux   	:= _nTroco
Local _acReceb
Local _nVlrAcrDesc 	:= 0
Local i
Local nLoopParc     := 0
Local cFormRet      := GetPvProfString("Condicao de Pagamento", "Retencoes", "RETENCOES", GetClientDir()+"SIGALOJA.INI")
Local nRestDiv      := 0
Local lPCCRet       := FindFunction("LJPCCRet")

If !File( GetClientDir()+"SIGALOJA.INI" )
	WritePProString("Condicao de Pagamento", "Retencoes", "RETENCOES", GetClientDir()+"SIGALOJA.INI")
EndIf

//Para utilizar o conceito de cliente entrega
If SL1->(FieldPos( "L1_CLIENT" )) > 0 .And. SL1->(FieldPos( "L1_LOJENT" )) > 0
	If !Empty( SL1->L1_CLIENT) .And. !Empty( SL1->L1_LOJENT )
		SA1->(dbSetOrder( 1 ))
		SA1->(MsSeek( xFilial( "SA1" ) + SL1->L1_CLIENT + SL1->L1_LOJENT) )
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica o Desconto e o Acrescimo   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_nVlrAcrDesc := nVlrAcrs - (_nDescloj + _nDescFin)
If _nVlrAcrDesc > 0
	_cAcrescimo := Alltrim(Str(_nVlrAcrDesc,14,2))
	_iRetorno := IFAcresTot( nHdlECF, _cAcrescimo )
	If L010AskImp(.F.,_iRetorno)
		Return (.F.)
	EndIf
ElseIf _nVlrAcrDesc < 0
    _cDescTotal := Alltrim(Str( Abs(_nVlrAcrDesc), 14, 2 ))
	_iRetorno := IFDescTot( nHdlECF,_cDescTotal )
	If L010AskImp(.F.,_iRetorno)
		Return (.F.)
	EndIf
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se existe o ponto de entrada para montar a string com   ³
//³as formas de pagamento.                                          ³
//³O sistema vai verificar o parametro MV_LJPAGTO para verificar    ³
//³qual a forma de pagamento sera registrada no ECF. O cliente      ³
//³podera utilizar a descricao da tabela 24 do SX5 ou a descricao   ³
//³cadastrada no arquivo de administradoras (SAE).                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock('LJ220PAG')
	_sFormaPagto := ExecBlock('LJ220PAG')
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica quais as formas de pagamento estão registradas no ECF   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MonFormPag( @_aFormPag )
	_aTotForm := Array(Len(_aFormPag))
	AFill(_aTotForm, 0)

	_acReceb  := aClone(aReceb)
	nLoopParc := Len(_acReceb)
	
	//Reajuste dos valores de Pis/COFInS nas parcelas
	If lPCCRet .AND. LJPCCRet() > 0 .And. ( nLoopParc != 1 .Or. (nLoopParc == 1 .And. _acReceb[1][2] > 0) )
		
		For i := 1 to nLoopParc
			_acReceb[i][2] -= NoRound(((LJPCCRet()) / nLoopParc ),nDecimais)
			nRestDiv += NoRound(((LJPCCRet()) / nLoopParc ),nDecimais)
		Next i
		           
		If nRestDiv < (LJPCCRet())
			_acReceb[nLoopParc][2] -= (LJPCCRet()) - nRestDiv
		EndIf
	EndIf

	If _nCredito > 0
		AADD(_acReceb,{dDataBase,_nCredito,"CR",,,,,,,.F.,1})
	Endif

	For i := 1 To Len(_acReceb)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³O parametro MV_LJPAGTO retorna um valor inteiro. Pode ser      ³
		//³1 que irá indicar que a descrição da forma de pagto será a da  ³
		//³tabela 24 do SX5 ou 2, que será do cadastro de administradoras ³
		//³(SAE).                                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Alltrim(_acReceb[i][3]) $ GetMv('MV_SIMB1')+',CH,CR' .or. GetNewPar("MV_LJPAGTO",1)==1
			nPos := 	AScan(_aFormPag, {|x| Upper(x[2])==Upper(Alltrim(_acReceb[i][3]))})
		Else
			nPos := 	AScan(_aFormPag, {|x| Upper(x[1])==Upper(Alltrim(Subst(_acReceb[i][4],7,30)))})
		Endif
		
		if Alltrim(_acReceb[i][3]) $ GetMv('MV_SIMB1')+',VA'
			_aTotForm[nPos] += _acReceb[i][2] + _nTrocoAux
			_nTrocoAux := 0
		else
			_aTotForm[nPos] += _acReceb[i][2]
		Endif
	Next
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Registra o pagamento da venda                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_sFormaPagto := ''
	For i:=1 to Len(_aFormPag)
		If _aTotForm[i] > 0
			_sFormaPagto := _sFormaPagto + _aFormPag[i][IIF(GetMV("MV_LJPAGTO")==1,3,1)] + '|' + Alltrim(Str(_aTotForm[i],14,nDecimais)) + '|'
		Endif
	Next i
	
	If lPCCRet .AND. LJPCCRet() > 0
		_sFormaPagto := _sFormaPagto + cFormRet + '|' + Alltrim(Str((LJPCCRet()),14,nDecimais)) + '|'
	EndIf
		
Endif

iRet := IFPagto( nHdlECF, _sFormaPagto, _Vinculado ) //	Efetua a impressao do Item
If L010AskImp(.F.,iRet)
	Return (.F.)
EndIf

cOrcam	  := "Orcamento: " + SL1->L1_NUM + " "
cMensagem := AllTrim(GetMV("MV_LJFISMS"))
If Empty(cMensagem)
   If SLG->(FieldPos("LG_MSGCUP"))>0
      cMensagem := Rtrim(SLG->LG_MSGCUP)
   EndIf   
EndIf 

cString:= cOrcam + cMensagem

// Armazena o número da nota a ser gravado, neste caso o do cupom fiscal
cNumNota 	:= cNumCupFis

// Guarda o n£mero do cupom que foi aberto
cOldCupFis  := cNumCupFis

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fecha o cupom e imprime a mensagem promocional  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_iRetorno := IFFechaCup( nHdlECF,cString )	//	Fecha Cupom
If L010AskImp(.F.,_iRetorno)
	Return (.F.)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pega o numero do proximo cupom 				    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_iRetorno := 0
cNumCupFis := "000000"
Do While (Val(cNumCupFis) = 0) .and. (_iRetorno <> 1)
	_iRetorno := IFPegCupom(nHdlECF, @cNumCupFis)
	If L010AskImp(.F.,_iRetorno)
		If Aviso("Problemas com a impressora fiscal", "O cupom fiscal foi impresso/finalizado corretamente?", {"Sim","Não"}) == 1
			IFCancCup(nHdlECF)
			Aviso("Efetuado o cancelamento do cupom", "O cupom fiscal foi cancelado pois houve erro no processo.", {"Ok"})
		EndIf
		Return (.F.)
	EndIf
	cNumCupFis := StrZero(Val(cNumCupFis),TamSx3("L1_NUMCFIS")[1],0)
Enddo

// Procura o cupom a ser gravado na base
_nOldOrder := SL1->(IndexOrd())
_nOldRecno := SL1->(Recno())
SL1->(DbSetOrder(2))

_lFound := SL1->(Dbseek(xFilial("SL1")+cSerie+cNumCupFis+cNumPdv))
SL1->(DbSetOrder(_nOldOrder)) 
SL1->(DbGoto(_nOldRecno))

// Faz Consistˆncia do cupom
if ! (cOldCupFis == cNumCupFis) .OR. _lFound
	If Aviso("Problemas com a impressora fiscal", "O cupom fiscal foi impresso/finalizado corretamente?", {"Sim","Não"}) == 1
		IFCancCup(nHdlECF)
		Aviso("Efetuado o cancelamento do cupom", "O cupom fiscal foi cancelado pois houve erro no processo.", {"Ok"})
	EndIf
	Return(.F.)
else
	Return(.T.)
endif

Return

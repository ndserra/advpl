#INCLUDE "RWMAKE.CH"
#INCLUDE "LJIMPCUP.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LJIMPCUP  º Autor ³ Fernando Salvatori º Data ³  16/08/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de entrada para impressao do cupom fiscal            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LJTER01                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function LJIMPCUP()
Local _i, _cImpCup  := GetMv("MV_IMPCUP")
Local _nColunas := IIf(Substr(_cImpCup, 1, 8) == "BEMATECH", 40, 48) // No de Colunas
Local _nLinEject:= IIf(Substr(_cImpCup, 1, 8) == "BEMATECH",  9,  6) // No Linhas para Eject
Local _cMsg1    := ""    
Local _cNomVend := ""
Local _cDescCpg := ""

Local _cNumOrc    := ParamIXB[1]
Local _cCodVen    := ParamIXB[4]

dbSelectArea( "SA3" )
dbSetOrder( 1 )
If dbSeek( xFilial( "SA3" ) + _cCodVen)
	_cNomVend := A3_NOME
EndIf

dbSelectArea( "SL1" )
dbSetOrder( 1 )
If dbSeek( xFilial( "SL1" ) + _cNumOrc )

	dbSelectArea("SE4")
	dbSetOrder(1)
	If dbSeek( xFilial( "SE4") + SL1->L1_CONDPG )
		_cDescCpg := Substr(SE4->E4_DESCRI, 1, 32)
	EndIf
	dbSelectArea( "SL1" )
	TerPBegin(,"P",10)   // se quiser imprimir na serial apenas altere o segundo parametro para "S"
	TerPrint(Replicate("-",_nColunas))
	
	_cMsg1  := ""
	_cMsg1  += STR0001//"TOTAL ----->> : "
	_cMsg1  += Str(SL1->L1_VLRLIQ, 10, 2)
	TerPrint(_cMsg1)
	TerPrint(Replicate("-",_nColunas))
	
	_cMsg1  := ""
	_cMsg1  += STR0002 + _cNumOrc//"Pedido : "
	_cMsg1  += STR0003 + _cNomVend//"  Vendedor: "
	TerPrint(_cMsg1)
	TerPrint("")
	TerPrint(Replicate("-",_nColunas))
	
	// Imprime 6 linhas em branco para dar a altura do corte do papel
	For _i := 1 To 3
		TerPrint("")
	Next _i
	
	TerPrint(Replicate("-",_nColunas))
	
	For _i := 1 To _nLinEject
		TerPrint("")
	Next _i
	
	TerPEnd()
EndIf

Return .t.

#INCLUDE "FRTR860A.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³ FRTR860A    ³ Autor ³ Vendas Cliente     ³ Data ³ 29/04/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Relatorio de Nota de Credito - Front Loja                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpA1 - Notas de Credito Utilizadas                        ³±±
±±³          ³ ExpA2 - Notas de Credito que podem ser utilizadas          ³±±
±±³          ³ ExpN3 - Valor Total da Compra                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ ExR1 - Nil                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³ Uso      ³ Sigaloja                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function FRTR860A (aNewNCC, aNCCItens , nVlrCompra )							 

Local nX			:= 0		// CONTADOR
Local nY			:= 0		// CONTADOR
Local nLin			:= 8		// CONTADOR
Local wnrel			:= STR0001  //"FRTR860A"
Local NomeProg		:= STR0001 //"FRTR860A"
Local cString  		:= "SL1"   //Variavel contendo a string "SL1"
Local cTitulo		:= STR0002 //"Nota de Crédito"
Local cDesc1		:= STR0003 //"Este programa tem a função de emitir a Nota de Crédito."
Local cPerg			:= ""      // Pergunt

Private nLasKey		:= 0       									// Ultima chave
Private aReturn  	:= { STR0004, 1,STR0005, 2, 2, 1, "",} 	//"Zebrado"###"Administracao"
Private m_pag		:= 0                   						//Númer de paginas

Default aNewNCC 	:= {}
Default aNCCItens   := {}
Default nVlrCompra	:= 0


SetPrint(cString,wnrel,cPerg,@cTitulo,cDesc1,,,.F. )

If nLastKey == 27
	Return .F.
EndIf

SetDefault(aReturn,cString)

If nLastKey == 27
	Return .F.
EndIf

For nX:= 1 To Len(aNewNCC)
	SA1->(DbSetOrder(1))
	If SA1->(DbSeek(xFilial("SA1")+aNewNCC[nX][8]+aNewNCC[nX][9]))
		@ nLin,010 PSAY STR0006 + aNewNCC[nX][8]+ STR0007 + aNewNCC[nX][9] + STR0008 + Alltrim(SA1->A1_NOME) //"Código: "###" Loja: "###" Nome: "
		nLin++
	Endif 
	@ nLin,010 PSAY STR0009 + DTOC(aNewNCC[nX][5]) + STR0010 + DTOC(aNewNCC[nX][6])  //"Data de Emissão: "###" Data de Validade da NCC: "
	nLin++
	@ nLin,010 PSAY STR0011 + aNewNCC[nX][1] + STR0012 + aNewNCC[nX][2] + STR0013+ SuperGetMV("MV_SIMB"+Alltrim(STR(aNewNCC[nX][10])))+ " "+ Transform(aNewNCC[nX][7],PesqPict("SE1","E1_SALDO"))  //"Prefixo: "###" Número: "###" Saldo NCC: "
	nLin++	
	@ nLin,010 PSAY STR0014 + SuperGetMV("MV_SIMB"+Alltrim(STR(aNewNCC[nX][10])))+ " "+Transform(nVlrCompra,PesqPict("SE1","E1_SALDO")) //"Valor Compra: "
	nLin+= 3
	@ nLin,010 PSAY STR0015  	//"Creditos Utilizados "
	nLin++		
	@ nLin,010 PSAY STR0016 	//"Prefixo "
	@ nLin,060 PSAY STR0017 	//"Numero "
	@ nLin,120 PSAY STR0018 	//"Valor "

	If Len(aNCCItens) > 0 
		           
		For nY := 1 to Len(aNCCItens)
			nLin++		
			
    		If aNCCItens[nY][1]
				
				@ nLin,010 PSAY aNCCItens[nY][9]    		
				@ nLin,060 PSAY aNCCItens[nY][3]
				@ nLin,120 PSAY SuperGetMV("MV_SIMB"+Alltrim(STR(aNCCItens[nY][8])))+ " "+Transform(aNCCItens[nY][2],PesqPict("SE1","E1_SALDO"))

			Endif
			
		Next nY

	Endif 					            

Next nX 

If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
EndIf

MS_Flush()

Return Nil 
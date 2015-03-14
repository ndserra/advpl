#INCLUDE "FRTR950.ch"
#INCLUDE "RWMAKE.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³ FRTR950     ³ Autor ³ Vendas Cliente     ³ Data ³ 29/04/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Relatorio de Nota de Credito - Front Loja                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ ExR1 - Nil                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³ Uso      ³ Sigaloja                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function FRTR950()
Local aArea    	:= GetArea() 			// Backup de Areaa
Local nCheck	:= Paramixb[1]      	// Check
Local cCodOrigem:= Paramixb[2]      	// codigo de origem
Local cCodDestin:= Paramixb[3]			// Cod do destina
Local nDinheir	:= Paramixb[4]			// Numero do Dinhiro
Local nCheques	:= Paramixb[5]			// Numero de Cheque
Local nCartao	:= Paramixb[6]			// Numero de Cartao
Local nVlrDebi	:= Paramixb[7]			// Valor de Debito
Local nFinanc	:= Paramixb[8]			// Valor financeiro
Local nConveni	:= Paramixb[9]			// Valor convenio
Local nVales	:= Paramixb[10]			// Vales
Local nOutros	:= Paramixb[11]			// Outros valores
Local nVlrTot	:= 0					// Total
Local nLin		:= 8					// Numero de Linha
Local wnrel		:= "FRTR950"			// Fonte

Local cNomeProg	:= STR0001 	//"FRTR950"
Local cString  	:= "SL1"   	// Variavel contendo a string "SL1"
Local cTitulo	:= STR0002 	//"Nota de Crédito"
Local cDesc1	:= STR0003 	//"Este programa tem a função de emitir a Nota de Crédito."
Local cPerg		:= ""		//

Private nLasKey	:= 0									 // Ultima Pagina
Private aReturn := { STR0004, 1,STR0005, 2, 2, 1, "",}  //"Zebrado"###"Administracao"
Private m_pag	:= 0 									 // Numero da pagina	


nVlrTot := nDinheir+nCheques+nCartao+nVlrDebi+nFinanc+nConveni+nVales+nOutros

If nVlrTot == 0 
	Aviso(STR0006, STR0007, {STR0008})  //"Atenção!"###"Não existem dados a listar."###"Ok"
	Return
EndIf

SetPrint(cString,wnrel,cPerg,@cTitulo,cDesc1,,,.F. )

If nLastKey == 27
	Return .F.
EndIf

SetDefault(aReturn,cString)

If nLastKey == 27
	Return .F.
EndIf

@ nLin,010 PSAY STR0009  //"Comprovante de Operação Não Fiscal"
nLin++
@ nLin,010 PSAY STR0010 +If(nCheck == 1,STR0011,STR0012) //"Tipo de Operação: "###"SANGRIA"###"SUPRIMENTO"
nLin++
@ nLin,010 PSAY STR0013 + Alltrim(SM0->M0_NOME) + STR0014 + Transform(Alltrim(SM0->M0_CGC),PesqPict("SA1","A1_CGC")) //"Empresa: "###" CNPJ: "
nLin++
@ nLin,010 PSAY STR0015 + DTOC(dDataBase) + STR0016 + Time() //"Data: "###" Hora: "
nLin++
@ nLin,010 PSAY STR0017 + cCodOrigem + STR0018 + cCodDestin //"Caixa Origem: "###" Caixa Destino: "
nLin+= 3
@ nLin,010 PSAY STR0019 		  //"Tipo"
@ nLin,090 PSAY STR0020 	 //"Valor "
nLin++
If nDinheir > 0
	nLin++
	@ nLin,010 PSAY STR0021 		  //"DINHEIRO"
	@ nLin,090 PSAY Transform(nDinheir,PesqPict("SE1","E1_SALDO"))	
EndIf
If nCheques > 0			     
	nLin++
	@ nLin,010 PSAY STR0022 		  //"CHEQUE"
	@ nLin,090 PSAY Transform(nCheques,PesqPict("SE1","E1_SALDO"))	
EndIf	
If nCartao > 0			     
	nLin++
	@ nLin,010 PSAY STR0023 		  //"CARTAO CREDITO"
	@ nLin,090 PSAY Transform(nCartao,PesqPict("SE1","E1_SALDO"))	
EndIf	
If nVlrDebi > 0			     
	nLin++
	@ nLin,010 PSAY STR0024 		  //"CARTAO DEBITO"
	@ nLin,090 PSAY Transform(nVlrDebi,PesqPict("SE1","E1_SALDO"))	
EndIf	
If nFinanc > 0			     
	nLin++
	@ nLin,010 PSAY STR0025 		  //"FINANCIADO"
	@ nLin,090 PSAY Transform(nFinanc,PesqPict("SE1","E1_SALDO"))	
EndIf	
If nConveni > 0			     
	nLin++
	@ nLin,010 PSAY STR0026 		  //"CONVENIO"
	@ nLin,090 PSAY Transform(nConveni,PesqPict("SE1","E1_SALDO"))	                                           
EndIf
If nVales > 0			     
	nLin++
	@ nLin,010 PSAY STR0027 		  //"VALES"
	@ nLin,090 PSAY Transform(nVales,PesqPict("SE1","E1_SALDO"))	                                           
EndIf
If nOutros > 0			     
	nLin++
	@ nLin,010 PSAY STR0028 		  //"OUTROS"
	@ nLin,090 PSAY Transform(nOutros,PesqPict("SE1","E1_SALDO"))	  
EndIf	

If nVlrTot > 0 
	nLin++
	@ nLin,010 PSAY STR0029 		  //"TOTAL........................."
	@ nLin,090 PSAY Transform(nVlrTot,PesqPict("SE1","E1_SALDO"))	
Endif 
nLin+=2
@ nLin,010 PSAY STR0030 + Alltrim(PswRet()[1][2]) //"Caixa: "

If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
EndIf

MS_Flush()
RestArea(aArea)

Return Nil 
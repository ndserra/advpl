#INCLUDE "LOJR950.ch"
#INCLUDE "Protheus.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³ LOJR950     ³ Autor ³ Vendas CLientes    ³ Data ³ 29/04/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Relatorio de Nota de Credito                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 - Tipo de Operacao - Sangria ou Suprimento           ³±±
±±³          ³ ExpC2 - Caixa Origem                                       ³±±
±±³          ³ ExpC3 - Caixa Destino                                      ³±±
±±³          ³ ExpN4 - Valor em Dinheiro                                  ³±±
±±³          ³ ExpN5 - Valor em Cheque                                    ³±±
±±³          ³ ExpN6 - Valor em Cartao de Credito                         ³±±
±±³          ³ ExpN7 - Valor em Cartao de Debito                          ³±±
±±³          ³ ExpN8 - Valor em Financiamento                             ³±±
±±³          ³ ExpN9 - Valor em Convenio                                  ³±±
±±³          ³ ExpN10- Valor em Vales                                     ³±±
±±³          ³ ExpN11- Valor em Outros                                    ³±±
±±³          ³ ExpA12- Simbolos Utilizados                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ ExR1 - Nil                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³ Uso      ³ Sigaloja                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/              
User Function LOJR950()  

Local aArea    		:= GetArea() 	// Bk da Area
Local nCheck		:= Paramixb[1]	// Numero de check 
Local cCodOrigem	:= Paramixb[2]	// Codigo de Origem
Local cCodDestin	:= Paramixb[3]	// Codigo de Destina
Local nDinheir		:= Paramixb[4]	// Numero de inheiro
Local nCheques		:= Paramixb[5]	// Numero de Cheque 
Local nCartao		:= Paramixb[6]	// Numero de Cartão
Local nVlrDebi		:= Paramixb[7]	// Valor de Debito
Local nFinanc		:= Paramixb[8]	// Numero de Financeiro
Local nConveni		:= Paramixb[9]		// Numero do convenio
Local nVales		:= Paramixb[10]   	// Numero de Vales
Local nOutros		:= Paramixb[11]		// Numero de Outros
Local aSimbs		:= Paramixb[12]		// Array com sib
Local nX			:= 0     			// Contador 
Local nVlrTot		:= 0				// Valor total

Static _nLinha := 0			// Linha
Static _nPage  := 0         // Pagina

_nLinha   := 310
_nPage    := 1

nVlrTot := nDinheir+nCheques+nCartao+nVlrDebi+nFinanc+nConveni+nVales+nOutros

If nVlrTot == 0 
	Aviso(STR0001, STR0002, {STR0003}) //"Atenção!"###"Não existem dados a listar."###"Ok" //"Atenção!"###"Não existem dados a listar."###"Ok"
	Return
EndIf

SetPrvt(STR0004) //"oPrint"
oPrint:= TMSPrinter():New(STR0005)   //"Comprovante de Operação não Fiscal" //"Comprovante de Operação Não Fiscal"
oPrint:SetPortrait()   

oFontCN08  := TFont():New("Courier New", 08, 08, .F., .F., , , , .F., .F.)
oFontCN08N := TFont():New("Courier New", 08, 08, .F., .T., , , , .F., .F.)
oFontCN11N := TFont():New("Courier New", 11, 11, .F., .T., , , , .F., .F.)
oFontCN12  := TFont():New("Courier New", 12, 12, .F., .F., , , , .F., .F.)
oFontCN12N := TFont():New("Courier New", 12, 12, .F., .T., , , , .F., .F.)

oFont18N := TFont():New("Tahoma", 18, 18, .F., .T., , , , .F., .F.)
oFont26N := TFont():New("Tahoma", 26, 26, .F., .T., , , , .F., .F.)

MsgRun(STR0006,"",{|| CursorWait(), LjComPrint(oPrint,nCheck,cCodOrigem,cCodDestin,;
												nDinheir,nCheques,nCartao,nVlrDebi,;
												nFinanc,nConveni,nVales,nOutros,;
												aSimbs,nVlrTot),;
												CursorArrow()}) //"Gerando Visualização, Aguarde..." //"Gerando Visualização, Aguarde..."
oPrint:Preview()  // Visualiza antes de imprimir
RestArea(aArea)

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄ´ÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³LjComPrint³ Autor ³TOTVS                   ³ Data ³ 08/03/2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Imprime e gera a visualizacao do relatorio                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³SIGALOJA                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LjComPrint(	oPrint,nCheck,cCodOrigem,cCodDestin,;
							nDinheir,nCheques,nCartao,nVlrDebi,;
							nFinanc,nConveni,nVales,nOutros,;
							aSimbs,nVlrTot)

Local nLin	  := 0 // Numero de linha

Default oPrint  		:= Nil
Default nCheck          := 0
Default cCodOrigem      := ""
Default cCodDestin      := ""
Default nDinheir        := 0
Default nCheques        := 0
Default nCartao         := 0
Default nVlrDebi        := 0
Default nFinanc         := 0
Default nConveni        := 0
Default nVales          := 0
Default nOutros         := 0
Default aSimbs          := {}
Default nVlrTot         := 0

/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³   ESCALA PARA POSICIONAMENTO DA IMPRESSAO    ³
//³                                              ³
//³A impressao das linhas abaixo pode ser ativada³
//³se for necessario efetuar uma manutencao neste³
//³relatorio                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//Marcacoes de Linhas
oPrint:Say(0300, 0110, "0300", oFontCN08)
oPrint:Say(0400, 0110, "0400", oFontCN08)
oPrint:Say(0500, 0110, "0500", oFontCN08)
oPrint:Say(0600, 0110, "0600", oFontCN08)
oPrint:Say(0700, 0110, "0700", oFontCN08)
oPrint:Say(0800, 0110, "0800", oFontCN08)
oPrint:Say(0900, 0110, "0900", oFontCN08)
oPrint:Say(1000, 0110, "1000", oFontCN08)
oPrint:Say(1100, 0110, "1100", oFontCN08)
oPrint:Say(1200, 0110, "1200", oFontCN08)
oPrint:Say(1300, 0110, "1300", oFontCN08)
oPrint:Say(1400, 0110, "1400", oFontCN08)
oPrint:Say(1500, 0110, "1500", oFontCN08)
oPrint:Say(1600, 0110, "1600", oFontCN08)
oPrint:Say(1700, 0110, "1700", oFontCN08)
oPrint:Say(1800, 0110, "1800", oFontCN08)
oPrint:Say(1900, 0110, "1900", oFontCN08)
oPrint:Say(2000, 0110, "2000", oFontCN08)
oPrint:Say(2100, 0110, "2100", oFontCN08)
oPrint:Say(2200, 0110, "2200", oFontCN08)
oPrint:Say(2300, 0110, "2300", oFontCN08)
oPrint:Say(2400, 0110, "2400", oFontCN08)
oPrint:Say(2500, 0110, "2500", oFontCN08)
oPrint:Say(2600, 0110, "2600", oFontCN08)
oPrint:Say(2700, 0110, "2700", oFontCN08)
oPrint:Say(2800, 0110, "2800", oFontCN08)
oPrint:Say(2900, 0110, "2900", oFontCN08)
oPrint:Say(3000, 0110, "3000", oFontCN08)
oPrint:Say(3100, 0110, "3100", oFontCN08)

oPrint:Line	(0300, 0080, 0300, 0100)
oPrint:Line	(0350, 0090, 0350, 0100)
oPrint:Line	(0400, 0080, 0400, 0100)
oPrint:Line	(0450, 0090, 0450, 0100)
oPrint:Line	(0500, 0080, 0500, 0100)
oPrint:Line	(0550, 0090, 0550, 0100)
oPrint:Line	(0600, 0080, 0600, 0100)
oPrint:Line	(0650, 0090, 0650, 0100)
oPrint:Line	(0700, 0080, 0700, 0100)
oPrint:Line	(0750, 0090, 0750, 0100)
oPrint:Line	(0800, 0080, 0800, 0100)
oPrint:Line	(0850, 0090, 0850, 0100)

oPrint:Line	(0900, 0080, 0900, 0100)
oPrint:Line	(0950, 0090, 0950, 0100)
oPrint:Line	(1000, 0080, 1000, 0100)
oPrint:Line	(1050, 0090, 1050, 0100)
oPrint:Line	(1100, 0080, 1100, 0100)
oPrint:Line	(1150, 0090, 1150, 0100)
oPrint:Line	(1200, 0080, 1200, 0100)
oPrint:Line	(1250, 0090, 1250, 0100)
oPrint:Line	(1300, 0080, 1300, 0100)
oPrint:Line	(1350, 0090, 1350, 0100)
oPrint:Line	(1400, 0080, 1400, 0100)
oPrint:Line	(1450, 0090, 1450, 0100)
oPrint:Line	(1500, 0080, 1500, 0100)
oPrint:Line	(1550, 0090, 1550, 0100)
oPrint:Line	(1600, 0080, 1600, 0100)
oPrint:Line	(1650, 0090, 1650, 0100)
oPrint:Line	(1700, 0080, 1700, 0100)
oPrint:Line	(1750, 0090, 1750, 0100)
oPrint:Line	(1800, 0080, 1800, 0100)
oPrint:Line	(1850, 0090, 1850, 0100)
oPrint:Line	(1900, 0080, 1900, 0100)
oPrint:Line	(1950, 0090, 1950, 0100)
oPrint:Line	(2000, 0080, 2000, 0100)
oPrint:Line	(2050, 0090, 2050, 0100)
oPrint:Line	(2100, 0080, 2100, 0100)
oPrint:Line	(2150, 0090, 2150, 0100)
oPrint:Line	(2200, 0080, 2200, 0100)
oPrint:Line	(2250, 0090, 2250, 0100)
oPrint:Line	(2300, 0080, 2300, 0100)
oPrint:Line	(2350, 0090, 2350, 0100)
oPrint:Line	(2400, 0080, 2400, 0100)
oPrint:Line	(2450, 0090, 2450, 0100)
oPrint:Line	(2500, 0080, 2500, 0100)
oPrint:Line	(2550, 0090, 2550, 0100)
oPrint:Line	(2600, 0080, 2600, 0100)
oPrint:Line	(2650, 0090, 2650, 0100)
oPrint:Line	(2700, 0080, 2700, 0100)
oPrint:Line	(2750, 0090, 2750, 0100)
oPrint:Line	(2800, 0080, 2800, 0100)
oPrint:Line	(2850, 0090, 2850, 0100)
oPrint:Line	(2900, 0080, 2900, 0100)
oPrint:Line	(2950, 0090, 2950, 0100)
oPrint:Line	(3000, 0080, 3000, 0100)
oPrint:Line	(3050, 0090, 3050, 0100)
oPrint:Line	(3100, 0080, 3100, 0100)
oPrint:Line	(3150, 0090, 3150, 0100)
oPrint:Line	(3200, 0080, 3200, 0100)

oPrint:Line	(0280, 0100, 3200, 0100)

//Marcacoes de Colunas
oPrint:Say(0230, 0070, "0100", oFontCN08)
oPrint:Say(0230, 0170, "0200", oFontCN08)
oPrint:Say(0230, 0270, "0300", oFontCN08)
oPrint:Say(0230, 0370, "0400", oFontCN08)
oPrint:Say(0230, 0470, "0500", oFontCN08)
oPrint:Say(0230, 0570, "0600", oFontCN08)
oPrint:Say(0230, 0670, "0700", oFontCN08)
oPrint:Say(0230, 0770, "0800", oFontCN08)
oPrint:Say(0230, 0870, "0900", oFontCN08)
oPrint:Say(0230, 0970, "1000", oFontCN08)
oPrint:Say(0230, 1070, "1100", oFontCN08)
oPrint:Say(0230, 1170, "1200", oFontCN08)
oPrint:Say(0230, 1270, "1300", oFontCN08)
oPrint:Say(0230, 1370, "1400", oFontCN08)
oPrint:Say(0230, 1470, "1500", oFontCN08)
oPrint:Say(0230, 1570, "1600", oFontCN08)
oPrint:Say(0230, 1670, "1700", oFontCN08)
oPrint:Say(0230, 1770, "1800", oFontCN08)
oPrint:Say(0230, 1870, "1900", oFontCN08)
oPrint:Say(0230, 1970, "2000", oFontCN08)
oPrint:Say(0230, 2070, "2100", oFontCN08)
oPrint:Say(0230, 2170, "2200", oFontCN08)
oPrint:Say(0230, 2270, "2300", oFontCN08)

oPrint:Line	(0280, 0100, 0300, 0100)
oPrint:Line	(0290, 0150, 0300, 0150)
oPrint:Line	(0280, 0200, 0300, 0200)
oPrint:Line	(0290, 0250, 0300, 0250)
oPrint:Line	(0280, 0300, 0300, 0300)
oPrint:Line	(0290, 0350, 0300, 0350)
oPrint:Line	(0280, 0400, 0300, 0400)
oPrint:Line	(0290, 0450, 0300, 0450)
oPrint:Line	(0280, 0500, 0300, 0500)
oPrint:Line	(0290, 0550, 0300, 0550)
oPrint:Line	(0280, 0600, 0300, 0600)
oPrint:Line	(0290, 0650, 0300, 0650)
oPrint:Line	(0280, 0700, 0300, 0700)
oPrint:Line	(0290, 0750, 0300, 0750)
oPrint:Line	(0280, 0800, 0300, 0800)
oPrint:Line	(0290, 0850, 0300, 0850)
oPrint:Line	(0280, 0900, 0300, 0900)
oPrint:Line	(0290, 0950, 0300, 0950)
oPrint:Line	(0280, 1000, 0300, 1000)
oPrint:Line	(0290, 1050, 0300, 1050)
oPrint:Line	(0280, 1100, 0300, 1100)
oPrint:Line	(0290, 1150, 0300, 1150)
oPrint:Line	(0280, 1200, 0300, 1200)
oPrint:Line	(0290, 1250, 0300, 1250)
oPrint:Line	(0280, 1300, 0300, 1300)
oPrint:Line	(0290, 1350, 0300, 1350)
oPrint:Line	(0280, 1400, 0300, 1400)
oPrint:Line	(0290, 1450, 0300, 1450)
oPrint:Line	(0280, 1500, 0300, 1500)
oPrint:Line	(0290, 1550, 0300, 1550)
oPrint:Line	(0280, 1600, 0300, 1600)
oPrint:Line	(0290, 1650, 0300, 1650)
oPrint:Line	(0280, 1700, 0300, 1700)
oPrint:Line	(0290, 1750, 0300, 1750)
oPrint:Line	(0280, 1800, 0300, 1800)
oPrint:Line	(0290, 1850, 0300, 1850)
oPrint:Line	(0280, 1900, 0300, 1900)
oPrint:Line	(0290, 1950, 0300, 1950)
oPrint:Line	(0280, 2000, 0300, 2000)
oPrint:Line	(0290, 2050, 0300, 2050)
oPrint:Line	(0280, 2100, 0300, 2100)
oPrint:Line	(0290, 2150, 0300, 2150)
oPrint:Line	(0280, 2200, 0300, 2200)
oPrint:Line	(0290, 2250, 0300, 2250)
oPrint:Line	(0280, 2300, 3200, 2300)

oPrint:Line	(0300, 0100, 0300, 2300)
*/


oPrint:StartPage() // Inicia uma nova página

oPrint:Box( 0100, 0100, 3000, 2300 )
oPrint:Say( 0180, 0300, STR0005, oFont26N ) //"Comprovante de Operação Não Fiscal" 
oPrint:Box( 0300, 0100, 3000, 2300 )

oPrint:StartPage() // Inicia uma nova página
oPrint:Say( 340, 0200, STR0007, oFontCN12N )					//"Tipo de Operação: "
oPrint:Say( 340, 0600, If(nCheck == 1,STR0008,STR0009), oFontCN12N )						 //"SANGRIA"###"SUPRIMENTO"
oPrint:Say( 420, 0200, STR0010, oFontCN12N )					//"Empresa: "
oPrint:Say( 420, 0600, SM0->M0_NOME, oFontCN12 )						
oPrint:Say( 420, 1000, STR0011, oFontCN12N )				 	//"CNPJ: "
oPrint:Say( 420, 1400, Transform(Alltrim(SM0->M0_CGC),PesqPict("SA1","A1_CGC")), oFontCN12 )				 
oPrint:Say( 500, 0200, STR0012, oFontCN12N )					//"Data: " //"Data: "
oPrint:Say( 500, 0600, DTOC(dDataBase), oFontCN12 )						
oPrint:Say( 500, 1000, STR0013, oFontCN12N )				 	//"Hora: " //"Hora: "
oPrint:Say( 500, 1400, Time(), oFontCN12 )				 
oPrint:Say( 580, 0200, STR0014, oFontCN12N )		    //"Caixa Origem: " //"Caixa Origem: "
oPrint:Say( 580, 0600, cCodOrigem, oFontCN12 )						
oPrint:Say( 580, 1000, STR0015, oFontCN12N )			//"Caixa Destino: " //"Caixa Destino: "
oPrint:Say( 580, 1400, cCodDestin, oFontCN12 )									

oPrint:Box( 0660, 0100, 3000, 2300 )			
oPrint:Say( 0670, 0200, STR0016, oFontCN12N )								 //"Nro. Docto " //"Tipo"
oPrint:Say( 0670, 1000, STR0017, oFontCN12N )		 //"Valor " //"Valor"
oPrint:Box( 0760, 0100, 3000, 2300 )		
                                            
	
nLin := 760     

If nDinheir > 0
	nLin += 80	
	oPrint:Say( nLin, 0200, STR0018, oFontCN12 )                                             //"DINHEIRO"
	oPrint:Say( nLin, 1000, Transform(nDinheir,PesqPict("SE1","E1_SALDO")), oFontCN12 )                                                              
EndIf
If nCheques > 0			     
	nLin += 80	
	oPrint:Say( nLin, 0200, STR0019, oFontCN12 )                                             //"CHEQUE"
	oPrint:Say( nLin, 1000, Transform(nCheques,PesqPict("SE1","E1_SALDO")), oFontCN12 )                                                              
EndIf	
If nCartao > 0			     
	nLin += 80	
	oPrint:Say( nLin, 0200, STR0020, oFontCN12 )                                             //"CARTAO CREDITO"
	oPrint:Say( nLin, 1000, Transform(nCartao,PesqPict("SE1","E1_SALDO")), oFontCN12 )                                                              
EndIf	
If nVlrDebi > 0			     
	nLin += 80	
	oPrint:Say( nLin, 0200, STR0021, oFontCN12 )                                             //"CARTAO DEBITO"
	oPrint:Say( nLin, 1000, Transform(nVlrDebi,PesqPict("SE1","E1_SALDO")), oFontCN12 )                                                              
EndIf	
If nFinanc > 0			     
	nLin += 80	
	oPrint:Say( nLin, 0200, STR0022, oFontCN12 )                                             //"FINANCIADO"
	oPrint:Say( nLin, 1000, Transform(nFinanc,PesqPict("SE1","E1_SALDO")), oFontCN12 )                                                              
EndIf	
If nConveni > 0			     
	nLin += 80	
	oPrint:Say( nLin, 0200, STR0023, oFontCN12 )                                             //"CONVENIO"
	oPrint:Say( nLin, 1000, Transform(nConveni,PesqPict("SE1","E1_SALDO")), oFontCN12 )                                                              
EndIf
If nVales > 0			     
	nLin += 80	
	oPrint:Say( nLin, 0200, STR0024, oFontCN12 )                                             //"VALES"
	oPrint:Say( nLin, 1000, Transform(nVales,PesqPict("SE1","E1_SALDO")), oFontCN12 )                                                              
EndIf
If nOutros > 0			     
	nLin += 80	
	oPrint:Say( nLin, 0200, STR0025, oFontCN12 )                                             //"OUTROS"
	oPrint:Say( nLin, 1000, Transform(nOutros,PesqPict("SE1","E1_SALDO")), oFontCN12 )                                                              
EndIf	

If nVlrTot > 0 
	nLin += 80	
	oPrint:Say( nLin, 0200, STR0026, oFontCN12N )                                             //"TOTAL........................."
	oPrint:Say( nLin, 1000, Transform(nVlrTot,PesqPict("SE1","E1_SALDO")), oFontCN12N )                                                              
Endif 
nLin+= 80	
oPrint:Line( nLin, 0100, nLin, 2300)							
nLin+= 80	
oPrint:Say( nLin, 0200, STR0027, oFontCN12N )						 //"Caixa: " //"Caixa: "
oPrint:Say( nLin, 0500, Alltrim(PswRet()[1][2]), oFontCN12 )		
	
oPrint:EndPage()   // Finaliza a página	       

Return
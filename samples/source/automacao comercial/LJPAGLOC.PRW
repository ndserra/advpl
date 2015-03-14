#INCLUDE "LJPAGCOL.ch"
#INCLUDE "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LJPAGCOL ºAutor  ³Vendas CLiente      º Data ³ 17/05/2011  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatorio de Comprovante de Pagamento                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³SIGALOJA                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LJPAGLOC()      

Local aArea    	:= GetArea() 	//Backup da area
Local cCCodcli	:= Paramixb[1]	// Cod do cliente
Local cCLojCli	:= Paramixb[2]	// Loj Cliente
Local aTitulo	:= Paramixb[3]	// Titulos
Local aPgtos	:= Paramixb[4]	// Pagamentos
Local cMsgComp	:= Paramixb[5]	// Mensagem de complemento
Local nTotComp	:= Paramixb[6]	// Total da complemento
Local cTotRec	:= Paramixb[7]	// tot do recebimento
Local aSE5Bxas	:= Paramixb[8] // Sex5 baixados
Local lImprime	:= .F.			// se Imprimi 			
Local nX		:= 0			// COntador     
Local nVlrTot	:= 0			// Valor total

Static _nLinha := 0				// Numero da linha
Static _nPage  := 0				// Numero da pagina

_nLinha   := 310
_nPage    := 1

For nX := 1 To Len(aTitulo)	
	If aTitulo[nX][1]		
		lImprime := .T. 				
		nVlrTot  += aTitulo[nX][10]
	Endif 		
Next nX 


If ! lImprime
	Aviso(STR0001, STR0002, {STR0003}) //"Atenção!"###"Não existem dados a listar."###"Ok"
	Return
EndIf

SetPrvt("oPrint")
oPrint:= TMSPrinter():New(STR0004)   //"Comprovante de Pagamento"
oPrint:SetPortrait()   

oFontCN08  := TFont():New("Courier New", 08, 08, .F., .F., , , , .F., .F.)
oFontCN08N := TFont():New("Courier New", 08, 08, .F., .T., , , , .F., .F.)
oFontCN11N := TFont():New("Courier New", 11, 11, .F., .T., , , , .F., .F.)
oFontCN12  := TFont():New("Courier New", 12, 12, .F., .F., , , , .F., .F.)
oFontCN12N := TFont():New("Courier New", 12, 12, .F., .T., , , , .F., .F.)

oFont26N := TFont():New("Tahoma", 26, 26, .F., .T., , , , .F., .F.)


MsgRun(STR0005,"",{|| CursorWait(), LjPagPrint(oPrint,cCCodcli,cCLojCli,aTitulo,aPgtos,nVlrTot),CursorArrow()}) //"Gerando Visualização, Aguarde..."

oPrint:Preview()  // Visualiza antes de imprimir

RestArea(aArea)

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄ´ÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³LjPagPrint³ Autor ³TOTVS                   ³ Data ³ 08/03/2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Imprime e gera a visualizacao do relatorio                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³SIGALOJA                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LjPagPrint(oPrint,cCCodcli,cCLojCli,aTitulo,aPgtos,nVlrTot)

Local nX	  := 0  // Contador
Local nLin	  := 0 	// Numero de linha

Default oPrint		:= Nil
Default cCCodcli    := ""
Default cCLojCli    := ""
Default aTitulo     := {}
Default aPgtos      := {}
Default nVlrTot     := 1


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

SA1->( DbSetOrder( 1 ) )
If SA1->( DbSeek( xFilial("SA1") + cCCodcli + cCLojCli  ) )
	oPrint:StartPage() // Inicia uma nova página

	oPrint:Box( 0100, 0100, 3000, 2300 )
	oPrint:Say( 0180, 0400, STR0006, oFont26N ) //"Comprovante de Recebimento"
	oPrint:Box( 0300, 0100, 3000, 2300 )

	oPrint:StartPage() // Inicia uma nova página
	oPrint:Say( 400, 0200, STR0007, oFontCN12N )					 //"Empresa: "
	oPrint:Say( 400, 0450, SM0->M0_NOME, oFontCN12 )						
	oPrint:Say( 400, 1000, DTOC(dDataBase)+ STR0008+ Time(), oFontCN12 )				 //", "
	oPrint:Say( 480, 0200, STR0009, oFontCN12N )					 //"Filial: "
	oPrint:Say( 480, 0450, SM0->M0_FILIAL, oFontCN12 )						
	oPrint:Say( 480, 1000, STR0010, oFontCN12N )								 //"Cond. Pagto: "
	oPrint:Say( 480, 1350, aPgtos[1][3], oFontCN12 )									
	
	oPrint:Box( 0560, 0100, 3000, 2300 )			
	
	oPrint:Say( 570, 0200, STR0011, oFontCN12N )								 //"Nro. Docto "
	oPrint:Say( 570, 1000, STR0012, oFontCN12N )		 //"Valor "

	oPrint:Box( 0660, 0100, 3000, 2300 )		
                                            
	
	nLin := 660     
	
	For nX := 1 To Len(aTitulo)
		
		If aTitulo[nX][1]			
			nLin += 80	
			oPrint:Say( nLin, 0200, aTitulo[nX][03], oFontCN12 )                                            
			oPrint:Say( nLin, 1000, Transform(aTitulo[nX][10],PesqPict("SE1","E1_SALDO")), oFontCN12 )                                                              
		                         
			If nLin > 3000
				oPrint:EndPage()   	  // Finaliza a página	
				oPrint:StartPage()   // Inicializa a página			
				nLin := 400
			EndIf	
	
		Endif 
	
	Next nX
	nLin+= 80
	oPrint:Say( nLin, 0200, STR0013+Alltrim(SA1->A1_NOME), oFontCN12N )						 //"Cliente: "
	nLin+= 80		
	oPrint:Say( nLin, 0200, STR0014, oFontCN12N )						 //"TOTAL........................."
	oPrint:Say( nLin, 1000, Transform(nVlrTot,PesqPict("SE1","E1_SALDO")), oFontCN12N )                                                              
	nLin+= 80		
	oPrint:Line( nLin, 0100, nLin, 2300)	
	nLin+= 80	
	oPrint:Say( nLin, 0200, STR0007, oFontCN12N )					 //"Empresa: "
	oPrint:Say( nLin, 0500, SM0->M0_NOME, oFontCN12 )						
	nLin+= 80
	oPrint:Say( nLin, 0200, STR0015, oFontCN12N )					 //"CNPJ: "
	oPrint:Say( nLin, 0500, Transform(Alltrim(SM0->M0_CGC),PesqPict("SA1","A1_CGC")), oFontCN12 )							
	nLin+= 80	
	oPrint:Say( nLin, 0200, STR0016, oFontCN12N )						 //"Cajero: "
	oPrint:Say( nLin, 0500, Alltrim(PswRet()[1][2]), oFontCN12 )		
		
	oPrint:EndPage()   // Finaliza a página	       
	
Endif 	
	
Return
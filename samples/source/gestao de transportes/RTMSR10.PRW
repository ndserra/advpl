#INCLUDE "RTMSR10.ch"
#Include "Protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RTMSR10  บ Autor ณ Antonio C Ferreira บ Data ณ  08/07/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Impressao da Cotacao.                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TMS - Transportadora                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

USER Function RTMSR10()
//-- Declaracao de Variaveis
Local cDesc1	:= STR0001		//-- "Este programa ira imprimir as Cotacoes.             "
Local cDesc2	:= STR0002		//-- "                                                    "
Local cDesc3	:= STR0003		//-- "Cotacao de Frete"
Local cPict		:= ""
Local titulo	:= STR0003		//-- "Cotacao de Frete"
Local nLin		:= 80

Local Cabec1	:= ""
Local Cabec2	:= ""
Local imprime	:= .T.
Local aOrd		:= {}

Private lEnd		:= .F.
Private lAbortPrint:= .F.
Private limite		:= 80
Private tamanho	:= "P"
Private nomeprog	:= "RTMSR10" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo		:= 18
Private aReturn	:= { STR0004, 1, STR0005, 2, 2, 1, "", 1}	 //-- "Zebrado"  "Administracao"
Private nLastKey	:= 0
Private cPerg		:= "RTMR10"
Private cbtxt		:= Space(10)
Private cbcont		:= 00
Private CONTFL		:= 01
Private m_pag		:= 01
Private wnrel		:= nomeprog

DbSelectArea("DT4")
DbSetOrder(1)

pergunte(cPerg,.F.)
//-- Monta a interface padrao com o usuario
If	Type('PARAMIXB')=='A'
	mv_par01 := mv_par02 := PARAMIXB[1]
	mv_par03 := mv_par04 := PARAMIXB[2]
	wnrel := SetPrint("DT4",NomeProg,,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)
Else
	wnrel := SetPrint("DT4",NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)
EndIf

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,"DT4")

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },STR0006)   // "Imprimindo o Romaneio de Carga."
Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  08/07/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem, aSx3Box, nCol, nSoma, nColunas, cDescricao

Local cFilOriDe  := mv_par01 
Local cFilOriAte := mv_par02
Local cNumCotDe  := mv_par03 
Local cNumCotAte := mv_par04

Local bImpSessao := {|cFrase| Replicate("-",(limite/2)-(Len(cFrase)/2)) + cFrase + Replicate("-",(limite+1)-((limite/2)-(Len(cFrase)/2)+Len(cFrase))) }

SA1->( DbSetOrder( 1 ) )  // A1_FILIAL+A1_COD+A1_LOJA

DUY->( DbSetOrder( 1 ) )  // DUY_FILIAL+DUY_GRPVEN 

SB1->( DbSetOrder( 1 ) )  // B1_FILIAL+B1_COD

DUE->( DbSetOrder( 1 ) )  // DUE_FILIAL+DUE_DDD+DUE_TEL



dbSelectArea("DT4")
dbSetOrder(1)  // DT4_FILIAL+DT4_FILORI+DT4_NUMCOT
MsSeek(xFilial("DT4")+cFilOriDe+cNumCotDe, .T.)

//SETREGUA -> Indica quantos registros serao processados para a regua
SetRegua(RecCount())

Do  While DT4->(!EOF()) .And. DT4->DT4_FILIAL == xFilial("DT4") .And.;
	DT4->DT4_FILORI <= cFilOriAte .And. DT4->DT4_NUMCOT <= cNumCotAte
	
	If DT4->DT4_FILORI < cFilOriDe .Or. DT4->DT4_NUMCOT < cNumCotDe
		DT4->(dbSkip())
		Loop
	EndIf
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Verifica o cancelamento pelo usuario...                             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	If  lAbortPrint
		@nLin,00 PSay STR0007  //-- "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	//-- Imprime os produtos da cotacao de frete
	DVF->(DbSetOrder(1))
	DVF->(MsSeek(xFilial('DVF') + DT4->DT4_FILORI + DT4->DT4_NUMCOT))
	While DVF->( ! Eof() .And. DVF->DVF_FILIAL + DVF->DVF_FILORI + DVF->DVF_NUMCOT == xFilial('DVF') + DT4->DT4_FILORI + DT4->DT4_NUMCOT)
		//-- Impressao do cabecalho do relatorio
		If  nLin > 55
			nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			++nLin
		Endif
		SM0->(MsSeek(cEmpAnt+DT4->DT4_FILORI, .T.))
		//
		//**** DADOS DA COTACAO ***
		//
		@nLin		,00 PSay STR0008 + DT4_FILORI + " - " + Alltrim(SM0->M0_CIDCOB) + " - " + SM0->M0_ESTCOB   //-- "Filial.......: "
		@nLin++	,46 PSay STR0032 + UsrRetName(DT4_USER)
	
		@nLin		,00 PSay STR0009 + DT4_NUMCOT  			//-- "Numero.......: "
		@nLin		,24 PSay STR0010 + dtoc(DT4_DATCOT)		//-- "Data Cotacao.: "
		@nLin++	,54 PSay STR0011 + dtoc(DT4_PRZVAL)		//-- "Data Validade: "
		//
		//**** DADOS DO CLIENTE ***
		//
		++nLin
		@nLin++	,00 PSay Eval(bImpSessao, STR0027)		//-- " C L I E N T E "
		++nLin
		DUE->( MsSeek(xFilial("DUE") + DT4->(DT4_DDD+DT4_TEL)) )
		@nLin		,00 PSay STR0012 + "(" + DT4_DDD + ") " + DT4_TEL   //-- "Telefone.....: "
		@nLin++	,40 PSay STR0013 + DUE->DUE_CONTAT		//-- "Contato...: "
		/* REMETENTE */
		++nLin                                   
		SA1->( DbSeek( xFilial("SA1") + DT4->( DT4_CLIREM + DT4_LOJREM ) ) )
		@nLin		,00 PSay STR0014 + Transform(SA1->A1_CGC, PesqPict("SA1","A1_CGC"))   //-- "Remetente....: "
		@nLin++	,40 PSay SA1->A1_NOME
	    /* DESTINATARIO */
		SA1->( DbSeek( xFilial("SA1") + DT4->( DT4_CLIDES + DT4_LOJDES ) ) )
		@nLin		,00 PSay STR0015 + Transform(SA1->A1_CGC, PesqPict("SA1","A1_CGC"))		//-- "Destinatario.: "
		@nLin++	,40 PSay SA1->A1_NOME
	    /* DEVEDOR */
		SA1->( DbSeek( xFilial("SA1") + DT4->( DT4_CLIDEV + DT4_LOJDEV ) ) )
		@nLin		,00 PSay STR0016 + Transform(SA1->A1_CGC, PesqPict("SA1","A1_CGC"))   //-- "Devedor......: "
		@nLin++	,40 PSay SA1->A1_NOME
		//	
		//**** CARGA ***
		//
		++nLin
		@nLin++,00 PSay Eval(bImpSessao, STR0028)			//-- " C A R G A "
		++nLin
	
		DUY->( MsSeek(xFilial("DUY")+DT4->DT4_CDRDES) )
		@nLin+=1	,00 PSay STR0017 + DUY->( DUY_DESCRI + "   " + DUY_EST )  	//-- "Destino.......: "

		@nLin+=1	,00 PSay STR0020 				+ DVF->DVF_CODPRO + Posicione('SB1',1,xFilial('SB1')+DVF->DVF_CODPRO,'B1_DESC')	//-- "Produto.......: "
		@nLin+=1	,00 PSay STR0022 				+ Tabela('MG',DVF->DVF_CODEMB,.F.)																//-- "Embalagem.....: "
		@nLin		,50 PSay STR0033				+ Transform(DVF->DVF_QTDUNI,PesqPict('DVF','DVF_QTDUNI'	))
		@nLin+=1	,00 PSay STR0021 				+ Transform(DVF->DVF_QTDVOL,PesqPict('DVF','DVF_QTDVOL'	))								//-- "Volumes.......: "
		@nLin		,50 PSay STR0018				+ Transform(DVF->DVF_PESO  ,PesqPict('DVF','DVF_PESO'		))						 		//-- "Peso Real.....: "
		@nLin+=1	,00 PSay STR0019				+ Transform(DVF->DVF_PESOM3,PesqPict('DVF','DVF_PESOM3'	))								//-- "Peso Cubado...: "
		@nLin		,50 PSay STR0023				+ Transform(DVF->DVF_VALMER,PesqPict('DVF','DVF_VALMER'	))								//-- "Valor Mercad..: "
		//	
		//**** FRETE COMBINADO *** 
		//	
		++nLin
		@nLin++,00 PSay Eval(bImpSessao, STR0029)			//-- " F R E T E   C O M B I N A D O " 
		++nLin
	
		nCol     := 00   // Variavel da coluna. Para funcionar os calculos tem que comecar sempre do Zero.
		nSoma    := 40   // Numero para pular as colunas.
		nColunas := 02   // Numero de Colunas.

		DT8->(DbSetOrder(1))			// DT8_FILIAL+DT8_FILORI+DT8_NUMCOT+DT8_SERVIC+DT8_CODPAS
		DT8->(MsSeek(xFilial('DT8') + DT4->DT4_FILORI + DT4->DT4_NUMCOT + DVF->DVF_CODPRO))
		While DT8->( ! Eof() .And. DT8->DT8_FILIAL + DT8->DT8_FILORI + DT8->DT8_NUMCOT + DT8->DT8_CODPRO == xFilial('DT8') + DT4->DT4_FILORI + DT4->DT4_NUMCOT + DVF->DVF_CODPRO)
			DT3->(DbSetOrder(1))		// DT3_FILIAL+DT3_CODPAS
			DT3->(MsSeek(xFilial('DT3') + DT8->DT8_CODPAS))

			cDescricao	:= Iif(DT8->DT8_CODPAS=='TF',PadR(STR0031,20),DT3->DT3_DESCRI)		//'TOTAL DE FRETE'
		
			@ nLin, nCol PSay cDescricao+': '+TransForm(DT8->DT8_VALTOT,PesqPict('DT8','DT8_VALPAS'))
		
			nCol := ((nCol + nSoma) % (nColunas*nSoma))  // Zera pelo modulo do numero. Exemplo 80 % 80 == 0.
		
			nLin += If(nCol==0, 1, 0)
		
			DT8->(DbSkip())
		EndDo
	
	   nLin += If(nCol==0, 0, 1)

		//**** OBSERVACOES ***

		++nLin
		@nLin++,00 PSay Eval(bImpSessao, STR0030)		//-- " O B S E R V A C O E S "
		++nLin
	
		cDescricao := MsMM(DT4->DT4_CODOBS,180)
		Do  While ( Len( cDescricao ) > 0 )
			@nLin++, 10 PSay AllTrim(Substr( cDescricao, 1, 60 ))
			cDescricao := Substr( cDescricao, 61 )         
		EndDo		

		++nLin
		@nLin++,00 PSay Replicate("-", limite)
	
		nLin := 80

		DVF->(DbSkip())
	EndDo	
	dbSelectArea("DT4")
	dbSkip() // Avanca o ponteiro do registro no arquivo
EndDo

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If  (aReturn[5]==1)
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return Nil
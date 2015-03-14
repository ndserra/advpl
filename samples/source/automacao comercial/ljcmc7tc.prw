#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLJCMC7TC  บAutor  ณCesar Valadao       บ Data ณ  12/02/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPonto de entrada para utilizacao de CMC7 via teclado        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณprotheus                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function LJCMC7TC
Local oDlgGetCh						// Objeto da tela
Local oCMC7							// Objeto Get
Local cCMC7 	:= Space(40)		// Conteudo capturado da leitura do documento
Local aRet		:= {}				// Retorno da funcao

DEFINE MSDIALOG oDlgGetCh FROM 12, 13 TO 100,390 TITLE "Dados do Cheque" PIXEL

	@ 2,5 TO 41,185 OF oDlgGetCh PIXEL
	
	@ 10,10 SAY "Insira o cheque na leitora de CMC7"		SIZE 170,9 PIXEL
	@ 23,10 MSGET oCMC7 VAR cCMC7 OF oDlgGetCh Picture "@!"	SIZE 170,9 PIXEL VALID (oDlgGetCh:End(), .T.)
	
	DEFINE SBUTTON FROM 200,20 TYPE 1 ACTION oDlgGetCh:End() ENABLE OF oDlgGetCh PIXEL

ACTIVATE MSDIALOG oDlgGetCh CENTERED

aRet := { 	Substr(cCMC7, 2,3),;	// (1) - Banco
			Substr(cCMC7,14,6),;	// (2) - Cheque	
			Substr(cCMC7, 5,4),;	// (3) - Agencia
			Substr(cCMC7,24,9),;	// (4) - Conta
			Substr(cCMC7,11,3) }	// (5) - Compensacao

Return aRet
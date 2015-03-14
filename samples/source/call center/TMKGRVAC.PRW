#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TMKGRVAC  ºAutor  ³Microsiga           º Data ³  07/13/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gravacao do Suspect (ACH) e relacionamento de contatos      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CALL CENTER                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function TMKGRVAC(aMailing)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracoes                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cTel 		:= ""                                        
Local cCep 		:= ""
Local cFax 		:= ""
Local cCodCargo := CRIAVAR("UM_CARGO",.T.)
Local cCodigo   := CRIAVAR("ACH_CODIGO",.T.)
Local cCodCont  := CRIAVAR("U5_CODCONT",.T.)
Local nCont		:= 0
Local cLojaPad  := GetMv("MV_LOJAPAD")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Grava informacoes do Mailing no ACH	                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ProcRegua(Len(aMailing))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicia-se a partir do segundo registro pois o primeiro  ³
//³e a descricao das colunas							   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nCont := 2 TO Len(aMailing) 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Executa as validacoes para gravacao	pela razao social   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectarea("ACH") //Verifica se existe esse registro cadastrado na Tabela de Suspect
	DbSetOrder(3)
	If DbSeek(xFilial("ACH") + aMailing[nCont][01])
		Loop
	EndIf

	DbSelectarea("SUS")  //Verifica se existe esse registro cadastrado na Tabela de Prospect
	DbSetOrder(2)
	If DbSeek(xFilial("SUS") + aMailing[nCont][01])
		Loop
	EndIf
	
	DbSelectarea("SA1") //Verifica se existe esse registro cadastrado na Tabela de Clientes
	DbSetOrder(2)
	If DbSeek(xFilial("SA1") + aMailing[nCont][01])
		Loop
	EndIf
	
	cCep 	:= STRTRAN(Alltrim(aMailing[nCont][05]),"-")
	cTel 	:= STRTRAN(Alltrim(aMailing[nCont][08]),"-")
	cFax 	:= STRTRAN(Alltrim(aMailing[nCont][09]),"-")
	
	cTel	:= SgLimpaTel(cTel)

	Begin Transaction
		
		If Empty(cCodigo) 
			cCodigo := GETSXENUM("ACH","ACH_CODIGO")
		Endif	
		
		DbSelectarea("ACH")
		Reclock("ACH",.T.)
		Replace ACH_FILIAL	With xFilial("ACH")
		Replace ACH_CODIGO	With cCodigo
		Replace ACH_LOJA	With cLojaPad 
		Replace ACH_RAZAO	With aMailing[nCont][01]
		Replace ACH_NFANT   With aMailing[nCont][02]
		Replace ACH_TIPO	With "1" // Tipo (DEFAULT "F"-Consumidor Final)
		Replace ACH_END     With aMailing[nCont][03]
		Replace ACH_CIDADE  With aMailing[nCont][04]
		Replace ACH_CEP     With cCep
		Replace ACH_EST 	With aMailing[nCont][06]
		Replace ACH_TEL	    With cTel
		Replace ACH_DDD	    With aMailing[nCont][07]
		Replace ACH_FAX     With cFax
		Replace ACH_EMAIL   With aMailing[nCont][10]
		Replace ACH_URL	    With aMailing[nCont][11]
		Replace ACH_CGC     With aMailing[nCont][12]
		DbCommit()
		MsUnlock()
		
		ConfirmSx8()
	
		IncProc()
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Gravacao do Cargo do Contato            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(AllTrim(aMailing[nCont][14]))
		
			DbSelectarea("SUM")
			DbSetOrder(2)//UM_DESC
			If DbSeek(xFilial("SUM") + AllTrim(aMailing[nCont][14])) 
				cCodCargo := SUM->UM_CARGO
			Else
				If !Empty(AllTrim(aMailing[nCont][13]))
					If Empty(cCodCargo)
						cCodCargo := GETSXENUM("SUM","UM_CARGO")
					Endif
						 
					Reclock("SUM",.T.)
					Replace UM_FILIAL  With xFILIAL("SUM")
					Replace UM_CARGO   With cCodCargo
					Replace UM_DESC    With Alltrim(aMailing[nCont][14])
					DbCommit()
					MsUnlock()
					ConfirmSx8()
				EndIf
			EndIf
		Endif
			
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Gravacao do Contato                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If  !Empty(AllTrim(aMailing[nCont][13]))
		
			DbSelectarea("SU5")
			DbSetOrder(3)//U5_CONTAT
			If  !DbSeek(xFilial("SU5") + aMailing[nCont][13]) 
			
				If Empty(cCodCont)
					cCodCont := GETSXENUM("SU5","U5_CODCONT")
			    EndIf
			    
				Reclock("SU5",.T.)
				Replace U5_FILIAL	  With  xFilial("SU5")
				Replace U5_CODCONT    With  cCodCont
				Replace U5_CONTAT     With  aMailing[nCont][13]
				Replace U5_FUNCAO     With  cCodCargo
				Replace U5_DDD        With  Alltrim(aMailing[nCont][07])
				Replace U5_FCOM1      With  cTel 
				Replace U5_FAX        With  cFax 
				Replace U5_STATUS     With  "1" // Desatualizado
			    Replace U5_END     	  With aMailing[nCont][03]
				Replace U5_MUN        With aMailing[nCont][04]
				Replace U5_CEP        With cCep
				Replace U5_EST        With aMailing[nCont][06]
		
				
				DbCommit()
				MsUnlock()
				ConfirmSx8()
			
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Grava relacionamento no AC8³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
				dbSelectArea("AC8")
				RecLock("AC8",.T.)
				Replace AC8->AC8_FILIAL With xFilial("AC8")
				Replace AC8->AC8_FILENT With xFilial("ACH")
				Replace AC8->AC8_ENTIDA With "ACH"
				Replace AC8->AC8_CODENT With cCodigo + cLojaPad
				Replace AC8->AC8_CODCON With cCodCont
			
				dbCommit()
				MsUnLock()
			
			Endif
		EndIf	
	    
    End Transaction

	cCodCargo := ""
	cCodigo   := ""
	cCodCont  := ""

Next nCont

Return(.T.)

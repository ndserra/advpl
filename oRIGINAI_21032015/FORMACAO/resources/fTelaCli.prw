#Include 'Protheus.ch'
#Include 'TBICONN.ch'

User Function fTelaCli()

Local oBtnInc := oButton1:= oButton2:= Nil
Local oFont1 := TFont():New("Arial Narrow",,018,,.F.,,,,,.F.,.F.)
Local oFontOb := TFont():New("Arial Narrow",,018,,.T.,,,,,.F.,.F.)

Local lCon        := .F.

Private oCodigo,oGNome,oLoja,oSay1,oSay2,oSay4,oSLoja
Private ogCodigo,oGet1,oGet3                         
Private oGroup1, oGroup2                             
Private oRadMenu1                                    
Private cCodigo   := ""
Private cLoja     := ""
Private cNome     := ""
Private cFantasia := ""
Private cNPJ      := ""
Private nBloq     := 1   




Static oDlg

If Select("SX2") = 0
	PREPARE ENVIRONMENT EMPRESA '99' FILIAL '01' TABLES 'SA1' MODULO "FAT"
	lCon := .T.
EndIf	

cCodigo   := CriaVar("A1_COD"   ,.F.)
cLoja     := CriaVar("A1_LOJA"  ,.F.)
cNome     := CriaVar("A1_NOME"  ,.F.)
cFantasia := CriaVar("A1_NREDUZ",.F.)
cNPJ      := CriaVar("A1_CGC"   ,.F.)


  DEFINE MSDIALOG oDlg TITLE "Cliente" FROM 000, 000  TO 250, 500 COLORS 0, 16777215 PIXEL

    @ 000, 001 GROUP oGroup1 TO 091, 247 OF oDlg COLOR 0, 16777215 PIXEL
	    
	    @ 007, 005 SAY   oCodigo PROMPT "Codigo:" SIZE 032, 014 OF oGroup1 FONT oFontOb COLORS 255, 16777215 PIXEL
	    @ 007, 031 MSGET ogCodigo VAR cCodigo     Valid( vDados() ) SIZE 038, 012 OF oGroup1 COLORS 0, 16777215 FONT oFont1 F3 "SA1" PIXEL
	    
	    @ 007, 073 SAY   oSLoja PROMPT "Loja:" SIZE 017, 010 OF oGroup1 FONT oFontOb COLORS 255, 16777215 PIXEL
	    @ 007, 091 MSGET oLoja  VAR cLoja      SIZE 020, 012 OF oGroup1 COLORS 0, 16777215 FONT oFont1    PIXEL
	   
	    @ 008, 121 SAY   oSay1 PROMPT "Nome:" SIZE 020, 010 OF oGroup1 FONT oFont1 COLORS 0, 16777215 PIXEL
	    @ 007, 143 MSGET oGNome VAR cNome    SIZE 098, 012 OF oGroup1 COLORS 0, 16777215 FONT oFont1 PIXEL
	    
	    @ 029, 005 SAY oSay2 PROMPT "Fantasia:" SIZE 032, 010 OF oGroup1 FONT oFont1 COLORS 0, 16777215 PIXEL
	    @ 027, 031 MSGET oGet1 VAR   cFantasia        SIZE 098, 012 OF oGroup1 COLORS 0, 16777215 FONT oFont1 PIXEL
	    
	    @ 046, 005 SAY oSay4 PROMPT "CNPJ:" SIZE 032, 010 OF oGroup1 FONT oFont1 COLORS 0, 16777215 PIXEL
	    @ 046, 031 MSGET oGet3 VAR cNPJ    SIZE 098, 010 OF oGroup1 COLORS 0, 16777215 FONT oFont1 PIXEL
	    
	    @ 026, 139 GROUP oGroup2 TO 066, 201 PROMPT "Bloqueado" OF oDlg COLOR 255, 16777215 PIXEL
	    @ 035, 150 RADIO oRadMenu1 VAR nBloq ITEMS "SIM","NAO" SIZE 037, 019 OF oGroup2 COLOR 0, 16777215 PIXEL

    @ 096, 012 BUTTON oBtnInc PROMPT "Incluir"  Action( fIncluir(.T.) ) SIZE 045, 020 OF oDlg FONT oFont1 PIXEL
    @ 096, 092 BUTTON oButton1 PROMPT "Alterar" Action(fIncluir(.F.) ) SIZE 045, 020 OF oDlg FONT oFont1 PIXEL
    @ 097, 172 BUTTON oButton2 PROMPT "Excluir" Action(fExcluir() ) SIZE 045, 020 OF oDlg FONT oFont1 PIXEL

  ACTIVATE MSDIALOG oDlg CENTERED
     
If lCon
	RESET ENVIRONMENT
EndIf	   
                                   
Return
//-++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Static Function fIncluir(lInc)

dbSelectArea("SA1")
SA1->(dbSetOrder(1)) // Filial + Cod + Loja

If SA1->(dbSeek(xFilial("SA1") + cCodigo + cLoja))
	If lInc
		MsgInfo("Cliente " + cCodigo + "/" + cLoja + " já cadastrado: " + SA1->A1_NOME)
	Return(NIL)

	Else
		RecLock("SA1",.F.) //Alterar
	Endif
		
	Else
		RecLock("SA1",.T.) //Incluir
	Endif
	 
	 SA1->A1_FILIAL := xFilial("SA1")
	 SA1->A1_COD    := cCodigo
	 SA1->A1_LOJA   := cLoja
	 SA1->A1_NOME   := cNome
	 SA1->A1_NREDUZ := cFantasia
	 SA1->A1_CGC    := cNPJ
	 SA1->A1_MSBLQL := cValtoChar(nBloq)
	 
	 MsUnLock()
	
	

fLimpa()

Return( NIL ) 
//**************************************************************



Static Function fLimpa()

cCodigo   := CriaVar("A1_COD"   ,.F.)
cLoja     := CriaVar("A1_LOJA"  ,.F.)
cNome     := CriaVar("A1_NOME"  ,.F.)
cFantasia := CriaVar("A1_NREDUZ",.F.)
cNPJ      := CriaVar("A1_CGC"   ,.F.)

ogCodigo:Refresh() 
oLoja:Refresh()
oGNome:Refresh()
oGet1:Refresh()
oGet3:Refresh()


Return( NIL )
//-++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Static Function vDados()

dbSelectArea("SA1")
SA1->(dbSetOrder(1)) // Filial + Cod + Loja

If  SA1->( dbSeek(xFilial("SA1") + cCodigo + cLoja ) )
	 cCodigo           := SA1->A1_COD    
	 cLoja             := SA1->A1_LOJA   
	 cNome             := SA1->A1_NOME   
	 cFantasia         := SA1->A1_NREDUZ 
	 cNPJ              := SA1->A1_CGC    
	 nBloq             := IIf(SA1->A1_MSBLQL =="1",1,2) 
                                         
EndIf

	ogCodigo:Refresh() 
	oLoja:Refresh()
	oGNome:Refresh()
	oGet1:Refresh()
	oGet3:Refresh()


Return(.T.)
//-++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Static Function fExcluir()

	dbSelectArea("SA1")
	SA1->(dbSetOrder(1))

	If SA1->(dbSeek(xFilial("SA1") + cCodigo + cLoja))	
		If msgYesNo("Deseja excluir o Cliente " + cCodigo + "/" + cLoja + " - " + SA1->A1_NOME )
			
			RecLock("SA1",.F.) //Alterar
		
				SA1->( dbdelete() )
	
			SA1->(MsUnlock())
			
			fLimpa()
		EndIf
	EndIf
	
	
		
Return( NIL )


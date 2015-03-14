#Include "PROTHEUS.CH"
#Include 'TBICONN.ch'
//--------------------------------------------------------------
/*/{Protheus.doc} MyFunction
Description                                                     
                                                                
@param xParam Parameter Description                             
@return xRet Return Description                                 
@author  -                                               
@since 07/03/2015                                                   
/*/                                                             
//--------------------------------------------------------------
User Function xTelinha()                        
	Local btAlterar := btExcluir := btIncluir := NIL 
	Local cCliente, oCnpj, oFantasia, oLoja, oNome
	Local oFont1 := TFont():New("MS Sans Serif",,016,,.F.,,,,,.F.,.F.)
	Local oFont1Ob := TFont():New("Arial Narrow",,018,,.T.,,,,,.F.,.F.)
	Local ogCnpj, ogCodigo, ogFantasia, ogLoja, ogNome
	Local ogRadio, ngRadio := 1
	Local oGroup1, oGroup2
	
	Private cgCodigo   := ""
	Private cgLoja     := ""
	Private cgNome     := ""
	Private cgFantazia := ""
	Private cgCnpj     := ""
	Private cgBloq     := 1   
	
	Static oDlg

	If Select("SX2") = 0
		PREPARE ENVIRONMENT EMPRESA '99' FILIAL '01' TABLES 'SA1' MODULO 'FAT'
		lCon := .T.
	EndIf
	
	cgCodigo 		:= CriaVar("A1_COD",.F.)
	cgLoja 		:= CriarVar("A1_LOJA",.F.) 
	cgNome 		:= CriarVar("A1_NOME",.F.)
	cgFantasia 	:= CriarVar("A1_NREDUZ",.F.)
	cgCnpj 		:= CriaVar("A1_CGC",.F.)


  DEFINE MSDIALOG oDlg TITLE "Cliente" FROM 000, 000  TO 250, 600 COLORS 0, 16777215 PIXEL

	@ 005, 009 GROUP oGroup2 TO 103, 290 PROMPT "Clientes" OF oDlg COLOR 128, 16777215 PIXEL
 
		@ 023, 022 SAY cCliente PROMPT "Cliente:" SIZE 025, 007 OF oDlg FONT oFont1Ob COLORS 128, 16777215 PIXEL
		@ 023, 048 MSGET ogCodigo VAR cgCodigo SIZE 048, 010 OF oDlg COLORS 0, 16777215 F3 "SA1" PIXEL
		
		@ 023, 107 SAY oLoja PROMPT "Loja:" SIZE 017, 008 OF oDlg FONT oFont1Ob COLORS 128, 16777215 PIXEL
		@ 023, 127 MSGET ogLoja VAR cgLoja SIZE 052, 010 OF oDlg COLORS 0, 16777215 PIXEL
		
		@ 045, 025 SAY oNome PROMPT "Nome:" SIZE 017, 008 OF oDlg FONT oFont1Ob COLORS 128, 16777215 PIXEL
		@ 044, 048 MSGET ogNome VAR cgNome SIZE 141, 010 OF oDlg COLORS 0, 16777215 PIXEL
		
		
		@ 084, 017 SAY oCnpj PROMPT "Cnpj:" SIZE 027, 008 OF oDlg FONT oFont1Ob COLORS 128, 16777215 PIXEL
		@ 082, 048 MSGET ogCnpj VAR cgCnpj SIZE 141, 010 OF oDlg COLORS 0, 16777215 PIXEL
		
		@ 065, 018 SAY oFantasia PROMPT "Fantasia:" SIZE 027, 008 OF oDlg FONT oFont1Ob COLORS 128, 16777215 PIXEL
		@ 063, 049 MSGET ogFantasia VAR cgFantasia SIZE 141, 010 OF oDlg COLORS 0, 16777215 PIXEL
	
	@ 040, 207 GROUP oGroup1 TO 077, 275 PROMPT "Bloqueado" OF oDlg COLOR 128, 16777215 PIXEL
	@ 052, 217 RADIO ogRadio VAR cgBloq ITEMS "SIM","NÃO" SIZE 028, 018 OF oDlg COLOR 0, 16777215 PIXEL
    
	@ 106, 057 BUTTON btIncluir PROMPT "Incluir" Action( fIncluir() )SIZE 041, 016 OF oDlg PIXEL
	@ 105, 130 BUTTON btAlterar PROMPT "Alterar" SIZE 041, 016 OF oDlg PIXEL
	@ 106, 204 BUTTON btExcluir PROMPT "Excluir" SIZE 041, 016 OF oDlg PIXEL
    

  ACTIVATE MSDIALOG oDlg CENTERED
  
  	If lCon
		RESET ENVIRONMENT
	EndIf	

Return ( NIL )

// -----------------------------------------------------------------------

Static Function fIncluir()

	
	dbSelectArea("SA1")
	SA1->(dbSrtOrder(1)) // Filial + Cod + Loja
	
	if SA1->( dbSeek( xFilial("SA1") +cgCodigo + cgLoja ) )
	
		RecLock("SA1",.T.) // Incluir
	
			SA1->A1_FILIAL	:= xFilial("SA1")
			SA1->A1_COD		:= cgCodigo
			SA1->A1_LOJA		:= cgLoja
			SA1->A1_NOME		:= cgNome
			SA1->A1_NREDUZ	:= cgFantasia
			SA1->A1_CGC		:= cgCnpj
			SA1->A1_MSBLQL	:= nBloq
		
		MsUnlock()
	
	Else
		MsgInfo("Cliente já cadastrado " + SA1->A1_NOME )
	EndIf
	
	MsgInfo("Cliente já cadastrado " + SA1->A1_NOME )
	
Return ( NIL )
#INCLUDE "TOTVS.CH"

User Function TELA()                        

Local oBsair, oBConf
Local oGCod, oGLoja, oGNome,oGroup1, oSCod, oSNOME, oDlg
Local cGCod  := Space(6)
Local cGLoja := Space(2)
Local cGNome := Space(30)

  DEFINE MSDIALOG oDlg TITLE "Aula Advpl" FROM 000, 000  TO 170, 480 COLORS 0, 16777215 PIXEL      
  
    @ 003, 004 GROUP oGroup1 TO 054, 239 OF oDlg COLOR 0, 16777215 PIXEL        
    @ 013, 008 SAY oSCod PROMPT "Codigo:" SIZE 027, 010 OF oDlg COLORS 0, 16777215 PIXEL
	 @ 013, 037 MSGET oGCod  VAR cGCod    SIZE 040, 010 OF oDlg  Valid(fCod()) COLORS 0, 16777215 PIXEL
    @ 013, 082 MSGET oGLoja VAR cGLoja    SIZE 020, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 013, 108 SAY oSNOME PROMPT "Nome:"  SIZE 025, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 013, 130 MSGET oGNome VAR cGNome    SIZE 080, 010 OF oDlg COLORS 0, 16777215 PIXEL

    @ 056, 131 BUTTON oBsair PROMPT "SAIR"     SIZE 049, 019 OF oDlg ACTION oDlg:End() PIXEL
    @ 055, 186 BUTTON oBConf PROMPT "CONFIRMA" SIZE 049, 019 OF oDlg ACTION fConfirme() PIXEL

  ACTIVATE MSDIALOG oDlg CENTERED

Return( NIL )
//**************************************
Static Function fConfirme()             


MsgInfo("Confirmei")



Return( NIL )
//**************************************
Static Function fCod()

Local lRet := .T.
                 

Return( lRet )
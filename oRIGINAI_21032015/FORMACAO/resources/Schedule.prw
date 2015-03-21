#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"

User Function Schedule()

 If Select("SX2") == 0
  Prepare Environment Empresa '99' Filial '01' Tables 'SX5', 'SX2', 'SX6', 'SX3'
 EndIf                                                                          
 
fEnvEmail()

RESET ENVIRONMENT 

Return( NIL )
//************************************************************************************************************************************************************
Static Function fEnvEmail()
 Local _cHTML := ""
 
 _cHTML:= '<HTML><HEAD><TITLE></TITLE>'
 _cHTML+= '<META http-equiv=Content-Type content="text/html; charset=windows-1252">'
 _cHTML+= '<META content="MSHTML 6.00.6000.16735" name=GENERATOR></HEAD>'
 _cHTML+= '<BODY>'
 _cHTML+= '<H1><FONT color=#ff0000>Totvs CTT </FONT></H1>'
 _cHTML+= '<TABLE cellSpacing=0 cellPadding=0 width="100%" bgColor=#afeeee background="" '
 _cHTML+= 'border=1>'
 _cHTML+= '  <TBODY>'
 _cHTML+= '  <TR>'
 _cHTML+= '    <TD>Voce está participando</TD>'
  _cHTML+= '  <TR>'
 _cHTML+= '    <TD> do curso configurador </TD>'
  _cHTML+= '  <TR>'
 _cHTML+= '    <TD> Teste realizado com sucesso !!! </TD>'
 _cHTML+= '    <TD>789</TD></TR></TBODY></TABLE>'
 _cHTML+= '<P>&nbsp;</P>'
 _cHTML+= '<P><A href="http://www.totvs.com.br">Clique nesse '
 _cHTML+= 'link!!!</A></P></BODY></HTML>'
 
 U_EnvMail("TESTE SHEDULE", _cHTML, "herold.leite@totvs.com.br","","", Nil, Nil)
 
 
Return( NIL )
//*************************************************************************************************************************************************************************************************** 
User Function EnvMail(_cSubject, _cBody, _cMailTo, _cCC, _cAnexo, _cConta, _cSenha)
Local _cMailS   := GetMv("MV_RELSERV")
Local _cAccount   := IIf(_cConta=Nil,GetMV("MV_RELACNT"),_cConta)
Local _cPass   := IIf(_cSenha=Nil,GetMV("MV_RELPSW"),_cSenha)
Local _cSenha2   := GetMV("MV_RELPSW")
Local _cUsuario2  := GetMV("MV_RELACNT")
Local lAuth     := GetMv("MV_RELAUTH",,.F.)

ConOut("Enviando e-mail - " + _cSubject + " - para " + _cMailTo)

Connect Smtp Server _cMailS Account _cAccount Password _cPass RESULT lResult

If lAuth  // Autenticacao da conta de e-mail

 lResult := MailAuth(_cUsuario2, _cSenha2)
 
 If !lResult
 
  ConOut("Nao foi possivel autenticar a conta - " + _cUsuario2)  
  Return()                                                     
  
 EndIf
 
EndIf 

lResult := .F.

While ! lResult

 If !Empty(_cAnexo) 
  Send Mail From _cAccount To _cMailTo CC _cCC Subject _cSubject Body _cBody ATTACHMENT _cAnexo RESULT lResult
 Else
  Send Mail From _cAccount To _cMailTo CC _cCC Subject _cSubject Body _cBody RESULT lResult
 Endif
 
EndDo             

Return( NIL )
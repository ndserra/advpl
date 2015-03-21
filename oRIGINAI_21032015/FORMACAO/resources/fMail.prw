#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"

User Function fMail()

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
  _cHTML+= '<BODY>'
 _cHTML+= '<H1><FONT color=#ff0000> </FONT></H1>'

 dbSelectArea("SB1")

 _cHTML+= "<h1> Produto: "  + SB1->B1_COD + " " +  SB1->B1_DESC +  "</h1>" 
   
 _cHTML+= ' <h2 style="color:red"> Esta Bloqueado !!! </h2> '
  
 _cHTML+= '</BODY></HTML>'
 
 U_EnvMail("Cadatro de Produto", _cHTML, "herold.leite@totvs.com.br","","", Nil, Nil)
 
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


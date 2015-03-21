#Include 'Protheus.ch'

User Function MT010INC()
Local aAreaSB1 := SB1->( GetArea() )

If msgYesNo("Deseja cadastrar o complemento do Produto")
	
	dbSelectArea("SB5")
	SB5->(dbSetOrder(1))
	If SB5->(MsSeek(xFilial("SB5") + SB1->B1_COD ))
		RecLock("SB5",.F.)
	Else
		RecLock("SB5",.T.)
	EndIf
		
			SB5->B5_FILIAL := xFilial("SB5")
			SB5->B5_COD    := SB1->B1_COD
			SB5->B5_CEME    := SB1->B1_DESC
			
		SB5->(MsUnLock())
		
		fMail()
				
EndIf	

RestArea(aAreaSB1)

Return()

//****************************************************************************

Static Function fMail()

_cHTML:= '<HTML><HEAD><TITLE></TITLE>'
_cHTML+= '<BODY>'
_cHTML+= '<H1><FONT color=#ff0000> </FONT></H1>'
_cHTML+= "<H1>Usuario: "+ cUserName   + "</H1>'
_cHTML+= "<H1>Data: "   + Dtoc(Date()) + "</H1>'
_cHTML+= "<h1> Produto: "  + SB1->B1_COD + " " +  SB1->B1_DESC +  "</h1>" 
_cHTML+= " <h2 style= color:red> Bloqueio de tela :" + iif(SB1->B1_MSBLQL == "1"," Sim"," Não")+ "</h2>"
_cHTML+= '</BODY></HTML>'
 
 U_EnvMail("Cadatro de Produto", _cHTML, GetMv("XX_ENG"),"","", Nil, Nil)
 
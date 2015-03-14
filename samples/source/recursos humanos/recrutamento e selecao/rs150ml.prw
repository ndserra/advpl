/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ Rs150ML	     ³ Autor ³RH			    ³ Data ³ 01/06/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Envia e-mail de Agenda para Candidatos.			   		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Rs150ML()		                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 										                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ TRMA150                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function Rs150ML()

Local nTipo   	:= ParamIxb[1]
Local aSaveArea := GetArea()
Local aSvCols	:= Aclone(aCols)

Local cAssunto	:= "Agenda de Processo seletivo" 
Local cMensagem	:= ""
Local cEmail	:= ""

Local nx		:= 0
Local ny		:= 0 
Local nErro		:= 0
Local nTamGetD 	:= Iif( nQual == 3, 1, Len(aSvGetD) )
Local nPosProc	:= GdFieldPos("QD_TPPROCE")
Local nPosData	:= GdFieldPos("QD_DATA")
Local nPosHora	:= GdFieldPos("QD_HORA")

If nTipo == 1
	If !MsgYesNo( OemToAnsi("Confirma o envio de e-mail de agenda para os candidatos ?" ))	
		Return Nil           
	Else
		lEnviaMail := .F.
	EndIf
EndIf

ProcRegua(nTamGetD)

For ny := 1 To nTamGetD //Numero de Candidatos
	
	IncProc()

	TRX->(dbGoto(ny))

	dbSelectArea("SQG")
	dbSetOrder(1)
	dbSeek(xFilial("SQG")+TRX->TRX_CURRIC)
	cEmail	:= SQG->QG_EMAIL
		
	If (nQual == 6 .Or. nQual == 7) .And. !TRX->TRX_CHECK
		Loop
	EndIf
	
	If nQual != 3 //Candidato
		aCols 	:= aClone(aSvGetd[ny][2])
	EndIf
    

	//Lay-out do e-mail
		cMensagem := '<html><title>'+cAssunto+'</title><body>'
		cMensagem += '<table borderColor="#0099cc" height="29" cellSpacing="1" width="645" borderColorLight="#0099cc" border=1>'
		cMensagem += '<tr><td borderColor="#0099cc" borderColorLight="#0099cc" align="left" width="606"'
		cMensagem += 'borderColorDark=v bgColor="#0099cc" height="1">'
		cMensagem += '<p align="center"><FONT face="Arial" color="#ffffff" size="4">'
		cMensagem += '<b>'+OemToAnsi(cAssunto)+'</b></font></p></td></tr>'
		cMensagem += '<tr><td align="left" width="606" height="32"><b><FONT face="Arial" color="#0099cc" size="2">Candidato:&nbsp;</FONT></b><FONT face="Arial" color="#666666" size="2">' + TRX->TRX_NOME + '</FONT><br></td>'
	   
		cMensagem += '<tr><td>'
		cMensagem += '<table width="100%"  border="1" cellspacing="2" cellpadding="2">'
		cMensagem += '<tr>'
		cMensagem += '<td><b><FONT face="Arial" color="#0099cc" size="2">Item do Processo</FONT></b></td>'
		cMensagem += '<td><b><FONT face="Arial" color="#0099cc" size="2">Data</FONT></b></td>'
		cMensagem += '<td><b><FONT face="Arial" color="#0099cc" size="2">Hora</FONT></b></td>'
		cMensagem += '</tr>'
				
		For nx := 1 To Len(aCols)
			cMensagem += '<tr>'							   
			cMensagem += '<td><FONT face="Arial" color="#666666" size="2">&nbsp;' + FDesc("SX5", "R9"+aCols[nx][nPosProc], "X5_DESCRI") + '</FONT></td>'
			cMensagem += '<td><FONT face="Arial" color="#666666" size="2">&nbsp;' + Dtoc(aCols[nx][nPosData]) + '</FONT></td>'
			cMensagem += '<td><FONT face="Arial" color="#666666" size="2">&nbsp;' + aCols[nx][nPosHora] + '</FONT></td>'						
			cMensagem += '</tr>'
		Next nx  
	   
		cMensagem += '</table></td></tr>'
		cMensagem += +'</table></body></html>'	
    //---
    
	MsgRun( OemToAnsi("Aguarde. Enviando Email..."),"",;
			{||nErro := Rh_Email(cEmail,,cAssunto,cMensagem)})
	RH_ErroMail(nErro,TRX->TRX_NOME)
	
Next ny

If nQual != 3 //Candidato
	aCols := Aclone(aSvCols)
EndIf

RestArea(aSaveArea)

Return Nil
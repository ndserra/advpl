#Include "Prothues.ch"


User Function FTP()

Local cServer := "Ftp.totv.com.br"
Local nPorta  := 21
Local cUser   := "totv"
Local cPass   := "escola1010"
Local aRetDir := {}


If FTPConnect(cServer, nPorta, cUser, cPass)
	Conout( "FTP Conectado" )	
	
	If FTPUpLoad("\system\sigafin.xnu","sigafin.xnu") // Sobe arquivos no ftp
		Conout( "UpLoad Completo" )				
	Else                          
		Conout( "Erro no UpLoad" )					
	EndIf
	
	If FTPRenameFile("sigafin.xnu","sigafin.Old") // Renomeando arquivos no FTP
		Conout( "Arquivo renomeado" )				
	Else                          
		Conout( "Erro ao renomear" )					
	EndIf

	If FTPErase("sigafin.Old") // Apagando arquivos no FTP
		Conout( "Arquivo Deletado" )				
	Else                          
		Conout( "Erro ao deletar" )					
	EndIf
	          
	aDirFtp    := FTPDirectory("",)
	aDirFtpD   := FTPDirectory("","D") // R: Leitura | D: Lista Diretorio | H: Oculto | A: Arquivo | S: Sistema
	aDirFtpLoc :=FTPDirectory("\System\*.xnu",)
	

	For i := 1 To Len(aDirFtpLoc)
		If FTPUpLoad("\system\" + aDirFtpLoc[i,1] ,aDirFtpLoc[i,1]) // Sobe arquivos no ftp	
				Conout( "UpLoad Completo" + aDirFtpLoc[i,1] )				
	   Else                          
		 Conout( "Erro no UpLoad" + aDirFtpLoc[i,1] )					
	   EndIf
	Next i		
	
	For i := 1 To Len(aDirFtp)
		If FTPDownLoad("\system\" + aDirFtp[i,1] ,aDirFtp[i,1]) // Sobe arquivos no ftp	
				Conout( "Downloads Completo" + aDirFtp[i,1] )				
	   Else                          
		 Conout( "Erro no Downloads" + aDirFtp[i,1] )					
	   EndIf
	Next i		
	                              
	                            
//	FtpDirChange("Caminho Escolhido") //Muda de diretorio no FTP

//cRet :=	FtpDirGetCurDir() // Informa o diretorio do FTP
	                            
	                            
	ftpDisconnect()
			
ElseIf
	Conout( "Falha na conexão do FTP" )
EndIf

	





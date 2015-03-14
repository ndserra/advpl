/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³UpdatEscala ³ Autor ³Eduardo Ju             ³ Data ³27/03/06  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Atualizacao dos Codigos das escalas das alternativas         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Implantacao APD                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function UpdEscala()
Local cTexto 	:= ""

MsgInfo("Iniciar o processo de troca da Escala...")

dbSelectArea("RBK")
dbSetorder(2)
If !dbSeek(xFilial("RBK")+"ESCALA RELATIVA DE AVALIACäO")
   MsgInfo("Grau de Importância: ESCALA RELATIVA DE AVALIACäO, não cadastrado...")
   Return cTexto
EndIf

dbGoTop()
dbSelectArea("RBL")
dbSetOrder(0)

ProcRegua( RBL->( Reccount() ))

While !RBL->( Eof() ) 
	IncProc()
	If RBL->RBL_ESCALA <> "05"
		RBL->( DbSkip() )
		Loop
	EndIf
		
	Do Case 
		Case RBL->RBL_ITEM == "01"  
			RecLock("RBL",.F.)
				Replace RBL_ITEM 	with "SS"
				Replace RBL_DESCRI  with "SEMPRE SUPERA"
			dbCommit()        
			MsUnLock()
		Case RBL->RBL_ITEM == "02"  
			RecLock("RBL",.F.)
				Replace RBL_ITEM 	with "SF"
				Replace RBL_DESCRI  with "SUPERA FREQUENTEMENTE"
			dbCommit()        
			MsUnLock()
		Case RBL->RBL_ITEM == "03"  
			RecLock("RBL",.F.)
				Replace RBL_ITEM 	with "AP"
				Replace RBL_DESCRI  with "ATINGE PERFEITAMENTE"
			dbCommit()        
			MsUnLock()			
		Case RBL->RBL_ITEM == "04"  
			RecLock("RBL",.F.)
				Replace RBL_ITEM 	with "RA"
				Replace RBL_DESCRI  with "REQUER ATENCAO"
			dbCommit()        
			MsUnLock()				
		Case RBL->RBL_ITEM == "05"  
			RecLock("RBL",.F.)
				Replace RBL_ITEM 	with "AE"
				Replace RBL_DESCRI  with "ABAIXO DA EXPECTATIVAS"
			dbCommit()        
			MsUnLock()	
	EndCase
 	RBL->( dbSkip() )
EndDo    

dbSelectArea("RDB")
dbSetOrder(9)	//Escala e Item de Escala
dbSeek(xFilial("RDB")+"05")

ProcRegua( RDB->( Reccount() ))

While !RDB->( Eof() ) .And. RDB->RDB_ESCALA == "05"

	IncProc()

	Do Case 
		Case RDB->RDB_CODALT == "01"  
			RecLock("RDB",.F.)
				Replace RDB_CODALT with "SS"
			dbCommit()        
			MsUnLock()
		Case RDB->RDB_CODALT == "02"  
			RecLock("RDB",.F.)
				Replace RDB_CODALT with "SF"
			dbCommit()        
			MsUnLock()
		Case RDB->RDB_CODALT == "03"  
			RecLock("RDB",.F.)
				Replace RDB_CODALT with "AP"
			dbCommit()        
			MsUnLock()			
		Case RDB->RDB_CODALT == "04"  
			RecLock("RDB",.F.)
				Replace RDB_CODALT with "RA"
			dbCommit()        
			MsUnLock()				
		Case RDB->RDB_CODALT == "05"  
			RecLock("RDB",.F.)
				Replace RDB_CODALT 	with "AE"
			dbCommit()        
			MsUnLock()	
	EndCase	
	RDB->( dbSkip() )
EndDo

MsgInf("Fim do processamento")
Return cTexto
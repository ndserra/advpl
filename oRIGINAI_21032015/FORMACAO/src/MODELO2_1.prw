#Include "PROTHEUS.CH"

User Function Modelo2_1()


Local aLegenda := {} 

Private aRotina := {}
Private cCadastro := "Solicitação de Software"

AAdd(aRotina, {"Pesquisar" , "AxPesqui"   , 0, 1})
AAdd(aRotina, {"Visualizar", "u_Mod2Manut", 0, 2})
AAdd(aRotina, {"Incluir"   , "u_Mod2Manut", 0, 3})
AAdd(aRotina, {"Alterar"   , "u_Mod2Manut", 0, 4})
AAdd(aRotina, {"Excluir"   , "u_Mod2Manut", 0, 5})
AAdd(aRotina, {"Legenda"   , "u_LegSZ1"   , 0, 6})
AAdd(aRotina, {"Baixar"    , "u_BaixaSZ1"   , 0, 6})

AAdd(aLegenda, {"Z1_LEGENDA = 1 " , "BR_BRANCO"})
aAdd(aLegenda, {"Z1_LEGENDA = 2 " , "BR_PRETO"})
                                               
dbSelectArea("SZ1")
dbSetOrder(1)
dbGoTop()

mBrowse(,,,,"SZ1",,,,,4,aLegenda)


Return Nil
//----------------------------------------------

User Function LegSZ1()
Local cQualquer := "Legenda"
Local aCor := {}

AAdd(aCor, {"BR_BRANCO"   , "Em Aberto" })
aAdd(aCor, {"BR_PRETO", "Finalizado"  })

brwlegenda(cCadastro,cQualquer,aCor) 

Return Nil
//----------------------------------------------

User Function BaixaSZ1(cAlias, nReg, nOpc)
Local cPedido := SZ1->Z1_COD

If MsgYesno("Deseja dar baixa no pedido : " + (cAlias)->Z1_COD )
	
	 (cAlias)->(dbSetOrder(1))
	 If MsSeek(xFilial(cAlias)+SZ1->Z1_COD )
		While ! SZ1->( EOF() ) .AND. SZ1->Z1_COD ==  cPedido
		
			RecLock(cAlias,.F.)
				(cAlias)->Z1_LEGENDA := 2
			//	SZ1->Z1_LEGENDA := 2
			MsUnlock()
			
			SZ1->(dbSkip())
				
		EndDo	
	EndIf
EndIf

Return Nil
//----------------------------------------------



#Include "PROTHEUS.CH"

User Function Tela1()

Local oDlg
Local oBtnOk
Local oBtnCancel
Local aButtons
Local oSayConj
Local oGetConj
Local oSayCivil, cSayCivil
Local oSaySal, cSaySal
Local oRadio, nRadio
Local oChk, lChk
Local cNome    := Space(20)
Local cConjuge := Space(20)
Local cEnder   := Space(30)
Local cCivil   := Space(1)

aButtons := {{"BMPPERG", {||MsgInfo("Pergunte")}, "Pergunte..."},;
             {"BMPCALEN", {||MsgInfo("Calendario")}, "Calendario..."}}
             
Define MSDialog oDlg Title "" From 0,0 To 400,600 Pixel

@20,10 Say "Nome:" Pixel Of oDlg
@20,50 Get cNome Size 50,10 Pixel Of oDlg

@40,10 Say "Estado Civil:" Pixel Of oDlg
@40,50 Get cCivil Size 10,10 Picture "@!" Valid cCivil$"S|C|D" .And. u_VldCivil(cCivil, oSayConj, oGetConj, oSayCivil) Pixel Of oDlg

@40,80 Say oSayCivil Var cSayCivil Size 20,10 Pixel Of oDlg
  
@60,10 Say oSayConj Var "Cônjuge:" Pixel Of oDlg
@60,50 Get oGetConj Var cConjuge Size 50,10 Pixel Of oDlg

@80,10 Say "Endereço:" Pixel Of oDlg
@80,50 Get cEnder Pixel Of oDlg

@100,10 Say "Salário:" Pixel Of oDlg

@100,40 Radio oRadio Var nRadio Items "1000", "2000", "3000" Size 50,9 On Change u_Salario(nRadio, oSaySal) Pixel Of oDlg

@100,80 Say oSaySal Var cSaySal Size 20,10 Pixel Of oDlg

@140,10 CheckBox oChk Var lChk Prompt "Check Box" Size 70,9 On Change MsgAlert(If(lChk,"Marcado","Desmarcado")) Pixel Of oDlg

@oDlg:nHeight/2-30,oDlg:nClientWidth/2-70 Button oBtnOk     Prompt "&Ok"       Size 30,15 Pixel Action u_Confirma()      Message "Clique aqui para Confirmar" Of oDlg
@oDlg:nHeight/2-30,oDlg:nClientWidth/2-35 Button oBtnCancel Prompt "&Cancelar" Size 30,15 Pixel Action oDlg:End() Cancel Message "Clique aqui para Cancelar"  Of oDlg

Activate MSDialog oDlg Centered On Init EnchoiceBar(oDlg, {|| oDlg:End()}, {||oDlg:End()},,aButtons)

Return Nil

//----------------------------------------------------------------------------------------------------------------// 
User Function Confirma()

MsgAlert("Você clicou no botão OK!")

Return
                                                            
//----------------------------------------------------------------------------------------------------------------// 
User Function VldCivil(cCivil, oSayConj, oGetConj, oSayCivil)

If cCivil <> "C"
   oSayConj:Hide()
   oGetConj:Hide()
   //oSayConj:Disable()
   //oGetConj:Disable()
 Else
   oSayConj:Show()
   oGetConj:Show()
   //oSayConj:Enable()
   //oGetConj:Enable()
EndIf

If       cCivil == "C"
         oSayCivil:SetText("Casado")
 ElseIf  cCivil == "S"
         oSayCivil:SetText("Solteiro")
 Else
         oSayCivil:SetText("Divorciado")
EndIf

Return .T.

//----------------------------------------------------------------------------------------------------------------// 
User Function Salario(nRadio, oSaySal) 

If nRadio == 1
   oSaySal:SetText("Hum mil")
 ElseIf nRadio == 2
   oSaySal:SetText("Dois mil")
 Else
   oSaySal:SetText("Tres mil")
EndIf

Return

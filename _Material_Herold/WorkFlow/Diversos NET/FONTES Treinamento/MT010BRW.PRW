#Include "Rwmake.ch"


User Function MT010BRW
Local aRet := {}
Aadd(aRet, {'Envio WF PV' , "U_WFENVPV"   , 0, 6,0 } ) //'Envio Workflow'
Return aRet


User Function WFENVPV
  Local cCodFor := Space(Len(SA2->A2_COD))
  Local cLojFor := Space(Len(SA2->A2_LOJA))
  Local cNomFor := Space(Len(SA2->A2_Nome))
  Private oDlgPesq    := {}
  DBSELECTAREA('SA2')
//  @ 199,274 To 350,792 Dialog oDlgPesq Title OemToAnsi("Informar o fornecedor para envio atualizacao de preco")
  @ 199,274 To 350,792 Dialog oDlgPesq Title OemToAnsi("Informar o numero da Fatura Transportador")

  @ 012,010 To 055,240

  @ 25,018 Say OemToAnsi("Fornecedor") Size 30,8 
  @ 25,110 Say OemToAnsi("Loja")       Size 16,8 
  @ 40,018 Say OemToAnsi("Nome")       Size 16,8 

  @ 025,052 Get cCodFor F3 "SA2" Valid FORNEPRC(cCodFor,@cLojFor,@cNomFor)  Size 45,10
  @ 025,120 Get cLojFor Valid FORNEPRC(cCodFor,@cLojFor,@cNomFor)          Size 16,10
  @ 040,052 Get cNomFor WHEN .F. Size 120,10

  
  @ 60,018 Button OemToAnsi("_Ok")   Size 36,16 Action U_WFPRODENV(cCodFor, cLojFor)
  @ 60,072 Button OemToAnsi("_Sair") Size 36,16 Action Close(oDlgPesq)
  ACTIVATE MSDIALOG oDlgPesq Centered                       
  Return Nil


Static Function FORNEPRC(cCodFor,cLojFor,cNomFor)
  Local cChave := If(Empty(cLojFor),cCodFor,cCodFor+cLojFor)
  If Empty(cCodFor)
    Return .f.
  Endif

  SA2->(DbSetOrder(1))  //filial+cod+loja
  If !SA2->(DbSeek(XFilial("SA2")+cChave))
    MsgAlert("Fornecedor não cadastrado")
    Return .f.
  Endif
  cNomFor := SA2->A2_NOME
  cLojFor      := SA2->A2_LOJA
  Return .t.






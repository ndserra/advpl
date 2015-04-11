#INCLUDE "PROTHEUS.CH"
#INCLUDE "AP5MAIL.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  |KSKWF003  บAutor  ณ DAC - Denilso      บ Data ณ  05/03/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ WorkFlow de aprovacao pedido de compra testa e envia       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Kasinski                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
 
User Function KSKWF003(cOpc,cTipo,cNumPc,cFilSCR,lLibera,cMensProg)
//===============================================
  Local aArea      := GetArea()
  Local aAreaSCR   := SCR->(GetArea()) 
  Local aAreaSC7   := SC7->(GetArea())
  Local nTamUser   := Len(SCR->CR_USERLIB)
  Local aSCR       := {}
  Local aStatus    := {"","Bloqueado","Em Aprova็ใo","Aprovado","Reprovado","Aprov. Usuario"}
  Local aMensIncon := {}
  Local lEnviado   := .f.
  Local cAliasTRB, cQuery, nNivel, cStatus, nCount, cEmailUsu , cSubject
  //indica se deve verificar se encerra o pedido ou nใo, flag enviada no recebimento do workflow
  If ValType(lLibera) <> "L"
    lLibera := .f. 
  Endif

  If ValType(cFilSCR) <> "C"
    cFilSCR := xFilial("SCR")
  Endif

  If ValType(cMensProg) <> "C"
    cMensProg := ''
  Endif

  If ValType(cTipo) <> "C"
    cTipo := 'PC'
  Endif

  If ValType(cNumPc) <> "C"
    cNumPc := SC7->C7_NUM
  Endif

  //cOpc = 1-Envio de pedido, 2-Envio de pedido gerado pela cotacao, 3-recebimento de aprova็ใo pedido
  If ValType(cOpc) <> "C"  
    cOpc := '1'
  Endif

  If cOpc == '1' .and. SC7->C7_CONAPRO <> 'B'  //Chamada do btao envio de workflow MT120BRW()
    Aviso( "KSKWF00301", "Pedido tem que estar bloqueado para envio de Workflow", {"Ok"} )  //
    Return Nil            
  Endif

  If cOpc == '1' .and. !Empty(SC7->C7_FILIAL) .and. SC7->C7_FILIAL <> Xfilial('SC7')  //controlar por filial
    Aviso( "KSKWF00302", "Pedido nใo pertence a esta filial, nใo serแ envido Workflow", {"Ok"} )  //
    Return Nil            
  Endif

                       
  Begin sequence
    cAliasTRB := GetNextAlias()
    cQuery := " SELECT SCR.CR_FILIAL, SCR.CR_TIPO, SCR.CR_USER, SCR.CR_APROV, SCR.CR_NIVEL, "
    cQuery += " SCR.CR_STATUS, SCR.CR_DATALIB, SCR.CR_OBS, SCR.CR_IDWF, SCR.R_E_C_N_O_ NREGSCR"
    cQuery += " FROM " + RetSqlName("SCR")  + " SCR "
    cQuery += " WHERE SCR.CR_FILIAL  = '"   + cFilSCR + "' "  
    cQuery += "   AND SCR.CR_TIPO    = '"   + cTipo   + "' "
    cQuery += "   AND SCR.CR_NUM     = '"   + cNumPC  + "' "
    cQuery += "   AND SCR.D_E_L_E_T_ = ' ' "
    cQuery += " ORDER BY SCR.CR_NIVEL  "
    cQuery := ChangeQuery(cQuery)
    DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasTRB, .F., .T.)
    TcSetField(cAliasTRB,"CR_DATALIB","D",8,0)

    //Nใo localizou nenhum registro nใo enviar SCR
    If (cAliasTRB)->(Eof()) 
      If cOpc == '1' 
        Aviso( "KSKWF00303", "Nใo localizado pedido para envio Workflow", {"Ok"} )  //
      Endif
      Break
    Endif  
    //verificar por niveis, caso sejam todos iguais a zero enviarแ todos os workflows caso nใo enviarแ somente o primeiro e no retorno deverแ tratar os demais
    While (cAliasTRB)->(!Eof())
    // Configuracao padrao MATA097 Aprovacao de Compras:
    // Para o tipo de WF == "PC"
    // CR_STATUS== "01" Bloqueado p/ sistema (aguardando outros niveis)
    // CR_STATUS== "02" Aguardando Liberacao do usuario
    // CR_STATUS== "03" Pedido Liberado pelo usuario
    // CR_STATUS== "04" Pedido Bloqueado pelo usuario
    // CR_STATUS== "05" Pedido Liberado por outro usuario
      cStatus := aStatus[ Val((cAliasTRB)->CR_STATUS)+1 ] //Somo mais um para nใo dar erro se estiver zerado
      aAdd( aSCR,{ (cAliasTRB)->CR_NIVEL,;            //1
                   (cAliasTRB)->CR_APROV,;            //2
                   cStatus,;                          //3
                   AllTrim(UsrFullName((cAliasTRB)->CR_USER)),; //4   
                   DToC((cAliasTRB)->CR_DATALIB),;    //5
                   (cAliasTRB)->CR_OBS,;              //6
                   (cAliasTRB)->CR_STATUS,;           //7
                   (cAliasTRB)->CR_IDWF,;             //8
                   (cAliasTRB)->NREGSCR} )            //9
      (cAliasTRB)->(DbSkip()) 

    Enddo

    For nCount := 1 To Len(aSCR)
      If Empty(aScr[nCount,8]) .and. aScr[nCount,7] == "02"   //Usuarios liberados para envio de workflow
        KSKWFE03(aSCR,aScr[nCount,9],cMensProg,cOpc,@aMensIncon)
        lEnviado := .t.
      Endif  
      //no caso de existir dados para aprovar, bloqueado pelo usuแrio ou bloqueado nใo deixar encerrar
//      If aScr[nCount,7] $ '02_04_01' .and. lLibera
      If aScr[nCount,7] $ '02_01' .and. lLibera
        lLibera   := .f. 
      Endif
    Next
    If !lEnviado .and. cOpc == '1' 
      Aviso( "KSKWF00304", "Nใo existem pedidos com status para serem enviados Workflow", {"Ok"} )  //
      Break             
    Endif
    If cOpc == '1'  
      Aviso( "KSKWF00305", "Workflow Enviado com Sucesso", {"Ok"} )  //
    Endif  
  End Begin

  If Select(cAliasTRB) <> 0
    (cAliasTRB)->(DbCloseArea())
    Ferase(cAliasTRB+GetDBExtension())
  Endif  

  //rotina para liberar o Pedido de venda
  Begin Sequence
    If !lLibera .or. cTipo <> "PC" 
      Break
    Endif
    //Verificar se todos estใo bloqueados, se sim nใo pode liberar 21/12/09
    lLibera   := .f. 
    For nCount := 1 To Len(aScr)
      If !aScr[nCount,7] $ '04'
        lLibera := .t.
      Endif 
    Next
    If !lLibera
      Break
    Endif
    
    PcoIniLan("000055")
    SC7->(DbGotop())
    SC7->(dbSetOrder(1))
    SC7->(DbSeek( cFilSCR+Substr( cNumPC,1,len(SC7->C7_NUM) ) ))
    Begin Transaction    
      While !SC7->(EOF()) .and. SC7->C7_FILIAL+SC7->C7_NUM == cFilSCR+Substr(cNumPC,1,len(SC7->C7_NUM))
        RecLock("SC7",.F.)
        SC7->C7_CONAPRO := "L"
        SC7->(MsUnLock())
        //Enviar email informando pedido liberado
        cCodSolic	:= SC7->C7_USER
        SC7->(DbSkip())
      Enddo
    End Transaction  

  End Begin
  //caso tenha enviado WF devo enviar mensagem para o solicitante DAC 08/01/2010
  If lEnviado
    aAdd(aMensIncon,'Processo de envio de WorkFlow para os seguintes aprovadores:')
    aAdd(aMensIncon,'')
    For nCount := 1 To Len(aScr)
      aAdd(aMensIncon,'Aprovador : '+aScr[nCount,4])  //' - Situa็ใo '+aScr[nCount,3]
    Next  
  Endif
  If Len(aMensIncon) > 0 .and. cOpc $ '1_2'
    cSubject  := "Dados referente ao envio de Workflow do Pedido "+cNumPc+" em "+DtoC(date())
    cEmailUsu := AllTrim(UsrRetMail(__CUSERID))
    If Empty(cEmailUsu)
      Aviso( "KSKWF00306", "Nใo enviado email com hist๓rico do envio Workflow, pois o usuแrio logado nใo possui e-mail !", {"Ok"} )  //
    Else    
      U_Notifica(cEmailUsu , cSubject , aMensIncon )
    Endif
  Endif    
  RestArea( aAreaSC7 )
  RestArea( aAreaSCR )
  RestArea( aArea )
  Return Nil





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณKSKWFE03  บAutor  ณ DAC-Denilso       บ Data ณ 05/03/2010  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina Envio WorkFlow                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Kasinski                                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบP.L. 3    ณ WorkFlow  Solicitacao de Compra                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function KSKWFE03(aAprov,nRegSCR,cMensProg,cOpc,aMensIncon)
  Local cAprov     := ''
  Local cAprovWF   := ''
  Local cObs       := ''
  Local cEMailApv  := ''
  Local cChave     := ''
  Local cWFID      := ''
  Local cCxEmail   := Alltrim(SuperGetMV("MV_WFMLBOX",,"WF"))//Nome da caixa de mensagem do workflow
  Local cCotacao   := ""
  Local oHtml      := NIL
  Local cNumPed    := ''
  Local cCodAprov  := ''
  Local cStatusRet := ''
  Local cEmailUsu  := ''
  Local cFuncRet   := ''        
  Local cUser      := ''
  Local cCondgto   := ''
  Local cContato   := ''
  Local cWfDiret   := SuperGetMV( 'KS_WFDIRE',,'\workflow\HTML\COMPRAS\' )
  Local aCabec     := {} 
  Local aItens     := {}                        
  Local nTotal     := 0
  Local oProcess   := Nil
  Local cHttpWf    := Alltrim(SuperGetMV("MV_HTTPWF",,"127.0.0.1"))//Local onde estarใo arquivos Workflows
  Local cPortaWF   := Alltrim(SuperGetMV("MV_HTTPPWF",,"90"))//Porta do http
  Local cServerWf := "http://"+cHttpWf+":"+cPortaWf
  Local nCount, cIdFW, cCopyWF 

  If ValType(cMensProg) <> "C"
    cMensProg := ''
  ElseIf !Empty(cMensProg)
    cMensProg := 'Ref. a '+ cMensProg    
  Endif

  If ValType(aMensIncon) <> "A"
    aMensIncon := {}
  Endif
  
  Begin Sequence
    SCR->(DbGoto(nRegSCR))
    cNumPed := SubsTr(SCR->CR_NUM,1,Len(SC7->C7_NUM))
    SC7->(DbSetOrder(1))
    If !SC7->(DbSeek(xFilial("SC7")+cNumPed))
      Aadd(aMensIncon,"Nใo localizado pedido "+xFilial("SC7")+"-"+cNumPed+" para enviar workflow! " )
      Break
    Endif
                              
    cNumPed     := SC7->C7_NUM               // Numero do Pedido
    cAprovWF    := AllTrim(UsrRetName(SCR->CR_USER))  // Nome do Aprovador
    cAprov      := AllTrim(UsrFullName(SCR->CR_USER))  // Nome do Aprovador
    cEMailApv   := AllTrim(UsrRetMail(SCR->CR_USER))  // E-mail do Aprovador
    cCodAprov   := SCR->CR_USER              // Codigo do usuario Aprovador
    cCondPgto   := GetAdvFval("SE4","E4_DESCRI",xFilial("SE4")+SC7->C7_COND,1)
    cContato    := SC7->C7_CONTATO
    cCotacao    := SC7->C7_NUMCOT        
    cObjetivo   := "Aprovacใo do pedido de compras "+SC7->C7_NUM+' '+cMensProg    //"Aprobaci๓n Contrato - Numero: "
    //Verificar se o comprador esta cadastrado em compradores e se tem e-mail para enviar
    SY1->(DbSetOrder(3))  //filial+user
    If SY1->(DbSeek(Xfilial('SY1')+SC7->C7_USER)) .and. !Empty(SY1->Y1_EMAIL)
      cEmailUsu   := AllTrim((SY1->Y1_EMAIL))
    Else    
      cEmailUsu   := UsrRetMail(SC7->C7_USER)  // E-mail do usuario da Solicitacao de Compra, utilizado na funcao de retorno
    Endif

    WF7->(DbSetOrder(1)) //WF7_FILIAL + WF7_PASTA
    If !WF7->(DbSeek(xFilial("WF7")+cCxEmail ) )
      Aadd(aMensIncon,"KSKWFE03 - Conta de e-mail" +cCxEmail+"nao cadastrado. Pedido de Compra "+SC7->C7_NUM)
      Conout("KSKWFE03 - Conta de e-mail" +cCxEmail+"nao cadastrado. Pedido de Compra "+SC7->C7_NUM)  //"WFSolic - Conta de e-mail ["###"]nao cadastrado."
      Break
    EndIf

//    cNomeFor := SC7->C7_FORNECE + SC7->C7_LOJA + " - " + GetAdvFval("SA2","A2_NREDUZ",xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,1)
//    Informar dados do fornecedoR DAC 12/03/2010
    SA2->(DbSetOrder(1))
    SA2->(DbSeek(xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA))
    cNomeFor := SC7->C7_FORNECE + SC7->C7_LOJA + " - " + SA2->A2_NREDUZ
    Conout("WF:PC")
    oProcess := TWFProcess():New( '100100', 'ENVIO : ' + SCR->CR_NUM )
    oProcess:NewTask('100100', cWfDiret + 'WFSAPROVPED.HTM'  )
    oProcess:cSubject := "Aprovacใo do pedido de compras "+  SC7->C7_NUM  //"Aprobaci๓n Contrato - Numero: "
    oProcess:NewVersion(.T.)

    If Empty( cEMailApv )
      Conout( "E-mail nao cadastrado para o aprovador " + cAprov + ' - SC ' + SC7->C7_NUM  )  //'E-mail nao cadastrado para o aprovador "
      oProcess:Finish()
      Aadd(aMensIncon,"E-mail nao cadastrado para o aprovador " + cAprov + ' - SC ' + SC7->C7_NUM )  //'E-mail nao cadastrado para o aprovador "
      Break
    Endif   

    oProcess:cTo      := cAprovWF //Link
    oProcess:UserSiga := __CUSERID
    cWFID             := oProcess:fProcessID + oProcess:fTaskId
    oHtml             := oProcess:oHTML
    oHtml:ValByName( 'M0_NOMECOM'   , SM0->M0_NOMECOM )

    oProcess:bReturn := "U_KSKWFR03()"      // Funcao retorno WF
    oHtml:ValByName( 'CCODAPROV'        , cCodAprov )
    oHtml:ValByName( "WFID"             , cWFID  )      // Hidden Field
    oHtml:ValByName( "CFILANT"          , cFilAnt)              // Hidden Field
    oHtml:ValByName( 'CTPAPROVACAO'     , cObjetivo )
    oHtml:ValByName( 'CCOND'            , cCondPgto )
    oHtml:ValByName( 'CONTATO'          , cContato )
    oHtml:ValByName( 'C1_NUM'           , SC7->C7_NUM )
//    oHtml:ValByName( 'COMPRADOR'        , UsrRetName(SC7->C7_USER) )
    oHtml:ValByName( 'COMPRADOR'        , UsrFullName(SC7->C7_USER) )
    oHtml:ValByName( 'C1_FORNECE'       , cNomeFor )
    oHtml:ValByName( 'C1_EMISSAO'       , SC7->C7_EMISSAO )
    oHtml:ValByName( 'CAPROVADOR'       , cAprov )
    oHtml:ValByName( 'CID'              , cWFID )  //????
    oHtml:ValByName( 'A2_EMAIL'         , SA2->A2_EMAIL )  //Email do fornecedor

    //Ja esta posicionado no pedido    
    While SC7->(!Eof()) .And. SC7->C7_FILIAL == xFilial("SC7") .And. SC7->C7_NUM == cNumPed
      nSubTot := SC7->C7_TOTAL - SC7->C7_VLDESC
      aAdd( (oHtml:ValByName( 'it.1') )  , SC7->C7_ITEM  )       //1-Item
      aAdd( (oHtml:ValByName( 'it.2') )  , SC7->C7_PRODUTO )     //2-Produto
      aAdd( (oHtml:ValByName( 'it.3') )  , SC7->C7_DESCRI )      //3-Descricao do produto
      aAdd( (oHtml:ValByName( 'it.4') )  , SC7->C7_UM  )         //4-Unidade
      aAdd( (oHtml:ValByName( 'it.5') )  , Transform( SC7->C7_QUANT, " 99999,999.99" ) )  //5-Quantidade
      aAdd( (oHtml:ValByName( 'it.6') )  , Transform( SC7->C7_PRECO, " 99999,999.99" ) )  //6-Preco
      aAdd( (oHtml:ValByName( 'it.7') )  , Transform( SC7->C7_TOTAL, " 99999,999.99" ) )  //7-Total
      aAdd( (oHtml:ValByName( 'it.8') )  , Transform( SC7->C7_VLDESC, " 99999,999.99" ) )  //6-Preco
      aAdd( (oHtml:ValByName( 'it.9') )  , Transform( nSubTot, " 99999,999.99" ) )  //7-Total
      aAdd( (oHtml:ValByName( 'it.10') ) , SC7->C7_DATPRF  ) //8-Data Entrega
      nTotal += nSubTot
      SC7->(DbSkip())
    Enddo            
    
    oHtml:ValByName( 'NTOTAL'     , Transform( nTotal, " 99,999,999.99" )  )
    aDados := U_DadosCot( cCotacao,SC7->C7_FORNECE )

    //mostrar aprovadores
    For nCount := 1 to Len(aAprov)
      aAdd( (oHtml:ValByName( 'proc.1') )  , aAprov[nCount,1] )  //Nivel
      aAdd( (oHtml:ValByName( 'proc.2') )  , aAprov[nCount,2] )  //Codigo Usuario
      aAdd( (oHtml:ValByName( 'proc.3') )  , aAprov[nCount,3] )  //Situa็ใo
      aAdd( (oHtml:ValByName( 'proc.4') )  , aAprov[nCount,4] )  //Aprovado por
      aAdd( (oHtml:ValByName( 'proc.5') )  , aAprov[nCount,5] )  //Data da Aprova็ใo
      aAdd( (oHtml:ValByName( 'proc.6') )  , aAprov[nCount,6] )  //Observa็ใo
      //Guardar para envio de mensagem para usuแrio
    Next     
   
    //Link
//   oProcess:oProcess:lHtmlBody := .T.

   If !"@" $ oProcess:cTO
     _cTo := cEMailApv  //UsrRetMail(oProcess:cTO)
     cProcess := oProcess:Start()
     Conout(cProcess)
        
     aMsg := {}
     aaDD(aMsg, "Sr.(a) " + cAprov )
     AADD(aMsg, " Enviamos o email com o link abaixo para a sua aprovacao. ")
     AADD(aMsg, " Referente a analise do Pedido Compra No. " + cNumPed )
     AADD(aMsg, " Conforme solicita็ใo aprova็ใo do usuแrio "+ UsrFullName(__CUSERID))
     AADD(aMsg, " ")
     AADD(aMsg, " ")
     AADD(aMsg, "Atenciosamente ")
     AADD(aMsg, " ")
     AADD(aMsg, "Workflow Totvs")
     AADD(aMsg, " ")

//	aAdd(aMsg, '<p><a href="' +GetNewPar("MV_WFHTTP",cServerWf)+'/messenger/emp' +cEmpAnt  + '/' + cAprovWF + '/' + alltrim(cProcess) + '.htm">clique aqui</a></p>')
         //     U_CONSOLE(_cTo)

      cCopyWF := '/messenger/emp' +cEmpAnt  + '/' + cAprovWF + '/' + alltrim(cProcess)+ '.htm' //temporario pois esta copiando no mensager e nใo no workflow
      If !File(cCopyWF)
        cCopyWF := '/workflow/emp' +cEmpAnt  + '/temp/' + alltrim(cProcess)+ '.htm' //temporariopois esta copiando no mensager e nใo no workflow
      Endif

      If File(cCopyWF)
        __CopyFile(cCopyWF, '/workflow/http'+ '/' + alltrim(cProcess) + '.htm') // Realiza a copia do arquivo
      Endif

//     cCopyWF := '/messenger/emp' +cEmpAnt  + '/' + cAprovWF + '/' + alltrim(cProcess)+ '.htm' //temporariopois esta copiando no mensager e nใo no workflow
//   	 __CopyFile(cCopyWF, '/workflow/http'+ '/' + alltrim(cProcess) + '.htm') // Realiza a copia do arquivo

     aAdd(aMsg, '<p><a href="' +GetNewPar("MV_WFHTTP",cServerWf)+'/workflow/http'+ '/' + alltrim(cProcess) + '.htm">clique aqui</a></p>')

     U_Notifica( _cTo, oProcess:cSubject , aMsg )
   Endif

   //oProcess:Start()
   oProcess:Free()  
   RecLock("SCR",.f.)
   SCR->CR_IDWF := cWFID
   SCR->(MsUnLock()) 
   
 End Begin

 Return Nil



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณKSKWFR03	บAutor	ณ DAC-Denilso  บ Data ณ 30/11/2009	   ฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorno do aprovador.				          บฑฑ
ฑฑบ	     ณ								  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso	     ณKasinski                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบP.L.	10   ณ WorkFlow	 Aprovacao Pedido de Compra			  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function KSKWFR03(oProcess)
  Local	aArea	    := GetArea()
  Local	cOpcao	    := UPPER(Alltrim(oProcess:oHtml:RetByName('cOpcaoAprov')))
  Local	cNumPC	    := oProcess:oHtml:RetByName('C1_NUM')
  Local	cCodAprov   := Alltrim(oProcess:oHtml:RetByName('CCODAPROV'))
  Local	cObs	    := oProcess:oHtml:RetByName('OBS')
  Local	cFilialPC   := oProcess:oHtml:RetByName('CFILANT')
  Local	cStatus	    := If(cOpcao	== "SI","03","04")		// 03->	Aprovado, 04-> Reprovado
  Local nOpc        := If(cOpcao == "SI", 2, 4 )
  Local cTipo       := "PC"
  Local cWFID       := oProcess:oHtml:RetByName('WFID')

  Local	cEmailFor   := AllTrim(oProcess:oHtml:RetByName('A2_EMAIL'))
  Local	cEmailForAp := AllTrim(oProcess:oHtml:RetByName('A2_XEMAIL'))
  Local cEmailCmp   := ""
  Local	cComprador	:= oProcess:oHtml:RetByName('COMPRADOR')
  Local lLibera     := .t. //indicara se deve ou nใo ser mandado e-mail para o fornecedors, todos os aprovadores liberados DAC 12/03/2010
  Local aMensFor    := {}
  Local aMensCmp    := {} 
  Local nEnvia      := 0
  Local lRet

  If Empty( Xfilial('SC7') )
    cFilialPC := Xfilial('SC7')
  Endif

  SC7->(dBSetOrder(1))
  SC7->(DbGotop())
  SC7->( DbSeek(cFilialPC+Substr(cNumPC,1,len(SC7->C7_NUM))) )
  cGrupo    := SC7->C7_APROV
  cEmailCmp := AllTrim(UsrRetMail(SC7->C7_USER))  // E-mail do Aprovador

  Conout('KSKWFR03: '+cNumPC)
  Conout("Retorno WF: " , cOpcao , cNumPC, cCodAprov,cFilialPC,cObs	) // //"Retorno	WF: "

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Inicializa a gravacao dos lancamentos do SIGAPCO	      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
  PcoIniLan("000055")

  DbSelectArea("SCR")
  SCR->(DbSetOrder(1))

  Begin	Transaction
    If !SCR->(DbSeek(cFilialPC+cTipo+cNumPC))
      Conout('nใo localizou SCR '+cFilialPC+cTipo+cNumPC)
      Break
    Endif
    While SCR->(!Eof())	.And. SCR->CR_FILIAL ==	cFilialPC  .And. SCR->CR_TIPO == cTipo .And. Alltrim(SCR->CR_NUM) == cNumPC
      Conout('Lendo Aprovador : ',SCR->CR_USER,cCodAprov)
      If AllTrim(SCR->CR_USER) == AllTrim(cCodAprov) .and. Empty(SCR->CR_USERLIB) .and. !Empty(SCR->CR_IDWF) 
        lRet := .t.
        //Caso seja por controle de Al็ada(testando nivel) devo testar id
        If Val(SCR->CR_NIVEL) > 0 .and. AllTrim(CWFID) <> AllTrim(SCR->CR_IDWF) 
          lRet := .f.
        Endif
        If lRet  
          Conout('Achou o aprovador '+cCodAprov)
          //Funcao abaixo	usada para liberar ou broquear o PC, fonte MATXALC
          lRet := MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,SCR->CR_TOTAL,SCR->CR_APROV,,cGrupo,,,,,SCR->CR_OBS},dDatabase,If(nOpc==2,4,6) )
          If lRet .and. !Empty(cObs) 
            RecLock("SCR",.F.)
            SCR->CR_OBS := cObs
            //Preparar dados para envio email fornecedor
            SCR->(MsUnLock())
          Endif  
        Endif
        Conout('Retornou maAlcDoc '+If(lRet,'Verdadeiro','Falso'))
      EndIf
      //Indicar se o pedido ja foi aprovado por todos
      // CR_STATUS== "01" Bloqueado p/ sistema (aguardando outros niveis)
      // CR_STATUS== "02" Aguardando Liberacao do usuario
      // CR_STATUS== "03" Pedido Liberado pelo usuario
      // CR_STATUS== "04" Pedido Bloqueado pelo usuario
      // CR_STATUS== "05" Pedido Liberado por outro usuario

      If Empty(SCR->CR_DATALIB) .or. SCR->CR_STATUS $ "01_02_04"
        lLibera := .f.
      Endif
      
      SCR->(DbSkip())
    EndDo  
  End Transaction
  //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
  //ณ Finaliza a gravacao	dos lancamentos	do SIGAPCO      ณ
  //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
  PcoFinLan("000055")

  //Enviar e-mail para o fornecedor
  If lLibera
    Aadd(aMensCmp,KSKWFL03())
    Aadd(aMensCmp,KSKWFF03(cFilialPC,cNumPC))
//    U_KSKWF004(cFilialPC,cNumPC,aMensCmp,cEmailCmp)
  Endif
  //testar se existe mais itens para ser enviados, se nใo houver encerrar o pedido
  U_KSKWF003('3',cTipo,cNumPc,cFilialPC,.t.)  //.t. indica que deve encerrar se todos os SCR's foram liberados


  RestArea( aArea )
  Return Nil


//Logo TOTVS
Static Function KSKWFL03()
  Local _cLin := ""
  _cLin += "<HTML>"
  _cLin += "<tr> "
  _cLin += "<td align='center'  height='20' width='828'> "
  _cLin += " <p> "
  _cLin += " <b> "
  _cLin += " <img border='0' src='http://www.totvs.com.br/logo.jpg' width='190' height='64' align='left' ><p "
  _cLin += " align='center'><font color='#FFFFFF' size='3' face='Arial'><strong><span style='text-transform: uppercase'></strong></font><font "
  _cLin += " color='#FF0000' size='5' face='Arial'><strong>Aprova็ใo de Pedido</strong></font><font "
  _cLin += " color='#FFFFFF' size='3' face='Arial'></font></p> "
  _cLin +="  </b></td> "
  _cLin +="  </tr> "
  Return _cLin

//Retorno para o fornecedor
Static Function KSKWFF03(cFilialPC,cNumPed)
  Local _cLin := ""
  Local nSubTot
  //reposicionar o pedido
  SC7->(dBSetOrder(1))
  SC7->(DbGotop())
  SC7->( DbSeek(cFilialPC+cNumPed ) )


  _cLin += "<HTML>"
  _cLin += "  <BR>"
  _cLin += " <BR><BR>"
  _cLin += "     <TR>"
  _cLin += "        <B>"
  _cLin += "            <Font size=5> "
  _cLin += "               APROVAวรO DE PEDIDO COMPRAS TOTVS"
  _cLin += "            </Font> "
  _cLin += "        </B>"
  _cLin += "     </TR>"
  _cLin += "  </BR> "
  _cLin += " <BR>"
  _cLin += "   <I>"
  _cLin += "      <TR> "
  _cLin += "         Foi aprovado o pedido de compras de numero "+cNumPed+If(Empty(SC7->C7_NUMCOT),""," ,Cota็ใo "+SC7->C7_NUMCOT)
  _cLin += "      </TR>"
  _cLin += " <BR>"
  _cLin += " <BR>"
//  _cLin += "    <TR>"
//  _cLin += "         Data da aprova็ใo: " + dtoc(date())
//  _cLin += "      <BR>"
//  _cLin += "      <BR>"
//  _cLin += "         Hora da Arpova็ใo: " + Time()
//  _cLin += "      <BR>"
//  _cLin += "      <BR>"
//  _cLin += "    </TR>"
  _cLin += "       <TABLE BORDER = 5>"
  _cLin += "    <TR>"
  _cLin += "      <I>"
  _cLin += "         <TD><B>  Item </B></TD>"
  _cLin += "         <TD><B>  Produto </B></TD>"
  _cLin += "         <TD><B>  UN    </B></TD>"
  _cLin += "         <TD><B>  Qtde    </B></TD>"
  _cLin += "         <TD><B>  Vlr. Unit  </B></TD>"
  _cLin += "         <TD><B>  Vlr Desconto  </B></TD>"
  _cLin += "         <TD><B>  Total         </B></TD>"
  _cLin += "    </TR>"                 
  While SC7->(!Eof()) .And. SC7->C7_FILIAL == cFilialPC .And. SC7->C7_NUM == cNumPed
    nSubTot := SC7->C7_TOTAL - SC7->C7_VLDESC
    _cLin += "    <TR>"
    _cLin += "      <TD>" + SC7->C7_ITEM + "</TD>"
    _cLin += "      <TD>" + SC7->C7_DESCRI + "</TD>"
    _cLin += "      <TD>" + SC7->C7_UM + "</TD>"
    _cLin += "      <TD>" + Transform( SC7->C7_QUANT, " 99999,999.99" )  + "</TD>"
    _cLin += "      <TD>" + Transform( SC7->C7_PRECO, " 99999,999.99" )  + "</TD>"
    _cLin += "      <TD>" + Transform( SC7->C7_VLDESC, " 99999,999.99" ) + "</TD>"
    _cLin += "      <TD>" + Transform( nSubTot, " 99999,999.99" )        + "</TD>"
    _cLin += "    </TR>"                 

    SC7->(DbSkip())
  Enddo            

  _cLin += "     </I>"
  _cLin += " </TR>"
  _cLin += "</TABLE>"
  _cLin += " <BR>"
  _cLin += " <BR><BR>"
  _cLin += " <I> TOTVS </I>"
  _cLin += "     <Font size=2>"  
  _cLin += "        <CENTER>"
  _cLin += " </BODY>"
  _cLin += "</HTML>"
  Return _cLin




   // WFKillProcess(cProcesso)  //mata processo workflow

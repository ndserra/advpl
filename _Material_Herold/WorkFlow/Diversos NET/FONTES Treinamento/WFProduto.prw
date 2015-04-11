#INCLUDE "PROTHEUS.CH"
#INCLUDE "AP5MAIL.CH" 
#Include "Rwmake.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณWFPRODENV บAutor  ณ DAC - Denilso      บ Data ณ 22/08/10    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de envio e  workflow de produto                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณEducacao                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function WFPRODENV(cCodFor, cLojFor)
  Local cHttpWf   := Alltrim(SuperGetMV("WF_HTTPWF" ,,"127.0.0.1"))      //http configurado para acesso workflow
  Local cPortaWF  := Alltrim(SuperGetMV("WF_HTTPPWF",,"90"))             //Porta do http configurada para acesso workflow
  Local cWfDiret  := AllTrim(SuperGetMV("WF_WFDIRE" ,,"\WORKFLOW\HTML\COMPRAS\"))  //Local onde se encontra html nใo preeenchido para carga de dados
  Local cServerWf := "http://"+cHttpWf+":"+cPortaWf                      //Link para acesso ao HTML que serแ gerado
  Local cUsuario  := AllTrim(UsrRetName(__CUSERID))                    // Nome do usuแrio de envio produto
  Local cNomFor, cEmailFor, cContato, cIDWF, cObjetivo
  Local oHtml  , oProcess , _cTo
  Local aMensIncon:={}
  If ValType(cCodFor) <> "C"
    cCodFor := ""
  Endif
  If ValType(cLojFor) <> "C"
    cLojFor := ""
  Endif

  If Empty(cCodFor) .or. Empty(cLojFor)
    MsgAlert("Informar codigo e loja do fornecedor, para envio workflow")
    Return Nil
  Endif
  //Posicionar Fornecedor
  SA2->(DbSetOrder(1))    
  SA2->(DbSeek(XFilial("SA2")+cCodFor+cLojFor))
  cNomFor   := AllTrim(SA2->A2_NOME)
  cEmailFor := AllTrim(SA2->A2_EMAIL)
  cContato  := AllTrim(SA2->A2_CONTATO)
  cObjetivo := "Atualiza็ใo Pre็o Produto "+SB1->B1_COD   //objetivo QUE SAIRA NO html

  //caso nao tenha o e-mail do fornecedor nใo enviar
  If Empty(cEmailFor)
    Aviso( "WFPRODENV002", "Falta e-mail do fornecedor "+cCodFor+"-"+cNomFor+" para envio Workflow !", {"Ok"} )  //
    Return .f.
  Endif  

  //Carregar objeto para envio workflow, ja deve estar posicionado no produto
  oProcess := TWFProcess():New( "000001", "Atualiza็ใo Pre็o Produto "+SB1->B1_COD )
  oProcess:NewTask("000001" , cWfDiret +"WFPRODUTO.HTM" )  //Selecionar HTML que sera carregado com os dados
  oProcess:cSubject := "Atualiza็ใo de pre็os referente ao produto "+  SB1->B1_DESC  //referencia do e-mail
  oProcess:NewVersion(.T.)
  oProcess:bReturn  := "U_WFPRODREC()"   //retorno do workflow, responsavel pela grava็ใo dos valores
  oProcess:cTo      := cContato          //nome do destinatario do email
  oProcess:UserSiga := __CUSERID         //usuแrio referente ao processo WF
  cIDWF             := oProcess:fProcessID + oProcess:fTaskId  //ID de controle do Workflow

  //Preparar objeto para carregar HTML com dados do produto, produto deve estar posicionado
  oHtml             := oProcess:oHTML
  oHtml:ValByName( 'M0_NOMECOM'   , SM0->M0_NOMECOM )  //Nome da Empresa
  oHtml:ValByName( 'COBJETIVO'    , cObjetivo )        //Objetivo         
  oHtml:ValByName( 'CCODUSU'      , __CUSERID )        //Codigo Usuario
  oHtml:ValByName( 'CCODFOR'      , cCodFor )          //Codigo Fornecedor
  oHtml:ValByName( 'CLOJFOR'      , cLojFor )          //Loja Fornecedor


  // Preenche os dados do cabecalho 
  oHtml:ValByName( 'CFORNECEDOR'  , cCodFor+"-"+cNomFor )          
  oHtml:ValByName( 'CONTATO'      , cContato )         
  
  //itens
  Aadd( (oHtml:ValByName( "IT.CODIGO"))     , SB1->B1_COD )
  Aadd( (oHtml:ValByName( "IT.DESCRICAO"))  , SB1->B1_DESC )
  Aadd( (oHtml:ValByName( "IT.UN"))         , SB1->B1_UM )
  Aadd( (oHtml:ValByName( "IT.VALOR"))      , TRANSFORM( SB1->B1_PRV1,'@E 999,999.99' ) )
  Aadd( (oHtml:ValByName( "IT.VLRFOR"))     , TRANSFORM( 0.00        ,'@E 999,999.99' ) )

  //dados da solicita็ใo
  Aadd( (oHtml:ValByName( "PRC.SOL"))       , cUsuario )
  Aadd( (oHtml:ValByName( "PRC.DDATSOL"))   , DtoC(dDatabase) )

  //Preparar para enviaremail
  _cTo := cEmailFor  
  cProcess := oProcess:Start()
  Conout(cProcess)  //mostara na console dados referente o start no objeto
  aMsg := {}        //Criar matriz para guardar dados no corpo do e-mail
  //corpo do e-mail
  Aadd(aMsg, "Sr.(a) " + cContato )
  Aadd(aMsg, " Enviamos o email com o link abaixo para preenchimento. ")
  Aadd(aMsg, " Referente a Atualiza็ใo de pre็os do produto " + SB1->B1_DESC )
  Aadd(aMsg, " Conforme solicita็ใo comprador "+ UsrFullName(__CUSERID))
  Aadd(aMsg, " ")
  Aadd(aMsg, " ")
  Aadd(aMsg, "Atenciosamente ")
  Aadd(aMsg, " ")
  Aadd(aMsg, "TOTVS")
  Aadd(aMsg, " ")
  Aadd(aMsg, '<p><a href="' +GetNewPar("MV_WFHTTP",cServerWf)+'/messenger/emp' +cEmpAnt  + '/' + AllTrim(UsrRetName(SCR->CR_USER)) + '/' + alltrim(cProcess) + '.htm">clique aqui</a></p>')
  //Fun็ใo responsavel por enviar e-mail com link workflow customizada
  U_Notifica( _cTo, oProcess:cSubject , aMsg )  
  
  //enviar e-mail para usuario
  //matriz responsavel para mandar e-mail parausuario
  Aadd(aMensIncon,"Produto "+SB1->B1_COD+"-"+SB1->B1_DESC+", enviada para o Fornecedor  "+SA2->A2_NOME+" em "+DtoC(Date())+" as "+SubsTr(Time(),1,5) )
  cSubject  := "Dados referente ao envio de workflow produto "+SB1->B1_COD+" em "+DtoC(date())+" as "+SubsTr(Time(),1,5) 
  cEmailUsu := AllTrim(UsrRetMail(__CUSERID))
  If Empty(cEmailUsu)
    Aviso( "WFPRODENV002", "Nใo enviado email com hist๓rico do envio Workflow, pois o usuแrio logado nใo possui e-mail !", {"Ok"} )  //
  Else    
    U_Notifica(cEmailUsu , cSubject , aMensIncon )
  Endif    
  Return .t.




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณWFPRODREC บAutor  ณ DAC - Denilso      บ Data ณ 22/08/10    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de recebimento workflow de produto                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณEducacao                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function WFPRODREC(oProcess)
  Local cUsuario :=  AllTrim(oProcess:oHtml:RetByName("C8_NUM"))  

  Local cCodUsu    := AllTrim(oProcess:oHtml:RetByName("CCODUSU"))  //recupera codigo usuario
  Local cCodFor    := AllTrim(oProcess:oHtml:RetByName("CCODFOR"))  //recupera codigo fornecedor 
  Local cLojFor    := AllTrim(oProcess:oHtml:RetByName("CLOJFOR"))  //recupera loja fornecedor
  Local cFilAnt    := AllTrim(oProcess:oHtml:RetByName("CFILANT"))  //recupera Filial
  Local aValProd   := {} 
  Local aMensIncon := {}
  Local cCodProd, cValProd, nValAnt, cSubject, cEmailUsu, cSubject

  //posicionar o fornecedor
  SA2->(DbSetOrder(1))  //filial+cod+loja 
  cCodFor := cCodFor+Space(Len(SA2->A2_COD)-Len(cCodFor))   //ajustar tamanho codigo fornecedor
  cLojFor := cLojFor+Space(Len(SA2->A2_LOJA)-Len(cLojFor))  //ajustar tamanho loja fornecedor

  Begin Sequence
    If !SA2->(DbSeek(Xfilial("SA2")+cCodFor+cLojFor)) 
      Aadd(aMensIncon,"Nao localizado Fornecedor "+cCodFor+"-"+cLojFor+"no recebimento Workflow !")
      Conout('WF produto: '+"Nao localizado Fornecedor "+cCodFor+"-"+cLojFor+"no recebimento Workflow !")
      Break
    Endif
    //posiciono a ordem do produto para pesquisa
    SB1->(DbSetOrder(1))  //filial+codprod

    For nCount := 1 to len(oProcess:oHtml:RetByName("IT.CODIGO"))
      cCodProd := oProcess:oHtml:RetByName("IT.CODIGO")[nCount]
      cValProd := oProcess:oHtml:RetByName("IT.VLRFOR")[nCount]
      If !SB1->(DbSeek(XFilial(cFilAnt+cCodProd)))
        Aadd(aMensIncon,"Nใo localizada produto "+cCodProd+", referente atualiza็ใo valor do fornecedor codigo "+cCodFor+"-"+cLojFor+" com valor "+cValProd )
        Conout('WF produto: '+"Nใo localizada produto "+cCodProd+", referente atualiza็ใo valor do fornecedor codigo "+cCodFor+"-"+cLojFor+" com valor "+cValProd )
        Loop
      Endif
      RecLock("SB1",.f.)
      nValProd := SB1->B1_PRV1
      SB1->B1_PRV1 := WFSTRVAL(cValProd) //fun็ใo static abaixo
      SB1->(MSUnlock())

      Conout('WF produto: '+"Atualizado produto "+cCodProd+" valor anterior "+Str(nValProd)+" para "+Str(SB1->B1_PRV1))

      Aadd(aValProd,{ cCodPro,cCodFor+"-"+cLojFor+"-"+SA2->A2_NREDUZ,Str(nValProd),Str(SB1->B1_PRV1) })   
    Next  
  
    cEmailUsu := AllTrim(UsrRetMail(cCodUsu))
    If Empty(cEmailUsu)
      Conout('WF produto: '+"Nใo enviado email com hist๓rico do envio Workflow, pois o usuแrio "+cCodUsu+" nใo possui e-mail !", {"Ok"} )  //
      Break
    Endif  

    //guardar valores alterados para posterior envio de mensagem
    If Len(aValProd) > 0
      Aadd(aMensIncon,WFRECMSG(aValProd)) 
    Endif

    If Len(aMensIncon) > 0
      //enviar e-mail para usuario
      //matriz responsavel para mandar e-mail para usuario
      cSubject  := "Dados referente ao envio de workflow produto "+cCodProd+" em "+DtoC(date())+" as "+SubsTr(Time(),1,5) 
      U_Notifica(cEmailUsu , cSubject , aMensIncon )
    Endif
  End Sequence


  Return Nil





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณWFRECMSG  บAutor  ณ DAC - Denilso      บ Data ณ 22/08/10    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMontagem HTML no corpo do e-mail para informa็๕es usuario   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณEducacao                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function WFRECMSG(aRetProd)
  Local nCount
  Local _cLin  := ""

  _cLin += "<HTML>"
  _cLin += "  <BR>"
  _cLin += " <BR><BR>"
  _cLin += "     <TR>"
  _cLin += "        <B>"
  _cLin += "            <Font size=5> "
  _cLin += "               ALTERAวAO DE PRODUTO CONFORME WORKFLOW FORNECEDOR "
  _cLin += "            </Font> "
  _cLin += "        </B>"
  _cLin += "     </TR>"
  _cLin += "  </BR> "
  _cLin += " <BR>"
  _cLin += "   <I>"
  _cLin += "      <TR> "
  _cLin += "         Foram alterados os valores dos produtos abaixo, conforme WorkFlow do Fornecedor !"
  _cLin += "      </TR>"
  _cLin += " <BR>"
  _cLin += " <BR>"
  _cLin += "       <TABLE BORDER = 5>"
  _cLin += "    <TR>"
  _cLin += "      <I>"
  _cLin += "         <TD><B>  Produto </B></TD>"
  _cLin += "         <TD><B>  Fornecedor </B></TD>"
  _cLin += "         <TD><B>  Valor    </B></TD>"
  _cLin += "         <TD><B>  Valor Atualizado  </B></TD>"
  _cLin += "         <TD><B>  Data  </B></TD>"

  _cLin += "    </TR>"                 
  For nCount := 1 To Len(aRetProd)   
    _cLin += "      <TD>" + aRetProd[nCount,1] + "</TD>"
    _cLin += "      <TD>" + aRetProd[nCount,2] + "</TD>"
    _cLin += "      <TD>" + aRetProd[nCount,3] + "</TD>"
    _cLin += "      <TD>" + aRetProd[nCount,4] + "</TD>"
    _cLin += "      <TD>" + aRetProd[nCount,5] + "</TD>"
  Next
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




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณWFSTRVAL  บAutor  ณ DAC - Denilso      บ Data ณ 22/08/10    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetornar valor de um dado caracter recebido                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณEducacao                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function WFSTRVAL(cValor)
  Local nPos, nValor
  nPos   := AT(",",cValor)
  If nPos > 0
    nValor := Val(SubsTr(cValor,1,nPos-1)+"."+SubsTr(cValor,nPos+1,2))
  Else
    nValor := Val(cValor)  
  Endif
  Return nValor





                                     


//Fun็๕es relativa ao Workflow

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOTIFICA  บAutor  ณ                           ณ             บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao de notificacao.                                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
USER FUNCTION Notifica(cTo, cTitle, aMsg, aFiles, lMens )
  Local cBody, nInd
  cBody := '<html>'
  cBody += '<DIV><SPAN class=610203920-12022004><FONT face=Verdana color=#ff0000 '
  cBody += 'size=2><STRONG>Workflow - Servi็o Envio de Mensagens</STRONG></FONT></SPAN></DIV><hr>'
  For nInd := 1 TO Len(aMsg)
    cBody += '<DIV><FONT face=Verdana color=#000080 size=3><SPAN class=216593018-10022004>' + aMsg[nInd] + '</SPAN></FONT></DIV><p>'
  Next
  cBody += '</html>'

  If "@" $ cTo
    WFNotifyAdmin( cTo , cTitle, cBody, aFiles )
  Else
    conout("Nใo foi enviado e-mail para "+cTo+" referente "+cTitle )
  Endif 
    
  Return Nil                  
  
  
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDadosCot  บAutor  ณ                    บ Data ณ             บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao retorna dados da cotacao                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function DadosCot( cNumCot, cCodFor )
  Local aArea   := GetArea()
  Local aRetorno := {}
  Local cQuery := ""
  Local cAliasQry       := GetNextAlias()

  cQuery += "SELECT C8_NUM,C8_FORNECE,C8_LOJA,A2_NOME,E4_CODIGO,E4_DESCRI,C8_DATPRF,C8_PRAZO "
  cQuery += "FROM "+RetSqlName("SC8")+" SC8,"+RetSqlName("SA2")+" SA2,"+RetSqlName("SE4")+" SE4 "
  cQuery += "WHERE "
  cQuery += "C8_FILIAL ='"+xFilial("SC8")+"' AND SC8.D_E_L_E_T_ = '' "
  cQuery += "AND A2_FILIAL = '"+xFilial("SA2")+"' AND C8_FORNECE = A2_COD AND C8_LOJA = A2_LOJA AND SA2.D_E_L_E_T_ = '' "
  cQuery += "AND E4_FILIAL = '"+xFilial("SE4")+"' AND C8_COND = E4_CODIGO AND SE4.D_E_L_E_T_ = '' "
  cQuery += "AND C8_NUM = '"+cNumCot+"' AND C8_NUM <> '' AND C8_FORNECE <> '"+cCodFor+"' "
  cQuery += "GROUP BY C8_NUM,C8_FORNECE,C8_LOJA,A2_NOME,E4_CODIGO,E4_DESCRI ,C8_DATPRF,C8_PRAZO "

  dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.F.,.T.)

  TcSetField(cAliasQry,"C8_DATPRF","D",8,0)
  TcSetField(cAliasQry,"C8_PRAZO","N",12,2)

  DbSelectArea(cAliasQry)
  (cAliasQry)->(DbGoTop())
  While (cAliasQry)->(!EOF())
        AADD(aRetorno,{ (cAliasQry)->C8_FORNECE,;
        (cAliasQry)->C8_LOJA,;
        (cAliasQry)->A2_NOME,;
        (cAliasQry)->E4_CODIGO+"-"+(cAliasQry)->E4_DESCRI,;
        (cAliasQry)->C8_DATPRF+(cAliasQry)->C8_PRAZO})
        (cAliasQry)->(DbSkip())
  EndDo

  If Len(aRetorno) == 0
        AADD( aRetorno, {"","","","",Ctod("//")} )
  EndIf

  If Select(cAliasQry) > 0
        (cAliasQry)->(DbCloseArea())
    Ferase(cAliasQry+GetDBExtension())
  EndIf
  RestArea( aArea )
  Return( aRetorno )
                                
  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณKSKAPRVSC  บAutor  ณ DAC                บ Data ณ 05/03/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao retorna aprovadores na solicita็ใo de compras       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function KSKAPRVSC(cNumSC,nOpca,cAliasTRB)
  Local lRet      := .t.
  Local lGrava    := .f.
  Local aArea     := GetArea()
  Local aAreaSCR  := SC1->(GetArea()) 
  Local aRet      := {}
  Local aRetST    := {}
  Local _cpUser   := RetCodUsr()
  Local cQuery, cEmailUsu, cSubject

  //indica sea chamada ้ para envio de workflow
  If ValType(nOpca) <> "N"
    nOpca := 0
  Endif       

  If ValType(cNumSC) <> "C"
    cNumSC := SC1->C1_NUM
  Endif       

  If ValType(cAliasTRB) <> "C"
    cAliasTRB := GetNextAlias()  
  Endif

  If nOpca > 2  //retornar pois tratase de status para bloqueio
    Return .t.  
  Endif

  If cNumSC <> SC1->C1_NUM
    SC1->(DbSetOrder(1))
    If !SC1->(DbSeek(Xfilial("SC1")+cNumSC))
      Aviso( "KSKAPRVSC01", "Nใo localizado solicita็ใo de compras "+cNumSC, {"Ok"} )  //
      Return .f.
    Endif
  Endif
  
  If nOpca == 0 .and. SC1->C1_APROV <> 'B'  //se nao for bloqueado nao deixar, neste caso somente estara sendo controlada para o workflow
    Aviso( "KSKAPRVSC02", 'Workflow somente para solicita็๕es bloqueadas', {"Ok"} )  //
    Return Nil  
  Endif
  
  //Tipo de aprovador 1= Solicitante, 2=Aprovador e 3 = Ambos
  cQuery := " SELECT SZI.ZI_CODUSU, SC1.C1_IDWF, SC1.C1_ITEM, SC1.R_E_C_N_O_ NREGSC1 "
  cQuery += " FROM " + RetSqlName("SZI") + " SZI, "+ RetSqlName("SC1") + " SC1"

  cQuery += " LEFT JOIN " + RetSqlName("SB1") + " SB1 "
  cQuery += "   ON  SB1.B1_FILIAL  = '" + xFilial("SB1") + "' "
  cQuery += "   AND SB1.B1_COD     =  SC1.C1_PRODUTO "
  cQuery += "   AND SB1.D_E_L_E_T_ = ' ' "    
  
  cQuery += " WHERE SC1.C1_FILIAL =  '"  + xFilial('SC1') + "' "
  cQuery += "   AND SC1.C1_NUM    =  '"  + SC1->C1_NUM    + "' "
  If nOpca == 0
    cQuery += " AND SC1.C1_APROV     =  'B' "   //SOMENTE BLOQUEADOS
  Endif  
  cQuery += "   AND SC1.D_E_L_E_T_ =  ' ' "    
  
  cQuery += "   AND SZI.ZI_FILIAL  = '" + xFilial("SZI") + "' "
  cQuery += "   AND SC1.C1_CC  >= SZI.ZI_CCINI  AND SC1.C1_CC <= SZI.ZI_CCFIM  "
  If nOpca == 0
    cQuery += " AND SZI.ZI_TIPO IN ('2','3') " 
  Else
    cQuery += " AND SZI.ZI_TIPO IN ('1','3') " 
    cQuery += " AND SZI.ZI_CODUSU  = '" + __CUSERID + "' "
  Endif  
  cQuery += "   AND SZI.D_E_L_E_T_ =  ' ' "    
  
 
  cQuery += " ORDER BY SZI.ZI_CODUSU, SC1.C1_ITEM "

  cQuery := ChangeQuery(cQuery)
      
  DbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAliasTRB, .F., .T.)
  (cAliasTRB)->(DbGotop())

  If (cAliasTRB)->(EOF())
    Aviso( "KSKAPRVSC03", "Nใo localizado aprovadores para a solicita็ใo de compras", {"Ok"} )  //
    lRet := .f.
  Endif   

  //neste caso foi aprovado/recusada manualmente posso enviar o WF para comprador
  If lRet .and. nOpca > 0  //Caso nใo seja workflow, necessแrio regravar o status
    RECLOCK("SC1",.F.)
    SC1->C1_APROV := "B"
    SC1->(MSUNLOCK())
  //caso seja aprovado manualmente
  ElseIf lRet .and. nOpca > 0  //enviar WF para comprador
    cRetSt := If(nOpca == 1,"Liberado por" ,;
              If(nOpca == 2,"Reprovado por","Indefinido" ))
     //caso nใo seja aprovado informar o motivo 
    Aadd(aRet,"Item "+SC1->C1_ITEM+", "+cRetSt+" "+SC1->C1_NOMAPRO+If(nOpca == 2 .and. !Empty(SC1->C1_OBS),", "+SC1->C1_OBS,"") +"."  )
    cSubject  := "Dados referente a aprova็ใo Workflow do Solicita็ใo de Compras "+SC1->C1_NUM+" em "+DtoC(date())+", Aprovador "+UsrFullName(AllTrim(_cpUser))
    cEmailUsu := AllTrim(UsrRetMail(SC1->C1_USER))
    //CASO NAO TENHA E-MAIL DO COMPRADOR DEVOLVO PARA O APROVADOR AVISAR AO COMPRADOR 
    If Empty(cEmailUsu)
      cEmailUsu := AllTrim(UsrRetMail(_cpUser))
      aAdd(aRet,Replicate("_",80))
      aAdd(aRet,"FAVOR AVISAR SOLICITANTE "+UsrFullName(SC1->C1_USER)+" DA ATUALIZAวรO REF. APROVAวรO SOLICITAวรO DE COMPRAS "+cNumSC+" POIS O MESMO NรO POSSUI EMAIL ") 
    Endif
    If !Empty(cEmailUsu) 
      U_Notifica(cEmailUsu , cSubject , aRet )
    Endif
  Endif
  
  Return lRet
                      


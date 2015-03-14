/*
Programa : QbgOrdProcs_rdm
Autor    : Jeferson Barros Jr.
Data     : 10/11/03 14:25.
Uso      : Gravação do campo EE7_KEY (Pedido) e EEC_VLNFC (Embarque) para 
           ordeção decrescente de processos.
Revisao  : 
*/

#include "EECRDM.CH"

/*
Funcao      : OrdProcs()
Parametros  : Nenhum.
Retorno     : .t.
Objetivos   : Gravação do campo EE7_KEY (Pedido) e EEC_VLNFC (Embarque) para 
              ordeção decrescente de processos.
Autor       : Jeferson Barros Jr.
Data        : 10/11/03 14:29.
Revisao     : 
Obs.        :
*/
*----------------------*
User Function OrdProcs()
*----------------------*
Local lRet:=.t.

Begin sequence

   If EECFlags("ORD_PROC")
   
      If !MsgYesNo("Confirma a atualização?","Atenção")
         Break
      EndIf

      // ** Grava o campo chave para os pedidos.
      Processa({|| SetIndexKey()})

      // ** Grava o campo chave para os embarques.
      Processa({|| SetIndexKey(.f.)})

      MsgInfo("Atualização realizada com sucesso!","Atenção")
   Else
      MsgInfo("Os tratamentos para ordenação decrescente de processos, estão"+ENTER+;
              "desativados. Revise o MV_AVG0056 e os campos necessários para"+ENTER+;
              "ativação da rotina.","Atenção")   
   EndIf

End Sequence

Return lRet


/*
Funcao      : SetIndexKey(lPedido)
Parametros  : lPedido = .t. - Fase de Pedido (Default)
                        .f. - Fase de Embarque.
Retorno     : .t.
Objetivos   : Gravação do campo EE7_KEY (Pedido) e EEC_VLNFC (Embarque) para 
              ordeção decrescente de processos.
Autor       : Jeferson Barros Jr.
Data        : 10/11/03 14:46.
Revisao     : 
Obs.        :
*/
*----------------------------------*
Static Function SetIndexKey(lPedido)
*----------------------------------*
Local lRet:=.t., cAlias, aOrd:=SaveOrd({"EE7","EEC"})
Local nNextKey := 9999999999

Default lPedido := .t.

Begin Sequence

   cAlias:=If(lPedido,"EE7","EEC")

   ProcRegua((cAlias)->(LastRec())+1)

   If lPedido

      Begin Transaction

         EE7->(DbSetOrder(2))

         // ** Atualiza os processos com data de solicitação preenchida...
         EE7->(DbSeek(xFilial("EE7")+Dtos(Ctod("01/01/1900")),.t.))
         Do While EE7->(!Eof()) .And. xFilial("EE7") == EE7->EE7_FILIAL .And. !Empty(EE7->EE7_DTSLCR)

            IncProc("Atualizando Dados do Processo: "+;
                    AllTrim(Transf(EE7->EE7_PEDIDO,AVSX3("EE7_PEDIDO",AV_PICTURE))))

            EE7->(RecLock("EE7",.f.))
            EE7->EE7_KEY := nNextKey

            nNextKey -= 1

            EE7->(DbSkip())
         EndDo
         
         // ** Atualiza os processos sem data de solicitação preenchida...
         EE7->(DbSeek(xFilial("EE7")))
         Do While EE7->(!Eof()) .And. xFilial("EE7") == EE7->EE7_FILIAL .And. Empty(EE7->EE7_DTSLCR)

            IncProc("Atualizando Dados do Processo: "+;
                     AllTrim(Transf(EE7->EE7_PEDIDO,AVSX3("EE7_PEDIDO",AV_PICTURE))))

            EE7->(RecLock("EE7",.f.))
            EE7->EE7_KEY := nNextKey

            nNextKey -= 1

            EE7->(DbSkip())
         EndDo
      End Transaction
   Else
   
      Begin Transaction
      
         EEC->(DbSetOrder(12))
         
         // ** Atualiza os processos já embarcados.
         EEC->(DbSeek(xFilial("EEC")+Dtos(Ctod("01/01/1900")),.t.))
         Do While EEC->(!Eof()) .And. xFilial("EEC") == EEC->EEC_FILIAL .And. !Empty(EEC->EEC_DTEMBA)

            IncProc("Atualizando Dados do Processo: "+;
                    AllTrim(Transf(EEC->EEC_PREEMB,AVSX3("EEC_PREEMB",AV_PICTURE))))

            EEC->(RecLock("EEC",.f.))
            EEC->EEC_VLNFC := nNextKey
            nNextKey -= 1

            EEC->(DbSkip())
         EndDo
                  
         // ** Atualizando os processos sem data de embarque.
         EEC->(DbSeek(xFilial("EEC")))
         Do While EEC->(!Eof()) .And. xFilial("EEC") == EEC->EEC_FILIAL .And. Empty(EEC->EEC_DTEMBA)

           IncProc("Atualizando Dados do Processo: "+;
                   AllTrim(Transf(EEC->EEC_PREEMB,AVSX3("EEC_PREEMB",AV_PICTURE))))

            EEC->(RecLock("EEC",.f.))
            EEC->EEC_VLNFC := nNextKey
            nNextKey -= 1

            EEC->(DbSkip())
         EndDo
      End Transaction
   EndIf

End Sequence

RestOrd(aOrd)

Return lRet
*--------------------------------------------------------------------------------------------------------------*
*  FIM DO RDMAKE QGGORDPROCS_RDM.PRW
*--------------------------------------------------------------------------------------------------------------*
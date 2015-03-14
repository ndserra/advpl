/*
Programa : Qbgatucambio_rdm.
Autor    : João Pedro Macimiano Trabbold
Data     : 19/08/04 8:45.
Uso      : Fazer a atualização dos novos campos do EEQ, a partir de dados da capa do embarque
Revisao  : 
*/

#include "EECRDM.CH"

/*
Funcao     : AtuCambio().
Parametros : Nenhum.
Retorno    : .t. -> Atualização realizada com sucesso.
             .f. -> Atualização não pode ser realizada.
Objetivos  : Fazer a atualização dos novos campos do EEQ, a partir de dados da capa do embarque e do EC6
Autor      : João Pedro Macimiano Trabbold
Data       : 19/08/04 8:45.
Revisao    :
Obs.       :
*/
*------------------------*
User Function AtuCambio()
*------------------------*
Local lRet:=.t.

Begin sequence

   /* Verifica se o ambiente possue todas as configurações necessárias para a ativação 
      dos tratamentos de frete, seguro e comissão. */

   If EECFlags("FRESEGCOM")

      If !MsgYesNo("Confirma a atualização?","Atenção")
         lRet:= .f.
         Break
      EndIf

      // Validações específicas para atualização dos campos do EEQ
      If !VldAtu()
         lRet:= .f.
         Break
      EndIf

      // ** Grava os campos 
      Processa({|| GravaCpos() })

      MsgInfo("Atualização realizada com sucesso!","Aviso")
   Else
      MsgStop("Problema:"+Replic(ENTER,2)+;
              "      A atualização não poderá ser realizada."+Replic(ENTER,2)+;
              "Detalhes:"+Replic(ENTER,2)+;
              "      O ambiente não possue todas as configurações necessárias para a"+ENTER+;
              "ativação dos tratamentos de frete, seguro e comissão.","Atenção")
      lRet := .f.
   EndIf

End Sequence

Return lRet

/*
Funcao      : VldAtu().
Parametros  : Nenhum.
Retorno     : .t./.f.
Objetivos   : Validação que verifica se as tabelas EEQ e EEC estão no mesmo modo (exclusivo ou compartilhado).
Autor       : João Pedro Macimiano Trabbold
Data        : 19/08/04 10:33.
Revisao     :
Obs.        :
*/
*----------------------*
Static Function VldAtu()
*----------------------*
Local lRet:=.t. 


Begin Sequence

   If xFilial("EEQ") # xFilial("EEC")
      MsgStop("Para haver a Atualização, as tabelas de Embarques(EEC) e do Valor das Parcelas"+ENTER+;
              " de Embarque(EEQ) devem estar no mesmo modo (compartilhado ou exclusivo).","Atualização não pode ser efetuada!") 
      lRet:=.f.
   endif

End Sequence

Return lRet

/*
Funcao      : GravaCpos().
Parametros  : Nenhum.
Retorno     : .t./.f. 
Objetivos   : Gravar os conteúdos dos novos campos do EEQ
Autor       : João Pedro Macimiano Trabbold
Data        : 17/08/04 14:46.
Revisao     :
Obs.        :
*/
*--------------------------*
Static Function GravaCpos()
*--------------------------*
Local lRet:=.t., aOrd:=SaveOrd({"EEQ","EC6","EEC"}) 

Begin Sequence 
   EEQ->(DbSetOrder(1))
   EEQ->(DbSeek(xFilial("EEQ")))
   While !EEQ->(EOF()) .And. xFilial("EEQ") == EEQ->EEQ_FILIAL
      EC6->(DbSetOrder(1))
      if EC6->(DbSeek(xFilial("EC6")+"EXPORT"+EEQ->EEQ_EVENT))  
      
         EEC->(DBSetOrder(1))
         if EEC->(DBSeek(xFilial("EEC")+EEQ->EEQ_PREEMB))
            
            BEGIN TRANSACTION  
               If EEQ->(RecLock("EEQ",.f.))
                  
                  if EC6->EC6_RECDES == "1"
                     EEQ->EEQ_FORN   := EEC->EEC_FORN
                     EEQ->EEQ_FOLOJA := EEC->EEC_FOLOJA
                     EEQ->EEQ_IMPORT := EEC->EEC_IMPORT
                     EEQ->EEQ_IMLOJA := EEC->EEC_IMLOJA
                     EEQ->EEQ_TIPO   := "R"
                  Else
                     EEQ->EEQ_TIPO   := "P"
                  endif 
                  EEQ->EEQ_MOEDA  := EEC->EEC_MOEDA
                  
               endif
            END TRANSACTION
         
         endif     
      endif  
      EEQ->(DbSkip())    
   enddo
End Sequence

RestOrd(aOrd)

Return lRet
*--------------------------------------------------------------------------------------------------------------*
*  FIM DO RDMAKE QBGATUCAMBIO_RDM.PRW
*--------------------------------------------------------------------------------------------------------------*
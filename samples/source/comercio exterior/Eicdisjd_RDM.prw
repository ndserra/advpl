///FunCao    : EICDISJD  
///Autor     : AVERAGE/ALEX WALLAUER 
///Data      : 07/09/00
///Descricao : Controle de Saldo de Containers 
/// Uso      : PROTHEUS V508
#INCLUDE "Eicdisjd.ch"   
#include "AVERAGE.CH"


*---------------------------------*
USER FUNCTION Eicdisjd()
*---------------------------------*
cFilSJD:=xFilial("SJD")

SJD->(DBSETORDER(1))

IF SJD->(DBSEEK(cFilSJD+SW6->W6_HAWB))

   bWhile:={||cFilSJD==SJD->JD_FILIAL.AND.SW6->W6_HAWB==SJD->JD_HAWB}
   
   SJD->(DBEVAL( {||DeletaSJD()},,bWhile ))

ENDIF

RETURN .T.

*------------------------------*
STATIC Function DeletaSJD()
*------------------------------*

MsProcTxt(STR0001+SJD->JD_TIPO_CT) //"Excluindo Container: "

SJD->(RECLOCK("SJD",.F.))
SJD->(DBDELETE())
SJD->(MSUNLOCK())

return .t.

#INCLUDE "rwmake.ch"

*--------------------------*
USER FUNCTION ICPADB1()              
*--------------------------*

M->B1_POSIPI:=M->B1_POSIPI+SPACE(LEN(SB1->B1_POSIPI)-LEN(M->B1_POSIPI))

RETURN EMPTY(M->B1_POSIPI+M->B1_EX_NCM+M->B1_EX_NBM) .OR. ExistCpo("SYD",M->B1_POSIPI+M->B1_EX_NCM+M->B1_EX_NBM)

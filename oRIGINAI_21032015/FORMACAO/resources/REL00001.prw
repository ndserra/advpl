#include 'protheus.ch'
#include 'parmtype.ch'

User Function REL00001()

MsgInfo("Grupo de pergunta SX1","Dicionario SX1")

PERGUNTE("REL00001",.T.)

MsgInfo("Codigo de: "  + MV_PAR01 + CHR(13) + ;
 	    "Codigo Ate: " + MV_PAR02 + CHR(13) + ;
 	    "Bloqueado: "  + cValToChar(MV_PAR03) )



Return()



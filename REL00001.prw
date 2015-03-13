#include 'protheus.ch'
#include 'parmtype.ch'

user function REL00001() 

Msginfo("Perguntinhas do grupo SX1","Dicionario SX1")

PERGUNTE("REL00001",.T.)

Msginfo("Codigo de: " + MV_PAR01 + CHR(13) + ;
		"Codigo ate: " + MV_PAR02 + CHR(13) + ;
		"Bloqueio: " + cValToChar(MV_PAR03), "Respostas")
		


return
/*
    Programa : EICPLC00.PRW
    Autor    : Heder M Oliveira    
    Data     : 23/06/99 18:31
    Revisao  : 23/06/99 18:31
    Uso      : Adicionar campos na enchoice

*/            
#INCLUDE "AVERAGE.CH"
*-------------------------*
USER FUNCTION EICPLC00()
*-------------------------*
//aENCHOICE := identificador Private declarada no EICLC100.PRW
aEnchoice := {"WC_LC_NUM", "WC_DT_EMI", "WC_DT_VEN", "WC_PRORROG",;
                      "WC_DT_EMB", "WC_DT_NEG", "WC_TRANSB", "WC_EMB_PAR",;
                      "WC_BANCO", "WC_AGENCIA","WC_VM_BANC",;
                      "WC_PER_FOB", "WC_VLR_ABE","WC_BANCOAV","WC_AGENCAV",;
					  "WC_VM_BAAV","WC_BANCOEM","WC_AGENCEM","WC_VM_BAEM",;
					  "WC_PERVAL"}
RETURN NIL 

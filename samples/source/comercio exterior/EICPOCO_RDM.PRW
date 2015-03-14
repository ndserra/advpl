/*
Autor : Igor de Araújo Chiba
Data  : 02/02/2009
Objetivo: Ponto de entrada para conta e ordem 
*/

#DEFINE FECHTO_EMBARQUE "1"
#DEFINE NFE_PRIMEIRA     1
#DEFINE NFE_UNICA        3

STATIC lImportador := GETMV("MV_PCOIMPO",,.T.)//Se for importador é .T., e Adquirente é .F.

*------------------------------*
User Function EICPOCO(cAcao)
*------------------------------*
Local cExecute
Local aOrd := SaveOrd({"SF1"})
cAcao:=AvCallAct()

//MSGINFO("Acao chamada: "+cAcao)

If ValType(cAcao) == "C"
   cExecute := cAcao
ELSE
   RETURN .T.
EndIf

Do Case
   Case cExecute == "200"//"VALID_PEDIDO_PLI"    //CHAMADO DO EICDI500.PRW

        lValidPOPLI := VALID_PEDIDO()
   
   Case cExecute == "201"//"ANTES_INICIA_SW6_SW9"//CHAMADO DO EICDI500.PRW

        cCpoNaoInicia += ",M->W6_IMPCO,M->W6_IMPENC"   

   Case cExecute == "202"//"ALTERA_AEMBARQUE"    //CHAMADO DO EICDI500.PRW

        IF MOpcao == FECHTO_EMBARQUE
           AADD(aEmbarques,"W6_IMPCO")
        ENDIF
        
        IF !(lImportador .AND. GetMv("MV_EASY",,"N") = "S")
           AADD(aTiraCampos,"W6_PEDFAT")
        ENDIF
        
   Case cExecute == "203"//"GRAVA_SC7"           //CHAMADO DO EIC.PRW

        Busca_FornImp()

   Case cExecute == "204"//"MBROWSE"             //CHAMADO DO EICDI154.PRW
     
        IF !lImportador
           AADD(aRotina,{"Visualiza NFT","U_EICImpPCO(.F.)",0,4})   
           
//         SWN->(DBSETORDER(3)) //Para testes
//         aColors:= {{'SWN->(DBSETORDER(3)),SWN->(DBSEEK(xFilial()+SW6->W6_HAWB+"9"))',"BR_AZUL"},;
//                    {"Empty(SW6->W6_DI_NUM)" ,"DISABLE"},;
//                    {"!Empty(SW6->W6_DI_NUM)","ENABLE" }}

        ENDIF

   Case cExecute == "205"//"INICIA_VARIAVEIS"    //CHAMADO DO EICDI154.PRW

        IF !lExecAuto .AND. !lSoGravaNF .AND. !lImportador .AND. !EMPTY(SW6->W6_IMPCO)
           IF nTipoNF == NFE_PRIMEIRA .OR. nTipoNF == NFE_UNICA
              IF SW6->W6_IMPCO == '1'
                 MSGINFO("Processo Por Conta e Ordem nao pode gerar NFE.")
                 lLoop:=.T.
              ENDIF
           ELSE            
              // By JPP - 24/07/2009 - 16:00 - Inclusão dos tratamentos para gerar nota fiscal complementar de transferência de posse. 
              SF1->(DbSetOrder(5))
              lTemNFT:=SF1->(DbSeek(xFilial("SF1")+SW6->W6_HAWB+"9")) 
              RestOrd(aOrd)
           ENDIF
        ENDIF

   Case cExecute == "206"////CHAMADO DO EICDI154.PRW
        
        IF lSoGravaNF// AWR - 02/02/09 - So Grava a NF
           IF U_EICGrvWork1()//Essa funcao esta no programa EICIMPPCO_RDM.PRW do PCO
              lSair:=.T.
           ENDIF
        ENDIF
   
   Case cExecute == "207"////CHAMADO DO EICFI400.PRW - FI400POS_PO
   		
   		// JWJ - 05/06/09 - Validação se deve gerar PR para o FOB
   		IF lImportador .AND. GETMV("MV_PCOFOB",,.F.) == .F. .AND. SW2->W2_IMPCO == '1'
   			lGeraPR := .F.
   		ENDIF

   Case cExecute == "208"////CHAMADO DO EICFI400.PRW - FI400POS_DI
   		
   		// JWJ - 05/06/09 - Validação se deve gerar PR para o FOB
   		IF lImportador .AND. GETMV("MV_PCOFOB",,.F.) == .F. .AND. SW6->W6_IMPCO == '1'
   			lSair := .T.
   		ENDIF
   		
   Case cExecute == "209"////CHAMADO DO EICPO400.PRW - "VALID" // AWR 01/12/2009
   		
   		IF M->W2_IMPCO == '1'.AND. M->W2_IMPENC == '1'
           MSGINFO("Pedido nao pode ser Conta e Ordem e Encomenda ao mesmo tempo.")
           lValido := .F.
   		ENDIF
   		
EndCase

Return .T.

/*
Autor : Igor de Araújo Chiba
Data  : 02/02/2009
Objetivo: Mudar o fornecedor e a loja,deixar o mesmo do SYT, para serem gravados no pedido de compra do SIGACOM
*/

*------------------------------*
Static Function Busca_FornImp()
*------------------------------*
Local nOldOrder 

IF !lImportador .AND. SW2->W2_IMPCO = "1"
   nOldOrder := SYT->(INDEXORD())
   SYT->(DBSETORDER(1))
   IF SYT->(DBSEEK(xFilial("SYT")+ AVKEY(SW2->W2_IMPORT,"W2_IMPORT") ))
      cFornece  := SYT->YT_FORN
      cLoja     := SYT->YT_LOJA                                      
   ENDIF
   SYT->(DBSETORDER(nOldOrder))
ENDIF

Return .T. 

/*
Autor : Igor de Araújo Chiba
Data  : 18/02/2009
Objetivo: Validar se todos os pedidos estao com o mesmo IMPCO da capa do processo 
*/
*------------------------------*
Static Function VALID_PEDIDO()
*------------------------------*
IF EMPTY(M->W6_IMPCO)
   IF SW2->W2_IMPCO='1'
      M->W6_IMPCO := '1'
   ELSE
      M->W6_IMPCO := '2'
   ENDIF

ELSE //W6 preenchido 1 ou 2
   IF M->W6_IMPCO == '1'
      IF SW2->W2_IMPCO <> '1'
         Alert('Pedido tem que ser de importacao por conta e ordem')
         RETURN .F.       
      ENDIF        
   ELSE //W6=2 
      IF SW2->W2_IMPCO == '1'
         Alert('Pedido nao pode ser de importacao por conta e ordem')
         RETURN .F.       
      ENDIF        
   ENDIF
ENDIF
// AWR 02/12/2009
IF EMPTY(M->W6_IMPENC)
   IF SW2->W2_IMPENC='1'
      M->W6_IMPENC := '1'
   ELSE
      M->W6_IMPENC := '2'
   ENDIF

ELSE //W6 preenchido 1 ou 2
   IF M->W6_IMPENC == '1'
      IF SW2->W2_IMPENC <> '1'
         Alert('Pedido tem que ser de encomenda')
         RETURN .F.       
      ENDIF        
   ELSE //W6=2 
      IF SW2->W2_IMPENC == '1'
         Alert('Pedido nao pode ser de encomenda')
         RETURN .F.       
      ENDIF        
   ENDIF
ENDIF
// AWR 02/12/2009
RETURN .T.

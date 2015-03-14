#INCLUDE "EECPEM17.ch"

/*
Programa        : EECPEM17.PRW
Objetivo        : RESERVA DE PRACA
Autor           : Flavio Yuji Arakaki
Data/Hora       : 11/10/1999 11:10
Obs.            : 
*/                

/*
considera que estah posicionado no registro de processos (embarque) (EEC)
*/

#include "EECRDM.CH"

/*
Funcao      : EECPEM17
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : Flavio Yuji Arakaki
Data/Hora   : 11/10/1999 11:10
Revisao     :
Obs.        :
*/
User Function EECPEM17

Local lRet := .T.
Local nAlias := Select()
Local aOrd   := SaveOrd({"EE9","SA2","SA1","SYA","EEB","SYR","EE6"})

Local cEMB_ATTN := "",cEMB_FAX := "",cEMB_NOME := "",cEMB_FONE := ""
Local cARMA_NOME := "",cDESP_NOME := "",cDESP_ATTN := "",cDESP_FONE := ""
Local cFOR_CONTATO,cFOR_FONE,cFOR_FAX
Local cIMP_NOME,cIMP_END,cIMP_BAIRRO,cIMP_MUN,cIMP_EST    
Local cNOPADES,cDESTINO
Local cETAETD,cETA,cETD

Local mProd,nLProd,nLAtu
Local cVOLUME
                                                                      
Private cNResP := SPACE(20)                                           

Begin Sequence

   SA2->(DBSETORDER(1))
   SA1->(DBSETORDER(1))              
   SYA->(DBSETORDER(1))  
   EEB->(DBSETORDER(1))          
   SYR->(DBSETORDER(1))
   
   IF ! TelaGets()
      lRet := .F.
      Break
   Endif               

   //regras para carregar dados 
   cEMB_NOME := BuscaEmpresa(EEC->EEC_PREEMB,OC_EM,CD_AGE)
   cEMB_ATTN := ALLTRIM(EECCONTATO(CD_SY5,EEB->EEB_CODAGE,,"1",1)) //nome do contato seq 1
   cEMB_FAX  := ALLTRIM(EECCONTATO(CD_SY5,EEB->EEB_CODAGE,,"1",7)) //fax do contato seq 1 
   cEMB_FONE := ALLTRIM(EECCONTATO(CD_SY5,EEB->EEB_CODAGE,,"1",4)) //fone do contato seq 1  
   
   cDESP_NOME:= BuscaEmpresa(EEC->EEC_PREEMB,OC_EM,CD_DES)
   cDESP_ATTN:= ALLTRIM(EECCONTATO(CD_SY5,EEB->EEB_CODAGE,,"1",1)) //nome do contato seq 1
   cDESP_FONE:= ALLTRIM(EECCONTATO(CD_SY5,EEB->EEB_CODAGE,,"1",4)) //fone do contato seq 1
   
   cARMA_NOME:= BuscaEmpresa(EEC->EEC_PREEMB,OC_EM,CD_ARM)
      
   IF Empty(cEMB_NOME)                                                                                  
      HELP(" ",1,"AVG0005050") //MSGINFO("Não existe Agente Embarcador cadastrado.","Aviso")
      lRet := .F.                                                                                  
      Break
   ENDIF                                                                                            
   
   // FORNECEDOR                                              
   cFOR_CONTATO :=EECCONTATO(CD_SA2,EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",1,EEC->EEC_RESPON)  //nome do contato seq 1     
   cFOR_FONE    :=EECCONTATO(CD_SA2,EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",4,EEC->EEC_RESPON)  //fone do contato seq 1     
   cFOR_FAX     :=EECCONTATO(CD_SA2,EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",7,EEC->EEC_RESPON)  //fax do contato seq 1      
   
   cFOR_CONTATO :=ALLTRIM(cFOR_CONTATO)
   cFOR_FONE    :=ALLTRIM(cFOR_FONE)
   cFOR_FAX     :=ALLTRIM(cFOR_FAX)
   
   // EXPORTADOR       
   IF !EMPTY(EEC->EEC_EXPORT)
      cEXP_NOME    := POSICIONE("SA2",1,xFilial("SA2")+EEC->EEC_EXPORT+EEC->EEC_EXLOJA,"A2_NOME")
   ELSE
      cEXP_NOME    := POSICIONE("SA2",1,xFilial("SA2")+EEC->EEC_FORN+EEC->EEC_FOLOJA,"A2_NOME")   
   ENDIF       
       
   // IMPORTADOR
   IF !EMPTY(EEC->EEC_IMPODE) .AND. ;                                                
      SA1->(DBSEEK(xFilial("SA1")+EEC->EEC_IMPORT+EEC->EEC_IMLOJA))              
      cIMP_NOME   := EEC->EEC_IMPODE 
      IF EMPTY(EEC->EEC_ENDIMP) //RUA+BAIRRO
         cIMP_END    := SA1->A1_END     
         cIMP_BAIRRO := SA1->A1_BAIRRO  
      ENDIF
      IF EMPTY(EEC->EEC_END2IM)
         cIMP_MUN    := SA1->A1_MUN 
         cIMP_EST    := SA1->A1_EST                        
      ENDIF        
   ELSEIF SA1->(DBSEEK(xFilial("SA1")+EEC->EEC_IMPORT+EEC->EEC_IMLOJA))               
      cIMP_NOME   := SA1->A1_NOME
      cIMP_END    := SA1->A1_END        
      cIMP_BAIRRO := SA1->A1_BAIRRO     
      cIMP_MUN    := SA1->A1_MUN        
      cIMP_EST    := SA1->A1_EST        
   ENDIF  
   
   cNOPADES := "" 
   cDESTINO := SPACE(AVSX3("Y9_DESCR",3))
  
   IF !EMPTY(EEC->EEC_ORIGEM) .AND. !EMPTY(EEC->EEC_DEST) .AND. SYR->(DBSEEK(xFilial("SYR")+EEC->EEC_VIA+EEC->EEC_ORIGEM+EEC->EEC_DEST+EEC->EEC_TIPTRA))  
      cPAISDES := Posicione("SYR",1,xFilial("SYR")+EEC->EEC_VIA+EEC->EEC_ORIGEM+EEC->EEC_DEST+EEC->EEC_TIPTRA,"YR_PAIS_DE")
      cDESTINO := Posicione("SYR",1,xFilial("SYR")+EEC->EEC_VIA+EEC->EEC_ORIGEM+EEC->EEC_DEST+EEC->EEC_TIPTRA,"YR_CID_DES")   
      cNOPADES := Posicione("SYA",1,xFilial("SYA")+cPAISDES,"YA_DESCR")     
   ENDIF      
   
   cDESTINO := ALLTRIM(cDESTINO)    
        
   cETAETD := ""     
   IF MONTH(EEC->EEC_ETA) == MONTH(EEC->EEC_ETD) .AND. !EMPTY(EEC->EEC_ETA) .AND. !EMPTY(EEC->EEC_ETD)
      cETAETD := STR(DAY(EEC->EEC_ETA),2)+"-"+STR(DAY(EEC->EEC_ETD),2)+"/"+UPPER(MesExtenso(MONTH(EEC->EEC_ETA)))+"/"+SUBSTR(STR(YEAR(EEC->EEC_ETA),4),3,2)
   ELSEIF !EMPTY(EEC->EEC_ETA) .AND. !EMPTY(EEC->EEC_ETD) 
      cETA := STR(DAY(EEC->EEC_ETA),2)+"/"+UPPER(MesExtenso(MONTH(EEC->EEC_ETA)))+"/"+SUBSTR(STR(YEAR(EEC->EEC_ETA),4),3,2)     
   ELSEIF (EMPTY(EEC->EEC_ETA).AND.!EMPTY(EEC->EEC_ETD))                                                 
      cETAETD := "  /  /  "+"-"+STR(DAY(EEC->EEC_ETD),2)+"/"+UPPER(MesExtenso(MONTH(EEC->EEC_ETD)))+"/"+SUBSTR(STR(YEAR(EEC->EEC_ETD),4),3,2) 
   ELSEIF (!EMPTY(EEC->EEC_ETA) .AND. EMPTY(EEC->EEC_ETD)) 
      cETAETD := STR(DAY(EEC->EEC_ETA),2)+"/"+UPPER(MesExtenso(MONTH(EEC->EEC_ETA)))+"/"+SUBSTR(STR(YEAR(EEC->EEC_ETA),4),3,2)+"-"+"  /  /  "
   ENDIF           
   
   cETD := "  /  /  "
   IF !EMPTY(EEC->EEC_ETD)
      cETD := STR(DAY(EEC->EEC_ETD),2)+"/"+UPPER(MesExtenso(MONTH(EEC->EEC_ETD)))+"/"+SUBSTR(STR(YEAR(EEC->EEC_ETD),4),3,2)      
   ENDIF       
   
   cETADES := "  /  / "
   IF !EMPTY(EEC->EEC_ETADES)
      cETADES := STR(DAY(EEC->EEC_ETADES),2)+"/"+UPPER(MesExtenso(MONTH(EEC->EEC_ETADES)))+"/"+SUBSTR(STR(YEAR(EEC->EEC_ETADES),4),3,2)  
   ENDIF    
                
   //gerar arquivo padrao de edicao de carta
   IF ! E_AVGLTT("G")
      lRet := .F.
      Break
   Endif
    
   //adicionar registro no AVGLTT
   AVGLTT->(DBAPPEND())
   
   //gravar dados a serem editados
   AVGLTT->AVG_CHAVE :=EEC->EEC_PREEMB //nr. do processo
   AVGLTT->AVG_C01_60:=cEXP_NOME
   AVGLTT->AVG_C02_60:=WORKID->EEA_TITULO
   
   //carregar detalhe
   mDETALHE:=STR0001+ALLTRIM(cEMB_NOME)+ENTER //"EMPRESA       "
   mDETALHE:=mDETALHE+STR0002+cEMB_ATTN+ENTER //"AT            "
   mDETALHE:=mDETALHE+STR0003+cEMB_FAX+ENTER //"FAX           "
   mDETALHE:=mDETALHE+STR0004+cEMB_FONE+ENTER //"FONE          "
   mDETALHE:=mDETALHE+SPACE(60)+StrZero(DAY(dDATABASE),2)+"/"+UPPER(MesExtenso(MONTH(dDATABASE)))+"/"+SUBSTR(STR(YEAR(dDATABASE),4),3,2)+ENTER
   mDETALHE:=mDETALHE+ENTER+ENTER
   mDETALHE:=mDETALHE+STR0005+ENTER //"CONFORME CONTATO TELEFONICO MANTIDO COM V.SA. FAVOR PROVIDENCIAR A RESERVA DE"
   mDETALHE:=mDETALHE+STR0006+ENTER //"ESPACO CONFORME DETALHES ABAIXO."
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+STR0007+ENTER //"***  QUANDO DA CONFIRMACAO VIA FAX, GENTILEZA MENCIONAR O NUMERO DA NOSSA"
   mDETALHE:=mDETALHE+STR0008+ENTER                                    //"REFERENCIA, AGENTE DE DESTINO, SE SERA COM TRANSBORDO E CASO POSITIVO, DETALHES"
   mDETALHE:=mDETALHE+STR0009+ENTER //"DO NAVIO QUE FARA A CONEXAO. ***"
   mDETALHE:=mDETALHE+ENTER+ENTER 
   mDETALHE:=mDETALHE+STR0010+ALLTRIM(cNResP)+ENTER //"                          RESERVA DE PRACA  NR "
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+STR0011+LEFT(EEC->EEC_PREEMB,15)+STR0012+cIMP_NOME+ENTER  //"N/REF.:   "###" CLIENTE: "
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+STR0013+Posicione("EE6",1,xFilial("EE6")+EEC->EEC_EMBARC,"EE6_NOME")+ENTER //"# NAVIO                   => "
   mDETALHE:=mDETALHE+STR0014+cDESTINO+"/"+cNOPADES+ENTER    //"# PORTO                   => "
   mDETALHE:=mDETALHE+STR0015+cARMA_NOME+ENTER //"# ARMADOR                 => "
   
   IF MONTH(EEC->EEC_ETA) == MONTH(EEC->EEC_ETD) .AND. !EMPTY(EEC->EEC_ETA) .AND. !EMPTY(EEC->EEC_ETD)
      mDETALHE:=mDETALHE+STR0016+cETAETD+ENTER    //"# ETA/ETS ORIGEM          => "
   ELSEIF (EMPTY(EEC->EEC_ETA) .AND. !EMPTY(EEC->EEC_ETD)) .OR. (!EMPTY(EEC->EEC_ETA) .AND. EMPTY(EEC->EEC_ETD)) 
      mDETALHE:=mDETALHE+STR0016+cETAETD+ENTER  //"# ETA/ETS ORIGEM          => "
   ELSEIF EMPTY(EEC->EEC_ETA) .AND. EMPTY(EEC->EEC_ETD)  
      mDETALHE:=mDETALHE+STR0016+ENTER //"# ETA/ETS ORIGEM          => "
   ELSE
      mDETALHE:=mDETALHE+STR0016 +cETA+"-"+ALLTRIM(cETD)+ENTER  //"# ETA/ETS ORIGEM          => "
   ENDIF      
   
   mDETALHE:=mDETALHE+STR0017+cETADES+ENTER //"# ETA DESTINO             => "
   mDETALHE:=mDETALHE+STR0018+ENTER //"# DATA ENTREGA CARGA/DOCS.=> FAVOR INFORMAR"
   mDETALHE:=mDETALHE+STR0019+ENTER   //"# LOCAL P/ENTREGA-DA CARGA=> FAVOR INFORMAR"
   mDETALHE:=mDETALHE+STR0020+cDESP_NOME+ENTER                             //"# DESPACHANTE             => "
   mDETALHE:=mDETALHE+STR0021+cDESP_FONE+" "+cDESP_ATTN+ENTER //"# FONE / CONTATO          => "
   
   EE9->(DBSETORDER(4))
   EE9->(DBSEEK(xFILIAL()+EEC->EEC_PREEMB))
   mDETALHE:=mDETALHE+STR0022 //"# MERCADORIA              => "
   WHILE EE9->(!EOF()) .AND. xFILIAL("EE9")==EE9->EE9_FILIAL .AND. EEC->EEC_PREEMB==EE9->EE9_PREEMB 
      mProd := MSMM(EE9->EE9_DESC,AVSX3("EE9_VM_DES",3))
      nLProd := MLCOUNT(mProd,AVSX3("EE9_VM_DES",3))  
      nLAtu := 0                                      
      
      FOR nLAtu := 1 to nLProd 
        IF nLAtu > 1
           mDetalhe := mDETALHE + "                             "+MEMOLINE(mProd,AVSX3("EE9_VM_DES",3),nLAtu)+ENTER    
        ELSE
           mDetalhe := mDETALHE + MEMOLINE(mProd,AVSX3("EE9_VM_DES",3),nLAtu)+ENTER    
        ENDIF                         
      NEXT                                                                          
      mDETALHE:=mDETALHE+ENTER
      mDETALHE:=mDETALHE+"                             "
      EE9->(DBSKIP())
   ENDDO
   
   cVOLUME := Posicione("EE5",1,xFilial("EE5")+EEC->EEC_EMBAFI,"EE5_DESC")
   
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+STR0023+cVOLUME+ENTER //"# EMBALAGEM FINAL         => "
   mDETALHE:=mDETALHE+STR0024+ALLTRIM(EEC->EEC_QUANTI)+ENTER //"# TOTAL DE EMBALAGENS     => "
   mDETALHE:=mDETALHE+STR0025+TRANSFORM(EEC->EEC_PESBRU,AVSX3("EEC_PESBRU",6))+ENTER //"# P. BRUTO TOTAL - KG     => "
   mDETALHE:=mDETALHE+STR0026+TRANSFORM(EEC->EEC_CUBAGE,AVSX3("EEC_CUBAGE",6))+ENTER //"# M3 TOTAL                => "
   mDETALHE:=mDETALHE+STR0027+EEC->EEC_MOEDA+" "+TRANSFORM(EEC->EEC_FRPREV,AVSX3("EEC_FRPREV",6))+ENTER //"# FRETE                   => "

   mDETALHE:=mDETALHE+STR0028+ ENTER //"                          => FAVOR CONFIRMAR"
   mDETALHE:=mDETALHE+STR0029+ALLTRIM(cNResP)+ENTER //"# S/RESERVA               => "
   mDETALHE:=mDETALHE+STR0030+ENTER+ENTER //"# OBSERVACOES             => "
   
   mDETALHE:=mDETALHE+STR0031+ENTER //"ATENCIOSAMENTE "
   mDETALHE:=mDETALHE+ENTER         
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+cFOR_CONTATO+ENTER                
   mDETALHE:=mDETALHE+STR0032+cFOR_FONE+ENTER //"FONE: "
   mDETALHE:=mDETALHE+STR0033+cFOR_FAX+ENTER     //"FAX : "
   
   //gravar detalhe
   AVGLTT->WK_DETALHE := mDETALHE

   cSEQREL :=GetSXENum("SY0","Y0_SEQREL")
   CONFIRMSX8()
   
   //executar rotina de manutencao de caixa de texto
   lRet := E_AVGLTT("M",WORKID->EEA_TITULO)
   
End Sequence

RestOrd(aOrd)
Select(nAlias)

Return lRet

/*
Funcao      : TelaGets
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       :
Data/Hora   :
Revisao     :
Obs.        :
*/
Static Function TelaGets

Local nOpcA := 0
Local oDlg

//Local bOk    := {||nOpcA:=1,IF(!Empty(cNResP),oDlg:End(),(MSGINFO("Deve ser preenchido o No. da reserva de praça","Aviso"),nOpcA:=0))}
Local bOk    := {||nOpcA:=1,IF(!Empty(cNResP),oDlg:End(),(HELP(" ",1,"AVG0005051"),nOpcA:=0))}
Local bCancel:= {||oDlg:End()}                                                         

Begin Sequence
   
   DEFINE MSDIALOG oDlg TITLE AllTrim(WorkId->EEA_TITULO) FROM 10,0 TO 18,50 OF oMainWnd
      
      @ 23,10 SAY STR0034 SIZE 80,8 PIXEL //"RESERVA DE PRAÇA NR "
      @ 23,90 MSGET cNResP PICTURE "@!" VALID NaoVazio() SIZE 30,8 PIXEL
            
   ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,bOk,bCancel)
                                                                                                          
End Sequence

Return nOpcA == 1

*------------------------------------------------------------------------------*
* FIM DO PROGRAMA EECPEM17.PRW                                                 *
*------------------------------------------------------------------------------*

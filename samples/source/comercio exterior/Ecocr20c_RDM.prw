#INCLUDE "Ecocr20c.ch"
#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 01/12/99
#Include "Average.Ch"


User Function Ecocr20c()        // incluido pelo assistente de conversao do AP5 IDE em 01/12/99

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CTRAVAALIAS,LTRAVA,PDESCCPO,PDATA,PDESC,PDESCRICAO")
SetPrvt("PCAMPO,PINVOICE,PTIPO_INT,PENVIO,PEXISTE,PSTATUS,PFORN")
SetPrvt("MALTEROU,MTROCADT,MPO_NUM_A,MFOB_VLR,MINVOICE_A,MIDENTCT_A,MFORN_A,MMOEDA_A")
SetPrvt("MVALOR_FOB,MTROCA_FOB,MMEMO,MCONTA_DI,CAUXFOR,MVLR_FOB")

#xTranslate CR200LOCK(<cTravaAlias>,<lTrava>) => ;
                      Eval({|| cTravaAlias:=<cTravaAlias>,;
                               lTrava     :=<lTrava>,;
                               ExecBlock("ECOCR20B",.F.,.F.,1)})
                      
#xTranslate CR200Existe(<PDescCpo>) => Eval({|| PDescCpo := <PDescCpo>,;
                                                ExecBlock("ECOCR20B",.F.,.F.,2)})

#xTranslate CR200_VerDt(<PData>,<PDesc>,<PDescricao>) => ;
                            Eval({|| PData     :=<PData>,;
                                     PDesc     :=<PDesc>,;
                                     PDescricao:=<PDescricao>,;
                                     ExecBlock("ECOCR20B",.F.,.F.,3)})

#xTranslate CR200_Verif(<PDescCpo>,<PData>,<PCampo>,<PDescricao>) => ;
                                Eval({|| PDescCpo  :=<PDescCpo>,;
                                         PData     :=<PData>,; 
                                         PCampo    :=<PCampo>,;
                                         PDescricao:=<PDescricao>,;
                                         ExecBlock("ECOCR20B",.F.,.F.,4)})

#xTranslate CR200_Cod(<PDescCpo>,<PData>,<PCampo>) => ;
                                 Eval({|| PDescCpo:=<PDescCpo>,;
                                          PData   :=<PData>,;
                                          PCampo  :=<PCampo>,;
                                          ExecBlock("ECOCR20B",.F.,.F.,5)})

//#xTranslate CR200Inv_For(<PInvoice>,<PForn>) => Eval({|| PInvoice := <PInvoice>, PForn := <PForn>,;
//                                                ExecBlock("ECOCR20B",.F.,.F.,6)})

#xTranslate CR200_Crit(<PTipo_Int>,<PDesc>,<PEnvio>,<PExiste>,<PStatus>) => ;
                                 Eval({|| PTipo_Int:=<PTipo_Int>,;
                                          PDesc    :=<PDesc>,;
                                          PEnvio   :=<PEnvio>,;
                                          PExiste  :=<PExiste>,;
                                          PStatus  :=<PStatus>,;
                                          ExecBlock("ECOCR20B",.F.,.F.,7)})                                          
                                          
cFilSA2:=xFilial('SA2');cFilEC5:=xFilial('EC5');cFilEC6:=xFilial('EC6');cFilECC:=xFilial('ECC')
cFilEC2:=xFilial('EC2');cFilEC8:=xFilial('EC8');cFilEC9:=xFilial('EC9');cFilEC4:=xFilial('EC4')
cFilEC0:=xFilial('EC0')

IF ! EC2->EC2_FIM_CT $ cSim
   MAlterou := .F.
   CR200LOCK("EC2",.F.)
   IF EC2->EC2_HAWB #DI_Ctb->DIHAWB
      IF ! EMPTY(ALLTRIM(DI_Ctb->DIHAWB)) .AND. EMPTY(ALLTRIM(EC2->EC2_HAWB))
         CR200_Crit("2",STR0001,DI_Ctb->DIHAWB,EC2->EC2_HAWB,"2") //"NUMERO DO H.A.W.B."
         EC2->EC2_HAWB := DI_Ctb->DIHAWB
         MAlterou := .T.
      ELSE
         CR200_Crit("2",STR0001,DI_Ctb->DIHAWB,EC2->EC2_HAWB,"3") //"NUMERO DO H.A.W.B."
      ENDIF
   ENDIF

   IF EC2->EC2_DI_NUM # TransDI("EC2_DI_NUM",DI_Ctb->DIDI_NUM)//DI_Ctb->DIDI_NUM
      IF ! EMPTY(DI_Ctb->DIDI_NUM) .AND. EMPTY(EC2->EC2_DI_NUM)
         CR200_Crit("2",STR0002,TRANSF(DI_Ctb->DIDI_NUM, '@R 99/9999999-9'),TRANSF(EC2->EC2_DI_NUM, '@R 99/9999999-9'),"2") //"NUMERO DA D.I."
         EC2->EC2_DI_NUM := TransDI("EC2_DI_NUM",DI_Ctb->DIDI_NUM)//DI_Ctb->DIDI_NUM,10,0)
         MAlterou := .T.
      ELSE
         CR200_Crit("2",STR0002,TRANSF(DI_Ctb->DIDI_NUM, '@R 99/9999999-9'),TRANSF(EC2->EC2_DI_NUM, '@R 99/9999999-9'),"3") //"NUMERO DA D.I."
      ENDIF
   ENDIF

   IF EC2->EC2_DESP # DI_Ctb->DIDESP                                     && LAB 08.05.00
      IF ! EMPTY(DI_Ctb->DIDESP) .AND. EMPTY(EC2->EC2_DESP)
         CR200_Crit("2",STR0003,DI_Ctb->DIDESP,EC2->EC2_DESP,"2") //"DESPACHANTE"
         EC2->EC2_DESP := DI_Ctb->DIDESP                                 && LAB 08.05.00
         MAlterou := .T.
      ELSE
         CR200_Crit("2",STR0003,DI_Ctb->DIDESP,EC2->EC2_DESP,"3") //"DESPACHANTE"
      ENDIF
   ENDIF

   IF ALLTRIM(EC2->EC2_LOTE) #ALLTRIM(DI_Ctb->DILOTE)
      IF ! EMPTY(DI_Ctb->DILOTE) .AND. EMPTY(EC2->EC2_LOTE)
         CR200_Crit("2",STR0004,DI_Ctb->DILOTE,EC2->EC2_LOTE,"2") //"NUMERO DO LOTE"
         EC2->EC2_LOTE := DI_Ctb->DILOTE
         MAlterou := .T.
      ELSE
         CR200_Crit("2",STR0004,DI_Ctb->DILOTE,EC2->EC2_LOTE,"3") //"NUMERO DO LOTE"
      ENDIF
   ENDIF

   IF EC2->EC2_NF_ENT #DI_Ctb->DINF_ENT
      IF ! EMPTY(DI_Ctb->DINF_ENT) .AND. EMPTY(EC2->EC2_NF_ENT)
         CR200_Crit("2",STR0005,DI_Ctb->DINF_ENT,EC2->EC2_NF_ENT,"2") //"NUMERO DA N.F. ENTR."
         EC2->EC2_NF_ENT := DI_Ctb->DINF_ENT
         MAlterou := .T.
      ELSE
         CR200_Crit("2",STR0005,DI_Ctb->DINF_ENT,EC2->EC2_NF_ENT,"3") //"NUMERO DA N.F. ENTR."
      ENDIF
   ENDIF

   IF EC2->EC2_DTENCE #DI_Ctb->DIDT_ENCE   && LAB 24.05.99
      IF ! EMPTY(DI_Ctb->DIDT_ENCE) .AND. EMPTY(EC2->EC2_DTENCE)
         CR200_Crit("2",STR0006,dtoc(DI_Ctb->DIDT_ENCE),dtoc(EC2->EC2_DTENCE),"2") //"DATA DO RECEBTO FISCAL"
         EC2->EC2_DTENCE := DI_Ctb->DIDT_ENCE
         MAlterou := .T.
      ELSE
         CR200_Crit("2",STR0006,dtoc(DI_Ctb->DIDT_ENCE),dtoc(EC2->EC2_DTENCE),"3") //"DATA DO RECEBTO FISCAL"
      ENDIF
   ENDIF

   IF EC2->EC2_SUB_SE #DI_Ctb->DISUB_SET
      IF ! EMPTY(DI_Ctb->DISUB_SET) .AND. EMPTY(EC2->EC2_SUB_SE)
         CR200_Crit("2",STR0007,DI_Ctb->DISUB_SET,EC2->EC2_SUB_SE,"2") //"NUMERO DA D.A.I."
         EC2->EC2_SUB_SE := DI_Ctb->DISUB_SET
         MAlterou := .T.
      ELSE
         CR200_Crit("2",STR0007,DI_Ctb->DISUB_SET,EC2->EC2_SUB_SE,"3") //"NUMERO DA D.A.I."
      ENDIF
   ENDIF

   IF EC2->EC2_NF_COM #DI_Ctb->DINF_COMP
      IF ! EMPTY(DI_Ctb->DINF_COMP) .AND. EMPTY(EC2->EC2_NF_COM)
         CR200_Crit("2",STR0008,DI_Ctb->DINF_COMP,EC2->EC2_NF_COM,"2") //"NUMERO DA N.F. COMP."
         EC2->EC2_NF_COM := DI_Ctb->DINF_COMP
         MAlterou := .T.
      ELSE
         CR200_Crit("2",STR0008,DI_Ctb->DINF_COMP,EC2->EC2_NF_COM,"3") //"NUMERO DA N.F. COMP."
      ENDIF
   ENDIF

   EC2->(MSUNLOCK())

   IF DI_Ctb->DIVL_DCI #0
      IF CR200Existe("DIVL_DCI")
         CR200_Verif("DIVL_DCI",DI_Ctb->DIDT_DCI,DI_Ctb->DIVL_DCI,"D.C.I.")
      ELSE
         CR200_Cod("DIVL_DCI",DI_Ctb->DIDT_DCI,DI_Ctb->DIVL_DCI)
         CR200_Crit("2",STR0009,ALLTRIM(TRANS(DI_Ctb->DIVL_DCI,'@E 999,999,999,999.99')),SPACE(20),"2") //"PAGO PELO IMPORTADOR"
         MAlterou := .T.
      ENDIF
   ENDIF

   IF DI_Ctb->DIICMS_C #0
      IF CR200Existe("DIICMS_C")
         CR200_Verif("DIICMS_C",DI_Ctb->DIDT,DI_Ctb->DIICMS_C,"COMP.ARM.")
      ELSE
         CR200_Cod("DIICMS_C",DI_Ctb->DIDT,DI_Ctb->DIICMS_C)
         CR200_Crit("2",STR0010,ALLTRIM(TRANS(DI_Ctb->DIICMS_C,'@E 999,999,999,999.99')),SPACE(20),"2") //"ICMS PAGO PELO IMP."
         MAlterou := .T.
      ENDIF
   ENDIF

   IF DI_Ctb->DIVL_DAP #0
      IF CR200Existe("DIVL_DAP")
         CR200_Verif("DIVL_DAP",DI_Ctb->DIDT_ARMZ,DI_Ctb->DIVL_DAP,"ARM. DAP")
      ELSE
         CR200_Cod("DIVL_DAP",DI_Ctb->DIDT_ARMZ,DI_Ctb->DIVL_DAP)
         CR200_Crit("2",STR0011,ALLTRIM(TRANS(DI_Ctb->DIVL_DAP,'@E 999,999,999,999.99')),SPACE(20),"2") //"MULTAS PAGA PELO IMP."
         MAlterou := .T.
      ENDIF
   ENDIF

   IF DI_Ctb->DIVL_FRETE #0
      IF CR200Existe("DIVL_FRETE")
         CR200_Verif("DIVL_FRETE",DI_Ctb->DIDT,DI_Ctb->DIVL_FRETE,"FRETE")
      ELSE
         CR200_Cod("DIVL_FRETE",DI_Ctb->DIDT,DI_Ctb->DIVL_FRETE)
         CR200_Crit("2",STR0012,ALLTRIM(TRANS(DI_Ctb->DIVL_FRETE,'@E 999,999,999,999.99')),SPACE(20),"2") //"VALOR DE FRETE"
         MAlterou := .T.
      ENDIF
   ENDIF

   IF DI_Ctb->DIVL_II #0
      IF CR200Existe("DIVL_II")
         CR200_Verif("DIVL_II",DI_Ctb->DIDT_ENTR,DI_Ctb->DIVL_II,"I.I.")
      ELSE
         CR200_Cod("DIVL_II",DI_Ctb->DIDT_ENTR,DI_Ctb->DIVL_II)
         CR200_Crit("2",STR0013,ALLTRIM(TRANS(DI_Ctb->DIVL_II,'@E 999,999,999,999.99')),SPACE(20),"2") //"I.I."
         MAlterou := .T.
      ENDIF
   ENDIF

   IF DI_Ctb->DIVL_IPI #0
      IF CR200Existe("DIVL_IPI")
         CR200_Verif("DIVL_IPI",DI_Ctb->DIDT_ENTR,DI_Ctb->DIVL_IPI,"I.P.I.")
      ELSE
         CR200_Cod("DIVL_IPI",DI_Ctb->DIDT_ENTR,DI_Ctb->DIVL_IPI)
         CR200_Crit("2",STR0014,ALLTRIM(TRANS(DI_Ctb->DIVL_IPI,'@E 999,999,999,999.99')),SPACE(20),"2") //"I.P.I."
         MAlterou := .T.
      ENDIF
   ENDIF

   IF DI_Ctb->DIVL_ICMS #0
      IF CR200Existe("DIVL_ICMS")
         CR200_Verif("DIVL_ICMS",DI_Ctb->DIDT_ENTR,DI_Ctb->DIVL_ICMS,"ICMS")
      ELSE
         CR200_Cod("DIVL_ICMS",DI_Ctb->DIDT_ENTR,DI_Ctb->DIVL_ICMS)
         CR200_Crit("2",STR0015,ALLTRIM(TRANS(DI_Ctb->DIVL_ICMS,'@E 999,999,999,999.99')),SPACE(20),"2") //"ICMS PAGO PELO DESP."
         MAlterou := .T.
      ENDIF
   ENDIF

   IF DI_Ctb->DIVL_ARM #0
      IF CR200Existe("DIVL_ARM")
         CR200_Verif("DIVL_ARM",DI_Ctb->DIDT_ARMZ,DI_Ctb->DIVL_ARM,"ARM.AEREO")
      ELSE
         CR200_Cod("DIVL_ARM",DI_Ctb->DIDT_ARMZ,DI_Ctb->DIVL_ARM)
         CR200_Crit("2",STR0016,ALLTRIM(TRANS(DI_Ctb->DIVL_ARM,'@E 999,999,999,999.99')),SPACE(20),"2") //"MULTAS PAGA PELO DESP."
         MAlterou := .T.
      ENDIF
   ENDIF

   IF DI_Ctb->DIVL_DESP #0
      IF CR200Existe("DIVL_DESP")
         CR200_Verif("DIVL_DESP",DI_Ctb->DIDTP_DESP,DI_Ctb->DIVL_DESP,"COM.DESP.")
      ELSE
         CR200_Cod("DIVL_DESP",DI_Ctb->DIDTP_DESP,DI_Ctb->DIVL_DESP)
         CR200_Crit("2",STR0017,ALLTRIM(TRANS(DI_Ctb->DIVL_DESP,'@E 999,999,999,999.99')),SPACE(20),"2") //"PAGO PELO DESPACHANTE"
         MAlterou := .T.
      ENDIF
   ENDIF

   IF DI_Ctb->DIDESP_GI #0
      IF CR200Existe("DIDESP_GI")
         CR200_Verif("DIDESP_GI",DI_Ctb->DIDT_ARMZ,DI_Ctb->DIDESP_GI,"DESP.GUIA")
      ELSE
         CR200_Cod("DIDESP_GI",DI_Ctb->DIDT_ARMZ,DI_Ctb->DIDESP_GI)
         CR200_Crit("2",STR0018,ALLTRIM(TRANS(DI_Ctb->DIDESP_GI,'@E 999,999,999,999.99')),SPACE(20),"2") //"ICMS S/ MULTAS - DESP."
         MAlterou := .T.
      ENDIF
   ENDIF

   IF DI_Ctb->DIDESP_CL #0
      IF CR200Existe("DIDESP_CL")
         CR200_Verif("DIDESP_CL",DI_Ctb->DIDT_ARMZ,DI_Ctb->DIDESP_CL,"DESP.COMP")
      ELSE
         CR200_Cod("DIDESP_CL",DI_Ctb->DIDT_ARMZ,DI_Ctb->DIDESP_CL)
         CR200_Crit("2",STR0019,ALLTRIM(TRANS(DI_Ctb->DIDESP_CL,'@E 999,999,999,999.99')),SPACE(20),"2") //"ICMS S/ MULTAS - IMP."
         MAlterou := .T.
      ENDIF
   ENDIF

   IF DI_Ctb->DIFRETE_RO #0
      IF CR200Existe("DIFRETE_RO")
         CR200_Verif("DIFRETE_RO",DI_Ctb->DIDTP_ROD,DI_Ctb->DIFRETE_RO,"FRETE ROD")
      ELSE
         CR200_Cod("DIFRETE_RO",DI_Ctb->DIDTP_ROD,DI_Ctb->DIFRETE_RO)
         CR200_Crit("2",STR0020,ALLTRIM(TRANS(DI_Ctb->DIFRETE_RO,'@E 999,999,999,999.99')),SPACE(20),"2") //"FRETE RODOVIARIO"
         MAlterou := .T.
      ENDIF
   ENDIF

   IF DI_Ctb->DIVL_USSEG #0
      IF CR200Existe("DIVL_USSEG")
         CR200_Verif("DIVL_USSEG",DI_Ctb->DIDT,DI_Ctb->DIVL_USSEG,"SEGURO")
      ELSE
         CR200_Cod("DIVL_USSEG",DI_Ctb->DIDT,DI_Ctb->DIVL_USSEG)
         CR200_Crit("2",STR0021,ALLTRIM(TRANS(DI_Ctb->DIVL_USSEG,'@E 999,999,999,999.99')),SPACE(20),"2") //"SEGURO"
         MAlterou := .T.
      ENDIF
   ENDIF

   IF DI_Ctb->DIVL_APORT #0
      IF CR200Existe("DIVL_APORT")
         CR200_Verif("DIVL_APORT",DI_Ctb->DIDT_ARMZ,DI_Ctb->DIVL_APORT,STR0022) //"ARMAZ. PORTUARIA"
      ELSE
         CR200_Cod("DIVL_APORT",DI_Ctb->DIDT_ARMZ,DI_Ctb->DIVL_APORT)
         CR200_Crit("2",STR0022,ALLTRIM(TRANS(DI_Ctb->DIVL_APORT,'@E 999,999,999,999.99')),SPACE(20),"2") //"ARMAZ. PORTUARIA"
         MAlterou := .T.
      ENDIF
   ENDIF

   IF DI_Ctb->DIVL_AAER #0
      IF CR200Existe("DIVL_AAER")
         CR200_Verif("DIVL_AAER",DI_Ctb->DIDT_ARMZ,DI_Ctb->DIVL_AAER,STR0023) //"ARMAZ. AEREA"
      ELSE
         CR200_Cod("DIVL_AAER",DI_Ctb->DIDT_ARMZ,DI_Ctb->DIVL_AAER)
         CR200_Crit("2",STR0023,ALLTRIM(TRANS(DI_Ctb->DIVL_AAER,'@E 999,999,999,999.99')),SPACE(20),"2") //"ARMAZ. AEREA"
         MAlterou := .T.
      ENDIF
   ENDIF

   IF DI_Ctb->DIVL_ADAP #0
      IF CR200Existe("DIVL_ADAP")
         CR200_Verif("DIVL_ADAP",DI_Ctb->DIDT_ARMZ,DI_Ctb->DIVL_ADAP,STR0024) //"ARMAZ. DAP/MULTITERMINAIS"
      ELSE
         CR200_Cod("DIVL_ADAP",DI_Ctb->DIDT_ARMZ,DI_Ctb->DIVL_ADAP)
         CR200_Crit("2",STR0024,ALLTRIM(TRANS(DI_Ctb->DIVL_ADAP,'@E 999,999,999,999.99')),SPACE(20),"2") //"ARMAZ. DAP/MULTITERMINAIS"
         MAlterou := .T.
      ENDIF
   ENDIF

   IF DI_Ctb->DIVL_701 #0
      IF CR200Existe("DIVL_701")
         CR200_Verif("DIVL_701",DI_Ctb->DIDT_DESEM,DI_Ctb->DIVL_701,STR0025) //"VAR.CAMBIAL (DESEMB.) F.O.B."
      ELSE
         CR200_Cod("DIVL_701",DI_Ctb->DIDT_DESEM,DI_Ctb->DIVL_701)
         CR200_Crit("2",STR0025,ALLTRIM(TRANS(DI_Ctb->DIVL_701,'@E 999,999,999,999.99')),SPACE(20),"2") //"VAR.CAMBIAL (DESEMB.) F.O.B."
         MAlterou := .T.
      ENDIF
   ENDIF

   IF DI_Ctb->DIVL_702 # 0         && LAB 02.05.00
      IF CR200Existe("DIVL_702")
         CR200_Verif("DIVL_702",DI_Ctb->DIDT_DESEM,DI_Ctb->DIVL_702,STR0025) //"VAR.CAMBIAL (DESEMB.) F.O.B."
      ELSE
         CR200_Cod("DIVL_702",DI_Ctb->DIDT_DESEM,DI_Ctb->DIVL_702)
         CR200_Crit("2",STR0025,ALLTRIM(TRANS(DI_Ctb->DIVL_702,'@E 999,999,999,999.99')),SPACE(20),"2") //"VAR.CAMBIAL (DESEMB.) F.O.B."
         MAlterou := .T.
      ENDIF
   ENDIF

   IF DI_Ctb->DIVL_702_P #0
      IF CR200Existe("DIVL_702_P")
         CR200_Verif("DIVL_702_P",DI_Ctb->DIDT_DESEM,DI_Ctb->DIVL_702_P,STR0026) //"VAR.CAMBIAL (DESEMB.) FRETE"
      ELSE
         CR200_Cod("DIVL_702_P",DI_Ctb->DIDT_DESEM,DI_Ctb->DIVL_702_P)
         CR200_Crit("2",STR0026,ALLTRIM(TRANS(DI_Ctb->DIVL_702_P,'@E 999,999,999,999.99')),SPACE(20),"2") //"VAR.CAMBIAL (DESEMB.) FRETE"
         MAlterou := .T.
      ENDIF
   ENDIF

   IF DI_Ctb->DIVL_509 #0
      IF CR200Existe("DIVL_509")
         CR200_Verif("DIVL_509",DI_Ctb->DIDT_DESEM,DI_Ctb->DIVL_509,STR0027) //"VALOR DESPESA 5.09"
      ELSE
         CR200_Cod("DIVL_509",DI_Ctb->DIDT_DESEM,DI_Ctb->DIVL_509)
         CR200_Crit("2",STR0027,ALLTRIM(TRANS(DI_Ctb->DIVL_509,'@E 999,999,999,999.99')),SPACE(20),"2") //"VALOR DESPESA 5.09"
         MAlterou := .T.
      ENDIF
   ENDIF

   IF DI_Ctb->DIVL_620 #0
      IF CR200Existe("DIVL_620")
         CR200_Verif("DIVL_620",DI_Ctb->DIDT_620,DI_Ctb->DIVL_620,STR0028) //"VALOR JUROS"
      ELSE
         CR200_Cod("DIVL_620",DI_Ctb->DIDT_620,DI_Ctb->DIVL_620)
         CR200_Crit("2",STR0028,ALLTRIM(TRANS(DI_Ctb->DIVL_620,'@E 999,999,999,999.99')),SPACE(20),"2") //"VALOR JUROS"
         MAlterou := .T.
      ENDIF
   ENDIF

   IF DI_Ctb->DIVL_621 #0
      IF CR200Existe("DIVL_621")
         CR200_Verif("DIVL_621",DI_Ctb->DIDT_621,DI_Ctb->DIVL_621,STR0029) //"VALOR I.R."
      ELSE
         CR200_Cod("DIVL_621",DI_Ctb->DIDT_621,DI_Ctb->DIVL_621)
         CR200_Crit("2",STR0029,ALLTRIM(TRANS(DI_Ctb->DIVL_621,'@E 999,999,999,999.99')),SPACE(20),"2") //"VALOR I.R."
         MAlterou := .T.
      ENDIF
   ENDIF

   IF DI_Ctb->DIVL_623 #0
      IF CR200Existe("DIVL_623")
         CR200_Verif("DIVL_623",DI_Ctb->DIDT_623,DI_Ctb->DIVL_623,STR0030) //"VALOR DESP.BANCARIA"
      ELSE
         CR200_Cod("DIVL_623",DI_Ctb->DIDT_623,DI_Ctb->DIVL_623)
         CR200_Crit("2",STR0030,ALLTRIM(TRANS(DI_Ctb->DIVL_623,'@E 999,999,999,999.99')),SPACE(20),"2") //"VALOR DESP.BANCARIA"
         MAlterou := .T.
      ENDIF
   ENDIF

   IF DI_Ctb->DIVL_699 #0
      IF CR200Existe("DIVL_699")
         CR200_Verif("DIVL_699",DI_Ctb->DIDT_699,DI_Ctb->DIVL_699,STR0031) //"VALOR CREDITO A BANCO"
      ELSE
         CR200_Cod("DIVL_699",DI_Ctb->DIDT_699,DI_Ctb->DIVL_699)
         CR200_Crit("2",STR0031,ALLTRIM(TRANS(DI_Ctb->DIVL_699,'@E 999,999,999,999.99')),SPACE(20),"2") //"VALOR CREDITO A BANCO"
         MAlterou := .T.
      ENDIF
   ENDIF

   IF DI_Ctb->DIVL_NFT #0
      IF CR200Existe("DIVL_NFT")
         CR200_Verif("DIVL_NFT",DI_Ctb->DIDT,DI_Ctb->DIVL_NFT,STR0032) //"CREDITO-IMPORT. EM ANDAMENTO"
      ELSE
         CR200_Cod("DIVL_NFT",DI_Ctb->DIDT,DI_Ctb->DIVL_NFT)
         CR200_Crit("2",STR0032,ALLTRIM(TRANS(DI_Ctb->DIVL_NFT,'@E 999,999,999,999.99')),SPACE(20),"2") //"CREDITO-IMPORT. EM ANDAMENTO"
         MAlterou := .T.
      ENDIF
   ENDIF


   IF DI_Ctb->DIVL_NF #0
      IF CR200Existe("DIVL_NF")
         CR200_Verif("DIVL_NF",DI_Ctb->DIDT_NF,DI_Ctb->DIVL_NF,STR0033) //"VALOR NF"
      ELSE
         CR200_Cod("DIVL_NF",DI_Ctb->DIDT_NF,DI_Ctb->DIVL_NF)
         CR200_Crit("2",STR0034,ALLTRIM(TRANS(DI_Ctb->DIVL_NF,'@E 999,999,999,999.99')),SPACE(20),"2") //"VALOR N.FISCAL"
         MAlterou := .T.
      ENDIF
   ENDIF

   IF DI_Ctb->DIVL_NFC #0
      IF CR200Existe("DIVL_NFC")
         CR200_Verif("DIVL_NFC",DI_Ctb->DIDT_NFC,DI_Ctb->DIVL_NFC,STR0035) //"VALOR NF CP"
      ELSE
         CR200_Cod("DIVL_NFC",DI_Ctb->DIDT_NFC,DI_Ctb->DIVL_NFC)
         CR200_Crit("2",STR0036,ALLTRIM(TRANS(DI_Ctb->DIVL_NFC,'@E 999,999,999,999.99')),SPACE(20),"2") //"VALOR NF COMPL."
         MAlterou := .T.
      ENDIF
   ENDIF

   IF DI_Ctb->DIDT #EC2->EC2_DT
      IF EMPTY(EC2->EC2_DT) .AND. ! EMPTY(DI_Ctb->DIDT)
         MTrocaDt := .T.
         CR200_VerDt(DI_Ctb->DIDT,"DIICMS_C",STR0037) //"COM.ARM."
         CR200_VerDt(DI_Ctb->DIDT,"DIVL_FRETE",STR0038) //"FRETE"
         CR200_VerDt(DI_Ctb->DIDT_ENTR,"DIVL_II",STR0013) //"I.I."
         CR200_VerDt(DI_Ctb->DIDT_ENTR,"DIVL_IPI",STR0014) //"I.P.I."
         CR200_VerDt(DI_Ctb->DIDT_ENTR,"DIVL_ICMS",STR0039) //"ICMS"
         CR200_VerDt(DI_Ctb->DIDT,"DIDESP_GI",STR0040) //"DESP.GUIA"
         CR200_VerDt(DI_Ctb->DIDT,"DIDESP_GI",STR0040) //"DESP.GUIA"
         CR200_VerDt(DI_Ctb->DIDT,"HDIFOB_DI",STR0041) //"FOB. D.I."

         IF MTrocaDT
            CR200_Crit("2",STR0042,DTOC(DI_Ctb->DIDT),DTOC(EC2->EC2_DT),"2") //"DATA PAGTO. IMPOSTOS"
            CR200LOCK("EC2",.F.)
            EC2->EC2_DT := DI_Ctb->DIDT
            EC2->(MSUNLOCK())
         ENDIF
         MAlterou := .T.
      ELSE
         CR200_Crit("2",STR0042,DTOC(DI_Ctb->DIDT),DTOC(EC2->EC2_DT),"3") //"DATA PAGTO. IMPOSTOS"
      ENDIF
   ENDIF

   CR200_VerDt(DI_Ctb->DIDT_DCI,"DIVL_DCI",STR0043) //"D.C.I."
   CR200_VerDt(DI_Ctb->DIDT_ARMZ,"DIVL_ARM",STR0044) //"ARM.AEREO"
   CR200_VerDt(DI_Ctb->DIDTP_DESP,"DIVL_DESP",STR0045) //"COM.DESP."
   CR200_VerDt(DI_Ctb->DIDTP_ROD,"DIFRETE_RO",STR0046) //"FRETE ROD"

   EC8->(DBSETORDER(1))   && LAB 24.03.00

//   EC8->(DBSEEK(cFilEC8+DI_Ctb->DIHAWB+If(lTemEC8FOM, DI_Ctb->DIFORN+DI_Ctb->DIMOEDA, "")+DI_Ctb->DIIDENTCT))
//   Não é necessario verificar a existencia do campo EC8_FORN = lTemEC8Fom
//   ACSJ - 23/04/2004

   EC8->(DBSEEK(cFilEC8+DI_Ctb->DIHAWB+DI_Ctb->DIFORN+DI_Ctb->DIMOEDA+DI_Ctb->DIIDENTCT))
//   DO WHILE ! EC8->(EOF()) .AND. (DI_Ctb->DIHAWB+If(lTemEC8FOM, DI_Ctb->DIFORN+DI_Ctb->DIMOEDA, "")+DI_Ctb->DIIDENTCT)==(EC8->EC8_HAWB+If(lTemEC8FOM, EC8->EC8_FORN+EC8->EC8_MOEDA, "")+EC8->EC8_IDENTC) .AND. EC8->EC8_FILIAL==cFilEC8
//   Não é necessario verificar a existencia do campo EC8_FORN = lTemEC8Fom
//   ACSJ - 23/04/2004
   DO WHILE ! EC8->(EOF()) .AND. (DI_Ctb->DIHAWB+DI_Ctb->DIFORN+DI_Ctb->DIMOEDA+DI_Ctb->DIIDENTCT)==(EC8->EC8_HAWB+EC8->EC8_FORN+EC8->EC8_MOEDA+EC8->EC8_IDENTC) .AND. EC8->EC8_FILIAL==cFilEC8
      SYSREFRESH()
      CR200LOCK("EC8",.F.)
      EC8->(DBDELETE())
      EC8->(MSUNLOCK())
      EC8->(DBSKIP())
   ENDDO

   IVH_Ctb->(DBSETORDER(1))
   IVH_Ctb->(DBSEEK(DI_Ctb->DIHAWB+DI_Ctb->DIIDENTCT))
   MPO_Num_A := IVH_Ctb->IVHPO_NUM

   IV_Ctb->(DBSETORDER(2))
   IV_Ctb->(DBSEEK(DI_Ctb->DIHAWB+DI_Ctb->DIFORN+DI_Ctb->DIMOEDA+DI_Ctb->DIIDENTCT))
   DO WHILE ! IV_Ctb->(EOF()) .AND. (DI_Ctb->DIHAWB+DI_Ctb->DIFORN+DI_Ctb->DIMOEDA+DIIDENTCT)==(IV_Ctb->IVHAWB+IV_Ctb->IVFORN+IV_Ctb->IVMOE_FOB+IV_Ctb->IVIDENTCT)
      SYSREFRESH()
      MFob_Vlr   := IV_Ctb->IVFOB_TOT
      MInvoice_A := IV_Ctb->IVINVOICE
      MIdentct_A := IV_Ctb->IVIDENTCT
      MMoeda_A   := IV_Ctb->IVMOE_FOB
      MForn_A    := IV_Ctb->IVFORN

      IF MFob_Vlr #0
         CR200LOCK("EC8",.T.)
         EC8->EC8_FILIAL  := cFilEC8
         EC8->EC8_HAWB    := DI_Ctb->DIHAWB
         EC8->EC8_IDENTC  := MIdentct_A
         EC8->EC8_PO_NUM  := MPO_Num_A
         EC8->EC8_INVOIC  := MInvoice_A
         EC8->EC8_FOB_PO  := MFob_Vlr
    	 EC8->EC8_FORN := MForn_A         
         EC8->EC8_MOEDA   := MMoeda_A
         EC8->(MSUNLOCK())
      ENDIF
      IV_Ctb->(DBSKIP())
   ENDDO

//   EC8->(DBSEEK(cFilEC8+DI_Ctb->DIHAWB+If(lTemEC8FOM, DI_Ctb->DIFORN+DI_Ctb->DIMOEDA, "")+DI_Ctb->DIIDENTCT))
//   Não é necessario verificar a existencia do campo EC8_FORN = lTemEC8Fom
//   ACSJ - 23/04/2004                                                                                       
  
   EC8->(DBSEEK(cFilEC8+DI_Ctb->DIHAWB+DI_Ctb->DIFORN+DI_Ctb->DIMOEDA+DI_Ctb->DIIDENTCT))
   MValor_FOB := 0

//   DO WHILE ! EC8->(EOF()) .AND. (DI_Ctb->DIHAWB+If(lTemEC8FOM, DI_Ctb->DIFORN+DI_Ctb->DIMOEDA, "")+DI_Ctb->DIIDENTCT)==(EC8->EC8_HAWB+If(lTemEC8FOM, EC8->EC8_FORN+EC8->EC8_MOEDA, "")+EC8->EC8_IDENTC) .AND. EC8->EC8_FILIAL==cFilEC8
//   Não é necessario verificar a existencia do campo EC8_FORN = lTemEC8Fom
//   ACSJ - 23/04/2004                                                                                       
   DO WHILE ! EC8->(EOF()) .AND. (DI_Ctb->DIHAWB+DI_Ctb->DIFORN+DI_Ctb->DIMOEDA+DI_Ctb->DIIDENTCT)==(EC8->EC8_HAWB+EC8->EC8_FORN+EC8->EC8_MOEDA+EC8->EC8_IDENTC) .AND. EC8->EC8_FILIAL==cFilEC8
      SYSREFRESH()
      MValor_FOB := MValor_FOB + EC8->EC8_FOB_PO
      EC8->(DBSKIP())
   ENDDO

   CR200LOCK("EC2",.F.)
   MTroca_FOB := .F.
   IF MValor_FOB #EC2->EC2_FOB_DI
      IF EC2->EC2_SIS_OR == "1"
         IF Di_Ctb->DITX_FOB #0
            IF CR200Existe("HDIFOB_DI")
               CR200_Verif("HDIFOB_DI",DI_Ctb->DIDT,MValor_FOB*Di_Ctb->DITX_FOB,STR0041)  && LAB 24.03.00 //"FOB. D.I."
            ELSE
               IF Di_Ctb->DITX_FOB #0
                  CR200_Cod("HDIFOB_DI",DI_Ctb->DIDT,MValor_FOB*Di_Ctb->DITX_FOB)
               ENDIF
               CR200_Crit("2",STR0047,ALLTRIM(TRANS(MValor_FOB*Di_Ctb->DITX_FOB,'@E 999,999,999,999.99')),SPACE(20),"2") //"VALOR FOB INVOICE"
               EC2->EC2_FOB_DI := MValor_FOB
               MAlterou := .T.
            ENDIF
         ELSE
            IF CR200Existe("HDIFOB_DI")
               CR200_Verif("HDIFOB_DI",DI_Ctb->DIDT,MValor_FOB,STR0041)   && LAB 24.03.00 //"FOB. D.I."
            ELSE
               IF Di_Ctb->DITX_FOB #0
                  CR200_Cod("HDIFOB_DI",DI_Ctb->DIDT,MValor_FOB)
               ENDIF
               CR200_Crit("2",STR0047,ALLTRIM(TRANS(MValor_FOB,'@E 999,999,999,999.99')),ALLTRIM(TRANS(EC2->EC2_FOB_DI,'@E 999,999,999,999.99')),"2") //"VALOR FOB INVOICE"
               EC2->EC2_FOB_DI := MValor_FOB
               MAlterou := .T.
            ENDIF
         ENDIF
      ELSE
         mMemo:=mMemo+STR0048+CHR(13)+CHR(10) //"Registro nao foi originado pelo sistema."
      ENDIF
   ENDIF

   IF MTroca_FOB
      MAlterou := .T.
      EC2->EC2_FOB_DI := MValor_FOB
   ENDIF

   IF Di_Ctb->DITX_FOB #0
      IF EC2->EC2_TX_DI #DI_Ctb->DITX_FOB
         IF ! EMPTY(DI_Ctb->DITX_FOB) .AND. EMPTY(EC2->EC2_TX_DI)
            CR200_Crit("2",STR0049,ALLTRIM(TRANS(DI_Ctb->DITX_FOB,'@E 999,999.999999')),ALLTRIM(TRANS(EC2->EC2_TX_DI,'@E 999,999.999999')),"2") //"TAXA FOB INVOICE"
            EC2->EC2_TX_DI := DI_Ctb->DITX_FOB
            IF CR200Existe("HDIFOB_DI")
               CR200_Verif("HDIFOB_DI",DI_Ctb->DIDT,MValor_FOB*Di_Ctb->DITX_FOB,STR0041)   && LAB 24.03.00 //"FOB. D.I."
            ELSE
               IF Di_Ctb->DITX_FOB #0
                  CR200_Cod("HDIFOB_DI",DI_Ctb->DIDT,MValor_FOB*Di_Ctb->DITX_FOB)    && LAB 24.03.00
               ENDIF
               CR200_Crit("2",STR0047,ALLTRIM(TRANS(EC2->EC2_FOB_DI*Di_Ctb->DITX_FOB,'@E 999,999,999,999.99')),SPACE(20),"2") //"VALOR FOB INVOICE"
            ENDIF
            MAlterou := .T.
         ELSE
            CR200_Crit("2",STR0049,ALLTRIM(TRANS(DI_Ctb->DITX_FOB,'@E 999,999.999999')),ALLTRIM(TRANS(EC2->EC2_TX_DI,'@E 999,999.999999')),"3") //"TAXA FOB INVOICE"
         ENDIF
      ENDIF
   ENDIF

   IF MAlterou
      MConta_DI := MConta_DI + 1
   ENDIF

   EC2->(MSUNLOCK())
ELSE
   IF EC2->EC2_HAWB #DI_Ctb->DIHAWB
      CR200_Crit("2",STR0001,DI_Ctb->DIHAWB,EC2->EC2_HAWB,"4") //"NUMERO DO H.A.W.B."
   ENDIF

   IF EC2->EC2_DI_NUM # TransDI("EC2_DI_NUM",DI_Ctb->DIDI_NUM)//DI_Ctb->DIDI_NUM
      CR200_Crit("2",STR0002,TRANSF(DI_Ctb->DIDI_NUM, '@R 99/9999999-9'),TRANSF(EC2->EC2_DI_NUM, '@R 99/9999999-9'),"4") //"NUMERO DA D.I."
   ENDIF

   IF EC2->EC2_DESP # DI_Ctb->DIDESP                   && LAB 08.05.00
      CR200_Crit("2",STR0003,DI_Ctb->DIDESP,EC2->EC2_DESP,"4") //"DESPACHANTE"
   ENDIF

   IF EC2->EC2_LOTE #DI_Ctb->DILOTE
      CR200_Crit("2",STR0004,DI_Ctb->DILOTE,EC2->EC2_LOTE,"4") //"NUMERO DO LOTE"
   ENDIF

   IF EC2->EC2_NF_ENT #DI_Ctb->DINF_ENT
      CR200_Crit("2",STR0005,DI_Ctb->DINF_ENT,EC2->EC2_NF_ENT,"4") //"NUMERO DA N.F. ENTR."
   ENDIF

   IF EC2->EC2_NF_COM #DI_Ctb->DINF_COMP
      CR200_Crit("2",STR0008,DI_Ctb->DINF_COMP,EC2->EC2_NF_COM,"4") //"NUMERO DA N.F. COMP."
   ENDIF

   IF DI_Ctb->DIVL_DCI #0
      IF CR200Existe("DIVL_DCI")
         CR200_Verif("DIVL_DCI",DI_Ctb->DIDT_DCI,DI_Ctb->DIVL_DCI,STR0043) //"D.C.I."
      ELSE
         CR200_Crit("2",STR0009,ALLTRIM(TRANS(DI_Ctb->DIVL_DCI,'@E 999,999,999,999.99')),SPACE(20),"4") //"PAGO PELO IMPORTADOR"
      ENDIF
   ENDIF

   IF DI_Ctb->DIICMS_C #0
      IF CR200Existe("DIICMS_C")
         CR200_Verif("DIICMS_C",DI_Ctb->DIDT,DI_Ctb->DIICMS_C,STR0050) //"COMP.ARM."
      ELSE
         CR200_Crit("2",STR0010,ALLTRIM(TRANS(DI_Ctb->DIICMS_C,'@E 999,999,999,999.99')),SPACE(20),"4") //"ICMS PAGO PELO IMP."
      ENDIF
   ENDIF

   IF DI_Ctb->DIVL_DAP #0
      IF CR200Existe("DIVL_DAP")
         CR200_Verif("DIVL_DAP",DI_Ctb->DIDT_ARMZ,DI_Ctb->DIVL_DAP,STR0051) //"ARM. DAP"
      ELSE
         CR200_Crit("2",STR0011,ALLTRIM(TRANS(DI_Ctb->DIVL_DAP,'@E 999,999,999,999.99')),SPACE(20),"4") //"MULTAS PAGA PELO IMP."
      ENDIF
   ENDIF

   IF DI_Ctb->DIVL_FRETE #0
      IF CR200Existe("DIVL_FRETE")
         CR200_Verif("DIVL_FRETE",DI_Ctb->DIDT,DI_Ctb->DIVL_FRETE,STR0038) //"FRETE"
      ELSE
         CR200_Crit("2",STR0012,ALLTRIM(TRANS(DI_Ctb->DIVL_FRETE,'@E 999,999,999,999.99')),SPACE(20),"4") //"VALOR DE FRETE"
      ENDIF
   ENDIF

   IF DI_Ctb->DIVL_II #0
      IF CR200Existe("DIVL_II")
         CR200_Verif("DIVL_II",DI_Ctb->DIDT_ENTR,DI_Ctb->DIVL_II,STR0013) //"I.I."
      ELSE
         CR200_Crit("2",STR0013,ALLTRIM(TRANS(DI_Ctb->DIVL_II,'@E 999,999,999,999.99')),SPACE(20),"4") //"I.I."
      ENDIF
   ENDIF

   IF DI_Ctb->DIVL_IPI #0
      IF CR200Existe("DIVL_IPI")
         CR200_Verif("DIVL_IPI",DI_Ctb->DIDT_ENTR,DI_Ctb->DIVL_IPI,STR0014) //"I.P.I."
      ELSE
         CR200_Crit("2",STR0014,ALLTRIM(TRANS(DI_Ctb->DIVL_IPI,'@E 999,999,999,999.99')),SPACE(20),"4") //"I.P.I."
      ENDIF
   ENDIF

   IF DI_Ctb->DIVL_ICMS #0
      IF CR200Existe("DIVL_ICMS")
         CR200_Verif("DIVL_ICMS",DI_Ctb->DIDT_ENTR,DI_Ctb->DIVL_ICMS,STR0039) //"ICMS"
      ELSE
         CR200_Crit("2",STR0015,ALLTRIM(TRANS(DI_Ctb->DIVL_ICMS,'@E 999,999,999,999.99')),SPACE(20),"4") //"ICMS PAGO PELO DESP."
      ENDIF
   ENDIF

   IF DI_Ctb->DIVL_ARM #0
      IF CR200Existe("DIVL_ARM")
         CR200_Verif("DIVL_ARM",DI_Ctb->DIDT_ARMZ,DI_Ctb->DIVL_ARM,STR0044) //"ARM.AEREO"
      ELSE
         CR200_Crit("2",STR0016,ALLTRIM(TRANS(DI_Ctb->DIVL_ARM,'@E 999,999,999,999.99')),SPACE(20),"4") //"MULTAS PAGA PELO DESP."
      ENDIF
   ENDIF

   IF DI_Ctb->DIVL_DESP #0
      IF CR200Existe("DIVL_DESP")
         CR200_Verif("DIVL_DESP",DI_Ctb->DIDTP_DESP,DI_Ctb->DIVL_DESP,STR0045) //"COM.DESP."
      ELSE
         CR200_Crit("2",STR0017,ALLTRIM(TRANS(DI_Ctb->DIVL_DESP,'@E 999,999,999,999.99')),SPACE(20),"4") //"PAGO PELO DESPACHANTE"
      ENDIF
   ENDIF

   IF DI_Ctb->DIDESP_GI #0
      IF CR200Existe("DIDESP_GI")
         CR200_Verif("DIDESP_GI",DI_Ctb->DIDT_ARMZ,DI_Ctb->DIDESP_GI,STR0040) //"DESP.GUIA"
      ELSE
         CR200_Crit("2",STR0018,ALLTRIM(TRANS(DI_Ctb->DIDESP_GI,'@E 999,999,999,999.99')),SPACE(20),"4") //"ICMS S/ MULTAS - DESP."
      ENDIF
   ENDIF

   IF DI_Ctb->DIDESP_CL #0
      IF CR200Existe("DIDESP_CL")
         CR200_Verif("DIDESP_CL",DI_Ctb->DIDT_ARMZ,DI_Ctb->DIDESP_CL,STR0052) //"DESP.COMP"
      ELSE
         CR200_Crit("2",STR0019,ALLTRIM(TRANS(DI_Ctb->DIDESP_CL,'@E 999,999,999,999.99')),SPACE(20),"4") //"ICMS S/ MULTAS - IMP."
      ENDIF
   ENDIF

   IF DI_Ctb->DIFRETE_RO #0
      IF CR200Existe("DIFRETE_RO")
         CR200_Verif("DIFRETE_RO",DI_Ctb->DIDTP_ROD,DI_Ctb->DIFRETE_RO,STR0046) //"FRETE ROD"
      ELSE
         CR200_Crit("2",STR0020,ALLTRIM(TRANS(DI_Ctb->DIFRETE_RO,'@E 999,999,999,999.99')),SPACE(20),"4") //"FRETE RODOVIARIO"
      ENDIF
   ENDIF

   IF DI_Ctb->DIVL_USSEG #0
      IF CR200Existe("DIVL_USSEG")
         CR200_Verif("DIVL_USSEG",DI_Ctb->DIDT,DI_Ctb->DIVL_USSEG,STR0021) //"SEGURO"
      ELSE
         CR200_Crit("2",STR0021,ALLTRIM(TRANS(DI_Ctb->DIVL_USSEG,'@E 999,999,999,999.99')),SPACE(20),"4") //"SEGURO"
      ENDIF
   ENDIF

   IF DI_Ctb->DIVL_APORT #0
      IF CR200Existe("DIVL_APORT")
         CR200_Verif("DIVL_APORT",DI_Ctb->DIDT_ARMZ,DI_Ctb->DIVL_APORT,STR0022) //"ARMAZ. PORTUARIA"
      ELSE
         CR200_Crit("2",STR0022,ALLTRIM(TRANS(DI_Ctb->DIVL_APORT,'@E 999,999,999,999.99')),SPACE(20),"4") //"ARMAZ. PORTUARIA"
      ENDIF
   ENDIF

   IF DI_Ctb->DIVL_AAER #0
      IF CR200Existe("DIVL_AAER")
         CR200_Verif("DIVL_AAER",DI_Ctb->DIDT_ARMZ,DI_Ctb->DIVL_AAER,STR0023) //"ARMAZ. AEREA"
      ELSE
         CR200_Crit("2",STR0023,ALLTRIM(TRANS(DI_Ctb->DIVL_AAER,'@E 999,999,999,999.99')),SPACE(20),"4") //"ARMAZ. AEREA"
      ENDIF
   ENDIF

   IF DI_Ctb->DIVL_ADAP #0
      IF CR200Existe("DIVL_ADAP")
         CR200_Verif("DIVL_ADAP",DI_Ctb->DIDT_ARMZ,DI_Ctb->DIVL_ADAP,STR0024) //"ARMAZ. DAP/MULTITERMINAIS"
      ELSE
         CR200_Crit("2",STR0024,ALLTRIM(TRANS(DI_Ctb->DIVL_ADAP,'@E 999,999,999,999.99')),SPACE(20),"4") //"ARMAZ. DAP/MULTITERMINAIS"
      ENDIF
   ENDIF

   IF DI_Ctb->DIVL_701 #0
      IF CR200Existe("DIVL_701")
         CR200_Verif("DIVL_701",DI_Ctb->DIDT_DESEM,DI_Ctb->DIVL_701,STR0025) //"VAR.CAMBIAL (DESEMB.) F.O.B."
      ELSE
         CR200_Crit("2",STR0025,ALLTRIM(TRANS(DI_Ctb->DIVL_701,'@E 999,999,999,999.99')),SPACE(20),"4") //"VAR.CAMBIAL (DESEMB.) F.O.B."
      ENDIF
   ENDIF

   IF DI_Ctb->DIVL_702 # 0               && LAB 02.05.00
      IF CR200Existe("DIVL_702")
         CR200_Verif("DIVL_702",DI_Ctb->DIDT_DESEM,DI_Ctb->DIVL_702,STR0025) //"VAR.CAMBIAL (DESEMB.) F.O.B."
      ELSE
         CR200_Crit("2",STR0025,ALLTRIM(TRANS(DI_Ctb->DIVL_702,'@E 999,999,999,999.99')),SPACE(20),"4") //"VAR.CAMBIAL (DESEMB.) F.O.B."
      ENDIF
   ENDIF

   IF DI_Ctb->DIVL_702_P #0  && LAB 29.07.98
      IF CR200Existe("DIVL_702_P")
         CR200_Verif("DIVL_702_P",DI_Ctb->DIDT_DESEM,DI_Ctb->DIVL_702_P,STR0026) //"VAR.CAMBIAL (DESEMB.) FRETE"
      ELSE
         CR200_Crit("2",STR0026,ALLTRIM(TRANS(DI_Ctb->DIVL_702_P,'@E 999,999,999,999.99')),SPACE(20),"4") //"VAR.CAMBIAL (DESEMB.) FRETE"
      ENDIF
   ENDIF

   IF DI_Ctb->DIVL_509 #0
      IF CR200Existe("DIVL_509")
         CR200_Verif("DIVL_509",DI_Ctb->DIDT_DESEM,DI_Ctb->DIVL_509,STR0027) //"VALOR DESPESA 5.09"
      ELSE
         CR200_Crit("2",STR0027,ALLTRIM(TRANS(DI_Ctb->DIVL_509,'@E 999,999,999,999.99')),SPACE(20),"4") //"VALOR DESPESA 5.09"
      ENDIF
   ENDIF

   IF DI_Ctb->DIVL_620 #0
      IF CR200Existe("DIVL_620")
         CR200_Verif("DIVL_620",DI_Ctb->DIDT_620,DI_Ctb->DIVL_620,STR0028) //"VALOR JUROS"
      ELSE
         CR200_Crit("2",STR0028,ALLTRIM(TRANS(DI_Ctb->DIVL_620,'@E 999,999,999,999.99')),SPACE(20),"4") //"VALOR JUROS"
      ENDIF
   ENDIF

   IF DI_Ctb->DIVL_621 #0
      IF CR200Existe("DIVL_621")
         CR200_Verif("DIVL_621",DI_Ctb->DIDT_621,DI_Ctb->DIVL_621,STR0029) //"VALOR I.R."
      ELSE
         CR200_Crit("2",STR0029,ALLTRIM(TRANS(DI_Ctb->DIVL_621,'@E 999,999,999,999.99')),SPACE(20),"4") //"VALOR I.R."
      ENDIF
   ENDIF

   IF DI_Ctb->DIVL_623 #0
      IF CR200Existe("DIVL_623")
         CR200_Verif("DIVL_623",DI_Ctb->DIDT_623,DI_Ctb->DIVL_623,STR0030) //"VALOR DESP.BANCARIA"
      ELSE
         CR200_Crit("2",STR0030,ALLTRIM(TRANS(DI_Ctb->DIVL_623,'@E 999,999,999,999.99')),SPACE(20),"4") //"VALOR DESP.BANCARIA"
      ENDIF
   ENDIF

   IF DI_Ctb->DIVL_699 #0
      IF CR200Existe("DIVL_699")
         CR200_Verif("DIVL_699",DI_Ctb->DIDT_699,DI_Ctb->DIVL_699,STR0031) //"VALOR CREDITO A BANCO"
      ELSE
         CR200_Crit("2",STR0031,ALLTRIM(TRANS(DI_Ctb->DIVL_699,'@E 999,999,999,999.99')),SPACE(20),"4") //"VALOR CREDITO A BANCO"
      ENDIF
   ENDIF

   IF DI_Ctb->DIVL_NFT #0
      IF CR200Existe("DIVL_NFT")
         CR200_Verif("DIVL_NFT",DI_Ctb->DIDT,DI_Ctb->DIVL_NFT,STR0032) //"CREDITO-IMPORT. EM ANDAMENTO"
      ELSE
         CR200_Crit("2",STR0032,ALLTRIM(TRANS(DI_Ctb->DIVL_NFT,'@E 999,999,999,999.99')),SPACE(20),"4") //"CREDITO-IMPORT. EM ANDAMENTO"
      ENDIF
   ENDIF

   IF DI_Ctb->DIVL_NF #0
      IF CR200Existe("DIVL_NF")
         CR200_Verif("DIVL_NF",DI_Ctb->DIDT_NF,DI_Ctb->DIVL_NF,STR0033) //"VALOR NF"
      ELSE
         CR200_Crit("2",STR0034,ALLTRIM(TRANS(DI_Ctb->DIVL_NF,'@E 999,999,999,999.99')),SPACE(20),"4") //"VALOR N.FISCAL"
      ENDIF
   ENDIF

   IF DI_Ctb->DIVL_NFC #0
      IF CR200Existe("DIVL_NFC")
         CR200_Verif("DIVL_NFC",DI_Ctb->DIDT_NFC,DI_Ctb->DIVL_NFC,STR0035) //"VALOR NF CP"
      ELSE
         CR200_Crit("2",STR0036,ALLTRIM(TRANS(DI_Ctb->DIVL_NFC,'@E 999,999,999,999.99')),SPACE(20),"4") //"VALOR NF COMPL."
      ENDIF
   ENDIF

   IF DI_Ctb->DIDT #EC2->EC2_DT
      CR200_VerDt(DI_Ctb->DIDT,"DIICMS_C",STR0037) //"COM.ARM."
      CR200_VerDt(DI_Ctb->DIDT,"DIVL_FRETE",STR0038) //"FRETE"
      CR200_VerDt(DI_Ctb->DIDT_ENTR,"DIVL_II",STR0013) //"I.I."
      CR200_VerDt(DI_Ctb->DIDT_ENTR,"DIVL_IPI",STR0014) //"I.P.I."
      CR200_VerDt(DI_Ctb->DIDT_ENTR,"DIVL_ICMS",STR0039) //"ICMS"
      CR200_VerDt(DI_Ctb->DIDT,"DIDESP_GI",STR0040) //"DESP.GUIA"
   ENDIF

   CR200_VerDt(DI_Ctb->DIDT_DCI,"DIVL_DCI", "D.C.I.")
   CR200_VerDt(DI_Ctb->DIDT_ARMZ,"DIVL_ARM",STR0044) //"ARM.AEREO"
   CR200_VerDt(DI_Ctb->DIDTP_DESP,"DIVL_DESP",STR0045) //"COM.DESP."
   CR200_VerDt(DI_Ctb->DIDTP_ROD,"DIFRETE_RO",STR0046) //"FRETE ROD"

   IVH_Ctb->(DBSETORDER(1))
   IVH_Ctb->(DBSEEK(DI_Ctb->DIHAWB+DI_Ctb->DIIDENTCT))
   MPO_Num_A  := IVH_Ctb->IVHPO_NUM

   EC8->(DBSETORDER(1))   && LAB 24.03.00

   IV_Ctb->(DBSETORDER(2))
   IV_Ctb->(DBSEEK(DI_Ctb->DIHAWB+DI_Ctb->DIFORN+DI_Ctb->DIMOEDA+DI_Ctb->DIIDENTCT))
   DO WHILE ! IV_Ctb->(EOF()) .AND. (DI_Ctb->DIHAWB+DI_Ctb->DIFORN+DI_Ctb->DIMOEDA+DI_Ctb->DIIDENTCT) == (IV_Ctb->IVHAWB+IV_Ctb->IVFORN+IV_Ctb->IVMOE_FOB+IV_Ctb->IVIDENTCT)
      SYSREFRESH()
      MFob_Vlr   := IV_Ctb->IVFOB_TOT
      MInvoice_A := IVH_Ctb->IVHINVOICE       
      MIdentct_A := IVH_Ctb->IVHIDENTCT                               
      MForn_A    := IV_Ctb->IVFORN

      MMoeda_A := IV_Ctb->IVMOE_FOB
      IF ! EC8->(DBSEEK(cFilEC8+DI_Ctb->DIHAWB+MForn_A+MMoeda_A+MIdentct_A+MPO_Num_A+MInvoice_A))
         cAuxFor:=U_CR200Inv_For(MInvoice_A,MForn_A )
         CR200_Crit("2",STR0053,ALLTRIM(MPO_NUM_A)+" "+ALLTRIM(MInvoice_A)+" "+cAuxFor,SPACE(20),"4") //"NRO. P.O./INV./FORN."
      ELSE
         MVlr_FOB := VAL(STR(MFob_Vlr,15,2))
         IF MVlr_FOB # EC8->EC8_FOB_PO
            CR200_Crit("2",STR0054,ALLTRIM(TRANS(MFob_Vlr,'@E 999,999,999,999.99')),ALLTRIM(TRANS(EC8->EC8_FOB_PO,'@E 999,999,999,999.99')),"4") //"VALOR FOB P.O."
         ENDIF
      ENDIF
      IV_Ctb->(DBSKIP())
   ENDDO

//   EC8->(DBSEEK(cFilEC8+DI_Ctb->DIHAWB+If(lTemEC8FOM, DI_Ctb->DIFORN+DI_Ctb->DIMOEDA, "")+DI_Ctb->DIIDENTCT))
//   Não é necessario verificar a existencia do campo EC8_FORN = lTemEC8Fom
//   ACSJ - 23/04/2004

   EC8->(DBSEEK(cFilEC8+DI_Ctb->DIHAWB+DI_Ctb->DIFORN+DI_Ctb->DIMOEDA+DI_Ctb->DIIDENTCT))
   MValor_FOB := 0

//   DO WHILE ! EC8->(EOF()) .AND. (DI_Ctb->DIHAWB+If(lTemEC8FOM, DI_Ctb->DIFORN+DI_Ctb->DIMOEDA, "")+DI_Ctb->DIIDENTCT)==(EC8->EC8_HAWB+If(lTemEC8FOM, EC8->EC8_FORN+EC8->EC8_MOEDA, "")+EC8->EC8_IDENTC) .AND. EC8->EC8_FILIAL==cFilEC8
//   Não é necessario verificar a existencia do campo EC8_FORN = lTemEC8Fom
//   ACSJ - 23/04/2004
   DO WHILE ! EC8->(EOF()) .AND. (DI_Ctb->DIHAWB+DI_Ctb->DIFORN+DI_Ctb->DIMOEDA+DI_Ctb->DIIDENTCT)==(EC8->EC8_HAWB+EC8->EC8_FORN+EC8->EC8_MOEDA+EC8->EC8_IDENTC) .AND. EC8->EC8_FILIAL==cFilEC8
      SYSREFRESH()
      MValor_FOB := MValor_FOB + EC8->EC8_FOB_PO
      EC8->(DBSKIP())
   ENDDO

   IF MValor_FOB #EC2->EC2_FOB_DI
      IF EC2->EC2_SIS_OR == "1"
         IF Di_Ctb->DITX_FOB #0
            IF CR200Existe("HDIFOB_DI")
               CR200_Verif("HDIFOB_DI",DI_Ctb->DIDT,EC2->EC2_FOB_DI*Di_Ctb->DITX_FOB,STR0041) //"FOB. D.I."
            ELSE
               CR200_Crit("2",STR0047,ALLTRIM(TRANS(MValor_FOB*Di_Ctb->DITX_FOB,'@E 999,999,999,999.99')),SPACE(20),"4") //"VALOR FOB INVOICE"
            ENDIF
         ELSE
            IF CR200Existe("HDIFOB_DI")
               CR200_Verif("HDIFOB_DI",DI_Ctb->DIDT,EC2->EC2_FOB_DI,STR0041) //"FOB. D.I."
            ELSE
               CR200_Crit("2",STR0047,ALLTRIM(TRANS(MValor_FOB,'@E 999,999,999,999.99')),ALLTRIM(TRANS(EC2->EC2_FOB_DI,'@E 999,999,999,999.99')),"4") //"VALOR FOB INVOICE"
            ENDIF
         ENDIF
      ELSE
         mMemo:=mMemo+STR0048+CHR(13)+CHR(10) //"Registro nao foi originado pelo sistema."
      ENDIF
   ENDIF

   IF Di_Ctb->DITX_FOB #0
      IF EC2->EC2_TX_DI #DI_Ctb->DITX_FOB
         CR200_Crit("2",STR0049,ALLTRIM(TRANS(DI_Ctb->DITX_FOB,'@E 999,999.999999')),ALLTRIM(TRANS(EC2->EC2_TX_DI,'@E 999,999.999999')),"4") //"TAXA FOB INVOICE"
      ENDIF
   ENDIF

ENDIF

// Substituido pelo assistente de conversao do AP5 IDE em 01/12/99 ==> __RETURN(.T.)
Return(.T.)        // incluido pelo assistente de conversao do AP5 IDE em 01/12/99
STATIC FUNCTION TransDI(cCpoAtu,cCpoCont)
LOCAL xValor:=cCpoCont

IF AVSX3(cCpoAtu,2) = "C" .AND. VALTYPE(cCpoCont) = "N"
   IF EMPTY(cCpoCont)
      RETURN ""
   ELSE               
      xValor:=STRZERO(cCpoCont,10,0)
   ENDIF
ELSEIF AVSX3(cCpoAtu,2) = "N" .AND. VALTYPE(cCpoCont) = "C"
   IF EMPTY(cCpoCont)
      RETURN ""
   ELSE               
      xValor:=VAL(cCpoCont)
   ENDIF
ENDIF

RETURN xValor



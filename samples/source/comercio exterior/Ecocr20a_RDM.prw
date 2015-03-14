#INCLUDE "Ecocr20a.ch"
#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 01/12/99
#Include "Average.ch"


User Function Ecocr20a()        // incluido pelo assistente de conversao do AP5 IDE em 01/12/99

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CTRAVAALIAS,LTRAVA,PDESCCPO,PDATA,PDESC,PDESCRICAO")
SetPrvt("PCAMPO,PINVOICE,PTIPO_INT,PENVIO,PEXISTE,PSTATUS,PFORN")
SetPrvt("CPATH,CMESPROC,CFILSA2,CFILEC5,CFILEC6,CFILECC")
SetPrvt("CFILEC2,CFILEC8,CFILEC9,CFILEC4,CFILEC0,MMEMO,CFILEC7")
SetPrvt("LRETA,MCONTA,MALTEROU,MCONTA_DI,MRECNO,TID_CAMP")
SetPrvt("TIDENTCONTA,TDESCR,TCONTADEB,TCONTACRED,TCOD,TNOME")
SetPrvt("TCOM_HIS,TCTAFINANCEIRA,MDESPR_INV,MPO_NUM_A,MINVOICE_A,MIDENTCT_A,MForn_A,MMoeda_A")
SetPrvt("MFOB_VLR,CAUXFOR,MVALOR_FOB,TMES,TANO,TDATA_CON")
SetPrvt("MNR_CONT,MJA_PAGO,")

//** AAF 08/01/08 - Execucao por Agendamento
If Type("lScheduled") <> "L"
   Private lScheduled := .F.
EndIf
//**

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
                                         
cPath := AllTrim(GETMV("MV_PATH_CO")); cMesProc := AllTrim(GETMV("MV_MESPROC"))
cFilSA2:=xFilial('SA2');cFilEC5:=xFilial('EC5');cFilEC6:=xFilial('EC6');cFilECC:=xFilial('ECC')
cFilEC2:=xFilial('EC2');cFilEC8:=xFilial('EC8');cFilEC9:=xFilial('EC9');cFilEC4:=xFilial('EC4')
cFilEC0:=xFilial('EC0');cFilEC7:=xFilial('EC7')
mMemo  := '';lRetA:=.T.

// Verifica se existe o campo EC9_FORN / EC8_FORN
Private lExisteECF := .F., lExisteECG := .F.        

// Verifica se existe o arquivo de pagamento antecipado ECF
lExisteECF := GetMV("MV_PAGANT", .F., .F.)
If lExisteECF
   cFilECF    := xFilial('ECF')			
   lExisteECG := .T.   
   cFilECG    := xFilial('ECG')			
Endif                    

// Verifica se o indice de ordem 1 do EC5 possui a seguinte chave FILIAL+FORN+INVOICE+IDENTCT
/*
If lExisteFor
   If SIX->(DbSeek("EC5"+"1"))
      If !"EC5_FORN" $ SIX->CHAVE  
         lExisteFor := .F.
      Endif       
   Else
      lExisteFor := .F.     
   Endif
Endif */

Do While .T.
   IF(Right(cPath,1)#"\", cPath := cPath+"\",)

   IF ! lIsDir(Left(cPath,Len(cPath)-1))
      // Path nao existe
      Help(" ",1,"E_PATH_CO")
      lRetA:=.F.
      EXIT
   ENDIF
   
   If ! ExecBlock("ECOCR20B",.F.,.F.,8)  // CR200ABRE()
      lRetA:=.F.
      EXIT
   EndIf
   
   AvProcessa({|| CR200Inv(),STR0001})// Substituido pelo assistente de conversao do AP5 IDE em 01/12/99 ==>    Processa({|| EXECUTE(CR200Inv),"Integrando registros de invoices."}) //"Integrando registros de invoices."
   AvProcessa({|| CR200Des(),STR0002})// Substituido pelo assistente de conversao do AP5 IDE em 01/12/99 ==>    Processa({|| EXECUTE(CR200Des),"Integrando registros de despachos."}) //"Integrando registros de despachos."
   AvProcessa({|| CR200ApaPag(),STR0062})  // Substituido pelo assistente de conversao do AP5 IDE em 01/12/99 ==>    Processa({|| EXECUTE(CR200Pag),"Integrando registros de pagamentos."})
   AvProcessa({|| CR200Apa2Pag(),STR0063}) // Substituido pelo assistente de conversao do AP5 IDE em 01/12/99 ==>    Processa({|| EXECUTE(CR200Pag),"Integrando registros de pagamentos."})
   AvProcessa({|| CR200Pag(),STR0064})     // Substituido pelo assistente de conversao do AP5 IDE em 01/12/99 ==>    Processa({|| EXECUTE(CR200Pag),"Integrando registros de pagamentos."})

   IV_Ctb->(dbcloseAREA());DI_Ctb->(dbcloseAREA());IVH_Ctb->(dbcloseAREA())
   APD_Ctb->(dbcloseAREA())
   If lExisteECF
      ANT_Ctb->(dbcloseAREA())
   Endif
   SA2->(DBSETORDER(1));EC5->(DBSETORDER(1));EC6->(DBSETORDER(1));ECC->(DBSETORDER(1))
   EC2->(DBSETORDER(1));EC8->(DBSETORDER(1));EC9->(DBSETORDER(1));EC4->(DBSETORDER(1))
   EC0->(DBSETORDER(1))
   save to MemoCTB.INT all like mMemo
   ECORESUMO()
   Exit
Enddo
// Substituido pelo assistente de conversao do AP5 IDE em 01/12/99 ==> __Return(lRetA)
Return(lRetA)        // incluido pelo assistente de conversao do AP5 IDE em 01/12/99

*-------------------------*
// Substituido pelo assistente de conversao do AP5 IDE em 01/12/99 ==> Function CR200Inv
Static Function CR200Inv()
*-------------------------*

ProcRegua(IV_Ctb->(LASTREC()))

DBSELECTAREA('IV_Ctb')
IV_Ctb->(DBSETORDER(1))
IV_Ctb->(DBGOTOP())

MConta := 0
DO WHILE ! IV_Ctb->(EOF())
   IncProc(STR0004+PADL(MConta,5,'0')) //"No. de Invoices.:"
// IF IV_Ctb->IV_AMOST  $ cSim
//    IV_Ctb->(DBSKIP())
//    LOOP
// ENDIF

   IF ! SA2->(DBSEEK(cFilSA2+IV_Ctb->IVFORN))
      CR200LOCK("SA2",.T.)
      SA2->A2_COD     :=IV_Ctb->IVFORN
      SA2->A2_FILIAL  :=cFilSA2
      SA2->A2_LOJA    :='.'
      SA2->A2_NOME    :=IV_Ctb->IVNOM_FOR
      SA2->A2_NREDUZ  :=IV_Ctb->IVNOM_FOR
      SA2->A2_END     :='.'
      SA2->A2_ID_FBFN :='2-Forn'
      SA2->A2_STATUS  := '1'
      SA2->(MSUNLOCK())
   ENDIF

// Para Agfa tivemos que deixar sem i identct pois o ivh100 nao esta atualizado corretamente
   IF ! EC5->(DBSEEK(cFilEC5+IV_Ctb->IVFORN+IV_Ctb->IVINVOICE+IV_Ctb->IVIDENTCT ))  
      IVH_Ctb->(DBSETORDER(2))
	  
      IF ! IVH_Ctb->(DBSEEK(IV_Ctb->IVINVOICE))
          mMemo:=mMemo+STR0005 + ALLTRIM(IV_Ctb->IVINVOICE) + STR0006 + ALLTRIM(IV_Ctb->IVIDENTCT) + STR0007+CHR(13)+CHR(10) //"Invoice "###" BU/Unid.Req. "###" sem vinculo com HAWB"
          IV_Ctb->(DBSKIP())
          LOOP
      ENDIF

      IF ! DI_Ctb->(DBSEEK(IVH_Ctb->IVHHAWB))
          mMemo:=mMemo+STR0005 + ALLTRIM(IV_Ctb->IVINVOICE) + STR0006 + ALLTRIM(IV_Ctb->IVIDENTCT) + STR0008+CHR(13)+CHR(10) //"Invoice "###" BU/Unid.Req. "###" sem HAWB"
          IV_Ctb->(DBSKIP())
          LOOP
      ENDIF
	  
      CR200LOCK("EC5",.T.)
      EC5->EC5_FILIAL := cFilEC5
      EC5->EC5_INVOIC := IV_Ctb->IVINVOICE
      EC5->EC5_IDENTC := IV_Ctb->IVIDENTCT
      EC5->EC5_DT_EMI := IV_Ctb->IVDT_EMIS
      EC5->EC5_FORN   := IV_Ctb->IVFORN
      EC5->EC5_MOE_FO := IV_Ctb->IVMOE_FOB
      EC5->EC5_FOB_TO := IV_Ctb->IVFOB_TOT
      EC5->EC5_SIS_OR := "1"
      EC5->EC5_CD_PGT := IV_Ctb->IVCD_PGTO
      EC5->EC5_NR_CON := '0000'
      EC5->EC5_T_D    := IV_Ctb->IVCT_D                   && LAB 03.05.00
      EC5->EC5_DT_VEN := IV_Ctb->IVDT_VEN
      EC5->EC5_AMOS   := IV_Ctb->IV_AMOST
      EC5->EC5_HAWB   := IV_Ctb->IVHAWB                   //IVH_Ctb->IVHHAWB
      EC5->(MSUNLOCK())
	  
      CR200_Crit("1",STR0009   ,IV_Ctb->IVINVOICE,SPACE(20),"1") //"NUMERO DA INVOICE"
      CR200_Crit("1",STR0010    ,IV_Ctb->IVIDENTCT,SPACE(20),"1") //"B.U. / UNID.REQ."
      CR200_Crit("1",STR0011     ,DTOC(IV_Ctb->IVDT_EMIS),SPACE(20),"1") //"DATA DA EMISSAO"
      CR200_Crit("1",STR0012  ,DTOC(IV_Ctb->IVDT_VEN),SPACE(20),"1") //"DATA DE VENCIMENTO"
      CR200_Crit("1",STR0013,IV_Ctb->IVFORN+" "+ALLTRIM(IV_Ctb->IVNOM_FOR),SPACE(20),"1") //"CODIGO DO FORNECEDOR"
      CR200_Crit("1",STR0014        ,IV_Ctb->IVMOE_FOB,SPACE(20),"1") //"MOEDA F.O.B."
      CR200_Crit("1",STR0015        ,ALLTRIM(TRANS(IV_Ctb->IVFOB_TOT,'@E 999,999,999,999.99')),SPACE(20),"1") //"VALOR F.O.B."
      MConta := MConta + 1                                              
   ELSE
//    If EC5->EC5_AMOS $ cSim
//       IV_Ctb->(DBSKIP())
//       LOOP
//    EndIf

      If VAL(EC5->EC5_NR_CON) == 0 .or. VAL(EC5->EC5_NR_CON) = 9999
         MAlterou := .F.
         CR200LOCK("EC5",.F.)

         IF (EC5->EC5_INVOIC+EC5->EC5_IDENTC) #(IV_Ctb->IVINVOICE+IV_Ctb->IVIDENTCT)
            IF ! EMPTY(IV_Ctb->IVINVOICE) .AND. EMPTY(EC5->EC5_INVOIC)
			
               CR200_Crit("1",STR0009,IV_Ctb->IVINVOICE,EC5->EC5_INVOIC,"2") //"NUMERO DA INVOICE"
               EC5->EC5_INVOIC := IV_Ctb->IVINVOICE
               MAlterou := .T.
            ELSE
			
               CR200_Crit("1",STR0009,IV_Ctb->IVINVOICE,EC5->EC5_INVOIC,"3") //"NUMERO DA INVOICE"
            ENDIF
         ENDIF

         IF EC5->EC5_DT_EMI #IV_Ctb->IVDT_EMIS
            IF ! EMPTY(IV_Ctb->IVDT_EMIS) .AND. EMPTY(EC5->EC5_DT_EMI)
               CR200_Crit("1",STR0011,DTOC(IV_Ctb->IVDT_EMIS),DTOC(EC5->EC5_DT_EMI),"2") //"DATA DA EMISSAO"
               EC5->EC5_DT_EMI := IV_Ctb->IVDT_EMIS
               MAlterou := .T.
            ELSE
               CR200_Crit("1",STR0011,DTOC(IV_Ctb->IVDT_EMIS),DTOC(EC5->EC5_DT_EMI),"3") //"DATA DA EMISSAO"
            ENDIF
         ENDIF

         IF EC5->EC5_DT_VEN #IV_Ctb->IVDT_VEN
            IF ! EMPTY(IV_Ctb->IVDT_VEN) .AND. EMPTY(EC5->EC5_DT_VEN)
               CR200_Crit("1",STR0012,DTOC(IV_Ctb->IVDT_VEN),DTOC(EC5->EC5_DT_VEN),"2") //"DATA DE VENCIMENTO"
               EC5->EC5_DT_VEN := IV_Ctb->IVDT_VEN
               MAlterou := .T.
            ELSE
               CR200_Crit("1",STR0012,DTOC(IV_Ctb->IVDT_VEN),DTOC(EC5->EC5_DT_VEN),"3") //"DATA DE VENCIMENTO"
            ENDIF
         ENDIF

         IF EC5->EC5_FORN # IV_Ctb->IVFORN
            IF ! EMPTY(IV_Ctb->IVFORN) .AND. EMPTY(EC5->EC5_FORN)
               CR200_Crit("1",STR0013,IV_Ctb->IVFORN+" "+ALLTRIM(IV_Ctb->IVNOM_FOR),EC5->EC5_FORN+" "+ALLTRIM(BuscaF_Fornec(EC5->EC5_FORN)),"2") //"CODIGO DO FORNECEDOR"
               EC5->EC5_FORN := IV_Ctb->IVFORN
               MAlterou := .T.
            ELSE
               CR200_Crit("1",STR0013,IV_Ctb->IVFORN+" "+ALLTRIM(IV_Ctb->IVNOM_FOR),EC5->EC5_FORN+" "+ALLTRIM(BuscaF_Fornec(EC5->EC5_FORN)),"3") //"CODIGO DO FORNECEDOR"
            ENDIF
         ENDIF

         IF EC5->EC5_MOE_FO #IV_Ctb->IVMOE_FOB
            IF ! EMPTY(IV_Ctb->IVMOE_FOB) .AND. EMPTY(EC5->EC5_MOE_FO)
               CR200_Crit("1",STR0014,IV_Ctb->IVMOE_FOB,EC5->EC5_MOE_FO,"2") //"MOEDA F.O.B."
               EC5->EC5_MOE_FO := IV_Ctb->IVMOE_FOB
               MAlterou := .T.
            ELSE
               CR200_Crit("1",STR0014,IV_Ctb->IVMOE_FOB,EC5->EC5_MOE_FO,"3") //"MOEDA F.O.B."
            ENDIF
         ENDIF

         IF EC5->EC5_FOB_TO #IV_Ctb->IVFOB_TOT
            IF ! EMPTY(IV_Ctb->IVFOB_TOT) .AND. EMPTY(EC5->EC5_FOB_TO)
               CR200_Crit("1",STR0015,ALLTRIM(TRANS(IV_Ctb->IVFOB_TOT,'@E 999,999,999,999.99')),ALLTRIM(TRANS(EC5->EC5_FOB_TO,'@E 999,999,999,999.99')),"2") //"VALOR F.O.B."
               EC5->EC5_FOB_TO := IV_Ctb->IVFOB_TOT
               MAlterou := .T.
            ELSE
               CR200_Crit("1",STR0015,ALLTRIM(TRANS(IV_Ctb->IVFOB_TOT,'@E 999,999,999,999.99')),ALLTRIM(TRANS(EC5->EC5_FOB_TO,'@E 999,999,999,999.99')),"3") //"VALOR F.O.B."
            ENDIF
         ENDIF

         IF EC5->EC5_IDENTC #IV_Ctb->IVIDENTCT
            IF ! EMPTY(IV_Ctb->IVIDENTCT) .AND. EMPTY(EC5->EC5_IDENTC)
               CR200_Crit("1",STR0016,IV_Ctb->IVIDENTCT,EC5->EC5_IDENTC,"2") //"B.U./ UNID. REQ. "
               EC5->EC5_IDENTC := IV_Ctb->IVIDENTCT
               MAlterou := .T.
            ELSE
               CR200_Crit("1",STR0016,IV_Ctb->IVIDENTCT,EC5->EC5_IDENTC,"3") //"B.U./ UNID. REQ. "
            ENDIF
         ENDIF

         IF MAlterou
            MConta := MConta + 1
         ENDIF

         EC5->(MSUNLOCK())
      ELSE
         IF EC5->EC5_INVOIC #IV_Ctb->IVINVOICE
            CR200_Crit("1",STR0009,IV_Ctb->IVINVOICE,EC5->EC5_INVOIC,"4") //"NUMERO DA INVOICE"
         ENDIF

         IF EC5->EC5_IDENTC #IV_Ctb->IVIDENTCT
            CR200_Crit("1",STR0017,IV_Ctb->IVIDENTCT,EC5->EC5_IDENTC,"4") //"B.U. / UNID. REQ."
         ENDIF

         IF EC5->EC5_DT_EMI #IV_Ctb->IVDT_EMIS
            CR200_Crit("1",STR0011,DTOC(IV_Ctb->IVDT_EMIS),DTOC(EC5->EC5_DT_EMI),"4") //"DATA DA EMISSAO"
         ENDIF

         IF EC5->EC5_DT_VEN #IV_Ctb->IVDT_VEN
            CR200_Crit("1",STR0012,DTOC(IV_Ctb->IVDT_VEN),DTOC(EC5->EC5_DT_VEN),"4") //"DATA DE VENCIMENTO"
         ENDIF

         IF EC5->EC5_FORN # IV_Ctb->IVFORN
            CR200_Crit("1",STR0013,IV_Ctb->IVFORN+" "+ALLTRIM(IV_Ctb->IVNOM_FOR),EC5->EC5_FORN+" "+ALLTRIM(BuscaF_Fornec(EC5->EC5_FORN)),"4") //"CODIGO DO FORNECEDOR"
         ENDIF

         IF EC5->EC5_MOE_FO #IV_Ctb->IVMOE_FOB
            CR200_Crit("1",STR0014,IV_Ctb->IVMOE_FOB,EC5->EC5_MOE_FO,"4") //"MOEDA F.O.B."
         ENDIF

         IF EC5->EC5_FOB_TO #IV_Ctb->IVFOB_TOT
            CR200_Crit("1",STR0015,ALLTRIM(TRANS(IV_Ctb->IVFOB_TOT,'@E 999,999,999,999.99')),ALLTRIM(TRANS(EC5->EC5_FOB_TO,'@E 999,999,999,999.99')),"4") //"VALOR F.O.B."
         ENDIF
      ENDIF
   ENDIF
   IV_Ctb->(DBSKIP())
ENDDO
IncProc(STR0004+PADL(MConta,5,'0')) //"No. de Invoices.:"

DBSELECTAREA('EC5')
COMMIT
Return .T.
*------------------------*
// Substituido pelo assistente de conversao do AP5 IDE em 01/12/99 ==> Function CR200Des
Static Function CR200Des()
*-------------------------*
ProcRegua(DI_Ctb->(LASTREC()))

IVH_Ctb->(DBSETORDER(1))

DBSELECTAREA('DI_Ctb')
DI_Ctb->(DBGOTOP())
MConta_DI := 0

DO WHILE ! DI_Ctb->(EOF())

   IncProc(STR0018+PADL(MConta_DI,5,'0')) //"No. de Despachos.:"

   EC6->(DBSETORDER(5))
   
   If ! EC6->(DBSEEK(cFilEC6+"IMPORT"+DI_Ctb->DIIDENTCT))

       IF  EC6->(DBSEEK(cFilEC6+"IMPORT"+"1000"))
	   
           DO  WHILE ! EC6->(EOF()) .AND. ALLTRIM(EC6->EC6_IDENTC)=="1000" .AND. EC6->EC6_FILIAL==cFilEC6 .AND. EC6->EC6_TPMODU == "IMPORT"
               EC6->(DBSKIP())
               MRecno := EC6->(RECNO())
               EC6->(DBSKIP(-1))
               TId_camp       := EC6->EC6_ID_CAM
               TIdentConta    := EC6->EC6_IDENTC
               TDescr         := EC6->EC6_DESC
               TContaDeb      := EC6->EC6_CTA_DB
               TContaCred     := EC6->EC6_CTA_CR
               TCod           := EC6->EC6_COD_HI
               TNome          := EC6->EC6_NO_CAM
               TCom_His       := EC6->EC6_COM_HI
               TCtaFinanceira := EC6->EC6_FINANC

               CR200LOCK("EC6",.T.)
               EC6->EC6_FILIAL := cFilEC6
               EC6->EC6_ID_CAM := TId_camp
               EC6->EC6_DESC   := TDescr
               EC6->EC6_CTA_DB := TContaDeb
               EC6->EC6_CTA_CR := TContaCred
               EC6->EC6_COD_HI := TCod
               EC6->EC6_COM_HI := TCom_His
               EC6->EC6_NO_CAM := TNome
               EC6->EC6_IDENTC := DI_Ctb->DIIDENTCT
               EC6->EC6_FINANC := TCtaFinanceira
               EC6->EC6_TPMODU := "IMPORT"
               EC6->(DBGOTO(MRecno))

           ENDDO
       ENDIF
	   
   ENDIF

   IF ! ECC->(DBSEEK(cFilECC+DI_Ctb->DIIDENTCT))
      CR200LOCK("ECC",.T.)
      ECC->ECC_FILIAL := cFilECC
      ECC->ECC_IDENTC := DI_Ctb->DIIDENTCT
      ECC->ECC_DESCR  := STR0019 //"A IDENTIFICAR"
   ENDIF

   EC6->(DBSETORDER(2))

   IVH_Ctb->(DBSETORDER(1))
   IVH_Ctb->(DBSEEK(DI_Ctb->DIHAWB+DI_Ctb->DIIDENTCT))
   MDespr_Inv := .F.

   MPO_Num_A := IVH_Ctb->IVHPO_NUM

   IV_Ctb->(DBSETORDER(2))
   IV_Ctb->(DBSEEK(DI_Ctb->DIHAWB+DI_Ctb->DIFORN+DI_Ctb->DIMOEDA+DI_Ctb->DIIDENTCT))
   MDespr_Inv := .F.
   DO WHILE ! IV_Ctb->(EOF()) .AND. (DI_Ctb->DIHAWB+DI_Ctb->DIFORN+DI_Ctb->DIMOEDA+DI_Ctb->DIIDENTCT)==(IV_Ctb->IVHAWB+IV_Ctb->IVFORN+IV_Ctb->IVMOE_FOB+IV_Ctb->IVIDENTCT)
      SYSREFRESH()
      MInvoice_A := IV_Ctb->IVINVOICE
      MIdentct_A := IV_Ctb->IVIDENTCT

      EC5->(DBSEEK(cFilEC5+IV_Ctb->IVFORN+MInvoice_A+MIdentct_A))

      IF ! EC5->(EOF()) .OR. ! IV_Ctb->(EOF())
         IF IV_Ctb->IV_AMOST $ cSim .OR. EC5->EC5_AMOS $ cSim
            MDespr_Inv := .T.
         ELSE
            MDespr_Inv := .F.
            EXIT
         ENDIF
      ENDIF

      IV_Ctb->(DBSKIP())
   ENDDO

   IF MDespr_Inv
      DI_Ctb->(DBSKIP())
      LOOP
   ENDIF


   IF ! EC2->(DBSEEK(cFilEC2+DI_Ctb->DIHAWB+DI_Ctb->DIFORN+DI_Ctb->DIMOEDA+DI_Ctb->DIIDENTCT))
      CR200LOCK("EC2",.T.)
      EC2->EC2_FILIAL  := cFilEC2
      EC2->EC2_HAWB    := DI_Ctb->DIHAWB
      EC2->EC2_IDENTC  := DI_Ctb->DIIDENTCT
      EC2->EC2_DI_NUM  := TransDI("EC2_DI_NUM",DI_Ctb->DIDI_NUM)//DI_Ctb->DIDI_NUM
      EC2->EC2_LOTE    := DI_Ctb->DILOTE
      EC2->EC2_SIS_OR  := "1"
      EC2->EC2_NF_ENT  := DI_Ctb->DINF_ENT
      EC2->EC2_FIM_CT  := "2" // Em Aberto
      EC2->EC2_DT      := DI_Ctb->DIDT
      EC2->EC2_NF_COM  := DI_Ctb->DINF_COMP
      EC2->EC2_DESP    := DI_Ctb->DIDESP       && LAB 08.05.00
      // EC2->EC2_FORN    := IVH_Ctb->IVHFORN
      EC2->EC2_SUB_SE  := DI_Ctb->DISUB_SET
      EC2->EC2_DTENCE  := DI_Ctb->DIDT_ENCE    && LAB 24.05.99
      EC2->EC2_FORN    := DI_Ctb->DIFORN
      EC2->EC2_MOEDA   := DI_Ctb->DIMOEDA

      EC2->(MSUNLOCK())
      CR200_Crit("2",STR0020,DI_Ctb->DIHAWB,SPACE(20),"1") //"NUMERO DO H.A.W.B."
      CR200_Crit("2",STR0021,TRANSF(DI_Ctb->DIDI_NUM, '@R 99/9999999-9'),SPACE(20),"1") //"NUMERO DA D.I."
      CR200_Crit("2",STR0022,DI_Ctb->DILOTE,SPACE(20),"1") //"NUMERO DO LOTE"
      CR200_Crit("2",STR0023,DI_Ctb->DINF_ENT,SPACE(20),"1") //"NUMERO DA N.F. ENTR."
      CR200_Crit("2",STR0024,DI_Ctb->DINF_COMP,SPACE(20),"1") //"NUMERO DA N.F. COMP."
      CR200_Crit("2",STR0025,DI_Ctb->DISUB_SET,SPACE(20),"1") //"NUMERO DA D.A.I."


      IF DI_Ctb->DIVL_DESP #0
         CR200_Cod("DIVL_DESP",DI_Ctb->DIDTP_DESP,DI_Ctb->DIVL_DESP)
         CR200_Crit("2",STR0026,ALLTRIM(TRANS(DI_Ctb->DIVL_DESP,'@E 999,999,999,999.99')),SPACE(20),"1") //"DEVOL. ADTO DESPACH."
         CR200_Crit("2",STR0027,DTOC(DI_Ctb->DIDTP_DESP),SPACE(20),"1") //"DATA DEVOLUCAO"
      ENDIF

      IF DI_Ctb->DIVL_DCI #0
         CR200_Cod("DIVL_DCI",DI_Ctb->DIDT_DCI,DI_Ctb->DIVL_DCI)
         CR200_Crit("2",STR0028,ALLTRIM(TRANS(DI_Ctb->DIVL_DCI,'@E 999,999,999,999.99')),SPACE(20),"1") //"VL_DCI"
         CR200_Crit("2",STR0029,DTOC(DI_Ctb->DIDT_DCI),SPACE(20),"1") //"DATA VL_DCI"
      ENDIF

      IF DI_Ctb->DIVL_ICMS #0
         CR200_Cod("DIVL_ICMS",DI_Ctb->DIDT_ENTR,DI_Ctb->DIVL_ICMS)
         CR200_Crit("2",STR0030,ALLTRIM(TRANS(DI_Ctb->DIVL_ICMS,'@E 999,999,999,999.99')),SPACE(20),"1") //"I.C.M.S."
      ENDIF

      IF DI_Ctb->DIICMS_C #0
         CR200_Cod("DIICMS_C",DI_Ctb->DIDT,DI_Ctb->DIICMS_C)
         CR200_Crit("2",STR0031,ALLTRIM(TRANS(DI_Ctb->DIICMS_C,'@E 999,999,999,999.99')),SPACE(20),"1") //"ICMS_C"
      ENDIF

      IF DI_Ctb->DIVL_ARM #0
         CR200_Cod("DIVL_ARM",DI_Ctb->DIDT_ARMZ,DI_Ctb->DIVL_ARM)
         CR200_Crit("2",STR0032,ALLTRIM(TRANS(DI_Ctb->DIVL_ARM,'@E 999,999,999,999.99')),SPACE(20),"1") //"COMPL. ADTO DESPACH."
         CR200_Crit("2",STR0033,DTOC(DI_Ctb->DIDT_ARMZ),SPACE(20),"1") //"DATA COMPLEMENTO"
      ENDIF

      IF DI_Ctb->DIVL_DAP #0
         CR200_Cod("DIVL_DAP",DI_Ctb->DIDT_ARMZ,DI_Ctb->DIVL_DAP)
         CR200_Crit("2",STR0034,ALLTRIM(TRANS(DI_Ctb->DIVL_DAP,'@E 999,999,999,999.99')),SPACE(20),"1") //"VL_DAP"
      ENDIF

      IF DI_Ctb->DIDESP_GI #0
         CR200_Cod("DIDESP_GI",DI_Ctb->DIDT_ARMZ,DI_Ctb->DIDESP_GI)
         CR200_Crit("2",STR0035,ALLTRIM(TRANS(DI_Ctb->DIDESP_GI,'@E 999,999,999,999.99')),SPACE(20),"1") //"N.F. COMPLEMENTAR"
      ENDIF

      IF DI_Ctb->DIDESP_CL #0
         CR200_Cod("DIDESP_CL",DI_Ctb->DIDT_ARMZ,DI_Ctb->DIDESP_CL)
         CR200_Crit("2",STR0036,ALLTRIM(TRANS(DI_Ctb->DIDESP_CL,'@E 999,999,999,999.99')),SPACE(20),"1") //"DESP_CL"
      ENDIF

      IF DI_Ctb->DIVL_FRETE #0
         CR200_Cod("DIVL_FRETE",DI_Ctb->DIDT,DI_Ctb->DIVL_FRETE)
         CR200_Crit("2",STR0037,ALLTRIM(TRANS(DI_Ctb->DIVL_FRETE,'@E 999,999,999,999.99')),SPACE(20),"1") //"VALOR DE FRETE"
      ENDIF

      IF DI_Ctb->DIFRETE_RO #0
         CR200_Cod("DIFRETE_RO",DI_Ctb->DIDTP_ROD,DI_Ctb->DIFRETE_RO)
         CR200_Crit("2",STR0038,ALLTRIM(TRANS(DI_Ctb->DIFRETE_RO,'@E 999,999,999,999.99')),SPACE(20),"1") //"FRETE_RO"
         CR200_Crit("2",STR0039,DTOC(DI_Ctb->DIDTP_ROD),SPACE(20),"1") //"DT. FRETE_RO"
      ENDIF

      IF DI_Ctb->DIVL_II #0
         CR200_Cod("DIVL_II",DI_Ctb->DIDT_ENTR,DI_Ctb->DIVL_II)
         CR200_Crit("2",STR0040,ALLTRIM(TRANS(DI_Ctb->DIVL_II,'@E 999,999,999,999.99')),SPACE(20),"1") //"I.I."
      ENDIF

      IF DI_Ctb->DIVL_IPI #0
         CR200_Cod("DIVL_IPI",DI_Ctb->DIDT_ENTR,DI_Ctb->DIVL_IPI)
         CR200_Crit("2",STR0041,ALLTRIM(TRANS(DI_Ctb->DIVL_IPI,'@E 999,999,999,999.99')),SPACE(20),"1") //"I.P.I."
      ENDIF

      IF DI_Ctb->DIVL_USSEG #0
         CR200_Cod("DIVL_USSEG",DI_Ctb->DIDT,DI_Ctb->DIVL_USSEG)
         CR200_Crit("2",STR0042,ALLTRIM(TRANS(DI_Ctb->DIVL_USSEG,'@E 999,999,999,999.99')),SPACE(20),"1") //"SEGURO"
      ENDIF

      IF DI_Ctb->DIVL_APORT #0
         CR200_Cod("DIVL_APORT",DI_Ctb->DIDT_ARMZ,DI_Ctb->DIVL_APORT)
         CR200_Crit("2",STR0043,ALLTRIM(TRANS(DI_Ctb->DIVL_APORT,'@E 999,999,999,999.99')),SPACE(20),"1") //"BAIXA ADTO DESPACH."
      ENDIF

      IF DI_Ctb->DIVL_AAER  #0
         CR200_Cod("DIVL_AAER",DI_Ctb->DIDT_ARMZ,DI_Ctb->DIVL_AAER)
         CR200_Crit("2",STR0043,ALLTRIM(TRANS(DI_Ctb->DIVL_AAER,'@E 999,999,999,999.99')),SPACE(20),"1") //"BAIXA ADTO DESPACH."
      ENDIF

      IF DI_Ctb->DIVL_ADAP  #0
         CR200_Cod("DIVL_ADAP",DI_Ctb->DIDT_ARMZ,DI_Ctb->DIVL_ADAP)
         CR200_Crit("2",STR0043,ALLTRIM(TRANS(DI_Ctb->DIVL_ADAP,'@E 999,999,999,999.99')),SPACE(20),"1") //"BAIXA ADTO DESPACH."
      ENDIF

      IF DI_Ctb->DIVL_701  #0
         CR200_Cod("DIVL_701",DI_Ctb->DIDT_DESEM,DI_Ctb->DIVL_701)
         CR200_Crit("2",STR0044,ALLTRIM(TRANS(DI_Ctb->DIVL_701,'@E 999,999,999,999.99')),SPACE(20),"1") //"VL_701"
      ENDIF

      IF DI_Ctb->DIVL_702  # 0             && LAB 02.05.00
         CR200_Cod("DIVL_702",DI_Ctb->DIDT_DESEM,DI_Ctb->DIVL_702)
         CR200_Crit("2",STR0045,ALLTRIM(TRANS(DI_Ctb->DIVL_702,'@E 999,999,999,999.99')),SPACE(20),"1") //"VL_702"
      ENDIF

      IF DI_Ctb->DIVL_702_P  #0
         CR200_Cod("DIVL_702_P",DI_Ctb->DIDT_DESEM,DI_Ctb->DIVL_702_P)
         CR200_Crit("2",STR0046,ALLTRIM(TRANS(DI_Ctb->DIVL_702_P,'@E 999,999,999,999.99')),SPACE(20),"1") //"VL_702_P"
      ENDIF

      IF DI_Ctb->DIVL_509  #0
         CR200_Cod("DIVL_509",DI_Ctb->DIDT_DESEM,DI_Ctb->DIVL_509)
         CR200_Crit("2",STR0047,ALLTRIM(TRANS(DI_Ctb->DIVL_509,'@E 999,999,999,999.99')),SPACE(20),"1") //"VL_509"
      ENDIF

      IF DI_Ctb->DIVL_620  #0
         CR200_Cod("DIVL_620",DI_Ctb->DIDT_620,DI_Ctb->DIVL_620)
         CR200_Crit("2",STR0048,ALLTRIM(TRANS(DI_Ctb->DIVL_620,'@E 999,999,999,999.99')),SPACE(20),"1") //"VALOR JUROS"
      ENDIF

      IF DI_Ctb->DIVL_621  #0
         CR200_Cod("DIVL_621",DI_Ctb->DIDT_621,DI_Ctb->DIVL_621)
         CR200_Crit("2",STR0049,ALLTRIM(TRANS(DI_Ctb->DIVL_621,'@E 999,999,999,999.99')),SPACE(20),"1") //"VALOR I.R."
      ENDIF

      IF DI_Ctb->DIVL_623  #0
         CR200_Cod("DIVL_623",DI_Ctb->DIDT_623,DI_Ctb->DIVL_623)
         CR200_Crit("2",STR0050,ALLTRIM(TRANS(DI_Ctb->DIVL_623,'@E 999,999,999,999.99')),SPACE(20),"1") //"VALOR DESP.BANCARIA"
      ENDIF

      IF DI_Ctb->DIVL_699  #0
         CR200_Cod("DIVL_699",DI_Ctb->DIDT_699,DI_Ctb->DIVL_699)
         CR200_Crit("2",STR0051,ALLTRIM(TRANS(DI_Ctb->DIVL_699,'@E 999,999,999,999.99')),SPACE(20),"1") //"VALOR CREDITO A BANCO"
      ENDIF

      IF DI_Ctb->DIVL_NFT  #0
         CR200_Cod("DIVL_NFT",DI_Ctb->DIDT,DI_Ctb->DIVL_NFT)
         CR200_Crit("2",STR0052,ALLTRIM(TRANS(DI_Ctb->DIVL_NFT,'@E 999,999,999,999.99')),SPACE(20),"1") //"CREDITO-IMPORT. EM ANDAMENTO"
      ENDIF

      IF DI_Ctb->DIVL_NF #0
         CR200_Cod("DIVL_NF",DI_Ctb->DIDT_NF,DI_Ctb->DIVL_NF)
         CR200_Crit("2",STR0053,ALLTRIM(TRANS(DI_Ctb->DIVL_NF,'@E 999,999,999,999.99')),SPACE(20),"1") //"N.F. ENTRADA"
      ENDIF

      IF DI_Ctb->DIVL_NFC #0
         CR200_Cod("DIVL_NFC",DI_Ctb->DIDT_NFC,DI_Ctb->DIVL_NFC)
         CR200_Crit("2",STR0035,ALLTRIM(TRANS(DI_Ctb->DIVL_NFC,'@E 999,999,999,999.99')),SPACE(20),"1") //"N.F. COMPLEMENTAR"
      ENDIF

      IF ! EMPTY(DI_Ctb->DIDT)
         CR200_Crit("2",STR0054,DTOC(DI_Ctb->DIDT),SPACE(20),"1") //"DATA PAGTO. IMPOSTOS"
      ENDIF

      IV_Ctb->(DBSETORDER(2))
      IV_Ctb->(DBSEEK(DI_Ctb->DIHAWB+DI_Ctb->DIFORN+DI_Ctb->DIMOEDA+DI_Ctb->DIIDENTCT))
      DO WHILE ! IV_Ctb->(EOF()) .AND. (DI_Ctb->DIHAWB+DI_Ctb->DIFORN+DI_Ctb->DIMOEDA+DI_Ctb->DIIDENTCT)==(IV_Ctb->IVHAWB+IV_Ctb->IVFORN+IV_Ctb->IVMOE_FOB+IV_Ctb->IVIDENTCT)

         SYSREFRESH()

         MFob_Vlr   := IV_Ctb->IVFOB_TOT
         MInvoice_A := IV_Ctb->IVINVOICE
         MIdentct_A := IV_Ctb->IVIDENTCT                        
         MForn_A    := IV_Ctb->IVFORN
         MMoeda_A   := IV_Ctb->IVMOE_FOB

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

         cAuxFor := U_CR200Inv_For(MInvoice_A,IV_Ctb->IVFORN)
         CR200_Crit("2",STR0055,ALLTRIM(MPO_NUM_A)+" "+ALLTRIM(MInvoice_A)+" "+cAuxFor,SPACE(20),"1")    //"NRO. P.O./INV./FORN."
         CR200_Crit("2",STR0056,ALLTRIM(TRANS(EC8->EC8_FOB_PO,'@E 999,999,999,999.99')),SPACE(20),"1") //"VALOR FOB P.O."
         IV_Ctb->(DBSKIP())
      ENDDO

      MValor_FOB := 0

      EC8->(DBSEEK(cFilEC8+DI_Ctb->DIHAWB+DI_Ctb->DIFORN+DI_Ctb->DIMOEDA+DI_Ctb->DIIDENTCT))

      DO WHILE ! EC8->(EOF()) .AND. (DI_Ctb->DIHAWB+DI_Ctb->DIFORN+DI_Ctb->DIMOEDA+DI_Ctb->DIIDENTCT)==(EC8->EC8_HAWB+EC8->EC8_FORN+EC8->EC8_MOEDA+EC8->EC8_IDENTC) .AND. EC8->EC8_FILIAL==cFilEC8
         SYSREFRESH()

         MValor_FOB := MValor_FOB + EC8->EC8_FOB_PO
         EC8->(DBSKIP())
      ENDDO

      CR200LOCK("EC2",.F.)
      EC2->EC2_FOB_DI := MValor_FOB
      EC2->EC2_TX_DI  := Di_Ctb->DITX_FOB
//    EC2->EC2_TX_USD := Di_Ctb->DITX_DIUSD        && LAB 26.08.99

      IF  "CIBIE" $ UPPER(SM0->M0_NOME)                && LAB 01.06.00
          EC2->EC2_TX_USD := Di_Ctb->DITX_DIUSD        && LAB 01.06.00
      ENDIF

      EC2->(MSUNLOCK())

      IF Di_Ctb->DITX_FOB #0
         IF EC2->EC2_FOB_DI #0
            CR200_Cod("HDIFOB_DI",DI_Ctb->DIDT,EC2->EC2_FOB_DI*Di_Ctb->DITX_FOB)
         ENDIF
         CR200_Crit("2",STR0057,ALLTRIM(TRANS(EC2->EC2_TX_DI,'@E 999,999.999999')),SPACE(20),"1") //"TAXA FOB INVOICE"
      ENDIF

//    IF Di_Ctb->DITX_DIUSD # 0                    && LAB 26.08.99
//       CR200_Crit("2","TAXA USD D.I.",ALLTRIM(TRANS(EC2->EC2_TX_USD,'@E 999,999.999999')),SPACE(20),"1")
//    ENDIF

      IF  "CIBIE" $ UPPER(SM0->M0_NOME)                && LAB 01.06.00
          IF Di_Ctb->DITX_DIUSD # 0                    
             CR200_Crit("2",STR0058,ALLTRIM(TRANS(EC2->EC2_TX_USD,'@E 999,999.999999')),SPACE(20),"1") //"TAXA USD D.I."
          ENDIF
      ENDIF

      MConta_DI := MConta_DI + 1
   ELSE
   
      ExecBlock("ECOCR20C",.F.,.F.)  
      
   ENDIF
   DI_Ctb->(DBSKIP())
ENDDO
IncProc(STR0018+PADL(MConta_DI,5,'0')) //"No. de Despachos.:"

Return .T.
*---------------------------*
// Substituido pelo assistente de conversao do AP5 IDE em 01/12/99 ==> Function CR200Pag
Static Function CR200Pag()
*---------------------------*
// Variaveis de utilidade exclusiva do pagamento antecipado
Local nOrdemECF, nOrdemEC6, nRecnoEC6, lInclui, cSeq := Space(04)
Local cFilSA2 := xFilial("SA2"), MCTA_DEB := " ", MCTA_CRE := " "   

ProcRegua(APD_Ctb->(LASTREC()))

APD_Ctb->(DBGOTOP())

TMes := STRZERO(VAL(SUBSTR(cMESPROC,1,2))+1,2,0)
TAno := SUBSTR(cMESPROC,3,4)
IF TMes == "13"
   TMes := "01"
   TAno := STRZERO(VAL(TAno)+1,4,0)
ENDIF

TData_Con := AVCTOD("01/"+TMes+"/"+TAno) - 1
MNr_Cont  := 9999

DO WHILE ! APD_Ctb->(EOF())

   IncProc(STR0059) //"Pagamentos..."

   EC5->(DBSETORDER(1))

   IF ! EC5->(DBSEEK(cFilEC5+APD_Ctb->APDFORN+APD_Ctb->APDINVOICE+APD_Ctb->APDIDENTCT ))  
      mMemo:=mMemo+STR0005 + ALLTRIM(APD_Ctb->APDINVOICE) + STR0060 + ALLTRIM(APD_Ctb->APDIDENTCT) + STR0061+CHR(13)+CHR(10) //"Invoice "###" BU/UNID. REQ. "###" nao cadastrada no arquivo de invoices."
      APD_Ctb->(DBSKIP())
      LOOP
   ENDIF

   IF  APD_Ctb->APDTIPOREG == "2"  // Juros nao deve gravar VCF000
       APD_Ctb->(DBSKIP())
       LOOP
   ENDIF

   EC9->(DBSETORDER(2))
   EC9->(DBSEEK(cFilEC9+APD_Ctb->APDFORN+APD_Ctb->APDINVOICE+APD_Ctb->APDIDENTCT+"6"))  // evitar duplicidade

   MJa_Pago := .F.
   DO  WHILE ! EC9->(EOF()) .AND. (APD_Ctb->APDFORN+APD_Ctb->APDINVOICE+APD_Ctb->APDIDENTCT+"6") == ;
              (EC9->EC9_FORN+EC9->EC9_INVOIC+EC9->EC9_IDENTC+LEFT(EC9->EC9_ID_CAM,1)) .AND. EC9->EC9_FILIAL==cFilEC9
       
       IF  VAL(EC9->EC9_NR_CON)==0 .OR. VAL(EC9->EC9_NR_CON) == 9999
           If EC9->EC9_VL_MOE == APD_Ctb->APDFOBMOE  
              MJa_Pago := .T.  
           EndIf
       ELSE
           IF EC9->EC9_DTCONT==APD_Ctb->APDCA_DT .AND. EC9->EC9_VL_MOE==APD_Ctb->APDFOBMOE
              MJa_Pago := .T.
           ENDIF
       ENDIF
       EC9->(DBSKIP())
   ENDDO

   IF  MJa_Pago
       APD_Ctb->(DBSKIP())
       LOOP
   ENDIF

   CR200LOCK("EC9",.T.)
   EC9->EC9_FILIAL  := cFilEC9
   EC9->EC9_INVOIC  := APD_Ctb->APDINVOICE
   EC9->EC9_IDENTC  := APD_Ctb->APDIDENTCT
   EC9->EC9_DT_LAN  := TData_Con
   EC9->EC9_DTCONT  := APD_Ctb->APDCA_DT
   EC9->EC9_DTCONV  := AVCTOD("  /  /  ")
   EC9->EC9_PARIDA  := APD_Ctb->APDCA_TX
   EC9->EC9_FLUTUA  := APD_Ctb->APDCA_TX
   EC9->EC9_NR_CON  := '0000'
   EC9->EC9_VALOR   := VAL(STR(APD_Ctb->APDFOBMOE * APD_Ctb->APDCA_TX,15,2))
   EC9->EC9_VL_MOE  := APD_Ctb->APDFOBMOE
   EC9->EC9_DESCR   := APD_Ctb->APDBCO_CON + " " + DTOC(APD_Ctb->APDDT_CONT) + " " + ALLTRIM(APD_Ctb->APDHAWB)  && LAB 26.11.99
   EC9->EC9_LANCMA  := '2'
   EC9->EC9_FORN    := APD_Ctb->APDFORN    
   EC9->EC9_SEQ  := APD_Ctb->APDSEQ

   
   DO  CASE
       CASE  APD_Ctb->APDTIPOREG $ "1A"  // Principal e frete intl
             IF  EC5->EC5_CD_PGT == "1"
                 EC9->EC9_ID_CAM := "602"
             ELSE
                 EC9->EC9_ID_CAM := "603"
             ENDIF
       CASE  APD_Ctb->APDTIPOREG == "4"   // Liquid.Futura
             IF  EC5->EC5_CD_PGT == "1"
                 EC9->EC9_ID_CAM := "612"
             ELSE
                 EC9->EC9_ID_CAM := "613"
             ENDIF
*      CASE  APD_Ctb->APDTIPOREG == "2"   // Juros
*            EC9->EC9_ID_CAM     := "620"
*      CASE  APD_Ctb->APDTIPOREG == "3"   // I.R.
*            EC9->EC9_ID_CAM     := "621"
       CASE  APD_Ctb->APDTIPOREG == "5"   // Abatimento
             EC9->EC9_ID_CAM     := "622"
*      CASE  APD_Ctb->APDTIPOREG == "6"   // Despesas bancarias
*            EC9->EC9_ID_CAM     := "623"
       OTHERWISE
             EC9->EC9_ID_CAM     := "624"
   ENDCASE

   EC9->(MSUNLOCK())

   APD_Ctb->(DBSKIP())
ENDDO

// Transfere do ANT_CTB p/ ECF
If lExisteECF   
   nOrdemECF  := ECF->(IndexOrd())
   nOrdemEC6  := EC6->(IndexOrd())
   nRecnoEC6  := EC6->(Recno())
   lInclui    := .T.
   SA2->(DbSetOrder(1))
   EC6->(DbSetOrder(1))

   ECF->(DBSETORDER(3))
   ANT_Ctb->(DbGotop())
   DO WHILE ! ANT_Ctb->(EOF())      

      IncProc(STR0059) //"Pagamentos..."
            
      // Verifica se existe o evento 608                          
      If ! ECF->(DBSEEK(cFilECF+"IMPORT"+ANT_Ctb->ANTHAWB+ANT_Ctb->ANTFORN+ANT_Ctb->ANTIDENTCT+ANT_Ctb->ANTORIGEM+ANT_Ctb->ANTINVOICE+ANT_Ctb->ANTSEQ+"608"))  // evitar duplicidade      //AOM - 19/07/2012 - Adicionada na chave "IMPORT"  
      
         //AAF 29/09/2012 - Utilizar conta padrao caso não encontre a configuração especifica para o centro de custo.
         If !EC6->(DbSeek(xFilial()+"IMPORT"+"608"+ANT_Ctb->ANTIDENTCT))
            EC6->(DbSeek(xFilial()+"IMPORT"+"608"))
         EndIf
         
         //AAF 29/09/2012 - Tradução das mascaras das contas contabeis.
		 MCTA_DEB := EasyMascCon(EC6->EC6_CTA_DB,ANT_Ctb->ANTFORN,"",/* cImport */,/* cLojaImp */,ANT_Ctb->ANTBANCO,ANT_Ctb->ANTAGENCIA,ANT_Ctb->ANTCONTA,'IMPORT',"608")
		 MCTA_CRE := EasyMascCon(EC6->EC6_CTA_CR,ANT_Ctb->ANTFORN,"",/* cImport */,/* cLojaImp */,ANT_Ctb->ANTBANCO,ANT_Ctb->ANTAGENCIA,ANT_Ctb->ANTCONTA,'IMPORT',"608")
      
         CR200LOCK("ECF",.T.)      
         //FSM - 24/10/2012      
         ECF->ECF_FILIAL  := cFilECF
         ECF->ECF_INVOIC  := ANT_Ctb->ANTINVOICE
         ECF->ECF_HAWB    := ANT_Ctb->ANTHAWB	      
         ECF->ECF_IDENTC  := ANT_Ctb->ANTIDENTCT
         ECF->ECF_DTCONT  := ANT_Ctb->ANTCA_DT
         ECF->ECF_DTCONV  := AVCTOD("  /  /  ")
         ECF->ECF_PARIDA  := ANT_Ctb->ANTCA_TX
         ECF->ECF_FLUTUA  := 0
         ECF->ECF_NR_CON  := '9999'
         ECF->ECF_VALOR   := VAL(STR(ANT_Ctb->ANTFOBMOE * ANT_Ctb->ANTCA_TX,15,2))
         ECF->ECF_VL_MOE  := ANT_Ctb->ANTFOBMOE
         ECF->ECF_DESCR   := ANT_Ctb->ANTBCO_CON + " " + DTOC(ANT_Ctb->ANTDT_CONT) + " " + ALLTRIM(ANT_Ctb->ANTHAWB)  
         ECF->ECF_ID_CAM  := "608"
         ECF->ECF_MOEDA   := ANT_Ctb->ANTMOEDA
         ECF->ECF_ORIGEM  := ANT_CTb->ANTORIGEM       
         ECF->ECF_FORN    := ANT_Ctb->ANTFORN    
         ECF->ECF_SEQ     := ANT_Ctb->ANTSEQ    
		 
         If MCTA_DEB = "999999999999999"
            IF SA2->(DBSEEK(cFilSA2+ANT_Ctb->ANTFORN)) .AND. ! EMPTY(ALLTRIM(ANT_Ctb->ANTFORN))
               MCTA_DEB = IF(!EMPTY(ALLTRIM(SA2->A2_CONTAB)), ALLTRIM(SA2->A2_CONTAB),"999999999999999")
            ENDIF
         Endif 
         If MCTA_CRE = "999999999999999"
            IF SA2->(DBSEEK(cFilSA2+ANT_Ctb->ANTFORN)) .AND. ! EMPTY(ALLTRIM(ANT_Ctb->ANTFORN))
               MCTA_CRE = IF(!EMPTY(ALLTRIM(SA2->A2_CONTAB)), ALLTRIM(SA2->A2_CONTAB),"999999999999999")
            ENDIF
         Endif    
         ECF->ECF_CTA_DB := MCTA_DEB
         If Empty( MCTA_CRE )
            Sa6->( DbSeek( xFilial( "SA6" )+Trim(ANT_Ctb->ANTBANCO)+Trim(ANT_Ctb->ANTAGENCIA) ) )
            mCta_Cre:=Sa6->A6_Contabi

         End
         ECF->ECF_CTA_CR := MCTA_CRE 
         //AOM - 19/07/2012
         ECF->ECF_TPMODU := "IMPORT"
         ECF->ECF_LINK   :="608"
         ECF->(MSUNLOCK())              
         If lExisteECG
      	    GravaECG()
         Endif 	 
      EndIf             
      ANT_Ctb->(DBSKIP())
   ENDDO
   ECF->(DbSetOrder(nOrdemECF))                                     
   EC6->(DbSetOrder(nOrdemEC6))                                     
   EC6->(DbGoto(nRecnoEC6))
Endif

IncProc(STR0059) //"Pagamentos..."

Return .T.
*------------------------------*
STATIC FUNCTION GravaECG()
*------------------------------*
Local nOrdemSW6 := SW6->(IndexOrd()), nRecnoSW6  := SW6->(Recno()), cFilECG := xFilial("ECG")

SW6->(DbSetOrder(1))
ECG->(DbSetOrder(1))                     
SW6->(DbSeek(xFilial()+ANT_Ctb->ANTHAWB))

If !ECG->(DbSeek(cFilECG+"IMPORT"+ANT_Ctb->ANTHAWB+ANT_Ctb->ANTFORN+ANT_Ctb->ANTIDENTCT+ANT_Ctb->ANTORIGEM))//AOM - 19/07/2012 - Adicionada na chave "IMPORT"          
   CR200LOCK("ECG",.T.)
   ECG->ECG_FILIAL  := cFilECG
   ECG->ECG_HAWB    := SW6->W6_HAWB
   ECG->ECG_IDENTC  := ANT_Ctb->ANTIDENTCT
   ECG->ECG_SIS_OR  := "1"
   ECG->ECG_NR_CON  := "9999"   
   ECG->ECG_DT      := SW6->W6_DT
   ECG->ECG_ORIGEM  := ANT_Ctb->ANTORIGEM  
   ECG->ECG_FORN    := ANT_Ctb->ANTFORN 
   //AOM - 19/07/2012
   ECG->ECG_DTENCE  := CTOD(' /  / ') 
   ECG->ECG_TPMODU := "IMPORT" 
   ECG->(MSUNLOCK()) 
ElseIf ! Empty(ECG->ECG_DTENCE)
   CR200LOCK("ECG",.F.)
   ECG->ECG_DTENCE := CTOD("")
   ECG->(MSUNLOCK()) 
Endif                   



SW6->(DbSetOrder(nOrdemSW6))                                     
SW6->(DbGoto(nRecnoSW6))

Return .T.
*-----------------------------------------*
STATIC FUNCTION TransDI(cCpoAtu,cCpoCont)
*-----------------------------------------*
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

*----------------------------*
Static Function CR200ApaPag()
*----------------------------*
Local lConecTop := .F.

#IFDEF TOP            
  IF (TcSrvType() != "AS/400")   // Considerar qdo for AS/400 para que tenha o tratamento de Codbase
     lConecTop := .T. //FSM - 24/10/2012
  Endif
#ENDIF 

If lConecTop
  IF EC9->(RECCOUNT())/1024 < 1
     nCount := 1
  Else
     nCount := Round(EC9->(RECCOUNT())/1024,0)
  EndIf
  ProcRegua(nCount)
  SX2->(DBSEEK("EC9"))
  nCount:=EC9->(RECCOUNT())

  nCont := 0
  // APAGA A CADA 1024 PARA NÃO ENCHER O LOG DO BANCO!
  While nCont <= nCount
       IncProc(STR0065)
       cQuery := "DELETE FROM "+SX2->X2_ARQUIVO
       cQuery := cQuery + " WHERE R_E_C_N_O_ between "+Str(nCont)+" AND "+Str(nCont+1024)
       cQuery := cQuery + " AND EC9_LANCMA <> '1'"
       cQuery := cQuery + " AND (EC9_ID_CAM = '603') AND EC9_NR_CON IN ('0000','9999')"
       cQuery := cQuery + " AND (EC9_FILIAL = '"+cFilEC9+"' "
       nCont := nCont + 1024
       TCSQLEXEC(cQuery)
  Enddo
Else
  ProcRegua(EC9->(LASTREC()))
  EC9->(DbSetOrder(3))
  EC9->(DbSeek(cFilEC9+"0000"))
  DO WHILE ! EC9->(EOF()) .AND. EC9->EC9_FILIAL==cFilEC9 .and. EC9->EC9_NR_CON = "0000"
     IncProc(STR0065)
     IF EC9->EC9_ID_CAM # '603'
        EC9->(DBSKIP())   
        Loop
     EndIf
     IF EC9->EC9_LANCMA <> '1' .And. VAL(EC9->EC9_NR_CON)==0 .OR. VAL(EC9->EC9_NR_CON) == 9999  
        CR200LOCK("EC9",.F.)
        EC9->(DBDELETE())
        EC9->(MSUNLOCK())              
     ENDIF
     EC9->(DBSKIP())
  ENDDO   
  EC9->(DbSeek(cFilEC9+"9999"))
  DO WHILE ! EC9->(EOF()) .AND. EC9->EC9_FILIAL==cFilEC9 .and. EC9->EC9_NR_CON = "9999"
     IncProc(STR0065)
     IF EC9->EC9_ID_CAM # '603'
        EC9->(DBSKIP())   
        Loop
     EndIf
     IF EC9->EC9_LANCMA <> '1' .And. VAL(EC9->EC9_NR_CON)==0 .OR. VAL(EC9->EC9_NR_CON) == 9999  
        CR200LOCK("EC9",.F.)
        EC9->(DBDELETE())
        EC9->(MSUNLOCK())              
     ENDIF
     EC9->(DBSKIP())
  ENDDO   
  EC9->(DbSetOrder(1))
ENDIF

Return .T.
                
*----------------------------*
Static Function CR200Apa2Pag()
*----------------------------*
Local lConecTop := .F.

#IFDEF TOP            
  IF (TcSrvType() != "AS/400")   // Considerar qdo for AS/400 para que tenha o tratamento de Codbase
     lConecTop := .T. //FSM - 24/10/2012
  Endif
#ENDIF 

If lConecTop
   IF EC7->(RECCOUNT())/1024 < 1
      nCount := 1
   Else
      nCount := Round(EC7->(RECCOUNT())/1024,0)
   EndIf
   ProcRegua(nCount)
   SX2->(DBSEEK("EC7"))
   nCount:=EC7->(RECCOUNT())

   nCont := 0
   // APAGA A CADA 1024 PARA NÃO ENCHER O LOG DO BANCO!
   While nCont <= nCount
        IncProc(STR0066)
        cQuery := "DELETE FROM "+SX2->X2_ARQUIVO
    	cQuery := cQuery + " WHERE R_E_C_N_O_ between "+Str(nCont)+" AND "+Str(nCont+1024)
    	cQuery := cQuery + " AND EC7_ID_CAM = '603' AND EC7_NR_CON IN ('0000','9999')"
 	    nCont := nCont + 1024
    	TCSQLEXEC(cQuery)
   Enddo
Else
  ProcRegua(EC7->(LASTREC()))
  EC7->(DBGOTOP())
  DO WHILE ! EC7->(EOF()) .AND. EC7->EC7_FILIAL==cFilEC7       
     IncProc(STR0066)
     IF EC7->EC7_ID_CAM # '603'
        EC7->(DBSKIP())   
        Loop
     EndIf
     IF VAL(EC7->EC7_NR_CON)==0 .OR. VAL(EC7->EC7_NR_CON) == 9999
        CR200LOCK("EC7",.F.)
        EC7->(DBDELETE())
        EC7->(MSUNLOCK())              
     ENDIF
     EC7->(DBSKIP())
  ENDDO
Endif

Return .T.

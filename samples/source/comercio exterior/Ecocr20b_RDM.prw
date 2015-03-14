#INCLUDE "Ecocr20b.ch"
#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 01/12/99
#include "Average.ch"


User Function Ecocr20b()        // incluido pelo assistente de conversao do AP5 IDE em 01/12/99

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CTRAVAALIAS,LTRAVA,PDESCCPO,PDATA,PDESC,PDESCRICAO")
SetPrvt("PCAMPO,PINVOICE,PTIPO_INT,PENVIO,PEXISTE,PSTATUS,PFORN")
SetPrvt("LRETCR20B,OLDSEL,MEXISTE,MTROCA_FOB,MTEXTO,OLDSELE")
SetPrvt("LRETLOCAL,MTROCADT,CALIASLOCK,LRETLOCK,")

#xTranslate CR200LOCK(<cTravaAlias>,<lTrava>) => ;
                      Eval({|| cTravaAlias:=<cTravaAlias>,;
                               lTrava     :=<lTrava>,;
                               CR200LOCK() })// Substituido pelo assistente de conversao do AP5 IDE em 01/12/99 ==>                                Execute(CR200LOCK) })
                      
#xTranslate CR200Existe(<PDescCpo>) => Eval({|| PDescCpo := <PDescCpo>,;
                                                CR200Existe()})// Substituido pelo assistente de conversao do AP5 IDE em 01/12/99 ==>                                                 Execute(CR200Existe)})

#xTranslate CR200_VerDt(<PData>,<PDesc>,<PDescricao>) => ;
                            Eval({|| PData     :=<PData>,;
                                     PDesc     :=<PDesc>,;
                                     PDescricao:=<PDescricao>,;
                                     CR200_VerDt()})// Substituido pelo assistente de conversao do AP5 IDE em 01/12/99 ==>                                      Execute(CR200_VerDt)})

#xTranslate CR200_Verif(<PDescCpo>,<PData>,<PCampo>,<PDescricao>) => ;
                                Eval({|| PDescCpo  :=<PDescCpo>,;
                                         PData     :=<PData>,; 
                                         PCampo    :=<PCampo>,;
                                         PDescricao:=<PDescricao>,;
                                         CR200_Verif()})// Substituido pelo assistente de conversao do AP5 IDE em 01/12/99 ==>                                          Execute(CR200_Verif)})

#xTranslate CR200_Cod(<PDescCpo>,<PData>,<PCampo>) => ;
                                 Eval({|| PDescCpo:=<PDescCpo>,;
                                          PData   :=<PData>,;
                                          PCampo  :=<PCampo>,;
                                          CR200_Cod()})// Substituido pelo assistente de conversao do AP5 IDE em 01/12/99 ==>                                           Execute(CR200_Cod)})

//#xTranslate CR200Inv_For(<PInvoice>,<PForn>) => Eval({|| PInvoice := <PInvoice>, PForn := <PForn>,;																		
//                                                U_CR200Inv_For()})// Substituido pelo assistente de conversao do AP5 IDE em 01/12/99 ==>                                                 Execute(CR200Inv_For)})

#xTranslate CR200_Crit(<PTipo_Int>,<PDesc>,<PEnvio>,<PExiste>,<PStatus>) => ;
                                 Eval({|| PTipo_Int:=<PTipo_Int>,;
                                          PDesc    :=<PDesc>,;
                                          PEnvio   :=<PEnvio>,;
                                          PExiste  :=<PExiste>,;
                                          PStatus  :=<PStatus>,;
                                          CR200_Crit()})// Substituido pelo assistente de conversao do AP5 IDE em 01/12/99 ==>                                           Execute(CR200_Crit)})

cFilSA2:=xFilial('SA2');cFilEC5:=xFilial('EC5');cFilEC6:=xFilial('EC6');cFilECC:=xFilial('ECC')
cFilEC2:=xFilial('EC2');cFilEC8:=xFilial('EC8');cFilEC9:=xFilial('EC9');cFilEC4:=xFilial('EC4')
cFilEC0:=xFilial('EC0')

// Verifica se existe o campo EC9_FORN / EC8_FORN
Private lExisteECF := .F. 

SX3->(DbSetOrder(1))

// Verifica se existe a opcao de pagamento antecipado
lExisteECF := GetMV("MV_PAGANT", .F., .F.)

Do Case 
   Case ParamIXB == 1
        lRetCR20B:=CR200LOCK()// Substituido pelo assistente de conversao do AP5 IDE em 01/12/99 ==>         lRetCR20B:=Execute(CR200LOCK)
   Case ParamIXB == 2
        lRetCR20B:=CR200Existe()// Substituido pelo assistente de conversao do AP5 IDE em 01/12/99 ==>         lRetCR20B:=Execute(CR200Existe)
   Case ParamIXB == 3
        lRetCR20B:=CR200_VerDt()// Substituido pelo assistente de conversao do AP5 IDE em 01/12/99 ==>         lRetCR20B:=Execute(CR200_VerDt)
   Case ParamIXB == 4
        lRetCR20B:=CR200_Verif()// Substituido pelo assistente de conversao do AP5 IDE em 01/12/99 ==>         lRetCR20B:=Execute(CR200_Verif)
   Case ParamIXB == 5
        lRetCR20B:=CR200_Cod()// Substituido pelo assistente de conversao do AP5 IDE em 01/12/99 ==>         lRetCR20B:=Execute(CR200_Cod)
   Case ParamIXB == 6
        lRetCR20B:=CR200Inv_For()// Substituido pelo assistente de conversao do AP5 IDE em 01/12/99 ==>         lRetCR20B:=Execute(CR200Inv_For)
   Case ParamIXB == 7
        lRetCR20B:=CR200_Crit()// Substituido pelo assistente de conversao do AP5 IDE em 01/12/99 ==>         lRetCR20B:=Execute(CR200_Crit)
   Case ParamIXB == 8
        lRetCR20B:=CR200Abre()// Substituido pelo assistente de conversao do AP5 IDE em 01/12/99 ==>         lRetCR20B:=Execute(CR200Abre)
EndCase   

If lRetCR20B==Nil
   lRetCR20B:=.T.
EndIf

// Substituido pelo assistente de conversao do AP5 IDE em 01/12/99 ==> __RETURN(lRetCR20B)
Return(lRetCR20B)        // incluido pelo assistente de conversao do AP5 IDE em 01/12/99

    
*-------------------*
// Substituido pelo assistente de conversao do AP5 IDE em 01/12/99 ==> FUNCTION CR200Existe
Static FUNCTION CR200Existe()
*-------------------*

OldSel := SELECT()

EC6->(DBSEEK(xFilial("EC6")+"IMPORT"+PDescCpo+SPACE(10-LEN(PDescCpo))+DI_Ctb->DIIDENTCT))

MExiste := .F.
DO WHILE ! EC6->(EOF()) .AND. ALLTRIM(PDescCpo) == ALLTRIM(EC6->EC6_NO_CAM) .AND.;
           DI_Ctb->DIIDENTCT == EC6->EC6_IDENTC .AND. EC6->EC6_FILIAL==xFilial("EC6") .AND. ;
           EC6->EC6_TPMODU == "IMPORT"

   SYSREFRESH()

   EC4->(DBSEEK(xFilial("EC4")+DI_Ctb->DIHAWB+DI_Ctb->DIFORN+DI_Ctb->DIMOEDA+DI_Ctb->DIIDENTCT+EC6->EC6_ID_CAM))
   IF ! EC4->(EOF())
      MExiste := .T.
      EXIT
   ELSE
      MExiste := .F.
   ENDIF
   EC6->(DBSKIP())
ENDDO

SELECT(OldSel)

RETURN MExiste

*-------------------*
// Substituido pelo assistente de conversao do AP5 IDE em 01/12/99 ==> FUNCTION CR200_Verif
Static FUNCTION CR200_Verif()
*-------------------*

OldSel := SELECT()

PCampo := VAL(SUBSTR(STR(PCampo,16,3),1,15))

EC6->(DBSEEK(xFilial("EC6")+"IMPORT"+PDescCpo+SPACE(10-LEN(PDescCpo))+DI_Ctb->DIIDENTCT))

DO WHILE ! EC6->(EOF()) .AND. ALLTRIM(PDescCpo) == ALLTRIM(EC6->EC6_NO_CAM) .AND. ;
        DI_Ctb->DIIDENTCT == EC6->EC6_IDENTC .AND. EC6->EC6_FILIAL==xFilial("EC6") .AND. ;
        EC6->EC6_TPMODU == "IMPORT"

   SYSREFRESH()

   EC4->(DBSEEK(xFilial("EC4")+DI_Ctb->DIHAWB+DI_Ctb->DIFORN+DI_Ctb->DIMOEDA+DI_Ctb->DIIDENTCT+EC6->EC6_ID_CAM))

   DO WHILE ! EC4->(EOF()) .AND. (DI_Ctb->DIHAWB+DI_Ctb->DIFORN+DI_Ctb->DIMOEDA+DI_Ctb->DIIDENTCT)==(EC4->EC4_HAWB+EC4->EC4_FORN+EC4->EC4_MOEDA+EC4->EC4_IDENTC) .AND. ;   
      EC6->EC6_ID_CAM==EC4->EC4_ID_CAM .AND. EC4->EC4_FILIAL==xFilial("EC4")
      SYSREFRESH()
      IF PCampo <> EC4->EC4_VL_CAM
         IF VAL(EC4->EC4_NR_CON) <> 0
            CR200_Crit("2",STR0001+PDescricao+STR0002+EC6->EC6_ID_CAM,ALLTRIM(TRANS(PCampo,'@E 999,999,999,999.99')),ALLTRIM(TRANS(EC4->EC4_VL_CAM,'@E 999,999,999,999.99')),"4") //"VL "###" Cod "
         ELSE
            IF PDescCpo <> "HDIFOB_DI"
*              IF EMPTY(EC4->EC4_VL_CAM) .AND. ! EMPTY(PCampo)   && LAB 03.08.99
               IF ! EMPTY(PCampo)
                  CR200_Crit("2",STR0001+PDescricao+STR0002+EC6->EC6_ID_CAM,ALLTRIM(TRANS(PCampo,'@E 999,999,999,999.99')),ALLTRIM(TRANS(EC4->EC4_VL_CAM,'@E 999,999,999,999.99')),"2") //"VL "###" Cod "
                  CR200LOCK("EC4",.F.)
                  EC4->EC4_VL_CAM := PCampo
                  EC4->(MSUNLOCK())
*              ELSE
*                 CR200_Crit("2",STR0001+PDescricao+STR0002+EC6->EC6_ID_CAM,ALLTRIM(TRANS(PCampo,'@E 999,999,999,999.99')),ALLTRIM(TRANS(EC4->EC4_VL_CAM,'@E 999,999,999,999.99')),"3") //"VL "###" Cod "
               ENDIF
            ELSE
               CR200_Crit("2",STR0001+PDescricao+STR0002+EC6->EC6_ID_CAM,ALLTRIM(TRANS(PCampo,'@E 999,999,999,999.99')),ALLTRIM(TRANS(EC4->EC4_VL_CAM,'@E 999,999,999,999.99')),"2") //"VL "###" Cod "
               CR200LOCK("EC4",.F.)
               EC4->EC4_VL_CAM := PCampo
               EC4->(MSUNLOCK())
               MTroca_FOB := .T.
            ENDIF
         ENDIF
      ENDIF

      EC4->(DBSKIP())
   ENDDO
   EC6->(DBSKIP())
ENDDO

SELECT(OldSel)

RETURN .T.

*-----------------*
// Substituido pelo assistente de conversao do AP5 IDE em 01/12/99 ==> FUNCTION CR200_Cod
Static FUNCTION CR200_Cod()
*-----------------*

OldSel := SELECT()
SYSREFRESH()
EC6->(DBSEEK(xFilial("EC6")+"IMPORT"+PDescCpo+SPACE(10-LEN(PDescCpo))+DI_Ctb->DIIDENTCT))

IF EC6->(EOF())
   MTexto := ALLTRIM(PDescCpo)+STR0003 //" N.CAD.LINK"
   CR200_Crit("2",MTexto,ALLTRIM(TRANS(PCampo,'@E 999,999,999,999.99')),SPACE(20),"1")
   SELECT(OldSel)
   RETURN .T.
ENDIF

IF  "AGFA" $ SM0->M0_NOME
    IF  LEFT(EC6->EC6_ID_CAM,1) == "4" .AND. EC6->EC6_ID_CAM #"401"  // transf. para estoque divisa ou transito ?
        IV_Ctb->(DBSETORDER(2))
        IV_Ctb->(DBSEEK(DI_Ctb->DIHAWB+DI_Ctb->DIFORN+DI_Ctb->DIMOEDA+DI_Ctb->DIIDENTCT))

        EC9->(DBSETORDER(2))
        EC9->(DBSEEK(xFilial("EC9")+IV_Ctb->IVFORN+IV_Ctb->IVINVOICE+IV_Ctb->IVIDENTCT+"6"))
*       IF  EOF()  && LAB 05.10.98
*           SELE APD_Ctb
*           SEEK IV_Ctb->(IVINVOICE + IVIDENTCT)     && pesquisa pagto no APD (no mes)
*       ENDIF
        IF  ! EC9->(EOF()) .AND. VAL(EC9->EC9_NR_CON) #0 .AND. VAL(EC9->EC9_NR_CON) # 9999
            EC6->(DBSEEK(cFilEC6+"IMPORT"+PDescCpo+SPACE(10-LEN(PDescCpo))+DI_Ctb->DIIDENTCT+ALLTRIM(STR(VAL(DI_Ctb->DICC_ESTOQ),15,0))+SPACE(15-LEN(ALLTRIM(STR(VAL(DI_Ctb->DICC_ESTOQ),15,0))))+"43"))  // pesquisa divisas
        ELSE
            EC6->(DBSEEK(cFilEC6+"IMPORT"+PDescCpo+SPACE(10-LEN(PDescCpo))+DI_Ctb->DIIDENTCT+ALLTRIM(STR(VAL(DI_Ctb->DICC_ESTOQ),15,0))+SPACE(15-LEN(ALLTRIM(STR(VAL(DI_Ctb->DICC_ESTOQ),15,0))))+"44"))  // pesquisa transito
        ENDIF
    ELSE
        EC6->(DBSEEK(cFilEC6+"IMPORT"+PDescCpo+SPACE(10-LEN(PDescCpo))+DI_Ctb->DIIDENTCT+ALLTRIM(STR(VAL(DI_Ctb->DICC_ESTOQ),15,0))))  // pesquisa para II e Despach.
    ENDIF

    IF EC6->(EOF())
       EC6->(DBSEEK(cFilEC6+"IMPORT"+PDescCpo+SPACE(10-LEN(PDescCpo))+DI_Ctb->DIIDENTCT))
    ENDIF
ENDIF

CR200LOCK("EC4",.T.)
EC4->EC4_FILIAL := cFilEC4
EC4->EC4_HAWB   := DI_Ctb->DIHAWB
EC4->EC4_IDENTC := DI_Ctb->DIIDENTCT
EC4->EC4_ID_CAM := EC6->EC6_ID_CAM
EC4->EC4_NR_CON := '0000'
EC4->EC4_DT_PGT := PData
EC4->EC4_VL_CAM := PCampo
EC4->EC4_SIS_OR := "1"
EC4->EC4_FORN   := DI_Ctb->DIFORN
EC4->EC4_MOEDA  := DI_Ctb->DIMOEDA
DO  CASE
    CASE EC6->EC6_ID_CAM == "620"
         EC4->EC4_COM_HI := DI_Ctb->DICC_620
    CASE EC6->EC6_ID_CAM == "621"
         EC4->EC4_COM_HI := DI_Ctb->DICC_621
    CASE EC6->EC6_ID_CAM == "623"
         EC4->EC4_COM_HI := DI_Ctb->DICC_623
    CASE EC6->EC6_ID_CAM == "699"
         EC4->EC4_COM_HI := DI_Ctb->DICC_699
ENDCASE

EC4->(MSUNLOCK())

SELECT(OldSel)

RETURN .T.

*----------------------------*
// Substituido pelo assistente de conversao do AP5 IDE em 01/12/99 ==> FUNCTION CR200Inv_For
User FUNCTION CR200Inv_For(cInvoice,cForn)
*----------------------------*
SYSREFRESH()
OldSele := SELECT()
EC5->(DBSEEK(cFilEC5+cForn+cInvoice))
MTexto := SPACE(20)
IF ! EC5->(EOF())
   MTexto := ALLTRIM(BuscaF_Fornec(EC5->EC5_FORN))
ENDIF

SELECT(OldSele)
RETURN MTexto


*-------------------*
// Substituido pelo assistente de conversao do AP5 IDE em 01/12/99 ==> FUNCTION CR200_Crit
Static FUNCTION CR200_Crit()
*-------------------*
OldSel := SELECT()
SYSREFRESH()
CR200LOCK("EC0",.T.)
EC0->EC0_FILIAL := XfILIAL("EC0")
EC0->EC0_DT_INT := dDataBase
EC0->EC0_TIPO_I := PTipo_Int
EC0->EC0_HAWB_I := IF(PTipo_Int=="1",IV_Ctb->IVINVOICE,DI_Ctb->DIHAWB)
EC0->EC0_IDENTC := IF(PTipo_Int=="1",IV_Ctb->IVIDENTCT,DI_Ctb->DIIDENTCT)
EC0->EC0_DES_CA := PDesc
EC0->EC0_CON_EN := PEnvio
EC0->EC0_CON_EX := PExiste
EC0->EC0_STATUS := PStatus

EC0->(MSUNLOCK())

SELECT(OldSel)

RETURN .T.


*-----------------*
// Substituido pelo assistente de conversao do AP5 IDE em 01/12/99 ==> FUNCTION CR200Abre
Static FUNCTION CR200Abre()
*-----------------*
lRetLocal:=.T.
SYSREFRESH()
Do While .T.

   If ! FILE(cPath+("IV100.DBF"))
      AvE_Msg(STR0004,1) //"Arquivo IV100 näo encontrado."
      lRetLocal:=.F.
      EXIT
   EndIf
   If ! FILE(cPath+("DI100.DBF"))
      AvE_Msg(STR0005,1) //"Arquivo DI100 näo encontrado."
      lRetLocal:=.F.
      EXIT
   EndIf
   If ! FILE(cPath+("IVH100.DBF"))
      AvE_Msg(STR0006,1) //"Arquivo IVH100 näo encontrado."
      lRetLocal:=.F.
      EXIT
   EndIf
   If ! FILE(cPath+("APD100.DBF"))
      AvE_Msg(STR0007,1) //"Arquivo APD100 näo encontrado."
      lRetLocal:=.F.
      EXIT
   EndIf
   If lExisteECF
      If ! FILE(cPath+("ANT100.DBF"))
         AvE_Msg(STR0008,1) //"Arquivo ANT100 näo encontrado."
         lRetLocal:=.F.
         EXIT
      EndIf
   Endif

   FErase(cPath+("IV100"+OrdBagExt()))
   FErase(cPath+("IV101"+OrdBagExt()))
   DBUSEAREA(.T.,,(cPath+("IV100")),"IV_Ctb",.F.)
   IF NETERR()
      AvE_Msg(STR0009,1) //"Arquivo IV100 näo disponivel ..."
      lRetLocal:=.F.
      EXIT
   ENDIF

   IndRegua("IV_Ctb",cPath+("IV100"+OrdBagExt()),"IVINVOICE+IVIDENTCT",;
   "AllwaysTrue()",;
   "AllwaysTrue()",;
   STR0010) //"Indexando Arquivo Temporario IV100 1..."

   IndRegua("IV_Ctb",cPath+("IV101"+OrdBagExt()),"IVHAWB+IVFORN+IVMOE_FOB+IVIDENTCT",;
   "AllwaysTrue()",;
   "AllwaysTrue()",;
   STR0011) //"Indexando Arquivo Temporario IV100 2..."

   SET INDEX TO (cPath+("IV100"+OrdBagExt())),(cPath+("IV101"+OrdBagExt()))

   FErase(cPath+("DI100"+OrdBagExt()))
   DBUSEAREA(.T.,,(cPath+("DI100")),"DI_Ctb",.F.)
   IF NETERR()
      AvE_Msg(STR0012,1) //"Arquivo DI100 näo disponivel ..."
      IV_Ctb->(dbcloseAREA())
      lRetLocal:=.F.
      EXIT
   ENDIF
   IndRegua("Di_Ctb",cPath+("DI100"+OrdBagExt()),"DIHAWB+DIIDENTCT",;
   "AllwaysTrue()",;
   "AllwaysTrue()",;
   STR0013) //"Indexando Arquivo Temporario DI100 1..."

   FErase(cPath+("IVH100"+OrdBagExt()))
   FErase(cPath+("IVH101"+OrdBagExt()))
   DBUSEAREA(.T.,,(cPath+("IVH100")),"IVH_Ctb",.F.)
   IF NETERR()
      AvE_Msg(STR0014,1) //"Arquivo IVH100 näo disponivel ..."
      IV_Ctb->(dbcloseAREA())
      DI_Ctb->(dbcloseAREA())
      lRetLocal:=.F.
      EXIT
   ENDIF

   IndRegua("IVH_Ctb",cPath+("IVH100"+OrdBagExt()),"IVHHAWB+IVHIDENTCT+IVHPO_NUM+IVHINVOICE",;
   "AllwaysTrue()",;
   "AllwaysTrue()",;
   STR0015) //"Indexando Arquivo Temporario IVH100 1..."

   IndRegua("IVH_Ctb",cPath+("IVH101"+OrdBagExt()),"IVHINVOICE+IVHIDENTCT",;
   "AllwaysTrue()",;
   "AllwaysTrue()",;
   STR0016) //"Indexando Arquivo Temporario IVH100 2..."
   SET INDEX TO (cPath+("IVH100"+OrdBagExt())),(cPath+("IVH101"+OrdBagExt()))

   FErase(cPath+("APD100"+OrdBagExt()))
   DBUSEAREA(.T.,,(cPath+("APD100")),"APD_Ctb",.F.)
   IF NETERR()
      AvE_Msg(STR0017,1) //"Arquivo APD100 näo disponivel ..."
      IV_Ctb->(dbcloseAREA())
      DI_Ctb->(dbcloseAREA())
      IVH_Ctb->(dbcloseAREA())
      lRetLocal:=.F.
      EXIT
   ENDIF

   IndRegua("APD_Ctb",cPath+("APD_Ctb"+OrdBagExt()),"APDINVOICE+APDIDENTCT",;
   "AllwaysTrue()",;
   "AllwaysTrue()",;
   STR0018) //"Indexando Arquivo Temporario APD100 1..."

   If lExisteECF
      FErase(cPath+("ANT100"+OrdBagExt()))
      DBUSEAREA(.T.,,(cPath+("ANT100")),"ANT_Ctb",.F.)
      IF NETERR()
         AvE_Msg(STR0019,1) //"Arquivo ANT100 näo disponivel ..."
         IV_Ctb->(dbcloseAREA())
         DI_Ctb->(dbcloseAREA())
         IVH_Ctb->(dbcloseAREA())
         APD_Ctb->(dbcloseAREA())         
         lRetLocal:=.F.
         EXIT
      ENDIF                                                                                             
      IndRegua("ANT_Ctb",cPath+("ANT_Ctb"+OrdBagExt()),"ANTFORN+ANTINVOICE+ANTIDENTCT",; 
      "AllwaysTrue()",;
      "AllwaysTrue()",;
      STR0020) //"Indexando Arquivo Temporario ANT100 1..."

   Endif
   
   EXIT
Enddo

Return lRetLocal


*-------------------*
// Substituido pelo assistente de conversao do AP5 IDE em 01/12/99 ==> FUNCTION CR200_VerDt
Static FUNCTION CR200_VerDt()
*-------------------*

OldSel := SELECT()

EC6->(DBSEEK(XFILIAL()+"IMPORT"+PDesc+SPACE(10-LEN(PDesc))+DI_Ctb->DIIDENTCT))

DO WHILE ! EC6->(EOF()) .AND. ALLTRIM(PDesc) == ALLTRIM(EC6->EC6_NO_CAM) .AND. Di_Ctb->DIIDENTCT==EC6->EC6_IDENTC .AND. EC6->EC6_FILIAL==xFilial("EC6") .AND. ;
   EC6->EC6_TPMODU == "IMPORT"

   EC4->(DBSEEK(xFilial("EC4")+DI_Ctb->DIHAWB+DI_Ctb->DIFORN+DI_Ctb->DIMOEDA+DI_Ctb->DIIDENTCT+EC6->EC6_ID_CAM))
   
   SYSREFRESH()

   DO WHILE ! EC4->(EOF()) .AND. (DI_Ctb->DIHAWB+DI_Ctb->DIFORN+DI_Ctb->DIMOEDA+DI_Ctb->DIIDENTCT)==(EC4->EC4_HAWB+EC4->EC4_FORN+EC4->EC4_MOEDA+EC4->EC4_IDENTC) .AND. EC6->EC6_ID_CAM==EC4->EC4_ID_CAM;
              .AND. EC4->EC4_FILIAL==xFilial("EC4")
      
      SYSREFRESH()

      IF PData <> EC4->EC4_DT_PGT
         IF VAL(EC4->EC4_NR_CON) <> 0
            CR200_Crit("2",STR0021+PDescricao+STR0002+EC6->EC6_ID_CAM,DTOC(PData),DTOC(EC4->EC4_DT_PGT),"4") //"DT "###" Cod "
            MTrocaDt := .F.
         ELSE
            IF EMPTY(EC4->EC4_DT_PGT) .AND. ! EMPTY(PData)
               CR200_Crit("2",STR0021+PDescricao+STR0002+EC6->EC6_ID_CAM,DTOC(PData),DTOC(EC4->EC4_DT_PGT),"2") //"DT "###" Cod "
               CR200LOCK("EC4",.F.)
               EC4->EC4_DT_PGT := PData
               EC4->(MSUNLOCK())
            ELSE
               CR200_Crit("2",STR0021+PDescricao+STR0002+EC6->EC6_ID_CAM,DTOC(PData),DTOC(EC4->EC4_DT_PGT),"3") //"DT "###" Cod "
            ENDIF
         ENDIF
      ENDIF

      EC4->(DBSKIP())
   ENDDO
   EC6->(DBSKIP())
ENDDO

SELECT(OldSel)

RETURN .T.

*-----------------*
// Substituido pelo assistente de conversao do AP5 IDE em 01/12/99 ==> Function CR200LOCK
Static Function CR200LOCK()
*-----------------*
SYSREFRESH()
cAliasLock := Alias()
lRetLock:=.T.
lRetLock:=Reclock(cTravaAlias,lTrava)
DbSelectArea( cAliasLock )
Return lRetLock



#INCLUDE "EECAF155.ch"

/*
Programa..: EECAF155.PRW
Objetivo..: Impressao do Relatorio de Custo Realizado
Autor.....: Luciano Campos de Santana
Data/Hora.: 27/12/2001
Obs.......: REL18.RPT
*/
#include "EEC.CH"
#DEFINE DEFPRIPAG 44 //46
#DEFINE SEGPAG 58         
*--------------------------------------------------------------------
USER FUNCTION EECAF155
LOCAL cARQRPT,cTIPRPT,oDLG,nOPC,cNOMDBFC,aCAMPOSC,aNOMDBFD,aCAMPOSD,aARQS,;
      aRETCRW,cEXP_FOR,cVIA_TRAN,aDESP,nA,nB,cA,lFOB,lFRE,lSEG,aTOTREAIS,;
      aTOTMOEDA,nTAXA,nVALFOB,nVALFRE,nVALSEG,aPROCESSO,nC,nFATORVAL,;
      nFATORPES,nPESOLIQ,nD,nVALUNIT,aDESPA,nVALTOTMOE,nVALUNIMOE,;
      aORDANT  := SAVEORD({"EE5","EE6","EE7","EE9","EEA","EEB","EEC","SA2","SB1",;
                           "SYB","SYQ","SYR","EET","SAH"}),;
      bOK      := {|| nOPC := 1,oDLG:END()},;
      bCancel  := {|| nOPC := 0,oDLG:END()},;
      cPICTPRE := AVSX3("EEC_TOTPED",AV_PICTURE),;
      cPICTPES := AVSX3("EE9_SLDINI",AV_PICTURE),;
      cPICTNCM := AVSX3("EE9_POSIPI",AV_PICTURE),;
      cPICTPRU := EECPreco("EE9_PRECOI", AV_PICTURE),;
      cRATEIO  := GetNewPar("MV_AVG0021","3")
     //cPICTPRU := AVSX3("EE9_PRECOI",AV_PICTURE),;

Local nPos:=0, nPosComis:=0, aAgentes:={}, aComissao:={}, j:=0
Local lGravaAgente:=.t.

PRIVATE cPREEMB,nDIA_EMB,nLIN,nPAG
Private PRIPAG := DEFPRIPAG
Private lFobDescontado := GetMv("MV_AVG0086",,.f.)

BEGIN SEQUENCE
   IF SELECT("WORKID") > 0
      cARQRPT := WORKID->EEA_ARQUIV
      cTITRPT := ALLTRIM(WorkId->EEA_TITULO)
   ELSE
      cARQRPT := POSICIONE("EEA",1,xFILIAL("EEA")+AVKEY("AF155","EEA_COD"),"EEA_ARQUIV")
      cTITRPT := EEA->EEA_TITULO
   ENDIF
   cPREEMB  := SPACE(AVSX3("EEC_PREEMB",AV_TAMANHO))
   nDIA_EMB := 1
   DEFINE MSDIALOG oDLG TITLE cTITRPT FROM 0,0 TO 155,380 OF oMainWnd PIXEL //FSM - 18/07/2011
      @ 20,03 SAY STR0001            PIXEL //"Embarque"
      @ 20,33 MSGET cPREEMB  SIZE 70,08 PIXEL F3("EEC") VALID(AF155(1))
      *
      @ 35,03 SAY STR0002        PIXEL //"Usar a cotacao da data do:"
      @ 45,13 RADIO nDIA_EMB ITEMS STR0003,STR0004 PIXEL SIZE 35,10 OF oDLG //"&Dia"###"&Embarque"
   ACTIVATE MSDIALOG oDLG ON INIT ENCHOICEBAR(oDLG,bOK,bCANCEL) CENTERED
   IF nOPC # 1
      BREAK
   ENDIF
   aDESPA   := {0,0,0}  
   nTAXA    := BUSCATAXA(EEC->EEC_MOEDA,IF(nDIA_EMB=1,dDATABASE,EEC->EEC_DTEMBA))
   nVALFOB  := EEC->((EEC_TOTPED+EEC_DESCON)-(EEC_FRPREV+EEC_FRPCOM+EEC_SEGPRE+EEC_DESPIN+AvGetCpo("EEC->EEC_DESP1")+AvGetCpo("EEC->EEC_DESP2")))
   nVALFRE  := EEC->EEC_FRPREV
   nVALSEG  := EEC->EEC_SEGPRE
   ///nPESOLIQ := EEC->EEC_PESLIQ
   IF cRATEIO = "1"  // PESO LIQUIDO
      nPESOLIQ := EEC->EEC_PESLIQ
   ELSEIF cRATEIO = "2"  // PESO BRUTO
          nPESOLIQ := EEC->EEC_PESBRU
   ELSE  // PRECO FOB
      nPESOLIQ := EEC->((EEC_TOTPED+EEC_DESCON)-(EEC_FRPREV+EEC_FRPCOM+EEC_SEGPRE+EEC_DESPIN+AvGetCpo("EEC->EEC_DESP1")+AvGetCpo("EEC->EEC_DESP2")))
   ENDIF
   cNOMDBFC := "WORK18C"
   aCAMPOSC := {{"SEQREL"    ,"C",08,0},{"COURI_NAIV","C",07,0},;
                {"MOEDA"     ,"C",03,0},{"PROCESSO"  ,"C",20,0},;
                {"EXPORTADOR","C",40,0},{"DATA_EMBAR","C",11,0},;
                {"IMPORTADOR","C",40,0},{"VIA_TRANSP","C",40,0},;
                {"AGENTE"    ,"C",40,0},{"EMBALAGEM" ,"C",40,0},;
                {"NOME_CO_NA","C",40,0},{"NUM_RE"    ,"C",12,0},;
                {"TOTAL_EMBA","C",20,0},{"FRETE_EMBA","C",20,0},;
                {"SEGURO_EMB","C",20,0},{"COND_PAGTO","C",40,0},;
                {"ADIAN_DESP","C",20,0},{"COMPL_DESP","C",20,0},;
                {"DEVOL_DESP","C",20,0},{"VALTR_DESP","C",20,0},;
                {"TAXA"      ,"C",20,0},{"DT_TAXA"   ,"C",10,0},;
                {"ABERT_FECH","C",07,0}}
   cNOMDBFD := "WORK18D"
   aCAMPOSD := {{"SEQREL"    ,"C",08,0},{"PAGINA"    ,"C",03,0},;
                {"FLAG"      ,"C",01,0},{"DESPESAS"  ,"C",50,0},;
                {"VALORREAIS","C",20,0},{"VALORMOEDA","C",20,0},;
                {"VALORFOB"  ,"C",20,0},{"SUBTITULO" ,"C",18,0},;
                {"PRODUTO"   ,"C",50,0},{"FABRICANTE","C",50,0},;
                {"QUANTIDADE","C",20,0},{"NCM"       ,"C",10,0},;
                {"PESLIQUNIT","C",15,0},{"PESLIQTOTA","C",15,0},;
                {"VALUNITREA","C",20,0},{"VALUNITMOE","C",20,0},;
                {"SUBREL    ","C",03,0},;
                {"DESCAGEN"  ,"C",40,0},;
                {"TIPOCOM"   ,"C",40,0},;
                {"VALCOM"    ,"C",20,0}}

   aARQS    := {{cNOMDBFC,aCAMPOSC,"CAB","SEQREL"},;
                {cNOMDBFD,aCAMPOSD,"DET","SEQREL"}}
   aRETCRW  := CRWNEWFILE(aARQS) 
   cSEQREL  := GetSXENum("SY0","Y0_SEQREL")
   CONFIRMSX8()
   CAB->(DBAPPEND())
   CAB->SEQREL := cSEQREL
   // CABECARIO DO NOME DO ..... (COURIER OU NAVIO)
   SYQ->(DBSETORDER(1))
   SYQ->(DBSEEK(XFILIAL("SYQ")+EEC->EEC_VIA))
   CAB->COURI_NAIV := IF(LEFT(SYQ->YQ_COD_DI,1)="1",STR0005,STR0006) //"Navio"###"Courier"
   // MOEDA
   CAB->MOEDA := EEC->EEC_MOEDA
   // PROCESSO DE EMBARQUE
   CAB->PROCESSO := EEC->EEC_PREEMB
   // EXPORTADOR
   SA2->(DBSETORDER(1))
   IF ! EMPTY(EEC->EEC_EXPORT)
      SA2->(DBSEEK(xFILIAL("SA2")+EEC->(EEC_EXPORT+EEC_EXLOJA)))
   ELSE
      SA2->(DBSEEK(xFILIAL("SA2")+EEC->(EEC_FORN+EEC_FOLOJA)))
   ENDIF
   CAB->EXPORTADOR := SA2->A2_NOME
   // DATA DE EMBARQUE
   CAB->DATA_EMBAR := EEC->(STR(DAY(EEC_DTEMBA),2,0)+" "+LEFT(MESEXTENSO(MONTH(EEC_DTEMBA)),3)+" "+STR(YEAR(EEC_DTEMBA),4,0))
   // IMPORTADOR
   CAB->IMPORTADOR := EEC->EEC_IMPODE
   // VIA DE TRANSPORTE
   SYQ->(DBSETORDER(1))
   SYQ->(DBSEEK(XFILIAL("SYQ")+EEC->EEC_VIA))
   cTIPTRA := LEFT(SYQ->YQ_COD_DI,1)
   cVIA    := ALLTRIM(SYQ->YQ_DESCR)
   SY9->(DBSETORDER(2))
   SY9->(DBSEEK(XFILIAL("SY9")+EEC->EEC_ORIGEM))
   cVIA := cVIA+STR0007+ALLTRIM(SY9->Y9_DESCR) //" de "
   SY9->(DBSEEK(XFILIAL("SY9")+EEC->EEC_DEST))
   cVIA := cVIA+STR0008+ALLTRIM(SY9->Y9_DESCR) //" para "
   CAB->VIA_TRANSP := cVIA
   // AGENTE EMBARCADOR
   BUSCAEMPRESA(EEC->EEC_PREEMB,OC_EM,CD_AGE)
   CAB->AGENTE := EEB->(EEB_CODAGE+" "+EEB_NOME)
   // TIPO DE EMBALAGEM
   EE5->(DBSETORDER(1))
   EE5->(DBSEEK(XFILIAL("EE5")+EEC->EEC_EMBAFI))
   CAB->EMBALAGEM := EE5->EE5_DESC
   // DADOS DO NOME DO ..... (COURIER OU NAVIO)
   SYR->(DBSETORDER(1))
   SYR->(DBSEEK(XFILIAL("SYR")+EEC->(EEC_VIA+EEC_ORIGEM+EEC_DEST)+cTIPTRA))
   IF SYR->YR_TIPTRAN = "1"  // MARITIMO
      EE6->(DBSETORDER(1))
      EE6->(DBSEEK(XFILIAL("EE6")+EEC->EEC_EMBARC))
      CAB->NOME_CO_NA := EE6->EE6_NOME
   ELSEIF SYR->YR_TIPTRAN = "7"  // RODOVIARIO
          CAB->NOME_CO_NA := BUSCAEMPRESA(EEC->EEC_PREEMB,OC_EM,CD_TRA)
   ELSEIF SYR->YR_TIPTRAN = "5"  // POSTAGEM - COURIER
          CAB->NOME_CO_NA := BUSCAEMPRESA(EEC->EEC_PREEMB,OC_EM,CD_COU)
   ELSE  // DEMAIS CODIGOS
      CAB->NOME_CO_NA := BUSCAEMPRESA(EEC->EEC_PREEMB,OC_EM,CD_AGE)
   ENDIF
   CAB->NUM_RE := BUSCARE(EEC->EEC_PREEMB)
   // TOTAL DO EMBARQUE
   CAB->TOTAL_EMBA := "("+EEC->EEC_MOEDA+") "+TRANSFORM(EEC->EEC_TOTPED,cPICTPRE)
   // VALOR DO FRETE
   CAB->FRETE_EMBA := "("+EEC->EEC_MOEDA+") "+TRANSFORM(EEC->EEC_FRPREV,cPICTPRE)
   // VALOR DO SEGURO
   CAB->SEGURO_EMB := "("+EEC->EEC_MOEDA+") "+TRANSFORM(EEC->EEC_SEGPRE,cPICTPRE)
   // TAXA DA MOEDA
   CAB->TAXA := "("+EEC->EEC_MOEDA+") "+TRANSFORM(nTAXA,"@E 999.99999999")
   // CONDICAO DE PAGAMENTO
   CAB->COND_PAGTO := SY6DESCRICAO(EEC->EEC_CONDPA+Str(EEC->EEC_DIASPA,AVSX3("EEC_DIASPA",AV_TAMANHO),AVSX3("EEC_DIASPA",AV_DECIMAL)),"PORT. -PORTUGUES",1)
   // DATA DA TAXA DA MOEDA
   CAB->DT_TAXA := DTOC(SYE->YE_DATA)
   // PRECO ABERTO OU FECHADO
   CAB->ABERT_FECH := EEC->(IF(EEC_PRECOA="1",STR0009,STR0010)) //"Aberto"###"Fechado"

   /* By JBJ - 18/05/04 - Tratamentos para impressão do(s) agente(s) recebedor(es) de comissão
                          cadastrados no processo.
                          Obs: Para a rotina nova de comissão, considera as informações do EEB.
                               Para a rotina antiga de comissão, considera as informações da
                               capa do processo. */
   EEB->(DbSetOrder(1))
   If EEB->(DbSeek(xFilial("EEB")+EEC->EEC_PREEMB+OC_EM))
      Do While EEB->(!Eof()) .And. EEB->EEB_FILIAL == xFilial("EEB") .And.;
                                   EEB->EEB_PEDIDO == EEC->EEC_PREEMB .And.;
                                   EEB->EEB_OCORRE == OC_EM      

         //  Soh considera os agentes recebedores de comissao.
         If SubStr(EEB->EEB_TIPOAGE,1,1) <> CD_AGC
            EEB->(DbSkip())
            Loop
         EndIf

         nPos := aScan(aAgentes,{|x| x[1] = AllTrim(EEB->EEB_NOME)})

         If EECFlags("COMISSAO")
            If nPos == 0
               aAdd(aAgentes,{AllTrim(EEB->EEB_NOME),EEB->EEB_TIPCOM,EEB->EEB_TOTCOM})
            Else
               If Agentes[nPos][2] == EEB->EEB_TIPCOM
                  aAgentes[nPos][3] += EEB->EEB_TOTCOM
               Else
                  aAdd(aAgentes,{AllTrim(EEB->EEB_NOME),EEB->EEB_TIPCOM,EEB->EEB_TOTCOM})
               EndIf
            EndIf
         Else
            If lGravaAgente
               nFob := (EEC->EEC_TOTPED+EEC->EEC_DESCON)-(EEC->EEC_FRPREV+EEC->EEC_FRPCOM+;
                                                          EEC->EEC_SEGPRE+EEC->EEC_DESPIN+;
                                                          AvGetCpo("EEC->EEC_DESP1")+;
                                                          AvGetCpo("EEC->EEC_DESP2"))
               Do Case
                  Case EEC->EEC_TIPCVL = "1" // Percentual.
                     nValCom := Round((EEB->EEB_TXCOMI/100)*nFob,3)

                  Case EEC->EEC_TIPCVL = "2" // Valor Fixo.
                     nValCom := EEB->EEB_TXCOMI

                  Case EEC->EEC_TIPCVL = "3" // Percentual Por item.
                     nValCom := Round((EEC->EEC_VALCOM/100)*nFob,3)
                     lGravaAgente :=.f.
               Endcase

               If nPos = 0
                  aAdd(aAgentes,{AllTrim(EEB->EEB_NOME),EEC->EEC_TIPCOM,nValCom})
               Else
                  aAgentes[nPos][3] += nValCom
               EndIf
            EndIf
         EndIf
         EEB->(DbSkip())
      EndDo

      If Len(aAgentes) > 0
         For j:=1 To Len(aAgentes)
            DET->(DBAPPEND())
            DET->SEQREL := cSEQREL
            DET->PAGINA := "001"
            DET->FLAG   := "X"
            DET->SUBREL := "AGE" // Link com o sub-relatório de agentes.

            DET->DESCAGEN := AllTrim(aAgentes[j][1])

            Do Case
               Case aAgentes[j][2] == "1"
                  DET->TIPOCOM  := STR0022 //"120-A Remeter"
               Case aAgentes[j][2] == "2"
                  DET->TIPOCOM  := STR0023 //"121-Conta Gráfica"
               Case aAgentes[j][2] == "3"
                  DET->TIPOCOM  := STR0024 //"122-A Deduzir da Fatura"
            EndCase

            DET->VALCOM := AllTrim(Transf(aAgentes[j][3],AvSx3("EEC_TOTPED",AV_PICTURE)))

            /* Controle para calculo do total de comissão por tipo de comissao.
               aComissao por dimensão:
                         aComissao[1][1] -> Tipo da comissão.
                                  [1][2] -> Total da comissao para o tipo. */

            nPosComis := aScan(aComissao,{|x| x[1] == aAgentes[j][2]})
            If nPosComis = 0
               aAdd(aComissao,{aAgentes[j][2],aAgentes[j][3]})
            Else
               aComissao[nPosComis][2] += aAgentes[j][3]
            EndIf
         Next
      EndIf

      // ** Atualiza o total de linhas disponíveis.
      PRIPAG := PRIPAG - Len(aAgentes)
   EndIf

   // BUSCA AS DESPESAS DO EMBARQUE NO EET
   lFRE  := lSEG := .F.
   aDESP := {{},;   // DESPESAS 1
             {}}    // DEMAIS DESPESAS
   // ESTRUTURA DENTRO DO aDESP
   // 1.DESPESA - 2.VL.EM R$ - 3.VL.EM US$
   // LCS - 17/09/2002
   EET->(DBSETORDER(1))
   EET->(DBSEEK(XFILIAL("EET")+AVKEY(EEC->EEC_PREEMB,"EET_PEDIDO")+OC_EM))
   DO WHILE ! EET->(EOF()) .AND.;
      EET->(EET_FILIAL+EET_PEDIDO+EET_OCORRE) = (XFILIAL("EET")+AVKEY(EEC->EEC_PREEMB,"EET_PEDIDO")+OC_EM)
      *
      IF LEFT(EET->EET_DESPES,1) = "1"
         IF EET->EET_DESPES = "101" // FOB
            nVALFOB := EET->EET_VALORR/nTAXA
            lFOB    := .T.
         ELSEIF EET->EET_DESPES = "102" // FRETE
                nVALFRE := EET->EET_VALORR/nTAXA
                lFRE    := .T.
         ELSEIF EET->EET_DESPES = "103" // SEGURO
                nVALSEG := EET->EET_VALORR/nTAXA
                lSEG    := .T.
         ENDIF
         EET->(AADD(aDESP[1],{EET_DESPES,EET_VALORR,EET_VALORR/nTAXA}))
      ELSEIF EET->EET_DESPES = "901" // ADIANTAMENTO AO DESPACHANTE
             aDESPA[1] := aDESPA[1]+EET->EET_VALORR
      ELSEIF EET->EET_DESPES = "902" // COMPLEMENTOS AO DESPACHANTE
             aDESPA[2] := aDESPA[2]+EET->EET_VALORR
      ELSEIF EET->EET_DESPES = "903" // DEVOLUCOES AO DESPACHANTE
             aDESPA[3] := aDESPA[3]+EET->EET_VALORR
      ELSE
         EET->(AADD(aDESP[2],{EET_DESPES,EET_VALORR,EET_VALORR/nTAXA}))
      ENDIF
      EET->(DBSKIP())
   ENDDO

   For j:=1 To Len(aComissao)
      aAdd(aDesp[1],{aComissao[j][1],aComissao[j][2]*nTaxa,aComissao[j][2]})
   Next

   /// LCS - 17/09/2002 - SUBSTITUIDO PELAS LINHAS ACIMA
   ///SWD->(DBSETORDER(5))
   ///SWD->(DBSEEK(XFILIAL("SWD")+AVKEY(EEC->EEC_PREEMB,"WD_HAWB")+OC_EM))
   ///DO WHILE ! SWD->(EOF()) .AND.;
   ///   SWD->(WD_FILIAL+WD_HAWB+WD_OCORREN) = (XFILIAL("SWD")+AVKEY(EEC->EEC_PREEMB,"WD_HAWB")+OC_EM)
   ///   *
   ///   IF LEFT(SWD->WD_DESPESA,1) = "1"
   ///      IF SWD->WD_DESPESA = "101" // FOB
   ///         nVALFOB := SWD->WD_VALOR_R/nTAXA
   ///         lFOB    := .T.
   ///      ELSEIF SWD->WD_DESPESA = "102" // FRETE
   ///             nVALFRE := SWD->WD_VALOR_R/nTAXA
   ///             lFRE    := .T.
   ///      ELSEIF SWD->WD_DESPESA = "103" // SEGURO
   ///             nVALSEG := SWD->WD_VALOR_R/nTAXA
   ///             lSEG    := .T.
   ///      ENDIF
   ///      SWD->(AADD(aDESP[1],{WD_DESPESA,WD_VALOR_R,WD_VALOR_R/nTAXA}))
   ///   ELSEIF SWD->WD_DESPESA = "901" // ADIANTAMENTO AO DESPACHANTE
   ///          aDESPA[1] := aDESPA[1]+SWD->WD_VALOR_R
   ///   ELSEIF SWD->WD_DESPESA = "902" // COMPLEMENTOS AO DESPACHANTE
   ///          aDESPA[2] := aDESPA[2]+SWD->WD_VALOR_R
   ///   ELSEIF SWD->WD_DESPESA = "903" // DEVOLUCOES AO DESPACHANTE
   ///          aDESPA[3] := aDESPA[3]+SWD->WD_VALOR_R
   ///   ELSE
   ///      SWD->(AADD(aDESP[2],{WD_DESPESA,WD_VALOR_R,WD_VALOR_R/nTAXA}))
   ///   ENDIF
   ///   SWD->(DBSKIP())
   ///ENDDO
   IF ! lFOB  // FOB
      AADD(aDESP[1],{"101",nVALFOB*nTAXA,nVALFOB})
   ENDIF
   IF ! lFRE  // FRETE
      AADD(aDESP[1],{"102",nVALFRE*nTAXA,EEC->EEC_FRPREV})
   ENDIF
   IF ! lSEG  // SEGURO
      AADD(aDESP[1],{"103",nVALSEG*nTAXA,EEC->EEC_SEGPRE})
   ENDIF
   // INICIO DOS DETALHES DO EMBARQUE
   AF155(2,"001","0")
   nLIN      := 1
   nPAG      := 1
   aTOTREAIS := {{0,0},{0,0}}
   aTOTMOEDA := {{0,0},{0,0}}
   FOR nA := 1 TO 2
       aDESP[nA]      := ASORT(aDESP[nA],,,{|X,Y| X[1] < Y[1]})
       aTOTREAIS[1,1] := 0
       aTOTREAIS[1,2] := 0
       aTOTMOEDA[1,1] := 0
       aTOTMOEDA[1,2] := 0
       FOR nB := 1 TO LEN(aDESP[nA])
           SYB->(DBSETORDER(1))
           SYB->(DBSEEK(XFILIAL("SYB")+aDESP[nA,nB,1]))
           IF (nPAG <= 1 .AND. (nLIN > PRIPAG .OR. nLIN+1 > PRIPAG)) .OR.;
              (nPAG > 1  .AND. (nLIN > SEGPAG .OR. nLIN+1 > SEGPAG))
              IF DET->FLAG # "3"
                 AF155(2,STRZERO(nPAG,3,0),"3")
              ENDIF
              nPAG := nPAG+1
              AF155(2,STRZERO(nPAG,3,0),"0")
              nLIN := 1
           ENDIF
           AF155(2,STRZERO(nPAG,3,0),"1")

           Do Case
              Case aDESP[nA,nB,1] == "1"
                   DET->DESPESAS := STR0025 //"120-Comissão (A Remeter)"
              Case aDESP[nA,nB,1] == "2"
                   DET->DESPESAS := STR0026 //"121-Comissão (Conta Gráfica)"
              Case aDESP[nA,nB,1] == "3"
                   DET->DESPESAS := STR0027 //"122-Comissão (A Deduzir da Fatura)"
              OtherWise
                   DET->DESPESAS := aDESP[nA,nB,1]+"-"+SYB->YB_DESCR
           EndCase

           DET->VALORREAIS := TRANSFORM(aDESP[nA,nB,2],cPICTPRE)
           DET->VALORMOEDA := TRANSFORM(aDESP[nA,nB,3],cPICTPRE)
           DET->VALORFOB   := IF(aDESP[nA,nB,1]="101",STR0011,; //"BASE"
                                 TRANSFORM(ROUND((aDESP[nA,nB,3]/nVALFOB)*100,3),"@E 999.999"))
           nLIN            := nLIN+1
           aTOTREAIS[1,1]  := aTOTREAIS[1,1]+aDESP[nA,nB,2]
           aTOTMOEDA[1,2]  := aTOTMOEDA[1,2]+aDESP[nA,nB,3]
       NEXT
       IF nA = 1
          IF (nPAG <= 1 .AND. (nLIN > PRIPAG .OR. nLIN+2 > PRIPAG)) .OR.;
             (nPAG > 1  .AND. (nLIN > SEGPAG .OR. nLIN+2 > SEGPAG))
             AF155(2,STRZERO(nPAG,3,0),"3")
             nPAG := nPAG+1
             AF155(2,STRZERO(nPAG,3,0),"0")
             nLIN := 1
          ENDIF
          AF155(2,STRZERO(nPAG,3,0),"2")
          DET->DESPESAS   := STR0012 //"C.I.F."
          DET->VALORREAIS := TRANSFORM(aTOTREAIS[1,1],cPICTPRE)
          DET->VALORMOEDA := TRANSFORM(aTOTMOEDA[1,2],cPICTPRE)
          DET->VALORFOB   := TRANSFORM(ROUND((aTOTMOEDA[1,2]/nVALFOB)*100,3),"@E 999.999")
          nLIN            := nLIN+1
       ENDIF
       IF DET->FLAG # "3"
          AF155(2,STRZERO(nPAG,3,0),"3")
          nLIN := nLIN+1
       ENDIF
       aTOTREAIS[2,1] := aTOTREAIS[2,1]+aTOTREAIS[1,1]
       aTOTMOEDA[2,2] := aTOTMOEDA[2,2]+aTOTMOEDA[1,2]
   NEXT
   IF (nPAG <= 1 .AND. (nLIN > PRIPAG .OR. nLIN+2 > PRIPAG)) .OR.;
      (nPAG > 1  .AND. (nLIN > SEGPAG .OR. nLIN+2 > SEGPAG))
      nPAG := nPAG+1
      AF155(2,STRZERO(nPAG,3,0),"0")
      nLIN := 1
   ENDIF

   AF155(2,STRZERO(nPAG,3,0),"2")
   DET->DESPESAS   := STR0013 //"TOTAL GERAL"
   DET->VALORREAIS := TRANSFORM(aTOTREAIS[2,1],cPICTPRE)
   DET->VALORMOEDA := TRANSFORM(aTOTMOEDA[2,2],cPICTPRE)
   DET->VALORFOB   := TRANSFORM(ROUND((aTOTMOEDA[2,2]/nVALFOB)*100,3),"@E 999.999")
   AF155(2,STRZERO(nPAG,3,0),"3")
   nLIN := nLIN+2
   // INICIO DA IMPRESSAO DO CABECARIO DOS PROCESSOS DO EMBARQUE
   IF (nPAG <= 1 .AND. (nLIN > PRIPAG .OR. nLIN+5 > PRIPAG)) .OR.;
      (nPAG > 1  .AND. (nLIN > SEGPAG .OR. nLIN+5 > SEGPAG))
      nPAG := nPAG+1
      nLIN := 0
   ENDIF
   AF155(2,STRZERO(nPAG,3,0),"4")
   DET->SUBTITULO := STR0014 //"CUSTO POR PROCESSO"
   AF155(2,STRZERO(nPAG,3,0),"0")
   nLIN := nLIN+5
   // BUSCA OS DADOS DOS PROCESSOS/ITENS DO EMBARQUE
   aPROCESSO := {}
   EE9->(DBSETORDER(3))
   EE9->(DBSEEK(XFILIAL("EE9")+EEC->EEC_PREEMB))
   DO WHILE ! EE9->(EOF()) .AND.;
      EE9->(EE9_FILIAL+EE9_PREEMB) = (XFILIAL("EE9")+EEC->EEC_PREEMB)
      *
      nA := ASCAN(aPROCESSO,{|X| X[1] = EE9->EE9_PEDIDO})
      IF nA = 0
         EE7->(DBSETORDER(1))
         EE7->(DBSEEK(XFILIAL("EE7")+EE9->EE9_PEDIDO))
         AADD(aPROCESSO,{EE9->EE9_PEDIDO,0,0,0,EE7->EE7_DTPROC,{}})
         nA := LEN(aPROCESSO)
      ENDIF
      aPROCESSO[nA,2] := aPROCESSO[nA,2]+EE9->EE9_PRCINC                // VALOR FOB MOEDA EMBARCADO
      ///aPROCESSO[nA,3] := aPROCESSO[nA,3]+EE9->EE9_PSLQTO                // PESO LIQUIDO EMBARCADO
      IF cRATEIO = "1"  // PESO LIQUIDO
         aPROCESSO[nA,3] := aPROCESSO[nA,3]+EE9->EE9_PSLQTO     // PESO LIQUIDO EMBARCADO
      ELSEIF cRATEIO = "2"  // PESO BRUTO
             aPROCESSO[nA,3] := aPROCESSO[nA,3]+EE9->EE9_PSBRTO // PESO BRUTO EMBARCADO
      ELSE  // PRECO FOB
         aPROCESSO[nA,3] := aPROCESSO[nA,3]+EE9->EE9_PRCINC     // PRECO FOB EMBARCADO
      ENDIF
      aPROCESSO[nA,4] := aPROCESSO[nA,4]+ROUND(EE9->EE9_PRCINC*nTAXA,2) // VALOR FOB REAIS EMBARCADO
      ///EE9->(AADD(aPROCESSO[nA,6],{EE9_COD_I,;            // 01.PEDIDO
      ///                            EE9_FABR+EE9_FALOJA,;  // 02.CODIGO DO ITEM
      ///                            EE9_SLDINI,;           // 03.QUANTIDADE
      ///                            EE9_UNIDAD,;           // 04.UNIDADE DE MEDIDA
      ///                            EE9_POSIPI,;           // 05.NCM
      ///                            EE9_PSLQUN,;           // 06.PESO LIQUIDO UNITARIO
      ///                            EE9_PRECOI,;           // 07.VALOR UNITARIO FOB NA MOEDA
      ///                            EE9_PRCINC,;           // 08.VALOR TOTAL DO ITEM FOB NA MOEDA
      ///                            EE9_PRECOI*nTAXA,;     // 09.VALOR UNITARIO DO ITEM EM REAIS
      ///                            EE9_PRCINC*nTAXA,;     // 10.VALOR TOTAL DO ITEM FOB EM REAIS
      ///                            EE9_PSLQTO}))          // 11.PESO LIQUIDO TOTAL
      EE9->(AADD(aPROCESSO[nA,6],{EE9_COD_I,;            // 01.PEDIDO
                                  EE9_FABR+EE9_FALOJA,;  // 02.CODIGO DO ITEM
                                  EE9_SLDINI,;           // 03.QUANTIDADE
                                  AF155(4),;             // 04.UNIDADE DE MEDIDA
                                  EE9_POSIPI,;           // 05.NCM
                                  EE9_PSLQUN,;           // 06.PESO LIQUIDO UNITARIO
                                  EE9_PRECOI,;           // 07.VALOR UNITARIO FOB NA MOEDA
                                  EE9_PRCINC,;           // 08.VALOR TOTAL DO ITEM FOB NA MOEDA
                                  EE9_PRECOI*nTAXA,;     // 09.VALOR UNITARIO DO ITEM EM REAIS
                                  EE9_PRCINC*nTAXA,;     // 10.VALOR TOTAL DO ITEM FOB EM REAIS
                                  AF155(3,cRATEIO),;     // 11.VALOR BASE DO RATEIO DO FRETE. DEPENDE DO MV
                                  RecNo()}))             // 12.NUMERO DO REGISTRO  
      EE9->(DBSKIP())                                    
   ENDDO
   // IMPRESSAO DOS DADOS DOS PROCESSOS DO EMBARQUE
   aPROCESSO := ASORT(aPROCESSO,,,{|X,Y| X[1] < Y[1]})
   aTOTREAIS := {{0,0},{0,0}}
   aTOTMOEDA := {{0,0},{0,0}}
   FOR nC := 1 TO LEN(aPROCESSO)
       aTOTREAIS[2,1] := 0 ; aTOTREAIS[2,2] := 0
       aTOTMOEDA[2,1] := 0 ; aTOTMOEDA[2,2] := 0
       nFATORVAL := ROUND((aPROCESSO[nC,2]/nVALFOB) ,4)
       nFATORPES := ROUND((aPROCESSO[nC,3]/nPESOLIQ),4)
       cA        := STR0015+ALLTRIM(aPROCESSO[nC,1]) //"PEDIDO "
       AF155(2,STRZERO(nPAG,3,0),"2")
       DET->DESPESAS := cA+SPACE(50-LEN(cA)-11)+STR0016+DTOC(aPROCESSO[nC,5]) //"DT."
       FOR nA := 1 TO 2
           aTOTREAIS[1,1] := 0 ; aTOTREAIS[1,2] := 0
           aTOTMOEDA[1,1] := 0 ; aTOTMOEDA[1,2] := 0
           FOR nB := 1 TO LEN(aDESP[nA])
               SYB->(DBSETORDER(1))
               SYB->(DBSEEK(XFILIAL("SYB")+aDESP[nA,nB,1]))
               IF (nPAG <= 1 .AND. (nLIN > PRIPAG .OR. nLIN+1 > PRIPAG)) .OR.;
                  (nPAG > 1  .AND. (nLIN > SEGPAG .OR. nLIN+1 > SEGPAG))
                  IF DET->FLAG # "3"
                     AF155(2,STRZERO(nPAG,3,0),"3")
                  ENDIF
                  nPAG := nPAG+1
                  AF155(2,STRZERO(nPAG,3,0),"0")
                  nLIN := 1
               ENDIF
               AF155(2,STRZERO(nPAG,3,0),"1")
               Do Case
                  Case aDESP[nA,nB,1] == "1"
                       DET->DESPESAS := STR0025 //"120-Comissão (A Remeter)"
                  Case aDESP[nA,nB,1] == "2"
                       DET->DESPESAS := STR0026 //"121-Comissão (Conta Gráfica)"
                  Case aDESP[nA,nB,1] == "3"
                       DET->DESPESAS := STR0027 //"122-Comissão (A Deduzir da Fatura)"
                  OtherWise
                       DET->DESPESAS := aDESP[nA,nB,1]+"-"+SYB->YB_DESCR
               EndCase
  
               IF aDESP[nA,nB,1] = "101"  // FOB
                  DET->VALORREAIS := TRANSFORM(aPROCESSO[nC,4],cPICTPRE)
                  DET->VALORMOEDA := TRANSFORM(aPROCESSO[nC,2],cPICTPRE)
                  DET->VALORFOB   := STR0011 //"BASE"
                  aTOTREAIS[1,1]  := aTOTREAIS[1,1]+aPROCESSO[nC,4]
                  aTOTMOEDA[1,2]  := aTOTMOEDA[1,2]+aPROCESSO[nC,2]
               ELSEIF aDESP[nA,nB,1] = "102" // Frete  //"103"  // SEGURO
                  DET->VALORREAIS := TRANSFORM(aDESP[nA,nB,2]*nFATORPES,cPICTPRE)
                  DET->VALORMOEDA := TRANSFORM(aDESP[nA,nB,3]*nFATORPES,cPICTPRE)
                  DET->VALORFOB   := TRANSFORM(((aDESP[nA,nB,3]*nFATORPES)/aPROCESSO[nC,2])*100,"@E 999.999")
                  aTOTREAIS[1,1]  := aTOTREAIS[1,1]+ROUND(aDESP[nA,nB,2]*nFATORPES,2)
                  aTOTMOEDA[1,2]  := aTOTMOEDA[1,2]+ROUND(aDESP[nA,nB,3]*nFATORPES,2)
               ELSE // Seguro e Demais Despesas.
                  DET->VALORREAIS := TRANSFORM(aDESP[nA,nB,2]*nFATORVAL,cPICTPRE)
                  DET->VALORMOEDA := TRANSFORM(aDESP[nA,nB,3]*nFATORVAL,cPICTPRE)
                  DET->VALORFOB   := TRANSFORM(((aDESP[nA,nB,3]*nFATORVAL)/aPROCESSO[nC,2])*100,"@E 999.999")
                  aTOTREAIS[1,1]  := aTOTREAIS[1,1]+ROUND(aDESP[nA,nB,2]*nFATORVAL,2)
                  aTOTMOEDA[1,2]  := aTOTMOEDA[1,2]+ROUND(aDESP[nA,nB,3]*nFATORVAL,2)
               ENDIF
               nLIN := nLIN+1
           NEXT
           IF nA = 1
              IF (nPAG <= 1 .AND. (nLIN > PRIPAG .OR. nLIN+1 > PRIPAG)) .OR.;
                 (nPAG > 1  .AND. (nLIN > SEGPAG .OR. nLIN+1 > SEGPAG)) //DFS - 07/05/12 - Ajuste no nome da define.
                 AF155(2,STRZERO(nPAG,3,0),"3")
                 nPAG := nPAG+1
                 AF155(2,STRZERO(nPAG,3,0),"0")
                 nLIN := 1
              ENDIF
              AF155(2,STRZERO(nPAG,3,0),"2")
              DET->DESPESAS   := STR0012 //"C.I.F."
              DET->VALORREAIS := TRANSFORM(aTOTREAIS[1,1],cPICTPRE)
              DET->VALORMOEDA := TRANSFORM(aTOTMOEDA[1,2],cPICTPRE)
              DET->VALORFOB   := TRANSFORM(ROUND((aTOTMOEDA[1,2]/aPROCESSO[nC,2])*100,3),"@E 999.999")
              nLIN            := nLIN+1
           ENDIF
           aTOTREAIS[2,1] := aTOTREAIS[2,1]+aTOTREAIS[1,1]
           aTOTMOEDA[2,2] := aTOTMOEDA[2,2]+aTOTMOEDA[1,2]
       NEXT
       AF155(2,STRZERO(nPAG,3,0),"3")
       IF (nPAG <= 1 .AND. (nLIN > PRIPAG .OR. nLIN+2 > PRIPAG)) .OR.;
          (nPAG > 1  .AND. (nLIN > SEGPAG .OR. nLIN+2 > SEGPAG))
          nPAG := nPAG+1
          AF155(2,STRZERO(nPAG,3,0),"0")
          nLIN := 1
       ENDIF
       AF155(2,STRZERO(nPAG,3,0),"2")
       DET->DESPESAS   := PADL(STR0017+cA+" - ",50," ") //"TOTAL DO PEDIDO "
       DET->VALORREAIS := TRANSFORM(aTOTREAIS[2,1],cPICTPRE)
       DET->VALORMOEDA := TRANSFORM(aTOTMOEDA[2,2],cPICTPRE)
       DET->VALORFOB   := TRANSFORM(ROUND((aTOTMOEDA[2,2]/aPROCESSO[nC,2])*100,3),"@E 999.999")
       AF155(2,STRZERO(nPAG,3,0),"3")
       nLIN := nLIN+2
   NEXT
   // INICIO DA IMPRESSAO DO CABECARIO DOS ITENS DOS PROCESSOS DO EMBARQUE
   IF (nPAG <= 1 .AND. (nLIN > PRIPAG .OR. nLIN+3 > PRIPAG)) .OR.;
      (nPAG > 1  .AND. (nLIN > SEGPAG .OR. nLIN+3 > SEGPAG))
      nPAG := nPAG+1
      nLIN := 0
   ENDIF
   AF155(2,STRZERO(nPAG,3,0),"4")
   DET->SUBTITULO := STR0018 //"CUSTO POR ITEM"
   nLIN           := nLIN+3
   IF (nPAG <= 1 .AND. (nLIN > PRIPAG .OR. nLIN+6 > PRIPAG)) .OR.;
      (nPAG > 1  .AND. (nLIN > SEGPAG .OR. nLIN+6 > SEGPAG))
      nPAG := nPAG+1
      nLIN := 0
   ENDIF
   AF155(2,STRZERO(nPAG,3,0),"6")
   nLIN      := nLIN+1
   aTOTREAIS := {{0,0},{0,0}}
   aTOTMOEDA := {{0,0},{0,0}}
   FOR nC := 1 TO LEN(aPROCESSO)
       FOR nD := 1 TO LEN(aPROCESSO[nC,6])
           aTOTREAIS[2,1] := 0 ; aTOTREAIS[2,2] := 0
           aTOTMOEDA[2,1] := 0 ; aTOTMOEDA[2,2] := 0
           SB1->(DBSETORDER(1))
           SB1->(DBSEEK(XFILIAL("SB1")+aPROCESSO[nC,6,nD,1]))
           SA2->(DBSETORDER(1))
           SA2->(DBSEEK(XFILIAL("SA2")+aPROCESSO[nC,6,nD,2]))
           cA := STR0015+ALLTRIM(aPROCESSO[nC,1]) //"PEDIDO "
           AF155(2,STRZERO(nPAG,3,0),"5")
           DET->DESPESAS   := cA+SPACE(50-LEN(cA)-11)+STR0016+DTOC(aPROCESSO[nC,5]) //"DT."
           DET->PRODUTO    := aPROCESSO[nC,6,nD,1]+" "+SB1->B1_DESC
           DET->FABRICANTE := SA2->(ALLTRIM(A2_COD)+" - "+A2_NOME)
           DET->QUANTIDADE := TRANSFORM(aPROCESSO[nC,6,nD,3],cPICTPES)+" "+aPROCESSO[nC,6,nD,4]
           DET->NCM        := TRANSFORM(aPROCESSO[nC,6,nD,5],cPICTNCM)
           DET->PESLIQUNIT := TRANSFORM(aPROCESSO[nC,6,nD,6],cPICTPES)
           DET->PESLIQTOTA := TRANSFORM(aPROCESSO[nC,6,nD,3]*aPROCESSO[nC,6,nD,6],cPICTPES)
           AF155(2,STRZERO(nPAG,3,0),"3")
           nLIN := nLIN+5
           FOR nA := 1 TO 2
               aTOTREAIS[1,1] := 0 ; aTOTREAIS[1,2] := 0
               aTOTMOEDA[1,1] := 0 ; aTOTMOEDA[1,2] := 0
               nFATORVAL      := ROUND((aPROCESSO[nC,6,nD,08]/nVALFOB) ,4)
               nFATORPES      := ROUND((aPROCESSO[nC,6,nD,11]/nPESOLIQ),4)
               FOR nB := 1 TO LEN(aDESP[nA])
                   SYB->(DBSETORDER(1))
                   SYB->(DBSEEK(XFILIAL("SYB")+aDESP[nA,nB,1]))
                   IF (nPAG <= 1 .AND. (nLIN > PRIPAG .OR. nLIN+1 > PRIPAG)) .OR.;
                      (nPAG > 1  .AND. (nLIN > SEGPAG .OR. nLIN+1 > SEGPAG))
                      IF DET->FLAG # "3"
                         AF155(2,STRZERO(nPAG,3,0),"3")
                      ENDIF
                      nPAG := nPAG+1
                      AF155(2,STRZERO(nPAG,3,0),"6")
                      nLIN := 1
                   ENDIF
                   AF155(2,STRZERO(nPAG,3,0),"1")
                   
                   Do Case
                      Case aDESP[nA,nB,1] == "1"
                           DET->DESPESAS := STR0025 //"120-Comissão (A Remeter)"
                      Case aDESP[nA,nB,1] == "2"
                           DET->DESPESAS := STR0026 //"121-Comissão (Conta Gráfica)"
                      Case aDESP[nA,nB,1] == "3"
                           DET->DESPESAS := STR0027 //"122-Comissão (A Deduzir da Fatura)"
                      OtherWise
                           DET->DESPESAS := aDESP[nA,nB,1]+"-"+SYB->YB_DESCR
                   EndCase

                   IF aDESP[nA,nB,1] = "101"  // FOB
                      DET->VALORREAIS := TRANSFORM(aPROCESSO[nC,6,nD,10],cPICTPRE)
                      DET->VALORMOEDA := TRANSFORM(aPROCESSO[nC,6,nD,08],cPICTPRE)
                      DET->VALORFOB   := STR0011 //"BASE"
                      DET->VALUNITREA := TRANSFORM(aPROCESSO[nC,6,nD,09],cPICTPRU)
                      DET->VALUNITMOE := TRANSFORM(aPROCESSO[nC,6,nD,07],cPICTPRU)
                      aTOTREAIS[1,1]  := aTOTREAIS[1,1]+aPROCESSO[nC,6,nD,09] // TOTAL REAL UNIT
                      aTOTREAIS[1,2]  := aTOTREAIS[1,2]+aPROCESSO[nC,6,nD,10] // TOTAL REAL
                      aTOTMOEDA[1,1]  := aTOTMOEDA[1,1]+aPROCESSO[nC,6,nD,07] // TOTAL MOEDA UNIT
                      aTOTMOEDA[1,2]  := aTOTMOEDA[1,2]+aPROCESSO[nC,6,nD,08] // TOTAL MOEDA
                   ELSEIF aDESP[nA,nB,1] = "102"  // Frete // 103 - SEGURO.
                      nVALTOTMOE      := ROUND((aDESP[nA,nB,3]*nFATORPES)            ,2)
                      nVALUNIMOE      := ROUND((nVALTOTMOE/aPROCESSO[nC,6,nD,03])    ,4)
                      nPERFOB         := ROUND((nVALTOTMOE/aPROCESSO[nC,6,nD,08])*100,3)
                      DET->VALUNITREA := TRANSFORM(nVALUNIMOE*nTAXA,cPICTPRU)
                      DET->VALUNITMOE := TRANSFORM(nVALUNIMOE      ,cPICTPRU)
                      DET->VALORMOEDA := TRANSFORM(nVALTOTMOE      ,cPICTPRE)
                      DET->VALORREAIS := TRANSFORM(nVALTOTMOE*nTAXA,cPICTPRE)
                      DET->VALORFOB   := TRANSFORM(nPERFOB         ,"@E 999.999")
                      aTOTREAIS[1,1]  := aTOTREAIS[1,1]+(nVALUNIMOE*nTAXA) // TOTAL REAIS UNIT.
                      aTOTREAIS[1,2]  := aTOTREAIS[1,2]+(nVALTOTMOE*nTAXA) // TOTAL REAIS
                      aTOTMOEDA[1,1]  := aTOTMOEDA[1,1]+nVALUNIMOE         // TOTAL MOEDA UNIT.
                      aTOTMOEDA[1,2]  := aTOTMOEDA[1,2]+nVALTOTMOE         // TOTAL MOEDAS

                   ELSEIF aDESP[nA,nB,1] == "1"  .or. aDESP[nA,nB,1] == "2" .or. aDESP[nA,nB,1] == "3" //Comissão
 
                      EE9->(DbGoTo(aPROCESSO[nC,6,nD,12]))
                      
                      If !Empty(EE9->EE9_CODAGE)

                         EEB->(DbSetOrder(1))
                         If EEB->(DbSeek(xFilial("EEB")+EE9->EE9_PREEMB+OC_EM+EE9->EE9_CODAGE))
                            
                            If EEB->EEB_TIPCOM == aDESP[nA,nB,1]

                               If EEB->EEB_TIPCVL $ "13" // Percentual/Percentual por item.
                                
                                  If lFobDescontado
                                     nVALTOTMOE := Round((EE9->EE9_PRCINC - EE9->EE9_VLDESC)*(EE9->EE9_PERCOM/100),2)

                                  Else
                                     nVALTOTMOE := Round(EE9->EE9_PRCINC*(EE9->EE9_PERCOM/100),2)
                                  EndIf

                               Else // Valor Fixo
                                  nVALTOTMOE := Round(EEB->EEB_VALCOM,4)

                               EndIf

                               nVALUNIMOE      := ROUND((nVALTOTMOE/aPROCESSO[nC,6,nD,03])    ,4)
                               nPERFOB         := ROUND((nVALTOTMOE/aPROCESSO[nC,6,nD,08])*100,3)
                               DET->VALUNITREA := TRANSFORM(nVALUNIMOE*nTAXA,cPICTPRU)
                               DET->VALUNITMOE := TRANSFORM(nVALUNIMOE      ,cPICTPRU)
                               DET->VALORMOEDA := TRANSFORM(nVALTOTMOE      ,cPICTPRE)
                               DET->VALORREAIS := TRANSFORM(nVALTOTMOE*nTAXA,cPICTPRE)
                               DET->VALORFOB   := TRANSFORM(nPERFOB         ,"@E 999.999")
                               aTOTREAIS[1,1]  := aTOTREAIS[1,1]+(nVALUNIMOE*nTAXA)
                               aTOTREAIS[1,2]  := aTOTREAIS[1,2]+(nVALTOTMOE*nTAXA)
                               aTOTMOEDA[1,1]  := aTOTMOEDA[1,1]+nVALUNIMOE
                               aTOTMOEDA[1,2]  := aTOTMOEDA[1,2]+nVALTOTMOE
                   
                            EndIf
                         EndIf
                      EndIf
                   ELSE  // Seguro e Diversos
                      nVALTOTMOE      := ROUND((aDESP[nA,nB,3]*nFATORVAL)            ,2)
                      nVALUNIMOE      := ROUND((nVALTOTMOE/aPROCESSO[nC,6,nD,03])    ,4)
                      nPERFOB         := ROUND((nVALTOTMOE/aPROCESSO[nC,6,nD,08])*100,3)
                      DET->VALUNITREA := TRANSFORM(nVALUNIMOE*nTAXA,cPICTPRU)
                      DET->VALUNITMOE := TRANSFORM(nVALUNIMOE      ,cPICTPRU)
                      DET->VALORMOEDA := TRANSFORM(nVALTOTMOE      ,cPICTPRE)
                      DET->VALORREAIS := TRANSFORM(nVALTOTMOE*nTAXA,cPICTPRE)
                      DET->VALORFOB   := TRANSFORM(nPERFOB         ,"@E 999.999")
                      aTOTREAIS[1,1]  := aTOTREAIS[1,1]+(nVALUNIMOE*nTAXA)
                      aTOTREAIS[1,2]  := aTOTREAIS[1,2]+(nVALTOTMOE*nTAXA)
                      aTOTMOEDA[1,1]  := aTOTMOEDA[1,1]+nVALUNIMOE
                      aTOTMOEDA[1,2]  := aTOTMOEDA[1,2]+nVALTOTMOE
                   ENDIF
                   nLIN := nLIN+1
               NEXT
               IF nA = 1
                  IF (nPAG <= 1 .AND. (nLIN > PRIPAG .OR. nLIN+1 > PRIPAG)) .OR.;
                     (nPAG > 1  .AND. (nLIN > SEGPAG .OR. nLIN+1 > SEGPAG))
                     AF155(2,STRZERO(nPAG,3,0),"3")
                     nPAG := nPAG+1
                     AF155(2,STRZERO(nPAG,3,0),"0")
                     nLIN := 1
                  ENDIF
                  AF155(2,STRZERO(nPAG,3,0),"2")
                  DET->DESPESAS   := STR0012 //"C.I.F."
                  DET->VALUNITREA := TRANSFORM(aTOTREAIS[1,1],cPICTPRU)
                  DET->VALORREAIS := TRANSFORM(aTOTREAIS[1,2],cPICTPRE)
                  DET->VALUNITMOE := TRANSFORM(aTOTMOEDA[1,1],cPICTPRU)
                  DET->VALORMOEDA := TRANSFORM(aTOTMOEDA[1,2],cPICTPRE)
                  DET->VALORFOB   := TRANSFORM(ROUND((aTOTMOEDA[1,2]/aPROCESSO[nC,6,nD,08])*100,3),"@E 999.999")
                  nLIN            := nLIN+1
               ENDIF
               aTOTREAIS[2,1]  := aTOTREAIS[2,1]+aTOTREAIS[1,1] // TOTAL REAIS UNIT.
               aTOTREAIS[2,2]  := aTOTREAIS[2,2]+aTOTREAIS[1,2] // TOTAL REAIS
               aTOTMOEDA[2,1]  := aTOTMOEDA[2,1]+aTOTMOEDA[1,1] // TOTAL MOEDA UNIT.
               aTOTMOEDA[2,2]  := aTOTMOEDA[2,2]+aTOTMOEDA[1,2] // TOTAL MOEDAS
           NEXT
           AF155(2,STRZERO(nPAG,3,0),"3")
           IF (nPAG <= 1 .AND. (nLIN > PRIPAG .OR. nLIN+2 > PRIPAG)) .OR.;
              (nPAG > 1  .AND. (nLIN > SEGPAG .OR. nLIN+2 > SEGPAG))
              nPAG := nPAG+1
              AF155(2,STRZERO(nPAG,3,0),"0")
              nLIN := 1
           ENDIF
           AF155(2,STRZERO(nPAG,3,0),"2")
           DET->DESPESAS   := PADL(STR0019+cA+" - ",50," ") //"TOTAL DO ITEM "
           DET->VALUNITREA := TRANSFORM(aTOTREAIS[2,1],cPICTPRU)
           DET->VALORREAIS := TRANSFORM(aTOTREAIS[2,2],cPICTPRE)
           DET->VALUNITMOE := TRANSFORM(aTOTMOEDA[2,1],cPICTPRU)
           DET->VALORMOEDA := TRANSFORM(aTOTMOEDA[2,2],cPICTPRE)
           DET->VALORFOB   := TRANSFORM(ROUND((aTOTMOEDA[2,2]/aPROCESSO[nC,6,nD,08])*100,3),"@E 999.999")
           AF155(2,STRZERO(nPAG,3,0),"3")
           nLIN := nLIN+2
       NEXT
       IF (nPAG <= 1 .AND. (nLIN > PRIPAG .OR. nLIN+7 > PRIPAG)) .OR.;
          (nPAG > 1  .AND. (nLIN > SEGPAG .OR. nLIN+7 > SEGPAG))
          nPAG := nPAG+1
          AF155(2,STRZERO(nPAG,3,0),"0")
          nLIN := 1
       ENDIF
       //AF155(2,STRZERO(nPAG,3,0),"2")
   NEXT
   AF155(2,STRZERO(nPAG,3,0),"H")
   CAB->ADIAN_DESP := TRANSFORM(aDESPA[1],cPICTPRE)
   CAB->COMPL_DESP := TRANSFORM(aDESPA[2],cPICTPRE)
   CAB->DEVOL_DESP := TRANSFORM(aDESPA[3],cPICTPRE)
   CAB->VALTR_DESP := TRANSFORM(aDESPA[1]+aDESPA[2]-aDESPA[3],cPICTPRE)
   CRWPREVIEW(aRETCRW,cARQRPT,cTITRPT,cSEQREL)
END SEQUENCE
RESTORD(AORDANT)
RETURN(.F.)
*--------------------------------------------------------------------
STATIC FUNCTION AF155(nP_ACAO,cP_CAMPO1,cP_CAMPO2) 
LOCAL lRET := .T.
IF nP_ACAO = 1
   EEC->(DBSETORDER(1))
   IF ! (EEC->(DBSEEK(XFILIAL("EEC")+cPREEMB)))
      MSGINFO(STR0020,STR0021) //"Processo nao cadastrado !"###"Atencao"
      lRET := .F.
   ENDIF
ELSEIF nP_ACAO = 2
       DET->(DBAPPEND())
       DET->SEQREL := cSEQREL
       DET->PAGINA := cP_CAMPO1
       DET->FLAG   := cP_CAMPO2
ELSEIF nP_ACAO = 3
      IF cP_CAMPO1 = "1"  // PESO LIQUIDO
         lRET := EE9->EE9_PSLQTO
      ELSEIF cP_CAMPO1 = "2"  // PESO BRUTO
             lRET := EE9->EE9_PSBRTO
      ELSE  // PRECO FOB
         lRET := EE9->EE9_PRCINC
      ENDIF
ELSEIF nP_ACAO = 4
       SAH->(DBSETORDER(1))
       SAH->(DBSEEK(XFILIAL("SAH")+EE9->EE9_UNIDAD))
       lRET := SAH->AH_UMRES
ENDIF
RETURN(lRET)
*--------------------------------------------------------------------

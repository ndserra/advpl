#INCLUDE "EECPFN00.ch"
#include "rwmake.ch"


#define CD_SA2 "X"
#define EEM_NF    "N"    //cadastro de notas
#define EEM_SD    "1"    //Nota de Saida                                 
#define EEM_CP    "2"    //Nota Complementar
#define EEM_CR    "3"    //Nota de Credito
#define TITULO_CREDITO STR0001 //"SOLICITACAO DE NOTA DE CREDITO"
#define TITULO_COMPLEM STR0002 //"SOLICITACAO DE EMISSAO DE FATURAMENTO COMPLEMENTAR"
#define TITULO_COMP1   STR0003 //"SOLICITACAO DE NF COMPLEMENTAR"
#define ENTER chr(13)+chr(10)
#define MARGEM Space(2)
/*-------------------------------------------------------------------
Programa        : EECPFN00.PRW
Objetivo        : Solicitacao de N.F. Complementar/Nota de Credito
Autor           : Cristiano A. Ferreira
Data/Hora       : 04/11/1999 09:51
*///-----------------------------------------------------------------
USER Function EECPFN00()
LOCAL aOrd := SaveOrd({"EE9","SA1","SA2","EEM"}),;
      lRet := .f.
PRIVATE CFILEMEN,AEXECUTAR,M->EEC_PREEMB,CEXPORT,CFAX,CPARA,DFATURA,;
        CFATURA,CCODCLIENTE,CCLIENTE,CCLIENTE2,CEND,CCID,DEMBARQUE,;
        NTAXA,CEMITIDO,CASSINADO,CAUTORIZ,CPICTDECPES,CPICTPESO,NTOTPED,;
        NFOBVALUE,NTOTFOB,NFRETE,NSEGURO,NOUTROS,ATOTAL,ANOTAS,ADTNFS,BSCAN,BSUM,;
        X,N,BFOR,NDIFTOTPED,NDIFTOTFOB,NDIFFRETE,NDIFSEGURO,NDIFOUTROS,CTIPO,CCODRPT,;
        CFASED,AORDIMP,NOPCAO,CTIT,CTITULO,CTIT1,CRPT,CSEQREL,GI_MRET,ADESCFAM,MDESCRI,;
        CDESCFAM,MPROD,CFAMANT,CNCMANT,I,ADESCRI,TG_LRET,TG_NOPC,TG_BOK,TB_BCANCEL,;
        TG_CLOAD,TG_ODLG,TG_Y,TG_BCANCEL,TG_NOPCA,TG_AOPC,CF_LRET,LG_LRET,CF3CODCLI,;
        CF3LOJCLI,FC_I,MDETALHE,CMENSAG,CNOTA,GI_NCOL,GI_NTOTLIN,GI_W
#xTranslate xLinha(<nVar>) => (<nVar> := <nVar>+11)
EE9->(dbSetOrder(1))
SA1->(dbSetOrder(1))
SA2->(dbSetOrder(1))
EEM->(dbSetOrder(1))
cFileMen     := ""
aExecutar    :={STR0004,STR0005,STR0006,STR0007} //"Reimprimir"###"Substituir"###"Criar Novo"###"Cancelar"
M->EEC_PREEMB:= Space(Len(EEC->EEC_PREEMB))
dFatura      := dDataBase
cCliente     := cCliente2   := cEnd     := cExport := cFax     := Space(60)
cEmitido     := cASSINADO   := cAUTORIZ := cPara   := Space(35)
cFatura      := cCodCliente := Space(20)
cPictDecPes  := cPictPeso   := ""
cCid         := Space(30)
dEmbarque    := Ctod("")
nTaxa        := 0
DO While TelaGets(1)
   cPictDecPes := if(EEC->EEC_DECPES > 0, "."+Replic("9",EEC->EEC_DECPES),"")
   cPictPeso   := "@E 999,999,999"+cPictDecPes
   nTotPed     := EEC->EEC_TOTPED*nTaxa
   nFobValue   := (EEC->EEC_TOTPED+EEC->EEC_DESCON)-(EEC->EEC_FRPREV+EEC->EEC_FRPCOM+EEC->EEC_SEGPRE+EEC->EEC_DESPIN)
   nTotFob     := nFobValue*nTaxa
   nFrete      := EEC->EEC_FRPREV*nTaxa
   nSeguro     := EEC->EEC_SEGPRE*nTaxa
   nOutros     := (EEC->EEC_FRPCOM+EEC->EEC_DESPIN-EEC->EEC_DESCON)*nTaxa
   aTotal      := {0,0,0,0,0}  // Totais das notas
   aNotas      := {"","","","",""} // Nro. das notas
   aDtNFs      := {"","","","",""} // Data das notas
   bScan       := {|z| Empty(z)}
   bSum        := {|n,x| x:=aScan(aNotas,bScan),;
                   if(x>0,aNotas[x] := STR0008+if(EEM_TIPONF==EEM_CR,"",AllTrim(EEM->EEM_NRNF))+" "+if(EEM_TIPONF==EEM_CR,STR0009+dtoc(dDataBase),if(EEM_TIPONF==EEM_CP,STR0010,STR0011)),),; //"NF "###"Credito "###"Complementar"###"Saida"
                   if(x>0,aDtNFs[x] := Dtoc(EEM->EEM_DTNF),),;
                   n := if(EEM_TIPONF==EEM_CR,-1,1),;
                   aTotal[1] := aTotal[1]+n*EEM->EEM_VLNF,;
                   aTotal[2] := aTotal[2]+n*EEM->EEM_VLMERC,;
                   aTotal[3] := aTotal[3]+n*EEM->EEM_VLFRET,;
                   aTotal[4] := aTotal[4]+n*EEM->EEM_VLSEGU,;
                   aTotal[5] := aTotal[5]+n*EEM->EEM_OUTROS }
   bFor := {|| At(EEM_TIPONF,EEM_SD+"\"+EEM_CR+"\"+EEM_CP) != 0 .AND.!EMPTY(EEM->EEM_DTNF)}
   EEM->(dbSeek(xFilial()+AvKey(EEC->EEC_PREEMB,"EEM_PREEMB")+EEM_NF))
   EEM->(dbEval(bSum,bFor,{||EEM_FILIAL==xFilial("EEM").And.EEM->EEM_PREEMB==EEC->EEC_PREEMB.And.EEM->EEM_TIPOCA==EEM_NF}))
   nDifTotPed := nTotPed-aTotal[1]
   nDifTotFob := nTotFob-aTotal[2]
   nDifFrete  := nFrete-aTotal[3]
   nDifSeguro := nSeguro-aTotal[4]
   nDifOutros := nOutros-aTotal[5]
   cTipo      := IF(nDifTotPed>0,EEM_CP,EEM_CR)
   cCodRpt    := "EECPFN00"+IF(cTipo==EEM_CP,"CP","CR")
   IF VAL(TRANSF(nDifTotPed,"@E 999,999,999.99")) == 0
      MsgStop(STR0012,STR0013) //"Não existem diferenças. Não é necessário Notas Crédito/Complementar."###"Aviso"
      Loop
   Endif
   cFased := "2"
   aOrdImp := saveord("SY0")
   SY0->(DBSETORDER(4))
   IF ( SY0->(DBSEEK(XFILIAL("SY0")+M->EEC_PREEMB+cFased+cCodRpt))) 
      nOpcao := 0
      cTit   := AllTrim(cTit1) + " " + AllTrim(M->EEC_PREEMB)
      *aqui
      @ 300,20 TO 400,400 DIALOG oDlg TITLE cTIT
      @ 016, 20 BUTTON aExecutar[1] SIZE 27,15  ACTION "nOpcao:=1,IW_End(oDlg)"
      @ 016, 62 BUTTON aExecutar[2] SIZE 27,15  ACTION "nOpcao:=2,IW_End(oDlg)"
      @ 016,104 BUTTON aExecutar[3] SIZE 27,15  ACTION "nOpcao:=3,IW_End(oDlg)"
      @ 016,146 BUTTON aExecutar[4] SIZE 27,15  ACTION "nOpcao:=4,IW_End(oDlg)"
      ACTIVATE DIALOG oDlg CENTERED
	  IF (nOpcao == 1)
	     AVRPTVIEW()
		 EXIT
      elseIf nOpcao == 2
             RECLOCK("SY0",.F.) 
             SY0->(DBDELETE())
      ELSEIF nOpcao == 4
             lRET:=.F.
             EXIT
      Endif
   Endif
   IF ! TelaGets(2)
      Exit
   Endif
   IF cTipo == EEM_CR // Nota de Credito
      nDifTotPed := nDifTotPed * -1
      nDifTotFob := nDifTotFob * -1
      nDifFrete  := nDifFrete  * -1
      nDifSeguro := nDifSeguro * -1
      nDifOutros := nDifOutros * -1
   Endif
   cTitulo := IF(cTipo==EEM_CP,TITULO_COMPLEM,TITULO_CREDITO)
   cTit1   := IF(cTipo==EEM_CP,TITULO_COMP1,TITULO_CREDITO)
   cRpt    := "AVGLTT.RPT"
   IF ! TelaGets(3)
      Loop
   Endif
   IF cTipo == EEM_CR // Nota de Credito
      IF ! TelaGets(4)
         Loop
      Endif
   Endif
   //gerar arquivo padrao de edicao de carta
   IF ! E_AVGLTT("G")
      lRet := .F.
      Exit
   Endif
   cSEQREL :=GetSX8Num("SY0","Y0_SEQREL")
   ConfirmSX8()
   IF cTipo == EEM_CR
      FormatCredito()
      cRpt := "EECSLNC.RPT"
      //executar rotina de manutencao de caixa de texto
      lRet := E_AVGLTT("W",cTitulo)
   Else
      FormatComplementar()
      //adicionar registro no AVGLTT
      AVGLTT->(DBAPPEND())
      AVGLTT->AVG_CHAVE  := EEC->EEC_PREEMB
      AVGLTT->AVG_C01_60 := cExport
      AVGLTT->AVG_C02_60 := cTitulo
      AVGLTT->WK_DETALHE := mDETALHE
      //executar rotina de manutencao de caixa de texto
      lRet := E_AVGLTT("M",cTitulo)
   Endif
   IF ! lRet
      Exit
   Endif
   //forcar atualizacao
   HEADER_P->(DBCOMMIT())
   DETAIL_P->(DBCOMMIT())
   IF ! AvgCrw32(cRpt,cTitulo,cSeqRel)
      Exit
   Endif
   //gravar historico de documentos
   E_HISTDOC(,cTITULO,dDATABASE,,,cRPT,cSeqrel,"2",EEC->EEC_PREEMB,cCODRPT)
   Exit
Enddo
IF Select("Work_Men") > 0
   Work_Men->(E_EraseArq(cFileMen))
Endif
RestOrd(aOrd)
Return(lRet)
//-------------------------------------------------------------------
Static Function GravaItens()
gi_mRet := MARGEM+Padr(STR0014,62)+Padr(STR0015,20)+ENTER //"PRODUTO"###"P.LIQUIDO"
EE9->(dbSeek(xFilial()+EEC->EEC_PREEMB))
DO While EE9->(!Eof() .And. EE9_FILIAL==xFilial("EE9")) .And.;
   EE9->EE9_PREEMB == EEC->EEC_PREEMB
   gi_mRet := gi_mRet+MARGEM+Padr(MSMM(EE9->EE9_DESC,62),62)+Padl(Transform(EE9->EE9_PSLQTO,cPictPeso),20)+ENTER
   EE9->(dbSkip())
Enddo
gi_mRet := gi_mRet + REPLICATE("-",100)
Return(gi_mRet)
//----------------------------------------------------------------------
Static Function TelaGets(TG_NTIPO)
tg_lRet := .f.
tg_nOpc := 0
tg_bOk  := tb_bCancel := nil
IF tg_nTipo == 1
   tg_cLoad:= ""
   M->EEC_PREEMB := Space(AVSX3("EEC_PREEMB",3))
   DEFINE MSDIALOG TG_oDlg TITLE STR0016 FROM 7,10 TO 12,60 OF oMainWnd //"Solicitação de N.F. Complementar/Nota de Crédito"
   tg_y := 20
   @ tg_y,01 SAY AVSX3("EEC_PREEMB",5)
   @ tg_y,40 GET M->EEC_PREEMB F3 "EEC" SIZE 50,08 PICTURE AVSX3("EEC_PREEMB",6) VALID ExistEmbarq()
   tg_bOk     := {||tg_nOpc:=1,IF(ValidAll(tg_oDlg),tg_oDlg:End(),tg_nOpc:=0)}
   tg_bCancel := {||tg_nOpc:=0,TG_ODLG:END()}
   ACTIVATE MSDIALOG TG_oDlg ON INIT EnchoiceBar(tg_oDlg,tg_bOk,tg_bCancel)
   IF tg_nOpc == 1
      tg_lRet := .t.
      if !LoadGets()
         tg_lRet := .f.
	  Endif
   Endif 
Elseif tg_nTipo == 2
       DEFINE MSDIALOG TG_oDlg TITLE STR0016 FROM 7,0 TO 26,80 OF oMainWnd //"Solicitação de N.F. Complementar/Nota de Crédito"
       tg_y := 14
       @ tg_y,01 SAY AVSX3("EEC_PREEMB",5)
       @ tg_y,40 GET M->EEC_PREEMB F3 "EEC" SIZE 50,08 PICTURE AVSX3("EEC_PREEMB",6) WHEN .F.
       @ xLinha(tg_y),01 SAY STR0017 //"Exportador"
       @ tg_y,40 GET cExport
       @ xLinha(tg_y),01 SAY STR0018 //"Fax"
       @ tg_y,40 GET cFax
       @ xLinha(tg_y),01 SAY STR0019 //"Para"
       @ tg_y,40 GET cPara
       @ xLinha(tg_y),01 SAY STR0020 //"Fatura Nr."
       @ tg_y,40 GET cFatura PICTURE AVSX3("EEC_NRINVO",6) VALID chkFatura()
       @ tg_y,115 SAY STR0021 //"Faturar em"
       @ tg_y,145 GET dFatura
       @ xLinha(tg_y),01 SAY STR0022 //"Código Cliente"
       @ tg_y,40 GET cCodCliente
       @ xLinha(tg_y),01 SAY STR0023 //"Cliente"
       @ tg_y,40 GET cCliente
       @ xLinha(tg_y),01 SAY STR0024 //"Data Embarque"
       @ tg_y,40 GET dEmbarque When .F.
       @ tg_y,79 SAY STR0025 //"Taxa"
       @ tg_y,95 GET nTaxa PICTURE "@E 9,999.999999" WHEN .f.
       @ xLinha(tg_y),01 SAY STR0026  //"Emitido"
       @ tg_y,40 GET cEmitido F3 "E33"
       @ xLinha(tg_y),01 SAY STR0027  //"Assinado"
       @ tg_y,40 GET cAssinado F3 "E33"
	   @ xLinha(tg_y),01 SAY STR0028 //"Autorizado"
       @ tg_y,40 GET cAUTORIZ  F3 "E33"
       tg_bOk     := {||tg_nOpc:=1,IF(ValidAll(tg_oDlg),TG_ODLG:END(),tg_nOpc:=0)}
       tg_bCancel := {||tg_nOpc:=0,TG_ODLG:END()}
       ACTIVATE MSDIALOG TG_oDlg ON INIT EnchoiceBar(tg_oDlg,tg_bOk,tg_bCancel)
       IF tg_nOpc == 1
          tg_lRet := .t.
       Endif 
Elseif tg_nTipo == 3
       tg_nOpcA:= 0
       tg_aOpc := {STR0010,STR0029} //"Complementar"###"Crédito"
       tg_nOpc := IF(cTipo==EEM_CP,STR0010,STR0029) //"Complementar"###"Crédito"
       DEFINE MSDIALOG TG_oDlg TITLE STR0016 FROM 7,0 TO 26,80 OF oMainWnd //"Solicitação de N.F. Complementar/Nota de Crédito"
       @ 15,03 SAY STR0030 //"Tipo de Nota:"
       @ 15,42 Get tg_nOPC when .f.
       tg_y := 38
       @ tg_y,03 SAY STR0031 //"FOB"
       @ tg_y,42 GET nDifTotFob PICTURE AVSX3("EEC_TOTPED",6) VALID AtualizaTot()
       @ xLinha(tg_y),03 SAY STR0032 //"Frete"
       @ tg_y,42 GET nDifFrete PICTURE AVSX3("EEC_FRPREV",6) VALID AtualizaTot()
       @ xLinha(tg_y),03 SAY STR0033 //"Seguro"
       @ tg_y,42 GET nDifSeguro PICTURE AVSX3("EEC_SEGPREV",6) VALID AtualizaTot() 
       @ xLinha(tg_y),03 SAY STR0034 //"Outros"
       @ tg_y,42 GET nDifOutros PICTURE AVSX3("EEC_TOTPED",6) VALID AtualizaTot()
       @ xLinha(tg_y),03 SAY STR0035 //"Total"
       @ tg_y,42 GET nDifTotPed PICTURE AVSX3("EEC_TOTPED",6) OBJECT tg_oGet
       EECMensagem(EEC->EEC_IDIOMA,"3",{xLinha(tg_y),1,150,325},,,,tg_oDlg)
       tg_oGet:Disable()
       tg_bOk     := {||tg_nOpcA:=1,tg_oDlg:End()}
       tg_bCancel := {||tg_nOpcA:=0,tg_oDlg:End()}
       ACTIVATE MSDIALOG TG_oDlg ON INIT EnchoiceBar(tg_oDlg,tg_bOk,tg_bCancel)
       IF tg_nOpcA == 1
          cTipo := IF(tg_nOpc==STR0010,EEM_CP,EEM_CR) //"Complementar"
          tg_lRet := .t.
       Endif 
Else
   IF Empty(EEC->EEC_CLIENT) .OR. ! (SA1->(dbSeek(xFilial()+EEC->EEC_CLIENT+EEC->EEC_CLLOJA)))
      SA1->(dbSeek(xFilial()+EEC->EEC_IMPORT+EEC->EEC_IMLOJA))
   Endif
   cEnd    := SA1->A1_END 
   cCid    := SA1->A1_MUN 
   DEFINE MSDIALOG TG_oDlg TITLE STR0036 FROM 7,0 TO 18,80 OF oMainWnd //"Solicitação Nota de Crédito"
   tg_y    := 20
   @ tg_y,01 SAY STR0023 //"Cliente"
   @ tg_y,40 GET cCliente
   @ xLinha(tg_y),40 GET cCliente2
   @ xLinha(tg_y),01 SAY STR0037 //"Endereço"
   @ tg_y,40 GET cEnd
   @ xLinha(tg_y),01 SAY STR0038 //"Cidade"
   @ tg_y,40 GET cCid
   tg_bOk     := {||tg_nOpc:=1,tg_oDlg:End()}
   tg_bCancel := {||tg_nOpc:=0,Tg_oDlg:End()}
   ACTIVATE MSDIALOG TG_oDlg ON INIT EnchoiceBar(tg_oDlg,tg_bOk,tg_bCancel)
   IF tg_nOpc == 1
      tg_lRet := .t.
   Endif 
Endif
Return(tg_lRet)
//----------------------------------------------------------------------
Static Function AtualizaTot()
nDifTotPed := nDifTotFob+nDifFrete+nDifSeguro+nDifOutros
tg_oGet:Refresh()
Return(.T.)
//----------------------------------------------------------------------
Static Function chkFatura()
LOCAL cf_lRet := .t.
IF !EEM->(dbSeek(xFilial()+EEC->EEC_PREEMB+EEM_NF))//+AvKey(cFatura,"EEM_NRNF")))
   MsgStop(STR0039,STR0013) //"Não existe Nota de Saída para esta Fatura !"###"Aviso"
   cf_lRet := .f.
Endif
Return(cf_lRet)
//----------------------------------------------------------------------
Static Function LoadGets()
LOCAL lg_lRet := .T.
DO While .t.
   IF tg_cLoad == M->EEC_PREEMB
      Exit
   Endif
   tg_cLoad := M->EEC_PREEMB
   IF ! Empty(EEC->EEC_EXPORT) .And.;
      SA2->(dbSeek(xFilial()+EEC->EEC_EXPORT+EEC->EEC_EXLOJA))
      cPara := EECCONTATO(CD_SA2, EEC->EEC_EXPORT,EEC->EEC_EXLOJA,"3",1)
      cFax  := EECCONTATO(CD_SA2, EEC->EEC_EXPORT,EEC->EEC_EXLOJA,"3",7)
   Else
      SA2->(dbSeek(xFilial()+EEC->EEC_FORN+EEC->EEC_FOLOJA))
      cPara := EECCONTATO(CD_SA2, EEC->EEC_FORN,EEC->EEC_FOLOJA,"3",1)
      cFax  := EECCONTATO(CD_SA2, EEC->EEC_FORN,EEC->EEC_FOLOJA,"3",7)
   Endif
   cExport := SA2->A2_NOME
   EE9->(dbSeek(xFilial()+EEC->EEC_PREEMB))
   dFatura := dDataBase
   cCodCliente := Space(20)
   cFatura := EEC->EEC_NRINVO
   IF ! Empty(EEC->EEC_CLIENT) .And.;
      SA1->(dbSeek(xFilial()+EEC->EEC_CLIENT+EEC->EEC_CLLOJA))
      cCliente := Padr(SA1->A1_NOME,60)
      cF3CODCLI:=EEC->EEC_CLIENT
      cF3LOJCLI:=EEC->EEC_CLLOJA
   Else
      cCliente := EEC->EEC_IMPODE
      cF3CODCLI:=EEC->EEC_IMPORT
      cF3LOJCLI:=EEC->EEC_IMLOJA
   Endif
   EE9->(DBSETORDER(2))
   EE9->(dbSeek(xFilial("EE9")+EEC->EEC_PREEMB))
   *AQUI
   dEmbarque := EE9->EE9_DTAVRB
   IF ( EMPTY(dEmbarque) )
      MSGSTOP(STR0040) //"Data de Averbação não preenchida para esse processo"
	  lg_lRet := .F.
	  exit
   Endif
   nTaxa    := BUSCATAXA(EEC->EEC_MOEDA,dEMBARQUE,,.T.,.F.)//EEC->EEC_CBTX
   cEmitido := EEC->EEC_RESPON
   IF ( nTaxa == 0 )
	  lg_lRet := .F.
	  exit
   Endif
   Exit
Enddo   
Return(lg_lRet)
//----------------------------------------------------------------------
Static Function FormatCredito()
Local fc_i:=0

HEADER_P->(dbAppend())
HEADER_P->AVG_FILIAL := xFilial("SY0")
HEADER_P->AVG_CHAVE  := M->EEC_PREEMB
HEADER_P->AVG_SEQREL := cSEQREL
HEADER_P->AVG_C01_60 := cExport
HEADER_P->AVG_C02_60 := STR0041 //"CONTABILIDADE GERAL"
HEADER_P->AVG_D01_08 := dFatura
HEADER_P->AVG_C03_60 := cCliente
HEADER_P->AVG_C05_60 := cCliente2
HEADER_P->AVG_C04_60 := cEnd
HEADER_P->AVG_C01_30 := cCid
HEADER_P->AVG_C01_20 := Posicione("SYA",1,xFilial("SYA")+SA1->A1_PAIS,"YA_DESCR")
HEADER_P->AVG_N02_15 := nDifTotPed
HEADER_P->AVG_C02_20 := cFatura
HEADER_P->AVG_D02_08 := dEmbarque
HEADER_P->AVG_N03_15 := nTaxa
HEADER_P->AVG_C02_30 := cEMITIDO
HEADER_P->AVG_C03_30 := cASSINADO
HEADER_H->(dbAppend())
AvReplace("HEADER_P","HEADER_H")
For fc_i := 1 To Len(aNotas)
   IF Empty(aNotas[fc_i])
      Exit
   Endif
   DETAIL_P->(dbAppend())
   DETAIL_P->AVG_FILIAL := xFilial("SY0")
   DETAIL_P->AVG_CHAVE  := M->EEC_PREEMB
   DETAIL_P->AVG_SEQREL := cSEQREL
   DETAIL_P->AVG_C01_10 := aNotas[fc_i]
   DETAIL_P->AVG_C02_10 := aDtNFs[fc_i]
   DETAIL_H->(dbAppend())
   AvReplace("DETAIL_P","DETAIL_H")
   DETAIL_H->(dbUnlock())
   DETAIL_P->(dbUnlock())
Next
HEADER_P->(dbUnlock())
HEADER_H->(dbUnlock())
Return(NIL)
//----------------------------------------------------------------------
Static Function FormatComplementar()
Local gi_w:=0

mDetalhe := ""
mDetalhe := mDetalhe+MARGEM+STR0042+cFax+ENTER //"FAX: "
mDetalhe := mDetalhe+MARGEM+STR0043+cPara+ENTER //"PARA: "
mDetalhe := mDetalhe+ENTER
mDetalhe := mDetalhe+MARGEM+Padr(STR0044+Dtoc(dFatura),50)+STR0045+ENTER //"FATURAR EM "###"C.COPIA"
mDetalhe := mDetalhe+MARGEM+Space(50)+STR0046+ENTER //"CONTABILIDADE"
mDetalhe := mDetalhe+ENTER
mDetalhe := mDetalhe+MARGEM+Padr(STR0047+cFatura,50)+STR0048+cCodCliente+ENTER //"FATURA NR "###"CODIGO DO CLIENTE: "
mDetalhe := mDetalhe+ENTER
mDetalhe := mDetalhe+MARGEM+Padr(STR0023,50)+Padr(STR0049,20)+STR0050+Posicione("SYF",1,xFilial("SYF")+EEC->EEC_MOEDA,"YF_DESC_SI")+ENTER //"CLIENTE"###"DATA DE EMBARQUE"###"TAXA "
mDetalhe := mDetalhe+MARGEM+Padr(cCliente,50)+Padr(Dtoc(dEmbarque),20)+Padl(Transform(nTaxa,"@E 9,999.999999"),16)+ENTER
mDetalhe := mDetalhe+ENTER
mDetalhe := mDetalhe+GravaItens()
mDetalhe := mDetalhe+ENTER
mDetalhe := mDetalhe+MARGEM+Space(50)+STR0051+ENTER //"NOTA FISCAL COMPLEMENTAR"
mDetalhe := mDetalhe+MARGEM+Space(50)+STR0052+ENTER //"VALORES ABAIXO"
mDetalhe := mDetalhe+ENTER
mDetalhe := mDetalhe+MARGEM+Padr(STR0053,8)+PadL(EEC->EEC_MOEDA+STR0054,18)+PadL(STR0055,20)+Padl(STR0056,20)+ENTER //"TIPO"###"  X"###"TAXA = "###"TOTAL R$"
mDetalhe := mDetalhe+MARGEM+Padr(STR0031,8)+Padl(Transf(nFobValue,"@E 999,999,999.99"),18)+Padl(Transform(nTaxa,"@E 9,999.9999"),20)+Padl(Transf(nDifTotFob,"@E 999,999,999.99"),20)+ENTER //"FOB"
mDetalhe := mDetalhe+MARGEM+Padr(STR0032,8)+Padl(Transf(EEC->EEC_FRPREV,"@E 999,999,999.99"),18)+Space(20)+Padl(Transf(nDifFrete,"@E 999,999,999.99"),20)+ENTER //"FRETE"
mDetalhe := mDetalhe+MARGEM+Padr(STR0033,8)+Padl(Transf(EEC->EEC_SEGPRE,"@E 999,999,999.99"),18)+Space(20)+Padl(Transf(nDifSeguro,"@E 999,999,999.99"),20)+ENTER //"SEGURO"
mDetalhe := mDetalhe+MARGEM+Padr(STR0034,8)+Padl(Transf((EEC->EEC_FRPCOM+EEC->EEC_DESPIN-EEC->EEC_DESCON),"@E 999,999,999.99"),18)+Space(20)+Padl(Transf(nDifOutros,"@E 999,999,999.99"),20)+ENTER //"OUTROS"
mDetalhe := mDetalhe+MARGEM+Padr(STR0035,8)+Padl(Transf(EEC->EEC_TOTPED,"@E 999,999,999.99"),18)+Space(20)+Padl(Transf(nDifTotPed,"@E 999,999,999.99"),20)+ENTER //"TOTAL"
mDetalhe := mDetalhe+REPLICATE("-",100)+ENTER
mDetalhe := mDetalhe+MARGEM+Space(25)+STR0057+ENTER+ENTER //"OBSERVACOES"
EEM->(dbSeek(xFilial()+EEC->EEC_PREEMB+EEM_NF))
DO WHILE xFilial("EEM")==EEM->EEM_FILIAL .AND. EEC->EEC_PREEMB == EEM->EEM_PREEMB .AND. EEM_NF == EEM->EEM_TIPOCA
  If EMPTY( EEM->EEM_DTNF )
     EEM->(DBSKIP())
	 LOOP
  EndIf
  n := if(EEM->EEM_TIPONF==EEM_CR,-1,1)
  cMENSAG := ""
  if (n == 1)
     cMensag := AllTrim(EEM->EEM_NRNF)
  endif	 
  cNota    := STR0008+cMensag+" "+if(EEM->EEM_TIPONF==EEM_CR,STR0009+ dtoc(dDataBase),if(EEM->EEM_TIPONF==EEM_CP,STR0010,STR0011)) //"NF "###"Credito "###"Complementar"###"Saida"
  mDetalhe := mDetalhe+MARGEM+Padr(cNota,25)+Padr(STR0031,8)+Space(19)+Padr(Transf(n*EEM->EEM_VLMERC,"@E 999,999,999.99"),20)+ENTER //"FOB"
  mDetalhe := mDetalhe+MARGEM+SPACE(25)+Padr(STR0032,8)+Space(19)+Padr(Transf(n*EEM->EEM_VLFRET,"@E 999,999,999.99"),20)+ENTER //"FRETE"
  mDetalhe := mDetalhe+MARGEM+SPACE(25)+Padr(STR0033,8)+Space(19)+Padr(Transf(n*EEM->EEM_VLSEGU,"@E 999,999,999.99"),20)+ENTER //"SEGURO"
  mDetalhe := mDetalhe+MARGEM+SPACE(25)+Padr(STR0034,8)+Space(19)+Padr(Transf(n*EEM->EEM_OUTROS,"@E 999,999,999.99"),20)+ENTER //"OUTROS"
  mDetalhe := mDetalhe+MARGEM+SPACE(25)+Padr(STR0058,25)+Space(2)+Padr(Transf(n*EEM->EEM_VLNF,"@E 999,999,999.99"),20)+ENTER+ENTER //"TOTAL DA NF "
  EEM->(DBSKIP())
ENDDO												
mDetalhe := mDetalhe+MARGEM+SPACE(25)+Padr(STR0059,25)+Space(2)+Padr(Transf(aTotal[1],"@E 999,999,999.99"),20)+ENTER //"TOTAL DAS NF'S"
mDetalhe := mDetalhe+Replic(ENTER,2)
// *** Observacoes ...
IF Select("Work_Men") > 0
   gi_nCol := 60
   Work_Men->(dbGoTop())
   DO While ! Work_Men->(Eof()) .And. Work_Men->WKORDEM < "zzzzz"
      gi_nTotLin:=MlCount(Work_Men->WKOBS,gi_nCol) 
      For gi_w := 1 To gi_nTotLin
         IF !Empty(MemoLine(Work_Men->WKOBS,gi_nCol,gi_w))
            mDetalhe := mDetalhe+MARGEM+MemoLine(Work_Men->WKOBS,gi_nCol,gi_w)+ENTER
         EndIf
      Next
      Work_Men->(dbSkip())
   Enddo
Endif
mDetalhe := mDetalhe+Replic(ENTER,2)
mDetalhe := mDetalhe+MARGEM+STR0060+cEMITIDO+ENTER+ENTER //"EMITIDO POR        "
Return(NIL)
*------------------------------------------------------------------------------*
* FIM DO PROGRAMA EECPFN00.PRW                                                 *
*------------------------------------------------------------------------------*
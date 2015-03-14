#INCLUDE "EECRDM.CH"
#INCLUDE "eecpem56.ch"


/*
Programa  : EECPEM56_RDM.
Objetivo  : Carta Remessa de Documentos (Modelo 2).
Autor     : Jeferson Barros Jr.
Data/Hora : 13/12/2003 - 11:05.
Obs.      : Inicialmente desenvolvido p/ S.Magalhães. (ECSME02.prw) 
Revisão   :
*/

#define LenCol1 30
#define LenCol2 02
#define LenCol3 02
#DEFINE TAMMSG  85

/*
Funcao     : EECPEM56.
Parametros : Nenhum.
Retorno    : .t./.f.
Objetivos  : Impressão Carta Remessa de Documentos (Modelo 2).
Autor      : Jeferson Barros Jr.
Data/Hora  : 13/12/2003 - 11:05.
Revisao    :
Obs.       :
*/
*---------------------*
User Function EECPEM56
*---------------------*
Local lRet := .f.
Local nAlias := Select(),nLinhas
Local cEXP_CONTATO,cSY0Seq,nFob:=0,cWKTEXTO
Local cNomBco:="", cContBco:= "", cEndBco:= "",cBaiBco:="", cMunBco:= ""
Local Z,c01100,aAGENT, i:=0, n:=0

Private aMESES := {"JANEIRO","FEVEREIRO","MARCO","ABRIL","MAIO","JUNHO","JULHO","AGOSTO","SETEMBRO","OUTUBRO","NOVEMBRO","DEZEMBRO"}
Private cMarca := GetMark(), lInverte := .f.
Private cTO_NOME,cTO_ATTN,cTO_FAX
Private cTitulo := CriaVar("EEA_TITULO"),cBanco:=Space(30),cBanco1:=Space(30)
Private cDtVencto,cMemo:="",cContato:=CriaVar("EE3_NOME"),cTelCont:=CriaVar("EE3_FONE")
Private cData,cInst:="",lCopia:=.f.
Private m_aHeader:={},m_aCols:={},m_n:=1,a_aHeader:={},a_aCols:={},a_n:=1
Private aHeader := {},aCols:={}
Private cUsad := Posicione("SX3",2,"EEC_PREEMB","X3_USADO"),cOri,cCopy,cDoc,cAd
Private oMark2,oGetDb,cObs   := "", cFileMen:="",cVisual := Posicione("SX3",2,"A6_DESCPAI","X3_USADO")
Private cMemoNroOp:="", cMemoValor:="", cMemoData:=""
Private cEXPMEMO,cIMPMEMO,cEXP_FONE,cEXP_FAX

Begin Sequence

   cWKTEXTO:= "" ; cEXPMEMO:= ""; cIMPMEMO:= ""

   EE9->(DbSetOrder(3))

   aAdd(a_aHeader,{STR0001,"WKDOC","@!" ,LenCol1,0,"",cUsad,"C","ZZZ"})   //"Descricao dos Doc."
   aAdd(a_aHeader,{STR0002,"WKORI","99" ,LenCol2,0,"",cUsad,"C","ZZZ"})   // "Original"
   aAdd(a_aHeader,{STR0003,"WKCOP","99" ,LenCol3,0,"",cUsad,"C","ZZZ"})   // "Copia"
   aAdd(a_aHeader,{"     ","WKADI","@!" ,0      ,0,"",cVisual,"C","ZZZ"}) // Coluna Adicional

   // ** Dados do Exportador.
   SA2->(dbSetOrder(1))
   IF !EMPTY(EEC->EEC_EXPORT)
      SA2->(dbSeek(xFilial()+EEC->EEC_EXPORT+EEC->EEC_EXLOJA))
      cEXP_CONTATO :=EECCONTATO(CD_SA2,EEC->EEC_EXPORT,EEC->EEC_EXLOJA,"1",1,EEC->EEC_RESPON)  //nome do contato seq 1
      cEXP_FONE    :=EECCONTATO(CD_SA2,EEC->EEC_EXPORT,EEC->EEC_EXLOJA,"1",4,EEC->EEC_RESPON)  //fone do contato seq 1
      cEXP_FAX     :=EECCONTATO(CD_SA2,EEC->EEC_EXPORT,EEC->EEC_EXLOJA,"1",7,EEC->EEC_RESPON)  //fax do contato seq 1
   ELSE
      SA2->(dbSeek(xFilial()+EEC->EEC_FORN+EEC->EEC_FOLOJA))
      cEXP_CONTATO :=EECCONTATO(CD_SA2,EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",1,EEC->EEC_RESPON)  //nome do contato seq 1
      cEXP_FONE    :=EECCONTATO(CD_SA2,EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",4,EEC->EEC_RESPON)  //fone do contato seq 1
      cEXP_FAX     :=EECCONTATO(CD_SA2,EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",7,EEC->EEC_RESPON)  //fax do contato seq 1
   ENDIF

   cEXP_CONTATO :=ALLTRIM(cEXP_CONTATO)
   cEXP_FONE    :=ALLTRIM(cEXP_FONE)
   cEXP_FAX     :=ALLTRIM(cEXP_FAX)   
   
   // ** Verifica se já foi impresso o documento, se foi carrega os dados na tela
   SY0->(DBSETORDER(4))
   IF (SY0->(DBSEEK(XFILIAL("SY0")+EEC->EEC_PREEMB+"2"+WorkId->EEA_COD))) .AND.;
      MSGYESNO(STR0004,STR0005) //"Deseja manter os dados da ultima impressão ?"###"Atenção"

      Do While !SY0->(EOF()) .AND. SY0->Y0_FILIAL = XFILIAL("SY0") .and. SY0->Y0_PROCESS = EEC->EEC_PREEMB .AND.;
                SY0->Y0_FASE = "2" .AND. SY0->Y0_CODRPT = WorkId->EEA_COD         
         cSY0Seq:= SY0->Y0_SEQREL
         SY0->(DbSkip())
      EndDo    

      HEADER_H->(DbSetOrder(1))
      If (HEADER_H->(DbSeek("  "+cSY0Seq+EEC->EEC_PREEMB)))
         cContato := IncSpace(HEADER_H->AVG_C10_60,35,.F.)
         cTelCont := HEADER_H->AVG_C11_60
         cData    := HEADER_H->AVG_C12_60
         cTitulo  := HEADER_H->AVG_C05_60
         cDtVencto:= HEADER_H->AVG_C07_60
      EndIf

      DETAIL_H->(DbSetOrder(1))
      If (DETAIL_H->(DbSeek("  "+cSY0Seq)))
         Do While DETAIL_H->(!EOF()) .And. cSY0Seq=DETAIL_H->AVG_SEQREL
            If DETAIL_H->AVG_C02_10 = "BANCO"
               cMemo:=cMemo+DETAIL_H->AVG_C01_60+ENTER
            ElseIf DETAIL_H->AVG_C02_10 = "ANEXOS"
                   AddaCols(DETAIL_H->AVG_C01_60,DETAIL_H->AVG_C01_20,DETAIL_H->AVG_C02_20,"")
            ElseIf DETAIL_H->AVG_C02_10 = "INST"
                   cInst := cInst + ALLTRIM(DETAIL_H->AVG_C01120)+ENTER
            ELSEIF DETAIL_H->AVG_C02_10 = "MEN"
                   cWKTEXTO := cWKTEXTO+ALLTRIM(DETAIL_H->AVG_C01100)+ENTER
            ELSEIF DETAIL_H->AVG_CONT = "_EXPO"
                   cEXPMEMO := cEXPMEMO+ALLTRIM(DETAIL_H->AVG_C01_60)+ENTER
            EndIf

            IF AllTrim(DETAIL_H->AVG_C02_10)="CAMBIO"
               cMemoNroOp+=DETAIL_H->AVG_C01_20+ENTER
               cMemoData +=DETAIL_H->AVG_C01_10+ENTER
               cMemoValor+=DETAIL_H->AVG_C02_20+ENTER
            EndIf

            DETAIL_H->(DbSkip())
         EndDo
      EndIf
   Else
      AddaCols(STR0006,Space(LenCol2),Space(LenCol3),"") //"Conhecimento de Embarque"
      AddaCols(STR0007,Space(LenCol2),Space(LenCol3),"") //"Saque                   "
      AddaCols(STR0008,Space(LenCol2),Space(LenCol3),"") //"Fatura Comercial        "
      AddaCols(STR0009,Space(LenCol2),Space(LenCol3),"") //"Packing List            "
      AddaCols(STR0010,Space(LenCol2),Space(LenCol3),"") //"Weight List             "
      AddaCols(STR0011,Space(LenCol2),Space(LenCol3),"") //"Certificado de Origem   "
      AddaCols(STR0012,Space(LenCol2),Space(LenCol3),"") //"Certificados            "
      AddaCols(STR0013,Space(LenCol2),Space(LenCol3),"") //"Aviso de Embarque       "
      AddaCols(STR0014,Space(LenCol2),Space(LenCol3),"") //"Fax                     "
      AddaCols(STR0015,Space(LenCol2),Space(LenCol3),"") //"Courier                 "
      AddaCols(STR0016,Space(LenCol2),Space(LenCol3),"") //"Certificado Cargo Gear  "
      AddaCols(STR0017,Space(LenCol2),Space(LenCol3),"") //"L/C Original            "

      cCONTATO := PADR(EEC->EEC_RESPON,35," ")
      cTelCont := IncSpace(cEXP_FONE,60,.F.)
      cTitulo  := IncSpace(AllTrim(WorkId->EEA_TITULO),60,.F.)
      SY6->(DBSETORDER(1))
      SY6->(DBSEEK(XFILIAL("SY6")+EEC->(EEC_CONDPA+STR(EEC_DIASPA,3,0))))
      cDTVENCTO := IncSpace(SY6->(MSMM(SY6->Y6_DESC_P,60,1)),40,.f.)  // GFP - 23/11/2012
      cNomBco   := AllTrim(BuscaInst(EEC->EEC_PREEMB,OC_EM,BC_FOR))
      cContBco  := ALLTRIM(EECCONTATO(CD_SA6,EEJ->EEJ_CODIGO,EEJ->EEJ_AGENCI,"1",1))
      SA6->(DBSETORDER(1))
      SA6->(DBSEEK(XFILIAL("SA6")+EEJ->(EEJ_CODIGO+EEJ_AGENCI+EEJ_NUMCON)))
      cEndBco  := ALLTRIM(SA6->A6_END)
      cBaiBco  := ALLTRIM(SA6->A6_BAIRRO)
      cMunBco  := ALLTRIM(SA6->A6_MUN)+If(!Empty(SA6->A6_MUN),", ","")+ALLTRIM(SA6->A6_UNIDFED)+" "+ ALLTRIM(SA6->A6_CEP)    // GFP - 23/11/2012

      cMemo := cNomBco + IF(!EMPTY(cNomBco) ,ENTER,"")
      cMemo := cMemo + cContBco + IF(!EMPTY(cContBco),ENTER,"")
      cMemo := cMemo + cEndBco  + IF(!EMPTY(cEndBco) ,ENTER,"")
      cMemo := cMemo + cBaiBco  + IF(!EMPTY(cBaiBco) ,ENTER,"")
      cMemo := cMemo + cMunBco   

      cData := IncSpace(AllTrim(SA2->A2_MUN)+", "+StrZero(Day(dDataBase),2)+" de "+aMeses[Month(dDataBase)]+" de "+Str(Year(dDataBase),4),60,.f.) 
      
      Cambio(1)    // GFP - 26/11/2012
   EndIf

   IF Empty(a_aCols)
      AddaCols(STR0006,Space(LenCol2),Space(LenCol3),"") //"Conhecimento de Embarque"
      AddaCols(STR0007,Space(LenCol2),Space(LenCol3),"") //"Saque                   "
      AddaCols(STR0008,Space(LenCol2),Space(LenCol3),"") //"Fatura Comercial        "
      AddaCols(STR0009,Space(LenCol2),Space(LenCol3),"") //"Packing List            "
      AddaCols(STR0010,Space(LenCol2),Space(LenCol3),"") //"Weight List             "
      AddaCols(STR0011,Space(LenCol2),Space(LenCol3),"") //"Certificado de Origem   "
      AddaCols(STR0012,Space(LenCol2),Space(LenCol3),"") //"Certificados            "
      AddaCols(STR0013,Space(LenCol2),Space(LenCol3),"") //"Aviso de Embarque       "
      AddaCols(STR0014,Space(LenCol2),Space(LenCol3),"") //"Fax                     "
      AddaCols(STR0015,Space(LenCol2),Space(LenCol3),"") //"Courier                 "
      AddaCols(STR0016,Space(LenCol2),Space(LenCol3),"") //"Certificado Cargo Gear  "
      AddaCols(STR0017,Space(LenCol2),Space(LenCol3),"") //"L/C Original            "
   Endif
   
   // Get dos Memos De Importador e Exportador
   IF !MEMOIMEX(0) .OR. !TelaGets(cWKTEXTO)
      Break
   Endif

   lRet    := .t.
   cSEQREL := GetSXENum("SY0","Y0_SEQREL")
   CONFIRMSX8()

   // ** Adicionar registro no HEADER_P.
   HEADER_P->(DBAPPEND())
   HEADER_P->AVG_FILIAL:=xFilial("SY0")
   HEADER_P->AVG_SEQREL:=cSEQREL
   HEADER_P->AVG_CHAVE :=EEC->EEC_PREEMB //nr. do processo

   // Dados do Exportador/Fornecedor (Sub-Relatório).
   FOR Z := 1 TO MLCOUNT(cEXPMEMO,60)
      APPENDDET("_EXPO")
      DETAIL_P->AVG_CONT   := "_EXPO"
      DETAIL_P->AVG_C01_60 := MEMOLINE(cEXPMEMO,60,Z)
   NEXT

   // ** Título do Documento.
   HEADER_P->AVG_C05_60:=Alltrim(cTitulo)

   // ** Banco Recebedor de Doctos.
   BancoDoc() 
   HEADER_P->AVG_C06_60:=Alltrim(BuscaInst(EEC->EEC_PREEMB,OC_EM,BC_DBR))

   // ** Copia.
   If lCopia
      HEADER_P->AVG_C09_10:="COPIA"
   EndIf

   // ** Verifica o tipo de Mod. de Pagto para imprimir a mensagem.
   If ! Empty(EEC->EEC_LC_NUM)   // Carta de Crédito.
      HEADER_P->AVG_C01_30 := Alltrim(EEC->EEC_LC_NUM)
   ElseIf EEC->EEC_MPGEXP = "005" // Pagamento Antecipado.
      HEADER_P->AVG_C01_30 := "1"
   ElseIf EEC->EEC_MPGEXP = "003" // Cobranca.
      HEADER_P->AVG_C01_30 := "3"
   ELSE
      HEADER_P->AVG_C01_30 := "BRANCO"
   EndIf

   // ** Banco da Carta de Crédito.
   If !Empty(cMemo)
      For i:=1 To MlCount(cMemo)
         AppendDet()
         DETAIL_P->AVG_C02_10:="BANCO" // Link Subreport.
         HEADER_P->AVG_C02_10:="BANCO" // Link Subreport.         
         DETAIL_P->AVG_C01_60:=Alltrim(Memoline(cMemo,60,i))
      Next i
   EndIf

   // ** Gravação dos itens (Details).
   GravaItens()

   HEADER_P->AVG_C04_10 := EEC->EEC_MOEDA
   HEADER_P->AVG_C01_20 := Alltrim(Transform(EEC->EEC_TOTPED,AVSX3("EEC_TOTPED",AV_PICTURE)))
   HEADER_P->AVG_C07_60 := cDtVencto

   // ** Cambio
   Cambio()

   // ** Sub-Agentes.
   aAGENT := {}
   EEB->(DBSETORDER(1))
   EEB->(DBSEEK(XFILIAL("EEB")+AVKEY(EEC->EEC_PREEMB,"EEB_PEDIDO")))
   DO WHILE ! EEB->(EOF()) .AND.;
      EEB->(EEB_FILIAL+EEB_PEDIDO) = (XFILIAL("EEB")+AVKEY(EEC->EEC_PREEMB,"EEB_PEDIDO"))

      IF LEFT(EEB->EEB_TIPOAG,1) = "3"  // Recebedor de Comissao
         APPENDDET()
         DETAIL_P->AVG_CONT := "_AGENT"
         DETAIL_P->AVG_C01_60 := EEB->EEB_NOME

         // ** Tipo de Comissão.
         If EEC->EEC_TIPCOM = "1"
            DETAIL_P->AVG_C02_20 := STR0018  //"A Remeter"
         ElseIf EEC->EEC_TIPCOM = "2"
                DETAIL_P->AVG_C02_20 := STR0019 //"Conta Grafica"
         ElseIf EEC->EEC_TIPCOM = "3"
                DETAIL_P->AVG_C02_20 := STR0020 //"Deduzir da Fatura"
         EndIf

         IF EEB->EEB_TIPCVL == "1" .OR. EEB->EEB_TIPCVL == "3" //EEC->EEC_TIPCVL == "1" .OR. EEC->EEC_TIPCVL == "3"     // GFP - 23/11/2012
            nFOB := (EEC->EEC_TOTPED+EEC->EEC_DESCON)-(EEC->EEC_FRPREV+EEC->EEC_FRPCOM+EEC->EEC_SEGPRE+EEC->EEC_DESPIN+AvGetCpo("EEC->EEC_DESP1")+AvGetCpo("EEC->EEC_DESP2"))
            DETAIL_P->AVG_C01_20 := ALLTRIM(TRANSFORM((/*EEB->EEB_TXCOMI*/EEB->EEB_VALCOM/100)*nFob,"@E 999,999,999.99"))  // GFP - 23/11/2012
         ELSE
            DETAIL_P->AVG_C01_20 := ALLTRIM(TRANSFORM(/*EEB->EEB_TXCOMI*/EEB->EEB_TOTCOM,"@E 999,999,999.99"))  // GFP - 23/11/2012
         ENDIF

         // ** Busca o restante dos dados do cliente.
         If (SY5->(DBSEEK(XFILIAL("SY5")+EEB->EEB_CODAGE)))
            SYA->(DBSETORDER(1))
            SYA->(DBSEEK(XFILIAL("SYA")+SY5->Y5_PAIS))
            wV := SY5->({Y5_END,Y5_CIDADE,SYA->YA_DESCR,Y5_FONE,Y5_FAX})
            // ** Monta o endereço do banco do agente.
            c01100 := ALLTRIM(WV[1])
            c01100 := c01100+IF(EMPTY(c01100),ALLTRIM(WV[2]),;
                                              IF(EMPTY(ALLTRIM(WV[2])),"",;
                                                                       " - "+ALLTRIM(WV[2])))
            c01100 := c01100+IF(EMPTY(c01100),ALLTRIM(WV[3]),;
                                              IF(EMPTY(ALLTRIM(WV[3])),"",;
                                                                       " - "+ALLTRIM(WV[3])))
            c01100 := c01100+IF(EMPTY(c01100),ALLTRIM(WV[4]),;
                                              IF(EMPTY(ALLTRIM(WV[4])),"",;
                                                                       " - TEL.: "+ALLTRIM(WV[4])))
            c01100 := c01100+IF(EMPTY(c01100),ALLTRIM(WV[5]),;
                                              IF(EMPTY(ALLTRIM(WV[5])),"",;
                                                                       " - FAX.: "+ALLTRIM(WV[5])))
            FOR Z := 1 TO MLCOUNT(c01100,60)
                APPENDDET()
                DETAIL_P->AVG_CONT   := "_AGENT"
                DETAIL_P->AVG_C01_60 := MEMOLINE(c01100,60,Z)
            NEXT
         ENDIF
      ENDIF
      EEB->(DBSKIP())
   ENDDO

   Anexos()

   // ** Mensagem.
   WKMSG->(DbGoTop())   
   Do While WKMSG->(!Eof())
      If !Empty(WKMSG->WKMARCA)
         HEADER_P->AVG_C07_10:="MEN" // ** Link o Subreport.
         nLinhas:=MlCount(WKMSG->WKTEXTO,60)
         For n:=1 To nLinhas
            If !Empty(MemoLine(WKMSG->WKTEXTO,60,n))
              AppendDet()   
              DETAIL_P->AVG_C02_10:="MEN" 
              DETAIL_P->AVG_C01100:= MemoLine(WKMSG->WKTEXTO,TAMMSG,n)
            EndIf
         Next n
      EndIf
      WKMSG->(DbSkip())
   EndDo 

   // ** Instruções Epeciais.
   If !Empty(cInst)
      For i:=1 To MlCount(cInst,105)
         If !Empty(Memoline(cInst,105,i))
            AppendDet()
            DETAIL_P->AVG_C02_10 := "INST" // ** Link o Subreport.
            HEADER_P->AVG_C08_10 := "INST" // ** Link o Subreport.
            DETAIL_P->AVG_C01120 := Alltrim(Memoline(cInst,105,i))
         EndIf
      Next i
   EndIf
   
   // ** Contato.
   HEADER_P->AVG_C10_60 := Alltrim(cContato)
   HEADER_P->AVG_C11_60 := Alltrim(cTelCont)    
   HEADER_P->AVG_C12_60 := Alltrim(cData)
   
   // ** Gravar dados no histórico.
   HEADER_H->(dbAppend())
   AvReplace("HEADER_P","HEADER_H")
   DETAIL_P->(dbSetOrder(0))      
   DETAIL_P->(DbGoTop())
   Do While ! DETAIL_P->(Eof())
      DETAIL_H->(DbAppend())
      AvReplace("DETAIL_P","DETAIL_H")
      DETAIL_P->(DbSkip())
   EndDo
   DETAIL_P->(dbSetOrder(1))      

End Sequence
IF Select("Work_msg") > 0
   Work_msg->(E_EraseArq(cFileMen))
Endif
IF SELECT("WKMSG") > 0
   OBSERVACOES("END")
ENDIF

Select(nAlias)

Return(lRet)

/*
Funcao     : GravaItens.
Parametros : Nenhum.
Retorno    : .t./.f.
Objetivos  : Gravar itens (Detail).
Autor      : Jeferson Barros Jr.
Data/Hora  : 13/12/2003 - 11:50.
Revisao    :
Obs.       :
*/
*--------------------------*
Static Function GravaItens() 
*--------------------------*
Local cRe:="",lRet:=.T.,cDtRE
Local aReg := {}, nPosReg, i,nPosSD:=0

Begin Sequence
   EE9->(DbSeek(xFilial("EE9")+EEC->EEC_PREEMB))
   
   While EE9->(!Eof() .And. EE9_FILIAL == xFilial("EE9")) .And. EE9->EE9_PREEMB == EEC->EEC_PREEMB

      nPosReg := aScan(aReg,{|x| Left(x[1],9) == Left(EE9->EE9_RE,9)})
      nPosSD  := aScan( aReg, { |x| x[3] == EE9->EE9_NRSD } )

      IF nPosReg == 0 
         aAdd( aReg,{ EE9->EE9_RE, EE9->EE9_DTRE, EE9->EE9_NRSD } )
      Else
         IF !Empty(EE9->EE9_NRSD)
            aReg[nPosReg][3] := EE9->EE9_NRSD
         Endif
         If Val( Right( EE9->EE9_RE, 3 ) ) > Val( Right( aReg[nPosReg][1], 3 ) )
            aReg[nPosReg][1] := EE9->EE9_RE
         EndIf
      Endif      

      EE9->( dbSkip() )
   EndDo

   IF Empty(aReg)
      aAdd(aReg,{"",AvCtod(""),""})
   Endif

   For i:=1 To Len(aReg)   
      AppendDet()
      IF i == 1
         HEADER_P->AVG_C03_10:="RE" // ** Link Subreport   
      Endif
      DETAIL_P->AVG_C02_10:="RE" // ** Link Subreport
      
      IF !Empty(aReg[i,1])
         DETAIL_P->AVG_C01_20:=Alltrim(Transform(aReg[i,1],AVSX3("EE9_RE",AV_PICTURE)))
         IF !Empty(aReg[i,2]) // ** Data da Re(99/99/9999)
            DETAIL_P->AVG_C01_10:=StrZero(Day(aReg[i,2]),2)+"/"+StrZero(Month(aReg[i,2]),2)+"/"+StrZero(Year(aReg[i,2]),4)
         Endif
      Endif

      DETAIL_P->AVG_C02_20 := Alltrim(aReg[i,3])     // ** Numero da SD.
      DETAIL_P->AVG_C03_20:=Alltrim(EEC->EEC_PEDREF) // ** Numero de referencia.
   Next i
End Sequence

Return lRet

/*
Funcao     : Cambio.
Parametros : Nenhum.
Retorno    : .t.
Objetivos  : Gravar Informações das parcelas do processo de embarque.
Autor      : Jeferson Barros Jr.
Data/Hora  : 13/12/2003 - 11:50.
Revisao    : Guilherme Fernandes Pilan - GFP
Data/Hora  : 26/11/2012
Obs.       : Ajuste para que as parcelas de cambio sejam carregadas corretamente na tela antes do relatorio.
*/
*-----------------------*
Static Function Cambio(nI)
*-----------------------*
Local lRet :=.t.,nLinhas:=0, nx:=0
Local aOrd := SaveOrd("EEQ")
Default nI := 2

Begin Sequence

If nI == 1
   
   EEQ->(DbSeek(xFilial("EEQ")+AvKey(EEC->EEC_PREEMB,"EEQ_PREEMB")))
   
   Do While EEQ->(!Eof()) .AND. EEQ->EEQ_FILIAL == xFilial("EEQ") .AND. EEQ->EEQ_PREEMB == EEC->EEC_PREEMB
      cMemoNroOp += EEQ->EEQ_NROP + ENTER
      cMemoValor += AllTrim(TRANSFORM(EEQ->EEQ_VL,"@E 999,999,999.99")) + ENTER
      cMemoData  += DtoC(EEQ->EEQ_VCT) + ENTER
      EEQ->(DbSkip())
   EndDo

Else

   HEADER_P->AVG_C05_10:="CAMBIO" // ** Link Subreport     
   
   nLinhas:=Max(MlCount(cMemoValor,20),MlCount(cMemoNroOp,20))
   
   For nX:=1 To nLinhas
      
      AppendDet()
      DETAIL_P->AVG_C02_10:="CAMBIO" // ** Link Subreport

      // ** Grava o nro do contrato da parcela
      If !Empty(Memoline(cMemoNroOp,20,nX))
         DETAIL_P->AVG_C01_20:=AllTrim(Memoline(cMemoNroOp,20,nX))
      EndIf
  
      If !Empty(Memoline(cMemoData,20,nX))
         DETAIL_P->AVG_C01_10:=AllTrim(Memoline(cMemoData,20,nX))
      EndIf

      If !Empty(Memoline(cMemoValor,20,nX))
         DETAIL_P->AVG_C02_20:=AllTrim(Memoline(cMemoValor,20,nX))
      EndIf
   Next

EndIf
   
End Sequence

RestOrd(aOrd,.T.)
Return lRet

/*
Funcao     : Anexos.
Parametros : Nenhum.
Retorno    : .t.
Objetivos  : Gravar Informações dos Documentos em Anexo a Carta Remessa de Documentos.
Autor      : Jeferson Barros Jr.
Data/Hora  : 13/12/2003 - 11:50.
Revisao    :
Obs.       :
*/
*----------------------*
Static Function Anexos()
*----------------------*
Local lRet :=.T., x:=0
Begin Sequence
   HEADER_P->AVG_C06_10:="ANEXOS" // Link o Subreport       
   For x:=1 To Len(a_aCols)
      If !a_Acols[x,5] // Deleted?
         If !Empty(a_Acols[x,2]) .Or. !Empty(a_Acols[x,3])
            AppendDet()
            DETAIL_P->AVG_C02_10:="ANEXOS" // Link Subreport
            DETAIL_P->AVG_C01_60:=a_Acols[x,1]
            DETAIL_P->AVG_C01_20:=If(!Empty(a_Acols[x,2]),a_Acols[x,2],"0")
            DETAIL_P->AVG_C02_20:=If(!Empty(a_Acols[x,3]),a_Acols[x,3],"0")
         EndIf
      EndIf
   Next x
End Sequence
Return lRet

/*
Funcao      : TelaGets.
Parametros  : cWKTEXTO.
Retorno     : .t./.f.
Objetivos   : Tela para set dos parâmetros para impressão da Carta Remessa de Documentos.
Autor       : Jeferson Barros Jr.
Data/Hora   : 13/12/2003 - 11:50.
Revisao     :
Obs.        :
*/
*--------------------------------*
Static Function TelaGets(cWKTEXTO)
*--------------------------------*
Local lRet := .f.,nOpc:=0, nPos := 1,aPos
Local oFld,aFld,oFldF, oYes,oNo, oDlg
Local bSet  := {|x,o| lCopia := x, o:Refresh(), lCopia},;
      bHide := {|n| if(n==nil,n:=0,), IF(N<>2,oGetDb:oBrowse:Hide(),), if(n<>3,oMark2:oBrowse:Hide(),) },;
      bShow := {|nTela| Show(nTela),oGetDB:oBrowse:Refresh() },;
      bOk     := {|| nOpc:=1,oDlg:End() },;
      bCancel := {|| nOpc:=0,oDlg:End() }

Local xx := "", yy := ""

Private aMarcados[2], nMarcado := 0

Begin Sequence

   DEFINE MSDIALOG oDlg TITLE AllTrim(WorkId->EEA_TITULO) FROM 200,1 TO 620,600 PIXEL OF oMainWnd
      oFld := TFolder():New(13,1,{STR0021,STR0022,STR0023,STR0024,STR0025},; //"&Dados Gerais"###"&Anexos"###"&Mensagem"###"&Instruções Especiais"###"&Cambio"
                                 {"DAD","ANE","MSG","INS","PAR"},oDLG,,,,.T.,.F.,300,197)//300,160
      aFld := oFld:aDialogs
      aEval(aFld,{|o| o:SetFont(oDlg:oFont) })
      
      // ** Folder Dados Gerais.
      oFldF := aFld[1]
      @ 006,005 TO 030,293  LABEL STR0026 OF oFLDF PIXEL //"Título"
      @ 014,010 SAY STR0027 OF oFldF FONT oDlg:oFont PIXEL //"Documento"
      @ 014,040 GET cTitulo OF oFLDF SIZE 160,06 PIXEL

      @ 032,005 TO 068,293  LABEL STR0028 OF oFLDF PIXEL //"Contato"

      @ 040,010 SAY STR0029 OF oFldF FONT oDlg:oFont PIXEL //"Nome"
      @ 040,040 MSGET cContato  OF oFLDF SIZE 130,06 F3 "E33" VALID LoadContact() PIXEL
      @ 051,010 SAY STR0030 OF oFldF FONT oDlg:oFont PIXEL //"Telefone"
      @ 051,040 GET cTelCont  OF oFLDF SIZE 130,06 PIXEL

      @ 070,005 TO 105,293  LABEL STR0031 OF oFLDF PIXEL //"Outros Dados"

      @ 078,010 SAY STR0032 OF oFldF FONT oDlg:oFont PIXEL //"Cond.Pagto."
      @ 078,040 GET cDtVencto OF oFLDF SIZE 100,06 PIXEL
      @ 078,140 SAY STR0033 OF oFldF FONT oDlg:oFont PIXEL //"Data"
      @ 078,160 GET cData  OF oFLDF SIZE 130,06 PIXEL
      @ 090,010 SAY STR0034 OF oFldF FONT oDlg:oFont PIXEL //"Imprime Copia"
      oYes := TCheckBox():New(090,050,STR0035,{|x| If(PCount()==0, lCopia,Eval(bSet, x,oNo ))},oFLDF,21,10,,,,,,,,.T.) //"Sim" //"Sim"
      oNo  := TCheckBox():New(090,070,STR0036,{|x| If(PCount()==0,!lCopia,Eval(bSet,!x,oYes))},oFLDF,21,10,,,,,,,,.T.) //"Não" //"Não"
     
      @ 108,005 TO 180,293  LABEL STR0037 OF oFLDF PIXEL //"Banco de Cobrança"
      @ 116,010 GET cMEMO SIZE 278,58 PIXEL OF oFLDF HSCROLL

      // ** Folder Anexos.
      oFLDF:=aFLD[2]
      @ 10004,043 GET yy OF oFldF
      aHeader := a_aHeader
      aCols   := a_aCols
      n       := a_n
      oGetDb  := IW_MultiLine(25,3,209,300,.T.,.T.)
   
      // ** Folder Mensagens.
      oMark2 := Observacoes(STR0038,cMarca,cWKTEXTO) //"New"
      @ 10004,043 GET xx OF oFld:aDialogs[3]
      aHeader := m_aHeader
      aCols   := m_aCols
      n       := m_n
      AddColMark(oMark2,"WKMARCA")

      // ** Folder Instruções de Embarque.
      oFLDF := aFLD[4]
      @ 05,05 GET cInst SIZE 288,174 PIXEL OF oFLDF HSCROLL

      // ** Folder Parcelas.
      oFLDF := aFLD[5]

      @ 05,05 TO 180,295  LABEL STR0039 OF oFLDF PIXEL //"Dados das Parcelas"
      
      @ 15,015 SAY STR0040 OF oFldF PIXEL //"Nro. Contrato/Operação"
      @ 25,015 GET cMemoNroOp MEMO SIZE 88,150 OF oFLDF PIXEL HSCROLL 
      
      @ 15,105 SAY STR0033 OF oFldF  PIXEL  //"Data"
      @ 25,105 GET cMemoData  MEMO SIZE  88,150 OF oFLDF PIXEL HSCROLL 
      
      cMemoValor := IF(EMPTY(cMEMOVALOR),AllTrim(TRANSFORM(EEC->EEC_TOTPED,"@E 999,999,999.99")),cMEMOVALOR)
      
      @ 15,195 SAY STR0041 OF oFldF  PIXEL //"Valor"
      @ 25,195 GET cMemoValor MEMO SIZE  88,150 OF oFLDF PIXEL HSCROLL 

      Eval(bHide)

      oFld:bChange := {|nOption,nOldOption| Eval(bHide,nOption), Eval(bShow,nOption)}

   ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,bOk,bCancel)

   If nOpc ==1
      lRet := .t.
   EndIf

End Sequence

Return lRet 

/*
Funcao      : BancoDoc.
Parametros  : Nenhum.
Retorno     : Nil.
Objetivos   : Retornar Banco Documentos.
Autor       : Jeferson Barros Jr.
Data/Hora   : 13/12/2003 - 13:27.
Revisao     :
Obs.        :
*/
*-----------------------*
Static Function BancoDoc
*-----------------------*
Local cBanco

Begin Sequence

   cTO_NOME := ""
   cTO_ATTN := ""
   cTO_FAX  := ""

   cBanco   := Posicione("SA2",1,xFilial("SA2")+EEC->EEC_FORN+EEC->EEC_FOLOJA,"A2_BANCO")
   cTO_NOME := Posicione("SA6",1,xFilial("SA6")+cBanco,"A6_NOME")
   cTO_ATTN := EECCONTATO(CD_SA6,cBANCO,,"1",1) // Nome do contato seq 1
   cTO_FAX  := EECCONTATO(CD_SA6,cBANCO,,"1",7) // Fax do contato seq 1
   
End Sequence

Return NIL

/*
Funcao      : LoadContact
Parametros  : Nenhum
Retorno     : .t.
Objetivos   : Carrega os dados do Contato
Autor       : Jeferson Barros Jr.
Data/Hora   : 13/12/2003 - 13:29
Revisao     : 
Obs.        :
*/
*--------------------------*
Static Function LoadContact
*--------------------------*
Local lRet:=.t., aOrd:=SaveOrd({"EE3"})

Begin Sequence
   EE3->(DbSetOrder(2))
   EE3->(DbSeek(xFilial("EE3")+cContato))

   cTelCont := EE3->EE3_FONE
  
End Sequence

RestOrd(aOrd)

Return lRet

/*
Funcao      : Show(nTela)
Parametros  : nTela 
Retorno     : .t.
Objetivos   : Tratamentos para objetos de tela.
Autor       : Jeferson Barros Jr
Data/Hora   : 13/12/2003.
Revisao     :
Obs.        :
*/
*--------------------------*
Static Function Show(nTela)
*--------------------------*
Local lRet:=.t., obj

Begin Sequence  
   If nTela == 2
      aHeader := a_aHeader
      aCOls   := a_aCols
      n       := a_n
      obj     := oGetDb:oBrowse
   Elseif nTela == 3
      aHeader := m_aHeader
      aCOls   := m_aCols
      n       := m_n
      obj     := oMark2:oBrowse  
      dbSelectArea("WkMsg")
   EndIf  
   
   If obj <> NIL   
      obj:Show()
      obj:SetFocus()
   Endif
   
End Sequence
Return lRet

/*
Funcao      : AddaCols
Parametros  : (cDoc,cOri,cCopy,cAd) Itens do aCols.
Retorno     : Nil
Objetivos   : Adiciona registros no Acols
Autor       : Jeferson Barros Jr.
Data/Hora   : 13/12/2003 - 13:32
Revisao     :
Obs.        : 
*/
*-------------------------------------------*
Static Function AddaCols(cDoc,cOri,cCopy,cAd)
*-------------------------------------------*
Begin Sequence

   aAdd(a_aCols,Array(5))
   a_aCols[Len(a_aCols)][05] := .f. // Deleted
   a_aCols[Len(a_aCols)][01] := cDoc
   a_aCols[Len(a_aCols)][02] := cOri
   a_aCols[Len(a_aCols)][03] := cCopy
   a_aCols[Len(a_aCols)][04] := cAd

End Sequence

Return NIL

/*
Funcao      : AppendDet
Parametros  : Nenhum.
Retorno     : Nil
Objetivos   : Adiciona registros no arquivo de detalhes
Autor       : Jeferson Barros Jr
Data/Hora   : 13/12/2003 - 13:33.
Revisao     : 
Obs.        :
*/
*-------------------------*
Static Function AppendDet()
*-------------------------*
Begin Sequence
   DETAIL_P->(dbAppend())
   DETAIL_P->AVG_FILIAL := xFilial("SY0")
   DETAIL_P->AVG_SEQREL := cSEQREL
   DETAIL_P->AVG_CHAVE  := EEC->EEC_PREEMB //nr. do processo
End Sequence

Return NIL

/*
Funcao      : Observacoes
Parametros  : cAcao := New/End
Retorno     : nil
Objetivos   : Manutenção de Mensagens.
Autor       : 
Data/Hora   : 
Revisao     : Jeferson Barros JR
Data/Hora   : 13/12/2003 - 13:34
Obs.        :
*/
*-------------------------------------------------*
Static Function Observacoes(cAcao,cMarca,cWKTEXTO)
*-------------------------------------------------*
Local xRet := nil
Local cPaisEt := Posicione("SA1",1,xFilial("SA1")+EEC->EEC_IMPORT+EEC->EEC_IMLOJA,"A1_PAIS")
Local nAreaOld, aOrd, aSemSx3
Local cTipMen, cIdioma, cTexto, i
Local oMark
Local lInverte := .F.

Static aOld

Begin Sequence
   cAcao := Upper(AllTrim(cAcao))

   IF cAcao == "NEW"
      Private aHeader := {}, aCAMPOS := array(EE4->(fcount()))
      aSemSX3 := { {"WKMARCA","C",02,0},{"WKTEXTO","M",10,0}}
      aOrd    := SaveOrd("EE4")
      aOld := {Select(), E_CriaTrab("EE4",aSemSX3,"WkMsg")}

      // ** Carregando as Mensagens que foram impressas no ultimo documento.
      IF ! EMPTY(cWKTEXTO)
         WKMSG->(DBAPPEND())
         WKMSG->WKMARCA    := cMARCA
         WKMSG->EE4_TIPMEN := "REIMPRESSAO"
         WKMSG->WKTEXTO    := cWKTEXTO
      ENDIF

      // Busca as mensagens padroes do sistema.
      EE4->(dbSetOrder(2))
      EE4->(dbSeek(xFilial()+"PORT. -PORTUGUES"))
      DO While !EE4->(Eof()) .And. EE4->EE4_FILIAL == xFilial("EE4") .And. EE4->EE4_IDIOMA = "PORT. -PORTUGUES    "
         If Left(EE4->EE4_TIPMEN,1) = "5"
            WkMsg->(dbAppend())         
            cTexto := MSMM(EE4->EE4_TEXTO,AVSX3("EE4_VM_TEX",AV_TAMANHO))         
            For i:=1 To MlCount(cTexto,AVSX3("EE4_VM_TEX",AV_TAMANHO))
                WkMsg->WKTEXTO := WkMsg->WKTEXTO+MemoLine(cTexto,AVSX3("EE4_VM_TEX",AV_TAMANHO),i)+ENTER
            Next              
            WkMsg->EE4_TIPMEN := EE4->EE4_TIPMEN
            WkMsg->EE4_COD    := EE4->EE4_COD
         EndIf         
         EE4->(DbSkip())
      EndDo
      
      DbSelectArea("WkMsg")
      WkMsg->(dbGoTop())
      aCampos     := {{"WKMARCA",," "},;
                      ColBrw("EE4_COD","WkMsg"),;
                      ColBrw("EE4_TIPMEN","WkMsg"),;
                      {{|| MemoLine(WkMsg->WKTEXTO,AVSX3("EE4_VM_TEX",AV_TAMANHO),1)},"",AVSX3("EE4_VM_TEX",AV_TITULO)}}
      
      //GFP 25/10/2010
      aCampos := AddCpoUser(aCampos,"EE4","2")
      
      oMark       := MsSelect():New("WkMsg","WKMARCA",,aCampos,lInverte,@cMarca,{25,3,209,300})
      oMark:bAval := {|| EditObs(cMarca), oMark:oBrowse:Refresh() }      
      xRet        := oMark                                                
      RestOrd(aOrd)

   Elseif cAcao == "END"
          IF Select("WkMsg") > 0
             WkMsg->(E_EraseArq(aOld[2]))
          Endif
          Select(aOld[1])
   Endif
End Sequence
Return(xRet)

/*
Funcao      : EditObs
Parametros  : cMarca
Retorno     : Nil
Objetivos   : Manutenção de Observações.
Autor       : 
Data/Hora   : 
Revisao     : Jeferson Barros Jr
              13/12/2003 - 13:35.
Obs.        :
*/
*-----------------------------*
Static Function EditObs(cMarca)
*-----------------------------*
Local nOpc, cMemo, oDlg
Local bOk     := {|| nOpc:=1, oDlg:End()}
Local bCancel := {|| oDlg:End()}

Local nRec

IF WkMsg->(!Eof())
   IF Empty(WkMsg->WKMARCA)
      nOpc:=0
      cMemo := WkMsg->WKTEXTO

      DEFINE MSDIALOG oDlg TITLE WorkId->EEA_TITULO FROM 7,0.5 TO 26,79.5 OF oMainWnd
      
         @ 05,05 SAY STR0042 PIXEL  //"Tipo Mensagem"
         @ 05,45 GET WkMsg->EE4_TIPMEN WHEN .F. PIXEL
         @ 20,05 GET cMemo MEMO SIZE 300,105 OF oDlg PIXEL HSCROLL 

         DEFINE SBUTTON oBtnOk     FROM 130,246 TYPE 1 ACTION Eval(bOk) ENABLE OF oDlg
         DEFINE SBUTTON oBtnCancel FROM 130,278 TYPE 2 ACTION Eval(bCancel) ENABLE OF oDlg

      ACTIVATE MSDIALOG oDlg CENTERED 

      IF nOpc == 1
         IF !Empty(nMarcado)
            nRec := WkMsg->(RecNo())
            WkMsg->(dbGoTo(nMarcado))
            WkMsg->WKMARCA := Space(2)
            WkMsg->(dbGoTo(nRec))
         Endif
         cObs := cObs + CMemo
         WkMsg->WKTEXTO := cMemo
         WkMsg->WKMARCA := cMarca
         nMarcado := nRec
      Endif
   Else
      cObs := ""
      WkMsg->WKMARCA := Space(2)
      nMarcado := 0
   Endif
Endif
     
Return NIL

/*
Funcao      : MEMOIMEX
Parametros  : nP_LINHA    -> NUMERO DE LINHAS QUE SERA IMPRESSO NO DOCUMENTO.
                             SE 0, É INFINITO
              nP_LINIMP   -> NUMERO DE LINHAS DISPONIVEIS P/ IMPRESSAO. SE NAO FOR PASSADO
                             SERA ASSUMIDO O nP_LINHA
Retorno     : 
Objetivos   : 
Autor       : 
Data/Hora   : 
Revisao     : Jeferson Barros Jr
              13/12/2003 - 14:06.
Obs.        :
*/
*------------------------------------------*
Static Function MEMOIMEX(nP_LINHA,nP_LINIMP)
*------------------------------------------*
Local lRET,bOK,bCANCEL,oDLG,oFLD,aDLG,aBUTTONS,Z,nLI

PRIVATE cCAMPO

Begin Sequence
 
   nP_LINHA    := IF(nP_LINHA   =NIL,0       ,nP_LINHA)
   nP_LINIMP   := IF(nP_LINIMP  =NIL,nP_LINHA,nP_LINIMP)
   lRET        := .F.
   nLI         := 3
   aBUTTONS    := {}
   bOK         := {|| lRET := .T.,oDLG:END()}
   bCANCEL     := {|| lRET := .F.,oDLG:END()}

   IF EMPTY(cIMPMEMO)
      // CARREGA AS LINHAS DO IMPORTADOR
      FOR Z := 1 TO 10
         If Z = 1
            cCAMPO := "EEC->EEC_IMPODE"
         ElseIf Z = 2
            cCAMPO := "EEC->EEC_ENDIMP"
         ElseIf Z = 3
            cCAMPO := "EEC->EEC_END2IM"
         EndIf

         IF ! EMPTY(&cCAMPO)                    
            cIMPMEMO := cIMPMEMO+ALLTRIM(&cCAMPO)+ENTER
         ENDIF
      NEXT
   ENDIF
   
   IF EMPTY(cEXPMEMO)   // GFP - 23/11/2012 - Inclusão do endereço
      cEXPMEMO := POSICIONE("SA2",1,XFILIAL("SA2")+EEC->EEC_FORN+EEC->EEC_FOLOJA,"A2_NOME")+ENTER
      cEXPMEMO := cEXPMEMO+ALLTRIM(If(!Empty(cEXP_FONE),STR0043,"")+AllTrim(cEXP_FONE))+If(!Empty(cEXP_FAX),STR0044+AllTrim(cEXP_FAX),"")+ENTER //"TEL.: "###" FAX: "
      cEXPMEMO := cEXPMEMO+AllTrim(SA2->A2_END)+" - "+AllTrim(SA2->A2_BAIRRO)+" - "+AllTrim(SA2->A2_MUN)+" - "+;
                           AllTrim(SA2->A2_CEP)+" - "+AllTrim(SA2->A2_EST)   +" - "+AllTrim(Posicione("SYA",1,xFilial("SYA")+SA2->A2_PAIS,"YA_DESCR"))
   ENDIF

   DEFINE MSDIALOG oDlg TITLE ALLTRIM(WORKID->EEA_TITULO) FROM 0,0 TO 240,357 OF oMainWnd PIXEL
      @ 21,04 GET cEXPMEMO MEMO SIZE 170,80 OF oDLG PIXEL HSCROLL
   ACTIVATE MSDIALOG oDLG CENTERED ON INIT ENCHOICEBAR(oDLG,bOK,bCANCEL,,aBUTTONS)
   
End Sequence

Return(lRet)
*-----------------------------------------------------------------------------------------------------------------*
* FIM DO PROGRAMA EECPEM56_RDM                                                                                    *
*-----------------------------------------------------------------------------------------------------------------*
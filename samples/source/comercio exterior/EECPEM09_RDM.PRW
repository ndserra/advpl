#INCLUDE "EECPEM09.ch"

/*
Programa        : EECPEM09.PRW
Objetivo        : Impressao de Remessa Documentos REM00001.RPT
Autor           : Heder M Oliveira
Data/Hora       : 27/09/99
Revisao         : Jeferson Barros Jr.
Data/Hora       : 05/12/03 - 15:00.
Obs.            : 
*/                

/*
considera que estah posicionado no registro de processos (embarque) (EEC)
*/

#include "EECRDM.CH"

/*
Funcao      : EECPEM09
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : Heder M Oliveira
Data/Hora   : 28/09/99 09:37
Revisao     :
Obs.        :
*/
User Function EECPEM09

Local lRet := .f.
Local nAlias := Select()

Local cEXP_NOME,cEXP_CONTATO,cEXP_FONE,cEXP_FAX

Local aOrd:=SaveOrd({"EEQ","SY5", "SY0"}), w:=0, z:=0

Private cTO_NOME,cTO_ATTN,cTO_FAX

Private lCHECK_1,cCHECK_1,lCHECK_2,cCHECK_2,lCHECK_3,cCHECK_3
Private lCHECK_4,cCHECK_4,lCHECK_5,cCHECK_5,lCHECK_6,cCHECK_6
Private lCHECK_7,cCHECK_7,lCHECK_8,cCHECK_8,lCHECK_9
Private cCHECK_9,lCHECK10,cCHECK10,lCHECK31,cCHECK31

Private lCHECK11,cCHECK11,lCHECK12,cCHECK12,lCHECK13,cCHECK13
Private lCHECK14,cCHECK14,lCHECK15,cCHECK15
Private lCHECK16,cCHECK16,cCHECK16O,cCHECK16C,lCHECK17,cCHECK17 
Private cCHECK17O,cCHECK17C,lCHECK18,cCHECK18,cCHECK18O,cCHECK18C
Private lCHECK19,cCHECK19,cCHECK19O,cCHECK19C,lCHECK20,cCHECK20 
Private cCHECK20O,cCHECK20C,lCHECK21,cCHECK21,cCHECK21O,cCHECK21C
Private lCHECK22,cCHECK22,cCHECK22O,cCHECK22C,lCHECK23,cCHECK23 
Private cCHECK23O,cCHECK23C,lCHECK24,cCHECK24,cCHECK24O,cCHECK24C
Private cCHECKG24,lCHECK25,cCHECK25,cCHECK25O,cCHECK25C,cCHECKG25
Private lCHECK26,cCHECK26,cCHECK26O,cCHECK26C,lCHECK27,cCHECK27 
Private cCHECKG27,cCHECK27O,cCHECK27C,lCHECK28,cCHECK28O,cCHECK28C
Private cCHECK28,cCHECKG28,lCHECK29,cCHECK29,cCHECKG29,cCHECK29O
Private cCHECK29C,lCHECK30,cCHECK30,cCHECK301

Private mDet := "", mDetAux := "", mDetalhe := ""

Private aDocumentos:={}  // Array com as informações dos documentos a serem anexados a carta remessa.
/*
aDocumentos por dimensão:
   aDocumentos[i][1] -> Descrição do documento.
              [i][2] -> Quantidade de originais.
              [i][3] -> Quantidade de cópias.
              [i][4] -> Deletado. (.t./.f.)
*/

cFileMen:=""

Begin Sequence

   //INSTRUCOES PARA COBRANCA
   lCHECK_1 := .F.
   cCHECK_1 := STR0001 //"ENVIAR DOCUMENTOS PARA O BANCO INTERVENIENTE NO EXTERIOR"
   lCHECK_2 := .F.
   cCHECK_2 := STR0002 //"ENTREGAR OS DOCUMENTOS CONTRA PAGAMENTO"
   lCHECK_3 := .F.
   cCHECK_3 := STR0003 //"ENTREGAR OS DOCUMENTOS CONTRA ACEITE"
   lCHECK_4 := .F.
   cCHECK_4 := STR0004 //"NAO PROTESTAR"
   lCHECK_5 := .F.
   cCHECK_5 := STR0005 //"PROTESTAR POR FALTA DE PAGAMENTO, APOS O VENCIMENTO"
   lCHECK_6 := .F.
   cCHECK_6 := STR0006 //"EM CASO DE ATRASO DE PAGAMENTO, COBRAR JUROS DO SACADO A TAXA LIBOR"
   cCHECK_61 :=STR0007 //"MAIS 4% DE 'SPREAD' ATE O DIA DO PAGAMENTO"
   lCHECK_7 := .F.
   cCHECK_7 := STR0008 //"AS DESPESAS DE SEU CORRESPONDENTE SERAO POR CONTA DO SACADO"
   lCHECK_8 := .F.
   cCHECK_8 := STR0009 //"SUAS DESPESAS SERAO POR CONTA DO SACADO"
   lCHECK_9 := .F.
   cCHECK_9 := STR0010 //"SUAS DESPESAS SERAO POR NOSSA CONTA"
   lCHECK10 := .F.
   cCHECK10 := STR0011 //"TODAS AS DESPESAS SERAO POR NOSSA CONTA"
   lCHECK31 := .F.
   cCHECK31 := STR0012 //"PROTESTAR POR FALTA DE ACEITE"
   
   //INSTRUCOES PARA O BANCO COBRADOR
   //AVISO POR
   lCHECK11 := .F.
   cCHECK11 := STR0013 //"TELEGRAMA P/AFC"
   lCHECK12 := .F.
   cCHECK12 := STR0014 //"VIA AEREA"
   
   lCHECK13 := .F.
   cCHECK13 := STR0015 //"FALTA DE ACEITE E/OU PAGAMENTO"
   lCHECK14 := .F.
   cCHECK14 := STR0016 //"PAGAMENTO EFETUADO"
   lCHECK15 := .F.
   cCHECK15 := STR0017 //"REMESSA DE FUNDOS"
   
   //DOCUMENTOS ANEXADOS   
   lCHECK16 := .F.
   cCHECK16 := STR0018 //"SAQUE"
   cCHECK16O:= SPACE(2)
   cCHECK16C:= SPACE(2)
   lCHECK17 := .F.
   cCHECK17 := STR0019 //"FATURA COMERCIAL"
   cCHECK17O:= SPACE(2)
   cCHECK17C:= SPACE(2)
   lCHECK18 := .F.
   cCHECK18 := STR0020 //"CERTIFICADO DE ORIGEM"
   cCHECK18O:= SPACE(2)
   cCHECK18C:= SPACE(2)
   lCHECK19 := .F.
   cCHECK19 := STR0021 //"CERTIFICADO DE SEGURO"
   cCHECK19O:= SPACE(2)
   cCHECK19C:= SPACE(2)
   lCHECK20 := .F.
   cCHECK20 := STR0022 //"CONHECIMENTO DE EMBARQUE"
   cCHECK20O:= SPACE(2)
   cCHECK20C:= SPACE(2)
   lCHECK21 := .F.
   cCHECK21 := STR0023 //"PACKING LIST"
   cCHECK21O:= SPACE(2)
   cCHECK21C:= SPACE(2)
   lCHECK22 := .F.
   cCHECK22 := STR0024 //"CERTIFICADO DE INSPECAO"
   cCHECK22O:= SPACE(2)
   cCHECK22C:= SPACE(2)
   lCHECK23 := .F.
   cCHECK23 := STR0025 //"CERTIFICADO DE QUALIDADE"
   cCHECK23O:= SPACE(2)
   cCHECK23C:= SPACE(2)
   lCHECK24 := IF(!EMPTY(EEC->EEC_LC_NUM),.T.,.F.)
   cCHECK24 := STR0026 //"CARTA DE CREDITO"
   cCHECK24O:= SPACE(2)
   cCHECK24C:= SPACE(2)
   cCHECKG24:= EEC->EEC_LC_NUM
   lCHECK25 := .F.
   cCHECK25 := STR0027 //"EMENDA L/C"
   cCHECK25O:= SPACE(2)
   cCHECK25C:= SPACE(2)
   cCHECKG25:= EEC->EEC_LC_NUM
   lCHECK26 := .F.
   cCHECK26 := STR0028 //"CARTA AO CLIENTE"
   cCHECK26O:= SPACE(2)
   cCHECK26C:= SPACE(2)
   lCHECK27 := .F.
   cCHECK27 := ""//"CARTA AO IMPORTADOR"
   cCHECKG27:= SPACE(60)
   cCHECK27O:= SPACE(2)
   cCHECK27C:= SPACE(2)
   lCHECK28 := .F.
   cCHECK28O:= SPACE(2)
   cCHECK28C:= SPACE(2)
   cCHECK28 := ""
   cCHECKG28:= SPACE(60)
   lCHECK29 := .F.
   cCHECK29 := ""
   cCHECKG29:= SPACE(60)
   cCHECK29O:= SPACE(2)
   cCHECK29C:= SPACE(2)
   
   //GERAL (RODAPE DA JANELA)
   lCHECK30 := .F.
   cCHECK30 := STR0029 //"OS DOCUMENTOS ORIGINAIS SEGUIRAM DIRETAMENTE AO IMPORTADOR, ASSUMIMOS"
   cCHECK301:= STR0030 //"PLENA RESPONSABILIDADE PELA BOA LIQUIDACAO NO EXTERIOR"

   SY0->(dbSetOrder(4))
   If (SY0->(AvSeekLast(xFilial("SY0")+EEC->EEC_PREEMB+WORKID->(AvKey("2", "Y0_FASE")+EEA_COD))) .Or.;
      SY0->(AvSeekLast(xFilial("SY0")+EEC->EEC_PREEMB+WORKID->(AvKey("3", "Y0_FASE")+EEA_COD))))
      If MsgYesNo("Deseja restaurar o histórico da ultima impressão?", "Histórico de Documentos")
         RestHist()
      EndIf
   EndIf
   
   IF ! TelaGets()
      Break
   Endif
   
   //gerar arquivo padrao de edicao de carta
   IF ! E_AVGLTT("G")
      Break
   Endif
   
   // dados do exportador
   IF !EMPTY(EEC->EEC_EXPORT)
      cEXP_NOME    :=Posicione("SA2",1,xFilial("SA2")+EEC->EEC_EXPORT+EEC->EEC_EXLOJA,"A2_NOME")
      cEXP_CONTATO :=EECCONTATO(CD_SA2,EEC->EEC_EXPORT,EEC->EEC_EXLOJA,"1",1,EEC->EEC_RESPON)  //nome do contato seq 1
      cEXP_FONE    :=EECCONTATO(CD_SA2,EEC->EEC_EXPORT,EEC->EEC_EXLOJA,"1",4,EEC->EEC_RESPON)  //fone do contato seq 1
      cEXP_FAX     :=EECCONTATO(CD_SA2,EEC->EEC_EXPORT,EEC->EEC_EXLOJA,"1",7,EEC->EEC_RESPON)  //fax do contato seq 1
   ELSE
      cEXP_NOME    :=Posicione("SA2",1,xFilial("SA2")+EEC->EEC_FORN+EEC->EEC_FOLOJA,"A2_NOME") 
      cEXP_CONTATO :=EECCONTATO(CD_SA2,EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",1,EEC->EEC_RESPON)  //nome do contato seq 1
      cEXP_FONE    :=EECCONTATO(CD_SA2,EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",4,EEC->EEC_RESPON)  //fone do contato seq 1
      cEXP_FAX     :=EECCONTATO(CD_SA2,EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",7,EEC->EEC_RESPON)  //fax do contato seq 1
   ENDIF

   cEXP_NOME    :=ALLTRIM(cEXP_NOME)
   cEXP_CONTATO :=ALLTRIM(cEXP_CONTATO)
   cEXP_FONE    :=ALLTRIM(cEXP_FONE)
   cEXP_FAX     :=ALLTRIM(cEXP_FAX)
   
   //BANCO DOCUMENTOS
   BancoDoc()
   
   cTO_NOME := ALLTRIM(cTO_NOME)
   cTO_ATTN := ALLTRIM(cTO_ATTN)
   cTO_FAX  := ALLTRIM(cTO_FAX)
   
   //BANCO SAQUE
   cBanco     := Posicione("SA1",1,xFilial("SA1")+EEC->EEC_IMPORT+EEC->EEC_IMLOJA,"A1_BCO1")
   cINBC_NOME := Posicione("SA6",1,xFilial("SA6")+cBanco,"A6_NOME")
   cINBBC_ATTN:= EECCONTATO(CD_SA6,cBANCO,,"1",1) //nome do contato seq 1
   cINBC_FAX  := EECCONTATO(CD_SA6,cBANCO,,"1",7) //fax do contato seq 1
   cINBC_END  := ALLTRIM(Posicione("SA6",1,xFilial("SA6")+cBanco,"A6_END"))
   cINBC_END  := cINBC_END+ALLTRIM(Posicione("SA6",1,xFilial("SA6")+cBanco,"A6_MUN"))
   cINBC_END  := cINBC_END+ALLTRIM(Posicione("SA6",1,xFilial("SA6")+cBanco,"A6_UNIDFED"))
   
   //CLIENTE
   cCLI_NOME:=""
   IF !EMPTY(EEC->EEC_CLIENT)
      cCLI_NOME := Posicione("SA1",1,xFilial("SA1")+EEC->EEC_CLIENT+EEC->EEC_CLLOJA,"A1_NOME")
   ELSE
      cCLI_NOME := EEC->EEC_IMPODE
   ENDIF
   
   //adicionar registro no AVGLTT
   AVGLTT->(DBAPPEND())

   //gravar dados a serem editados
   AVGLTT->AVG_CHAVE :=EEC->EEC_PREEMB //nr. do processo
   AVGLTT->AVG_C01_60:=cEXP_NOME

   AVGLTT->AVG_C01_10:=IF(lCHECK_1,"X"," ")
   AVGLTT->AVG_C02_10:=IF(lCHECK_2,"X"," ")
   AVGLTT->AVG_C03_10:=IF(lCHECK_3,"X"," ")
   AVGLTT->AVG_C04_10:=IF(lCHECK_4,"X"," ")
   AVGLTT->AVG_C05_10:=IF(lCHECK_5,"X"," ")
   AVGLTT->AVG_C06_10:=IF(lCHECK_6,"X"," ")
   AVGLTT->AVG_C07_10:=IF(lCHECK_7,"X"," ")
   AVGLTT->AVG_C08_10:=IF(lCHECK_8,"X"," ")
   AVGLTT->AVG_C09_10:=IF(lCHECK_9,"X"," ")
   AVGLTT->AVG_C10_10:=IF(lCHECK10,"X"," ")
   AVGLTT->AVG_C04_20:=IF(lCHECK11,"X"," ")
   AVGLTT->AVG_C05_20:=IF(lCHECK12,"X"," ") 
   AVGLTT->AVG_C17_20:=IF(lCHECK30,"X"," ")
   AVGLTT->AVG_C18_20:=IF(lCHECK31,"X"," ")

   AVGLTT->AVG_C06_20:=IF(lCHECK13,"X"," ")
   AVGLTT->AVG_C07_20:=IF(lCHECK14,"X"," ")
   AVGLTT->AVG_C08_20:=IF(lCHECK15,"X"," ")

   /* Substituído pelo sub-relatório.
   AVGLTT->AVG_C06_20:=IF(lCHECK13,"X"," ")
   AVGLTT->AVG_C07_20:=IF(lCHECK14,"X"," ")
   AVGLTT->AVG_C08_20:=IF(lCHECK15,"X"," ")
   AVGLTT->AVG_C09_20:=IF(lCHECK16,"X"," ")
   AVGLTT->AVG_C08_60:=IF(lCHECK16,cCHECK16O+SPACE(04)+cCHECK16C,SPACE(08))
   AVGLTT->AVG_C10_20:=IF(lCHECK17,"X"," ")
   AVGLTT->AVG_C09_60:=IF(lCHECK17,cCHECK17O+SPACE(04)+cCHECK17C,SPACE(08))
   AVGLTT->AVG_C01_30:=IF(lCHECK18,"X"," ")
   AVGLTT->AVG_C10_60:=IF(lCHECK18,cCHECK18O+SPACE(04)+cCHECK18C,SPACE(08))
   AVGLTT->AVG_C02_30:=IF(lCHECK19,"X"," ")
   AVGLTT->AVG_C11_60:=IF(lCHECK19,cCHECK19O+SPACE(04)+cCHECK19C,SPACE(08))
   AVGLTT->AVG_C03_30:=IF(lCHECK20,"X"," ")
   AVGLTT->AVG_C12_60:=IF(lCHECK20,cCHECK20O+SPACE(04)+cCHECK20C,SPACE(08))
   AVGLTT->AVG_C04_30:=IF(lCHECK21,"X"," ")
   AVGLTT->AVG_C13_60:=IF(lCHECK21,cCHECK21O+SPACE(04)+cCHECK21C,SPACE(08))
   AVGLTT->AVG_C05_30:=IF(lCHECK22,"X"," ")
   AVGLTT->AVG_C14_60:=IF(lCHECK22,cCHECK22O+SPACE(04)+cCHECK22C,SPACE(08))
   AVGLTT->AVG_C06_30:=IF(lCHECK23,"X"," ")
   AVGLTT->AVG_C15_60:=IF(lCHECK23,cCHECK23O+SPACE(04)+cCHECK23C,SPACE(08))
   AVGLTT->AVG_C11_20:=IF(lCHECK24,"X"," ")
   AVGLTT->AVG_C16_60:=IF(lCHECK24,cCHECK24O+SPACE(04)+cCHECK24C,SPACE(08))
   AVGLTT->AVG_C12_20:=IF(lCHECK24,cCHECKG24," ")
   AVGLTT->AVG_C13_20:=IF(lCHECK25,"X"," ")
   AVGLTT->AVG_C17_60:=IF(lCHECK25,cCHECK25O+SPACE(04)+cCHECK25C,SPACE(08))
   AVGLTT->AVG_C14_20:=IF(lCHECK25,cCHECKG25," ")
   AVGLTT->AVG_C15_20:=IF(lCHECK26,"X"," ")
   AVGLTT->AVG_C18_60:=IF(lCHECK26,cCHECK26O+SPACE(04)+cCHECK26C,SPACE(08))
   AVGLTT->AVG_C16_20:=IF(lCHECK27,"X"," ")
   AVGLTT->AVG_C19_60:=IF(lCHECK27,cCHECK27O+SPACE(04)+cCHECK27C,SPACE(08))
   AVGLTT->AVG_C01100:=cCHECKG27
   AVGLTT->AVG_C19_20:=IF(lCHECK28,"X"," ")      
   AVGLTT->AVG_C22_60:=cCHECKG28
   AVGLTT->AVG_C20_60:=IF(lCHECK28,cCHECK28O+SPACE(04)+cCHECK28C,SPACE(08))
   AVGLTT->AVG_C20_20:=IF(lCHECK29,"X"," ")
   AVGLTT->AVG_C23_60:=cCHECKG29
   AVGLTT->AVG_C21_60:=IF(lCHECK29,cCHECK29O+SPACE(04)+cCHECK29C,SPACE(08))
   */
   AVGLTT->AVG_C24_60:=cTO_NOME
   AVGLTT->AVG_D01_08:=dDATABASE
   AVGLTT->AVG_C25_60:=cTO_ATTN
   AVGLTT->AVG_C26_60:=cINBC_NOME
   AVGLTT->AVG_C27_60:=cINBC_END
   AVGLTT->AVG_C07_30:=EEC->EEC_NRINVO
   AVGLTT->AVG_C08_30:=EEC->EEC_MOEDA+TRANSF(EEC->EEC_TOTPED,AVSX3("EEC_TOTPED",6))
   AVGLTT->AVG_C28_60:=cCLI_NOME
   AVGLTT->AVG_C29_60:=SY6Descricao(EEC->EEC_CONDPA+STR(EEC->EEC_DIASPA,AVSX3("Y6_DIAS_PA",3),0),EEC->EEC_IDIOMA,1)                   

   /* By JBJ - 06/01/04 - 09:04 - Carregar as informações do EEQ (Parcelas de Câmbio).
   AVGLTT->AVG_D02_08:=EEC->EEC_CBVCT
   AVGLTT->AVG_C09_30:=EEC->EEC_CBNR
   */
   EEQ->(DbSetOrder(1))
   If EEQ->(DbSeek(xFilial("EEQ")+EEC->EEC_PREEMB))
      Do While EEQ->(!Eof()) .And. EEQ->EEQ_FILIAL == xFilial("EEQ") .And.;
                                   EEQ->EEQ_PREEMB == EEC->EEC_PREEMB

         If !Empty(EEQ->EEQ_VCT) .And. !Empty(EEQ->EEQ_NROP)
            AVGLTT->AVG_D02_08 := EEQ->EEQ_VCT
            AVGLTT->AVG_C09_30 := EEQ->EEQ_NROP
            Exit
         EndIf

         EEQ->(DbSkip())
      EndDo
   EndIf

   // Alterado por Heder M Oliveira - 3/22/2000
   //BANCO INTERVENIENTE NO EXTERIOR
   // Alterado por Heder M Oliveira - 4/6/2000
   IF ( !EMPTY(BuscaInst(EEC->EEC_PREEMB,OC_EM,BC_DIM))) //TIPO CLASSIFICACAO DOC P/IMPORTADOR
      IF SA6->(dbSeek(xFilial("SA6")+EEJ->EEJ_CODIGO))
         AVGLTT->AVG_C02_60 := AllTrim(SA6->A6_NOME)+" - "+AllTrim(SA6->A6_END)
         AVGLTT->AVG_C03_60 := AllTrim(EECCONTATO(CD_SA6,SA6->A6_COD,"","1",1))+" - "+AllTrim(SA6->A6_MUN)+" - "+AllTrim(Posicione("SYA",1,xFilial("SYA")+SA6->A6_COD_P,"YA_DESCR"))+" - Fone "+AllTrim(EECCONTATO(CD_SA6,SA6->A6_COD,"","1",4))
      Endif
   ENDIF

   /*
      IF SA1->(dbSeek(xFilial()+EEC->EEC_IMPORT+EEC->EEC_IMLOJA)) 
         IF SA6->(dbSeek(xFilial()+SA1->A1_BCO1))
            AVGLTT->AVG_C02_60 := AllTrim(SA6->A6_NOME)+" - "+AllTrim(SA6->A6_END)
            AVGLTT->AVG_C03_60 := AllTrim(EECCONTATO(CD_SA6,SA6->A6_COD,"","1",1))+" - "+AllTrim(SA6->A6_MUN)+" - "+AllTrim(Posicione("SYA",1,xFilial("SYA")+SA6->A6_COD_P,"YA_DESCR"))+" - Fone "+AllTrim(EECCONTATO(CD_SA6,SA6->A6_COD,"","1",4))
         Endif
      Endif   
   */
   /*   
   AVGLTT->AVG_C02_60 := BuscaInst(EEC->EEC_PREEMB,OC_EM,BC_EMI)
   IF EEB->(!Eof())
      AVGLTT->AVG_C03_60 := EECCONTATO(CD_SA6,EEJ->EEJ_CODIGO,,"1",1)//AllTrim(Posicione("SA6",1,xFilial("SA6")+EEJ->EEJ_CODIGO,"A6_MUN"))+" "+AllTrim(Posicione("SYA",1,xFilial("SYA")+Posicione("SA6",1,xFilial("SA6")+EEJ->EEJ_CODIGO,"A6_COD_P"),"YA_DESCR"))
   Endif
   */   
   
   //descreve itens
   If Empty(mDetalhe)
      GravaItens()
   EndIf
   mDETALHE:=mDETALHE+ENTER
   mDet := SPACE(40)+STR0031+ENTER //"O B S E R V A C O E S"

   IF ( !EMPTY(EEC->EEC_COURI2)) //COURIER DO BANCO
      mDET:=mDET+STR0032+EEC->EEC_COURI2+ENTER //"FAVOR ENVIAR DOCUMENTO AO EXTERIROR ATRAVES DE COURIER - SERVICE "
      mDET:=mDET+STR0033+ENTER+ENTER //"MENCIONANDO O No. DE NOSSO PROCESSO NO RESPECTIVO CONHECIMENTO."
   ENDIF
   mDet += mDetAux
   //chamar rotina de mensagens  AWR
   IF SELECT("Work_Men") > 0
      nCol:=100
      Work_Men->(DBGOTOP())
      DO WHILE !Work_Men->(EOF()) .AND. WORK_MEN->WKORDEM<"zzzzz"

         nTotLin:=MLCOUNT(Work_Men->WKOBS,nCol) 

         FOR W := 1 TO nTotLin
            If !EMPTY(MEMOLINE(Work_Men->WKOBS,nCol,W))
                mDET:=mDET+MEMOLINE(Work_Men->WKOBS,nCol,W)+ENTER
            EndIf
         NEXT
         Work_Men->(DBSKIP())
      ENDDO
   ENDIF
   mDETALHE:=mDETALHE+mDET

   AVGLTT->AVG_C30_60 := EECCONTATO(CD_SA2,EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",1,EEC->EEC_RESPON) //NOME
   AVGLTT->AVG_C31_60 := EECCONTATO(CD_SA2,EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",4,EEC->EEC_RESPON) //FONE
   
   IF ! Empty(EEC->EEC_EXPORT)
      AVGLTT->AVG_C32_60 := Posicione("SA2",1,xFilial("SA2")+EEC->EEC_EXPORT+EEC->EEC_EXLOJA,"A2_NOME")
   Else
      AVGLTT->AVG_C32_60 := Posicione("SA2",1,xFilial("SA2")+EEC->EEC_FORN+EEC->EEC_FOLOJA,"A2_NOME")
   Endif   
   
   AVGLTT->WK_DETALHE := mDetalhe
     
   cSEQREL :=GetSXENum("SY0","Y0_SEQREL")
   CONFIRMSX8()

   // ** Tratamento para o sub-relatório de documentos.
   If Len(aDocumentos) > 0
      For z:=1 To Len(aDocumentos)
         If !(aDocumentos[z][4])
            Detail_p->(DbAppend())
            Detail_p->AVG_FILIAL := xFilial("SY0")
            Detail_p->AVG_SEQREL := cSeqRel
            Detail_p->AVG_CHAVE  := EEC->EEC_PREEMB

            Detail_p->AVG_C01_10  := "_DOC"
            Detail_p->AVG_C01_60  := Memoline(AllTrim(aDocumentos[z][1]),60,1)
            Detail_p->AVG_C01_20  := Str(aDocumentos[z][2],2,0)+" / "+Str(aDocumentos[z][3],2,0)
         EndIf
      Next
   EndIf

   DETAIL_P->(DbGoTop())
   Do While ! DETAIL_P->(Eof())
      DETAIL_H->(DbAppend())
      AvReplace("DETAIL_P","DETAIL_H")
      DETAIL_P->(DbSkip())
   EndDo

   DETAIL_P->(DbGoTop())

   //executar rotina de manutencao de caixa de texto
   lRet := E_AVGLTT("M",WORKID->EEA_TITULO,"AVG_C01150")

End Sequence
                                                        
IF(SELECT("Work_Men")>0,Work_Men->(E_EraseArq(cFileMen)),)
Select(nAlias)

RestOrd(aOrd)

Return lRet

/*
Funcao      : BancoDoc
Parametros  : 
Retorno     : 
Objetivos   : Retornar Banco Documentos
Autor       : Heder M Oliveira
Data/Hora   : 
Revisao     :
Obs.        :
*/
Static Function BancoDoc

Local cBanco    
Local cAgenc
Local cNumCo
   
Begin Sequence   
   cTO_NOME := ""
   cTO_ATTN := ""
   cTO_FAX  := ""

   //JAP Inclusão de Agencia e Conta na chave de pesquisa do Banco.
   cBanco   := Posicione("SA2",1,xFilial("SA2")+EEC->EEC_FORN+EEC->EEC_FOLOJA,"A2_BANCO")
   cAgenc   := Posicione("SA2",1,xFilial("SA2")+EEC->EEC_FORN+EEC->EEC_FOLOJA,"A2_AGENCIA")
   cNumCo   := Posicione("SA2",1,xFilial("SA2")+EEC->EEC_FORN+EEC->EEC_FOLOJA,"A2_NUMCON")  
   cTO_NOME := Posicione("SA6",1,xFilial("SA6")+AvKey(cBanco,"A6_COD")+;
                                                AvKey(cAgenc,"A6_AGENCIA")+;
                                                AvKey(cNumCo,"A6_NUMCON"),"A6_NOME")
   cTO_ATTN := EECCONTATO(CD_SA6,cBANCO,,"1",1) //nome do contato seq 1
   cTO_FAX  := EECCONTATO(CD_SA6,cBANCO,,"1",7) //fax do contato seq 1
End Sequence

Return NIL

/*
Funcao      : GravaItens
Parametros  : 
Retorno     : 
Objetivos   :
Autor       : Heder M Oliveira
Data/Hora   : 
Revisao     :
Obs.        :
*/
Static Function GravaItens

Local nLinhas := 1
Local cCodAnt := ""
Local cItem, cVia
Local nComis

Local cTO_NOME,cTO_BANCO,cTO_AGENC,cTO_CONTA

Begin Sequence
   
   EE9->(DBSEEK(XFILIAL()+EEC->EEC_PREEMB))
   
   mDETALHE := ""
   mDETALHE:=mDETALHE+SPACE(2)+STR0034+TRANSF(EE9->EE9_RE,AVSX3("EE9_RE",6))+STR0035+TRANSF(EE9->EE9_NRSD,AVSX3("EE9_NRSD",6))+ENTER //"R.E.: "###"  S.D.:"

   WHILE EE9->(!EOF()) .AND. EE9->EE9_FILIAL==XFILIAL("EE9") .AND.;
         EE9->EE9_PREEMB == EEC->EEC_PREEMB
      IF nLinhas > 8 //+4
         Exit
      Endif
      IF (cCODANT#EE9->EE9_COD_I)
         cITEM:=MSMM(EE9->EE9_DESC,AVSX3("EE9_VM_DES",3),1)
         IF ( !EMPTY(cITEM) )
            nLinhas := nLinhas+MlCount(cItem,AVSX3("EE9_VM_DES",3))
            mDETALHE:=mDETALHE+cITEM+ENTER
         ENDIF
         cCODANT:=EE9->EE9_COD_I
      ENDIF
      EE9->(DBSKIP())
   ENDDO

   mDETALHE:=mDETALHE+ENTER

   cVia:=""
   IF !EMPTY(EEC->EEC_VIA)
      cVia:=Posicione("SYQ",1,XFILIAL("SYQ")+EEC->EEC_VIA,"YQ_DESCR")
   ENDIF      

   mDETALHE:=mDETALHE+STR0036+cVia+ENTER //"VIA             : "
   mDETALHE:=mDETALHE+STR0037+EEC->EEC_NRCONH+ENTER //"CONHECIMENTO No.: "
   mDETALHE:=mDETALHE+STR0038+DTOC(EEC->EEC_DTCONH)+ENTER //"DATA            : "
   nCOMIS:=0

   IF ( !EMPTY(EEC->EEC_VALCOM) )
      nComis:=EEC->EEC_VALCOM
      mDETALHE:=mDETALHE+STR0039+IF(EEC->EEC_TIPCVL#"1",STR0040,"")+TRANSF(nComis,IF(EEC->EEC_TIPCVL#"1","999,999.99","99.99"))+IF(EEC->EEC_TIPCVL#"1","",STR0041) //"COMISSAO DE "###"US$"###" %"
      mDETALHE:=mDETALHE+IF(EEC->EEC_TIPCVL=="1",STR0042+TRANSF(EEC->EEC_TOTPED*(nComis/100),"999,999.99"),"") //"- US$"
      cTO_NOME:=BUSCAEMPRESA(EEC->EEC_PREEMB,OC_EM,CD_AGC)
      cTO_BANCO:=""
      cTO_AGENC:=""
      cTO_CONTA:=""
      SY5->(DBSETORDER(1))
      IF ( SY5->(DBSEEK(XFILIAL("SY5")+EEB->EEB_CODAGE )))
         cTO_BANCO:=Posicione("SA6",1,xFilial("SA6")+SY5->Y5_BANCO,"A6_NOME")
         cTO_AGENC:=SY5->Y5_AGENCIA
         cTO_CONTA:=SY5->Y5_CONTA
      ENDIF
      mDETALHE:=mDETALHE+STR0043+ALLTRIM(cTO_NOME)+","+ALLTRIM(cTO_BANCO)+" - "+ENTER //" PARA "
      mDETALHE:=mDETALHE+ALLTRIM(cTO_AGENC)+STR0044+ALLTRIM(cTO_CONTA)+ENTER //" - C/C "
   ENDIF
   
   //mDETALHE:=mDETALHE+"VALOR A SER FECHADO: "+EEC->EEC_MOEDA+TRANSF(EEC->EEC_TOTPED-IF(EEC->EEC_TIPCVL#"1",nComis,EEC->EEC_TOTPED*(nComis/100)),AVSX3("EEC_TOTPED",6))+ENTER
   //mDETALHE:=mDETALHE+STR0045+EEC->EEC_MOEDA+TRANSF(EEC->EEC_TOTPED-IF(EEC->EEC_TIPCVL#"1",nComis,EEC->EEC_TOTPED*(nComis/100)),"999,999.99")+ENTER //"VALOR A SER FECHADO: "
   mDETALHE:=mDETALHE+STR0045+EEC->EEC_MOEDA+TRANSF(EEC->EEC_TOTPED-IF(EEC->EEC_TIPCVL#"1",nComis,EEC->EEC_TOTPED*(nComis/100)),"99,999,999,999.99")+ENTER //"VALOR A SER FECHADO: "
End Sequence

Return NIL

/*
Funcao      : TelaGets
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : Heder M Oliveira
Data/Hora   : 
Revisao     : Jeferson Barros Jr.
Data/Hora   : 05/12/03 - 15:00.
Obs.        :
*/
*-----------------------*
Static Function TelaGets
*-----------------------*
Local lRet := .f.
Local oDlg, oMark, oFldF,oFld
Local aFld, aButtons:={}
Local xx := ""

Local bHide := {|| oMark:oBrowse:Hide() },;
      bShow := {|o| dbSelectArea("Work_Men"),;
                    o := oMark:oBrowse,;
                    o:Show(),o:SetFocus() }

Local bOk := {|| If(ValDocs(),(oDlg:End(), lRet:=.t.),nil)},;
      bCancel := {|| oDlg:End()}
      
Begin Sequence

   aAdd(aButtons,{"EDITABLE",{|| aDocumentos:=EECSelDocs(aDocumentos)},STR0054}) //"Documentos Anexos"

   //*** GFP 11/08/2011 - Alteração do tamanho de tela - M11.5
   DEFINE MSDIALOG oDlg TITLE AllTrim(WorkId->EEA_TITULO) FROM 200,1 TO 620,600 PIXEL OF oMainWnd //580,600 //620,600

      // ** Folder "Documentos Anexados" - Substituído pela função padrão de seleção de documentos (eeccad00.prw)
      oFld := TFolder():New(15,1,{STR0046,STR0047,STR0049},; //"Cobrança"###"Banco cobrador"###"Documentos anexados"###"Mensagens"
                                 {"IPC","IBC","MSG"},oDlg,,,,.T.,.F.,297,140)
      /*
      oFld := TFolder():New(1,1,{STR0046,STR0047,STR0048,STR0049},; //"Cobrança"###"Banco cobrador"###"Documentos anexados"###"Mensagens"
                                {"IPC","IBC","DAX","MSG"},oDLG,,,,.T.,.F.,300,160)
      */
      aFld := oFld:aDialogs
      aEval(aFld,{|o| o:SetFont(oDlg:oFont) })
      
      oFldF := aFld[1] //INSTRUCOES PARA COBRANCA
      // para encontrar a proxima linha, some 9. Ex.: 10+9=19
      TCheckBox():New(10,10,cCHECK_1,bSETGET(lCHECK_1),oFLDF,215,10,,,oDLG:oFONT,,,,,.T.)
      TCheckBox():New(19,10,cCHECK_2,bSETGET(lCHECK_2),oFLDF,215,10,,,oDLG:oFONT,,,,,.T.)
      TCheckBox():New(28,10,cCHECK_3,bSETGET(lCHECK_3),oFLDF,215,10,,,oDLG:oFONT,,,,,.T.)
      TCheckBox():New(37,10,cCHECK_4,bSETGET(lCHECK_4),oFLDF,215,10,,,oDLG:oFONT,,,,,.T.)
      TCheckBox():New(46,10,cCHECK31,bSETGET(lCHECK31),oFLDF,215,10,,,oDLG:oFONT,,,,,.T.)
      TCheckBox():New(55,10,cCHECK_5,bSETGET(lCHECK_5),oFLDF,215,10,,,oDLG:oFONT,,,,,.T.)
      TCheckBox():New(64,10,cCHECK_6,bSETGET(lCHECK_6),oFLDF,232,10,,,oDLG:oFONT,,,,,.T.)
      
      @ 73,20 SAY cCHECK_61 OF oFldF FONT oDlg:oFont PIXEL
      
      TCheckBox():New(82,10,cCHECK_7,bSETGET(lCHECK_7),oFLDF,232,10,,,oDLG:oFONT,,,,,.T.)
      TCheckBox():New(90,10,cCHECK_8,bSETGET(lCHECK_8),oFLDF,232,10,,,oDLG:oFONT,,,,,.T.)
      TCheckBox():New(99,10,cCHECK_9,bSETGET(lCHECK_9),oFLDF,232,10,,,oDLG:oFONT,,,,,.T.)
      TCheckBox():New(108,10,cCHECK10,bSETGET(lCHECK10),oFLDF,232,10,,,oDLG:oFONT,,,,,.T.)
       
      oFLDF:=aFLD[2] //INSTRUCOES PARA O BANCO COBRADOR
      @ 10,10 SAY STR0050 OF oFLDF FONT oDlg:oFont PIXEL //"AVISO POR:"
      
      TCheckBox():New(10,45,cCHECK11,bSETGET(lCHECK11),oFLDF,60,10,,,oDLG:oFONT,,,,,.T.,,,) 
      TCheckBox():New(10,130,cCHECK12,bSETGET(lCHECK12),oFLDF,215,10,,,oDLG:oFONT,,,,,.T.,,,) 
      TCheckBox():New(37,10,cCHECK13,bSETGET(lCHECK13),oFLDF,215,10,,,oDLG:oFONT,,,,,.T.)
      TCheckBox():New(46,10,cCHECK14,bSETGET(lCHECK14),oFLDF,215,10,,,oDLG:oFONT,,,,,.T.)
      TCheckBox():New(55,10,cCHECK15,bSETGET(lCHECK15),oFLDF,215,10,,,oDLG:oFONT,,,,,.T.)
      
      /* Substituído pela função padrão de seleção de documentos (eeccad00.prw)
      oFLDF:=aFLD[3] //DOCUMENTOS ANEXADOS
      @ 02,195 SAY STR0051 OF oFLDF PIXEL //"QUANTIDADE"
      @ 10,190 SAY STR0052 OF oFLDF PIXEL //"ORIGINAL/COPIA"
       
      TCheckBox():New(18,10,cCHECK16,bSETGET(lCHECK16),oFLDF,60,10,,,oDlg:oFONT,,,,,.T.)
      @ 19,195 MSGET cCHECK16O OF oFLDF SIZE 10,06 PIXEL // WHEN lCHECK16
      @ 19,220 MSGET cCHECK16C OF oFLDF SIZE 10,06 PIXEL // WHEN lCHECK16
       
      TCheckBox():New(27,10,cCHECK17,bSETGET(lCHECK17),oFLDF,120,10,,,oDlg:oFONT,,,,,.T.)
      @ 28,195 MSGET cCHECK17O OF oFLDF SIZE 10,06 PIXEL // WHEN lCHECK17
      @ 28,220 MSGET cCHECK17C OF oFLDF SIZE 10,06 PIXEL // WHEN lCHECK17
      
      TCheckBox():New(36,10,cCHECK18,bSETGET(lCHECK18),oFLDF,120,10,,,oDlg:oFONT,,,,,.T.)
      @ 37,195 MSGET cCHECK18O OF oFLDF SIZE 10,06 PIXEL // WHEN lCHECK18
      @ 37,220 MSGET cCHECK18C OF oFLDF SIZE 10,06 PIXEL // WHEN lCHECK18
       
      TCheckBox():New(45,10,cCHECK19,bSETGET(lCHECK19),oFLDF,120,10,,,oDlg:oFONT,,,,,.T.)
      @ 46,195 MSGET cCHECK19O OF oFLDF SIZE 10,06 PIXEL // WHEN lCHECK19
      @ 46,220 MSGET cCHECK19C OF oFLDF SIZE 10,06 PIXEL // WHEN lCHECK19
       
      TCheckBox():New(54,10,cCHECK20,bSETGET(lCHECK20),oFLDF,120,10,,,oDlg:oFONT,,,,,.T.)
      @ 55,195 MSGET cCHECK20O OF oFLDF SIZE 10,06 PIXEL // WHEN lCHECK20
      @ 55,220 MSGET cCHECK20C OF oFLDF SIZE 10,06 PIXEL // WHEN lCHECK20
      
      TCheckBox():New(63,10,cCHECK21,bSETGET(lCHECK21),oFLDF,120,10,,,oDlg:oFONT,,,,,.T.)
      @ 64,195 MSGET cCHECK21O OF oFLDF SIZE 10,06 PIXEL // WHEN lCHECK21
      @ 64,220 MSGET cCHECK21C OF oFLDF SIZE 10,06 PIXEL // WHEN lCHECK21
       
      TCheckBox():New(72,10,cCHECK22,bSETGET(lCHECK22),oFLDF,120,10,,,oDlg:oFONT,,,,,.T.)
      @ 73,195 MSGET cCHECK22O OF oFLDF SIZE 10,06 PIXEL // WHEN lCHECK22
      @ 73,220 MSGET cCHECK22C OF oFLDF SIZE 10,06 PIXEL // WHEN lCHECK22
       
      TCheckBox():New(81,10,cCHECK23,bSETGET(lCHECK23),oFLDF,120,10,,,oDlg:oFONT,,,,,.T.)
      @ 82,195 MSGET cCHECK23O OF oFLDF SIZE 10,06 PIXEL // WHEN lCHECK23
      @ 82,220 MSGET cCHECK23C OF oFLDF SIZE 10,06 PIXEL // WHEN lCHECK23
       
      TCheckBox():New(90,10,cCHECK24,bSETGET(lCHECK24),oFLDF,60,10,,,oDlg:oFONT,,,,,.T.)
      @ 91,92 SAY STR0053 OF oFLDF PIXEL //"NR. L/C"
      @ 91,110 MSGET cCHECKG24 OF oFLDF SIZE 35,06 PIXEL // WHEN lCHECK24
      @ 91,195 MSGET cCHECK24O OF oFLDF SIZE 10,06 PIXEL // WHEN lCHECK24
      @ 91,220 MSGET cCHECK24C OF oFLDF SIZE 10,06 PIXEL // WHEN lCHECK24
      
      TCheckBox():New(99,10,cCHECK25,bSETGET(lCHECK25),oFLDF,120,10,,,oDlg:oFONT,,,,,.T.)
      @ 100,195 MSGET cCHECK25O OF oFLDF SIZE 10,06 PIXEL // WHEN lCHECK25
      @ 100,220 MSGET cCHECK25C OF oFLDF SIZE 10,06 PIXEL // WHEN lCHECK25
      
      TCheckBox():New(108,10,cCHECK26,bSETGET(lCHECK26),oFLDF,120,10,,,oDlg:oFONT,,,,,.T.)
      @ 109,195 MSGET cCHECK26O OF oFLDF SIZE 10,06 PIXEL // WHEN lCHECK26
      @ 109,220 MSGET cCHECK26C OF oFLDF SIZE 10,06 PIXEL // WHEN lCHECK26
      
      TCheckBox():New(117,10,cCHECK27,bSETGET(lCHECK27),oFLDF,120,10,,,oDlg:oFONT,,,,,.T.)
      @ 118,020 MSGET cCHECKG27 OF oFLDF SIZE 150,06 PIXEL // WHEN lCHECK27
      @ 118,195 MSGET cCHECK27O OF oFLDF SIZE 10,06 PIXEL // WHEN lCHECK27
      @ 118,220 MSGET cCHECK27C OF oFLDF SIZE 10,06 PIXEL // WHEN lCHECK27
      
      TCheckBox():New(126,10,cCHECK28,bSETGET(lCHECK28),oFLDF,20,10,,,oDlg:oFONT,,,,,.T.)
      @ 127,020 MSGET cCHECKG28 OF oFLDF SIZE 150,06 PIXEL // WHEN lCHECK28
      @ 127,195 MSGET cCHECK28O OF oFLDF SIZE 10,06 PIXEL // WHEN lCHECK28
      @ 127,220 MSGET cCHECK28C OF oFLDF SIZE 10,06 PIXEL // WHEN lCHECK28
      
      TCheckBox():New(135,10,cCHECK29,bSETGET(lCHECK29),oFLDF,20,10,,,oDlg:oFONT,,,,,.T.)
      @ 135,020 MSGET cCHECKG29 OF oFLDF SIZE 150,06 PIXEL // WHEN lCHECK29
      @ 135,195 MSGET cCHECK29O OF oFLDF SIZE 10,06 PIXEL // WHEN lCHECK29
      @ 135,220 MSGET cCHECK29C OF oFLDF SIZE 10,06 PIXEL // WHEN l
      CHECK29
      
      oFLDF:=aFLD[4] //MENSAGENS
      */

      oFLDF:=aFLD[3] //MENSAGENS             
      
      oMark := EECMensagem(EEC->EEC_IDIOMA,"5",{28,3,150,296},,,,oFLDF) //150/300
      //oMark := EECMensagem(EEC->EEC_IDIOMA,"5",{18,3,150,300},,,,oFLDF)
      @ 14,043 GET xx OF oFldF
      
      //INSTRUCAO NO RODAPE     
      TCheckBox():New(165,10,cCHECK30,bSETGET(lCHECK30),oDlg,238,10,,,oDlg:oFONT,,,,,.T.)
      @ 174,20 SAY cCHECK301 OF oDlg PIXEL
      
      Eval(bHide)
      
      //oFld:bChange := {|nOption,nOldOption| if(nOption==4,Eval(bShow),Eval(bHide)) }
      oFld:bChange := {|nOption,nOldOption| if(nOption==3,Eval(bShow),Eval(bHide)) }
      
      /*
      DEFINE SBUTTON oBtnOk     FROM 187,050 TYPE 1 ACTION (lRet:=.T.,oDlg:End()) ENABLE OF oDlg
      DEFINE SBUTTON oBtnCancel FROM 187,110 TYPE 2 ACTION (oDlg:End()) ENABLE OF oDlg
      */
   ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,bOk,bCancel,,aButtons) CENTERED 
  
End Sequence

Return lRet 

/*
Funcao      : ValDocs().
Parametros  : Nenhum.
Objetivos   : Validar os documentos em anexo.
Retorno     : .t./.f.
Autor       : Jeferson Barros Jr.
Data/Hora   : 08/12/03 - 08:35
Obs.        :
*/
*-----------------------*
Static Function ValDocs()
*-----------------------*
Local lRet:=.t.
// Local aAux:={}, cMsg:="", j:=0, z:=0

Begin Sequence

   If Len(aDocumentos) = 0 // Verifica se algum documento já foi anexado a carta remessa.
      MsgStop(STR0055,STR0056) //"Informe os documentos anexos !"###"Atenção"
      lRet:=.f.
      Break   
   /*
   Else
      // ** Valida as informações (Quantidade de originais e cópias) dos documentos anexados.
      For j:=1 To Len(aDocumentos)
         If !(aDocumentos[j][4]) // Deletado?
            If Empty(aDocumentos[j][2]) .And. Empty(aDocumentos[j][3])
               aAdd(aAux,aDocumentos[j][1])
            EndIf
         EndIf
      Next

      If Len(aAux) > 0
         For z:=1 To Len(aAux)
            cMsg+= AllTrim(aAux[z])+If(z<>Len(aAux),"; "+ENTER,"")
         Next     
         
         MsgStop(STR0057+Replic(ENTER,2)+;  //"Revise as quantidades de originais e de cópias dos documentos:"
                 cMsg,STR0056) //"Atenção"
         lRet:=.f.
         Break
      EndIf
   */
   EndIf

End Sequence

Return lRet

Static Function RestHist()
Local lAux := .F.
Local nDoc1, nDoc2

   If HEADER_H->(DbSeek(xFilial()+SY0->Y0_SEQREL))
      lCHECK_1 := !Empty(HEADER_H->AVG_C01_10)
      lCHECK_2 := !Empty(HEADER_H->AVG_C02_10)
      lCHECK_3 := !Empty(HEADER_H->AVG_C03_10)
      lCHECK_4 := !Empty(HEADER_H->AVG_C04_10)
      lCHECK_5 := !Empty(HEADER_H->AVG_C05_10)
      lCHECK_6 := !Empty(HEADER_H->AVG_C06_10)
      lCHECK_7 := !Empty(HEADER_H->AVG_C07_10)
      lCHECK_8 := !Empty(HEADER_H->AVG_C08_10)
      lCHECK_9 := !Empty(HEADER_H->AVG_C09_10)
      lCHECK10 := !Empty(HEADER_H->AVG_C10_10)
      lCHECK11 := !Empty(HEADER_H->AVG_C04_20)
      lCHECK12 := !Empty(HEADER_H->AVG_C05_20)
      lCHECK13 := !Empty(HEADER_H->AVG_C06_20)
      lCHECK14 := !Empty(HEADER_H->AVG_C07_20)
      lCHECK15 := !Empty(HEADER_H->AVG_C08_20)
      lCHECK30 := !Empty(HEADER_H->AVG_C17_20)
      lCHECK31 := !Empty(HEADER_H->AVG_C18_20)
        
      If DETAIL_H->(DbSeek(xFilial("SY0")+SY0->Y0_SEQREL))
         While DETAIL_H->(AVG_FILIAL+AVG_SEQREL == xFilial("SY0")+SY0->Y0_SEQREL)
            If AllTrim(DETAIL_H->AVG_C01_10)  == "_DOC" .And. At("/", DETAIL_H->AVG_C01_20) > 0
               nDoc1 := Val(SubStr(DETAIL_H->AVG_C01_20, 1, At("/", DETAIL_H->AVG_C01_20)))
               nDoc2 := Val(SubStr(DETAIL_H->AVG_C01_20, At("/", DETAIL_H->AVG_C01_20), Len(DETAIL_H->AVG_C01_20) - At("/", DETAIL_H->AVG_C01_20)))
               aAdd(aDocumentos, {DETAIL_H->AVG_C01_60, nDoc1, nDoc2, .F.})
            Else
               If !lAux .And. At(STR0031, DETAIL_H->AVG_C01150) == 0//"O B S E R V A C O E S"
                  mDetalhe += DETAIL_H->AVG_C01150 + ENTER
               Else
                  lAux := .T.
                  mDetAux += SubStr(DETAIL_H->AVG_C01150, At(STR0031, DETAIL_H->AVG_C01150) + Len(STR0031) + 2) + ENTER
               EndIf
               
            EndIf
            DETAIL_H->(DbSkip())
         EndDo
      EndIf
         
   EndIf
      
Return

******************************************************************************************************************
*   FIM DO RDMAKE EECPEM09_RDM																					 *
******************************************************************************************************************

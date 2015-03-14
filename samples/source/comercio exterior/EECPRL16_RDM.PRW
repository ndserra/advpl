#INCLUDE  "EECPRL16.ch"
#INCLUDE  "TOPCONN.CH"
#INCLUDE  "EECRDM.CH"
#INCLUDE  "RWMAKE.CH"

/*
Funcao      : EECPRL16
Objetivos   : Ajustar o relatório para a versão 811 - Release 4
Autor       : Juliano Paulino Alves - JPA
Data 	    : 07/08/2006
Obs         :
Revisão     :
*/
**********************
User Function EECPRL16
**********************
lRet := U_EECP16R3(.T.)
RETURN lRet

/*                                                                             
Funcao      : EECP16R3
Parametros  : Nenhum                                                       
Retorno     : .F.
Objetivos   : Fechto. de Cambio - Variacao Cambial Mensal
Autor       : Jeferson Barros Jr.
Data/Hora   : 15/08/2001 09:31
Obs.        : EECPRL16.RPT
Revisão     : Juliano Paulino Alves - Relatório personalisável - Release 4
Data/Hora   : 07/08/06 15:45                           
*/

*-----------------------------------*
User Function EECP16R3(p_R4)
*-----------------------------------*
Local lRet     := .f.
Local nOldArea := ALIAS()
Local aOrd     := SaveOrd({"EE9","EEM","EEC","EEB","EE7"})
Private aArqs, cCmd,cWhere,cOrder,;
        cNomDbfC := "R28002C",;
        aCamposC := {{"SEQREL    ","C",08,0},;
                     {"CHAVE     ","C",15,0},;
                     {"TITULO    ","C",100,0},;
                     {"PERIODO   ","C",100,0},; // By JPP - 27/09/04 13:34
                     {"TXPTAX    ","C",15,0},;  //"N",AVSX3("EEQ_TX",3),AVSX3("EEQ_TX",4)}
                     {"MOEDA     ","C",20,0},;
                     {"IMPORT    ","C",60,0},;
                     {"SOMAVLNFS ","C",18,0},;
                     {"SOMAVLCAMB","C",18,0},;
                     {"CODFILIAL ","C",02,0}},;
        cNomDbfD := "R28002D",;
        aCamposD := {{"SEQREL    ","C", 8,0},;
                     {"CHAVE     ","C",15,0},;
                     {"PROCESSO  ","C",AVSX3("EEC_PREEMB",AV_TAMANHO),0},;   
                     {"DTPROCESSO","C",10,0},;   
                     {"DTVENC    ","C",10,0},;
                     {"IMPODE    ","C",60,0},;
                     {"MOEDA     ","C",AVSX3("EEC_MOEDA" ,AV_TAMANHO),0},;  // By JPP - 27/09/04 13:26
                     {"VALORNFS  ","C",18,0},;  // "N",AVSX3("EEM_VLNF",3),AVSX3("EEM_VLNF",4)},;
                     {"VALORUSS  ","C",18,0},;  // "N",AVSX3("EEC_TOTPED",3),AVSX3("EEC_TOTPED",4)},;
                     {"VRCAMB    ","C",18,0}}   // "N",AVSX3("EEQ_TX",3),AVSX3("EEQ_TX",4)}}            
                     
Private dDtIni    := AVCTOD("  /  /  ")
Private dDtFim    := AVCTOD("  /  /  ")
Private cArqRpt, cTitRpt
Private nTxPTAX   := 0
Private lZero    := .T.
Private lNovo    := .F.
Private cImport := Space(AVSX3("A1_COD",3))  // By JPP 27/09/04 -  09:30
Private cMoeda := Space(AVSX3("YF_MOEDA",AV_TAMANHO))
Private cNomeImp := Space(AVSX3("A1_NOME",AV_TAMANHO))
Private oGetNomeImp

//JPA - 07/08/2006 - Relatório Personalizavel - Release 4
Private oReport
Private lR4   := If(p_R4 == NIL,.F.,.T.) .AND. FindFunction("TRepInUse") .And. TRepInUse()

Begin Sequence

   IF Select("WorkId") > 0
      cArqRpt := WorkId->EEA_ARQUIV
      cTitRpt := AllTrim(WorkId->EEA_TITULO)
   Endif

   IF ! TelaGets()
      lRet := .F.
      Break
   Endif

   aARQS := {}
   AADD(aARQS,{cNOMDBFC,aCAMPOSC,"CAB","SEQREL"})
   AADD(aARQS,{cNOMDBFD,aCAMPOSD,"DET","SEQREL"})

   aRetCrw := CrwNewFilee(aARQS)
   #IFDEF TOP
      IF TCSRVTYPE() <> "AS/400"
         If ! EECFlags("FRESEGCOM")  // By JPP - 27/09/04 13:30 - Se a estrutura de dados EEQ é antiga. Mantém select antigo.
         cCmd   := "SELECT EEC_PREEMB, EEC_DTPROC, EEQ_VCT, EEC_IMPODE, EEQ_VL, EEC_MOEDA, EEC_DTEMBA FROM " +;  
                   RetSqlName("EEC") + " EEC, "+RetSqlName("EEQ")+" EEQ " 
         Else // Se a estrutura de dados EEQ é Nova. Define o novo select.
            cCmd   := "SELECT EEC_PREEMB, EEC_DTPROC, EEQ_VCT, EEQ_IMPORT, EEQ_IMLOJA, EEQ_VL, EEQ_MOEDA, EEC_DTEMBA FROM " +;  
                      RetSqlName("EEC") + " EEC, "+RetSqlName("EEQ")+" EEQ "           
         EndIf
         cWhere := " WHERE EEC.D_E_L_E_T_ <> '*' AND "+; 
                   " EEC_FILIAL = '" +xFilial("EEC")+ "' AND "+;
                   " EEC_DTEMBA <> '        ' AND EEQ_PREEMB = EEC_PREEMB AND EEQ.D_E_L_E_T_ <> '*' AND EEQ_FILIAL = '"+xFilial("EEQ")+"' AND EEQ_PGT = '        '"
         If EECFlags("FRESEGCOM")  // By JPP - 27/09/04 13:30 - Se a estrutura de dados EEQ é nova. Inclui novos filtros.         
            cWhere := cWhere + " AND EEQ_TIPO = 'R' "   // Titulos a receber
            If !Empty(cMoeda) 
               cWhere := cWhere + " AND EEQ_MOEDA = '" + cMoeda + "' "
            EndIf
            If !Empty(cImport)
               cWhere := cWhere + " AND EEQ_IMPORT = '" + cImport + "' "   
            EndIf   
         EndIf
         If !Empty(dDtIni)
            cWhere := cWhere + " AND EEQ_VCT >= '" + DtoS(dDtIni)+"'"
         EndIf
         If !Empty(dDtFim)
            cWhere := cWhere + " AND EEQ_VCT <= '" + DtoS(dDtFim)+"'"         
         EndIf                    
         cOrder := " ORDER BY EEQ_VCT"	
         cCmd := ChangeQuery(cCmd+cWhere+cOrder)
         dbUseArea(.T., "TOPCONN", TCGENQRY(,,cCmd), "QRY", .F., .T.) 
         Processa({|| lRet := Imprimir() })
      ELSE
   #ENDIF
         // ** Grava arquivo temporário ...     
         GravaDBF()                 
         MsAguarde({||lRet := Imprimir()},STR0002)                                                                     //"Imprimindo registros ..."
   #IFDEF TOP
      ENDIF
   #ENDIF
     
   //rotina principal
   cSEQREL :=GetSXENum("SY0","Y0_SEQREL")
   CONFIRMSX8()
  
   If ( lZero )
      MSGINFO(STR0003, STR0004) //"Intervalo sem dados para impressão"###"Aviso"
      lRet := .f.
   Else
      If lR4      //JPA - 07/08/2006
         oReport := ReportDef()
      EndIf
   EndIf

   QRY->(dbCloseArea())

   If ( lRet )
      If lR4   //JPA - 07/08/2006
         oReport:PrintDialog()
         CrwCloseFile(aRetCrw,.T.)
      Else
         lRetC := CrwPreview(aRetCrw,cArqRpt,cTitRpt,cSeqRel)
      EndIf
   Else  
      // Fecha e apaga os arquivos temporarios
      CrwCloseFile(aRetCrw,.T.)
   EndIf

End Sequence

dbSelectArea(nOldArea)

//retorna a situacao anterior ao processamento
RestOrd(aOrd)

Return (.F.)

/*
Funcao          : GravaDBF
Parametros      : Nenhum                  
Retorno         : .T.
Objetivos       : Gravar DBF com os registros para impressao
Autor           : Jeferson Barros Jr.
Data/Hora       : 15/08/2001 - 09:50
Revisao         :
Obs.            : 
*/
*-----------------------------------*
Static Function GravaDBF()
*-----------------------------------*
Local cWork, aSemSX3 := {}, aOrd:=SaveOrd({"EEC","EEQ"}),;
      cMacro:="", /* cMacro1:= "" , */ lRet:= .T.   // BY JPP - 29/11/04 11:42


Local aConds:={"!Empty(EEC->EEC_DTEMBA)  ",;
               "EEC->EEC_DTEMBA >= dDtini",;
               "EEC->EEC_DTEMBA <= dDtfim"}

aSemSX3 := {{"EEC_FILIAL","C",AVSX3("EEC_FILIAL",AV_TAMANHO),0},;     
            {"EEC_PREEMB","C",AVSX3("EEC_PREEMB",AV_TAMANHO),0},;     
            {"EEC_IMPODE","C",AVSX3("EEC_IMPODE",AV_TAMANHO),0},;     
            {"EEC_MOEDA ","C",AVSX3("EEC_MOEDA ",AV_TAMANHO),0},;     
            {"EEC_DTEMBA","D",AVSX3("EEC_DTEMBA",AV_TAMANHO),0},;     
            {"EEC_DTPROC","D",AVSX3("EEC_DTPROC",AV_TAMANHO),0}}
            
If EECFlags("FRESEGCOM") // JPP - 10/01/05 13:00
   AADD(aSemSX3,{"EEQ_IMPORT","C",AVSX3("EEQ_IMPORT",AV_TAMANHO),0})
   AADD(aSemSX3,{"EEQ_IMLOJA","C",AVSX3("EEQ_IMLOJA",AV_TAMANHO),0}) 
EndIf               

cWork  := E_CRIATRAB("EEQ",aSemSX3,"QRY")

IndRegua("QRY",cWork+OrdBagExt(),"EEQ_VCT" ,"AllwayTrue()","AllwaysTrue()",STR0001) //"Processando Arquivo Temporario"

Set Index to (cWork+OrdBagExt())

Begin Sequence
  
   EEC->(DbSetorder(12))                         //Filial + Dta Embarque        
   // EEC->(DbSeek(xFilial("EEC")+IF(!Empty(dDtIni),Dtos(dDtIni),"00000000"),.T.)) - By JPP - 28/09/04 16:40
   EEC->(DbSeek(xFilial("EEC")+"00000000",.T.))
              
   If Empty(dDtini) .And. Empty(dDtFim)                               
      cMacro:= aConds[1]                         //"!Empty(EEC->EEC_DTEMBA)"
   Else              
     cMacro := If(!Empty(dDtini),aConds[2],"")   //"EEC->EEC_DTEMBA >= dDtini"
     cMacro += If(!Empty(dDtini),If(!Empty(dDtfim)," .And. ",""),"")                      
     cMacro += If(!Empty(dDtfim),aConds[3],"")   //"EEC->EEC_DTEMBA <= dDtfim"
   Endif        

   EEQ->(DbSeek(xFilial("EEQ")+EEC->EEC_PREEMB))          
      
   Do While EEC->(!Eof() .And. EEC_FILIAL == xFilial("EEC")) 
       
      EEQ->(DbSeek(xFilial("EEQ")+EEC->EEC_PREEMB))          
     
      //IF &cMacro     -  BY JPP 28/04/09 16:10        
         While EEQ->(!Eof() .And. EEQ_FILIAL == xFilial("EEQ")) .And. EEQ->EEQ_PREEMB == EEC->EEC_PREEMB 
         // Filtro pela Data Inicial   -  BY JPP 28/04/09 16:10               
         If !Empty(dDtIni)
            If DTOS(EEQ->EEQ_VCT) < DTOS(dDtini)
               EEQ->(DbSkip())
               Loop
            EndIf
         EndIf
         // Filtro pela Data Final
         If !Empty(dDtFim)
            If DTOS(EEQ->EEQ_VCT) > DTOS(dDtFim)
               EEQ->(DbSkip())
               Loop
            EndIf
         EndIf
         If ! EECFlags("FRESEGCOM")  // JPP - 27/09/04 14:25 - Se a estrutura da tabela EEQ é antiga. Mantem a gravação de dados original.
            If Empty(EEQ->EEQ_PGT)
               QRY->(DbAppend())
               QRY->EEC_PREEMB:= EEC->EEC_PREEMB  
               QRY->EEC_DTPROC:= EEC->EEC_DTPROC 
               QRY->EEC_IMPODE:= EEC->EEC_IMPODE 
               QRY->EEC_MOEDA := EEC->EEC_MOEDA  
               QRY->EEC_DTEMBA:= EEC->EEC_DTEMBA              
               QRY->EEQ_VCT   := EEQ->EEQ_VCT    
               QRY->EEQ_VL    := EEQ->EEQ_VL                     
            EndIf
         Else // Se a estrutura de dados da tabela EEQ é nova, Grava os dados de acordo com os novos campos da tabela EEQ e os novos filtros.   
            If EEQ->EEQ_TIPO <> "R"  // Titulos a Receber
               EEQ->(DbSkip())
               Loop
            EndIf 
            // Filtro pelo importador.
            If !Empty(cImport)
               If EEQ->EEQ_IMPORT <> AvKey(cImport,"EEQ_IMPORT")
                  EEQ->(DbSkip())
                  Loop
               EndIf
            EndIf
            // Filtro pela Moeda             
            If !Empty(cMoeda)
               If EEQ->EEQ_MOEDA <> AvKey(cMoeda,"EEQ_MOEDA")
                  EEQ->(DbSkip())
                  Loop
               EndIf
            EndIf
            If Empty(EEQ->EEQ_PGT)
               QRY->(DbAppend())
               QRY->EEC_PREEMB:= EEC->EEC_PREEMB  
               QRY->EEC_DTPROC:= EEC->EEC_DTPROC 
               QRY->EEQ_IMPORT:= EEQ->EEQ_IMPORT
               QRY->EEQ_IMLOJA:= EEQ->EEQ_IMLOJA 
               QRY->EEQ_MOEDA := EEQ->EEQ_MOEDA  
               QRY->EEC_DTEMBA:= EEC->EEC_DTEMBA              
               QRY->EEQ_VCT   := EEQ->EEQ_VCT    
               QRY->EEQ_VL    := EEQ->EEQ_VL                     
            EndIf
         EndIf
         EEQ->(DbSkip())
         Enddo            
      // EndIf     BY JPP 28/04/09 16:10
      EEC->(DbSkip())
   EndDo         

   RestOrd(aOrd)
   QRY->(DbGoTop())   

End Sequence

Return lRet
        
*-----------------------------------*
Static Function Imprimir
*-----------------------------------*
Local lRet := .f.
Local cPeriodo 
Local cChave  
Local nValorNfs := 0, nValorUss := 0, nValorCamb := 0
Local nSomaVlNfs := 0, nSomaVlCamb := 0
Local cPictNfs :=AVSX3("EEM_VLNF"  ,AV_PICTURE), cPictUss := AVSX3("EEC_TOTPED",AV_PICTURE),;  
      cPictCamb := AVSX3("EEC_TOTPED"  ,AV_PICTURE), cPictTxPTAX := AVSX3("EEQ_TX"  ,AV_PICTURE) 
Local aSomaMoeda := {}, nInd

Begin Sequence

   lZero := .t.
   #IFDEF TOP
      IF TCSRVTYPE() <> "AS/400"
         cCmd     := "SELECT COUNT(*) AS NCOUNT FROM " +;  
                     RetSqlName("EEC") + " EEC, "+RetSqlName("EEQ")+" EEQ " 
         cCmd     := ChangeQuery(cCmd+cWhere)
         nOldArea := Alias()
         dbUseArea(.T., "TOPCONN", TCGENQRY(,,cCmd), "QRYTEMP", .F., .T.) 
         ProcRegua(QRYTEMP->NCOUNT)
         QRYTEMP->(dbCloseArea())
         dbSelectArea(nOldArea)
      ELSE
   #ENDIF
         //... DBF ...
   #IFDEF TOP
      ENDIF
   #ENDIF
      
   CAB->(DBAPPEND())                     
   CAB->SEQREL  := cSeqRel 
   CAB->CHAVE   := "_ITEMSDETALHE" 
   CAB->TITULO  := cTitRpt
     
   // ** Define o Período do Relatório   
   If !Empty(dDtini) .And. !Empty(dDtfim)   
      cPeriodo := STR0005+Dtoc(dDtini)+STR0006+Dtoc(dDtfim)     //"Vencimentos de  "###"  Até  "
   ElseIf !Empty(dDtini) .And. Empty(dDtfim)
      cPeriodo := STR0007+Dtoc(dDtini)    //"Vencimentos a partir de  "
   ElseIf Empty(dDtini) .And. !Empty(dDtfim)   
      cPeriodo := STR0008+Dtoc(dDtfim) //"Vencimentos até  "
   Else   
      cPeriodo := STR0009 //"Todos os Vencimentos"
   EndIf   
   CAB->IMPORT := "*"     //  Define que o cabeçalho do relatorio será o antigo
   If EECFlags("FRESEGCOM")  // // JPP - 27/09/04 15:10 - Se a estrutura de dados EEQ é Nova. Define cabeçalho com os novos filtros.
      If !Empty(cMoeda)
         CAB->MOEDA := cMoeda
      Else
         CAB->MOEDA := STR0018 // "Todas"
      EndIf                                           
      If Empty(cImport)                     
         CAB->IMPORT := STR0009 // "Todos"  
      Else
         cChave:=QRY->EEQ_IMPORT + QRY->EEQ_IMLOJA 
         CAB->IMPORT :=  Posicione("SA1",1,xFilial("SA1")+cChave,"A1_NOME") 
      EndIf 
   EndIf   
   CAB->PERIODO := cPeriodo
   CAB->TXPTAX  :=Transform(nTxPTAX,cPictTxPTAX)  
   CAB->(MSUNLOCK())                                                       
      
   While QRY->(!Eof())
      #IFDEF TOP
         IF TCSRVTYPE() <> "AS/400"
            IncProc(STR0010 + QRY->EEC_PREEMB) //"Imprimindo: "
         ELSE
      #ENDIF
            //... DBF ...
      #IFDEF TOP
         ENDIF
      #ENDIF
      DET->(DBAPPEND())
      DET->SEQREL      := cSeqRel 
      DET->CHAVE    := "_ITEMSDETALHE"
      DET->PROCESSO    := AllTrim(QRY->EEC_PREEMB)
      #IFDEF TOP
         IF TCSRVTYPE() <> "AS/400"
            DET->DTPROCESSO := TransData(QRY->EEC_DTPROC)
            DET->DTVENC     := TransData(QRY->EEQ_VCT)
         ELSE
      #ENDIF
            DET->DTPROCESSO := Dtoc(QRY->EEC_DTPROC)
            DET->DTVENC     := Dtoc(QRY->EEQ_VCT)      
      #IFDEF TOP
         ENDIF
      #ENDIF
      If ! EECFlags("FRESEGCOM") // JPP - 27/09/04 16:00 - Se a estrutura de dados da tabela EEQ é antiga. Mantem a leitura original do cliente. 
      DET->IMPODE := ALLTRIM(QRY->EEC_IMPODE)
         DET->MOEDA    := QRY->EEC_MOEDA
      Else // Se a estrutura de dados da tabela EEQ é nova, o cliente é gravado a partir do cadastro de clientes.
         cChave:= QRY->EEQ_IMPORT + QRY->EEQ_IMLOJA 
         DET->IMPODE   := Posicione("SA1",1,xFilial("SA1")+cChave,"A1_NOME") 
         DET->MOEDA    := QRY->EEQ_MOEDA
      EndIf  
      #IFDEF TOP
         IF TCSRVTYPE() <> "AS/400"
            If ! EECFlags("FRESEGCOM") // JPP - 27/09/04 16:00 - Se a estrutura de dados da tabela EEQ é antiga. Mantem a leitura original dos dados. 
               nValorNfs := QRY->EEQ_VL * BuscaTaxa(QRY->EEC_MOEDA,CtoD(TransData(QRY->EEC_DTEMBA)),,.f.)
               DET->VALORNFS := Transform(nValorNfs,cPictNfs)
            Else // lê os dados com base na tabela EEQ 
               nValorNfs := QRY->EEQ_VL * BuscaTaxa(QRY->EEQ_MOEDA,CtoD(TransData(QRY->EEC_DTEMBA)),,.f.)
               DET->VALORNFS := Transform(nValorNfs,cPictNfs)
            EndIf            
         ELSE
      #ENDIF
            If ! EECFlags("FRESEGCOM") // JPP - 27/09/04 16:00 - Se a estrutura de dados da tabela EEQ é antiga. Mantem a leitura original dos dados.                                                                        
               nValorNfs := QRY->EEQ_VL * BuscaTaxa(QRY->EEC_MOEDA,QRY->EEC_DTEMBA,,.f.)
               DET->VALORNFS := Transform(nValorNfs,cPictNfs)
            Else // lê os dados com base na tabela EEQ 
               nValorNfs := QRY->EEQ_VL * BuscaTaxa(QRY->EEQ_MOEDA,QRY->EEC_DTEMBA,,.f.)
               DET->VALORNFS := Transform(nValorNfs,cPictNfs)                  
            EndIf   
      #IFDEF TOP
         ENDIF
      #ENDIF
      nValorUss  := QRY->EEQ_VL
      DET->VALORUSS  :=Transform(nValorUss,cPictUss) 
      #IFDEF TOP
         IF TCSRVTYPE() <> "AS/400" 
            If ! EECFlags("FRESEGCOM") // JPP - 27/09/04 16:00 - Se a estrutura de dados da tabela EEQ é antiga. Mantem a leitura original dos dados.                                                                        
               nValorCamb := QRY->EEQ_VL * (nTxPTAX - BuscaTaxa(QRY->EEC_MOEDA,CtoD(TransData(QRY->EEC_DTEMBA)),,.f.))         
               DET->VRCAMB := Transform(nValorCamb,cPictCamb)
            Else // lê os dados com base na tabela EEQ 
               nValorCamb := QRY->EEQ_VL * (nTxPTAX - BuscaTaxa(QRY->EEQ_MOEDA,CtoD(TransData(QRY->EEC_DTEMBA)),,.f.))         
               DET->VRCAMB := Transform(nValorCamb,cPictCamb)                
            EndIf   
         ELSE
      #ENDIF
            If ! EECFlags("FRESEGCOM") // JPP - 27/09/04 16:00 - Se a estrutura de dados da tabela EEQ é antiga. Mantem a leitura original dos dados.                                                                        
               nValorCamb := QRY->EEQ_VL * (nTxPTAX - BuscaTaxa(QRY->EEC_MOEDA,QRY->EEC_DTEMBA,,.f.))            
               DET->VRCAMB := Transform(nValorCamb,cPictCamb)
            Else // lê os dados com base na tabela EEQ       
               nValorCamb := QRY->EEQ_VL * (nTxPTAX - BuscaTaxa(QRY->EEQ_MOEDA,QRY->EEC_DTEMBA,,.f.))            
               DET->VRCAMB := Transform(nValorCamb,cPictCamb)
            EndIf   
      #IFDEF TOP
         ENDIF
      #ENDIF 
      nSomaVlNfs += nValorNfs  // By JPP 27/09/04 16:30 - Efetua o calculo dos totais.
      nSomaVlCamb += nValorCamb
      nInd :=Ascan(aSomaMoeda,{|aParamet| aParamet[1] = DET->MOEDA}) // By JPP 27/09/04 16:30 - Efetua a somatória dos valores para cada moeda
      If nInd > 0
         aSomaMoeda[nInd,2] := aSomaMoeda[nInd,2] + nValorUss
      Else
         AADD(aSomaMoeda,{DET->MOEDA,nValorUss})
      EndIf   
      
      DET->(MSUNLOCK())

      lNovo := .T.
      lZero := .f.
   
      QRY->(dbSkip())

      lRet := .t.           
   Enddo   
   CAB->SOMAVLNFS := If(nSomaVlNfs = 0,"",Transform(nSomaVlNfs,cPictNfs)) // By JPP 27/09/04 16:35 - Grava os totais do relatorio   
   CAB->SOMAVLCAMB:= If(nSomaVlCamb= 0,"",Transform(nSomaVlCamb,cPictCamb)) 
   CAB->(MSUNLOCK())

   For nInd := 1 to len(aSomaMoeda)       // By JPP 27/09/04 16:35  - Grava os dados do subrelatório
       DET->(DbAppend())    
       DET->SEQREL   := cSeqRel    
       DET->CHAVE    := "_ITEMSSUB_REL"
       DET->MOEDA    := aSomaMoeda[nInd,1]
       DET->VALORUSS := Transform(aSomaMoeda[nInd,2],cPictUss) 
       DET->(MSUNLOCK())
   next

End Sequence 

Return lRet

*-----------------------------------*
Static Function TelaGets
*-----------------------------------*

Local lRet  := .f.
Local nOpc  := 0
Local bOk, bCancel
Local nLin, nCol    // By JPP - 27/09/04 - 09:36
Local oPanel

Begin Sequence 
   if ! EECFlags("FRESEGCOM")    // By JPP - 27/09/04 09:40 - Se a estrutura de dados EEQ é antiga. Mantém a tela original.
      nLin := 18.5
      nCol := 44.5
   Else // Se a estrutura da tabela EEQ é nova, define a nova tela.
      nLin := 23 /*21*/ //FDR - 16/01/12 - Ajuste de tela
      nCol := 44.5
   EndIf

   DEFINE MSDIALOG oDlg TITLE cTitRpt FROM 9,0 TO nLin,nCol OF oMainWnd
      
      //wfs - alinhamento
      oPanel:= TPanel():New(0, 0, "",oDlg,, .F., .F.,,, nCol, nLin-9)
      
      If ! EECFlags("FRESEGCOM")  // By JPP - 27/09/04 09:45 - Se a estrutura de dados EEQ é antiga. Mantém a tela Original.
         @ 20,15 SAY STR0014 PIXEL Of oPanel //"Taxa PTAX"
         @ 20,70 MSGET nTxPTAX PICTURE (AVSX3("EEQ_TX",6)) Valid NaoVazio() SIZE 50,8 PIXEL Of oPanel

         @ 35,15 SAY STR0011 PIXEL Of oPanel //"Data Inicial"
         @ 35,70 MSGET dDtIni SIZE 50,8 PIXEL Of oPanel
      
         @ 50,15 SAY STR0012 PIXEL Of oPanel //"Data Final"
         @ 50,70 MSGET dDtFim SIZE 50,8 Valid fConfData(dDtFim,dDtIni) PIXEL Of oPanel
      Else // Se a estrutura da tabela EEQ é nova, define a nova tela, com os novos filtros.
         @ 17,07 SAY STR0014 PIXEL Of oPanel //"Taxa PTAX"
         @ 17,42 MSGET nTxPTAX PICTURE (AVSX3("EEQ_TX",AV_PICTURE)) Valid NaoVazio() SIZE 50,8 PIXEL Of oPanel
         
         @ 29,07 Say STR0015 Pixel Of oPanel // "Moeda"  
         @ 29,42 MsGet cMoeda F3 "SYF" Valid (Empty(cMoeda) .or. ExistCPO("SYF")) Size 20,8 Pixel Of oPanel
         
         @ 41,07 Say STR0016 Pixel Of oPanel // "Importador"  
         @ 41,42 MsGet oGetImp Var cImport F3 "SA1" Valid (Empty(cImport) .or. ExistCPO("SA1") .And. TipoCorreto()) Size 20,8 Pixel Of oPanel
                 
         @ 53,07 Say STR0017 Pixel Of oPanel  // "Descrição" 
         @ 53,42 MsGet oGetNomeImp Var cNomeImp Size 120,8 Pixel Of oPanel
                 
         @ 64,07 SAY STR0011 PIXEL Of oPanel //"Data Inicial"
         @ 64,42 MSGET dDtIni SIZE 50,8 PIXEL Of oPanel
      
         @ 76,07 SAY STR0012 PIXEL Of oPanel //"Data Final"
         @ 76,42 MSGET dDtFim SIZE 50,8 Valid fConfData(dDtFim,dDtIni) PIXEL Of oPanel 
         
         oGetNomeImp:Disable()     
      EndIf

      oPanel:Align:= CONTROL_ALIGN_ALLCLIENT
         
      bOk     := {|| If(fConfData(dDtFim,dDtIni),(nOpc:=1, oDlg:End()),nOpc:=0)}
      bCancel := {|| oDlg:End() }
   
   ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,bOk,bCancel) CENTERED
   
   IF nOpc == 1
      lRet := .t.
   Else
      lRet := .f.   
   Endif 

End Sequence

Return lRet   
   
*-----------------------------------*
Static Function fConfData(dFim,dIni)
*-----------------------------------*

Local lRet  := .t.

Begin Sequence
      
      if !empty(dFim) .and. dFim < dIni
         MsgInfo(STR0013,STR0004) //"Data Final não pode ser menor que Data Inicial"###"Aviso"
         lRet := .f.
      Else
         lRet := .t.
      Endif   

End Sequence
            
Return lRet
  
#IFDEF TOP
   *-----------------------------------*
   Static Function TransData(sData)
   *-----------------------------------*
   if Empty(sData)
      sData := "  /  /  "
   Else
      sData := SubStr(AllTrim(sData),7,2) + "/" + SubStr(AllTrim(sData),5,2) + "/" +   SubStr(AllTrim(sData),1,4)
   Endif

   Return sData 
#ENDIF
/*
Funcao      : TipoCorreto()
Parametros  : 
Retorno     : .T. ou .F.
Objetivos   : Definir se o tipo selecionado é Importador ou Todos.
Autor       : Julio de Paula Paz
Data/Hora   : 27/09/04 10:35.
*/
Static Function TipoCorreto()
Local lRet := .f.
If SA1->A1_TIPCLI = "1" .Or. SA1->A1_TIPCLI = "4"   // "1" = "Importador" - "4" = "Todos" 
   cNomeImp := SA1->A1_NOME
   lRet := .t.
Else
   MsgInfo(STR0019+ENTER;   //  "Importador Inválido! "
          +STR0020+ENTER;   //  "Selecionar um Importador que esteja cadastrado como "
          +STR0021)         //  "Importador ou Todos!"  
   cNomeImp := Space(AVSX3("A1_NOME",AV_TAMANHO))
   oGetNomeImp:Refresh()
EndIf
Return lRet 

//JPA - 07/08/2006 - Definições do relatório personalizável
****************************
Static Function ReportDef()
****************************                         
Local cTitulo := "Variação Cambial (Invoices)"
Local cDescr  := "Variacao Cambial Mensal"
//Alias que podem ser utilizadas para adicionar campos personalizados no relatório
aTabelas := {"EEC", "EEQ"}

//Array com o titulo e com a chave das ordens disponiveis para escolha do usuário
aOrdem   := {} 

//Parâmetros:            Relatório , Titulo ,  Pergunte , Código de Bloco do Botão OK da tela de impressão.
oReport := TReport():New("EECPRL16", cTitulo ,"", {|oReport| ReportPrint(oReport)}, cDescr)

//ER - 20/10/2006 - Inicia o relatório como paisagem.
oReport:oPage:lLandScape := .T.
oReport:oPage:lPortRait := .F.

//Define os objetos com as seções do relatório
oSecao1 := TRSection():New(oReport,"Seção 1",aTabelas,aOrdem)
oSecao2 := TRSection():New(oReport,"Seção 2",{"CAB"},{})

//Definição das colunas de impressão da seção 1
TRCell():New(oSecao1,"PROCESSO"  , "DET", "Processo"        , /*Picture*/   , AVSX3("EEC_PREEMB",AV_TAMANHO), /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"DTPROCESSO", "DET", "Dt. Processo"    , /*Picture*/   , 010                           , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"DTVENC"    , "DET", "Dt. Vencto"      , /*Picture*/   , 010                           , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"IMPODE"    , "DET", STR0016           , /*Picture*/   , 060                           , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"VALORNFS"  , "DET", "Valor R$"        , /*Picture*/   , 015                           , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"MOEDA"     , "DET", STR0015           , /*Picture*/   , AVSX3("EEC_MOEDA" ,AV_TAMANHO), /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"VALORUSS"  , "DET", " /   Valor"      , /*Picture*/   , 018                           , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"VRCAMB"    , "DET", "Variação Cambial", /*Picture*/   , 018                           , /*lPixel*/, /*{|| code-block de impressao }*/)

oReport:Section("Seção 1"):Cell("VALORNFS"):SetColSpace(5)

oSecao1:SetTotalInLine(.F.)
oSecao1:SetTotalText("Total")

oTotal:= TRFunction():New(oSecao1:Cell("VALORNFS"),NIL,"SUM",/*oBreak*/,"","@E 999,999,999.99",{|| ConvertNum(DET->VALORNFS)},.T.,.F.)
oTotal:SetTotalInLine(.F.)


//Definição das colunas de impressão da seção 2
TRCell():New(oSecao2,"IMPORT" , "CAB", "Importador", /*Picture*/, 030 , /*lPixel*/, /*{|| code-block de impressao }*/)
oReport:Section("Seção 2"):Cell("IMPORT"):SetCellBreak()

TRCell():New(oSecao2,"PERIODO", "CAB", "Período"   , /*Picture*/, 030 , /*lPixel*/, /*{|| code-block de impressao }*/)
oReport:Section("Seção 2"):Cell("PERIODO"):SetCellBreak()

TRCell():New(oSecao2,"TXPTAX" , "CAB", "Taxa"      , /*Picture*/, 015 , /*lPixel*/, /*{|| code-block de impressao }*/)
oReport:Section("Seção 2"):Cell("TXPTAX"):SetCellBreak()

TRCell():New(oSecao2,"MOEDA"  , "CAB", STR0015     , /*Picture*/, 020 , /*lPixel*/, /*{|| code-block de impressao }*/)
oReport:Section("Seção 2"):Cell("MOEDA"):SetCellBreak()

oReport:bOnPageBreak :={||oReport:Section("Seção 2"):PrintLine()} 

Return oReport


************************************
Static Function ReportPrint(oReport)
************************************
Local oSection := oReport:Section("Seção 1")

//Faz o posicionamento de outros alias para utilização pelo usuário na adição de novas colunas.
TRPosition():New(oReport:Section("Seção 1"),"EEC",1,{|| xFilial("EEC")})
TRPosition():New(oReport:Section("Seção 1"),"EEQ",1,{|| xFilial("EEQ")+EEC->EEC_PREEMB})

oReport:SetMeter(DET->(RecCount()))
DET->(dbGoTop())

oReport:Section("Seção 2"):Init()
//Inicio da impressão da seção 1. Sempre que se inicia a impressão de uma seção é impresso automaticamente
//o cabeçalho dela.              

oReport:Section("Seção 1"):Init()

//Laço principal
Do While DET->(!EoF()) .And. !oReport:Cancel()

   If DET->CHAVE == "_ITEMSSUB_REL  "
      oReport:Section("Seção 1"):Finish()
      oReport:Section("Seção 1"):Cell(1):Disable()
      oReport:Section("Seção 1"):Cell(2):Disable()
      oReport:Section("Seção 1"):Cell(3):Disable()
      oReport:Section("Seção 1"):Cell(4):Disable()
      oReport:Section("Seção 1"):Cell(5):Disable()
      oReport:Section("Seção 1"):Cell(8):Disable()
      oReport:Section("Seção 1"):Init()
      
      oReport:aFunction[1]:Disable()
      oSection:SetTotalText("")
   EndIf
      
   oReport:Section("Seção 1"):PrintLine() //Impressão da linha
   oReport:IncMeter()                     //Incrementa a barra de progresso

   DET->( dbSkip() )
EndDo

//Fim da impressão da seção 1
oReport:Section("Seção 1"):Finish()
//Fim da impressão da seção 2
oReport:Section("Seção 2"):Finish()

Return .T.
                                    
// JPA - 08/08/2006 - Converte uma String formatada para número
************************************
Static Function ConvertNum(sNum)
************************************
Local nNum

sNum := StrTran(sNum, ".", "")
sNum := StrTran(sNum, ",", ".")

nNum := Val(sNum)

return nNum
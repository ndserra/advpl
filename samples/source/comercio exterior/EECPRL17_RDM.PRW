//Revisão - Alcir Alves - 05-12-05 - consideração do novo campo padrão EEQ_TP_CON, caso o mesmo exista apenas consider dados com tipo ='1' 
#INCLUDE "EECPRL17.ch"
/*
Programa        : EECPRL17.PRW
Objetivo        : RELATORIO RECYABLE ACCOUNT STATEMENT
Autor           : eferson Barros Jr.
Data/Hora       : 15/08/2001 - 13:33
Obs.            : Arquivo - EECPRL17.RPT
Revisão         : Juliano Paulino Alves - Relatório personalisável - Release 4
Data/Hora       : 28/07/06 11:20
*/                          											

#Include  "TOPCONN.CH"
#include  "EECRDM.CH"

/*
Funcao      : EECPRL17
Objetivos   : Ajustar o relatório para a versão 811 - Release 4
Autor       : Juliano Paulino Alves - JPA
Data 	    : 28/07/2006
Obs         :
Revisão     :
*/
**********************
User Function EECPRL17
**********************
lRet := U_EECP17R3(.T.)
RETURN lRet

*---------------------------
User Function EECP17R3(p_R4)  
*---------------------------
Local aArqs,aRetCrw, cQry,;
      lRet     := .T.

Local aOrd     := SaveOrd({"EEC","SA1"}),;
      cNomDBFC := "IPAS_3MC"
   
Local aCamposC := {{"WKSEQREL  ","C",08,0},;
                   {"WKCHAVE   ","C",15,0},;
                   {"WKIMPORT"  ,"C",AVSX3("EEC_IMPORT",AV_TAMANHO),0},;
                   {"WKIMPODE  ","C",60,0},;
                   {"WKPERIODO ","C",60,0},;
                   {"WKLBLMOEDA","C",15,0},;
                   {"WKMOEDA   ","C",20,0},;
                   {"WKCODFILIA","C",02,0}}
     
Local cNomDBFD := "IPAS_3MD",;
      aCamposD := {{"WKSEQREL  ","C",08,0},;
                   {"WKCHAVE   ","C",15,0},;
                   {"WKIMPORT"  ,"C",AVSX3("EEC_IMPORT",AV_TAMANHO),0},;
                   {"WKNRINVO  ","C",20,0},{"WKIMPODE  ","C",60,0},; 
                   {"WKDTINVO  ","C",08,0},{"WKCBVCT   ","C",08,0},;
                   {"WKDTEMBA  ","C",08,0},{"WKPREEMB  ","C",20,0},;
                   {"WKCBPGT   ","C",08,0},{"WKTOTPED  ","N",15,2},;  // By JPP - 30/09/04 09:22
                   {"WKCBNR    ","C",20,0},{"WKTOTOPEN ","C",15,0},;  //"N",15,2},;
                   {"WKFLAG    ","C",01,0},{"WKTOTCLOS ","C",15,0},;  //"N",15,2},;
                   {"WKPERIODO ","C",21,0},{"WKMOEDA   ","C",AVSX3("EEC_MOEDA" ,AV_TAMANHO),0}}

Private cArqRpt, cTitRpt,;
        dDtIni   := dDtFim   := AVCTOD("  /  /    "),;
        cImport  := Space(AVSX3("A1_COD",3)),;
        cMoeda := Space(AVSX3("YF_MOEDA",AV_TAMANHO)),;
        oGetImp,;
        oGetMoeda,;
        cNomeImp := Space(AVSX3("A1_NOME",AV_TAMANHO)),;
        oGetNomeImp,;
        lEvento := .F. 

//Alcir Alves - 05-12-05
Private lTPCONExt:=(EEQ->(fieldpos("EEQ_TP_CON"))>0)

//JPA - 28/07/2006 - Relatório Personalizavel - Release 4
Private oReport
Private lR4 := If(p_R4 == NIL,.F.,.T.) .AND. FindFunction("TRepInUse") .And. TRepInUse()

Private lZero  := .T.

Begin Sequence

   If Select("WorkId") > 0
      cArqRpt := WorkId->EEA_ARQUIV
      cTitRpt := AllTrim(WorkId->EEA_TITULO)
   EndIf
   
   If ! TelaGets()
      lRET := .F.
      Break
   EndIf

   If EECFlags("FRESEGCOM") .And. EEQ->(FieldPos("EEQ_EVENT")) # 0 // JPP - 11/11/04 17:35 - Se o tratamento frete/seguro/comissão não estiver ativo. 
      lEvento := .T.  // Habilita o filtro pelo evento padrão "101"
   EndIf
   aARQS := {}
   AADD(aARQS,{cNomDBFC,aCamposC,"CAB","WKSEQREL+WKIMPORT"})
   AADD(aARQS,{cNomDBFD,aCamposD,"DET","WKSEQREL+WKIMPORT"})

   aRetCrw := CrwNewFile(aARQS)
   #IFDEF TOP
      IF TCSRVTYPE() <> "AS/400"
         MsAguarde({|| lRet := GravaDados() },STR0001) //"Aguarde"
      ELSE
   #ENDIF
         MsAguarde({|| GravaDBF()},STR0002)     //"Gravando arquivo temporário..."
         MsAguarde({|| lRet := GravaDados()},STR0001)     //"Aguarde"
   #IFDEF TOP
      ENDIF
   #ENDIF

   IF ( lZero )
      MSGINFO(STR0003, STR0004) //"Intervalo sem dados para impressão"###"Aviso"
      lRet := .f.
   Else
      If lR4      //JPA - 28/07/2006
         oReport := ReportDef()
      EndIf
   ENDIF

   If ( lRet )
      If lR4   //JPA - 28/07/2006
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

IF Select("Work_Men") > 0
   Work_Men->(E_EraseArq(cWork))
Endif              

RestOrd(aOrd)

Return(.F.)

/*
Funcao          : GravaDBF
Parametros      : Nenhum                  
Retorno         : .T.
Objetivos       : Gravar DBF com os registros para impressao
Autor           : Jeferson Barros Jr.
Data/Hora       : 15/08/2001 - 13:53
Revisao         :
Obs.            : 
*/
*-----------------------------------*
Static Function GravaDBF()
*-----------------------------------*
Local cWork, aSemSX3 := {}, aOrd:=SaveOrd({"EEC","EEQ"}),;
      cMacro:="", cMacro1:= "", lRet:= .T. 

Local aConds:={"!Empty(EEC->EEC_DTEMBA)  ",;
               "EEC->EEC_IMPORT = cImport",; 
               "EEQ->EEQ_PGT >= dDtini   ",;
               "EEQ->EEQ_PGT <= dDtfim",;
               "Empty(EEQ->EEQ_PGT)  "}

aSemSX3 := { {"EEC_FILIAL","C",AVSX3("EEC_FILIAL",AV_TAMANHO),0},;
             {"EEC_PREEMB","C",AVSX3("EEC_PREEMB",AV_TAMANHO),0},;
             {"EEC_IMPODE","C",AVSX3("EEC_IMPODE",AV_TAMANHO),0},;   
             {"EEC_IMPORT","C",AVSX3("EEC_IMPORT",AV_TAMANHO),0},;   
             {"EEC_NRINVO","C",AVSX3("EEC_NRINVO",AV_TAMANHO),0},;   
             {"EEC_DTEMBA","D",AVSX3("EEC_DTEMBA",AV_TAMANHO),0},;   
             {"EEC_DTINVO","D",AVSX3("EEC_DTINVO",AV_TAMANHO),0},;
             {"EEC_MOEDA" ,"C",AVSX3("EEC_MOEDA ",AV_TAMANHO),0},;
             {"EEQ_PREEMB","C",AVSX3("EEQ_PREEMB",AV_TAMANHO),0}} 

If EECFlags("FRESEGCOM") // JPP - 10/01/05 11:35
   AADD(aSemSX3,{"EEQ_IMPORT","C",AVSX3("EEQ_IMPORT",AV_TAMANHO),0})
   AADD(aSemSX3,{"EEQ_IMLOJA","C",AVSX3("EEQ_IMLOJA",AV_TAMANHO),0})    
EndIf

cWork  := E_CRIATRAB("EEQ",aSemSX3,"QRY")

If ! EECFlags("FRESEGCOM") // JPP - 30/09/04 11:30 - Se o tratamento frete/seguro/comissão não estiver ativo. Mantem o indice original. 
//   IndRegua("QRY",cWork+OrdBagExt(),"EEQ_VCT" ,"AllwayTrue()","AllwaysTrue()",STR0005) //"Processando Arquivo Temporario"
   IndRegua("QRY",cWork+OrdBagExt(),"EEC_IMPORT+DTos(EEQ_VCT)+EEQ_PREEMB" ,"AllwayTrue()","AllwaysTrue()",STR0005) //"Processando Arquivo Temporario"  - By JPP - 01/10/04 18:20
Else // Se o tratamento frete/seguro/comissão estiver ativo. Define um novo indice.
   IndRegua("QRY",cWork+OrdBagExt(),"EEQ_IMPORT+DTos(EEQ_VCT)+EEQ_PREEMB" ,"AllwayTrue()","AllwaysTrue()",STR0005) //"Processando Arquivo Temporario"
EndIf
Set Index to (cWork+OrdBagExt())

Begin Sequence

   EEQ->(dbSetOrder(1))     // Filial+Processo+Parcela
  
   If ! EECFlags("FRESEGCOM") // JPP - 30/09/04 15:00 - Se o tratamento frete/seguro/comissão não estiver ativo. Mantem gravação de dados original. 
      If !Empty(cImport)  
         EEC->(DbSetorder(6))  // Filial+Importador
         EEC->(DbSeek(XFilial("EEC")+cImport))  
         
         cMacro1:= aConds[2]                          //"EEC->EEC_IMPORT = cImport"
         If Empty(dDtini) .And. Empty(dDtFim)                               
            cMacro:= ".T."         
         Else         
            cMacro := If(!Empty(dDtini),aConds[5],"") // "Empty(EEQ->EEQ_PGT)  "
            cMacro += If(!Empty(dDtini) .Or. !Empty(dDtfim)," .Or. ","")                                    
            cMacro += If(!Empty(dDtini),aConds[3],"") //"EEQ->EEQ_PGT >= dDtini" 
            cMacro += If(!Empty(dDtini),If(!Empty(dDtfim)," .And. ",""),"")                      
            cMacro += If(!Empty(dDtfim),aConds[4],"") //"EEQ->EEQ_PGT <= dDtfim"
         EndIf     
      Else                                          
         EEC->(DbSetorder(12)) //Filial+Dta Embarque

         //EEC->(DbSeek(xFilial("EEC")+IF(!Empty(dDtIni),Dtos(dDtIni),"00000000"),.T.)) // By JPP 01/10/04 18:40
         EEC->(DbSeek(xFilial("EEC")+"00000000",.T.))   
         cMacro1:=".T."
         
         If Empty(dDtini) .And. Empty(dDtFim)                               
            cMacro:= aConds[1]                         //"!Empty(EEC->EEC_DTEMBA)  "
         Else  
            cMacro := If(!Empty(dDtini),aConds[5],"") // "Empty(EEQ->EEQ_PGT)  "
            cMacro += If(!Empty(dDtini) .Or. !Empty(dDtfim)," .Or. ","")                                                
            cMacro += If(!Empty(dDtini),aConds[3],"")  //"EEQ->EEQ_PGT >= dDtini"
            cMacro += If(!Empty(dDtini),If(!Empty(dDtfim)," .And. ",""),"")                      
            cMacro += If(!Empty(dDtfim),aConds[4],"")  //"EEQ->EEQ_PGT <= dDtfim"
         Endif        
      Endif
 
      Do While EEC->(!Eof()) .And. EEC->EEC_FILIAL == xFilial("EEC") .And. &cMacro1  
         EEQ->(DbSeek(xFilial("EEQ")+EEC->EEC_PREEMB))          
         // IF &cMacro       By JPP 01/10/04
         Do While EEQ->(!Eof() .And. EEQ_FILIAL == xFilial("EEQ")) .And. EEQ->EEQ_PREEMB == EEC->EEC_PREEMB 
            //Alcir Alves - 05-12-05 - considera apena tipo 1 - Exportação
            if lTPCONExt
               if EEQ->EEQ_TP_CON<>"1"
                  EEQ->(DBSKIP())
                  loop
               ENDIF
            endif
            //
            // Filtro pela data Inicial    
            If !Empty(dDtIni)
               If DTOS(EEQ->EEQ_VCT) < DTOS(dDtini) .and. ! Empty(EEQ->EEQ_VCT) //DFS - Alteração de PGT para VCT
                  EEQ->(DbSkip())
                  Loop
               EndIf
            EndIf
            // Filtro pela Data Final
            If !Empty(dDtFim)
               If DTOS(EEQ->EEQ_VCT) > DTOS(dDtFim) .And. ! Empty(EEQ->EEQ_VCT) //DFS - Alteração de PGT para VCT
                  EEQ->(DbSkip())
                  Loop
               EndIf
            EndIf
            QRY->(DbAppend())
            QRY->EEC_PREEMB:= EEC->EEC_PREEMB                     
            QRY->EEC_IMPODE:= EEC->EEC_IMPODE
            QRY->EEC_IMPORT:= EEC->EEC_IMPORT
            QRY->EEC_DTEMBA:= EEC->EEC_DTEMBA 
            QRY->EEC_NRINVO:= EEC->EEC_NRINVO
            QRY->EEC_DTINVO:= EEC->EEC_DTINVO             
            QRY->EEC_MOEDA := EEC->EEC_MOEDA            
            QRY->EEQ_VCT   := EEQ->EEQ_VCT
            QRY->EEQ_PGT   := EEQ->EEQ_PGT                        
            QRY->EEQ_VL    := EEQ->EEQ_VL
            QRY->EEQ_NROP  := EEQ->EEQ_NROP                    
            EEQ->(DbSkip())
         Enddo 
         //EndIf
         EEC->(DbSkip())
      EndDo         
   Else // Se o tratamento frete/seguro/comissão estiver ativo. Define nova gravação de dados.
      EEQ->(DbSeek(xFilial("EEQ")))
      Do While EEQ->(!Eof()) .And. EEQ->EEQ_FILIAL == xFilial("EEQ")   
         //Alcir Alves - 05-12-05 - considera apena tipo 1 - Exportação
         if lTPCONExt
            if EEQ->EEQ_TP_CON<>"1"
               EEQ->(DBSKIP())
               loop
            ENDIF
          endif
          //

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
         // Filtro pelo Evento
         If lEvento 
            If EEQ->EEQ_EVENT <> "101"  // Codigo de evento padrão 101 
               EEQ->(DbSkip())
               Loop
            EndIf
         EndIf   
         // Filtro pela data Inicial    
         If !Empty(dDtIni)
            If DTOS(EEQ->EEQ_VCT) < DTOS(dDtini) .and. ! Empty(EEQ->EEQ_VCT) //DFS - Alteração de PGT para VCT
               EEQ->(DbSkip())
               Loop
            EndIf
         EndIf
         // Filtro pela Data Final
         If !Empty(dDtFim)
            If DTOS(EEQ->EEQ_VCT) > DTOS(dDtFim) .And. ! Empty(EEQ->EEQ_VCT) //DFS - Alteração de PGT para VCT
               EEQ->(DbSkip())
               Loop
            EndIf
         EndIf
         QRY->(DbAppend())
         QRY->EEQ_PREEMB:= EEQ->EEQ_PREEMB                     
         QRY->EEQ_IMPORT:= EEQ->EEQ_IMPORT
         QRY->EEQ_IMLOJA:= EEQ->EEQ_IMLOJA
         QRY->EEQ_VCT   := EEQ->EEQ_VCT
         QRY->EEQ_PGT   := EEQ->EEQ_PGT                        
         QRY->EEQ_VL    := EEQ->EEQ_VL
         QRY->EEQ_NROP  := EEQ->EEQ_NROP 
         QRY->EEQ_MOEDA := EEQ->EEQ_MOEDA  
         EEQ->(DbSkip())   
      EndDo         
   EndIf
   RestOrd(aOrd)

End Sequence

QRY->(DbGoTop())

Return lRet

*-------------------------------------------------------------
Static Function GravaDados()
*-------------------------------------------------------------
Local lRet
Local cProcAnt := " ",lFlag := .t.       

#IFDEF TOP
   Local cQry   
#ENDIF
Local nValorOpen := 0, nValorClos := 0
Local cPict := AVSX3("EEC_TOTPED"  ,AV_PICTURE)
Local aSomaMoeda := {}, nInd       
Local cPreembAtu, cChave
lZero := .T.

Begin Sequence
  
   MsProcTxt(STR0006) //"Gerando relatório ..."
   #IFDEF TOP
      IF TCSRVTYPE() <> "AS/400"
         If ! EECFlags("FRESEGCOM") // JPP - 30/09/04 11:30 - Se o tratamento frete/seguro/comissão não estiver ativo. Mantem a select original. 
            cQRY := "SELECT EEC_NRINVO, EEC_DTINVO, EEQ_VCT, EEC_DTEMBA, EEC_PREEMB,"+;
                    " EEQ_VL, EEQ_PGT, EEQ_NROP, EEC_IMPORT, EEC_IMPODE, EEC_MOEDA "+;
                    " FROM "+RetSqlName("EEC")+" EEC, "+RetSqlName("EEQ")+" EEQ " 
            cQRY += "WHERE EEC.D_E_L_E_T_ <> '*' AND EEC_FILIAL = '"+xFilial("EEC")+"' AND"+;
                    " EEC_DTEMBA <> '        ' AND EEQ_PREEMB = EEC_PREEMB AND "+;
                    " EEQ.D_E_L_E_T_ <> '*' AND EEQ_FILIAL = '"+xFilial("EEQ")+"'"
    
            //Alcir Alves - 05-12-05 - considera apena tipo 1 - Exportação
            if lTPCONExt
                cQRY += " and EEQ_TP_CON='1'"
            endif
            //
        
            cWhere := "" 
            IF !Empty(cImport)
               cWhere += " AND EEC_IMPORT = '"+cImport+"'"
            Endif
            IF !Empty(dDtIni) .Or. !Empty(dDtFim)
               cWhere += " AND (EEQ_VCT = '        ' OR"         //DFS - Alteração de PGT para VCT
               IF !Empty(dDtIni)
                  cWhere += " EEQ_VCT >= '"+Dtos(dDtIni)+"'"     //DFS - Alteração de PGT para VCT
                  IF !Empty(dDtFim)
                     cWhere += " AND"
                  Endif
               Endif
               IF !Empty(dDtFim)
                  cWhere += " EEQ_VCT <= '"+Dtos(dDtFim)+"'"    //DFS - Alteração de PGT para VCT
               Endif           
               cWhere += ")"  
            Endif
            cQRY += cWhere
            cQRY += " ORDER BY EEC_IMPORT, EEQ_VCT, EEQ_PREEMB"       
         Else // Se o tratamento frete/seguro/comissão estiver ativo. Define uma nova select.
            cQRY := "SELECT EEQ_PREEMB, EEQ_VCT, EEQ_VL, EEQ_PGT, EEQ_NROP, EEQ_IMPORT, EEQ_IMLOJA, EEQ_MOEDA "+;
                    " FROM "+RetSqlName("EEQ")+" EEQ " 
            cQRY += "WHERE EEQ.D_E_L_E_T_ <> '*' AND EEQ_FILIAL = '"+xFilial("EEQ")+"'"
            //Alcir Alves - 05-12-05 - considera apena tipo 1 - Exportação
            if lTPCONExt
                cQRY += " and EEQ_TP_CON='1'"
            endif
            //
            cWhere := "" 
            cWhere := cWhere + " AND EEQ_TIPO = 'R' "   // Titulos a receber  
            If lEvento 
               cWhere := cWhere + " AND EEQ_EVENT = '101' "  // Código de Evento padrão 101
            EndIf  
            If !Empty(cMoeda) 
               cWhere := cWhere + " AND EEQ_MOEDA = '" + cMoeda + "' "
            EndIf 
            If !Empty(cImport)
               cWhere := cWhere + " AND EEQ_IMPORT = '" + cImport + "' "   
            EndIf   
            IF !Empty(dDtIni) .Or. !Empty(dDtFim)
               cWhere += " AND (EEQ_VCT = '        ' OR"  //DFS - Alteração de PGT para VCT
               IF !Empty(dDtIni)
                  cWhere += " EEQ_VCT >= '"+Dtos(dDtIni)+"'"   //DFS - Alteração de PGT para VCT
                  IF !Empty(dDtFim)
                     cWhere += " AND"
                  Endif
               Endif
               IF !Empty(dDtFim)
                  cWhere += " EEQ_VCT <= '"+Dtos(dDtFim)+"'"  //DFS - Alteração de PGT para VCT
               Endif           
               cWhere += ")"  
            Endif 
            cQRY += cWhere
            cQRY += " ORDER BY EEQ_IMPORT, EEQ_VCT, EEQ_PREEMB"
         EndIf
         cQRY := ChangeQuery(CQRY)
         DbUseArea(.T., "TOPCONN", TCGENQRY(,,cQRY),"QRY",.F.,.T.)
      ELSE
   #ENDIF
         //... DBF ...
   #IFDEF TOP
      ENDIF
   #ENDIF
   cSEQREL  := GetSXENum("SY0","Y0_SEQREL")
   CONFIRMSX8()

   MsProcTxt(STR0006)   //"Gerando relatório ..."
    
   cImportAtu := ""
   
   If EECFlags("FRESEGCOM") // JPP - 30/09/04 15:42 - Se o tratamento frete/seguro/comissão estiver ativo. Define indice da tabela EEC. 
      EEC->(DbSetorder(1))  // Filial+Preemb
      cPreembAtu := ""
   EndIf   
   Do While ! QRY->(Eof())         
      If ! EECFlags("FRESEGCOM") // JPP - 30/09/04 15:42 - Se o tratamento frete/seguro/comissão não estiver ativo. Mantem a gravação de dados original. 
      CAB->(DbAppend())  
      CAB->WKSEQREL  := cSeqRel
         CAB->WKCHAVE     := "_ITENS"  // JPP - 30/09/04 11:30
      CAB->WKIMPORT  := QRY->EEC_IMPORT 
      CAB->WKIMPODE  := QRY->EEC_IMPODE
         CAB->WKPERIODO := IF(Empty(dDtIni).And.Empty(dDtFim),STR0011,Dtoc(dDtIni)+STR0012+Dtoc(dDtFim)) //"ALL"###" TO "

      cImportAtu := QRY->EEC_IMPORT

      lRet := .T.
      
      Do While ! QRY->(Eof()) .And. cImportAtu == QRY->EEC_IMPORT         
         
         DET->(DbAppend())
         DET->WKSEQREL  := CAB->WKSEQREL
            DET->WKCHAVE    := "_ITENS" // JPP - 30/09/04 11:30
         DET->WKIMPORT  := CAB->WKIMPORT
         DET->WKIMPODE  := QRY->EEC_IMPODE
         DET->WKPERIODO := IF(Empty(dDtIni).And.Empty(dDtFim),STR0011,Dtoc(dDtIni)+STR0012+Dtoc(dDtFim)) //"ALL"###" TO "
         DET->WKNRINVO  := QRY->EEC_NRINVO        
         #IFDEF TOP
            IF TCSRVTYPE() <> "AS/400"
                  DET->WKDTINVO := If(!Empty(QRY->EEC_DTINVO),TransData(QRY->EEC_DTINVO),"")
                  DET->WKCBVCT  := If(!Empty(QRY->EEQ_VCT),TransData(QRY->EEQ_VCT),"")
                  DET->WKDTEMBA := If(!Empty(QRY->EEC_DTEMBA),TransData(QRY->EEC_DTEMBA),"")
                  DET->WKCBPGT  := If(!Empty(QRY->EEQ_PGT),TransData(QRY->EEQ_PGT),"")
            ELSE
         #ENDIF
                  DET->WKDTINVO := If(!Empty(QRY->EEC_DTINVO),Dtoc(QRY->EEC_DTINVO),"")
                  DET->WKCBVCT  := If(!Empty(QRY->EEQ_VCT),Dtoc(QRY->EEQ_VCT),"")
                  DET->WKDTEMBA := If(!Empty(QRY->EEC_DTEMBA),Dtoc(QRY->EEC_DTEMBA),"")
                  DET->WKCBPGT  := If(!Empty(QRY->EEQ_PGT),Dtoc(QRY->EEQ_PGT),"")
         #IFDEF TOP
            ENDIF
         #ENDIF
         DET->WKPREEMB := QRY->EEC_PREEMB                 
         DET->WKTOTPED := QRY->EEQ_VL
         DET->WKCBNR   := QRY->EEQ_NROP

         IF cProcAnt <> QRY->EEC_PREEMB
            cProcAnt := QRY->EEC_PREEMB        
            lFlag    := ! lFlag
         Endif

         DET->WKFLAG  := IF(lFlag,"1","0")
            DET->WKMOEDA    := QRY->EEC_MOEDA
            nValorClos := 0
            nValorOpen := 0
         
         If !Empty(QRY->EEQ_PGT)
               nValorClos := DET->WKTOTPED
               DET->WKTOTCLOS := Transform(nValorClos,cPict)
         Else
               nValorOpen := DET->WKTOTPED
               DET->WKTOTOPEN := Transform(nValorOpen,cPict)
            EndIF          
            nInd :=Ascan(aSomaMoeda,{|aParamet| aParamet[1] = DET->WKMOEDA}) // By JPP 30/09/04 10:28 - Efetua a somatória dos valores para cada moeda.
            If nInd > 0
               aSomaMoeda[nInd,2] := aSomaMoeda[nInd,2] + nValorOpen 
               aSomaMoeda[nInd,3] := aSomaMoeda[nInd,3] + nValorClos
            Else
               AADD(aSomaMoeda,{DET->WKMOEDA,nValorOpen,nValorClos})
         EndIF          
                  
         lZero := .F.
         
         QRY->(dbSkip())
      Enddo      
      Else // Se o tratamento frete/seguro/comissão não estiver ativo. Efetua uma nova gravacao de dados.
         If cPreembAtu <> QRY->EEQ_PREEMB 
            cPreembAtu := QRY->EEQ_PREEMB //DFS - Atribuição do valor, antes estava comparando
            If ! EEC->(DbSeek(XFilial("EEC")+cPreembAtu))
               Do While cPreembAtu == QRY->EEQ_PREEMB
                  QRY->(Dbskip())
                  Loop
               EndDo
               Loop
            EndIf 
         EndIf         
         CAB->(DbAppend())  
         CAB->WKSEQREL  := cSeqRel 
         CAB->WKCHAVE     := "_ITENS"  // JPP - 30/09/04 11:30
         CAB->WKIMPORT  := EEC->EEC_IMPORT 
         cChave := QRY->EEQ_IMPORT + QRY->EEQ_IMLOJA 
         CAB->WKIMPODE  := Posicione("SA1",1,xFilial("SA1")+cChave,"A1_NOME") 
         CAB->WKLBLMOEDA:= "CURRENCY:"
         CAB->WKMOEDA   := IF(Empty(cMoeda),STR0011,cMoeda) //"ALL"
         CAB->WKPERIODO := IF(Empty(dDtIni).And.Empty(dDtFim),STR0011,Dtoc(dDtIni)+STR0012+Dtoc(dDtFim)) //"ALL"###" TO "

         cImportAtu := QRY->EEQ_IMPORT
         lRet := .T.
         Do While ! QRY->(Eof()) .And. cImportAtu == QRY->EEQ_IMPORT         
            If cPreembAtu <> QRY->EEQ_PREEMB 
               cPreembAtu := QRY->EEQ_PREEMB //DFS - Atribuição do valor, antes estava comparando
               If ! EEC->(DbSeek(XFilial("EEC")+cPreembAtu))
                  Do While cPreembAtu == QRY->EEQ_PREEMB
                     QRY->(Dbskip())
                     Loop
                  EndDo
                  Loop
               EndIf   
            EndIf         
            DET->(DbAppend())
            DET->WKSEQREL  := CAB->WKSEQREL
            DET->WKCHAVE    := "_ITENS" 
            DET->WKIMPORT  := CAB->WKIMPORT
            cChave := QRY->EEQ_IMPORT + QRY->EEQ_IMLOJA 
            DET->WKIMPODE  := Posicione("SA1",1,xFilial("SA1")+cChave,"A1_NOME") 
            DET->WKPERIODO := IF(Empty(dDtIni).And.Empty(dDtFim),STR0011,Dtoc(dDtIni)+STR0012+Dtoc(dDtFim)) //"ALL"###" TO "
            DET->WKNRINVO  := EEC->EEC_NRINVO    
            //DFS - 21/01/13 - Inclusão de tratamento para impressão das datas de embarque e data da invoice
            DET->WKDTEMBA := If(!Empty(EEC->EEC_DTEMBA),TransData(DtoS(EEC->EEC_DTEMBA)),"")
            DET->WKDTINVO := If(!Empty(EEC->EEC_DTINVO),TransData(DtoS(EEC->EEC_DTINVO)),"")       
            #IFDEF TOP
               IF TCSRVTYPE() <> "AS/400"
                  DET->WKCBVCT  := If(!Empty(QRY->EEQ_VCT),TransData(QRY->EEQ_VCT),"")
                  DET->WKCBPGT  := If(!Empty(QRY->EEQ_PGT),TransData(QRY->EEQ_PGT),"")
               ELSE
            #ENDIF
                  DET->WKCBVCT  := If(!Empty(QRY->EEQ_VCT),Dtoc(QRY->EEQ_VCT),"")
                  DET->WKCBPGT  := If(!Empty(QRY->EEQ_PGT),Dtoc(QRY->EEQ_PGT),"")
            #IFDEF TOP
               ENDIF
            #ENDIF
            DET->WKPREEMB := QRY->EEQ_PREEMB                 
            DET->WKTOTPED := QRY->EEQ_VL
            DET->WKCBNR   := QRY->EEQ_NROP
            IF cProcAnt <> QRY->EEQ_PREEMB
               cProcAnt := QRY->EEQ_PREEMB        
               lFlag    := ! lFlag
            Endif
            DET->WKFLAG  := IF(lFlag,"1","0")     
            DET->WKMOEDA    := QRY->EEQ_MOEDA
            nValorClos := 0
            nValorOpen := 0
            If !Empty(QRY->EEQ_PGT)             
               nValorClos := DET->WKTOTPED
               DET->WKTOTCLOS := Transform(nValorClos,cPict)
            Else
               nValorOpen := DET->WKTOTPED
               DET->WKTOTOPEN := Transform(nValorOpen,cPict)
            EndIF          
            nInd :=Ascan(aSomaMoeda,{|aParamet| aParamet[1] = DET->WKMOEDA}) //  Efetua a somatória dos valores para cada moeda.
            If nInd > 0
               aSomaMoeda[nInd,2] := aSomaMoeda[nInd,2] + nValorOpen 
               aSomaMoeda[nInd,3] := aSomaMoeda[nInd,3] + nValorClos
            Else
               AADD(aSomaMoeda,{DET->WKMOEDA,nValorOpen,nValorClos})
            EndIf       
            lZero := .F.
            QRY->(dbSkip())
         Enddo      
      EndIf   
      For nInd := 1 to len(aSomaMoeda)       // Grava os dados do subrelatório
          DET->(DbAppend())
          DET->WKSEQREL    := CAB->WKSEQREL
          DET->WKCHAVE     := "_SUB_TOTMOEDA"
          DET->WKIMPORT    := CAB->WKIMPORT 
          DET->WKIMPODE    := CAB->WKIMPODE
          DET->WKMOEDA     := aSomaMoeda[nInd,1]
          DET->WKTOTOPEN := If(aSomaMoeda[nInd,2] <> 0,Transform(aSomaMoeda[nInd,2],cPict),"") 
          DET->WKTOTCLOS := If(aSomaMoeda[nInd,3] <> 0,Transform(aSomaMoeda[nInd,3],cPict),"")  
      next 
      ASize(aSomaMoeda,0)
   EndDo

   QRY->(dbCloseArea())
  
End Sequence

Return lRet

*--------------------------------------------------------------------         
STATIC FUNCTION TELAGETS
*--------------------------------------------------------------------
Local oDlg,;
      bOk     := {|| nOpc := 1,if(fConfData(dDtFim,dDtIni),oDlg:End(),"")},;
      bCancel := {|| oDlg:End() },;
      lRet    := .f.,;
      nOpc    := 0,;
      nLin, nCol    // By JPP - 29/09/04 16:20
                               
Begin Sequence
   if ! EECFlags("FRESEGCOM")    //  By JPP - 27/09/04 09:40 - Se o tratamento frete/seguro/comissão não estiver ativo. Mantém a tela original.
      nLin := 19
      nCol := 44.5
   Else // // Se o tratamento frete/seguro/comissão estiver ativo., define a nova tela. 
      nLin := 20.5
      nCol := 44.5
   EndIf
   Define MsDialog oDlg Title cTITRPT From 9,0 To nLin+2,nCol+4 Of oMainWnd //FSM - 18/07/2011
      if ! EECFlags("FRESEGCOM")    // By JPP - 27/09/04 09:40 - Se o tratamento frete/seguro/comissão não estiver ativo. Mantém a tela original.
      @ 15,09 Say STR0008 Pixel //"Importador"
      @ 15,49 MsGet cImport Size 40,8 Valid(Empty(cImport).or.ExistCpo("SA1")) F3("SA1") Pixel

         @ 30,05 To 71,173 Label STR0013 Pixel  //"Período"
      
      @ 39,09 Say STR0009      Pixel //"Data Inicial"
      @ 39,49 MsGet dDtIni Size 40,8  Pixel
      
      @ 52,09 Say STR0010        PIXEL //"Data Final"
      @ 52,49 MsGet dDtFim Size 40,8  PIXEL //Valid(fConfData(dDtFim,dDtIni)) Pixel
      Else // Se o tratamento frete/seguro/comissão estiver ativo., define a nova tela. 
         @ 15,08 Say STR0014 Pixel // "Moeda"  
         @ 15,42 MsGet oGetMoeda Var cMoeda F3 "SYF" Valid (Empty(cMoeda) .or. ExistCPO("SYF")) Size 20,8 Pixel
         @ 27,08 Say STR0008 Pixel //"Importador"
         @ 27,42 MsGet cImport Size 20,8 Valid(Empty(cImport).or. ExistCpo("SA1") .And. TipoCorreto()) F3("SA1") Pixel
         @ 39,08 Say STR0015 Pixel  // "Descrição" 
         @ 39,42 MsGet oGetNomeImp Var cNomeImp Size 120,8 Pixel  
         @ 52,03 To 86,173 Label STR0013 Pixel  //"Período"
         @ 60,08 Say STR0009      Pixel //"Data Inicial"
         @ 60,42 MsGet dDtIni Size 40,8  Pixel
         @ 72,08 Say STR0010        PIXEL //"Data Final"
         @ 72,42 MsGet dDtFim Size 40,8  PIXEL //Valid(fConfData(dDtFim,dDtIni)) Pixel
         oGetNomeImp:Disable() 
      EndIf

   Activate MsDialog oDlg On Init EnchoiceBar(oDlg,bOk,bCancel) Centered
  
   If nOpc == 1
      lRet  := .t.
   EndIf 

End Sequence

Return(lRet)
*--------------------------------------------------------------------   
Static Function fConfData(dFim,dIni)
Local lRet  := .f.

Begin Sequence

    If !Empty(dFim) .or. !Empty(dIni) 
       If dFim < dIni .or. Empty(dIni)    
          MsgInfo(STR0007,STR0004) //"Data Final Não Pode Ser Menor Que Data Inicial"###"Aviso"
          lRet := .f.
       Else
          lRet := .t.
       EndIf   
     Else
       lRet := .t.
     EndIf
     
End Sequence

Return(lRet)

#IFDEF TOP
   *-----------------------------------*
   Static Function TransData(sData)
   *-----------------------------------*
   If Empty(sData)
      sData := "  /  /  "
   Else
      sData := SubStr(AllTrim(sData),7,2) + "/" + SubStr(AllTrim(sData),5,2) + "/" +   SubStr(AllTrim(sData),3,2)
   Endif

   Return sData
#ENDIF
/*
Funcao      : TipoCorreto()
Parametros  : 
Retorno     : .T. ou .F.
Objetivos   : Definir se o tipo selecionado é Importador ou Todos.
Autor       : Julio de Paula Paz
Data/Hora   : 29/09/04 17:30.
*/
Static Function TipoCorreto()
Local lRet := .f.
If SA1->A1_TIPCLI = "1" .Or. SA1->A1_TIPCLI = "4"   // "1" = "Importador" - "4" = "Todos" 
   cNomeImp := SA1->A1_NOME
   lRet := .t.
Else
   MsgInfo(STR0016+ENTER; // "Importador Inválido! "
          +STR0017+ENTER; // "Selecionar um Importador que esteja cadastrado como "
          +STR0018)       // "Importador ou Todos!"  
   cNomeImp := Space(AVSX3("A1_NOME",AV_TAMANHO))
   oGetNomeImp:Refresh()
EndIf
Return lRet

//JPA - 28/07/2006 - Definições do relatório personalizável
****************************
Static Function ReportDef()
****************************
Local cTitulo := "International Recyable Account Statement"
Local cDescr  := "International Recyable Account Statement"
//Alias que podem ser utilizadas para adicionar campos personalizados no relatório
aTabelas := {"EEQ", "EEC"}

//Array com o titulo e com a chave das ordens disponiveis para escolha do usuário
aOrdem   := {}

//Parâmetros:            Relatório , Titulo ,  Pergunte , Código de Bloco do Botão OK da tela de impressão.
oReport := TReport():New("EECPRL17", cTitulo ,"", {|oReport| ReportPrint(oReport)}, cDescr)

//ER - 20/10/2006 - Inicia o relatório como paisagem.
oReport:oPage:lLandScape := .T.
oReport:oPage:lPortRait := .F.

//Define os objetos com as seções do relatório
oSecao1 := TRSection():New(oReport,"Seção 1",aTabelas,aOrdem)
oSecao2 := TRSection():New(oReport,"Seção 2",{"CAB"},{})  // JPA - 04/08/06

//Definição das colunas de impressão da seção 1
TRCell():New(oSecao1,"WKNRINVO" , "DET", "Invoice"    , /*Picture*/        , 030 						   , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"WKDTINVO" , "DET", "Date"       , /*Picture*/        , 008        				   , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"WKCBVCT"  , "DET", "Due Date"   , /*Picture*/        , 008         				   , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"WKDTEMBA" , "DET", "Shippment"  , /*Picture*/        , 008         				   , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"WKPREEMB" , "DET", "Process"    , /*Picture*/        , 020 						   , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"WKMOEDA"  , "DET", "Currency"   , /*Picture*/        , AVSX3("EEC_MOEDA" ,AV_TAMANHO), /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"WKTOTOPEN", "DET", "Open"       , /*Picture*/        , 015						   , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"WKTOTCLOS", "DET", "Closed"     , /*Picture*/        , 015 						   , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"WKCBPGT"  , "DET", "Payment Day", /*Picture*/        , 008        				   , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"WKCBNR"   , "DET", "Exchange N.", /*Picture*/        , 020 						   , /*lPixel*/, /*{|| code-block de impressao }*/)


// JPA - 04/08/06 - Definição das colunas de impressão da seção 2
TRCell():New(oSecao2,"WKIMPODE"  , "CAB", "Customer: "   , /*Picture*/, 030 , /*lPixel*/, /*{|| code-block de impressao }*/)
oReport:Section("Seção 2"):Cell("WKIMPODE"):SetCellBreak()

TRCell():New(oSecao2,"WKPERIODO", "CAB", "Period: "     , /*Picture*/, 030 , /*lPixel*/, /*{|| code-block de impressao }*/)
oReport:Section("Seção 2"):Cell("WKPERIODO"):SetCellBreak()

TRCell():New(oSecao2,"WKMOEDA"  , "CAB", "Currency: ", /*Picture*/, 020 , /*lPixel*/, /*{|| code-block de impressao }*/)
oReport:Section("Seção 2"):Cell("WKMOEDA"):SetCellBreak()
oReport:Section("Seção 2"):SetLineStyle()

oReport:bOnPageBreak :={||oReport:Section("Seção 2"):PrintLine()}

Return oReport


************************************
Static Function ReportPrint(oReport)
************************************
Local oSection := oReport:Section("Seção 1")

//Faz o posicionamento de outros alias para utilização pelo usuário na adição de novas colunas.
TRPosition():New(oReport:Section("Seção 1"),"EEC",1,{|| xFilial("EEC") + EEC->EEC_PREEMB})
TRPosition():New(oReport:Section("Seção 1"),"EEQ",1,{|| xFilial("EEQ") + EEC->EEC_PREEMB})

oReport:SetMeter(DET->(RecCount()))
CAB->(dbGoTop())
DET->(dbGoTop())

// JPA - 04/08/06 - Inicio da impressão da seção 2.
oReport:Section("Seção 2"):Init()
//Inicio da impressão da seção 1. Sempre que se inicia a impressão de uma seção é impresso automaticamente
//o cabeçalho dela.
oReport:Section("Seção 1"):Init()
cChave:= ""


//TRP-21/09/2006 às 14:15
//Laço principal
Do While CAB->(!EoF()) .And. !oReport:Cancel()
   Do While DET->(!EoF())  .And.  CAB->WKIMPORT == DET->WKIMPORT  .And. !oReport:Cancel()  
      If cChave <> DET->WKCHAVE .AND. DET->WKCHAVE == "_SUB_TOTMOEDA  "
         oReport:Section("Seção 1"):Finish()
         oReport:Section("Seção 1"):Cell(1):Disable()
         oReport:Section("Seção 1"):Cell(2):Disable()
         oReport:Section("Seção 1"):Cell(3):Disable()
         oReport:Section("Seção 1"):Cell(4):Disable()
         oReport:Section("Seção 1"):Cell(5):Disable()
         oReport:Section("Seção 1"):Cell(9):Disable()
         oReport:Section("Seção 1"):Cell(10):Disable()      
         oReport:Section("Seção 1"):Init()
      
      EndIf
   
      oReport:Section("Seção 1"):PrintLine() //Impressão da linha
   
     
      If cChave <> DET->WKCHAVE .AND. DET->WKCHAVE == "_SUB_TOTMOEDA  "
         oReport:Section("Seção 1"):Finish()
         oReport:Section("Seção 1"):Cell(1):Enable()
         oReport:Section("Seção 1"):Cell(2):Enable()
         oReport:Section("Seção 1"):Cell(3):Enable()
         oReport:Section("Seção 1"):Cell(4):Enable()
         oReport:Section("Seção 1"):Cell(5):Enable()
         oReport:Section("Seção 1"):Cell(9):Enable()
         oReport:Section("Seção 1"):Cell(10):Enable()      
         oReport:Section("Seção 1"):Init()
      EndIf
   
      oReport:IncMeter()                     //Incrementa a barra de progresso
      cChave:= DET->WKCHAVE
      DET->( dbSkip() )
   EndDo
   CAB->( DBSkip() )
   If !DET->( EoF() )
      oReport:EndPage()
   EndIf
EndDo

//Fim da impressão da seção 1
oReport:Section("Seção 1"):Finish()
//Fim da impressão da seção 2
oReport:Section("Seção 2"):Finish()                                

return .T.
/*---------------------------------------------------------------------------------
                          FIM DO PROGRAMA
----------------------------------------------------------------------------------*/

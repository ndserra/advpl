#INCLUDE  "EECPRL23.CH"
#INCLUDE  "EECRDM.CH"

/*                                                                             
Funcao      : EECPRL23
Parametros  : Nenhum                                                       
Retorno     : .F.
Objetivos   : Adiantamento Sem Vinculação - Listar todos os adiantamentos da fase de 
              Cliente e Pedido.
Autor       : Julio de Paula Paz
Data/Hora   : 06/10/04 - 10:10 
Revisao     : 
Obs.        : EECPRL23.RPT                           
*/

*-----------------------------------*
User Function EECPRL23()
*-----------------------------------*
Local lRet     := .f.
Local nOldArea := ALIAS()
Local aOrd     := SaveOrd({"EE9","EEC","EE7","SA1"})
Private aArqs, cCmd,cWhere,cOrder,cWork,;
        cNomDbfC := "REL23C",;
        aCamposC := {{"SEQREL    ","C",08,0},;
                     {"CHAVE     ","C",15,0},;
                     {"TITULO    ","C",100,0},;
                     {"MOEDA     ","C",20,0},;
                     {"IMPODE    ","C",60,0},;
                     {"SOMAVLRS  ","C",19,0},;
                     {"CODFILIAL ","C",02,0}},;
        cNomDbfD := "REL23D",;
        aCamposD := {{"SEQREL    ","C", 8,0},;
                     {"CHAVE     ","C",15,0},;
                     {"FASE      ","C",08,0},;
                     {"PROCESSO  ","C",AVSX3("EEC_PREEMB",AV_TAMANHO),0},;   
                     {"IMPODE    ","C",AVSX3("A1_NREDUZ",AV_TAMANHO),0},; 
                     {"PAIS      ","C",AVSX3("YA_DESCR" ,AV_TAMANHO),0},; 
                     {"MOEDA     ","C",AVSX3("EEC_MOEDA" ,AV_TAMANHO),0},; 
                     {"VALORVINC ","C",14,0},;
                     {"BANCO     ","C",AVSX3("A6_NREDUZ" ,AV_TAMANHO),0},;
                     {"DTCAMBIO  ","C",10,0},;
                     {"DTCREDITO ","C",10,0},; 
                     {"TAXA      ","C",10,0},; 
                     {"VALORRS   ","C",14,0},;
                     {"CONTRATO  ","C",AVSX3("EEQ_NROP" ,AV_TAMANHO),0},;
                     {"FLAG      ","C",01,0}}  

Private cArqRpt, cTitRpt
Private lZero    := .T.
Private cImport := Space(AVSX3("A1_COD",AV_TAMANHO))  
Private cMoeda := Space(AVSX3("YF_MOEDA",AV_TAMANHO))
Private cNomeImp := Space(AVSX3("A1_NOME",AV_TAMANHO))
Private oGetNomeImp, cProcAtu

Begin Sequence

   IF Select("WorkId") > 0
      cArqRpt := WorkId->EEA_ARQUIV
      cTitRpt := AllTrim(WorkId->EEA_TITULO)
   Else 
      cArqRpt := "REL23.RPT"
      cTitRpt := "RELATORIO DE ADIANTAMENTO SEM VINCULACAO"
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
      If TCSRVTYPE() <> "AS/400"
         If EECFlags("FRESEGCOM") // Se o tratamento frete/seguro/comissão estiver ativo. Lê os dados da tabela EEQ.  
            cCmd   := "SELECT EEQ_PREEMB, EEQ_SALDO,EEQ_DTNEGO, EEQ_DTCE, EEQ_NROP,EEQ_PGT, EEQ_FASE, EEQ_BANC,"
            cCmd   += " EEQ_AGEN, EEQ_NCON , EEQ_PARC, EEQ_IMPORT, EEQ_IMLOJA, EEQ_MOEDA "
            cCmd   += " FROM " + RetSqlName("EEQ")+" EEQ "
         
            cWhere := " WHERE EEQ.D_E_L_E_T_ <> '*'"
            cWhere += " AND EEQ_FILIAL = '"+xFilial("EEQ")+ "'" 
            cWhere += " AND EEQ_TIPO = 'A' AND (EEQ_FASE = 'C' OR EEQ_FASE = 'P')"
            cWhere += " AND EEQ_SALDO > 0"
            If !Empty(cMoeda) 
               cWhere := cWhere + " AND EEQ_MOEDA = '" + cMoeda + "' "
            EndIf
            If !Empty(cImport)
               cWhere := cWhere + " AND EEQ_IMPORT = '" + cImport + "' "   
            EndIf
            
            cOrder := " ORDER BY EEQ_PREEMB,EEQ_PARC"	
            
            cQuery := cCmd + cWhere + cOrder
         Else // Se o tratamento frete/seguro/comissão não estiver ativo. Lê os dados das tabelas SA1 e EE7. 
            cCmd   := " SELECT EEQ_PREEMB, EEQ_SALDO, EEQ_DTNEGO, EEQ_DTCE, EEQ_NROP,EEQ_PGT,"
            cCmd   += " EEQ_FASE, EEQ_BANC, EEQ_AGEN, EEQ_NCON , EEQ_PARC,"
            cCmd   += " '     'AS EEQ_IMPORT, ' ' AS EEQ_IMLOJA, '  ' AS EEQ_MOEDA "
            cCmd   += " FROM " + RetSqlName("EEQ")+" EEQ " 
             
            cWhere := " WHERE EEQ.D_E_L_E_T_ <> '*'"
            cWhere += " AND EEQ_FILIAL = '"+xFilial("EEQ")+ "'" 
           
            cWhere += " AND EEQ_TIPO = 'A' AND (EEQ_FASE = 'C' OR EEQ_FASE = 'P')"           
            cWhere += " AND EEQ_SALDO > 0"
              
            cOrder := " ORDER BY EEQ_PREEMB,EEQ_PARC"	
    
            cQuery := cCmd + cWhere + cOrder
         EndIf
         cCmd := ChangeQuery(cQuery)
         dbUseArea(.T., "TOPCONN", TCGENQRY(,,cCmd), "QRY", .F., .T.) 
        
         TCSetField("QRY", "EEQ_DTNEGO", "D")
         TCSetField("QRY", "EEQ_DTCE", "D")
         TCSetField("QRY", "EEQ_PGT", "D")
         TCSetField("QRY", "EEQ_SALDO", "N",15,2)
         TCSetField("QRY", "EEQ_VL", "N",15,2)
        
         Processa({|| lRet := Imprimir() })
      Else
         // ** Grava arquivo temporário ...     
         GravaDBF()                 
         MsAguarde({||lRet := Imprimir()},STR0002) // "Imprimindo registros ..."                                                                    //"Imprimindo registros ..."
      EndIf
   #ELSE
      // ** Grava arquivo temporário ...     
      GravaDBF()                 
      MsAguarde({||lRet := Imprimir()},STR0002) // "Imprimindo registros ..."                                                                    //"Imprimindo registros ..."
   #ENDIF   
   
   //rotina principal
   cSEQREL :=GetSXENum("SY0","Y0_SEQREL")
   CONFIRMSX8()
  
   If ( lZero )
      MSGINFO(STR0003, STR0004) //"Intervalo sem dados para impressão"###"Aviso"
      lRet := .f.
   EndIf

   

   If ( lRet )
      lRetC := CrwPreview(aRetCrw,cArqRpt,cTitRpt,cSeqRel)
   Else  
      // Fecha e apaga os arquivos temporarios
      CrwCloseFile(aRetCrw,.T.)
   EndIf   
   
End Sequence  

/* Fecha e apaga arquivos temporarios */ 
#IFDEF TOP
   If Select("QRY") > 0
      QRY->(dbCloseArea())
   EndIf   
#ELSE
   If Select("QRY") > 0
      QRY->(E_EraseArq("QRY",cWork))
   EndIf
#ENDIF

dbSelectArea(nOldArea)

/* retorna a situacao anterior ao processamento */
RestOrd(aOrd)

Return (.F.)

/*
Funcao          : GravaDBF
Parametros      : Nenhum                  
Retorno         : .T.
Objetivos       : Gravar DBF com os registros para impressao
Autor           : Julio de Paula Paz
Data/Hora       : 06/10/04 - 15:00
Revisao         :
Obs.            : 
*/
*-----------------------------------*
Static Function GravaDBF()
*-----------------------------------* 
Local aSemSX3 := {}, lRet:= .T.   

aSemSX3 := {{"EEQ_PREEMB","C",AVSX3("EEQ_PREEMB",AV_TAMANHO),0}}

If EECFlags("FRESEGCOM") // JPP - 10/01/05 13:35
   AADD(aSemSX3,{"EEQ_IMPORT","C",AVSX3("EEQ_IMPORT",AV_TAMANHO),0})
   AADD(aSemSX3,{"EEQ_IMLOJA","C",AVSX3("EEQ_IMLOJA",AV_TAMANHO),0}) 
EndIf  

    
cWork  := E_CRIATRAB("EEQ",aSemSX3,"QRY")

IndRegua("QRY",cWork+OrdBagExt(),"EEQ_PREEMB+EEQ_PARC" ,"AllwayTrue()","AllwaysTrue()",STR0001) //"Processando Arquivo Temporario"

Set Index to (cWork+OrdBagExt())

Begin Sequence
  
   SA1->(DbSetOrder(1))  //Filial + Importador + Loja
   EE7->(DbSetOrder(1))  //Filial + Processo
   EEQ->(DbSetOrder(1))  //Filial + Preemb + Parcela        
   
   EEQ->(DbSeek(xFilial("EEQ")))
         
   Do While EEQ->(!Eof() .And. EEQ->EEQ_FILIAL == xFilial("EEQ")) 
      If EEQ->EEQ_TIPO <> "A"  // Adiantamentos
         EEQ->(DbSkip())
         Loop
      EndIf 
      If (EEQ->EEQ_FASE <> 'C' .And. EEQ->EEQ_FASE <> 'P') // Adiantamentos Fase de Cliente e Fase de Pedido
         EEQ->(DbSkip())
         Loop
      EndIf 
      If ! EEQ->EEQ_SALDO > 0  // O saldo deve ser maior que zero.
         EEQ->(DbSkip())
         Loop
      EndIf 

      If EECFlags("FRESEGCOM") // Se o tratamento frete/seguro/comissão estiver ativo. Lê os dados da tabela EEQ. 
         /* Filtro pelo importador.  */
         If !Empty(cImport) // Filtro para fase de pedido
            If EEQ->EEQ_IMPORT <> AvKey(cImport,"EEQ_IMPORT")
               EEQ->(DbSkip())
               Loop
            EndIf
         EndIf
         /* Filtro pela Moeda */            
         If !Empty(cMoeda) // Filtro para fase de pedido
            If EEQ->EEQ_MOEDA <> AvKey(cMoeda,"EEQ_MOEDA")
               EEQ->(DbSkip())
               Loop
            EndIf 
         EndIf
      Else // Se o tratamento frete/seguro/comissão não estiver ativo. Lê os dados das tabelas SA1 e EE7. 
         If EEQ->EEQ_FASE = "C"   // Fase de Cliente
            If ! SA1->(DbSeek(xFilial("SA1")+EEQ->EEQ_PREEMB)) // Efetua o link entre o adiantamento e o importador
               EEQ->(DbSkip())
               Loop
            EndIf 
            /* Filtro pelo importador.  */
            If !Empty(cImport) 
               If SA1->A1_COD <> AvKey(cImport,"A1_COD")
                  EEQ->(DbSkip())
                  Loop
               EndIf
            EndIf   
            /* Filtro pela Moeda */            
            If !Empty(cMoeda) 
               If SA1->A1_MOEDA <> AvKey(cMoeda,"A1_MOEDA")
                  EEQ->(DbSkip())
                  Loop
               EndIf
            EndIf   
         Else    // Fase de Pedido
            If ! EE7->(DbSeek(xFilial("EE7")+EEQ->EEQ_PREEMB)) // Efetua o link entre o adiantamento e o processo
               EEQ->(DbSkip())
               Loop
            EndIf
            /* Filtro pelo importador.  */
            If !Empty(cImport) // Filtro para fase de pedido
               If EE7->EE7_IMPORT <> AvKey(cImport,"EE7_IMPORT")
                  EEQ->(DbSkip())
                  Loop
               EndIf
            EndIf
            /* Filtro pela Moeda */            
            If !Empty(cMoeda) // Filtro para fase de pedido
               If EE7->EE7_MOEDA <> AvKey(cMoeda,"EE7_MOEDA")
                  EEQ->(DbSkip())
                  Loop
               EndIf
            EndIf
         EndIf   
      EndIf  

      QRY->(DbAppend())
      AvReplace("EEQ","QRY") 
      EEQ->(DbSkip())
   EndDo         

   QRY->(DbGoTop())   

End Sequence
Return lRet 

/*
Funcao          : Imprimir
Parametros      : Nenhum                  
Retorno         : .T. ou .F.
Objetivos       : Gravar os dados do relatorio em arquivos temporarios
                  que serão lidos pelo Crytal Reports.
Autor           : Julio de Paula Paz
Data/Hora       : 06/10/04 - 
Revisao         :
Obs.            : 
*/
*-----------------------------------*
Static Function Imprimir
*-----------------------------------*
Local lRet := .f., cChave, nOldArea 
Local nValorVinc := 0, nValorRs := 0,nSomaVlRs := 0, nTaxa, nSomaReg := 0
Local cPictVinc := Left(AVSX3("EEQ_SALDO", AV_PICTURE),3)+Right(AVSX3("EEQ_SALDO", AV_PICTURE),14)
Local cPictRs := Left(AVSX3("EEQ_VL", AV_PICTURE),3)+Right(AVSX3("EEQ_VL", AV_PICTURE),14)  
Local cPictTX := AVSX3("EEQ_TX", AV_PICTURE)
Local aSomaMoeda := {}, nInd, lFlag := .t.

Begin Sequence
              
   SA1->(DbSetOrder(1))  //Filial + Importador + Loja
   EE7->(DbSetOrder(1))  //Filial + Processo
      
   lZero := .t.
   #IFDEF TOP
      If TCSRVTYPE() <> "AS/400"  
         If EECFlags("FRESEGCOM") // Se o tratamento frete/seguro/comissão estiver ativo. Lê os dados da tabela EEQ.             
            cCmd   := "SELECT COUNT(*) AS NCOUNT"   
            cCmd   += " FROM " + RetSqlName("EEQ")+" EEQ " 
         
            cQuery := cCmd + cWhere 
         
            cCmd     := ChangeQuery(cQuery)
            nOldArea := Alias()
        
            dbUseArea(.T., "TOPCONN", TCGENQRY(,,cCmd), "QRYTEMP", .F., .T.)
            nSomaReg := QRYTEMP->NCOUNT
         Else
            cCmd   := "SELECT COUNT(*) AS NCOUNT"   
            cCmd   += " FROM " + RetSqlName("EEQ")+" EEQ "
         
            cQuery := cCmd + cWhere 
         
            cCmd     := ChangeQuery(cQuery)
            nOldArea := Alias()
        
            dbUseArea(.T., "TOPCONN", TCGENQRY(,,cCmd), "QRYTEMP", .F., .T.)
            nSomaReg := QRYTEMP->NCOUNT
         EndIf   
         ProcRegua(nSomaReg)
        
         QRYTEMP->(dbCloseArea())
         dbSelectArea(nOldArea)
      Else
        //... DBF ...
      EndIf
   #ELSE
      //... DBF ...
   #ENDIF
      
   CAB->(DBAPPEND())                     
   CAB->SEQREL  := cSeqRel
   CAB->CHAVE   := "_ITENS" 
   CAB->TITULO  := cTitRpt
   If !Empty(cMoeda)
      CAB->MOEDA := cMoeda
   Else
      CAB->MOEDA := STR0010 // "Todas"
   EndIf                                           
   If Empty(cImport)                     
      CAB->IMPODE := STR0009 // "Todos"  
   Else
      If EECFlags("FRESEGCOM") // Se o tratamento frete/seguro/comissão estiver ativo. Lê o importador dos campos QRY->EEQ_IMPORT+EEQ_IMLOJA.     
         cChave := QRY->EEQ_IMPORT + QRY->EEQ_IMLOJA
         CAB->IMPODE :=  Posicione("SA1",1,xFilial("SA1")+cChave,"A1_NREDUZ") 
      Else
         If QRY->EEQ_FASE = "C"   // Fase de Cliente
            SA1->(DbSeek(xFilial("SA1")+QRY->EEQ_PREEMB)) // Efetua o link entre o adiantamento e o importador
            CAB->IMPODE := SA1->A1_NREDUZ               
         Else    // Fase de Pedido
            EE7->(DbSeek(xFilial("EE7")+QRY->EEQ_PREEMB)) // Efetua o link entre o adiantamento e o processo
            cChave := EE7->EE7_IMPORT + EE7->EE7_IMLOJA
            CAB->IMPODE :=  Posicione("SA1",1,xFilial("SA1")+cChave,"A1_NREDUZ")       
         EndIf 
      EndIf      
   EndIf   
   cProcAtu = ""
      
   While QRY->(!Eof())
      #IFDEF TOP
         IF TCSRVTYPE() <> "AS/400"
            IncProc(STR0005 + QRY->EEQ_PREEMB) //"Imprimindo: "
           
            If ! EECFlags("FRESEGCOM") // Se o tratamento frete/seguro/comissão não estiver ativo. Lê os dados das tabelas SA1 e EE7.                         
               If QRY->EEQ_FASE = "C"   // Fase de Cliente
                  If ! SA1->(DbSeek(xFilial("SA1")+QRY->EEQ_PREEMB)) // Efetua o link entre o adiantamento e o importador
                     QRY->(DbSkip())
                     Loop
                  EndIf 
                  /* Filtro pelo importador.  */
                  If !Empty(cImport) 
                     If SA1->A1_COD <> AvKey(cImport,"A1_COD")
                        QRY->(DbSkip())
                        Loop
                     EndIf
                  EndIf   
                  /* Filtro pela Moeda */            
                  If !Empty(cMoeda) 
                     If SA1->A1_MOEDA <> AvKey(cMoeda,"A1_MOEDA")
                        QRY->(DbSkip())
                        Loop
                     EndIf
                  EndIf   
               Else    // Fase de Pedido
                  If ! EE7->(DbSeek(xFilial("EE7")+QRY->EEQ_PREEMB)) // Efetua o link entre o adiantamento e o processo
                     QRY->(DbSkip())
                     Loop
                  EndIf
                  /* Filtro pelo importador.  */
                  If !Empty(cImport) // Filtro para fase de pedido
                     If EE7->EE7_IMPORT <> AvKey(cImport,"EE7_IMPORT")
                        QRY->(DbSkip())
                        Loop
                     EndIf
                  EndIf
                  /* Filtro pela Moeda */            
                  If !Empty(cMoeda) // Filtro para fase de pedido
                     If EE7->EE7_MOEDA <> AvKey(cMoeda,"EE7_MOEDA")
                        QRY->(DbSkip())
                        Loop
                     EndIf
                  EndIf
               EndIf   
            EndIf 
         Else
            If QRY->EEQ_FASE = "C"   // Fase de Cliente
               If ! SA1->(DbSeek(xFilial("SA1")+QRY->EEQ_PREEMB)) // Efetua o link entre o adiantamento e o importador
                  QRY->(DbSkip())
                  Loop
               EndIf 
            Else    // Fase de Pedido
               If ! EE7->(DbSeek(xFilial("EE7")+QRY->EEQ_PREEMB)) // Efetua o link entre o adiantamento e o processo
                  QRY->(DbSkip())
                  Loop
               EndIf
            EndIf   
         EndIf
      #ELSE
         If QRY->EEQ_FASE = "C"   // Fase de Cliente
            If ! SA1->(DbSeek(xFilial("SA1")+QRY->EEQ_PREEMB)) // Efetua o link entre o adiantamento e o importador
               QRY->(DbSkip())
               Loop
            EndIf 
         Else    // Fase de Pedido
            If ! EE7->(DbSeek(xFilial("EE7")+QRY->EEQ_PREEMB)) // Efetua o link entre o adiantamento e o processo
               QRY->(DbSkip())
               Loop
            EndIf
         EndIf   
      #ENDIF

      DET->(DBAPPEND())
      DET->SEQREL   := cSeqRel  
      DET->CHAVE    := "_ITENS"     
      If cProcAtu <> QRY->EEQ_PREEMB
         cProcAtu = QRY->EEQ_PREEMB
    
         If QRY->EEQ_FASE = "P"
            DET->FASE     := "PROCESSO"  
            DET->PROCESSO := AllTrim(QRY->EEQ_PREEMB)
         Else
            DET->FASE     := "CLIENTE"
         EndIf    
         
         If EECFlags("FRESEGCOM") // Se o tratamento frete/seguro/comissão estiver ativo. Lê o importador dos campos QRY->EEQ_IMPORT+QRY->EEQ_IMLOJA.     
            cChave := QRY->EEQ_IMPORT + QRY->EEQ_IMLOJA
            DET->IMPODE := Posicione("SA1",1,xFilial("SA1")+cChave,"A1_NREDUZ")
            cChave := Posicione("SA1",1,xFilial("SA1")+cChave,"A1_PAIS") // Codigo do Pais      
         Else     
            If QRY->EEQ_FASE = "P" // Nome reduzido do importador fase de Pedido
               cChave := EE7->EE7_IMPORT + EE7->EE7_IMLOJA 
               DET->IMPODE := Posicione("SA1",1,xFilial("SA1")+cChave,"A1_NREDUZ") 
               cChave := Posicione("SA1",1,xFilial("SA1")+cChave,"A1_PAIS")  // Codigo do Pais    
            Else // Nome reduzido do importador fase de Cliente
               DET->IMPODE := SA1->A1_NREDUZ 
               cChave := SA1->A1_PAIS   // Codigo do Pais    
            EndIf
         EndIf      
      
         DET->PAIS  := Posicione("SYA",1,xFilial("SYA")+cChave,"YA_DESCR") 
         
         lFlag    := ! lFlag
      EndIf
      DET->FLAG := IF(lFlag,"1","0")
      If EECFlags("FRESEGCOM") // Se o tratamento frete/seguro/comissão estiver ativo. Lê a moeda do campo QRY->EEQ_MOEDA. 
         DET->MOEDA := QRY->EEQ_MOEDA 
      Else
         If QRY->EEQ_FASE = "P" // Recebe a moeda fase de pedido
            DET->MOEDA := EE7->EE7_MOEDA
         Else // Recebe a moeda fase de Cliente
            DET->MOEDA := SA1->A1_MOEDA                    
         EndIf
      EndIf   
      
      nValorVinc := QRY->EEQ_SALDO 
      DET->VALORVINC := Transform(nValorVinc,cPictVinc) 
      
      cChave := QRY->EEQ_BANC+QRY->EEQ_AGEN+QRY->EEQ_NCON
      DET->BANCO := Posicione("SA6",1,xFilial("SA6")+cChave,"A6_NREDUZ") 
      DET->DTCAMBIO  := Dtoc(QRY->EEQ_DTNEGO)
      DET->DTCREDITO := Dtoc(QRY->EEQ_DTCE)

      nTaxa := BuscaTaxa(DET->MOEDA,QRY->EEQ_PGT,,.f.)
      nValorRs := QRY->EEQ_SALDO * nTaxa
   
      DET->TAXA := Transform(nTaxa,cPictTx)
      DET->VALORRS := Transform(nValorRs,cPictRs)
      DET->CONTRATO := QRY->EEQ_NROP

      nSomaVlRs += nValorRs  // Totalizacao do valor em Reais.
  
      /* Totalização por moeda  */
      nInd :=Ascan(aSomaMoeda,{|aParamet| aParamet[1] = DET->MOEDA})  // Localiza a moeda no vetor aSomaMoeda.  
      If nInd > 0
         aSomaMoeda[nInd,2] := aSomaMoeda[nInd,2] + nValorVinc  // Soma o valor para moeda correspondente.
      Else
         AADD(aSomaMoeda,{DET->MOEDA,nValorVinc})  // Adiciona uma nova moeda e seu respectivo valor no vetor aSomaMoeda.
      EndIf   
     
      lZero := .f.
   
      QRY->(dbSkip())

      lRet := .t.           
   Enddo                              
   
   CAB->SOMAVLRS  := If(nSomaVlRs = 0,"",Transform(nSomaVlRs,cPictRs)) // Grava total dos valores em Reais 
   
   For nInd := 1 to Len(aSomaMoeda)  // Grava dados do sub-relatório.     
       DET->(DbAppend())    
       DET->SEQREL    := cSeqRel    
       DET->CHAVE     := "_SUB_TOTMOEDA"
       DET->MOEDA     := aSomaMoeda[nInd,1]
       DET->VALORVINC := Transform(aSomaMoeda[nInd,2],cPictVinc) 
   Next

End Sequence 

Return lRet
/*
Funcao      : TelaGets()
Parametros  : 
Retorno     : .T. ou .F.
Objetivos   : Montar e exibir a tela de filtros.
Autor       : Julio de Paula Paz
Data/Hora   : 06/10/04 14:43.
Revisão     : WFS - 31/05/12: ajuste de tela
*/
*-----------------------------------*
Static Function TelaGets()
*-----------------------------------*

Local lRet  := .f.
Local nOpc  := 0
Local bOk, bCancel
Local oPanel

Begin Sequence
 
   DEFINE MSDIALOG oDlg TITLE cTitRpt FROM 9,0 TO 16.5,40.5 OF oMainWnd
                        

      oPanel:= TPanel():New(0, 0, "",oDlg,, .F., .F.,,, 40.5, 7.5)

      @ 12,05 Say STR0006 Pixel Of oPanel // "Importador"  
      @ 11,38 MsGet oGetImp Var cImport Picture AVSX3("A1_COD", AV_PICTURE)  F3 "SA1" Valid (Empty(cImport) .or. ExistCPO("SA1") .And. TipoCorreto()) Size 20,8 Pixel Of oPanel
                 
      @ 23,05 Say STR0007 Pixel Of oPanel // "Descrição" 
      @ 22,38 MsGet oGetNomeImp Var cNomeImp Size 120,8 Pixel Of oPanel
                 
      @ 34,05 Say STR0008 Pixel Of oPanel // "Moeda"  
      @ 33,38 MsGet cMoeda Picture AVSX3("YF_MOEDA", AV_PICTURE)  F3 "SYF" Valid (Empty(cMoeda) .or. ExistCPO("SYF")) Size 20,8 Pixel Of oPanel
      
      oGetNomeImp:Disable()     
      
      oPanel:Align:= CONTROL_ALIGN_ALLCLIENT
      
      bOk     := {|| (nOpc:=1, oDlg:End())}
      bCancel := {|| oDlg:End() }
   
   ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,bOk,bCancel) CENTERED
   
   IF nOpc == 1
      lRet := .t.
   Endif 

End Sequence

Return lRet   

/*
Funcao      : TipoCorreto()
Parametros  : 
Retorno     : .T. ou .F.
Objetivos   : Definir se o tipo selecionado é Importador ou Todos.
Autor       : Julio de Paula Paz
Data/Hora   : 06/10/04 15:00.
*/
*-----------------------------------*
Static Function TipoCorreto()
*-----------------------------------*

Local lRet := .f.

If SA1->A1_TIPCLI = "1" .Or. SA1->A1_TIPCLI = "4"   // "1" = "Importador" - "4" = "Todos" 
   cNomeImp := SA1->A1_NOME
   lRet := .t.
Else
   MsgInfo(STR0011+ENTER;   //  "Importador Inválido! "
          +STR0012+ENTER;   //  "Selecionar um Importador que esteja cadastrado como "
          +STR0013)         //  "Importador ou Todos!"  
   cNomeImp := Space(AVSX3("A1_NOME",AV_TAMANHO))
   oGetNomeImp:Refresh()
EndIf

Return lRet  

*--------------------------------------------------------------------------------------*
*                       FIM DO RDMAKE PADRAO EECPRL23_RDM.PRW                          *
*--------------------------------------------------------------------------------------*          

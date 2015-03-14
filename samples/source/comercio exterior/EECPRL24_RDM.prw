#INCLUDE "EECRDM.CH"  
#INCLUDE "EECPRL24.CH"

/*
Programa  : EECPRL24_RDM.
Objetivo  : Relatório de Tabela de Preços
Autor     : João Pedro Macimiano Trabbold
Data/Hora : 13/10/04; 9:34 
Revisão   : Juliano Paulino Alves - Relatório personalisável - Release 4
Data/Hora : 07/08/06 09:40
*/

/*
Funcao      : EECPRL24
Objetivos   : Ajustar o relatório para a versão 811 - Release 4
Autor       : Juliano Paulino Alves - JPA
Data 	    : 07/08/2006
Obs         :
Revisão     :
*/
**********************
User Function EECPRL24
**********************
lRet := U_EECP24R3(.T.)
RETURN lRet

/*
Funcao      : EECP24R3().
Parametros  : Nenhum.
Retorno     : .f.
Objetivos   : Impressão do Relatório de Tabela de Preços
Autor       : João Pedro Macimiano Trabbold
Data/Hora   : 13/10/04; 9:34
Revisão     : Juliano Paulino Alves - Relatório personalisável - Release 4
Data/Hora   : 07/08/06 09:40 
*/
*-----------------------*
User Function EECP24R3(p_R4)
*-----------------------*   
Local   aOrd   := SaveOrd({"EX5","EX6","SB1","SYA","SYF","SA1"})
Private lRet   := .t. ,lApaga:= .f., lFlag:=.f.
Private cArqRpt:= "rel24.rpt",;
		  cTitRpt:= STR0001 //"Tabela de Preços"
Private aArqs,;
        cNomDbfC := "REL24C",;
        aCamposC := {{"SEQREL"  ,"C",08,0 },;
                     {"CLIENTE" ,"C",AvSx3("A1_NREDUZ" ,AV_TAMANHO),0 },;    
                     {"PRODUTO" ,"C",AvSx3("B1_DESC" ,AV_TAMANHO),0 },; 
                     {"MOEDA"   ,"C",AvSx3("YF_MOEDA",AV_TAMANHO)+2,0 },;
                     {"PAIS"    ,"C",AvSx3("YA_DESCR",AV_TAMANHO),0 },;
                     {"FLAG"    ,"C",1,0 }}
                     
Private cNomDbfD := "REL24D",;
        aCamposD := {{"SEQREL"  ,"C", 8,0},;
                     {"PRODUTO" ,"C",AvSx3("B1_COD"    ,AV_TAMANHO)+AvSx3("B1_DESC",AV_TAMANHO)+3,0 },;
                     {"PAIS"    ,"C",AvSx3("YA_DESCR"  ,AV_TAMANHO),0 },;
                     {"CLIENTE" ,"C",AvSx3("A1_NREDUZ" ,AV_TAMANHO),0 },;
                     {"MOEDA"   ,"C",AvSx3("YF_MOEDA"  ,AV_TAMANHO),0 },;
                     {"PRECO"   ,"C",AvSx3("EX5_PRECO" ,AV_TAMANHO)+7,0 },; 
                     {"FLAG"    ,"C",1,0 },;
                     {"FLAG2"   ,"C",1,0 }}
                                          
Private dDtIni         := AVCTOD("  /  /  "),;
        dDtFim         := AVCTOD("  /  /  "),; 
        dDtAprov       := AVCTOD("  /  /  "),;  
        aSituacao      := {STR0008,STR0009},; //{"Ativos","Aguardando Aprovacao"}
        cSituacao      := "",;  
        cCliente       := Space(AVSX3("A1_COD"   ,AV_TAMANHO)),;   
        cMoeda         := Space(AvSx3("EX5_MOEDA",AV_TAMANHO)),;
        cProduto       := Space(AvSx3("EX5_COD_I" ,AV_TAMANHO)),;
        cPais          := Space(AvSx3("EX5_PAIS",AV_TAMANHO)),;
        lProc          := .f. ,;
        cAlias         := ""  ,;
        lNovaRotina    := .f. ,;
        cLastSituation := ""  ,;
        aPrecos        := {}
        
//JPA - 07/08/2006 - Relatório Personalizavel - Release 4
Private oReport
Private lR4   := If(p_R4 == NIL,.F.,.T.) .AND. FindFunction("TRepInUse") .And. TRepInUse()        

BEGIN SEQUENCE     
      
   If EX5->(FieldPos("EX5_DTINI")) > 0 .And. EX5->(FieldPos("EX5_DTFIM")) > 0 .And.;
      EX6->(FieldPos("EX6_DTINI")) > 0 .And. EX6->(FieldPos("EX6_DTFIM")) > 0
      lNovaRotina := .t.     
      AAdd(aCamposC,{"PERIODO"  ,"C",25,0 })
      AAdd(aCamposC,{"SITUACAO" ,"C",25,0 })
      AAdd(aCamposD,{"DTINI"    ,"C",AVSX3("EX5_DTINI" ,AV_TAMANHO),0 })
      AAdd(aCamposD,{"DTFIM"    ,"C",AvSx3("EX5_DTFIM" ,AV_TAMANHO),0 })
      AAdd(aCamposD,{"DTAPROV"  ,"C",AvSx3("EX5_DTAPRO",AV_TAMANHO),0 })
   EndIf 
   
   aARQS := {} 
   AADD(aARQS,{cNOMDBFC,aCAMPOSC,"CAP","SEQREL"})
   AADD(aARQS,{cNOMDBFD,aCAMPOSD,"DET","SEQREL"})
   
   IF ! TelaGets()
      lRet := .F.
      Break  
   Endif     
   
   aRetCrw := CrwNewFile(aARQS)
   lApaga:= .t.
      
   cSEQREL :=GetSXENum("SY0","Y0_SEQREL")
   CONFIRMSX8()   

   CAP->(DBAPPEND())
   CAP->SEQREL := cSEQREL  
   if lNovaRotina 
      CAP->FLAG := "B"
   Else
      CAP->FLAG := "A"
   Endif                                                     
   
   if lNovaRotina 
      //testa o filtro de data de vencimento do cambio que aparecerá no cabeçalho do relatório
      if empty(dDtIni)
         if !empty(dDtFim) //somente Data final preenchida
            CAP->PERIODO := STR0002 + DTOC(dDtFim)  //"até"
         else //nenhuma data preenchida       
            CAP->PERIODO := STR0003 //"Todos" 
         endif
      else
         if !empty(dDtFim)
            if dDtIni == dDtFim//DtIni e DtFim iguais
               CAP->PERIODO := DTOC(dDtFim)
            else //DtIni e DtFim <>
               CAP->PERIODO := STR0004 + DTOC(dDtIni) + STR0005 + DTOC(dDtFim) //"De " //" a "
            endif
         else//somente data inicial preenchida
            CAP->PERIODO :=  STR0006 + DTOC(dDtIni) //"A partir de "
         endif
      endif  
      CAP->SITUACAO := cSituacao
   endif    
    
   //testa o filtro de Cliente que aparecerá no cabeçalho do relatório
   if !empty(cCliente)  
      SA1->(DBSEEK(xFilial("SA1")+cCliente))
      CAP->CLIENTE := SA1->A1_NREDUZ 
   else
      CAP->CLIENTE := STR0003 //"Todos"
   endif  
   
   //testa o filtro de Moeda que aparecerá no cabeçalho do relatório
   if !empty(cMoeda)
      CAP->MOEDA := cMoeda 
   Else                
      CAP->MOEDA := STR0007 //"Todas"  
   Endif        
   
   //testa o filtro de Produto que aparecerá no cabeçalho do relatório
   if !empty(cProduto)
      SB1->(DBSetOrder(1))
      SB1->(DBSeek(xFilial("SB1")+cProduto))
      CAP->PRODUTO := lower(SB1->B1_DESC)
   Else
      CAP->PRODUTO := STR0003 //"Todos"
   Endif

   //testa o filtro de País que aparecerá no cabeçalho do relatório   
   if !empty(cPais)  
      SYA->(DBSetOrder(1))
      SYA->(DBSeek(xFilial("SYA")+cPais))
      CAP->PAIS := SYA->YA_DESCR
   Else
      CAP->PAIS := STR0003 //"Todos"
   Endif
     
   #IFDEF TOP
      IF TCSRVTYPE() <> "AS/400"
         cCmd := MontaQuery() 
         cCmd := ChangeQuery(cCmd)
         dbUseArea(.T., "TOPCONN", TCGENQRY(,,cCmd), "QRY", .F., .T.) 
         cAlias:="QRY" 
      ELSE
         cAlias:="EX5"
         EX5->(DBSETORDER(1))
         EX5->(DBGoTop())         
         EX5->(DBSEEK(xFilial("EX5")))
      ENDIF
   #ELSE
      cAlias:="EX5"
      EX5->(DBSETORDER(1))    
      EX5->(DBGoTop())           
      EX5->(DBSEEK(xFilial("EX5")))   
   #ENDIF   
   
   While (cAlias)->(!Eof()) .and. (cAlias)->EX5_FILIAL == xFilial("EX5")
      Begin Sequence
         #IFDEF TOP
            IF TCSRVTYPE() = "AS/400"      
               If !FiltrosDBF()  // filtros para ambiente codebase 
                  break
               Endif
            Endif
         #ELSE
            If !FiltrosDBF()  // filtros para ambiente codebase
               break
            EndIf
         #ENDIF
              
      //Gravação dos detalhes   
         If (cAlias)->EX5_PRECO = 0
            Break
         endif
         DET->(DbAppend()) 
         DET->SEQREL := cSEQREL
          
         if lNovaRotina 
            DET->FLAG2 := "B" 
            GravaDatas()
         Else 
            DET->FLAG2 := "A"
         Endif
         lFlag := !lFlag  
         If(lFlag, DET->FLAG := "X", DET->FLAG := "Y") //zebrado do relatório   
         
         SB1->(DBSetOrder(1))
         SB1->(DBSeek(xFilial("SB1")+(cAlias)->EX5_COD_I))
         DET->PRODUTO := alltrim((cAlias)->EX5_COD_I) + " - " + lower(SB1->B1_DESC)
         SYA->(DBSetOrder(1))
         SYA->(DBSeek(xFilial("SYA")+(cAlias)->EX5_PAIS))
         DET->PAIS    := SYA->YA_DESCR 
         #IFDEF TOP
            IF TCSRVTYPE() = "AS/400"      
               DET->CLIENTE := "  -" 
            Else
               If !Empty((cAlias)->EX5_CLIENT)
                  SA1->(DBSetOrder(1))
                  SA1->(DBSeek(xFilial("SA1")+(cAlias)->EX5_CLIENT)) 
                  DET->CLIENTE := SA1->A1_NREDUZ 
               Else
                  DET->CLIENTE := "  -"
               Endif 
            Endif
         #ELSE
            DET->CLIENTE := "  -"
         #ENDIF
            
         DET->MOEDA   := (cAlias)->EX5_MOEDA
         DET->PRECO   := Transform((cAlias)->EX5_PRECO,AvSx3("EX5_PRECO",AV_PICTURE))
                    
         lProc := .t.    
      End Sequence
      
      #IFDEF TOP
         IF TCSRVTYPE() = "AS/400"      
            PrecoClient()
         Endif
      #ELSE
         PrecoClient()
      #ENDIF
      
      (cAlias)->(DBSkip())
   Enddo   
   
   if lProc = .f.
      msginfo(STR0010,STR0011) //("Intervalo sem dados para impressão.","Aviso!")
      lRet := .f.
      break
   Else
      If lR4      //JPA - 07/08/2006
         oReport := ReportDef()
      EndIf
   endif
   
END SEQUENCE 

   IF ( lRet )
      If lR4   //JPA - 07/08/2006
         oReport:PrintDialog()
         CrwCloseFile(aRetCrw,.T.)
      Else
         CrwPreview(aRetCrw,cArqRpt,cTitRpt,cSeqRel)
      EndIf
   ELSEIF lApaga
      // Fecha e apaga os arquivos temporarios
      CrwCloseFile(aRetCrw,.T.)
   ENDIF    
   if Select("QRY") > 0 
      QRY->(DbCloseArea()) 
   endif
   RestOrd(aOrd) 
      
Return (.f.)         

/*
Funcao      : PrecoClient().
Parametros  : Nenhum.
Retorno     : nil
Objetivos   : Adiciona na work os precos por cliente (somente para ambiente codebase) 
Autor       : João Pedro Macimiano Trabbold.
Data/Hora   : 14/10/04; 15:45
*/ 
*---------------------------*
Static Function PrecoClient()
*---------------------------*
local cFilial2, cProduto2, cPais2, nRec  
Begin Sequence  
   if lNovaRotina
      nRec := EX5->(RecNo())       
      cFilial2  := EX5->EX5_FILIAL
      cProduto2 := EX5->EX5_COD_I
      cPais2    := EX5->EX5_PAIS                                  
      //Tratamentos para que registros não se repitam no relatório
      if cSituacao == STR0008 //"Ativos"
         If Empty(EX5->EX5_DTAPRO)   //Não aprovado
            EX5->(DBSkip(-1))
            if cProduto2 == EX5->EX5_COD_I .And. cPais2 == EX5->EX5_PAIS .And. cFilial2 == EX5->EX5_FILIAL .and. EX5->(!BOF())
               EX5->(DBGoTo(nRec))
               break
            Endif 
         Elseif !Empty(EX5->EX5_DTFIM)
            EX5->(DBGoTo(nRec))
            Break
         Endif
      Else                                               
         If !Empty(EX5->EX5_DTAPRO)  //Aprovado
            if Empty(EX5->EX5_DTFIM)
               EX5->(DBSkip())
               if cProduto2 == EX5->EX5_COD_I .And. cPais2 == EX5->EX5_PAIS .And. cFilial2 == EX5->EX5_FILIAL .and. EX5->(!EOF())
                  EX5->(DBGoTo(nRec))
                  break
               Endif 
            Else 
               EX5->(DBGoTo(nRec))
               break
            Endif
         Endif
      Endif
   EX5->(DBGoTo(nRec))   
   Endif   
   
   //Procurar preços de clientes para o pais corrente    
   EX6->(DBSetOrder(1))
   if EX6->(DBSeek(xFilial("EX6")+EX5->EX5_COD_I+EX5->EX5_PAIS))
      While xFilial("EX6") == EX6->EX6_FILIAL    ;
           .And. EX5->EX5_COD_I == EX6->EX6_COD_I;
           .And. EX5->EX5_PAIS  == EX6->EX6_PAIS .and. EX6->(!EOF()) 
         
         if !FiltrosClient()  
            EX6->(DBSkip())
            Loop
         Endif     
         
         DET->(DBAppend())  
         if lNovaRotina 
            DET->FLAG2 := "B"
         Else 
            DET->FLAG2 := "A"
         Endif
         DET->SEQREL := cSEQREL
         lFlag := !lFlag
         If(lFlag, DET->FLAG := "X", DET->FLAG := "Y")
         
         If lNovaRotina 
            if !Empty(EX6->EX6_DTINI)
               DET->DTINI   := transform(EX6->EX6_DTINI,avsx3("EX6_DTINI",AV_PICTURE))
            Else
               DET->DTINI   := "-"
            Endif
            If !Empty(EX6->EX6_DTFIM)
               DET->DTFIM   := transform(EX6->EX6_DTFIM,avsx3("EX6_DTFIM",AV_PICTURE))
            Else
               DET->DTFIM   := "-"
            Endif
            If !Empty(EX6->EX6_DTAPRO)
               DET->DTAPROV :=SUBSTR(DtoC(EX6->EX6_DTAPRO),1,2)+"/"+SUBSTR(DtoC(EX6->EX6_DTAPRO),4,2)+"/"+SUBSTR(DtoC(EX6->EX6_DTAPRO),9,2) //wfs
            Else
               DET->DTAPROV := "-"
            Endif
         Endif
         SB1->(DBSetOrder(1))
         SB1->(DBSeek(xFilial("SB1")+EX6->EX6_COD_I))
         DET->PRODUTO := AllTrim(EX6->EX6_COD_I) + " - " + lower(SB1->B1_DESC)
    
         SYA->(DBSetOrder(1))
         SYA->(DBSeek(xFilial("SYA")+EX6->EX6_PAIS))
         DET->PAIS    := SYA->YA_DESCR 
                                             
         SA1->(DBSetOrder(1))
         SA1->(DBSeek(xFilial("SA1")+EX6->EX6_CLIENT+EX6->EX6_CLLOJA))
         DET->CLIENTE := SA1->A1_NREDUZ
         
         DET->MOEDA   := EX6->EX6_MOEDA
         DET->PRECO   := Transform(EX6->EX6_PRECO,AvSx3("EX6_PRECO",AV_PICTURE))        
         lProc := .t.
         EX6->(DBSkip())
      Enddo       
   Endif  
      
end sequence
return nil

/*
Funcao      : TelaGets().
Parametros  : Nenhum.
Retorno     : .t./.f.
Objetivos   : Tela com opções de filtros para os embarques.
Autor       : João Pedro Macimiano Trabbold.
Data/Hora   : 13/10/04; 10:20
*/
*-----------------------------*
Static Function TelaGets() 
*-----------------------------* 
Local lRet  := .f.
Local nOpc  := 0   	
Local bOk, bCancel  
Local n := 0, m := 0 ,oFont2

if !lNovaRotina
   n := 26   
   m := 16
Endif
Begin Sequence

   DEFINE MSDIALOG oDlg TITLE cTitRpt FROM 1,1 TO /*203*/233-(n*2),/*273*/323-(m*2) OF oMainWnd PIXEL //FDR - 16/01/12 - Ajuste de tela
      
      //Nopado por FDR - 16/01/12 - Retirada as linhas adicionais para padronização dos relatórios.
      // @ 11,3 to 103-n,135-m PIXEL 
      // @ 13,1 to 101-n,137-m PIXEL   
      // @ 11,1 to 103-n,137-m PIXEL    
            
      if lNovaRotina                                      
         @ 22,8  SAY STR0012 PIXEL //"Situação :"
         @ 20,38 COMBOBOX oCbxSit VAR cSituacao ITEMS aSituacao  SIZE 90,8 ON CHANGE (fChange()) OF oDlg PIXEL  
      
         @ 35,8  SAY STR0013  PIXEL //"Dt. Aprov. :"
         @ 33,38 MSGET oDtIni VAR dDtIni SIZE 40,8 PIXEL   
      
         @ 35,78 SAY STR0014 PIXEL //"Até "
         @ 33,88 MSGET oDtFim VAR dDtFim SIZE 40,8 PIXEL  
         fChange()  
      Endif
      
      @ 48-n,8  SAY STR0015 PIXEL //"Produto : "
      @ 46-n,38 MSGET cProduto PICTURE "@!" F3 "EB1" Valid (Empty(cProduto) .or. ExistCPO("SB1")) SIZE 40,8 OF oDlg PIXEL 
      
      @ 61-n,8  SAY STR0016 PIXEL //"País : "
      @ 59-n,38 MSGET cPais PICTURE "@!" F3 "SYA" Valid (Empty(cPais) .or. ExistCPO("SYA")) SIZE 40,8 OF oDlg PIXEL 
         
      @ 74-n,8  SAY STR0017 PIXEL //"Cliente :"
      @ 72-n,38 MSGET cCliente F3 "CLI" Valid (Empty(cCliente) .or. ExistCPO("SA1")) SIZE 40,8 OF oDlg PIXEL   
      
      @ 87-n,8  SAY STR0018 PIXEL //"Moeda : "
      @ 85-n,38 MSGET cMoeda PICTURE "@!" F3 "SYF" Valid (Empty(cMoeda) .or. ExistCPO("SYF")) SIZE 40,8 OF oDlg PIXEL 
      
      bOk     := {|| If(ConfereDt(),(nOpc:=1, oDlg:End()),nOpc:=0)}
      bCancel := {|| oDlg:End() }
						
   ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,bOk,bCancel) CENTERED

   IF nOpc == 1                                                    
      lRet := .t.
   Else
      lRet := .f.
   Endif 

End Sequence

Return lRet   

/*
Funcao      : fChange().
Parametros  : Nenhum.
Retorno     : nil
Objetivos   : Enable/Disable dos campos de Periodo, de acordo com a selecao da combobox oCbxSit
Autor       : João Pedro Macimiano Trabbold.
Data/Hora   : 23/08/04; 13:20
*/ 
*------------------------*
Static Function fChange()
*------------------------*  
Begin Sequence 
 
   if cSituacao == STR0009 //"Aguardando Aprovacao"
      oDtIni:Disable() 
      dDtIni:= AVCTOD("  /  /  ") 
      oDtFim:Disable() 
      dDtFim:= AVCTOD("  /  /  ") 
      oDtIni:Refresh() 
      oDtFim:Refresh()             
   Elseif cLastSituation == STR0009 //"Aguardando Aprovacao"
      oDtIni:Enable() 
      dDtIni := AVCTOD("  /  /  ")     
      oDtFim:Enable()                                 
      dDtIni := AVCTOD("  /  /  ")     
      oDtIni:Refresh()
      oDtFim:Refresh()      
   endif 
   cLastSituation := cSituacao
end sequence
return nil

/*
Funcao      : ConfereDt().
Parametros  : Nenhum.
Retorno     : .t./.f.
Objetivos   : Confere se as datas digitadas na tela de filtro são válidas.
Autor       : João Pedro Macimiano Trabbold.
Data/Hora   : 04/08/04; 13:27
*/
*-----------------------------------*
Static Function ConfereDt()
*-----------------------------------*
Local lRet := .f.

Begin Sequence      
   
   if !empty(dDtIni) .And. !empty(dDtFim) .And. dDtIni > dDtFim 
      MsgInfo(STR0019,STR0011) //("Data Final não pode ser menor que a inicial.","Aviso!")
   Else
      lRet := .t.
   Endif   
        
End Sequence
      
Return lRet           
/*
Funcao      : MontaQuery().
Parametros  : Nenhum.
Retorno     : cQry
Objetivos   : Monta a query para Serv. TOP
Autor       : João Pedro Macimiano Trabbold.
Data/Hora   : 13/09/04; 9:00
*/ 
#IFDEF TOP
*-----------------------------------*
Static Function Montaquery()
*-----------------------------------*
Local cQry := ""
Begin Sequence
   If Empty(cCliente)   
      cQry += " Select EX5_FILIAL, EX5_COD_I, EX5_PAIS, '" + Space(avsx3("EX6_CLIENT",AV_TAMANHO)) +"' AS EX5_CLIENT , " 
      cQry += "'" + Space(avsx3("EX6_CLLOJA",AV_TAMANHO)) +"' AS EX5_CLLOJA , EX5_MOEDA, EX5_PRECO " 
      if lNovaRotina
         cQry += ", EX5_DTINI, EX5_DTFIM, EX5_DTAPRO "
      endif
      cQry += " From " + RetSQLName("EX5") + " EX5 "
      cQry += " Where D_E_L_E_T_ <> '*' and EX5_PRECO <> 0 " 
      cQry += " and EX5_FILIAL = '" + xFilial("EX5") + "' "           
      
      if lNovaRotina    
         cQry += " and (EX5_DTFIM = '        ' or EX5_DTFIM >= '" + DtoS(dDataBase) + "') "
         If cSituacao == STR0008 //"Ativos"
            cQry += " and EX5_DTAPRO <> '        ' And EX5_DTINI <= '" + DtoS(dDataBase) + "' "    
            If !Empty(dDtini)   
               cQry += " and EX5_DTAPRO >= '" + DtoS(dDtIni) + "' "
            Endif
            If !Empty(dDtFim)
               cQry += " and EX5_DTAPRO <= '" + DtoS(dDtFim) + "' "
            Endif
         Elseif cSituacao == STR0009 //"Aguardando Aprovacao" 
            cQry += " and EX5_DTAPRO = '        ' "
         Endif
         
      Endif 
   
      If !Empty(cPais)
         cQry += " and EX5_PAIS = '" + cPais + "' "
      Endif
      If !Empty(cProduto)
         cQry += " and EX5_COD_I = '" + cProduto + "' " 
      Endif
      If !Empty(cMoeda)
         cQry += " and EX5_MOEDA = '" + cMoeda + "' "
      Endif      
      
      cQry += " UNION "
     
   Endif 
   
   cQry += " Select EX6_FILIAL AS EX5_FILIAL, EX6_COD_I AS EX5_COD_I, EX6_PAIS AS EX5_PAIS, EX6_CLIENT AS EX5_CLIENT, "
   cQry += " EX6_CLLOJA AS EX5_CLLOJA , EX6_MOEDA AS EX5_MOEDA, EX6_PRECO AS EX5_PRECO " 
   if lNovaRotina
      cQry += ", EX6_DTINI AS EX5_DTINI , EX6_DTFIM AS EX5_DTFIM, EX6_DTAPRO AS EX5_DTAPRO "
   endif
   cQry += " From " + RetSQLName("EX6") + " EX6 "
   cQry += " Where D_E_L_E_T_ <> '*' and EX6_PRECO <> 0 "     
   cQry += " and EX6_FILIAL = '" + xFilial("EX6") + "' "
   
   if lNovaRotina
      cQry += " and (EX6_DTFIM = '        ' or EX6_DTFIM >= '" + DtoS(dDataBase) + "') "
      If cSituacao == STR0008 //"Ativos"
         cQry += " and EX6_DTAPRO <> '        ' And EX6_DTINI <= '" + DtoS(dDataBase) + "' "  
         
         If !Empty(dDtini)   
            cQry += " and EX6_DTAPRO >= '" + DtoS(dDtIni) + "' "
         Endif
         
         If !Empty(dDtFim)
            cQry += " and EX6_DTAPRO <= '" + DtoS(dDtFim) + "' "
         Endif
         
      Elseif cSituacao == STR0009 //"Aguardando Aprovacao" 
         cQry += " and EX6_DTAPRO = '        ' "
      Endif
   Endif 
   
   If !Empty(cPais)
      cQry += " and EX6_PAIS = '" + cPais + "' "
   Endif
   If !Empty(cProduto)
      cQry += " and EX6_COD_I = '" + cProduto + "' " 
   Endif
   If !Empty(cMoeda)
      cQry += " and EX6_MOEDA = '" + cMoeda + "' "
   Endif                                     
   If !Empty(cCliente)
      cQry += " and EX6_CLIENT = '" + cCliente + "' "
   Endif
      
   cQry += " Order By EX5_COD_I, EX5_PAIS, EX5_CLIENT, EX5_CLLOJA"       
   
End Sequence

Return cQry  
#ENDIF                 
/*
Funcao      : FiltrosDBF().
Parametros  : Nenhum.
Retorno     : .T./.F.
Objetivos   : Filtros para ambiente CodeBase
Autor       : João Pedro Macimiano Trabbold.
Data/Hora   : 26/08/04; 16:50
*/

*-----------------------------------*
Static Function FiltrosDBF()
*-----------------------------------*
Local lRet := .t.

Begin Sequence   
   //Se o filtro de cliente estiver preenchido, nao aparecem os precos por pais
   if !Empty(cCliente)
      lRet := .f.
      break
   Endif  
   
   if lNovaRotina
      //Registros antigos não são listados
      If !Empty(EX5->EX5_DTFIM) .and. EX5->EX5_DTFIM < dDataBase
         lRet := .f.
         break
      Endif  
      
      //Testa condições de filtro por Situacao do preço    
      if cSituacao == STR0008 .and. (Empty(EX5->EX5_DTAPRO) .Or. (Empty(EX5->EX5_DTINI) .or. EX5->EX5_DTINI > dDatabase)) //"Ativos"
         lRet := .f.
         break 
      Endif
      if cSituacao == STR0009 .and. !Empty(EX5->EX5_DTAPRO) //"Aguardando Aprovacao"
         lRet := .f.
         break
      Endif
      
      //Testa condições de filtro por periodo quando o usuario selecionar os preços "Ativos"
      If cSituacao == STR0008 //"Ativos"
         if (!Empty(dDtIni) .and. EX5->EX5_DTAPRO < dDtIni) .or. (!Empty(dDtFim) .and. EX5->EX5_DTAPRO > dDtFim)
            lRet := .f.
            break
         Endif
      Endif   
   EndIf 
      
   //Testa condições de filtro por produto
   if !Empty(cProduto) .and. EX5->EX5_COD_I <> cProduto
      lRet := .f. 
      break
   Endif                       
   
   //Testa condições de filtro por País
   if !Empty(cPais) .and. EX5->EX5_PAIS <> cPais
      lRet := .f.
      break
   Endif
                                                                      
   //Testa condições de filtro por moeda
   If !Empty(cMoeda) .and. EX5->EX5_MOEDA <> cMoeda
      lRet := .f.
      break
   Endif
       
End Sequence
      
Return lRet              

/*
Funcao      : FiltrosClient().
Parametros  : Nenhum.
Retorno     : .T./.F.
Objetivos   : Filtros de precos por cliente para ambiente CodeBase
Autor       : João Pedro Macimiano Trabbold.
Data/Hora   : 15/10/04; 9:50
*/

*-----------------------------------*
Static Function FiltrosClient()
*-----------------------------------*
Local lRet := .t.

Begin Sequence   
   if lNovaRotina
      //Registros antigos não são listados
      If !Empty(EX6->EX6_DTFIM) .and. EX6->EX6_DTFIM < dDataBase
         lRet := .f.
         break
      Endif  
      
      //Testa condições de filtro por Situacao do preço    
      if cSituacao == STR0008 .and. (Empty(EX6->EX6_DTINI) .or. EX6->EX6_DTINI > dDatabase) //"Ativos"
         lRet := .f.
         break 
      Endif
      if cSituacao == STR0009 .and. !Empty(EX6->EX6_DTAPRO) //"Aguardando Aprovacao"
         lRet := .f.
         break
      Endif
      
      //Testa condições de filtro por periodo quando o usuario selecionar os preços "Ativos"
      If cSituacao == STR0008 //"Ativos"
         if (!Empty(dDtIni) .and. EX6->EX6_DTAPRO < dDtIni) .or. (!Empty(dDtFim) .and. EX6->EX6_DTAPRO > dDtFim)
            lRet := .f.
            break
         Endif
      Endif    
   EndIf
      
   //Testa condições de filtro por produto
   if !Empty(cProduto) .and. EX6->EX6_COD_I <> cProduto
      lRet := .f. 
      break
   Endif                       
   
   //Testa condições de filtro por País
   if !Empty(cPais) .and. EX6->EX6_PAIS <> cPais
      lRet := .f.
      break
   Endif    
   
   //Testa condições de filtro por Cliente
   if !Empty(cCliente) .and. EX6->EX6_CLIENT <> cCliente
      lRet := .f.
      break
   Endif
                                                                             
   //Testa condições de filtro por moeda
   If !Empty(cMoeda) .and. EX6->EX6_MOEDA <> cMoeda
      lRet := .f.
      break
   Endif
        
End Sequence
      
Return lRet              
                  
/*
Funcao      : GravaDatas().
Parametros  : Nenhum.
Retorno     : NIL
Objetivos   : Tratamentos para datas CodeBase/Top (Rotina Nova)
Autor       : João Pedro Macimiano Trabbold.
Data/Hora   : 14/10/04; 16:50
*/

*-----------------------------------*
Static Function GravaDatas()
*-----------------------------------*
#IFDEF TOP
   If TCSRVTYPE() = "AS/400"
      If Empty((cAlias)->EX5_DTINI)           //datas
         DET->DTINI  := "-"
      Else
         DET->DTINI  := TRANSFORM(DTOC((cAlias)->EX5_DTINI) ,AVSX3("EX5_DTINI" ,AV_PICTURE))  
      EndIf 
            
      If Empty((cAlias)->EX5_DTFIM)
         DET->DTFIM  := "-"
      Else   
         DET->DTFIM := TRANSFORM(DTOC((cAlias)->EX5_DTFIM),AVSX3("EX5_DTFIM",AV_PICTURE))
      EndIf 
               
      If Empty((cAlias)->EX5_DTAPRO)
         DET->DTAPROV  := "-"
      Else
         DET->DTAPROV  := SUBSTR((cAlias)->EX5_DTAPRO,7,2)+"/"+SUBSTR((cAlias)->EX5_DTAPRO,5,2)+"/"+SUBSTR((cAlias)->EX5_DTAPRO,3,2) //wfs   
      EndIf  
   Else    
      if Empty((cAlias)->EX5_DTINI)
         DET->DTINI := "-"
      else
         DET->DTINI := SUBSTR((cAlias)->EX5_DTINI,7,2)+"/"+SUBSTR((cAlias)->EX5_DTINI,5,2)+"/"+SUBSTR((cAlias)->EX5_DTINI,3,2)
      endif 
               
      if Empty((cAlias)->EX5_DTFIM)
         DET->DTFIM := "-"
      else
         DET->DTFIM := SUBSTR((cAlias)->EX5_DTFIM,7,2)+"/"+SUBSTR((cAlias)->EX5_DTFIM,5,2)+"/"+SUBSTR((cAlias)->EX5_DTFIM,3,2)
      endif 
               
      if Empty((cAlias)->EX5_DTAPRO)
         DET->DTAPROV  := "-"
      else
         DET->DTAPROV  := SUBSTR((cAlias)->EX5_DTAPRO,7,2)+"/"+SUBSTR((cAlias)->EX5_DTAPRO,5,2)+"/"+SUBSTR((cAlias)->EX5_DTAPRO,3,2)
      endif 
               
   endif
#ELSE 
   If Empty((cAlias)->EX5_DTINI)
      DET->DTINI  := "-"
   Else
      DET->DTINI  := TRANSFORM(DTOC((cAlias)->EX5_DTINI) ,AVSX3("EX5_DTINI" ,AV_PICTURE))  
   EndIf 
            
   If Empty((cAlias)->EX5_DTFIM)
      DET->DTFIM := "-"
   Else   
      DET->DTFIM := TRANSFORM(DTOC((cAlias)->EX5_DTFIM),AVSX3("EX5_DTFIM",AV_PICTURE))
   EndIf 
              
   If Empty((cAlias)->EX5_DTAPRO)
      DET->DTAPROV := "-"
   Else
      DET->DTAPROV := SUBSTR((cAlias)->EX5_DTAPRO,7,2)+"/"+SUBSTR((cAlias)->EX5_DTAPRO,5,2)+"/"+SUBSTR((cAlias)->EX5_DTAPRO,3,2)  
   EndIf
             
#ENDIF    
      
Return lRet

//JPA - 07/08/2006 - Definições do relatório personalizável
****************************
Static Function ReportDef()
****************************                         
Local cTitulo := STR0001
Local cDescr  := STR0001
//Alias que podem ser utilizadas para adicionar campos personalizados no relatório
aTabelas := {"SB1", "SYA", "EX5", "EX6"}

#IFDEF TOP
   AADD(aTabelas, "SA1")
#ENDIF

//Array com o titulo e com a chave das ordens disponiveis para escolha do usuário
aOrdem   := {} 

//Parâmetros:            Relatório , Titulo ,  Pergunte , Código de Bloco do Botão OK da tela de impressão.
oReport := TReport():New("EECPRL24", cTitulo ,"", {|oReport| ReportPrint(oReport)}, cDescr)

//ER - 20/10/2006 - Inicia o relatório como paisagem.
oReport:oPage:lLandScape := .T.
oReport:oPage:lPortRait := .F.

//Define os objetos com as seções do relatório
oSecao1 := TRSection():New(oReport,"Seção 1",aTabelas,aOrdem)
oSecao2 := TRSection():New(oReport,"Seção 2",{"CAP"},{})  // JPA - 07/08/06

//Definição das colunas de impressão da seção 1
TRCell():New(oSecao1,"PRODUTO", "DET", STR0015 , /*Picture*/   , AvSx3("B1_COD"    ,AV_TAMANHO)+AvSx3("B1_DESC",AV_TAMANHO)+3, /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"PAIS"   , "DET", STR0016 , /*Picture*/   , AvSx3("YA_DESCR"  ,AV_TAMANHO)                              , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"CLIENTE", "DET", STR0017 , /*Picture*/   , AvSx3("A1_NREDUZ" ,AV_TAMANHO)                              , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"MOEDA"  , "DET", STR0018 , /*Picture*/   , AvSx3("YF_MOEDA"  ,AV_TAMANHO)                              , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"PRECO"  , "DET", "Preço" , /*Picture*/   , AvSx3("EX5_PRECO" ,AV_TAMANHO)+7                            , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"DTAPROV", "DET", STR0013 , /*Picture*/   , 008                                                         , /*lPixel*/, /*{|| code-block de impressao }*/)

//Definição das colunas de impressão da seção 2 
TRCell():New(oSecao2,"PRODUTO" , "CAP", STR0015  , /*Picture*/, AvSx3("B1_DESC" ,AV_TAMANHO) , /*lPixel*/, /*{|| code-block de impressao }*/)
oReport:Section("Seção 2"):Cell("PRODUTO"):SetCellBreak()

TRCell():New(oSecao2,"PAIS"    , "CAP", STR0016  , /*Picture*/, AvSx3("YA_DESCR",AV_TAMANHO) , /*lPixel*/, /*{|| code-block de impressao }*/)
oReport:Section("Seção 2"):Cell("PAIS"):SetCellBreak()

TRCell():New(oSecao2,"SITUACAO", "CAP", STR0012  , /*Picture*/, 025 , /*lPixel*/, /*{|| code-block de impressao }*/)
oReport:Section("Seção 2"):Cell("SITUACAO"):SetCellBreak()

TRCell():New(oSecao2,"CLIENTE" , "CAP", STR0017  , /*Picture*/, AvSx3("A1_NREDUZ" ,AV_TAMANHO) , /*lPixel*/, /*{|| code-block de impressao }*/)
oReport:Section("Seção 2"):Cell("CLIENTE"):SetCellBreak()

TRCell():New(oSecao2,"MOEDA"   , "CAP", STR0018  , /*Picture*/, AvSx3("YF_MOEDA",AV_TAMANHO)+2 , /*lPixel*/, /*{|| code-block de impressao }*/)
oReport:Section("Seção 2"):Cell("MOEDA"):SetCellBreak()

TRCell():New(oSecao2,"PERIODO" , "CAP", "Período", /*Picture*/, 025 , /*lPixel*/, /*{|| code-block de impressao }*/)
oReport:Section("Seção 2"):Cell("PERIODO"):SetCellBreak()

oReport:bOnPageBreak :={||oReport:Section("Seção 2"):PrintLine()} 

Return oReport


************************************
Static Function ReportPrint(oReport)
************************************
Local oSection := oReport:Section("Seção 1")

//Faz o posicionamento de outros alias para utilização pelo usuário na adição de novas colunas.
TRPosition():New(oReport:Section("Seção 1"),"SB1",1,{|| xFilial("SB1")+(cAlias)->EX5_COD_I})
TRPosition():New(oReport:Section("Seção 1"),"SYA",1,{|| xFilial("SYA")+(cAlias)->EX5_PAIS})
TRPosition():New(oReport:Section("Seção 1"),"EX5",1,{|| xFilial("EX5")})
TRPosition():New(oReport:Section("Seção 1"),"EX6",2,{|| xFilial("EX6")+EX5->EX5_COD_I+EX5->EX5_PAIS})
#IFDEF TOP
   TRPosition():New(oReport:Section("Seção 1"),"SA1",1,{|| xFilial("SA1")+(cAlias)->EX5_CLIENT})
#ENDIF

oReport:SetMeter(DET->(RecCount()))
DET->(dbGoTop())

oReport:Section("Seção 2"):Init()
//Inicio da impressão da seção 1. Sempre que se inicia a impressão de uma seção é impresso automaticamente
//o cabeçalho dela.              
oReport:Section("Seção 1"):Init()

//Laço principal
Do While DET->(!EoF()) .And. !oReport:Cancel()
   oReport:Section("Seção 1"):PrintLine() //Impressão da linha
   oReport:IncMeter()                     //Incrementa a barra de progresso
   
   DET->( dbSkip() )
EndDo

//Fim da impressão da seção 1
oReport:Section("Seção 1"):Finish()
//Fim da impressão da seção 2
oReport:Section("Seção 2"):Finish()

Return .T.
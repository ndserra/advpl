#INCLUDE "EECPRL08.ch"

/*
Programa        : EECPRL08.PRW
Objetivo        : Impressao Shipped Orders
Autor           : Cristiane C. Figueiredo
Data/Hora       : 29/05/2000 09:18
Obs.            :
*/

#include "EECRDM.CH"

/*
Funcao      : EECPRL08
Objetivos   : Ajustar o relatório para a versão 811 - Release 4
Autor       : Juliano Paulino Alves - JPA
Data 	    : 02/08/2006
Obs         :
Revisão     :
*/
**********************
User Function EECPRL08
**********************
lRet := U_EECP08R3(.T.)
RETURN lRet

/*
Funcao      : EECP08R3
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : Cristiane C. Figueiredo
Data/Hora   : 29/05/2000 09:18
Obs.        :
Revisão     : Juliano Paulino Alves - Relatório personalisável - Release 4
Data/Hora   : 02/08/06 13:55
*/
User Function EECP08R3(p_R4)

Local lRet  := .T.
Local aOrd  := SaveOrd({"EE9","EEM","EEC","EEB","EE7"})
Local lZero := .t.

Local cNomDbfC, cNomDbfD, aCamposC, aCamposD, aArqs

Private dDtIni   := AVCTOD("  /  /  ")
Private dDtFim   := AVCTOD("  /  /  ")
Private cPais    := SPACE(AVSX3("YA_CODGI",3))
Private cFamilia := SPACE(AVSX3("YC_COD",3))
Private cCliente := SPACE(AVSX3("A1_COD",3))
Private cProd    := SPACE(AVSX3("B1_COD",3))
Private cDest    := SPACE(AVSX3("EE3_NOME",3))
Private cFax     := SPACE(20)
Private cCopia1  := SPACE(AVSX3("EE3_NOME",3))
Private cFax1    := SPACE(20)
Private cCopia2  := SPACE(AVSX3("EE3_NOME",3))
Private cFax2    := SPACE(20)

Private cArqRpt, cTitRpt

//JPA - 02/08/2006 - Relatório Personalizavel - Release 4
Private oReport
Private lR4   := If(p_R4 == NIL,.F.,.T.) .AND. FindFunction("TRepInUse") .And. TRepInUse()

cNomDbfC:= "WORK08C"
aCamposC:= {}
AADD(aCamposC,{"SEQREL" ,"C", 8,0})
AADD(aCamposC,{"EMPRESA","C",60,0})
AADD(aCamposC,{"PERIODO","C",30,0})
AADD(aCamposC,{"PAIS"   ,"C",60,0})
AADD(aCamposC,{"PARA1"  ,"C",60,0})
AADD(aCamposC,{"C_C1"   ,"C",60,0})
AADD(aCamposC,{"PARA2"  ,"C",60,0})
AADD(aCamposC,{"C_C2"   ,"C",60,0})

cNomDbfD:= "WORK08D"
aCamposD:= {}
AADD(aCamposD,{"SEQREL"  ,"C", 8,0})
AADD(aCamposD,{"PROCESSO","C",20,0})
AADD(aCamposD,{"PEDCLI"  ,"C",20,0})
AADD(aCamposD,{"APELIDO" ,"C",20,0})
AADD(aCamposD,{"PAIS"    ,"C",20,0})
AADD(aCamposD,{"DTPED"   ,"D", 8,0})
AADD(aCamposD,{"PRODUTO" ,"C",30,0})
AADD(aCamposD,{"QTDE_KG" ,"N",15,2})
AADD(aCamposD,{"REQUIRED","C",20,0})
AADD(aCamposD,{"TRANSP"  ,"C",30,0})
AADD(aCamposD,{"NRBL"    ,"C",30,0})
AADD(aCamposD,{"DTBL"    ,"D", 8,0})
AADD(aCamposD,{"CROSDT"  ,"D", 8,0})

aArqs := {}
AADD( aArqs, {cNomDbfc,aCamposc,"CAB","SEQREL"})
AADD( aArqs, {cNomDbfd,aCamposd,"DET","SEQREL"})

Begin Sequence
   
   IF Select("WorkId") > 0
      cArqRpt := WorkId->EEA_ARQUIV
      cTitRpt := AllTrim(WorkId->EEA_TITULO)
   Else 
      cArqRpt := Posicione("EEA",1,xFilial("EEA")+AvKey("58","EEA_COD"),"EEA_ARQUIV")
      cTitRpt := AllTrim(Posicione("EEA",1,xFilial("EEA")+AvKey("58","EEA_COD"),"EEA_TITULO"))
   Endif
   
   aRetCrw := CrwNewFile(aArqs)

   IF ! TelaGets()
      lRet := .F.
      Break
   Endif
   
   EEC->(dbSetOrder(1))
   EEC->(dbSeek(xFilial()))
   
   IF ( Empty(dDtIni) .and. Empty(dDtFim) )
      cPeriodo := "ALL"
   Else   
      cPeriodo := "FROM " + DtoC(dDtIni) + " TO " + DtoC(dDtFim)
   Endif
         
   IF Empty(cPais)
      cPais := "ALL" 
   ENDIF
   
   //rotina principal
   cSEQREL :=GetSXENum("SY0","Y0_SEQREL")
   CONFIRMSX8()
   
   CAB->(DBAPPEND())
   CAB->SEQREL  := cSeqRel 
   CAB->EMPRESA := SM0->M0_NOME
   CAB->PERIODO := cPeriodo
   CAB->PAIS    := IF(cPais <> "ALL",Posicione("SYA",1,xFilial("SYA")+cPais,"YA_NOIDIOM"),cPais)
   CAB->PARA1   := Alltrim(cDest)   + " Fax: " + cFax
   CAB->C_C1    := if(Empty(cCopia1),"","C/C1: " +Alltrim(cCopia1) + If(Empty(cFax1),""," Fax: " + cFax1))
   CAB->C_C2    := if(Empty(cCopia2),"","C/C2: " +Alltrim(cCopia2) + If(Empty(cFax2),""," Fax: " + cFax2))
   CAB->(MSUNLOCK())
   
   lZero := .t.
   
   While EEC->(!Eof() .And. EEC->EEC_FILIAL==xFilial("EEC"))
    
      IF EEC->EEC_DTCONH < dDtIni .Or. (!Empty(dDtFim) .And. EEC->EEC_DTCONH > dDtFim)
         EEC->(dbSkip())
         Loop
      Endif
      
      lPais   := cPais <> "ALL" .and. cPais <> EEC->EEC_PAISET
      lCliente:= !(empty(cCliente)).and. cCliente <> EEC->EEC_IMPORT
      lEmbq   := (empty(EEC->EEC_DTCONH))   
      
      IF lPais .or. lCliente .or. lEmbq
         EEC->(DBSKIP())
         Loop
      ENDIF
    
      lPrimIt := .T.
     
      EE9->(DBSETORDER(2))
      EE9->(DBSEEK(XFILIAL("EE9")+EEC->EEC_PREEMB))

      While EE9->(!EOF() .AND. EE9->EE9_FILIAL==xFilial("EE9")) .and. EE9->EE9_PREEMB == EEC->EEC_PREEMB
        
         lFamilia:= !(empty(cFamilia)) .and. EE9->EE9_FPCOD <> cFAMILIA
         lProduto:= !(empty(cProd)) .and. EE9->EE9_COD_I <> cProd
        
         IF lFamilia .or. lProduto
            EE9->(DBSKIP())
            Loop
         ENDIF
         
         IF Left(Posicione("SYQ",1,XFILIAL("SYQ")+EEC->EEC_VIA,"YQ_COD_DI"),1) == "7"
            cTRANSP := BuscaEmpresa(EEC->EEC_PREEMB,OC_EM,CD_TRA)
         Else
            cTRANSP := Posicione("EE6",1,XFILIAL("EE6")+EEC->EEC_EMBARC,"EE6_NOME")
         Endif   
            
         IF EE8->EE8_DTENTR <= DDATABASE
            cDtReq := "IMMEDIATE"
         Else
            cDtReq := cmonth(EE8->EE8_DTENTR) + "/" + STR(YEAR(EE8->EE8_DTENTR),4)
         Endif   
         
         DET->(DBAPPEND())
         DET->SEQREL  := cSeqRel 
         DET->PRODUTO := EE9->EE9_COD_I
         DET->QTDE_KG := EE9->EE9_PSLQTO
         DET->REQUIRED:= cDtReq
         
         IF lPrimIt
            DET->PROCESSO:= EEC->EEC_PREEMB
            DET->PEDCLI  := EEC->EEC_REFIMP
            DET->APELIDO := EEC->EEC_IMPODE
            DET->DTPED   := POSICIONE("EE7",1,XFILIAL("EE7")+EE9->EE9_PEDIDO,"EE7_DTPEDI")
            DET->PAIS    := POSICIONE("SYA",1,XFILIAL("SYA")+EEC->EEC_PAISET,"YA_DESCR")
            DET->TRANSP  := cTransp
            DET->NRBL    := EEC->EEC_NRCONH
            DET->DTBL    := EEC->EEC_DTCONH
            DET->CROSDT  := EE9->EE9_DTAVRB
            
            lPrimIt := .F.
            lZero := .f.
         ENDIF
         DET->(MSUNLOCK())
         
         EE9->(DBSKIP())
      Enddo   
     
      EEC->(DBSKIP())
   Enddo   
  
   IF lZero
      MSGINFO(STR0001, STR0002) //"Intervalo sem dados para impressão"###"Aviso"
      lRet := .f.
   Else
      If lR4      //JPA - 02/08/2006
         oReport := ReportDef()
      EndIf
   ENDIF
   
End Sequence

//retorna a situacao anterior ao processamento
RestOrd(aOrd)

IF ( lRet )
   If lR4   //JPA - 02/08/2006
      oReport:PrintDialog()
      CrwCloseFile(aRetCrw,.T.)
   Else
      lRetC := CrwPreview(aRetCrw,cArqRpt,cTitRpt,cSeqRel)
   EndIf
ELSE
   // Fecha e apaga os arquivos temporarios
   CrwCloseFile(aRetCrw,.T.)
ENDIF

Return .F.

/*
Funcao      : TelaGets
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : Cristiane C. Figueiredo
Data/Hora   : 29/05/2000 09:18
Revisao     :
Obs.        :
*/
Static Function TelaGets

Local lRet  := .f.
Local nOpc  := 0
Local bOk, bCancel

Begin Sequence

   DEFINE MSDIALOG oDlg TITLE cTitRpt FROM 7,0 TO 31,50 OF oMainWnd
   
      @  20,05 SAY STR0003 PIXEL //"Data Inicial"
      @  20,40 MSGET dDtIni SIZE 40,8 PIXEL
      
      @  33,05 SAY STR0004 PIXEL //"Data Final"
      @  33,40 MSGET dDtFim SIZE 40,8 Valid fConfData(dDtFim,dDtIni) PIXEL
      
      @  46,05 SAY STR0005 PIXEL //"Pais"
      @  46,40 MSGET cPais SIZE 28,8 F3 "SYA" PICTURE AVSX3("YA_CODGI",AV_PICTURE) VALID (Vazio() .Or. ExistCpo("SYA")) PIXEL
                                                            
      @  59,05 SAY STR0006 PIXEL //"Familia"
      @  59,40 MSGET cFamilia SIZE 16,8 F3 "SYC" PICTURE AVSX3("YC_COD",AV_PICTURE) VALID (Vazio() .Or. ExistCpo("SYC")) PIXEL
                                                                
      @  72,05 SAY STR0007 PIXEL //"Cliente"
      @  72,40 MSGET cCliente SIZE 40,8 F3 "CLI" PICTURE AVSX3("A1_COD",AV_PICTURE) VALID (Vazio() .Or. ExistCpo("SA1")) PIXEL
                                                                
      @  85,05 SAY STR0008 PIXEL //"Produto"
      @  85,40 MSGET cProd SIZE 115,8 F3 "SB1" PICTURE AVSX3("B1_COD",AV_PICTURE) VALID (Vazio() .Or. ExistCpo("SB1")) PIXEL
                                                                
      @  98,05 SAY STR0009 PIXEL //"Destinatario"
      @  98,40 MSGET cDest SIZE 115,8 F3 "E33" VALID (IF(Empty(cFax),cFax := IF(ALLTRIM(cDest)==ALLTRIM(EE3->EE3_NOME),EE3->EE3_FAX,SPACE(20)),),.T.) PIXEL
                                                                                        
      @ 111,05 SAY STR0010 PIXEL //"Fax"
      @ 111,40 MSGET cFax SIZE 123,8 PIXEL
                                                                                        
      @ 124,05 SAY STR0011 PIXEL //"Copia 1 para"
      @ 124,40 MSGET cCopia1 SIZE 115,8 F3 "E33" VALID (IF(Empty(cFax1),cFax1:= IF(ALLTRIM(cDest)==ALLTRIM(EE3->EE3_NOME),EE3->EE3_FAX,SPACE(20)),),.T.) PIXEL
                                                                                        
      @ 137,05 SAY STR0012 PIXEL //"Fax 1"
      @ 137,40 MSGET cFax1 SIZE 123,8 PIXEL
                                                                                        
      @ 150,05 SAY STR0013 PIXEL //"Copia 2 para"
      @ 150,40 MSGET cCopia2 SIZE 115,8 F3 "E33" VALID (IF(Empty(cFax2),cFax2:= IF(ALLTRIM(cDest)==ALLTRIM(EE3->EE3_NOME),EE3->EE3_FAX,SPACE(20)),),.T.) PIXEL
                                                                                        
      @ 163,05 SAY STR0014 PIXEL //"Fax 2"
      @ 163,40 MSGET cFax2 SIZE 123,8 PIXEL
        
      bOk     := {|| nOpc:=1, oDlg:End() }
      bCancel := {|| oDlg:End() }
      
   ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,bOk,bCancel) CENTERED
   
   IF nOpc == 1
      lRet := .t.
   Endif

End Sequence
   
Return lRet
   
/*
Funcao      : fConfData
Parametros  : Data Final, Data Inicial
Retorno     : 
Objetivos   : 
Autor       : Cristiane C. Figueiredo
Data/Hora   : 28/08/2000 11:00       
Revisao     :
Obs.        :
*/
Static Function fConfData(dFim,dIni)

Local lRet  := .f.

Begin Sequence
      
   if !empty(dFim) .and. dFim < dIni
      MsgInfo(STR0015,STR0002) //"Data Final não pode ser menor que Data Inicial"###"Aviso"
   Else
      lRet := .t.
   Endif   

End Sequence
      
Return lRet
   
//JPA - 02/08/2006 - Definições do relatório personalizável
****************************
Static Function ReportDef()
****************************                         
Local cTitulo := "Export Report - Shipped Orders"
Local cDescr  := "Export Report - Shipped Orders"
//Alias que podem ser utilizadas para adicionar campos personalizados no relatório
aTabelas := {"EEC", "EE9"}

//Array com o titulo e com a chave das ordens disponiveis para escolha do usuário
aOrdem  	 := {}

//Parâmetros:            Relatório , Titulo ,  Pergunte , Código de Bloco do Botão OK da tela de impressão.
oReport := TReport():New("EECPRL08", cTitulo ,"", {|oReport| ReportPrint(oReport)}, cDescr)

//ER - 20/10/2006 - Inicia o relatório como paisagem.
oReport:oPage:lLandScape := .T.
oReport:oPage:lPortRait := .F.

//Define os objetos com as seções do relatório
oSecao1 := TRSection():New(oReport,"Seção 1",aTabelas,aOrdem)
oSecao2 := TRSection():New(oReport,"Seção 2",{"CAB"},{})  // JPA - 04/08/06

//Definição das colunas de impressão da seção 1
TRCell():New(oSecao1,"PROCESSO", "DET", "Carbra Order"     		    	                        , /*Picture*/        , 018 , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"PEDCLI"  , "DET", "Customer Order"   	            		                , /*Picture*/        , 018 , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"APELIDO" , "DET", "Customer Name"                            			    , /*Picture*/        , 018 , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"PAIS"    , "DET", "Country Name"                    			            , /*Picture*/        , 018 , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"DTPED"   , "DET", "Order Date"                                            , /*Picture*/        , 008 , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"PRODUTO" , "DET", "Product Name"      			                        , /*Picture*/        , 030 , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"QTDE_KG" , "DET", "QTY KGS"           			                        , "@E 999,999,999.99", 015 , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"REQUIRED", "DET", "Ship Date " + chr(13)+chr(10) +"Required"              , /*Picture*/        , 014 , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"TRANSP"  , "DET", "Vessel Trucker &" + chr(13)+chr(10) +"Air Company Name", /*Picture*/        , 020 , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"NRBL"    , "DET", "B/L NBR"                                               , /*Picture*/        , 008 , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"DTBL"    , "DET", "B/L Date"                                              , /*Picture*/        , 010 , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"CROSDT"  , "DET", "Crossed " + chr(13)+chr(10) +"Date"                    , /*Picture*/        , 008 , /*lPixel*/, /*{|| code-block de impressao }*/)

AEVAL( oSecao1:aCell, {|X| X:SetColSpace(1) } )

//oReport:Section("Seção 1"):Cell("APELIDO"):SetColSpace(9)
//oReport:Section("Seção 1"):Cell("QTDE_KG"):SetColSpace(8)

oSecao1:SetTotalInLine(.F.)
oSecao1:SetTotalText("Total")

oTotal:= TRFunction():New(oSecao1:Cell("QTDE_KG"),NIL,"SUM",/*oBreak*/,"",,{|| DET->QTDE_KG},.T.,.F.)
oTotal:SetTotalInLine(.F.)
                                                        
// JPA - 04/08/06 - Definição das colunas de impressão da seção 2
TRCell():New(oSecao2,"PAIS"  , "CAB", "Country: "   , /*Picture*/, 030 , /*lPixel*/, /*{|| code-block de impressao }*/)
oReport:Section("Seção 2"):Cell("PAIS"):SetCellBreak()

TRCell():New(oSecao2,"PERIODO", "CAB", "Date: "     , /*Picture*/, 030 , /*lPixel*/, /*{|| code-block de impressao }*/)
oReport:Section("Seção 2"):Cell("PERIODO"):SetCellBreak()

TRCell():New(oSecao2,"PARA1"  , "CAB", "To: ", /*Picture*/, 060 , /*lPixel*/, /*{|| code-block de impressao }*/)
oReport:Section("Seção 2"):Cell("PARA1"):SetCellBreak()

TRCell():New(oSecao2,"C_C1"  , "CAB", "", /*Picture*/, 060 , /*lPixel*/, /*{|| code-block de impressao }*/)
oReport:Section("Seção 2"):Cell("C_C1"):SetCellBreak()

TRCell():New(oSecao2,"C_C2"  , "CAB", "", /*Picture*/, 060 , /*lPixel*/, /*{|| code-block de impressao }*/)
oReport:Section("Seção 2"):Cell("C_C2"):SetCellBreak()

//oSecao2:SetHeaderPage()
oReport:bOnPageBreak :={||oReport:Section("Seção 2"):PrintLine()}

Return oReport


************************************
Static Function ReportPrint(oReport)
************************************
Local oSection := oReport:Section("Seção 1")

//Faz o posicionamento de outros alias para utilização pelo usuário na adição de novas colunas.
TRPosition():New(oReport:Section("Seção 1"),"EEC",1,{|| xFilial()})
TRPosition():New(oReport:Section("Seção 1"),"EE9",1 ,{|| xFilial("EE9")+EEC->EEC_PREEMB})

oReport:SetMeter(DET->(RecCount()))
DET->(dbGoTop())

// JPA - 04/08/06 - Inicio da impressão da seção 2.
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

*------------------------------------------------------------------------------*
* FIM DO PROGRAMA EECPRL08.PRW                                                 *
*------------------------------------------------------------------------------*

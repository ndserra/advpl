#Include "Average.ch"
#include "TopConn.ch"
*========================*
User Function EicReInvAn()
*========================*
Private cTipoRel := Space(1)
Private aTipoRel := {"1=Remissivo", "2=Analítico"}
Private aMoeda   := {}

Do While TelaGets() ////Para escolher o Tipo do Relatorio, Remissivo ou Analitico
   Processa({|| If(ProcRel(),lOk:=.T.,lOk:=.F.),"Aguarde","Processando..."})
EndDo

Return .T.

*=======================*
Static Function ProcRel()
*=======================*
Private oReport //Objeto do TReport
Private nValorInv := 0 //Valor da Invoice

criaStru() //A Work Com a Estrutura

//EW4->(dbSetOrder(1))
EW4->(dbGoTop())
Do While !EW4->(EOF())
   /*
   If Empty(EW4->EW4_HAWB)
      EW4->(dbSkip())
      Loop
   Endif
   */
   
   WORK->(dbAppend())
   WORK->WK_INVOICE := EW4->EW4_INVOIC //Nro. Invoice
   WORK->WK_DT_EMIS := EW4->EW4_DT_EMI //Dt de Emissao
   WORK->WK_INCOTER := EW4->EW4_INCOTE //Incoterm
   WORK->WK_FOBTOT  := EW4->EW4_FOBTOT //Total da Invoice
   WORK->WK_TOT_AGR := EW4->EW4_FOBTOT //Total de Agrupamento da Moeda
   WORK->WK_COND_PG := EW4->EW4_COND_P //Condicao de Pagamento
   WORK->WK_DT_REC  := EW4->EW4_DT_REC //Dt. Rec. Inv
   WORK->WK_DT_OK_A := EW4->EW4_D_OK_A //Dt.Ok Agente
   WORK->WK_DT_LIB  := EW4->EW4_DT_LIB //Dt. Autoriz.
   WORK->WK_DT_IEA  := EW4->EW4_DT_IEA //Instr.Emb.Ag
   
   WORK->WK_MOEDA   := EW4->EW4_MOEDA
   WORK->WK_FORN    := EW4->EW4_FORN
   WORK->WK_AGEMB   := EW4->EW4_AGENTE
   WORK->WK_AGT_OK  := EW4->EW4_AGT_OK //Ok no Agente
   WORK->WK_OK_SHP  := EW4->EW4_OK_SHP //Ok to Ship?   
   
   //GFP 27/10/2010 - Alterado campo FORLOJ   
   IF EICLoja()
      WORK->WK_FORLOJ := EW4->EW4_FORLOJ
   ENDIF 
   
   //If aScan(aMoeda,EW4->EW4_MOEDA) == 0
   If Ascan(aMoeda, {|X| X[1] == EW4->EW4_MOEDA}) == 0
      aAdd(aMoeda,{EW4->EW4_MOEDA,BuscaTaxa(WORK->WK_MOEDA,dDataBase,.T.,.F.,.T.)})
   EndIf
   
   EW4->(dbSkip())
   
EndDo

//Pergunta para Inicializar os parametros
Pergunte("EICEV001",.F.)

oReport:=ReportDef()
oReport:PrintDialog()

Return .T.

*=========================*
Static Function ReportDef()
*=========================*
Local oSecao1
Local oSecao3
Local oSecao4
Local oCellInv
Local aTabelas1
Local aTabelas2
Local oBreak

//Alias que podem ser utilizadas para adicionar campos personalizados no relatório
aTabelas1 := {"SA2","EW4","SYF"}
aTabelas2 := {"SB1","EW5"}

//Array com o titulo e com a chave das ordens disponiveis para escolha do usuário
aOrdem   := {}
If EICLoja()
aAdd(aOrdem,"WK_FORN+WK_FORLOJ+WK_AGEMB+WK_MOEDA+WK_INVOICE")
aAdd(aOrdem,"WK_AGENTE+WK_FORN+WK_FORLOJ+WK_MOEDA+WK_INVOICE")

Else
aAdd(aOrdem,"WK_FORN+WK_AGEMB+WK_MOEDA+WK_INVOICE")
aAdd(aOrdem,"WK_AGENTE+WK_FORN+WK_MOEDA+WK_INVOICE")
EndIF

//Cria o objeto principal de controle do relatório.
//Parâmetros:            Relatório ,Titulo ,Pergunte ,Código de Bloco do Botão OK da tela de impressão.
oReport := TReport():New("EICREINVAN","Relatório de Invoices Antecipadas","",{|oReport| ReportPrint(oReport,oSecao1)},/*Descricao*/)

oReport:lParamPage := .F. //Desabilita a Pagina Inicial de Parametros

//Inicia o relatório como paisagem. 
oReport:oPage:lLandScape := .T. 
oReport:oPage:lPortRait := .F.

//Define o objeto com a seção do relatório
oSecao1 := TRSection():New(oReport,"Secao",aTabelas1,aOrdem)

//Definição das colunas de impressão da seção 1
TRCell():New(oSecao1,"WK_FORN"   ,"WORK","Fornecedor"        ,AvSx3("EW4_FORN",6)  ,AvSx3("EW4_FORN",3),/*lPixel*/,/*{|| code-block de impressao }*/)
If EICLoja()
   TRCell():New(oSecao1,"WK_FORLOJ"   ,"WORK","Loja Forn."        ,AvSx3("EW4_FORLOJ",6)  ,AvSx3("EW4_FORLOJ",3),/*lPixel*/,/*{|| code-block de impressao }*/)
EndIf
TRCell():New(oSecao1,"WK_AGEMB"  ,"WORK","Agente"            ,AvSx3("EW4_AGENTN",6),AvSx3("EW4_AGENTN",3)-25,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"WK_INVOICE","WORK","Invoice"           ,AvSx3("EW4_INVOIC",6),AvSx3("EW4_INVOIC",3),/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"WK_DT_EMIS","WORK","Dt.Emissão"        ,AvSx3("EW4_DT_EMI",6),13,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"WK_INCOTER","WORK","Incoterm"          ,AvSx3("EW4_INCOTE",6),AvSx3("EW4_INCOTE",3)+3,/*lPixel*/,/*{|| code-block de impressao }*/)//"EW4_INCOTE"
TRCell():New(oSecao1,"WK_MOEDA"  ,"WORK",AvSx3("EW4_MOEDA",5),AvSx3("EW4_MOEDA",6) ,                       ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"WK_FOBTOT" ,"WORK","Total Invoice"     ,AvSx3("EW4_FOBTOT",6),AvSx3("EW4_FOBTOT",3),/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"WK_TOT_AGR","WORK","Tot.moeda agrup."  ,AvSx3("EW4_FOBTOT",6),AvSx3("EW4_FOBTOT",3),/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"WK_COND_PG","WORK","Cond.Pagto"        ,AvSx3("EW4_COND_P",6),AvSx3("EW5_COD_I",3) ,/*lPixel*/,/*{|| code-block de impressao }*/)//"EW4_COND_P"
TRCell():New(oSecao1,"WK_DT_REC" ,"WORK","Dt.Rec.Inv"        ,AvSx3("EW4_DT_REC",6),AvSx3("EW5_QTDE",3)  ,/*lPixel*/,/*{|| code-block de impressao }*/)//"EW4_DT_REC"
TRCell():New(oSecao1,"WK_DT_OK_A","WORK","Dt.Ok.Agente"      ,AvSx3("EW4_D_OK_A",6),AvSx3("EW5_PRECO",3) ,/*lPixel*/,/*{|| code-block de impressao }*/)//"EW4_D_OK_A"
TRCell():New(oSecao1,"WK_DT_LIB" ,"WORK","Dt.Autoriz."       ,AvSx3("EW4_DT_LIB",6),AvSx3("EW4_DT_LIB",3),/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"WK_DT_IEA" ,"WORK","Instr.Emb.Ag."     ,AvSx3("EW4_DT_IEA",6),AvSx3("EW4_DT_IEA",3),/*lPixel*/,/*{|| code-block de impressao }*/)
//TRCell():New(oSecao1,"","","",AvSx3("",6)   ,,/*lPixel*/,/*{|| code-block de impressao }*/)

oBreak := TRBreak():New(oSecao1,{|| If(cTipoRel == "1",If(nValorInv>mv_par07,;
(nValorInv:=WORK->WK_TOT_AGR,oBreak:PrintTotal(),oReport:SkipLine(),.F.), .F.),WORK->(EOF()))},"Total Agrupamento",.F.) //"Total da Filial"

TRFunction():New(oSecao1:Cell("WK_FOBTOT") ,NIL,"SUM",oBreak,,/*cPicture*/,/*uFormula*/,.F.,.F.,.F.)
TRFunction():New(oSecao1:Cell("WK_TOT_AGR"),NIL,"SUM",oBreak,,/*cPicture*/,/*uFormula*/,.F.,.F.,.F.)

oSecao1:SetTotalInLine(.F.)
oSecao1:Cell("WK_INVOICE"):SetColSpace(04)
oSecao1:Cell("WK_DT_EMIS"):SetColSpace(05)
oSecao1:Cell("WK_INCOTER"):SetColSpace(08)
oSecao1:Cell("WK_FOBTOT"):SetColSpace(08)
oSecao1:Cell("WK_TOT_AGR"):SetColSpace(08)
oSecao1:Cell("WK_COND_PG"):SetColSpace(3)
oSecao1:Cell("WK_DT_REC"):SetColSpace(5)
oSecao1:Cell("WK_DT_OK_A"):SetColSpace(5)
oSecao1:Cell("WK_DT_LIB"):SetColSpace(5)
oSecao1:Cell("WK_DT_IEA"):SetColSpace(5)
//Fim Secao 1

//Secao 2 Itens EW5
If cTipoRel == "2"
   oSecao2 := TRSection():New(oReport,"Secao2",aTabelas2)
   
   //Criacao apenas para alinhamento
   TRCell():New(oSecao2,"WK_FORN"   ,"WORK2",""       ,AvSx3("EW4_FORN",6)  ,AvSx3("EW4_FORN",3),/*lPixel*/,/*{|| code-block de impressao }*/)
   If EICLoja()
      TRCell():New(oSecao2,"WK_FORLOJ"   ,"WORK2",""       ,AvSx3("EW4_FORLOJ",6)  ,AvSx3("EW4_FORLOJ",3),/*lPixel*/,/*{|| code-block de impressao }*/)
   EndIf
   TRCell():New(oSecao2,"WK_AGEMB"  ,"WORK" ,""       ,AvSx3("EW4_AGENTN",6),AvSx3("EW4_AGENTN",3)-21,/*lPixel*/,/*{|| code-block de impressao }*/)
   oSecao2:Cell("WK_FORN"):Hide()
   If EICLoja()
       oSecao2:Cell("WK_FORLOJ"):Hide()
   EndIf
   oSecao2:Cell("WK_AGEMB"):Hide()
   
   oCellInv:=TRCell():New(oSecao2,"WK_INVOICE","WORK2","",AvSx3("EW4_INVOIC",6),AvSx3("EW4_INVOIC",3)-3,/*lPixel*/)
   oCellInv:Hide()
   TRCell():New(oSecao2,"WK_CC"     ,"WORK2","Cliente Int.",AvSx3("EW5_CC",6)    ,13                   ,/*lPixel*/,,/*Alinhamento*/)//"EW5_CC"
   TRCell():New(oSecao2,"WK_SI_NUM" ,"WORK2","Nro. da S.I.",AvSx3("EW5_SI_NUM",6),AvSx3("EW5_SI_NUM",3)+3,/*lPixel*/)
   TRCell():New(oSecao2,"WK_PO_POS" ,"WORK2","Po/Item"     ,                     ,AvSx3("EW4_FOBTOT",3),/*lPixel*/)//AvSx3("EW5_COD_I",3)+5
   TRCell():New(oSecao2,"WK_PGI_NU" ,"WORK2","No.da PLI"   ,AvSx3("EW5_PGI_NU",6),AvSx3("EW4_FOBTOT",3),/*lPixel*/)//"EW5_PGI_NU"
   TRCell():New(oSecao2,"WK_COD_I"  ,"WORK2","Produto"     ,AvSx3("EW5_COD_I",6) ,AvSx3("EW5_COD_I",3) ,/*lPixel*/)
   TRCell():New(oSecao2,"WK_QTDE_I" ,"WORK2","Qtde"        ,AvSx3("EW5_QTDE",6)  ,AvSx3("EW5_QTDE",3)  ,/*lPixel*/)
   TRCell():New(oSecao2,"WK_PRECO"  ,"WORK2","Preco Unit." ,AvSx3("EW5_PRECO",6) ,AvSx3("EW5_PRECO",3) ,/*lPixel*/)
   TRCell():New(oSecao2,"WK_FABR"   ,"WORK2","Fabricante"  ,AvSx3("EW5_FABR",6)  ,AvSx3("EW5_FABR",3)  ,/*lPixel*/)
   IF EICLoja()
       TRCell():New(oSecao2,"WK_FABLOJ"   ,"WORK2","Loja Fabr."  ,AvSx3("EW5_FABLOJ",6)  ,AvSx3("EW5_FABLOJ",3)  ,/*lPixel*/)
   ENDIF
   
   oSecao2:Cell("WK_INVOICE"):SetColSpace(07)
   oSecao2:Cell("WK_CC"):SetColSpace(05)
   oSecao2:Cell("WK_SI_NUM"):SetColSpace(10)
   oSecao2:Cell("WK_PO_POS"):SetColSpace(08)
   oSecao2:Cell("WK_PGI_NU"):SetColSpace(09)
   oSecao2:Cell("WK_COD_I"):SetColSpace(03)
   oSecao2:Cell("WK_QTDE_I"):SetColSpace(05)
   oSecao2:Cell("WK_PRECO"):SetColSpace(05)
   oSecao2:Cell("WK_FABR"):SetColSpace(05)
   If EICLoja()
      oSecao2:Cell("WK_FABLOJ"):SetColSpace(05)
   EndIf   
EndIf
//Fim Secao 2

//Secao 3 Dados
oSecao3 := TRSection():New(oReport,"Quadro resumo dos filtros do Relatório")
oSecao3:lHeaderVisible:=.T.

TRCell():New(oSecao3,"TITULO1","WORK3","",,10,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao3,"DADOS1" ,"WORK3","",,10,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao3,"TITULO2","WORK3","",,28,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao3,"DADOS2" ,"WORK3","",,28,/*lPixel*/,/*{|| code-block de impressao }*/)

//Secao 4
oSecao4 := TRSection():New(oReport,"Quadro resumo das Taxas de conversão utilizadas")
oSecao4:lHeaderVisible:=.T.

TRCell():New(oSecao4,"WK_MOEDA","WORK3","",,5,,,"LEFT")
TRCell():New(oSecao4,"WK_TAXA" ,"WORK3","",AvSx3("YE_TX_COMP",6),AvSx3("YE_TX_COMP",3))
oSecao4:Cell("WK_MOEDA"):SetColSpace(05)
//Necessário para carregar os perguntes mv_par**
oReport:SetParam("EICEV001")

Return oReport

*=========================================*
Static Function ReportPrint(oReport,oSecao)
*=========================================*
Local cSecao3 := "Quadro resumo dos filtros do Relatório"
Local cSecao4 := "Quadro resumo das Taxas de conversão utilizadas"
//Faz o posicionamento de outros alias para utilização pelo usuário na adição de novas colunas.
TRPosition():New(oSecao,"SYF",1,{|| xFilial("SYF") + WORK->WK_MOEDA})
TRPosition():New(oSecao,"SA2",1,{|| xFilial("SA2") + WORK->WK_FORN+EICRetLoja("WORK","WK_FORLOJ")})
TRPosition():New(oSecao,"EW4",1,{|| xFilial("EW4") + WORK->WK_INVOICE})

If cTipoRel == "2"
   TRPosition():New(oReport:Section("Secao2"),"EW5",1,{|| xFilial("EW5") + WORK2->WK_INVOICE})
   TRPosition():New(oReport:Section("Secao2"),"SB1",1,{|| xFilial("SB1") + WORK2->WK_COD_I})
EndIf

adjWork() //Ajusta a Work Baseado nos parametros

//Dados com os Resumos e Quadros
ApdWORK3() //Agrupar as invoices - Valor

WORK->(dbGoTop())

oSecao:Init()
If cTipoRel == "2"
   oReport:Section("Secao2"):Init()
EndIf

lFirst:= .T.

//Laço principal
Do While !WORK->(EOF()) .And. !oReport:Cancel()
   
   If !lFirst
      nValorInv += WORK->WK_TOT_AGR
   EndIf
   
   oSecao:PrintLine(,,.T.) //Impressão da linha
   oReport:IncMeter() //Incrementa a barra de progresso
   
   If cTipoRel == "2"
      WORK2->(dbSeek(WORK->WK_FORN+EICRetLoja("WORK","WK_FORLOJ")+WORK->WK_INVOICE))
      Do While WORK2->WK_INVOICE == WORK->WK_INVOICE .And. WORK2->WK_FORN == WORK->WK_FORN .And. IIF(EICLoja(),WORK2->WK_FORLOJ == WORK->WK_FORLOJ,.T.);
               .And. !oReport:Cancel() .And. !WORK2->(EOF())
         oReport:Section("Secao2"):PrintLine(,,.T.) //Impressão da linha //.T. para excel
         WORK2->(dbSkip())
      EndDo
      oReport:SkipLine()
   EndIf

   If lFirst
      nValorInv += WORK->WK_TOT_AGR
      lFirst := .F.
   EndIf
   
   WORK->(dbSkip())
EndDo
WORK->(dbGoTop())
//Fim da impressão da seção 1
If cTipoRel == "2"
   oReport:Section("Secao2"):Finish()
EndIf
oSecao:Finish()

//WORK3
WORK3->(dbGoTop())
oReport:Section(cSecao3):Init()
//Laço principal
Do While (!WORK3->(EOF()) .And. !oReport:Cancel()) .Or. !Empty(WORK3->WK_MOEDA)

   oReport:Section(cSecao3):PrintLine() //Impressão da linha
   oReport:Section(cSecao3):IncMeter() //Incrementa a barra de progresso
   
   WORK3->(dbSkip())
EndDo
WORK3->(dbGoTop())
//Fim da impressão da seção 2
oReport:Section(cSecao3):Finish()

//Dados Moedas
WORK3->(dbGoTop())
oReport:Section(cSecao4):Init()

//Laço principal
Do While !WORK3->(EOF()) .And. !oReport:Cancel()
   
   If Empty(WORK3->WK_MOEDA)
      WORK3->(dbSkip())
      LOOP
   EndIf
   
   oReport:Section(cSecao4):PrintLine() //Impressão da linha
   oReport:Section(cSecao4):IncMeter()  //Incrementa a barra de progresso
   
   WORK3->(dbSkip())
EndDo
WORK3->(dbGoTop())
//Fim da impressão da seção 2

oReport:Section(cSecao4):Finish()

Return .T.

*========================*
Static Function criaStru()
*========================*
Local cArqDBF, cArqDBF2,cArqDBF3
Local aSemSX3:={}

aAdd(aSemSX3,{"WK_INVOICE","C",AvSx3("EW4_INVOIC",3),0})
aAdd(aSemSX3,{"WK_DT_EMIS","D",AvSx3("EW4_DT_EMI",3),0})
aAdd(aSemSX3,{"WK_INCOTER","C",AvSx3("EW4_INCOTE",3),0})
aAdd(aSemSX3,{"WK_FOBTOT" ,"N",AvSx3("EW4_FOBTOT",3),AvSx3("EW4_FOBTOT",4)})
aAdd(aSemSX3,{"WK_TOT_AGR","N",AvSx3("EW4_FOBTOT",3),AvSx3("EW4_FOBTOT",4)})
aAdd(aSemSX3,{"WK_COND_PG","C",AvSx3("EW4_COND_P",3),0})
aAdd(aSemSX3,{"WK_DT_REC" ,"D",AvSx3("EW4_DT_REC",3),0})

aAdd(aSemSX3,{"WK_DT_OK_A","D",AvSx3("EW4_D_OK_A",3),0})
aAdd(aSemSX3,{"WK_DT_LIB" ,"D",AvSx3("EW4_DT_LIB",3),0})
aAdd(aSemSX3,{"WK_DT_IEA" ,"D",AvSx3("EW4_DT_IEA",3),0})
aAdd(aSemSX3,{"WK_MOEDA"  ,"C",AvSx3("EW4_MOEDA",3) ,0})
aAdd(aSemSX3,{"WK_FORN"   ,"C",AvSx3("EW4_FORN",3)  ,0})
If EICLoja()
   aAdd(aSemSX3,{"WK_FORLOJ"   ,"C",AvSx3("EW4_FORLOJ",3)  ,0})
EndIf
aAdd(aSemSX3,{"WK_AGEMB"  ,"C",AvSx3("EW4_AGENTN",3),0})

aAdd(aSemSX3,{"WK_AGT_OK"  ,"C",01,0})
aAdd(aSemSX3,{"WK_OK_SHP"  ,"C",01,0})

If Select("WORK") # 0
   WORK->(dbCloseArea())
EndIf

cArqDBF:=E_CRIATRAB(,aSemSX3,"WORK",,.F.)

If !Used()
   MsgInfo("Nao foi possivel criar o arquivo: " + cArqDBF)
   Return .F.
EndIf

IF EICLoja()
   IndRegua("Work",cArqDBF+OrdBagExt(),"WK_FORN+WK_FORLOJ+WK_AGEMB+WK_MOEDA+WK_INVOICE")
Else
   IndRegua("Work",cArqDBF+OrdBagExt(),"WK_FORN+WK_AGEMB+WK_MOEDA+WK_INVOICE")
EndIf

If cTipoRel == "2"
   aSemSX3:={}
   
   aAdd(aSemSX3,{"WK_INVOICE","C",AvSx3("EW4_INVOIC",3) ,0})
   aAdd(aSemSX3,{"WK_CC"     ,"C",AvSx3("EW5_CC",3)     ,0}) //Cliente Int.
   aAdd(aSemSX3,{"WK_SI_NUM" ,"C",AvSx3("EW5_SI_NUM",3) ,0}) //Nro. da S.I.
   aAdd(aSemSX3,{"WK_PO_POS" ,"C",AvSx3("EW5_COD_I",3)+5,0}) //Po/Item
   aAdd(aSemSX3,{"WK_PGI_NU" ,"C",AvSx3("EW5_PGI_NU",3) ,0}) //No.da PLI
   aAdd(aSemSX3,{"WK_COD_I"  ,"C",AvSx3("EW5_COD_I",3)  ,0}) //Produto
   aAdd(aSemSX3,{"WK_QTDE_I" ,"N",AvSx3("EW5_QTDE",3)   ,AvSx3("EW5_QTDE",4)}) //Qtde
   aAdd(aSemSX3,{"WK_PRECO"  ,"N",AvSx3("EW5_PRECO",3)  ,AvSx3("EW5_PRECO",4)}) //Preco Unit.
   aAdd(aSemSX3,{"WK_FABR"   ,"C",AvSx3("EW5_FABR",3)   ,0}) //Fabricante
   aAdd(aSemSX3,{"WK_FORN"   ,"C",AvSx3("EW5_FORN",3),0}) //Fornecedor
   If EICLoja()
      aAdd(aSemSX3,{"WK_FORLOJ"   ,"C",AvSx3("EW5_FORLOJ",3),0})
      aAdd(aSemSX3,{"WK_FABLOJ"   ,"C",AvSx3("EW5_FABLOJ",3),0})
   EndIf
   //aAdd(aSemSX3,{"WK_","C",AvSx3("",3),0}) //Catg.Prod. ????
   
   If Select("WORK2") # 0
      WORK2->(dbCloseArea())
   EndIf

   cArqDBF2:=E_CRIATRAB(,aSemSX3,"WORK2",,.F.)

   If !Used()
      MsgInfo("Nao foi possivel criar o arquivo: " + cArqDBF2)
      Return .F.
   EndIf
   
    If EICLoja()
      IndRegua("Work2",cArqDBF2+OrdBagExt(),"WK_FORN+WK_FORLOJ+WK_INVOICE")
   Else
      IndRegua("Work2",cArqDBF2+OrdBagExt(),"WK_FORN+WK_INVOICE")
   EndIf
   
EndIf

//WORK3 ***********************************************************
aSemSX3:={}

//Dados dos Parametros
aAdd(aSemSX3,{"TITULO1","C",25,0})
aAdd(aSemSX3,{"TITULO2","C",25,0})
aAdd(aSemSX3,{"DADOS1" ,"C",30,0})
aAdd(aSemSX3,{"DADOS2" ,"C",30,0})

aAdd(aSemSX3,{"WK_MOEDA","C",AvSx3("EW4_MOEDA",3),0})
aAdd(aSemSX3,{"WK_TAXA" ,"N",AvSx3("YE_TX_COMP",3),AvSx3("YE_TX_COMP",4)})

If Select("WORK3") # 0
   WORK3->(dbCloseArea())
EndIf

cArqDBF3:=E_CRIATRAB(,aSemSX3,"WORK3",,.F.)

If !Used()
   MsgInfo("Nao foi possivel criar o arquivo: " + cArqDBF3)
   Return .F.
EndIf

Return .T.

*========================*
Static Function ApdWORK3()
*========================*
Local nCnt

WORK3->(dbAppend())
WORK3->TITULO1 := "Fornecedor: "
WORK3->TITULO2 := "Ok Autoriz: "
WORK3->DADOS1  := mv_par01
If mv_par04 == 1
   WORK3->DADOS2  := "Sim"
ElseIf mv_par04 == 2
   WORK3->DADOS2  := "Não"
Else
   WORK3->DADOS2  := "Ambos"
EndIF

WORK3->(dbAppend())
WORK3->TITULO1 := "Agente: "
WORK3->TITULO2 := "Ok Instruc: "
WORK3->DADOS1  := mv_par02
If mv_par05 == 1
   WORK3->DADOS2  := "Sim"
ElseIf mv_par05 == 2
   WORK3->DADOS2  := "Não"
Else
   WORK3->DADOS2  := "Ambos"
EndIf

WORK3->(dbAppend())
WORK3->TITULO1 := "Ok Agente: "
WORK3->TITULO2 := "Moeda/Vlr.Max.Agrupamento:"
If mv_par03 == 1
   WORK3->DADOS1 := "Sim"
ElseIf mv_par03 == 2
   WORK3->DADOS1 := "Não"
Else
   WORK3->DADOS1  := "Ambos"
EndIf
WORK3->DADOS2  := AllTrim(mv_par06)+" "+AllTrim(Trans(mv_par07,AvSx3("EW4_FOBTOT",6)))

SYE->(dbSetOrder(2))
For nCnt:=1 To Len(aMoeda)
    WORK3->(dbAppend())
    WORK3->WK_MOEDA:= aMoeda[nCnt][1]
    WORK3->WK_TAXA := aMoeda[nCnt][2]
    
    //If SYE->(dbSeek(cFilSYE + AvKey(aMoeda[nCnt],"EW4_MOEDA") + DTOS(dDataBase)))
    //   WORK3->WK_TAXA := SYE->YE_TX_COMP
    //EndIf
    
Next

Return .T.

*=======================*
Static Function adjWork()
*=======================*
Local cFilEW5 := xFilial("EW5")
EW5->(dbSetOrder(1))
oReport:SetMeter(WORK->(RecCount()))
WORK->(dbGoTop())

//Inicio da impressão da seção 1. Sempre que se inicia a impressão de uma seção é impresso automaticamente
//o cabeçalho dela.
Do While !WORK->(EOF())
   
   If !Empty(mv_par01) .And. AvKey(mv_par01,"EW4_FORN") # WORK->WK_FORN //Fornecedor
      WORK->(dbDelete())
      WORK->(dbSkip())
      LOOP
   EndIf
   
   If !Empty(mv_par02) .And. AvKey(mv_par02,"EW4_AGENTE") # WORK->WK_AGENTE //Agente
      WORK->(dbDelete())
      WORK->(dbSkip())
      LOOP
   EndIf
   
   If !Empty(mv_par06) .And. AvKey(mv_par06,"EW4_MOEDA") # WORK->WK_MOEDA //Moeda de Agrupamento
      WORK->WK_TOT_AGR := WORK->WK_FOBTOT*BuscaTaxa(WORK->WK_MOEDA,dDataBase,.T.,.F.,.T.) //WORK->WK_FOBTOT
   EndIf
   
   If (mv_par03 == 1 .And. Str(mv_par03) # WORK->WK_AGT_OK) .Or. (mv_par03 == 2 .And. Str(mv_par03) # WORK->WK_AGT_OK)
      WORK->(dbDelete())
      WORK->(dbSkip())
      LOOP
   EndIf
   
   //Embarque Autorizado
   If (mv_par04 == 1 .And. ALLTRIM(Str(mv_par04)) # WORK->WK_OK_SHP) .Or. (mv_par04 == 2 .And. ALLTRIM(Str(mv_par04)) # WORK->WK_OK_SHP)
      WORK->(dbDelete())
      WORK->(dbSkip())
      LOOP
   EndIf
   
   //GFP 27/10/2010 - Inserido Alias da WORK   
   If (mv_par05 == 1 .And. Empty(WORK->WK_DT_IEA)) .Or. (mv_par05 == 2 .And. !Empty(WORK->WK_DT_IEA)) //Instr.Embarque Emitida
      WORK->(dbDelete())
      WORK->(dbSkip())
      LOOP
   EndIf
   
   If cTipoRel == "2"
      EW5->(dbSeek(cFilEW5 + WORK->WK_INVOICE+WORK->WK_FORN+EICRetLoja("WORK","WK_FORLOJ")))
      Do While EW5->EW5_FILIAL == cFilEW5 .And. EW5->EW5_INVOIC == WORK->WK_INVOICE .AND. EW5->EW5_FORN == WORK->WK_FORN
         WORK2->(dbAppend())
         WORK2->WK_INVOICE:= EW5->EW5_INVOIC
         WORK2->WK_CC     := EW5->EW5_CC
         WORK2->WK_SI_NUM := EW5->EW5_SI_NUM
         WORK2->WK_PO_POS := EW5->EW5_PO_NUM + "/" + EW5->EW5_POSICAO
         WORK2->WK_PGI_NU := EW5->EW5_PGI_NUM
         WORK2->WK_COD_I  := EW5->EW5_COD_I
         WORK2->WK_QTDE_I := EW5->EW5_QTDE
         WORK2->WK_PRECO  := EW5->EW5_PRECO
         WORK2->WK_FABR   := EW5->EW5_FABR
         WORK2->WK_FORN   := EW5->EW5_FORN
         If EICLoja()
            WORK2->WK_FABLOJ   := EW5->EW5_FABLOJ
            WORK2->WK_FORLOJ   := EW5->EW5_FORLOJ
         EndIf
         EW5->(dbSkip())
      EndDo
   EndIf
   WORK->(dbSkip())   
EndDo
Return .T.

*========================*
Static Function TelaGets()
*========================*
Local nOpc := 2
Local nLin  := 15
Local nCol1 := 007, nCol2:=050

Define MsDialog oDLG Title "Relatorio de Invoices Antecipadas" From 0,0 To /*80*/100,450 Of oMainWnd Pixel  //GFP - 30/03/2012 - Ajuste tamanho de tela para versao M11.5
   *
   @nLin,nCol1 Say "Tipo" Pixel Of oDlg
   @nLin,nCol2 ComboBox cTipoRel Items aTipoRel Size 95,08 Pixel Of oDlg
   *
Activate MsDialog oDlg Centered On Init (EnchoiceBar(oDlg,{|| nOpc:=1,oDlg:End()},{|| nOpc:=2,oDlg:End()}))
   
If nOpc == 1
   lRet := .T.
Else //If nOpc == 2
   lRet := .F.
EndIf

Return lRet
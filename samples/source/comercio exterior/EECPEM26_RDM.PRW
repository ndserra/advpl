#Include "EECPEM77.ch"
#Include "EECRDM.ch"

#Define ANTERIOR "A"
#Define PROXIMO  "P"

#XTranslate xLin1(<nVar>) => (<nVar> := <nVar> + 18)
#XTranslate xLin2(<nVar>) => (<nVar> := <nVar> - 3 )

/*
Programa        : EECPEM26.PRW
Objetivo        : Gerar o Memorando de Exportacão modelo 2, conforme artigo 457 do RICMS,
                  convênios 113/96 e 107/01.
Autor           : Wilsimar Fabrício da Silva
Data            : 02/09/2009
Obs.            : 

*/

User Function EECPEM26()

Local lRet:= .F.
Local aOrd:= SaveOrd({"SA2", "EE9", "SYR", "EEM", "EXL"})
Local oDlg
Local bOk:= {||lRet:= .T., If(ValidAll(oDlg), oDlg:End(), lRet:= .F.)}
Local bCancel:= {||oDlg:End()}
Local nCont:= 1

//DFS - 02/10/12 - Inclusão de picture de acordo com o que foi digitado nas configurações do embarque
Private cPictDecPrc := if(EEC->EEC_DECPRC > 0, "."+Replic("9",EEC->EEC_DECPRC),"")
Private cPictDecPes := if(EEC->EEC_DECPES > 0, "."+Replic("9",EEC->EEC_DECPES),"")
Private cPictDecQtd := if(EEC->EEC_DECQTD > 0, "."+Replic("9",EEC->EEC_DECQTD),"")
//DFS - 02/10/12 - Inclusão de picture de acordo com o que foi digitado nas configurações do embarque
Private cPictPreco := "999,999,999"+cPictDecPrc
Private cPictPeso  := "9,999,999"+cPictDecPes
Private cPictQtde  := "9,999,999"+cPictDecQtd

Private cRpt:= "MEMEXP.RPT",;
        cNumMemo:= Space(20),;
        aArq:= {}
//Exportador
Private cNomeExp:= "",;
        cEndExp := "",;
        cCnpjExp:= "",;
        cInscExp:= ""
//Dados da exportação
Private cNrDDE:= "",;
        dDataDDE,;
        cNrConh := "",;
        dDtConh,;
        cPaisDest:= ""
Private aNotasExp:= {},;
        aRe:= {}
//Discriminação dos produtos exportados
Private aProdutos:= {}
//Remetente com fim específico de exportação
Private aFabricante:= {}
//Dados dos documentos fiscais de remessa
Private aNfRemessa:= {}
//Dados dos conhecimentos de transporte
Private aConhTransp:= {}
//Dados do Transportador
Private cNomeTransp:= Space(60),;
        cEndTransp:= Space(100),;
        cInsEstTransp:= Space(20),;
        cCNPJTrans:= Space(20)
//Representante legal do exportador/ responsável
Private dDtMemExp,;
        cAssExp  := "",;
        cCargoAss:= ""   
                              
//DFS - 31/10/12 - Variaveis para receber informações adicionais, número e data da DSE no relatório.
Private dDtDSE,;   
        cInfCompl:= Space(150),;
        cNumDSE  := Space(20)


//Variáveis requeridas pela MsGetDb
Private aRotina, aCols:= {}, aHeader:= {}, lRefresh
aRotina:={{"Pesquisar" , "AxPesqui", 0, 1},;
          {"Visualizar", "AxVisual", 0, 2},;
          {"Incluir"   , "AxInclui", 0, 3},;
          {"Alterar"   , "AxAltera", 0, 4},;
          {"Excluir"   , "AxDeleta", 0, 5}}

Private lCposMemExp := GetMv("MV_AVG0174",,.F.) .And. ChkFile("EYY");
                                                .And. EYY->(FieldPos("EYY_NROMEX")) # 0 ;
                                                .And. EYY->(FieldPos("EYY_DTMEX" )) # 0


SA2->(DBSetOrder(1))
EE9->(DBSetOrder(1))
SYR->(DBSetOrder(1))
EEM->(DBSetOrder(1))

Begin Sequence

   If Upper(FunName()) <> "EECAE100" .And. Upper(FunName()) <> "AA100DOC" 

      M->EEC_PREEMB:= Space(AvSx3("EEC_PREEMB", AV_TAMANHO))

      Define MsDialog oDlg Title STR0001 From 7,10 To 15,60 Of oMainWnd //"Memorando de Exportação"

         @ 20, 05 Say AvSx3("EEC_PREEMB", AV_TITULO) Pixel
         @ 20, 45 MsGet M->EEC_PREEMB F3 "EEC" Size 50, 08 Picture AvSx3("EEC_PREEMB", AV_PICTURE);
                  Valid ExistEmbarq() Pixel

      Activate MsDialog oDlg Centered On Init (EnchoiceBar(oDlg, bOk, bCancel))
   Else
      lRet:= .T.
   EndIf

   If !lRet
      Break
   EndIf
   
   If Select("Header_p") == 0
      AbreEEC()
   EndIf

   /*Carregar os dados da capa do processo.
     Estes dados serão usados em todos os memorandos de exportação, independente de qual
     seja o estado produtor/ fabricante da mercadoria.*/  

   LoadCapa()
   
   /* Carregar os dados referente aos itens do processo.
      Carrega os produtos do processo de exportação, agrupando por produtor/ fabricante.
      Levantamento das notas fiscais de venda e remessa (compra) */
      
   If !LoadDetalhe()
      Break
   EndIf

   //Criação das Works usadas nas MsGetDB
   CriaWorks(1)

   //Criação do aHeader, udado no MsGetDB
   LoadHeader()

   //Exibe a tela para que o usuário possa editar as informações antes de gerar a impressão.
   TelaGets()

   //Fecha as works e apaga os arquivos criados.
   EncerraWorks()

      
End Sequence

RestOrd(aOrd)
Return .F.


/*
Função      : LoadCapa
Parâmetros  : 
Retorno     : 
Objetivos   : Carregar os dados da capa do processo.
              Estes dados serão usados em todos os memorandos de exportação, independente de qual
              seja o estado produtor/ fabricante da mercadoria.
Autor       : Wilsimar Fabrício da Silva
Data/Hora   : 02/09/09
Revisão     : 
Obs.        :
*/
Static Function LoadCapa()          
//DFS - 31/10/12 - Inclusão da tabela EXL (Dados complementares)
Local aOrd:= SaveOrd({"EE9", "EXL"})

Begin Sequence

   EE9->(DBSetOrder(3))
   EE9->(DBSeek(xFilial() + EEC->EEC_PREEMB))

   //DFS - 31/10/12 - Seek na tabela EXL
   EXL->(DbSetOrder(1))
   EXL->(DBSeek(xFilial() + EEC->EEC_PREEMB))

   //Exportador
   If !Empty(EEC->EEC_EXPORT)
      SA2->(DBSeek(xFilial() + EEC->EEC_EXPORT + EEC->EEC_EXLOJA))
   Else
      SA2->(DBSeek(xFilial() + EEC->EEC_FORN + EEC->EEC_FOLOJA))
   EndIf
                                      
   //DFS - 31/10/12 - Alteração do tamanho padrão do campo referente ao nome do exportador, visto que, no dicionário o tamanho padrão é de 40 caracteres
   cNomeExp:= Padr(SA2->A2_NOME, 40)
   cEndExp := Padr(AllTrim(SA2->A2_END) + ", " + AllTrim(SA2->A2_NR_END) +;
                   If (!Empty(SA2->A2_BAIRRO), " - " + AllTrim(SA2->A2_BAIRRO),"") +;
                   If (!Empty(SA2->A2_MUN)   , ", "  + AllTrim(SA2->A2_MUN), "") +;
                   If (!Empty(SA2->A2_EST)   , " - " + AllTrim(SA2->A2_EST), ""), 100)
   cCnpjExp:= Padr(SA2->A2_CGC, 20)
   cInscExp:= Padr(SA2->A2_INSCR, 20)


   //Dados da Exportação
   cNrDDE  := Padr(Transf(EE9->EE9_NRSD, X3Picture("EE9_NRSD")), 20)
   dDataDDE:= EE9->EE9_DTAVRB
   cNrConh := Padr(Transf(EEC->EEC_NRCONH, X3Picture("EEC_NRCONH")), 20)
   dDtConh := EEC->EEC_DTCONH 


   
   SYR->(DBSeek(xFilial() + EEC->EEC_VIA + EEC->EEC_ORIGEM + EEC->EEC_DEST + EEC->EEC_TIPTRA))
   cPaisDest:= Padr(Posicione("SYA", 1, xFilial("SYA") + SYR->YR_PAIS_DE, "YA_DESCR"), 30)


   //Dados do transportador
   //Não há tratamento no padrão para armazenar estes dados. Será digitado pelo usuário


   //Representante legal do exportador/ responsável
   dDtMemExp:= dDataBase
   cAssExp  := Padr(EECContato(CD_SA2, SA2->A2_COD, SA2->A2_LOJA, "1", 1), 30)
   cCargoAss:= Padr(EECContato(CD_SA2, SA2->A2_COD, SA2->A2_LOJA, "1", 2), 30)
   
   //Dados Complementares
   //DFS - 31/10/12 - Inclusão dos campos Numero e Data da DSE
   cNumDSE  := Padr(Transf(EXL->EXL_DSE, X3Picture("EXL_DSE")), 20)
   dDtDSE   := EXL->EXL_AVRBDS
   
End Sequence

RestOrd(aOrd)
Return

/*
Função      : LoadDetalhe
Parâmetros  : 
Retorno     : lRet: .T. quando o processo caracteriza uma exportação indireta (o fabricante e o exportador
              não são os mesmos). .F. quando descaracteriza uma exportação indireta, não havendo a
              necessidade de geração do memorando de exportação.
Objetivos   : Carregar os dados referente aos itens do processo.
              As informações são agrupadas por produtor/ fabricante.
Autor       : Wilsimar Fabrício da Silva
Data/Hora   : 02/09/09
Revisão     : 
Obs.        : Os tratamentos customizados devem ser feitos considerando o dimensionamento dos arrays
              usados nesta função.
*/
Static Function LoadDetalhe()
Local aOrd:= SaveOrd({"EE9", "SD1", "SD2", "SC6"})
Local cExportador:= "",;
      cFabricante:= "",; 
      cMemoExpo  := "",;
      cNfRem     := Space(9),;
      cModNfRem  := Space(3),;
      cSerieNfRem:= Space(3),;
      cUnidade   := Space(2),;
      cNcm       := Space(10),;
      cDescricao := Space(AvSx3("B1_DESC", AV_TAMANHO))
Local dDataNfRem:= CtoD("")
Local nPos,;
      nPrecoUnit := 0,;
      nPrecoTot  := 0,;
      nQuantidade:= 0
Local lRet:= .F.
                  
EE9->(DBSetOrder(3)) //EE9_FILIAL + EE9_PREEMB + EE9_SEQEMB
SD1->(DBSetOrder(2)) //D1_FILIAL + D1_COD + D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA

//Verifica se existe a tabela usada pela rotina de notas fiscais de remessa.
If ChkFile("EYY") .And. Select("EYY") > 0
   aOrd:= SaveOrd({"EE9", "SD1", "EYY"})
   EYY->(DBSetOrder(1)) //EYY_FILIAL + EYY_PREEMB
EndIf

Begin Sequence   

   /*--------------
     Dados da Exportação
     ---------------------*/   
   //Notas fiscais
   EEM->(DBSeek(xFilial() + EEC->EEC_PREEMB + EEM_NF))
   While EEM->(!Eof()) .And.;
         EEM->EEM_FILIAL == EEM->(xFilial()) .And.;
         EEM->EEM_PREEMB == EEC->EEC_PREEMB .And.;
         EEM->EEM_TIPOCA == EEM_NF
         
      If EEM->EEM_TIPONF == EEM_SD  //Se nota fiscal de saída
                         //nota fiscal , modelo        , série         , data
         AAdd(aNotasExp, {EEM->EEM_NRNF, EEM->EEM_MODNF, EEM->EEM_SERIE, EEM->EEM_DTNF})
      EndIf
      EEM->(DBSkip())
   EndDo

   
   /*Produtos, RE's e produtores/ fabricantes.
     O memorando de exportação é gerado por produtor/ fabricante, quando este não for o próprio exportador.
     Este será o critério usado para o agrupamento.
     Os Arrays montados respeitam o mesmo padrão de tamanho e organização, para utilização na gravação
     da work detail.*/
     
   If Empty(EEC->EEC_EXPORT + EEC->EEC_EXLOJA)
      cExportador:= EEC->EEC_FORN + EEC->EEC_FOLOJA
   Else
      cExportador:= EEC->EEC_EXPORT + EEC->EEC_EXLOJA
   EndIf
   
   EE9->(DBSeek(xFilial() + EEC->EEC_PREEMB))

   While EE9->(!Eof()) .And.;
         EE9->EE9_FILIAL == EE9->(xFilial()) .And.;
         EE9->EE9_PREEMB == EEC->EEC_PREEMB

      If EE9->(EE9_FABR + EE9_FALOJA) == cExportador .Or. Empty(EE9->EE9_FABR + EE9->EE9_FALOJA)
         EE9->(DBSkip())
         Loop
      Else
         cFabricante:= EE9->EE9_FABR + EE9->EE9_FALOJA
         If lCposMemExp
            aOrdEYY := SaveOrd({"EYY"})
            EYY->(DbSetOrder(3))
            EYY->(DbSeek(xFilial("EYY") + EEC->EEC_PREEMB + EE9->EE9_PEDIDO + ALLTRIM(EE9->EE9_SEQUEN))) 
            cMemoExpo := EYY->EYY_NROMEX
            RestOrd(aOrdEYY)
         EndIf
      EndIf


      /*--------------
        Dados da Exportação
        ---------------------*/
      /*
        Registro de exportação
        os registros de exportação serão armazenados por produtor/ fabricante e apenas os números que não
        se repetem. O tratamento usado garante que o array seja criado com a estrutura separada por fabricante
        mesmo que não haja RE no processo.
        AAdd(aRe[cFabricante], {Núm. RE, Data RE.}) */

      If (nPos:= AScan(aRe, {|x| x[1] == cFabricante+If(lCposMemExp,cMemoExpo,"")})) == 0
         AAdd(aRe, {cFabricante+If(lCposMemExp,cMemoExpo,"")})
         nPos:= Len(aRe)
      EndIf

      If !Empty(EE9->EE9_RE)
         //Verifica se não existe registros para este produtor/ fabricante e adiciona
         If Len(aRe[nPos]) == 1

            AAdd(aRe[nPos], {EE9->EE9_RE,;
                             EE9->EE9_DTRE})
         ElseIf (AScan(aRe[nPos][2], {|y| AllTrim(y) == AllTrim(EE9->EE9_RE)})) == 0

            AAdd(aRe[nPos], {EE9->EE9_RE,;
                             EE9->EE9_DTRE})
         EndIf
      EndIf


      /*Busca os dados da nota fiscal de remessa e valores de compra dos produtos.
        Caso o cliente não use a integração com o faturamento e a rotina de notas fiscais de remessa,
        estas informações poderão ser digitadas antes da impressão do relatório. */
      /* Nopado por GFP - 24/01/2013
      If IsIntFat() .And. GetMv("MV_AVG0174",, .F.)

         //Redefine os valores iniciais
         nQuantidade:= 0
         nPrecoUnit := 0
         cNfRem     := Space(9)
         cSerieNfRem:= Space(3)
         dDataNfRem := CtoD("")
         cUnidade   := Space(2)
         cNcm       := Space(10)
         cDescricao := Space(AvSx3("B1_DESC", AV_TAMANHO))

         If EYY->(DBSeek(xFilial() + EE9->EE9_PREEMB))
            While EYY->(!Eof()) .And.;
                  EYY->(xFilial()) == EYY->EYY_FILIAL .And.;
                  EYY->EYY_PREEMB == EE9->EE9_PREEMB

               If AllTrim(EYY->EYY_RE) == AllTrim(EE9->EE9_RE)

                  //D1_FILIAL + D1_COD + D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA
                  If SD1->(DBSeek(xFilial() + AvKey(EE9->EE9_COD_I, "D1_COD") +;
                                  AvKey(EYY->EYY_NFENT, "D1_DOC") +;
                                  AvKey(EYY->EYY_SERENT, "D1_SERIE") +;
                                  AVKEY(cFabricante,"D1_FORNECE")))

                     cNfRem     := SD1->D1_DOC
                     cSerieNfRem:= SD1->D1_SERIE
                     //nPrecoUnit := SD1->D1_VUNIT nopado por WFS em 20/01/2010
                     dDataNfRem := SD1->D1_EMISSAO
                     nQuantidade:= SD1->D1_QUANT
                     cUnidade   := SD1->D1_UM
                     cNcm       := Posicione("SB1", 1, xFilial("SB1") + SD1->D1_COD, "B1_POSIPI")
                     cDescricao := Posicione("SB1", 1, xFilial("SB1") + SD1->D1_COD, "B1_DESC")
                     Exit
                  EndIf
               EndIf

               EYY->(DBSkip())
            End      
         EndIf
      EndIf
      */

      /*------------------
        Discriminação dos produtos exportados
        ---------------------------------------*/
      //Se não encontrar o fabricante, o inclui e retorna a nova posição (última).
      If (nPos:= AScan(aProdutos, {|x| x[1] == cFabricante+If(lCposMemExp,cMemoExpo,"")})) == 0
         AAdd(aProdutos, {cFabricante+If(lCposMemExp,cMemoExpo,"")})
         nPos:= Len(aProdutos)
      EndIf

      /* WFS 20/01/2010
         Alterações conforme o convênio 84 do ICMS.
         Os dados da seção "Discriminação dos produtos exportados" serão conforme
         a nota fiscal de saída (pedido de venda).
      
      
      //AAdd(aProdutos[cFabricante], {Quant., Unid., NCM, Descrição, Vl. Unit., Vl. Total, Código do produto, RE, Data RE})
      AAdd(aProdutos[nPos], {EE9->EE9_SLDINI,;
                             EE9->EE9_UNIDAD,;
                             EE9->EE9_POSIPI,;
                             AllTrim(MSMM(EE9->EE9_DESC, AvSx3("EE9_VM_DES", AV_TAMANHO))),;
                             nPrecoUnit,;
                             nPrecoTot:= EE9->EE9_SLDINI * nPrecoUnit,;
                             EE9->EE9_COD_I,;
                             EE9->EE9_RE,;
                             EE9->EE9_DTRE;
                             }) */
      //ISS - 27/01/11 - Alteração da descrição do item.
      DBSelectArea("EE2")
      EE2->(DBSETORDER(1))
      EE2->(DBSEEK(xFilial("EE2")+"3"+"*"+"PORT. -PORTUGUES         "+EE9->EE9_COD_I))
      
      If IsIntFat() .And. !Empty(EE9->EE9_NF)
      
         //Posicionamento das tabelas de itens, nota fiscal e pedido de venda
         SD2->(DBSetOrder(3)) //D2_FILIAL + D2_DOC + D2_SERIE + D2_CLIENTE + D2_LOJA + D2_COD + D2_ITEM
         SD2->(DBSeek(xFilial() + AvKey(EE9->EE9_NF, "D2_DOC") + AvKey(EE9->EE9_SERIE, "D2_SERIE") +;
                                  AvKey(EEC->EEC_IMPORT, "D2_CLIENTE") + AvKey(EEC->EEC_IMLOJA, "D2_LOJA") +;
                                  AvKey(EE9->EE9_COD_I, "D2_COD")))
         
         // GFP - 05/03/2013 - Looping para tratamento caso exista o mesmo item mais de uma vez na mesma NF.
         Do While SD2->(!Eof()) .AND. SD2->D2_FILIAL == xFilial("SD2") .AND. SD2->D2_DOC == EE9->EE9_NF .AND.;
                                      SD2->D2_SERIE == EE9->EE9_SERIE .AND. SD2->D2_CLIENTE == EEC->EEC_IMPORT .AND.;
                                      SD2->D2_LOJA == EEC->EEC_IMLOJA .AND. SD2->D2_COD == EE9->EE9_COD_I 
      
            SC6->(DBSetOrder(1)) //C6_FILIAL + C6_NUM + C6_ITEM + C6_PRODUTO
            SC6->(DBSeek(xFilial() + SD2->D2_PEDIDO + SD2->D2_ITEMPV + AvKey(EE9->EE9_COD_I, "C6_PRODUTO")))

            //AAdd(aProdutos[cFabricante], {Quant., Unid., NCM, Descrição, Vl. Unit., Vl. Total, Código do produto, RE, Data RE})
            //ISS - 27/01/11 - Alteração da descrição do item.
            AAdd(aProdutos[nPos], {SD2->D2_QUANT,;
                                   SD2->D2_UM,;
                                   EE9->EE9_POSIPI,;
                                   AllTrim(SC6->C6_DESCRI),;
                                   SD2->D2_PRCVEN,;
                                   SD2->D2_TOTAL,;
                                   EE9->EE9_COD_I,;
                                   EE9->EE9_RE,;
                                   EE9->EE9_DTRE;
                                   })
            SD2->(DbSkip())      
         EndDo
      Else
         //AAdd(aProdutos[cFabricante], {Quant., Unid., NCM, Descrição, Vl. Unit., Vl. Total, Código do produto, RE, Data RE})
         //ISS - 27/01/11 - Alteração da descrição do item.
         AAdd(aProdutos[nPos], {EE9->EE9_SLDINI,;
                                EE9->EE9_UNIDAD,;
                                EE9->EE9_POSIPI,;
                                AllTrim(MSMM(EE2->EE2_TEXTO,AVSX3("EE2_VM_TEX", AV_TAMANHO))),;
                                EE9->EE9_PRECO * BuscaTaxa(EEC->EEC_MOEDA, EEC->EEC_DTEMBA),;
                                EE9->EE9_SLDINI * EE9->EE9_PRECO * BuscaTaxa(EEC->EEC_MOEDA, EEC->EEC_DTEMBA),;
                                EE9->EE9_COD_I,;
                                EE9->EE9_RE,;
                                EE9->EE9_DTRE;
                                })
      EndIf

      /*-----------------
        Remetente com fim específico de exportação
        ----------------------------------------------*/
      SA2->(DBSeek(xFilial() + cFabricante))
      If AScan(aFabricante, {|x| x[1] == cFabricante+If(lCposMemExp,cMemoExpo,"")}) == 0

         AAdd(aFabricante, {cFabricante+If(lCposMemExp,cMemoExpo,""),; //1. fabricante
                            Padr(SA2->A2_NOME, 60),; //2. razão social
                            Padr(AllTrim(SA2->A2_END) + ", " + AllTrim(SA2->A2_NR_END) +;
                                 If (!Empty(SA2->A2_BAIRRO), " - " + AllTrim(SA2->A2_BAIRRO), "") +;
                                 If (!Empty(SA2->A2_MUN)   , ", "  + AllTrim(SA2->A2_MUN), "") +;
                                 If (!Empty(SA2->A2_EST)   , " - " + AllTrim(SA2->A2_EST), ""), 100),; //3. endereço
                            SA2->A2_EST,; //4. estado produtor
                            SA2->A2_INSCR,; //5. inscrição estatual
                            SA2->A2_CGC}) //6. CNPJ

      EndIf
      
      
      /*---------------------
        Dados dos documentos fiscais de remessa
        -------------------------------------------*/
      //Se não encontrar o fabricante, o inclui e retorna a nova posição (última).
      If (nPos:= AScan(aNfRemessa, {|x| x[1] == cFabricante+If(lCposMemExp,cMemoExpo,"")})) == 0
         AAdd(aNfRemessa, {cFabricante+If(lCposMemExp,cMemoExpo,"")})
         nPos:= Len(aNfRemessa)
      EndIf
      
      //If !Empty(cNfRem)  // Nopado por GFP - 24/01/2013
         //aNfRemessa[cFabricante], {Nota fiscal de remessa, Modelo, Série, Emissão, Quantidade, Unidade, NCM, Descrição}
         //Não serão armazenadas notas fiscais repetidas
         //If Len(aNfRemessa[nPos]) == 1

            
      If IsIntFat() .And. GetMv("MV_AVG0174",, .F.)   // GFP - 24/01/2013 - Sistema deve exibir todas as NFs vinculadas ao embarque.
         
         If EYY->(DBSeek(xFilial() + EE9->EE9_PREEMB))
            While EYY->(!Eof()) .And.;
                  EYY->(xFilial()) == EYY->EYY_FILIAL .And.;
                  EYY->EYY_PREEMB == EE9->EE9_PREEMB

               If AllTrim(EYY->EYY_SEQUEN) == AllTrim(EE9->EE9_SEQUEN)

                  //D1_FILIAL + D1_COD + D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA
                  If SD1->(DBSeek(xFilial() + AvKey(EE9->EE9_COD_I, "D1_COD") +;
                                  AvKey(EYY->EYY_NFENT, "D1_DOC") +;
                                  AvKey(EYY->EYY_SERENT, "D1_SERIE") +;
                                  AVKEY(/*cFabricante*/EYY->EYY_FORN,"D1_FORNECE") +;
                                  AVKEY(EYY->EYY_FOLOJA,"D1_FORNECE")))  // GFP - 05/03/2013

                     AAdd(aNfRemessa[nPos], {SD1->D1_DOC,;
                                    cModNfRem,;
                                    SD1->D1_SERIE,;
                                    SD1->D1_EMISSAO,;
                                    SD1->D1_QUANT,;
                                    SD1->D1_UM,;
                                    Posicione("SB1", 1, xFilial("SB1") + SD1->D1_COD, "B1_POSIPI"),;
                                    Posicione("SB1", 1, xFilial("SB1") + SD1->D1_COD, "B1_DESC");
                                    })
                     

                  EndIf
               EndIf

               EYY->(DBSkip())
            EndDo     
         EndIf 
      EndIf  
            
         //DFS - 24/08/12 - Retirado tratamento que impedia a impressão do segundo item se tivesse mesma nota fiscal de remessa.
         /*ElseIf (AScan(aNfRemessa[nPos][2], {|y| AllTrim(y) == AllTrim(cNfRem)})) == 0

            AAdd(aNfRemessa[nPos], {cNfRem,;
                                    cModNfRem,;
                                    cSerieNfRem,;
                                    dDataNfRem,;
                                    nQuantidade,;
                                    cUnidade,;
                                    cNcm,;
                                    cDescricao;
                                    })
         EndIf */

      //EndIf



      /*-----------------------
        Dados dos conhecimentos de transporte
        ----------------------------------------*/
      /*
        Não há tratamento no padrão para armazenar estes dados. Serão digitados pelo usuário.
        AAdd(aConhTransp[cFabricante], {Núm. Conhec., Mod., Série, Data de emissão}) */

      If (nPos:= AScan(aConhTransp, {|x| x[1] == cFabricante+If(lCposMemExp,cMemoExpo,"")})) == 0
         AAdd(aConhTransp, {cFabricante+If(lCposMemExp,cMemoExpo,"")})
      EndIf


      EE9->(DBSkip())
   EndDo

   //Verifica se existem produtores/ fabricantes para o processo.
   If Len(aFabricante) > 0
      lRet:= .T.
   Else
      MsgInfo(STR0052 + ENTER + STR0053, STR0045) //Este processo não caracteriza uma exportação indireta./ Não existem memorandos de exportação para serem impressos./ Aviso
   EndIf
   
   //NCF - 08/02/2012 - Memorando de Exportação por item
   If lCposMemExp .AND. Len(aFabricante) > 0 //DFS - 06/10/12 - Apenas adicionar valor ao campo se o array for maior que zero.
      cNumMemo := Substr( aFabricante[1][1], Len(SA2->A2_COD)+Len(SA2->A2_LOJA)+1 )
   EndIf
   
End Sequence
RestOrd(aOrd)
Return lRet

/*
Função      : TelaGets
Parâmetros  : 
Retorno     : 
Objetivos   : Gera a tela com as informações do memorando de exportação, agrupadas por produtor/ fabricante.
              Permite que o usuário saiba quais informações serão impressas, editar as informações carregadas
              e incluir demais informações não tratadas pelo Easy.
Autor       : Wilsimar Fabrício da Silva
Data/Hora   : 04/09/2009
Revisão     : 
Obs.        :
*/
Static Function TelaGets()

Local bOk     := {||AtualizaDados(nFabr), If(GeraTodos(), oDlg:End(),)},;
      bCancel := {||oDlg:End()},;
      bTitulo := {||oDlg:cTitle:= STR0001 + " " + AllTrim(Str(nFabr)) + " de " + AllTrim(Str(Len(aFabricante))) + " - " + AllTrim(aFabricante[nFabr][2])},;
      bRefresh:= {||oGetDb_b:oBrowse:Refresh(), oGetDb_b2:oBrowse:Refresh(), oGetDb_c:oBrowse:Refresh(), oGetDb_e:oBrowse:Refresh(), oGetDb_f:oBrowse:Refresh(), oFld:Refresh(), oDlg:Refresh()}
Local oFld,;
      oGetDb_b,;
      oGetDb_b2,;
      oGetDb_c,;
      oGetDb_e,;
      oGetDb_f,;
      oFld_b,;
      oFld_c,;
      oFld_e
Local aFld,;
      aPos,;
      aAltFld_b ,;
      aAltFld_b2,;
      aAltFld_c ,;
      aAltFld_e ,;
      aAltFld_f ,;
      aButtons:= {{"PREV",  {||AtualizaDados(nFabr), Navegacao(@nFabr, ANTERIOR), Eval(bTitulo), Eval(bRefresh)}, STR0037, STR0041},; //Fabricante Anterior / Anterior
                  {"NEXT",  {||AtualizaDados(nFabr), Navegacao(@nFabr, PROXIMO),  Eval(bTitulo), Eval(bRefresh)}, STR0038, STR0042},; //Próximo Fabricante  / Próximo
                  {"PEDIDO",{||AtualizaDados(nFabr), GeraRelatorio(nFabr), Eval(bRefresh) }, STR0043, STR0044}} //Gera o memorando para o fabricante / Gerar
Local cNota:= "",;
      cMod:= "",;
      cSerie:= "",;
      cDataNf:= "",;
      cProdRe:= "",;
      cRe:= "",;
      cDataRe:= "",;
      cTitulo:= ""
Local nLin,;
      nCol,;
      nCont,;
      nFld_a,;
      nFld_b,;
      nFld_d,;
      nFld_e,;
      nFld_f,;
      nFld_g,;
      nFld_h,; 
      nFld_i,;
      nFabr:= 1 //primeiro produtor/ fabricante

Begin Sequence


   cTitulo:= " " + AllTrim(Str(nFabr)) + " de " + AllTrim(Str(Len(aFabricante))) + " - " + AllTrim(aFabricante[nFabr][2])
   
   Define MsDialog oDlg Title STR0001 + cTitulo From 7, 0 To 35, 100 Of oMainWnd //Memorando de Exportação x de n - Razão Social do Produtor/ Fabricante
   
      oFld:= TFolder():New(15, 3, {STR0002,;  //Exportador
                                   STR0003,;  //Dados da exportação
                                   STR0004,;  //Discriminação dos produtos exportados
                                   STR0005,;  //Remetente com fim específico de exportação
                                   STR0006,;  //Dados dos documentos fiscais de remessa
                                   STR0007,;  //Dados dos conhecimentos de transporte
                                   STR0008,;  //Dados do transportador
                                   STR0009,;  //Representante legal do exportador
                                   STR0056},; //Informações Adicionais
                           {"F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9"}, oDlg,,,, .T., .F., 390, 193)

      aFld:= oFld:aDialogs
      aPos:= PosDlg(oFld)


      /*--------
        Exportador
        -------------*/
      
      nFld_a:= 1
      nLin:= 10
      nCol:= 5
      
      TSay():New(nLin       , nCol     , {|| STR0025}, aFld[nFld_a],,,,,, .T.) //Memorando de exportação nº
      TGet():New(xLin2(nLin), nCol + 80, BSetGet(cNumMemo), aFld[nFld_a], 80, 08, "@!",,,,,,, .T.,,,,,,,lCposMemExp) 

      xLin1(nLin)
      TSay():New(xLin1(nLin), nCol     , {|| STR0010}, aFld[nFld_a],,,,,, .T.) //Razão Social
      TGet():New(xLin2(nLin), nCol + 35, BSetGet(cNomeExp), aFld[nFld_a], 210, 08, "@!",,,,,,, .T.)
            
      TSay():New(xLin1(nLin), nCol     , {|| STR0011}, aFld[nFld_a],,,,,, .T.) //Endereço
      TGet():New(xLin2(nLin), nCol + 35, BSetGet(cEndExp), aFld[nFld_a], 230, 08, "@!",,,,,,, .T.)      
              
      TSay():New(xLin1(nLin), nCol     , {|| STR0012}, aFld[nFld_a],,,,,, .T.) //Insc. Estadual
      TGet():New(xLin2(nLin), nCol + 35, BSetGet(cInscExp), aFld[nFld_a], 150, 08, X3Picture("A2_INSCR"),,,,,,, .T.)
      
      TSay():New(xLin1(nLin), nCol     , {|| STR0013}, aFld[nFld_a],,,,,, .T.) //CNPJ
      TGet():New(xLin2(nLin), nCol + 35, BSetGet(cCnpjExp), aFld[nFld_a], 150, 08, X3Picture("A2_CGC"),,,,,,, .T.)



      /*--------------------
        Dados da exportação
        ----------------------------*/

      nFld_b:= 2
      nLin:= 10
            
      TSay():New(nLin       , nCol     , {|| STR0014}, aFld[nFld_b],,,,,, .T.) //Declaração de exportação nº
      TGet():New(xLin2(nLin), nCol + 75, BSetGet(cNrDDE), aFld[nFld_b], 80, 08, X3Picture("EE9_NRSD"),,,,,,, .T.)
      
      nLin += 3
      nCol += 165
      
      TSay():New(nLin       , nCol     , {|| STR0015}, aFld[nFld_b],,,,,, .T.) //Data
      TGet():New(xLin2(nLin), nCol + 20, BSetGet(dDataDDE), aFld[nFld_b], 40, 08, X3Picture("EE9_DTAVRB"),,,,,,, .T.)

      nCol:= 5
      
      TSay():New(xLin1(nLin), nCol     , {|| STR0016}, aFld[nFld_b],,,,,, .T.) //Conhecimento de embarque nº
      TGet():New(xLin2(nLin), nCol + 75, BSetGet(cNrConh), aFld[nFld_b], 80, 08, X3Picture("EEC_NRCONH"),,,,,,, .T.)

      nLin += 3
      nCol += 165
            
      TSay():New(nLin       , nCol     , {|| STR0015}, aFld[nFld_b],,,,,, .T.) //Data
      TGet():New(xLin2(nLin), nCol + 20, BSetGet(dDtConh), aFld[nFld_b], 40, 08, X3Picture("EEC_DTCONH"),,,,,,, .T.)
      
      nCol:= 5
      
      TSay():New(xLin1(nLin), nCol     , {|| STR0017}, aFld[nFld_b],,,,,, .T.) //Estado produtor/ fabricante
      TGet():New(xLin2(nLin), nCol + 75, BSetGet(aFabricante[nFabr][4]), aFld[nFld_b], 10, 08,"!@",,,,,,, .T.)

      nLin += 3
      nCol += 105
      
      TSay():New(nLin       , nCol     , {|| STR0018}, aFld[nFld_b],,,,,, .T.) //País de destino da mercadoria
      TGet():New(xLin2(nLin), nCol + 80, BSetGet(cPaisDest), aFld[nFld_b], 80, 08,"@!",,,,,,, .T.)


      oFld_b:= aFld[2]

      //Campos que podem ser alterados
      //Registro de exportação
      aAltFld_b:= {"WK_RE", "WK_DTRE"}
      
      xLin1(nLin)
      oGetDb_b:= MsGetDb():New(nlin, aPos[2] , aPos[3]-75, aPos[4],;  // Posições da Tela
                                                                 4,;  // Tipo de acordo com o aRotina(Inclusão, Alteração, etc.)
                                                                  ,;  // cLinhaOk
                                                                  ,;  // cTudoOk
                                                                  ,;  // cIncrementa
                                                               .F.,;  // Habilita a opção de deletar linhas do aCols. Valor padrão falso
                                                         aAltFld_b,;  // Campos que podem ser alterados
                                                                  ,;  // Indica qual coluna não ficara congelada na exibição
                                                                  ,;  // lVazio: Habilita validação da primeira coluna do aCols para esta não poder estar vazia. Valor padrão falso.
                                                                  ,;  // Reservado
                                                           "Work1",;  // Work que será mostrada no Browse
                                                                  ,;  // Função executada na validação do campo
                                                                  ,;  // Reservado
                                                               .F.,;  // Define se as linhas poderão ser incluídas
                                                            oFld_b,;  // Objeto no qual está inserida a MsGetDb
                                                               .F.,;  // Define se vai utilizar características do dicionário (gatilhos, consultas...)
                                                                  ,;  // Reservado
                                                                  ,;  // Função que valida exclusão
                                                                  ,)  // Função executada quando pressionada as teclas <Ctrl>+<Delete>

      oGetDb_b:oBrowse:Badd:= {|| .F.}
      oGetDb_b:oBrowse:Refresh()
      
      //Campos que podem ser alterados.
      //Nenhum. As notas fiscais serão apenas visualizadas.
      aAltFld_b2:= {}
      oGetDb_b2:= MsGetDb():New(aPos[3]-75, aPos[2], aPos[3]-11, aPos[4],; // Posições da Tela
                                                                       4,; // Tipo de acordo com o aRotina(Inclusão, Alteração, etc.)
                                                                        ,; // cLinhaOk
                                                                        ,; // cTudoOk
                                                                        ,; // cIncrementa
                                                                     .F.,; // Habilita a opção de deletar linhas do aCols. Valor padrão falso
                                                              aAltFld_b2,; // Campos que podem ser alterados
                                                                        ,; // Indica qual coluna não ficara congelada na exibição
                                                                        ,; // lVazio: Habilita validação da primeira coluna do aCols para esta não poder estar vazia. Valor padrão falso.
                                                                        ,; // Reservado
                                                                 "Work4",; // Work que será mostrada no Browse
                                                                        ,; // Função executada na validação do campo
                                                                        ,; // Reservado
                                                                     .F.,; // Define se as linhas poderão ser incluídas
                                                                  oFld_b,; // Objeto no qual está inserida a MsGetDb
                                                                     .F.,; // Define se vai utilizar características do dicionário (gatilhos, consultas...)
                                                                        ,; // Reservado
                                                                        ,; // Função que valida exclusão
                                                                        ,) // Função executada quando pressionada as teclas <Ctrl>+<Delete>

      oGetDb_b2:oBrowse:Badd:= {|| .F.}      
      oGetDb_b2:oBrowse:Refresh()

      /*--------------------  
        Discriminação dos produtos exportados
        ----------------------------------------*/

      oFld_c:= aFld[3]        

      //Campos que podem ser alterados
      aAltFld_c:= {"WK_DESC", "WK_QTD", "WK_UNID", "WK_VLUNIT", "WK_POSIPI"} //ISS - 27/01/11 - Alteração do campo de NCM
      
      oGetDb_c:= MsGetDb():New(aPos[1], aPos[2] ,aPos[3]-11, aPos[4],; // Posições da Tela
                                                                   4,; // Tipo de acordo com o aRotina(Inclusão, Alteração, etc.)
                                                                    ,; // cLinhaOk
                                                                    ,; // cTudoOk
                                                                    ,; // cIncrementa
                                                                 .F.,; // Habilita a opção de deletar linhas do aCols. Valor padrão falso
                                                           aAltFld_c,; // Campos que podem ser alterados
                                                                    ,; // Indica qual coluna não ficara congelada na exibição
                                                                    ,; // lVazio: Habilita validação da primeira coluna do aCols para esta não poder estar vazia. Valor padrão falso.
                                                                    ,; // Reservado
                                                             "Work2",; // Work que será mostrada no Browse
                                             "U_PEM26CAMPO('Work2')",; // Função executada na validação do campo
                                                                    ,; // Reservado
                                                                 .F.,; // Define se as linhas poderão ser incluídas
                                                              oFld_c,; // Objeto no qual está inserida a MsGetDb
                                                                 .F.,; // Define se vai utilizar características do dicionário (gatilhos, consultas...)
                                                                    ,; // Reservado
                                                                    ,; // Função que valida exclusão
                                                                    ,) // Função executada quando pressionada as teclas <Ctrl>+<Delete>


      oGetDb_c:oBrowse:Badd:= {|| .F.}
      oGetDb_c:oBrowse:Refresh()

      /*--------------------  
        Remetente com fim específico de exportação
        ----------------------------------------------*/
      /* Array aFabricante
         1. fabricante
         2. razão social
         3. endereço
         4. estado produtor
         5. inscrição estatual
         6. CNPJ
      */
      nFld_d:= 4
      nLin:= 10
      nCol:= 5
      
      TSay():New(nLin       , nCol     , {|| STR0010}, aFld[nFld_d],,,,,, .T.) //Razão Social
      TGet():New(xLin2(nLin), nCol + 35, BSetGet(aFabricante[nFabr][2]), aFld[nFld_d], 210, 08, "@!",,,,,,, .T.)
      
      TSay():New(xLin1(nLin), nCol     , {|| STR0011}, aFld[nFld_d],,,,,, .T.) //Endereço
      TGet():New(xLin2(nLin), nCol + 35, BSetGet(aFabricante[nFabr][3]), aFld[nFld_d], 230, 08, "@!",,,,,,, .T.)      

      TSay():New(xLin1(nLin), nCol     , {|| STR0012}, aFld[nFld_d],,,,,, .T.) //Insc. Estadual
      TGet():New(xLin2(nLin), nCol + 35, BSetGet(aFabricante[nFabr][5]), aFld[nFld_d], 150, 08, X3Picture("A2_INSCR"),,,,,,, .T.)

      TSay():New(xLin1(nLin), nCol     , {|| STR0013}, aFld[nFld_d],,,,,, .T.) //CNPJ
      TGet():New(xLin2(nLin), nCol + 35, BSetGet(aFabricante[nFabr][6]), aFld[nFld_d], 150, 08, X3Picture("A2_CGC"),,,,,,, .T.)
      
      

      /*--------------------  
        Dados dos documentos fiscais de remessa
        ------------------------------------------*/
      
      oFld_e:= aFld[5]

      //Campos que podem ser alterados
      aAltFld_e:= {"WK_NFREM", "WK_MODNFRE", "WK_SERNFRE", "WK_DTNFREM", "WK_QTDNFRE", "WK_UNINFRE", "WK_DESCNFR", "WK_NCMNFRE"}

      oGetDb_e:= MsGetDb():New(aPos[1], aPos[2] ,aPos[3]-11, aPos[4],; // Posições da Tela
                                                                   4,; // Tipo de acordo com o aRotina(Inclusão, Alteração, etc.)
                                                     "AllwaysTrue()",; // cLinhaOk
                                                                    ,; // cTudoOk
                                                                    ,; // cIncrementa
                                                                 .T.,; // Habilita a opção de deletar linhas do aCols. Valor padrão falso
                                                           aAltFld_e,; // Campos que podem ser alterados
                                                                    ,; // Indica qual coluna não ficara congelada na exibição
                                                                    ,; // lVazio: Habilita validação da primeira coluna do aCols para esta não poder estar vazia. Valor padrão falso.
                                                                    ,; // Reservado
                                                             "Work3",; // Work que será mostrada no Browse
                                                                    ,; // Função executada na validação do campo
                                                                    ,; // Reservado
                                                                 .T.,; // Define se as linhas poderão ser incluídas
                                                              oFld_e,; // Objeto no qual está inserida a MsGetDb
                                                                 .F.,; // Define se vai utilizar características do dicionário (gatilhos, consultas...)
                                                                    ,; // Reservado
                                                     "AllwaysTrue()",; // Função que valida exclusão
                                                                    ,) // Função executada quando pressionada as teclas <Ctrl>+<Delete>
      oGetDb_e:oBrowse:Refresh()


      /*--------------------  
        Dados dos conhecimentos de transporte
        ------------------------------------------*/
      nFld_f:= 6
      
      oFld_f:= aFld[nFld_f]

      //Campos que podem ser alterados
      aAltFld_f:= {"WK_NUMCONH", "WK_MODCONH", "WK_SERCONH", "WK_DTCONH"}
      oGetDb_f:= MsGetDb():New(aPos[1], aPos[2] ,aPos[3]-11, aPos[4],; // Posições da Tela
                                                                   4,; // Tipo de acordo com o aRotina(Inclusão, Alteração, etc.)
                                                     "AllwaysTrue()",; // cLinhaOk
                                                                    ,; // cTudoOk
                                                                    ,; // cIncrementa
                                                                 .T.,; // Habilita a opção de deletar linhas do aCols. Valor padrão falso
                                                           aAltFld_f,; // Campos que podem ser alterados
                                                                    ,; // Indica qual coluna não ficara congelada na exibição
                                                                    ,; // lVazio: Habilita validação da primeira coluna do aCols para esta não poder estar vazia. Valor padrão falso.
                                                                    ,; // Reservado
                                                             "Work5",; // Work que será mostrada no Browse
                                                                    ,; // Função executada na validação do campo
                                                                    ,; // Reservado
                                                                 .T.,; // Define se as linhas poderão ser incluídas
                                                              oFld_f,; // Objeto no qual está inserida a MsGetDb
                                                                 .F.,; // Define se vai utilizar características do dicionário (gatilhos, consultas...)
                                                                    ,; // Reservado
                                                     "AllwaysTrue()",; // Função que valida exclusão
                                                                    ,) // Função executada quando pressionada as teclas <Ctrl>+<Delete>

      oGetDb_f:oBrowse:Refresh()
      
      
      /*-------------
        Dados do transportador
        -------------------------*/

      nFld_g:= 7
      nLin:= 10
      nCol:= 5
      
      TSay():New(nLin       , nCol     , {|| STR0010}, aFld[nFld_g],,,,,, .T.) //Razão Social
      TGet():New(xLin2(nLin), nCol + 35, BSetGet(cNomeTransp), aFld[nFld_g], 210, 08, "@!",,,,,,, .T.)
      
      TSay():New(xLin1(nLin), nCol     , {|| STR0011}, aFld[nFld_g],,,,,, .T.) //Endereço
      TGet():New(xLin2(nLin), nCol + 35, BSetGet(cEndTransp), aFld[nFld_g], 230, 08, "@!",,,,,,, .T.)      
              
      TSay():New(xLin1(nLin), nCol     , {|| STR0012}, aFld[nFld_g],,,,,, .T.) //Insc. Estadual
      TGet():New(xLin2(nLin), nCol + 35, BSetGet(cInsEstTransp), aFld[nFld_g], 150, 08, X3Picture("A2_INSCR"),,,,,,, .T.)
      
      TSay():New(xLin1(nLin), nCol     , {|| STR0013}, aFld[nFld_g],,,,,, .T.) //CNPJ
      TGet():New(xLin2(nLin), nCol + 35, BSetGet(cCNPJTrans), aFld[nFld_g], 150, 08, X3Picture("A2_CGC"),,,,,,, .T.)


      /*-------------
        Representante legal do exportador/ responsável
        -------------------------------------------------*/
      
      nFld_h:= 8
      nLin:= 10
      nCol:= 5
      
      TSay():New(nLin       , nCol     , {|| STR0022}, aFld[nFld_h],,,,,, .T.) //Nome
      TGet():New(xLin2(nLin), nCol + 25, BSetGet(cAssExp), aFld[nFld_h], 100, 08, "@!", {||AllwaysTrue(cCargoAss:= EE3->EE3_CARGO)},,,,,, .T.,,,,,,,,, "E33")
      
      TSay():New(xLin1(nLin), nCol     , {|| STR0023}, aFld[nFld_h],,,,,, .T.) //Cargo
      TGet():New(xLin2(nLin), nCol + 25, BSetGet(cCargoAss), aFld[nFld_h], 100, 08, "@!",,,,,,, .T.)

      TSay():New(xLin1(nLin), nCol     , {|| STR0024}, aFld[nFld_h],,,,,, .T.) //Data da emissão
      TGet():New(xLin2(nLin), nCol + 42, BSetGet(dDtMemExp), aFld[nFld_h], 40, 08, "@!",,,,,,, .T.)
                                                          
      //DFS - 24/08/12 - Inclusão da aba "Informações Adicionais" para preenchimento diverso na impressão do relatório
      nFld_i:= 9
      nLin:= 10
      nCol:= 5
      TSay():New(xLin1(nLin), nCol     , {|| STR0056}, aFld[nFld_i],,,,,, .T.) //Informações Adicionais
      TGet():New(xLin2(nLin), nCol + 72, BSetGet(cInfCompl), aFld[nFld_i], 230, 08, "@!",,,,,,, .T.)      
      
      //DFS - 31/10/12 - Inclusão de Nr e Data da DSE.
      TSay():New(xLin1(nLin), nCol     , {|| STR0057}, aFld[nFld_i],,,,,, .T.) //Número DSE
      TGet():New(xLin2(nLin), nCol + 72, BSetGet(cNumDSE), aFld[nFld_i], 230, 08, "@!",,,,,,, .T.)    
      
      TSay():New(xLin1(nLin), nCol     , {|| STR0058}, aFld[nFld_i],,,,,, .T.) //Data DSE
      TGet():New(xLin2(nLin), nCol + 72, BSetGet(dDtDSE), aFld[nFld_i], 40, 08, "@!",,,,,,, .T.)    


      Eval(bRefresh)
   Activate MsDialog oDlg Centered On Init EnchoiceBar(oDlg, bOk, bCancel,, aButtons)

End Sequence

Return

/*
Função      : GeraRelatorio
Parâmetros  : nFabr - posição do array correspondente ao produtor/ fabricante.
Retorno     : 
Objetivos   : Gera o memorando de exportação para o produtor/ fabricante.
Autor       : Wilsimar Fabrício da Silva
Data/Hora   : 02/09/09
Revisão     : 
Obs.        :
*/
Static Function GeraRelatorio(nFabr)
Local cSeqRel,;
      cEstProd:= ""
Local nCont, nCont2
Local lRet:= .F.

Begin Sequence

      //Será impresso um memorando por estado produtor/ fabricante

      cEstProd:= aFabricante[nFabr][4] //Estado produtor

      cSeqRel:= GetSxeNum("SY0", "Y0_SEQREL")

      For nCont:= 1 To 3 //3 //número de vias - alteração conforme convênio 84/09

         ConfirmSx8()

         //Captura do SeqRel para a gravação do histório (vias do Header)
         
         /*------------------
           Gravação do Header
           -------------------*/
      
         HEADER_P->(DBAppend())

         HEADER_P->AVG_C01_10 := AllTrim(Str(nCont))
         HEADER_P->AVG_CHAVE  := EEC->EEC_PREEMB
         //DFS - 02/10/12 - Inclusão de header para filial
         HEADER_P->AVG_FILIAL := xFilial("SY0")
         HEADER_P->AVG_SEQREL := cSeqRel
         
         HEADER_P->AVG_C16_20:= cNumMemo


         //Exportador
         HEADER_P->AVG_C01_60:= cNomeExp
         HEADER_P->AVG_C01100:= AllTrim(cEndExp)
         HEADER_P->AVG_C01_20:= Transf(cInscExp, X3Picture("A2_INSCR"))
         HEADER_P->AVG_C02_20:= Transf(cCnpjExp, X3Picture("A2_CGC"))


         //Dados da Exportação
         HEADER_P->AVG_C03_20:= cNrDDE
         HEADER_P->AVG_C02_10:= DtoC(dDataDDE)
         HEADER_P->AVG_C04_20:= cNrConh
         HEADER_P->AVG_C03_10:= DtoC(dDtConh)
         HEADER_P->AVG_C05_10:= cEstProd
         HEADER_P->AVG_C01_30:= cPaisDest
      
      
         //Remetente com fim específico de exportação
         /* Array aFabricante
            1. fabricante
            2. razão social
            3. endereço
            4. estado produtor
            5. inscrição estatual
            6. CNPJ
         */
         HEADER_P->AVG_C04_60:= aFabricante[nFabr][2]
         HEADER_P->AVG_C02100:= AllTrim(aFabricante[nFabr][3])
         HEADER_P->AVG_C07_20:= Transf(aFabricante[nFabr][5], X3Picture("A2_INSCR"))
         HEADER_P->AVG_C08_20:= Transf(aFabricante[nFabr][6], X3Picture("A2_CGC"))
         

         //Dados do transportador
         HEADER_P->AVG_C02_60:= cNomeTransp
         HEADER_P->AVG_C03100:= cEndTransp
         HEADER_P->AVG_C14_20:= Transf(cInsEstTransp, X3Picture("A2_INSCR"))
         HEADER_P->AVG_C15_20:= Transf(cCNPJTrans, X3Picture("A2_CGC"))
         

         //Representante legal do exportador/ responsável
         HEADER_P->AVG_C02_30:= cAssExp
         HEADER_P->AVG_C03_30:= cCargoAss
         HEADER_P->AVG_C04_10:= DtoC(dDtMemExp)
      
         //Informações Adicionais         
         //DFS - 24/08/12 - Atribuição do conteudo para o rpt
         HEADER_P->AVG_C01150 := cInfCompl
         HEADER_P->AVG_C05_20 := cNumDSE
         HEADER_P->AVG_C06_10:= DtoC(dDtDSE)
         
         HEADER_P->(MsUnlock())
      
                
         //Gravação do histórico de documentos
         HEADER_H->(RecLock("HEADER_H", .T.))
         AvReplace("HEADER_P","HEADER_H")         
         HEADER_H->AVG_SEQREL:= cSeqRel
         HEADER_H->(MsUnlock())

                
         /*------------------
           Gravação do Detail
           -------------------*/
                  
         //A gravação do Detail é realizada apenas uma vez
         If nCont == 1

            //Dados da Exportação
            //Notas fiscais de venda
            For nCont2:= 1 To Len(aNotasExp)
   
               /*Array aNotasExp
                 1. Nota fiscal
                 2. Modelo
                 3. Série
                 4. Data
               */
               DETAIL_P->(RecLock("DETAIL_P", .T.))
               DETAIL_P->AVG_CHAVE  := EEC->EEC_PREEMB
               //DFS - 02/10/12 - Inclusão de detail para filial
               DETAIL_P->AVG_FILIAL := xFilial("SY0")
               DETAIL_P->AVG_SEQREL := cSeqRel

               DETAIL_P->AVG_C01_10:= "A"
               DETAIL_P->AVG_C05_20:= AllTrim(aNotasExp[nCont2][1])
               DETAIL_P->AVG_C04_10:= AllTrim(aNotasExp[nCont2][2])
               DETAIL_P->AVG_C05_10:= AllTrim(aNotasExp[nCont2][3])
               DETAIL_P->AVG_C06_20:= DtoC(aNotasExp[nCont2][4])

               DETAIL_P->(MsUnlock())

            Next

            //Registro de exportação
            For nCont2:= 2 To Len(aRe[nFabr])

               DETAIL_P->(RecLock("DETAIL_P", .T.))
               DETAIL_P->AVG_CHAVE  := EEC->EEC_PREEMB
               //DFS - 02/10/12 - Inclusão de detail para filial
               DETAIL_P->AVG_FILIAL := xFilial("SY0")
               DETAIL_P->AVG_SEQREL := cSeqRel
               DETAIL_P->AVG_C01_10 := "B"

               DETAIL_P->AVG_C04_20:= AllTrim(Transf(aRe[nFabr][nCont2][1], X3Picture("EE9_RE")))
               DETAIL_P->AVG_C02_10:= DtoC(aRe[nFabr][nCont2][2])

               DETAIL_P->(MsUnlock())

            Next
            
            
            //Discriminação dos produtos exportados
            For nCont2:= 2 To Len(aProdutos[nFabr])
      
               /* Array aProdutos
                  x.1   - Produtor/ Fabricante
                  x.2.1 - Quant.
                  x.2.2 - Unid.
                  X.2.3 - NCM
                  x.2.4 - Descrição
                  x.2.5 - Vl. Unit.
                  x.2.6 - Vl. Total
                  x.2.7 - Código do produto
                  x.2.8 - RE
                  x.2.9 - Data RE
               */

               DETAIL_P->(RecLock("DETAIL_P", .T.))
               DETAIL_P->AVG_CHAVE  := EEC->EEC_PREEMB
               //DFS - 02/10/12 - Inclusão de detail para filial
               DETAIL_P->AVG_FILIAL := xFilial("SY0")
               DETAIL_P->AVG_SEQREL := cSeqRel
               DETAIL_P->AVG_C01_10 := "C"
               //DFS - 02/10/12 - Inclusão de picture de acordo com o que foi digitado nas configurações do embarque
               DETAIL_P->AVG_C01_20:= AllTrim(Transf(aProdutos[nFabr][nCont2][1], cPictQtde))
               DETAIL_P->AVG_C03_10:= aProdutos[nFabr][nCont2][2]
               DETAIL_P->AVG_C02_10:= AllTrim(Transf(aProdutos[nFabr][nCont2][3], X3Picture("EE9_POSIPI")))
               DETAIL_P->AVG_C01150:= aProdutos[nFabr][nCont2][4]                             
               //DFS - 02/10/12 - Inclusão de picture de acordo com o que foi digitado nas configurações do embarque
               DETAIL_P->AVG_C02_20:= AllTrim(Transf(aProdutos[nFabr][nCont2][5], cPictPreco))
               DETAIL_P->AVG_C03_20:= AllTrim(Transf(aProdutos[nFabr][nCont2][6], X3Picture("EE9_PRCINC")))

               DETAIL_P->(MsUnlock())

            Next


            //Dados dos documentos fiscais de remessa.
            //Tratamento para impedir que a linha não seja suprimida quando não houver dados.
            If Len(aNfRemessa[nFabr]) < 2
               AAdd(aNfRemessa[nFabr], {"", "", "", CtoD(""), 0, "", "", ""})
            EndIf

            For nCont2:= 2 To Len(aNfRemessa[nFabr])

               /*
                 Array aNfRemessa
                 x.1   - Produtor/ Fabricante
                 x.2.1 - Nota fiscal de remessa
                 x.2.2 - Modelo
                 x.2.3 - Série
                 x.2.4 - Emissão
                 x.2.5 - Quantidade
                 x.2.6 - Unidade
                 x.2.7 - NCM
                 x.2.8 - Descrição
               */

               DETAIL_P->(RecLock("DETAIL_P", .T.))
               DETAIL_P->AVG_CHAVE  := EEC->EEC_PREEMB
               //DFS - 02/10/12 - Inclusão de detail para filial
               DETAIL_P->AVG_FILIAL := xFilial("SY0")
               DETAIL_P->AVG_SEQREL := cSeqRel

               //Flag usada para suprimir informações no crystal
               DETAIL_P->AVG_C01_10:= "D"

               DETAIL_P->AVG_C07_20:= AllTrim(aNfRemessa[nFabr][nCont2][1])
               DETAIL_P->AVG_C08_20:= AllTrim(aNfRemessa[nFabr][nCont2][2])
               DETAIL_P->AVG_C09_20:= AllTrim(aNfRemessa[nFabr][nCont2][3])
               DETAIL_P->AVG_C10_20:= DtoC(aNfRemessa[nFabr][nCont2][4])                    
               //DFS - 02/10/12 - Inclusão de picture de acordo com o que foi digitado nas configurações do embarque
               DETAIL_P->AVG_C06_20:= AllTrim(Transf(aNfRemessa[nFabr][nCont2][5], cPictQtde))
               DETAIL_P->AVG_C02_10:= AllTrim(aNfRemessa[nFabr][nCont2][6])
               DETAIL_P->AVG_C03_10:= AllTrim(Transf(aNfRemessa[nFabr][nCont2][7], X3Picture("B1_POSIPI")))
               DETAIL_P->AVG_C01_60:= AllTrim(aNfRemessa[nFabr][nCont2][8])
               DETAIL_P->(MsUnlock())

            Next

            //Dados dos conhecimentos de transporte
            //Tratamento para impedir que a linha não seja suprimida quando não houver dados.
            If Len(aConhTransp[nFabr]) < 2
               AAdd(aConhTransp[nFabr], {"", "", "", CtoD("")})
            EndIf

            For nCont2:= 2 To Len(aConhTransp[nFabr])
               /*
                  Array aConhTransp
                  x.1   - Produtor/Fabricante
                  x.2.1 - Núm. Conhec.
                  x.2.2 - Modelo
                  x.2.3 - Série
                  x.2.4 - Data de emissão
               */

               DETAIL_P->(RecLock("DETAIL_P", .T.))
               DETAIL_P->AVG_CHAVE  := EEC->EEC_PREEMB
               //DFS - 02/10/12 - Inclusão de detail para filial
               DETAIL_P->AVG_FILIAL := xFilial("SY0")
               DETAIL_P->AVG_SEQREL := cSeqRel

               //Flag usada para suprimir informações no crystal
               DETAIL_P->AVG_C01_10:= "E"
               
               DETAIL_P->AVG_C07_20:= AllTrim(aConhTransp[nFabr][nCont2][1])
               DETAIL_P->AVG_C08_20:= AllTrim(aConhTransp[nFabr][nCont2][2])
               DETAIL_P->AVG_C09_20:= AllTrim(aConhTransp[nFabr][nCont2][3])
               DETAIL_P->AVG_C10_20:= DtoC(aConhTransp[nFabr][nCont2][4])

               DETAIL_P->(MsUnlock())

               Work5->(DBSkip())
            Next
         EndIf


      Next //número de vias

      //Gravação do histórico dos itens
      DETAIL_P->(DBGoTop())
      
      While Detail_P->(!Eof())

         DETAIL_H->(RecLock("DETAIL_H", .T.))
         AvReplace("DETAIL_P", "DETAIL_H")
         DETAIL_H->(MsUnlock())
         
         Detail_P->(DBSkip())
      EndDo
      
      //Histórico SY0
      E_HISTDOC( , STR0001, dDataBase,,, cRpt, cSeqRel, "2", EEC->EEC_PREEMB, "26") //Memorando de Exportação


      //Gerando a impressão do relatório
      If !(lRet:= AvgCrw32(cRpt, STR0001, cSeqRel)) //Memorando de Exportação
         Break
      EndIf
      
      //Gravação do número do memorando de exportação na tabela EXL
      If EXL->(DBSeek(xFilial() + EEC->EEC_PREEMB))
         EXL->(RecLock("EXL", .F.))
         EXL->EXL_NROMEX:= cNumMemo
         EXL->EXL_DTMEX := DtoC(dDtMemExp)
         EXL->(MsUnLock())
      EndIf

End Sequence
Return lRet

/*
Função      : GeraTodos
Parâmetros  : 
Retorno     : lRet - .T. se o usuário optou por gerar o relatório; .F. se a operação foi cancelada.
Objetivos   : Gerar o memorando de exportação para todos os produtores/ fabricantes do processo.
Autor       : Wilsimar Fabrício da Silva
Data/Hora   : 02/09/09
Revisão     : 
Obs.        :
*/
Static Function GeraTodos()
Local nCont
local lRet:= .F.

Begin Sequence

   If MsgYesNo(STR0046 + AllTrim(EEC->EEC_PREEMB) + "." + ENTER + STR0047, STR0045) //Esta operação gerará o memorando de exportação para todos os produtores/ fabricantes do processo ###. Deseja prosseguir? / Aviso
      For nCont:= 1 To Len(aFabricante)
         GeraRelatorio(nCont)
      Next
      
      MsgInfo(STR0048) //Operação realizada com sucesso.
      lRet:= .T.
   EndIf
   
End Sequence
Return lRet

/*
Função      : CriaWorks
Parâmetros  : 
Retorno     : 
Objetivos   : Criação das works que serão usadas no objeto MsGetDb, possibilitando que o usuário
              digite as informações adicionais para os itens do produtor/ fabricante.
              As works são montadas com base nas informações carregadas na função LoadDetalhe.
Autor       : Wilsimar Fabrício da Silva
Data/Hora   : 21/09/2009
Revisão     : 
Obs.        :
*/
Static Function CriaWorks(nFabr)
Local aEstrutura:= {}
Local cArq, cAlias
Local nCont

Begin Sequence
   
   /* Array aProdutos
      x.1   - Fabricante
      x.2.1 - Quantidade
      x.2.2 - Unidade
      X.2.3 - NCM
      x.2.4 - Descrição
      x.2.5 - Valor unitário
      x.2.6 - Valor total
      x.2.7 - Código do produto
      x.2.8 - Registro de exportação
      x.2.9 - Data do RE
   */

   /*------------
     Dados da exportação
     ----------------------*/
   //Registro de exportação
   aEstrutura:= {{"WK_COD"   , "C", AvSx3("EE9_COD_I", AV_TAMANHO), 0},;
                 {"WK_DESC"  , "C", AvSx3("C6_DESCRI", AV_TAMANHO), 0},;
                 {"WK_RE"    , "C", AvSx3("EE9_RE"   , AV_TAMANHO), 0},;
                 {"WK_DTRE"  , "D", AvSx3("EE9_DTRE" , AV_TAMANHO), 0},;
                 {"WK_FLAG"  , "L", 1                             , 0}}

   cArq:= CriaTrab(aEstrutura, .T.)
   cAlias:= "Work1"
   DBUseArea(.T., __LocalDriver, cArq, cAlias, .T., .F.)

   //Armazena os arquivos criados para exclusão
   AAdd(aArq, {cAlias, cArq})

   //Alimenta a Work
   For nCont:= 2 To Len(aProdutos[nFabr])
      (cAlias)->(DBAppend())
      (cAlias)->WK_COD := aProdutos[nFabr][nCont][7]
      (cAlias)->WK_DESC:= aProdutos[nFabr][nCont][4]
      (cAlias)->WK_RE  := aProdutos[nFabr][nCont][8]
      (cAlias)->WK_DTRE:= aProdutos[nFabr][nCont][9]
   Next
   (cAlias)->(DBGoTop())

   /*Notas fiscais do exportador. Serão apenas exibidas.
     Array aNotasExp
     1. Nota fiscal
     2. Modelo
     3. Série
     4. Data
   */
   aEstrutura:= {{"WK_NFEXP"  , "C", AvSx3("D1_DOC", AV_TAMANHO)    , 0},;
                 {"WK_MODNFEX", "C", 3                              , 0},;
                 {"WK_SERNFEX", "C", AvSx3("D1_SERIE", AV_TAMANHO)  , 0},;
                 {"WK_DTNFREX", "D", AvSx3("D1_EMISSAO", AV_TAMANHO), 0},;
                 {"WK_FLAG"   , "L", 1                              , 0}}

   cArq:= CriaTrab(aEstrutura, .T.)
   cAlias:= "Work4"
   DBUseArea(.T., __LocalDriver, cArq, cAlias, .T., .F.)

   //Armazena os arquivos criados para exclusão
   AAdd(aArq, {cAlias, cArq})

   //Alimenta a Work
   For nCont:= 1 To Len(aNotasExp)
      (cAlias)->(DBAppend())
      (cAlias)->WK_NFEXP  := aNotasExp[nCont][1]
      (cAlias)->WK_MODNFEX:= aNotasExp[nCont][2]
      (cAlias)->WK_SERNFEX:= aNotasExp[nCont][3]
      (cAlias)->WK_DTNFREX:= aNotasExp[nCont][4]
   Next
   (cAlias)->(DBGoTop())   



   /*----------------------
     Discriminação dos produtos exportados
     ---------------------------------------*/
   aEstrutura:= {{"WK_COD"   , "C", AvSx3("EE9_COD_I" , AV_TAMANHO), 0                              },;
                 {"WK_POSIPI", "C", AvSx3("EE9_POSIPI", AV_TAMANHO), 0                              },;
                 {"WK_DESC"  , "C", AvSx3("C6_DESCRI" , AV_TAMANHO), 0                              },;
                 {"WK_QTD"   , "N", AvSx3("EE9_SLDINI", AV_TAMANHO), AvSx3("EE9_SLDINI", AV_DECIMAL)},;
                 {"WK_UNID"  , "C", AvSx3("EE9_UNIDAD", AV_TAMANHO), 0                              },;
                 {"WK_VLUNIT", "N", AvSx3("EE9_PRECO" , AV_TAMANHO), AvSx3("EE9_PRECO", AV_DECIMAL) },;
                 {"WK_VLTOT" , "N", AvSx3("EE9_PRCTOT", AV_TAMANHO), AvSx3("EE9_PRCTOT", AV_DECIMAL)},;
                 {"WK_FLAG"  , "L", 1                              , 0                              }}


   cArq:= CriaTrab(aEstrutura, .T.)
   cAlias:= "Work2"
   DBUseArea(.T., __LocalDriver, cArq, cAlias, .T., .F.)

   //Armazena os arquivos criados para exclusão
   AAdd(aArq, {cAlias, cArq})

   //Alimenta a Work
   For nCont:= 2 To Len(aProdutos[nFabr])
      (cAlias)->(DBAppend())
      (cAlias)->WK_COD   := aProdutos[nFabr][nCont][7]
      (cAlias)->WK_POSIPI:= aProdutos[nFabr][nCont][3]
      (cAlias)->WK_DESC  := aProdutos[nFabr][nCont][4]
      (cAlias)->WK_QTD   := aProdutos[nFabr][nCont][1]
      (cAlias)->WK_UNID  := aProdutos[nFabr][nCont][2]
      (cAlias)->WK_VLUNIT:= aProdutos[nFabr][nCont][5]
      (cAlias)->WK_VLTOT := aProdutos[nFabr][nCont][6]
   Next
   (cAlias)->(DBGoTop())    



   /*---------------------
     Dados dos documentos fiscais de remessa
     ------------------------------------------*/
   /*
     Array aNfRemessa
     x.1   - Produtor/ Fabricante
     x.2.1 - Nota fiscal de remessa
     x.2.2 - Modelo
     x.2.3 - Série
     x.2.4 - Emissão
     x.2.5 - Quantidade
     x.2.6 - Unidade
     x.2.7 - NCM
     x.2.8 - Descrição
   */
   aEstrutura:= {{"WK_NFREM"  , "C", AvSx3("D1_DOC", AV_TAMANHO)    , 0},;
                 {"WK_MODNFRE", "C", 3                              , 0},;
                 {"WK_SERNFRE", "C", AvSx3("D1_SERIE", AV_TAMANHO)  , 0},;
                 {"WK_DTNFREM", "D", AvSx3("D1_EMISSAO", AV_TAMANHO), 0},;
                 {"WK_QTDNFRE", "N", AvSx3("D1_QUANT", AV_TAMANHO)  , AvSx3("D1_QUANT", AV_DECIMAL)},;
                 {"WK_UNINFRE", "C", AvSx3("D1_UM", AV_TAMANHO)     , 0},;
                 {"WK_NCMNFRE", "C", AvSx3("B1_POSIPI", AV_TAMANHO) , 0},;
                 {"WK_DESCNFR", "C", AvSx3("B1_DESC", AV_TAMANHO)   , 0},;
                 {"WK_FLAG"   , "L", 1                              , 0}}

   cArq:= CriaTrab(aEstrutura, .T.)
   cAlias:= "Work3"
   DBUseArea(.T., __LocalDriver, cArq, cAlias, .T., .F.)

   //Armazena os arquivos criados para exclusão
   AAdd(aArq, {cAlias, cArq})

   //Alimenta a Work
   For nCont:= 2 To Len(aNfRemessa[nFabr])
      (cAlias)->(DBAppend())
      (cAlias)->WK_NFREM  := aNfRemessa[nFabr][nCont][1]
      (cAlias)->WK_MODNFRE:= aNfRemessa[nFabr][nCont][2]
      (cAlias)->WK_SERNFRE:= aNfRemessa[nFabr][nCont][3]
      (cAlias)->WK_DTNFREM:= aNfRemessa[nFabr][nCont][4]
      (cAlias)->WK_QTDNFRE:= aNfRemessa[nFabr][nCont][5]
      (cAlias)->WK_UNINFRE:= aNfRemessa[nFabr][nCont][6]
      (cAlias)->WK_NCMNFRE:= aNfRemessa[nFabr][nCont][7]
      (cAlias)->WK_DESCNFR:= aNfRemessa[nFabr][nCont][8]
   Next
   (cAlias)->(DBGoTop())

   //Se não houver dados, o append permite que o usuário inclua no objeto GetDb.
   If (cAlias)->(RecCount()) == 0
      (cAlias)->(DBAppend())
   EndIf


   /*-------------------
     Dados dos conhecimentos de transporte
     ---------------------------------------*/
   /*
     Array aConhTransp
     x.1   - Produtor/ Fabricante
     x.2.1 - Conhecimento de transporte
     x.2.2 - Modelo
     x.2.3 - Série
     x.2.4 - Data
   */
   aEstrutura:= {{"WK_NUMCONH", "C", 20                             , 0},;
                 {"WK_MODCONH", "C", 3                              , 0},;
                 {"WK_SERCONH", "C", 3                              , 0},;
                 {"WK_DTCONH" , "D", AVSx3("D1_EMISSAO", AV_TAMANHO), 0},;
                 {"WK_FLAG"   , "L", 1                              , 0}}

   cArq:= CriaTrab(aEstrutura, .T.)
   cAlias:= "Work5"
   DBUseArea(.T., __LocalDriver, cArq, cAlias, .T., .F.)

   //Armazena os arquivos criados para exclusão
   AAdd(aArq, {cAlias, cArq})

   //Alimenta a Work
   For nCont:= 2 To Len(aConhTransp[nFabr])
      (cAlias)->(DBAppend())
      (cAlias)->WK_NUMCONH:= aConhTransp[nFabr][nCont][1]
      (cAlias)->WK_MODCONH:= aConhTransp[nFabr][nCont][2]
      (cAlias)->WK_SERCONH:= aConhTransp[nFabr][nCont][3]
      (cAlias)->WK_DTCONH := aConhTransp[nFabr][nCont][4]
   Next
   (cAlias)->(DBGoTop())

   //Se não houver dados, o append permite que o usuário inclua no objeto GetDb.
   If (cAlias)->(RecCount()) == 0
      (cAlias)->(DBAppend())
   EndIf

   DBSelectArea("EEC")
End Sequence
Return


/*
Função      : EncerraWorks
Parâmetros  : 
Retorno     : 
Objetivos   : Fechar as works abertas e apagar os arquivos criados.
Autor       : Wilsimar Fabrício da Silva
Data/Hora   : 21/09/2009
Revisão     : 
Obs.        : Usa a variável private aArq
*/
Static Function EncerraWorks()
Local nCont

Begin Sequence

   For nCont:= 1 To Len(aArq)
      If Select(aArq[nCont][1]) > 0
         (aArq[nCont][1])->(DBCloseArea())
      EndIf
      FErase(aArq[nCont][2])
   Next

   aArq:= {}
End Sequence
Return

/*
Função      : LoadHeader
Parâmetros  : 
Retorno     : 
Objetivos   : Criar o array aHeader, necessário para o uso do objeto MsGetDb
Autor       : Wilsimar Fabrício da Silva
Data/Hora   : 22/09/2009
Revisão     : 
Obs.        :
*/
Static Function LoadHeader()

/*   
AAdd(X3Titulo(),;
     SX3->X3_CAMPO,;
     SX3->X3_PICTURE,;
     SX3->X3_TAMANHO,;
     SX3->X3_DECIMAL,;
     SX3->X3_VALID,;
     ,;
     SX3->X3_TIPO,;
     ,;
      })
*/

Begin Sequence

   AAdd(aHeader, {STR0026,; //Código
                  "WK_COD",;
                  X3Picture("EE9_COD_I"),;
                  AvSx3("EE9_COD_I", AV_TAMANHO),;
                  0,;
                  "",;
                  ,;
                  "C"}) 

   AAdd(aHeader, {STR0027,; //Descrição
                  "WK_DESC",;
                  "@!",;
                  AvSx3("C6_DESCRI" , AV_TAMANHO),;
                  0,;
                  "",;
                  ,;
                  "C"})
   //DFS - 02/10/12 - Inclusão de picture de acordo com o que foi digitado nas configurações do embarque
   AAdd(aHeader, {STR0031,; //Quantidade
                  "WK_QTD",;
                  cPictQtde,;
                  AvSx3("EE9_SLDINI", AV_TAMANHO),;
                  AvSx3("EE9_SLDINI", AV_DECIMAL),;
                  "",;
                  ,;
                  "N"})
                  
   AAdd(aHeader, {STR0028,; //Unidade
                  "WK_UNID",;
                  "@!",;
                  AvSx3("EE9_UNIDAD", AV_TAMANHO),;
                  0,;
                  "",;
                  ,;
                  "C"})

   AAdd(aHeader, {STR0055,; //N.C.M.
                  "WK_POSIPI",;
                  X3Picture("EE9_POSIPI"),;
                  AvSx3("EE9_POSIPI", AV_TAMANHO),;
                  0,;
                  "",;
                  ,;
                  "C"})
  
   //DFS - 02/10/12 - Inclusão de picture de acordo com o que foi digitado nas configurações do embarque
   AAdd(aHeader, {STR0029,; //Valor unitário
                  "WK_VLUNIT",;
                  cPictPreco,;
                  AvSx3("EE9_PRECO" , AV_TAMANHO),;
                  AvSx3("EE9_PRECO" , AV_DECIMAL),;
                  "",;
                  ,;
                  "N"})

   AAdd(aHeader, {STR0030,; //Valor total
                  "WK_VLTOT",;
                  X3Picture("EE9_PRCTOT"),;
                  AvSx3("EE9_PRCTOT", AV_TAMANHO),;
                  AvSx3("EE9_PRCTOT", AV_DECIMAL),;
                  "",;
                  ,;
                  "N"})

   AAdd(aHeader, {STR0032,; //Registro de exportação
                  "WK_RE",;
                  X3Picture("EE9_RE"),;
                  AvSx3("EE9_RE", AV_TAMANHO),;
                  0,;
                  "",;
                  ,;
                  "C"})                  

   AAdd(aHeader, {STR0033,; //Data do R.E.
                  "WK_DTRE",;
                  X3Picture("EE9_DTRE"),;
                  AvSx3("EE9_DTRE", AV_TAMANHO),;
                  AvSx3("EE9_DTRE", AV_DECIMAL),;
                  "",;
                  ,;
                  "D"})
                     
   AAdd(aHeader, {STR0034,; //NF de remessa
                  "WK_NFREM",;
                  X3Picture("D1_DOC"),;
                  AvSx3("D1_DOC", AV_TAMANHO),;
                  AvSx3("D1_DOC", AV_DECIMAL),;
                  "",;
                  ,;
                  "C"})

   AAdd(aHeader, {STR0020,; //Modelo
                  "WK_MODNFRE",;
                  "@!",;
                  3,;
                  0,;
                  "",;
                  ,;
                  "C"})
                  
   AAdd(aHeader, {STR0021,; //Série
                  "WK_SERNFRE",;
                  X3Picture("D1_SERIE"),;
                  AvSx3("D1_SERIE", AV_TAMANHO),;
                  0,;
                  "",;
                  ,;
                  "C"})
                  
   AAdd(aHeader, {STR0024,; //Data da emissão
                  "WK_DTNFREM",;
                  X3Picture("D1_EMISSAO"),;
                  AvSx3("D1_EMISSAO", AV_TAMANHO),;
                  0,;
                  "",;
                  ,;
                  "D"})

   AAdd(aHeader, {SubStr(STR0031, 1, 5) + ".",; //Quantidade
                  "WK_QTDNFRE",;
                  X3Picture("D1_QUANT"),;
                  AvSx3("D1_QUANT", AV_TAMANHO),;
                  AvSx3("D1_QUANT", AV_DECIMAL),;
                  "",;
                  ,;
                  "N"})

   AAdd(aHeader, {SubStr(STR0028, 1, 4) + ".",; //Unidade
                  "WK_UNINFRE",;
                  X3Picture("D1_UM"),;
                  AvSx3("D1_UM", AV_TAMANHO),;
                  0,;
                  "",;
                  ,;
                  "C"})

   AAdd(aHeader, {STR0054,; //N.C.M.
                  "WK_NCMNFRE",;
                  X3Picture("B1_POSIPI"),;
                  AvSx3("B1_POSIPI", AV_TAMANHO),;
                  0,;
                  "",;
                  ,;
                  "C"})

   AAdd(aHeader, {SubStr(STR0027, 1, 4) + ".",; //Descrição
                  "WK_DESCNFR",;
                  X3Picture("B1_DESC"),;
                  AvSx3("B1_DESC", AV_TAMANHO),;
                  0,;
                  "",;
                  ,;
                  "C"})

   AAdd(aHeader, {STR0035,; //Nota Fiscal
                  "WK_NFEXP",;
                  X3Picture("D1_DOC"),;
                  AvSx3("D1_DOC", AV_TAMANHO),;
                  AvSx3("D1_DOC", AV_DECIMAL),;
                  "",;
                  ,;
                  "C"})

   AAdd(aHeader, {STR0020,; //Modelo
                  "WK_MODNFEX",;
                  "@!",;
                  3,;
                  0,;
                  "",;
                  ,;
                  "C"})
                  
   AAdd(aHeader, {STR0021,; //Série
                  "WK_SERNFEX",;
                  X3Picture("D1_SERIE"),;
                  AvSx3("D1_SERIE", AV_TAMANHO),;
                  0,;
                  "",;
                  ,;
                  "C"})
                  
   AAdd(aHeader, {STR0024,; //Data da emissão
                  "WK_DTNFREX",;
                  X3Picture("D1_EMISSAO"),;
                  AvSx3("D1_EMISSAO", AV_TAMANHO),;
                  0,;
                  "",;
                  ,;
                  "D"})

   AAdd(aHeader, {STR0039,; //Nº do conhecimento
                  "WK_NUMCONH",;
                  "@!",;
                  20,;
                  0,;
                  "",;
                  ,;
                  "C"})

   AAdd(aHeader, {STR0049,; //Mod. Conh.
                  "WK_MODCONH",;
                  "@!",;
                  3,;
                  0,;
                  "",;
                  ,;
                  "C"})
                  
   AAdd(aHeader, {STR0050,; //Série Conh.
                  "WK_SERCONH",;
                  "@!",;
                  3,;
                  0,;
                  "",;
                  ,;
                  "C"})
                  
   AAdd(aHeader, {STR0051,; //Data emissão
                  "WK_DTCONH",;
                  X3Picture("D1_EMISSAO"),;
                  AvSx3("D1_EMISSAO", AV_TAMANHO),;
                  0,;
                  "",;
                  ,;
                  "D"})


End Sequence
Return

/*
Função      : PEM26Campo()
Parâmetros  : 
Retorno     : 
Objetivos   : Gatilho para atualização do campo valor total do produto quando preenchido os campos quantidade e valor unitário.
Autor       : Wilsimar Fabrício da Silva
Data/Hora   : 23/09/2009
Revisão     : 
Obs.        :
*/
User Function PEM26Campo(cAlias)
Local lRet:= .T.
Local cVar:= ReadVar()

Begin Sequence

   (cAlias)->(RecLock(cAlias, .F.))
   Do Case
      Case "WK_QTD" $ cVar
         (cAlias)->WK_VLTOT:= M->WK_QTD * (cAlias)->WK_VLUNIT

      Case "WK_VLUNIT" $ cVar
         (cAlias)->WK_VLTOT:= M->WK_VLUNIT * (cAlias)->WK_QTD      

   EndCase
   (cAlias)->(MsUnlock())

End Sequence
Return lRet

/*
Função      : AtualizaDados()
Parâmetros  : nFabr - a posição do array correspondente ao produtor/ fabricante editado pelo usuário.
Retorno     : 
Objetivos   : Atualizar os arrays (detalhes) com os dados editados pelo usuário nas MsGetDb.
              As informações serão passadas das works para os arrays correspondentes.
Autor       : Wilsimar Fabrício da Silva
Data/Hora   : Setembro/2009
Revisão     : 
Obs.        :
*/

Static Function AtualizaDados(nFabr)
Local aReTemp:= {},;
      aNfRemTemp:= {}
Local nCont

Begin Sequence

   //Tratamento para armazenar as informações digitadas pelo usuário nos arrays correspondentes.
   
   /*--------------
     Dados da Exportação
     ---------------------------*/
   /*
      Atualiza o array aRe com as informações digitadas pelo usuário na tela de prévia, objeto MsGetDB,
      sem repetí-los. Permite que seja feito o tratamento de ordenação para a geração do memorando.
      Atualiza também o array aProdutos, onde os RE's estão separados por produto.
      Array aRe
      x.1   - Produtor/ Fabricante
      x.2.1 - Número RE
      x.2.2 - Data RE
   */
   
   Work1->(DBGoTop())
   nCont:= 2
   While Work1->(!Eof())

      If(AScan(aReTemp, {|x| AllTrim(x[1]) == AllTrim(Work1->WK_RE)})) == 0

         AAdd(aReTemp, {Work1->WK_RE, Work1->WK_DTRE})
      EndIf

      aProdutos[nFabr][nCont][8]:= Work1->WK_RE
      aProdutos[nFabr][nCont][9]:= Work1->WK_DTRE
      
      nCont++
      Work1->(DBSkip())
   End
   Work1->(DBGoTop())

   aReTemp:= ASort(aReTemp,,, {|x, y| x[1] < y[1] })

   aRe[nFabr]:={}
   AAdd(aRe[nFabr], aFabricante[nFabr][1])
   AEval(aReTemp, {|aTemp| AAdd(aRe[nFabr], aClone(aTemp))})
   
   /*----------------- 
     Discriminação dos produtos exportados
     --------------------------------------*/
   /*
      Atualiza o array aProdutos com as informações digitadas para o produto/ fabricante pelo usuário.

      x.1   - Fabricante
      x.2.1 - Quantidade
      x.2.2 - Unidade
      X.2.3 - NCM
      x.2.4 - Descrição
      x.2.5 - Valor unitário
      x.2.6 - Valor total
      x.2.7 - Código do produto
      x.2.8 - Registro de exportação
      x.2.9 - Data do RE
   */

   Work2->(DBGoTop())
   nCont:= 2
   While Work2->(!Eof())

      aProdutos[nFabr][nCont][1]:= Work2->WK_QTD
      aProdutos[nFabr][nCont][2]:= Work2->WK_UNID
      aProdutos[nFabr][nCont][3]:= Work2->WK_POSIPI
      aProdutos[nFabr][nCont][4]:= Work2->WK_DESC
      aProdutos[nFabr][nCont][5]:= Work2->WK_VLUNIT
      aProdutos[nFabr][nCont][6]:= Work2->WK_VLTOT

      nCont++
      Work2->(DBSkip())
   End
   Work2->(DBGoTop())


   /*--------------------------
     Dados dos documentos fiscais de remessa
     ----------------------------------------*/
   /*
      Atualiza o array aNfRemessa com as informações digitadas para o produto/ fabricante pelo usuário.
      Substitui as informações existentes no array pelas novas informadas.

      Array aNfRemessa
      x.1   - Produtor/ Fabricante
      x.2.1 - Nota fiscal de remessa
      x.2.2 - Modelo
      x.2.3 - Série
      x.2.4 - Emissão
      x.2.5 - Quantidade
      x.2.6 - Unidade
      x.2.7 - NCM
      x.2.8 - Descrição
   */
   
   //Armazena o produtor/ fabricante
   aNfRemTemp:= {aFabricante[nFabr][1]}
   
   Work3->(DBGoTop())
   
   While Work3->(!Eof())
      //Se a linha não foi deletada
      If Work3->WK_FLAG <> .T.
         AAdd(aNfRemTemp, {Work3->WK_NFREM,;
                           Work3->WK_MODNFRE,;
                           Work3->WK_SERNFRE,;
                           Work3->WK_DTNFREM,;
                           Work3->WK_QTDNFRE,;
                           Work3->WK_UNINFRE,;
                           Work3->WK_NCMNFRE,;
                           Work3->WK_DESCNFR})
      EndIf
      
      Work3->(DBSkip())
   End
   Work3->(DBGoTop())
   
   aNfRemessa[nFabr]:= AClone(aNfRemTemp)



   /*------------------------
     Dados dos conhecimentos de transporte
     ----------------------------------------*/
   /*
      Adiciona no array aConhTransp as os dados digitados para o produtor/ fabricante pelo usuário.
      Sempre zera o conteúdo do array para considerar os últimos lançamentos.

      Array aConhTransp
      x.1   - Produtor/Fabricante
      x.2.1 - Núm. Conhec.
      x.2.2 - Modelo
      x.2.3 - Série
      x.2.4 - Data de emissão
   */
   Work5->(DBGoTop())
   
   aConhTransp[nFabr]:= {aFabricante[nFabr][1]}

   While Work5->(!Eof())
      //Se a linha não foi deletada
      If Work5->WK_FLAG <> .T.
         AAdd(aConhTransp[nFabr], {Work5->WK_NUMCONH,;
                                   Work5->WK_MODCONH,;
                                   Work5->WK_SERCONH,;
                                   Work5->WK_DTCONH})
      EndIf

      Work5->(DBSkip())
   End
   Work5->(DBGoTop())

End Sequence
Return

/*
Função      : Navegacao()
Parâmetros  : nFabr - posição atual do array
              cNavegacao - ação que será executada (incremento ou decremento)
Retorno     : 
Objetivos   : Incrementar/ decrementar a variável que controla a posição do array correspondente à um produtor/ fabricante.
              Atualizar as works com as novas informações.
Autor       : Wilsimar Fabrício da Silva
Data/Hora   : 
Revisão     : 
Obs.        : 
*/

Static Function Navegacao(nFabr, cNavegacao)

Begin Sequence

   //Gera os dados para o próximo produtor/ fabricante
   Do Case
      Case cNavegacao == PROXIMO
         nFabr++
      Case cNavegacao == ANTERIOR
         nFabr--
   EndCase

   //Tratamento para impedir o estouro do array
   If nFabr < 1
      nFabr:= 1
      MsgInfo(STR0036) //Primeiro Registro
   ElseIf nFabr > Len(aFabricante)
      nFabr:= Len(aFabricante)
      MsgInfo(STR0040) //Último registro
   Else
      //Encerra e apaga os arquivos
      EncerraWorks()

      //Criação das Works usadas nas MsGetDB
      CriaWorks(nFabr)
   EndIf
   //NCF - 08/02/2012 - Memorando de Exportação por item
   If lCposMemExp
      cNumMemo := Substr( aFabricante[nFabr][1], Len(SA2->A2_COD)+Len(SA2->A2_LOJA)+1 )
   EndIf

End Sequence
Return

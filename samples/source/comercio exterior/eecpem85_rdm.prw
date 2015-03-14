
#include "EECRDM.CH"
#include "EECPEM85.CH"

/*
Funcao      : EECPEM85
Parametros  : Nenhum
Retorno     : lRet (.T.) - Se for Confirmado
                   (.F.) - Se for Cancelado
Objetivos   : Impressao do Packing List
Autor       : Eduardo C. Romanini
Data/Hora   : 12/02/2008 15:30
Obs.        : Utiliza o arquivo PEM85.rpt
*/
*----------------------*
User Function EECPEM85()
*----------------------*
Local lRet    := .T.
Local nAlias  := Select()
Local aOrd    := SaveOrd({"EX9","EYH"})

Private cArqRpt := "PEM85.RPT"
Private cTitRpt := STR0001//"Impressão do Packing List"

Private cUnidad   := "KG"
Private cUnidDe   := "KG"
Private cAssNome  := Space(60)
Private cAssEmp   := Space(60)
Private cAssCargo := Space(60)

// BAK - Tratamento para impressão da descricao do produto - 13/02/2013
Private lDescItem := .F.
Private lDescMarc := .F.

Begin Sequence
   
   //Unidade de Medida considerada na Estufagem
   If !Empty(EEC->EEC_UNIDAD)
      cUnidDe := EEC->EEC_UNIDAD
   EndIf
   
   //Tela de Parâmetros Iniciais
   If !TelaGets()
      lRet := .F.
      Break
   EndIf
    
   cSeqRel :=GetSXENum("SY0","Y0_SEQREL")
   ConfirmSX8()
 
   //Gravação dos Dados
   If !GravaDados()
      lRet := .F.
      Break
   EndIf
   
   //Gravação do Histórico
   HEADER_P->(DbGoTop())
   Do While !HEADER_P->(Eof())
      HEADER_H->(dbAppend())
      AvReplace("HEADER_P","HEADER_H") 
      HEADER_P->(DbSkip())
   EndDo   

   DETAIL_P->(DbGoTop())
   Do While !DETAIL_P->(Eof())
      DETAIL_H->(DbAppend())
      AvReplace("DETAIL_P","DETAIL_H")
      DETAIL_P->(DbSkip())
   EndDo   

End Sequence

RestOrd(aOrd)
Select(nAlias)

Return lRet 

/*
Funcao      : TelaGets()
Parametros  : Nenhum
Retorno     : lRet (.T.) - Se for Confirmado
                   (.F.) - Se for Cancelado
Objetivos   : Exibição da tela de parametros
Autor       : Eduardo C. Romanini
Data/Hora   : 12/02/2008 15:30
Obs.        : 
*/
*------------------------*
Static Function TelaGets()
*------------------------*
Local lRet := .F.

Local bOk     := {|| lRet := .T., oDlg:End()}
Local bCancel := {|| oDlg:End()}

// BAK - Tratamento para impressão da descricao do produto - 13/02/2013
Local bSetP := {|x,o| lDescItem   := x, o:Refresh(), lDescItem   }
Local bSetE := {|x,o| lDescMarc   := x, o:Refresh(), lDescMarc   }
Local lMarDesc  := GetMv("MV_AVG0200",,.F.) .And. EYH->(FieldPos("EYH_CODMAR")) > 0  

Local oFld, oDlg, oFldPar, oFldDoc, oFldDesc

Begin Sequence
                         	
   //Assinatura
   If !Empty(EEC->EEC_RESPON)
      cAssNome  := IncSpace(AllTrim(Upper(EEC->EEC_RESPON)),60,.F.) //Nome
   EndIf
    
   cAssEmp   := IncSpace(AllTrim(Upper(SM0->M0_NOMECOM)),60,.F.) //Empresa
   
   EE3->(DbSetOrder(2))
   If EE3->(DbSeek(xFilial("EE3")+EEC->EEC_RESPON))
      cAssCargo := IncSpace(Alltrim(Upper(EE3->EE3_CARGO)),60,.F.) //Cargo
   EndIf 
  
   DEFINE MSDIALOG oDlg TITLE STR0002 FROM 9,0 TO /*20*/25,50 OF oMainWnd //"Packing List"  // GFP - 18/05/2012 - Ajuste de tamanho de tela para versao 11.5
   
     If lMarDesc
        oFld := TFolder():New(15,1,{STR0003,STR0004,"Descrição da Mercadoria"},{"PAR","ASS","DES"},oDlg,,,,.T.,.F.,200,90) //"Parametros","Assinatura"
     Else
        oFld := TFolder():New(15,1,{STR0003,STR0004},{"PAR","ASS"},oDlg,,,,.T.,.F.,200,90) //"Parametros","Assinatura"\
     EndIf

     aEval(oFld:aControls,{|x| x:SetFont(oDlg:oFont)})

     //Folder Parâmetros
     oFldPar := oFld:aDialogs[1] 

     @ 06,05 TO 55,190 LABEL STR0005 OF oFldPar PIXEL //"Detalhes"
     @ 15,10 SAY STR0006 OF oFldPar PIXEL //"Unidade de Medida"
     @ 15,65 MSGET cUnidad  SIZE 20,07 F3 "SAH"  VALID (NaoVazio() .and. ExistCpo("SAH")) OF oFldPar PIXEL 
     
     //Folder Assinatura
     oFldDoc := oFld:aDialogs[2]     

     @ 06,05 TO 55,190 LABEL STR0005 OF oFldDoc PIXEL //"Detalhes"

     @ 15,10 SAY STR0007 OF oFldDoc PIXEL //"Responsável"
     @ 15,65 MSGET cAssNome SIZE 120,07 OF oFldDoc PIXEL 

     @ 25,10 SAY STR0008 OF oFldDoc PIXEL //"Empresa"
     @ 25,65 MSGET cAssEmp SIZE 120,07 OF oFldDoc PIXEL 

     @ 35,10 SAY STR0009 OF oFldDoc PIXEL //"Cargo"
     @ 35,65 MSGET cAssCargo SIZE 120,07 OF oFldDoc PIXEL 

     If lMarDesc
        oFldDesc := oFld:aDialogs[3]
        @ 06,05 TO 55,190 LABEL STR0005 OF oFldDesc PIXEL //"Detalhes"
        @ 15,10 SAY "Descrição da Mercadoria" OF oFldDesc PIXEL //"
        oDescItem := TCheckBox():New(25, 10 , "Descrição do item do processo"   ,{|x| If(PCount()==0, lDescItem,    Eval(bSetP,  x,oDescItem ))} ,oFldDesc,120,07)
        oDescMarc := TCheckBox():New(35, 10 , "Descrição do mercadoria estufada",{|x| If(PCount()==0, lDescMarc,    Eval(bSetE,  x,oDescMarc ))} ,oFldDesc,120,07)
     EndIf
 
   ACTIVATE MSDIALOG oDlg CENTERED ON INIT (EnchoiceBar(oDlg,bOk,bCancel))

End Sequence

Return lRet

/*
Funcao      : GravaDados()
Parametros  : Nenhum
Retorno     : lRet (.T.) - Se for gravado corretamente
                   (.F.) - Se não for gravado corretamente.
Objetivos   : Gravação dos Dados de Capa e Detalhe.
Autor       : Eduardo C. Romanini
Data/Hora   : 12/02/2008 15:30
Obs.        : 
*/
*--------------------------*
Static Function GravaDados()
*--------------------------*
Local lRet        := .T.

Local nX

Local n           := 0
Local nInc        := 0
Local nInc2       := 0
Local nIncCont    := 0
Local nPesoLqTo   := 0
Local nPesoBrTo   := 0
Local nPesLiq     := 0
Local nPesBru     := 0
Local nPallet     := 0
Local nTotCont    := 0
Local nContPallet := 0
Local nTotEmb     := 0
Local nTotPallet  := 0
Local nRecEYH     := 0
Local nLinha      := 0
Local nCub        := 0
Local nTotalCub   := 0

Local cPalletID   := ""
Local cCidEst     := ""
Local cEndereco   := ""
Local cPais       := ""
Local cContato    := ""

Local aItens      := {}
Local aPallet     := {}
Local aEmbExt     := {}

Begin Sequence
 
   EX9->(DbSetOrder(1))
   
   //Looping nos Containers para retornar a quantidade total do Embarque.
   EX9->(DbSeek(xFilial("EX9")+EEC->EEC_PREEMB))
   While EX9->(!EOF()) .and. EX9->(EX9_FILIAL+EX9_PREEMB) == xFilial("EX9")+EEC->EEC_PREEMB
      
      nTotCont ++ //Total de Container

      EYH->(DbSetOrder(3))
      EYH->(DbSeek(xFilial("EYH")+"S"+EEC->EEC_PREEMB+EX9->EX9_ID))
      While EYH->(!Eof() .And. EYH_FILIAL+EYH_ESTUF+EYH_PREEMB+EYH_IDVINC == xFilial("EYH")+"S"+EEC->EEC_PREEMB+EX9->EX9_ID)

         If EYH->EYH_PLT == "S" //Verifica se é Pallet
            
            nTotPallet += EYH->EYH_QTDEMB //Total de Pallets
            
            nRecEYH := EYH->(RecNo())
            
            cPalletID := EYH->EYH_ID 
         
            //Posiciona o registro na Embalagem externa dentro do Pallet.
            EYH->(DbSetOrder(3))
            EYH->(DbSeek(xFilial("EYH")+"S"+EEC->EEC_PREEMB+cPalletID))
            While EYH->(!Eof() .And. EYH_FILIAL+EYH_ESTUF+EYH_PREEMB+EYH_IDVINC == xFilial("EYH")+"S"+EEC->EEC_PREEMB+cPalletID)           
               nTotEmb += EYH->EYH_QTDEMB //Total de Embalagens Externas dentro do Pallet              
               EYH->(DbSkip())
            EndDo

            EYH->(DbGoTo(nRecEYH))
         Else
            nTotEmb += EYH->EYH_QTDEMB //Total de Embalagens Externas fora do Pallet
         EndIf
       
         EYH->(DBSkip())
      EndDo

      EX9->(DbSkip())
   EndDo
   
   //Verifica se existe embalagem estufada
   If nTotEmb == 0
      MsgInfo(STR0010,STR0011)//"Não foram encontrados dados para impressão."###"Atenção"
      lRet := .F.
      Break
   EndIf
   
   //Refaz o Looping nos containers para gravação dos dados
   EX9->(DbSeek(xFilial("EX9")+EEC->EEC_PREEMB))
   While EX9->(!EOF()) .and. EX9->(EX9_FILIAL+EX9_PREEMB) == xFilial("EX9")+EEC->EEC_PREEMB
 
      nIncCont    := 1
      nPesoLqTo   := 0
      nPesoBrTo   := 0
      nContPallet := 0
      nLinha      := 0
      
      nTotalCub   := 0
      
      aPallet := {}
      aEmbExt := {}
      aItens  := {}

      HEADER_P->(DbAppend())
      
      HEADER_P->AVG_FILIAL := xFilial("SY0")
      HEADER_P->AVG_CHAVE  := EX9->EX9_CONTNR
      HEADER_P->AVG_SEQREL := cSeqRel
      
      //Código do Embarque (Commercial Invoice)
      HEADER_P->AVG_C02_20 := Alltrim(EX9->EX9_PREEMB)
      
      //Fornecedor
      SA2->(DbSetOrder(1))
      If SA2->(DbSeek(xFilial("SA2")+EEC->EEC_FORN+EEC->EEC_FOLOJA))
         
         HEADER_P->AVG_C01_60 := Alltrim(SA2->A2_NOME) //Nome
         
         cEndereco := AllTrim(SA2->A2_END)  //Endereço
         HEADER_P->AVG_C02_60 := cEndereco
         
         If !Empty(SA2->A2_NR_END)
            HEADER_P->AVG_C02_60 := cEndereco + ", " + AllTrim(SA2->A2_NR_END) //Número
         EndIf

         cCidEst := Alltrim(SA2->A2_MUN) + " - " + AllTrim(SA2->A2_EST) //Cidade - Estado
         HEADER_P->AVG_C03_60 := cCidEst

         //Pais
         If !Empty(SA2->A2_PAIS)
            SYA->(DbSetOrder(1))
            If SYA->(DbSeek(xFilial("SYA")+SA2->A2_PAIS))
               HEADER_P->AVG_C03_60 := cCidEst + " - " + AllTrim(SYA->YA_DESCR) //Descrição
            EndIf
         EndIf
      
      EndIf
      
      //Importador
      SA1->(DbSetOrder(1))
      If SA1->(DbSeek(xFilial("SA1")+EEC->EEC_IMPORT+EEC->EEC_IMLOJA))
         
         HEADER_P->AVG_C04_60 := Alltrim(SA1->A1_NOME) //Nome
         
         HEADER_P->AVG_C05_60 := AllTrim(SA1->A1_END)  //Endereço
         
         cCidEst := Alltrim(SA1->A1_MUN) + " - " + AllTrim(SA1->A1_EST) //Cidade - Estado
         HEADER_P->AVG_C06_60 := cCidEst

         //Pais
         If !Empty(SA1->A1_PAIS)
            SYA->(DbSetOrder(1))
            If SYA->(DbSeek(xFilial("SYA")+SA1->A1_PAIS))
               HEADER_P->AVG_C06_60 := cCidEst + " - " + AllTrim(SYA->YA_DESCR) //Descrição
               cPais := " - " + AllTrim(SYA->YA_DESCR)
            EndIf
         EndIf

         HEADER_P->AVG_C01150 := Alltrim(SA1->A1_MUN) + " - " + AllTrim(SA1->A1_EST) + If(!Empty(SA1->A1_ESTADO) ," - " + AllTrim(SA1->A1_ESTADO),"") + cPais

         If !Empty(SA1->A1_CONTATO)
            cContato := SA1->A1_CONTATO
         EndIf

         If !Empty(SA1->A1_DDI) 
            cContato := If(Empty(cContato),AllTrim(SA1->A1_DDI),cContato + " - " + AllTrim(SA1->A1_DDI))
         EndIf

         If !Empty(SA1->A1_DDD)
            cContato := If(Empty(cContato),AllTrim(SA1->A1_DDD),cContato + " - " + AllTrim(SA1->A1_DDD))
         EndIf

         If !Empty(SA1->A1_TEL)
            cContato := If(Empty(cContato),AllTrim(SA1->A1_TEL),cContato + " - " + AllTrim(SA1->A1_TEL))
         EndIf

         If !Empty(SA1->A1_EMAIL)
            cContato := If(Empty(cContato),AllTrim(SA1->A1_EMAIL),cContato + " - " + AllTrim(SA1->A1_EMAIL))
         EndIf

         HEADER_P->AVG_C02150 := cContato

      EndIf

      //País de Destino
      SYA->(DbSetOrder(1))      
      If SYA->(DbSeek(xFilial("SYA")+EEC->EEC_PAISDT))
         HEADER_P->AVG_C07_60 := Alltrim(SYA->YA_DESCR) //Descrição
      EndIf

      //Local de Embarque
      SY9->(DbSetOrder(2))
      If SY9->(DbSeek(xFilial("SY9")+EEC->EEC_ORIGEM))
         HEADER_P->AVG_C08_60 := AllTrim(SY9->Y9_DESCR) //Descrição
         
         //Pais de Origem
         If !Empty(SY9->Y9_PAIS)
            SYA->(DbSetOrder(1))      
            If SYA->(DbSeek(xFilial("SYA")+SY9->Y9_PAIS))
               HEADER_P->AVG_C12_60 := Alltrim(SYA->YA_DESCR) //Descrição
            EndIf
         EndIf
         
      EndIf
      
      //Local de Desembarque
      SY9->(DbSetOrder(2))
      If SY9->(DbSeek(xFilial("SY9")+EEC->EEC_DEST))
         HEADER_P->AVG_C09_60 := AllTrim(SY9->Y9_DESCR) //Descrição
      EndIf
      
      //Via de Transporte
      SYQ->(DbSetOrder(1))
      If SYQ->(DbSeek(xFilial("SYQ")+EEC->EEC_VIA))
         HEADER_P->AVG_C10_60 := AllTrim(SYQ->YQ_DESCR) //Descrição
      EndIf
       
      //Código do Container
      HEADER_P->AVG_C01_20 := Alltrim(EX9->EX9_CONTNR)
      
      //Lacre
      HEADER_P->AVG_C11_60 := Alltrim(EX9->EX9_LACRE)      
      
      //Assinatura
      If !Empty(cAssNome)
         HEADER_P->AVG_C13_60 := AllTrim(cAssNome) //Nome
      EndIf
 
      If !Empty(cAssEmp)
         HEADER_P->AVG_C14_60 := AllTrim(cAssEmp) //Empresa
      EndIf
      
      If !Empty(cAssCargo)
         HEADER_P->AVG_C15_60 := AllTrim(cAssCargo) //Cargo
      EndIf
          
      //Unidade de Medida
      HEADER_P->AVG_C01_10 := Alltrim(cUnidad)

      //////////////////////////////////
      //Embalagens Externas ou Pallets//
      //////////////////////////////////
      EYH->(DbSetOrder(3))
      EYH->(DbSeek(xFilial("EYH")+"S"+EEC->EEC_PREEMB+EX9->EX9_ID))
      While EYH->(!Eof() .And. EYH_FILIAL+EYH_ESTUF+EYH_PREEMB+EYH_IDVINC == xFilial("EYH")+"S"+EEC->EEC_PREEMB+EX9->EX9_ID)

         If EYH->EYH_PLT == "S"
            aAdd(aPallet,EYH->(RecNo()))
         Else
            aAdd(aEmbExt,EYH->(RecNo()))
         EndIf
       
         EYH->(DBSkip())
      EndDo

      ///////////////////////
      //Looping nos Pallets//
      ///////////////////////
      For n := 1 to Len(aPallet)

         EYH->(DbGoTo(aPallet[n]))
         
         cPalletID   := EYH->EYH_ID 
         
         nPallet     := EYH->EYH_QTDEMB
         nContPallet += nPallet
         
         //Peso Bruto
         nPesBru := AvTransUnid(cUnidDe,cUnidad,,EYH->EYH_PSBRTO)  //AOM - 30/04/2010 - Atribui o peso bruto de acordo com Paillet.


         //Posiciona o registro na Embalagem externa dentro do Pallet.
         EYH->(DbSetOrder(3))
         EYH->(DbSeek(xFilial("EYH")+"S"+EEC->EEC_PREEMB+cPalletID))
         While EYH->(!Eof() .And. EYH_FILIAL+EYH_ESTUF+EYH_PREEMB+EYH_IDVINC == xFilial("EYH")+"S"+EEC->EEC_PREEMB+cPalletID)

            lItem := !Empty(EYH->EYH_COD_I) // GFP - 18/05/2012
            
            DETAIL_P->(DbAppend())
      
            DETAIL_P->AVG_FILIAL := xFilial("SY0")
            DETAIL_P->AVG_CHAVE  := EX9->EX9_CONTNR
            DETAIL_P->AVG_SEQREL := cSeqRel
            
            nLinha++
            DETAIL_P->AVG_LINHA  := StrZero(nLinha,6)            
            
            //Pallet 
            DETAIL_P->AVG_C01_10 := Alltrim(Str(nPallet))

            //Embalagem Extena
            If !lItem // GFP - 17/05/2012 - Se não for produto, colunas "Packages" são preenchidas.
               DETAIL_P->AVG_C02_20 := Transform(EYH->EYH_QTDEMB,"@E 99,999,999") //Quantidade
            Else
               DETAIL_P->AVG_C02_20 := ""
            EndIf
         
            EE5->(DbSetOrder(1))
            If EE5->(DbSeek(xFilial("EE5")+EYH->EYH_CODEMB))

               //Descrição
               If !lItem // GFP - 17/05/2012 - Se não for produto, colunas "Packages" são preenchidas.
                  DETAIL_P->AVG_C01_60 := AllTrim(EYH->EYH_DESEMB)
               Else
                  DETAIL_P->AVG_C01_60 := ""
               EndIf   
            
               //Dimensão
               DETAIL_P->AVG_C06_20 := Alltrim(EE5->EE5_DIMENS)
            
               //Volume
               DETAIL_P->AVG_C07_20 := "m3"

               nCub := EE5->EE5_CCOM * EE5->EE5_LLARG * EE5->EE5_HALT
               nCub := nCub * EYH->EYH_QTDEMB
               DETAIL_P->AVG_C04_60 := AllTrim(Str(Round(nCub,2)))
               DETAIL_P->AVG_N01_15 := Round(nCub,2)
               nTotalCub += nCub 
            EndIf
         
            //Peso Bruto
            DETAIL_P->AVG_C09_20 := Transform(nPesBru,"@E 999,999,999.999")
            nPesoBrTo += nPesBru
         
            //Produto
            aItens := BuscaItens(lItem)
            For nInc := 1 To Len(aItens)
            
               If nInc > 1 
                  DETAIL_P->(DbAppend())
      
                  DETAIL_P->AVG_FILIAL := xFilial("SY0")
                  DETAIL_P->AVG_CHAVE  := EX9->EX9_CONTNR
                  DETAIL_P->AVG_SEQREL := cSeqRel
        
                  nLinha++
                  DETAIL_P->AVG_LINHA  := StrZero(nLinha,6)            

                  nIncCont++
               
               EndIf
            
               //Identificador da Linha(Utilizado para o Sub-Relatório)
               DETAIL_P->AVG_N01_04 := nIncCont

               //Quantidade
               DETAIL_P->AVG_C03_20 := Transform(aItens[nInc][2],AVSX3("EE9_SLDINI",AV_PICTURE))
            
               //Unidade de Medida
               DETAIL_P->AVG_C04_20 := Transform(aItens[nInc][4],AVSX3("EE9_UNIDAD",AV_PICTURE))
            
               //Código de Item
               DETAIL_P->AVG_C05_20 := AllTrim(Upper(aItens[nInc][3]))      
               
               //Código do lote
               DETAIL_P->AVG_C02_10 := AllTrim(Upper(aItens[nInc][7]))
                           
               //Peso Liquido Unitário
               nPesLiq := aItens[nInc][5]
               DETAIL_P->AVG_C08_20 := Transform(nPesLiq,AVSX3("EE9_PSLQTO",AV_PICTURE))
               nPesoLqTo += nPesLiq
               
               //Pedido no Cliente (Referencia do Cliente)
               DETAIL_P->AVG_C02_60 := AllTrim(Upper(aItens[nInc][6]))

               //Descrição do Item
               For nInc2 := 1 To MlCount(aItens[nInc][1])
               
                  DETAIL_P->(DbAppend())
            
                  DETAIL_P->AVG_SEQREL := cSeqRel
                  DETAIL_P->AVG_FILIAL := xFilial("SY0")
                  DETAIL_P->AVG_CHAVE  := EX9->EX9_CONTNR
                
                  nLinha++
                  DETAIL_P->AVG_LINHA  := StrZero(nLinha,6)            
        
                  DETAIL_P->AVG_CONT   := "SUB"
                           
                  //Identificador da Linha(Utilizado para o Sub-Relatório)
                  DETAIL_P->AVG_N01_04 := nIncCont
               
                  DETAIL_P->AVG_C01150 := MemoLine(aItens[nInc][1],,nInc2)
                  
                  //Pedido no Cliente (Referencia do Cliente)
                  DETAIL_P->AVG_C02_60 := AllTrim(Upper(aItens[nInc][6]))
               
               Next

            Next
         
            nIncCont++
       
            EYH->(DbSkip())                                
         EndDo
      Next
      
      //////////////////////////////////////////////////
      //Looping nas Embalagens Externas fora de Pallet//
      //////////////////////////////////////////////////
      For n := 1 to Len(aEmbExt)

         EYH->(DbGoTo(aEmbExt[n]))

         DETAIL_P->(DbAppend())
      
         DETAIL_P->AVG_FILIAL := xFilial("SY0")
         DETAIL_P->AVG_CHAVE  := EX9->EX9_CONTNR
         DETAIL_P->AVG_SEQREL := cSeqRel
         
         nLinha++
         DETAIL_P->AVG_LINHA  := StrZero(nLinha,6)            
            
         //Pallet 
         DETAIL_P->AVG_C01_10 := "-"

         //Embalagem Extena
         DETAIL_P->AVG_C02_20 := Transform(EYH->EYH_QTDEMB,"@E 99,999,999") //Quantidade
         
         EE5->(DbSetOrder(1))
         If EE5->(DbSeek(xFilial("EE5")+EYH->EYH_CODEMB))

            //Descrição
            DETAIL_P->AVG_C01_60 := AllTrim(EYH->EYH_DESEMB)
            
            //Dimensão
            DETAIL_P->AVG_C06_20 := Alltrim(EE5->EE5_DIMENS)
           
            //Volume
            DETAIL_P->AVG_C07_20 := "m3"

            nCub := EE5->EE5_CCOM * EE5->EE5_LLARG * EE5->EE5_HALT
            nCub := nCub * EYH->EYH_QTDEMB
            DETAIL_P->AVG_C04_60 := AllTrim(Str(Round(nCub,2)))
            DETAIL_P->AVG_N01_15 := Round(nCub,2)
            nTotalCub += nCub 

         EndIf
       
         //Peso Bruto
         nPesBru := AvTransUnid(cUnidDe,cUnidad,,EYH->EYH_PSBRTO)
         DETAIL_P->AVG_C09_20 := Transform(nPesBru,"@E 999,999,999.999")
         nPesoBrTo += nPesBru
         
         //Produto
         aItens := BuscaItens()
         For nInc := 1 To Len(aItens)
            
            If nInc > 1 
               DETAIL_P->(DbAppend())
     
               DETAIL_P->AVG_FILIAL := xFilial("SY0")
               DETAIL_P->AVG_CHAVE  := EX9->EX9_CONTNR
               DETAIL_P->AVG_SEQREL := cSeqRel
                
               nLinha++
               DETAIL_P->AVG_LINHA  := StrZero(nLinha,6)            
               
               nIncCont++
               
            EndIf
            
            //Identificador da Linha(Utilizado para o Sub-Relatório)
            DETAIL_P->AVG_N01_04 := nIncCont

            //Quantidade
            DETAIL_P->AVG_C03_20 := Transform(aItens[nInc][2],AVSX3("EE9_SLDINI",AV_PICTURE))
            
            //Unidade de Medida
            DETAIL_P->AVG_C04_20 := Transform(aItens[nInc][4],AVSX3("EE9_UNIDAD",AV_PICTURE))
            
            //Código de Item
            DETAIL_P->AVG_C05_20 := AllTrim(Upper(aItens[nInc][3]))
            
            //Código do lote // RMD - 07/08/2012
             DETAIL_P->AVG_C02_10 := AllTrim(Upper(aItens[nInc][7]))
            
            //Peso Liquido Unitário
            nPesLiq := aItens[nInc][5]
            DETAIL_P->AVG_C08_20 := Transform(nPesLiq,AVSX3("EE9_PSLQTO",AV_PICTURE))
            nPesoLqTo += nPesLiq
            
            //Pedido no Cliente (Referencia do Cliente)
            DETAIL_P->AVG_C02_60 := AllTrim(Upper(aItens[nInc][6]))
            
            //Descrição do Item
            For nInc2 := 1 To MlCount(aItens[nInc][1])
               
               DETAIL_P->(DbAppend())
            
               DETAIL_P->AVG_SEQREL := cSeqRel
               DETAIL_P->AVG_FILIAL := xFilial("SY0")
               DETAIL_P->AVG_CHAVE  := EX9->EX9_CONTNR
               
               nLinha++
               DETAIL_P->AVG_LINHA  := StrZero(nLinha,6)            
            
               DETAIL_P->AVG_CONT   := "SUB"
                           
               //Identificador da Linha(Utilizado para o Sub-Relatório)
               DETAIL_P->AVG_N01_04 := nIncCont
               
               DETAIL_P->AVG_C01150 := MemoLine(aItens[nInc][1],,nInc2)
              
               //Pedido no Cliente (Referencia do Cliente)
               DETAIL_P->AVG_C02_60 := AllTrim(Upper(aItens[nInc][6]))
            Next

            //Part Number
            DETAIL_P->AVG_C10_20 := EYH->EYH_LOTE

         Next
         
         nIncCont++
      
      Next

      //Totalizador da metragem cubica
      HEADER_P->AVG_N02_15 := Round(nTotalCub,2)
      
      //Totalizador de Embalagens Externas
      HEADER_P->AVG_C02_30 := AllTrim(Str(nTotEmb))
      
      //Totalizador de Pallets
      HEADER_P->AVG_C02_10 := AllTrim(Str(nContPallet)) //Pallets do Container
      HEADER_P->AVG_C03_30 := AllTrim(Str(nTotPallet))  //Pallets do Embarque

      //Totalizador de Containers
      HEADER_P->AVG_C01_30 := AllTrim(Str(nTotCont))
      
      //Totalizador do Peso Liquido
      HEADER_P->AVG_C03_20 := Transform(nPesoLqTo,AVSX3("EE9_PSLQTO",AV_PICTURE))
      
      //Totalizador do Peso Bruto
      HEADER_P->AVG_C04_20 := Transform(nPesoBrTo,AVSX3("EE9_PSLQTO",AV_PICTURE))

      cMemoMarca := MSMM(EEC->EEC_CODMAR,AVSX3("EEC_MARCAC",AV_TAMANHO))   
      cMemoMarca := StrTran(cMemoMarca, Replic(CHR(13)+CHR(10),2), "")
      For nX:=1 To MlCount(cMemoMarca,AvSx3("EEC_MARCAC",AV_TAMANHO))
         DETAIL_P->(dbAppend())
         DETAIL_P->AVG_FILIAL := xFilial("SY0")
         DETAIL_P->AVG_SEQREL := cSEQREL
         DETAIL_P->AVG_CHAVE  := EX9->EX9_CONTNR
         DETAIL_P->AVG_CONT   := "MARK"
         DETAIL_P->AVG_C03_60 := MemoLine(cMemoMarca,AvSx3("EEC_MARCAC",AV_TAMANHO),nX)   
      Next 

      EX9->(DbSkip())
   
   EndDo 
   
   HEADER_P->(DBCOMMIT())
   DETAIL_P->(DBCOMMIT())

End Sequence

Return lRet

/*
Funcao      : BuscaItens()
Parametros  : Nenhum
Retorno     : aRet - Array com os dados dos itens.
Objetivos   : Busca os itens dentro das embalagens externas.
Autor       : Eduardo C. Romanini
Data/Hora   : 12/02/2008 15:30
Obs.        : 
*/
*--------------------------*
Static Function BuscaItens(lItem)
*--------------------------*
Local aRet    := {}
Local aOrd    := SaveOrd({"EE9"})

Local nRecno  := EYH->(Recno())
Local nPsLqUn := 0

Local cDesc   := "" 
Local cChave  := EYH->(EYH_FILIAL+EYH_ESTUF+EYH_PREEMB+EYH_ID)
Local cPedido := ""

Begin Sequence
   
   /*
     Detalhes do Array de Retorno
     [1] - Descrição
     [2] - Quantidade
     [3] - Codigo do Item
     [4] - Unidade de Quantidade
     [5] - Peso Liquido Total
   */

   //Busca as embalagens internas da atual, até chegar no item
   If !lItem  // GFP - 18/05/2012
      If EYH->(DbSeek(cChave))
         While EYH->(!Eof() .And. EYH_FILIAL+EYH_ESTUF+EYH_PREEMB+EYH_IDVINC == cChave)
            If !Empty(EYH->EYH_COD_I)
               EE9->(DbSetOrder(3))
               If EE9->(DbSeek(xFilial("EE9")+EYH->(EYH_PREEMB+EYH_SEQEMB)))
                  //cDesc := MSMM(EE9->EE9_DESC, TAMSX3("EE9_VM_DES")[1],,, LERMEMO)
                  cDesc := BuscaDesc()               
                  cPedido := EE9->EE9_PEDIDO

                  If !Empty(EE9->EE9_UNPES) 
                     nPsLqUn := AvTransUnid(EE9->EE9_UNPES,cUnidad,EE9->EE9_COD_I,EE9->EE9_PSLQUN) * EYH->EYH_QTDEMB
                  Else
                     nPsLqUn := AvTransUnid(EE9->EE9_UNIDAD,cUnidad,EE9->EE9_COD_I,EE9->EE9_PSLQUN) * EYH->EYH_QTDEMB            
                  EndIf
         
                  aAdd(aRet,{cDesc,EYH->EYH_QTDEMB,EE9->EE9_COD_I,EE9->EE9_UNIDAD,nPsLqUn,EE9->EE9_REFCLI, EYH->EYH_LOTE})

               EndIf
            Else
               aRet := BuscaItens()
            EndIf

            EYH->(DbSkip())
         EndDo
      EndIf
   Else
      EE9->(DbSetOrder(3))
         If EE9->(DbSeek(xFilial("EE9")+EYH->(EYH_PREEMB+EYH_SEQEMB)))
            //cDesc := MSMM(EE9->EE9_DESC, TAMSX3("EE9_VM_DES")[1],,, LERMEMO)
            cDesc := BuscaDesc()
            cPedido := EE9->EE9_PEDIDO

            If !Empty(EE9->EE9_UNPES) 
               nPsLqUn := AvTransUnid(EE9->EE9_UNPES,cUnidad,EE9->EE9_COD_I,EE9->EE9_PSLQUN) * EYH->EYH_QTDEMB
            Else
               nPsLqUn := AvTransUnid(EE9->EE9_UNIDAD,cUnidad,EE9->EE9_COD_I,EE9->EE9_PSLQUN) * EYH->EYH_QTDEMB            
            EndIf
         
            aAdd(aRet,{cDesc,EYH->EYH_QTDEMB,EE9->EE9_COD_I,EE9->EE9_UNIDAD,nPsLqUn,EE9->EE9_REFCLI, EYH->EYH_LOTE})
         EndIf
   EndIf

End Sequence
                     
RestOrd(aOrd, .T.)
EYH->(DbGoTo(nRecno))
   
Return aRet

Static Function BuscaDesc()
Local cDesc := ""
Local cDescItem := ""
Local cDescMarc := ""
Local cCapaEmb := ""

Begin Sequence
   
   cDescItem := MSMM(EE9->EE9_DESC  , TAMSX3("EE9_VM_DES")[1],,, LERMEMO)
   cCapaEmb  := MSMM(EEC->EEC_CODMAR,AVSX3("EEC_MARCAC",AV_TAMANHO),,, LERMEMO)
   
   // Tratamento para marcação
   If (Type("lDescItem") <> "L" .Or. !lDescItem ).And. (Type("lDescMarc") <> "L" .Or. !lDescMarc);
       .And. EYH->(FieldPos("EYH_CODMAR")) == 0
      cDesc := cDescItem
      Break
   EndIf
   
   cDescMarc := MSMM(EYH->EYH_CODMAR, TAMSX3("EYH_MARCAC")[1],,, LERMEMO)

   If lDescItem
      cDesc := cDescItem
   EndIf
   
   If lDescMarc
      cDesc := cDescMarc
   EndIf

   If lDescItem .And. lDescMarc
      cDesc := cDescItem + CHR(13)+CHR(10) + cDescMarc
   EndIf

   If AllTrim(Upper(cDescMarc)) $ Upper(cCapaEmb)
      cDesc := cDescItem
   EndIf

   cDesc := StrTran(cDesc, Replic(CHR(13)+CHR(10),2), "")

End Sequence

Return cDesc
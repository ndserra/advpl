#INCLUDE "EECPEM12.ch"

/*
Programa        : EECPEM12.PRW
Objetivo        : Impressao do Form A
Autor           : Cristiano A. Ferreira / HEDER M OLIVEIRA
Data/Hora       : 26/01/00 15:53
Obs.            :
*/

/*
considera que estah posicionado no registro de embarque (EEC)
*/

#include "EECRDM.CH"

#define PAGE   01
#define LINE   02
#define ITEM   03
#define MARK   04
#define DESC   05
#define CRIT   06
#define PESO   07
#define INVO   08
#define NCM    09
#define RE     10
#define DTRE   11
#define VLFOB  12
#define PESLIQ 13

#define LenCol1 10  // +1
#define LenCol2 20  // +1
#define LenCol3 58  // +1
#define LenCol4 17  // +1
#define LenCol5 17  // +1
#define LenCol6 17

#define TOTAL_ITENS  20 //24 //22 //20/07 - BCO - Define um limite de 20 linhas por pagina
#define MARGEM Space(6)

/*
Funcao      : EECPEM12
Parametros  : 
Retorno     : 
Objetivos   : FORM A
Autor       : Cristiano A. Ferreira
Data/Hora   : 
Revisao     :
Obs.        :
*/
User Function EECPEM12

Local aOrd  := SaveOrd({"EEO","EE9","SA2","SYR","SY9"}),mDet:= ""
Local cVia  := UPPER(TABELA("Y3",LEFT(Posicione("SYQ",1,xFilial("SYQ")+EEC->EEC_VIA,"YQ_COD_DI"),1)))
Local cUsad := Posicione("SX3",2,"EEC_PREEMB","X3_USADO")
Local y:=0
Local nCont :=1 
Local i
Local j
Local cData

Local aArqsFormA := {}
Local aFormADet  := {}
Local nItemCount := 0
Local cAntNcm := "" 
Local cAntRE := ""
Local cNomCarg := ""

Local nCountItem := 0
Private lformRE := .F.
Private aRetCrwFormA := {}

Private bRefresh := {|cField| AtualizaBrw(cField), .t. },oGetDb:=nil
Private aHeader := {},nUsado := Len(aHeader)
Private nPagina:=1,aPagina:={},aCols:={},cCodInst:=""  

// Estrutura de aPagina por dimensao:
// ==================================
// aPagina[x][1] => Tabela com as NCM's
// aPagina[x][1][y][1] => Codigo da NCM
// aPagina[x][1][y][2] => Registro de Exportacao
// aPagina[x][1][y][3] => Data do Registro de Exportacao
// aPagina[x][1][y][4] => Valor FOB
// aPagina[x][1][y][5] => Peso Liquido
// aPagina[x][2] => Descricao do Detalhe da pagina x

// Estrutura de aHeader por dimensao:
// ==================================
// aHeader[x][1] => Titulo
// aHeader[x][2] => Nome do Campo
// aHeader[x][3] => Picture
// aHeader[x][4] => Tamanho
// aHeader[x][5] => Decimal
// aHeader[x][6] => Valid
// aHeader[x][7] => Usado (X3_USADO)
// aHeader[x][8] => Tipo
// aHeader[x][9] => Arquivo

Begin Sequence
 
   aAdd(aHeader,{STR0001    ,"WKPAGE","99" ,2,0,"Eval(bRefresh,'WKPAGE')",cUsad,"N","ZZZ"}) //"Pagina"
   aAdd(aHeader,{STR0002     ,"WKLINE","99" ,2,0,"Eval(bRefresh,'WKLINE')",cUsad,"N","ZZZ"}) //"Linha"
   aAdd(aHeader,{STR0003 ,"WKITEM","999",03     ,0,"",cUsad,"C","ZZZ"}) //"It.Number"
   aAdd(aHeader,{STR0004    ,"WKMARK","@!" ,LenCol2,0,"",cUsad,"C","ZZZ"}) //"Mark's"
   aAdd(aHeader,{STR0005 ,"WKDESC","@!" ,LenCol3,0,"",cUsad,"C","ZZZ"}) //"Descricao"
   aAdd(aHeader,{STR0006 ,"WKCRIT","@!" ,LenCol4,0,"",cUsad,"C","ZZZ"}) //"Crit.Orig"
   aAdd(aHeader,{STR0007,"WKPESO","@!" ,LenCol5,0,"",cUsad,"C","ZZZ"}) //"Peso Bruto"
   aAdd(aHeader,{STR0008   ,"WKINVO","@!" ,LenCol6,0,"",cUsad,"C","ZZZ"}) //"Invoice"
   aAdd(aHeader,{STR0009   ,"WKNCM",AVSX3("EE9_POSIPI",6),10,0,"",cUsad,"C","ZZZ"}) //"Ncm    "
   aAdd(aHeader,{STR0010   ,"WKRE" ,AVSX3("EE9_RE",6),10,0,"",cUsad,"C","ZZZ"}) //"Re     "
   aAdd(aHeader,{STR0011   ,"WKDTRE",AVSX3("EE9_DTRE",6),8,0,"",cUsad,"D","ZZZ"}) //"Dt.Re  "
   aAdd(aHeader,{STR0012   ,"WKFOB",AVSX3("EEC_TOTPED",6),15,2,"",cUsad,"N","ZZZ"}) //"Vl.FOB "
   aAdd(aHeader,{STR0013 ,"WKPESLIQ",AVSX3("EEC_PESLIQ",6),15,2,"",cUsad,"N","ZZZ"}) //"Peso Liq."
            
   SYR->(dbSetOrder(1))
   SA2->(dbSetOrder(1))
   SY9->(dbSetOrder(2))           
   EE9->(dbSetOrder(4))
   
   IF !Empty(EEC->EEC_INSCOD)
      cCodInst := EEC->EEC_INSCOD
   Endif           

   IF Empty(cCodInst)
      HELP(" ",1,"AVG0005047") //MsgStop("Instrumento de Negociação não informado !","Aviso")
      Break
   Endif
   
   
   EE9->(dbSeek(xFilial()+EEC->EEC_PREEMB))
   
   While EE9->(!Eof() .And. EE9_FILIAL==xFilial("EE9")) .And.;
         EE9->EE9_PREEMB == EEC->EEC_PREEMB
         if cAntNcm != EE9->EE9_POSIPI
         nCountItem ++
         cAntNcm := EE9->EE9_POSIPI
         endif
         EE9->(dbSkip())
   end do      //20/07 - BCO -  Conta quantos itens com ncm diferentes existem. 
   EE9->(DBGOTOP())
   
   if nCountItem > 4 //20/07 - BCO - Caso existam mais de quatro itens com NCM diferentes o documento de anexo de RE's será gerado.
      lformRE := .T.
   endif   
   EE9->(dbSeek(xFilial()+EEC->EEC_PREEMB))
   FormA()

   IF !TelaGets()
      Break
   Endif
   
   AddFormA()
   
   lCancel := .f.
   nPagina := 1
   if lformRE
      aFormADet := {}

      //aAdd(aFormADet ,{cName , cType, nLenght, nDecimals})   //BCO Criação de DBF para alimentar crystal Reports
      
      //20/07 - BCO - Cria e alimenta o Array que será usado para alimentar o Anexo do Form A
      
      aAdd(aFormADet ,{"WKFA_NCM"    , "C"    , 10     , 0      })
      aAdd(aFormADet ,{"WKFA_RE"     , "C"    , 12     , 0      })
      aAdd(aFormADet ,{"WKFA_DTRE"   , "D"    , 8      , 0      })
      aAdd(aFormADet ,{"WKFA_VLFOB"  , "N"    , 12     , 3      })
      aAdd(aFormADet ,{"WKFA_PESLI"  , "N"    , 10     , 3      })
      aAdd(aFormADet ,{"WKFA_INV"    , "C"    , 20     , 0      })
      aAdd(aFormADet ,{"WKFA_DINV"   , "D"    , 30     , 0      }) 
      aAdd(aFormADet ,{"WKFA_DATE"   , "C"    , 30     , 0      }) 
      aAdd(aFormADet ,{"WKFA_CNPJ"   , "C"    , 15     , 0      })
      aAdd(aFormADet ,{"WKFA_NCARG"  , "C"    , 60     , 0      })
      


      aArqsFormA := {}
      AADD(aArqsFormA,{"FormA_Det",aFormADet,"WKFA", "WKFA_RE"})
      
      cSEQREL :=GetSXENum("SY0","Y0_SEQREL")
      CONFIRMSX8()
      
      
      aRetCrwFormA    := CrwNewFile(aArqsFormA)
      
      IF !EMPTY(EEC->EEC_EXPORT) .AND. ;
         SA2->(DBSEEK(xFilial("SA2")+EEC->EEC_EXPORT+EEC->EEC_EXLOJA))
      ELSE
         SA2->(DBSEEK(xFilial("SA2")+EEC->EEC_FORN+EEC->EEC_FOLOJA))
      ENDIF

      aData := DataExtenso(EEC->EEC_DTINVO,EEC->EEC_IDIOMA)
      cData := alltrim(SA2->A2_MUN) + " " +  alltrim(aData[1]) + " "  + alltrim(aData[2]) + "," + alltrim(aData[3])
      
      DEFINE MSDIALOG oNomCarg TITLE "Entre com seu nome e cargo" FROM 000,000 TO 300,800 PIXEL
      
         oSay1    := TSay():New(65,25,{||'Entre com seu Nome e cargo: '},oNomCarg,,,,;
                     ,,.T.,,,200,20)
         cNomCarg :=  Space(60)
         
         oTGetCarg:= TGet():New(75,25,{|u| if( Pcount( )>0, cNomCarg:= u,cNomCarg)},oNomCarg,100,10,;
                     "@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cNomCarg,,,,)
                                                                                 
         oButton:=tButton():New(125,200,'OK',oNomCarg,{||(oNomCarg:End())},40,20,,,,.T.) 
          
                     
      Activate MSDialog oNomCarg Centered   
      
      
      for i := 1 to len(apagina)
         for j := 1 to len(aPagina[i][1])
            IF aPagina[i][1][j][1] <> cAntNcm
               cAntNcm :=  aPagina[i][1][j][1]
               cAntRE :=   aPagina[i][1][j][2]
               WKFA->(DBAPPEND())
               WKFA->WKFA_NCM    := aPagina[i][1][j][1]
               WKFA->WKFA_RE     := aPagina[i][1][j][2]
               WKFA->WKFA_DTRE   := aPagina[i][1][j][3]
               WKFA->WKFA_VLFOB  := aPagina[i][1][j][4]
               WKFA->WKFA_PESLI  := aPagina[i][1][j][5]
               WKFA->WKFA_INV    := EEC->EEC_NRINVO 
               WKFA->WKFA_DINV   := EEC->EEC_DTINVO
               WKFA->WKFA_DATE   := cData 
               WKFA->WKFA_CNPJ   := Transf(SA2->A2_CGC,AVSX3("A2_CGC",6))
               WKFA->WKFA_NCARG  := cNomCarg
               WKFA->(dbUnlock())
            endif
         next
      next
   endif
                                                     
   While nPagina <= Len(aPagina)
      nVez := 1
      // Cada Pagina tem quatro vias ...
      While nVez <= 2
         //gerar arquivo padrao de edicao de carta
         IF ! E_AVGLTT("G")
            lCancel := .t.
            Exit
         Endif
         
         //regras para carregar dados
         IF !EMPTY(EEC->EEC_EXPORT) .AND. ;
            SA2->(DBSEEK(xFilial("SA2")+EEC->EEC_EXPORT+EEC->EEC_EXLOJA))
         ELSE
            SA2->(DBSEEK(xFilial("SA2")+EEC->EEC_FORN+EEC->EEC_FOLOJA))
         ENDIF
         
	     mDet := Replic(ENTER,3) // //20/07 - BCO - Tratamento para imprimir novamente as informações do form A nas paginas 1 e 2
            
         mDet := mDet+MARGEM+SA2->A2_NOME+ENTER
         mDet := mDet+MARGEM+ALLTRIM(SA2->A2_END)+"-"+ALLTRIM(SA2->A2_BAIRRO)+ENTER
         mDet := mDet+MARGEM+ALLTRIM(SA2->A2_MUN)+"-"+ALLTRIM(SA2->A2_EST)+"-"+ALLTRIM(BUSCAPAIS(SA2->A2_PAIS))+ENTER
               
         if nVez == 2 //20/07 - BCO - Caso seja a segunda via do Documento, o CNPJ é exibido na parte superior.
            mDet := mDet+Replic(ENTER,1)
            mDet := mDet+MARGEM+Space(10)+Transf(SA2->A2_CGC,AVSX3("A2_CGC",6))+ENTER
         endif
               
         cMunExport := SA2->A2_MUN
            
         mDet := mDet+Replic(ENTER,2)
            
         mDet := mDet+MARGEM+EEC->EEC_IMPODE+ENTER
         mDet := mDet+MARGEM+EEC->EEC_ENDIMP+ENTER
         mDet := mDet+MARGEM+EEC->EEC_END2IM+ENTER
            
         mDet := mDet+Replicate(ENTER,4)
           
         mDet := mDet+MARGEM+cVia+ENTER
         mDet := mDet+ENTER
            
         // *** BHF - 12/08/08 - Verific. existência do Porto interm... Se preenchido, recebe o porto interm., senão, porto de origem.
         SY9->(dbsetorder(2))
         If EEC->(FieldPos("EEC_PTINT")) > 0 .And. !Empty(EEC->EEC_PTINT)
            SY9->(DBSEEK(XFILIAL()+EEC->EEC_PTINT))
         Else
            SY9->(dbSeek(xFilial()+EEC->EEC_ORIGEM))
         EndIf

         mDet := mDet+MARGEM+"FROM : "+AllTrim(SY9->Y9_CIDADE)+"/"+AllTrim(Posicione("SYA",1,xFilial("SYA")+SY9->Y9_PAIS,"YA_DESCR"))+ENTER
         mDet := mDet+ENTER
         // ***
            
         SYR->(dbSeek(xFilial()+EEC->EEC_VIA+EEC->EEC_ORIGEM+EEC->EEC_DEST))
         mDet := mDet+MARGEM+"TO   : "+AllTrim(SYR->YR_CID_DES)+"/"+AllTrim(Posicione("SYA",1,xFilial("SYA")+SYR->YR_PAIS_DE,"YA_DESCR"))+ENTER
            
         mDet := mDet+Replicate(ENTER,6)
            
         mDet := mDet+aPagina[nPagina][2]

         IF (nTotPag := MlCount(aPagina[nPagina][2],150)) < TOTAL_ITENS
            mDet := mDet+Replicate(ENTER,TOTAL_ITENS-nTotPag)
         Endif
               
            
         IF nVez == 1           
            
            mDet := mDet+Replicate(ENTER,4)
            
            cPais := Posicione("SA1",1,xFilial("SA1")+EEC->EEC_IMPORT+EEC->EEC_IMLOJA,"A1_PAIS")
            cPais := Posicione("SYA",1,xFilial("SYA")+cPais,"YA_NOIDIOM")
            mDet := mDet+ENTER
            mDet := mDet+MARGEM+Space(81)+Padc(cPais,43)+ENTER
            mDet := mDet+ENTER+ENTER
            mDet := mDet+MARGEM+Space(81)+AllTrim(cMunExport)+" "+Upper(cMonth(EEC->EEC_DTCONH))+" "+Str(Day(EEC->EEC_DTCONH),2)+", "+Str(Year(EEC->EEC_DTCONH),4)
         Else
            mDet := mDet+ENTER
            i := 1
            For y:=1 to 6//5 Igor Chiba 16/09/08
               IF y == 1
                  mDet := mDet+ENTER
                  Loop
               Endif

               IF y == 2
                  mDet := mDet+MARGEM+Space(27+1+15+1+22+1+24+1+24)
                  mDet := mDet+Space(8)/*+AllTrim(Transf(EEC->EEC_NRCONH,AvSx3("EEC_NRCONH",6)))*/+ENTER    // GFP - 29/09/2011 - Novo Layout Form A.
                  Loop
               Endif
                  
               
               if !(lFormRE) //20/07 - BCO - Caso não seja necessário o uso do documento anexo, os RE'S serão impressão na parte inferior do documento
                  IF Len(aPagina[nPagina][1]) >= i
                     mDet := mDet+MARGEM+Padr(AllTrim(Transf(aPagina[nPagina][1][i][2],AvSx3("EE9_RE",6))),27)
                     mDet := mDet+Space(1)+Padc(Dtoc(aPagina[nPagina][1][i][3]),15)
                     mDet := mDet+Space(1)+Padc(AllTrim(Transf(aPagina[nPagina][1][i][1],AvSx3("EE9_POSIPI",6))),22)
                     mDet := mDet+Space(1)+Padl(AllTrim(EEC->EEC_MOEDA)+" "+AllTrim(Transf(aPagina[nPagina][1][i][4],"@E 999,999,999.99")),24)
                     mDet := mDet+Space(1)+Padl(AllTrim(Transf(aPagina[nPagina][1][i][5],"@E 9,999,999.99"))+" KG",22)
                  Else
                     mDet := mDet+MARGEM+Space(27+1+15+1+22+1+24+1+22)
                  Endif
               else
               
                  IF Len(aPagina[nPagina][1]) >= i //20/07 - BCO -Caso seja necessário o uso do documento de anexo de RE'S, será impresdso "video anexo" na parte inferior do documento com Total de valor FOB e Peso Liquido
                     mDet := mDet+MARGEM+" Vide Anexo "       
                     mDet := mDet+Space(1)+" Vide Anexo "
                     mDet := mDet+Space(1)+" Vide Anexo "
                     mDet := mDet+Space(1)+" Vide Anexo "
                     mDet := mDet+Space(1)+" Vide Anexo "
                  Else
                     mDet := mDet+MARGEM+Space(27+1+15+1+22+1+24+1+22)
                  Endif
               endif
                  
               // Nopado por GFP - 29/09/2011 - Novo Layout Form A.
               IF y == 3
                  mDet := mDet+Space(10)//+Dtoc(EEC->EEC_DTCONH)
               Elseif y == 5
                  // Verifica se a via eh rodoviaria ...
                  IF Left(Posicione("SYQ",1,XFILIAL("SYQ")+EEC->EEC_VIA,"YQ_COD_DI"),1) == "7"
                     mDet := mDet+Space(5)//+Left(BuscaEmpresa(EEC->EEC_PREEMB,"Q","B"),21) // Transportadora
                  Else
                     mDet := mDet+Space(5)//+Left(BuscaEmpresa(EEC->EEC_PREEMB,"Q","1"),21) // Agente Embarcador
                  Endif
               Endif
               
               mDet := mDet+ENTER
               i := i + 1
               if lFormRE
                  EXIT
               ENDIF
            Next   
         ENDIF
	     //adicionar registro no AVGLTT
	     AVGLTT->(DBAPPEND())
	     AVGLTT->AVG_CHAVE  := EEC->EEC_PREEMB //nr. do processo
	     AVGLTT->WK_DETALHE := mDet // Detalhes ...
	        
	     cSeqRel := GetSXENum("SY0","Y0_SEQREL")
	     CONFIRMSX8()
	         
	     //executar rotina de manutencao de caixa de texto
	     IF !E_AVGLTT("M",WORKID->EEA_TITULO,"AVG_C01150")
	        lCancel := .t.
	        Exit
	     Endif
	         
	     //forcar atualizacao
	     //HEADER_H->(DBCOMMIT())
	     //DETAIL_H->(DBCOMMIT())
	     HEADER_P->(DBCOMMIT())
	     DETAIL_P->(DBCOMMIT())
	
	     MsgInfo(STR0014+LTrim(Str(nVez))+OemToAnsi(STR0015)+STR0016,STR0017) //"Posicione a "###"¦"###" via do Form A."###"Aviso"
	        
	     cRpt := WORKID->EEA_ARQUIV
	         
	     // AvgCrw32 acrescenta o path do crystal
	     IF ! AvgCrw32(@cRpt,WorkId->EEA_TITULO,cSeqRel)
	        lCancel := .t.
	        Exit
	     Endif
	         
	     //gravar historico de documentos
	     E_HISTDOC(,WorkId->EEA_TITULO,dDATABASE,,,cRPT,cSeqRel,WorkId->EEA_FASE,EEC->EEC_PREEMB,WorkId->EEA_COD)
	         
	     nVez := nVez+1
      Enddo
      
      
      IF lCancel 
         Break
      Endif
      
      nPagina := nPagina+1
   Enddo

      
   if lformRE //20/07 - BCO - Imprime o Documento de Anexo de RE'S
      
      MsgInfo("Imprimindo a folha de anexo de RE'S")
	  cArqRpt := "FormA_RE.rpt"// nome do relatório no Crystal
      cTitRpt := "Anexo Form A" 
      lRet := CrwPreview(aRetCrwFormA,cArqRpt,cTitRpt,cSeqRel)   
      
   endif


End Sequence 

if select("WKFA") != 0
   WKFA->(DbClosearea())
ENDIF

RestOrd(aOrd)

Return .F.

/*
Funcao      : FormA
Parametros  : 
Retorno     : 
Objetivos   : FORM A
Autor       : Cristiano A. Ferreira
Data/Hora   : 
Revisao     :
Obs.        :
*/
Static Function FormA

Local fa_nPrint:=3,fa_nPag := 0,fa_nNcm:=5,fa_cNcm:= Space(AVSX3("EE9_POSIPI",AV_TAMANHO))
Local fa_nIt:=1,fa_cItLn:= Space(LenCol1),fa_cMark:= MSMM(EEC->EEC_CODMAR,AVSX3("EEC_MARCAC",3))
Local fa_cMarkLn := Space(LenCol2),fa_nMarkLn := 1,fa_nMarkTo := MlCount(fa_cMark,LenCol2)
Local fa_cDescr:="",fa_cDescrLn:= Space(LenCol2),fa_nDescrTo:=1,fa_cCritLn:=Space(LenCol4)
Local fa_cPesoLn:= Space(LenCol5),fa_cInvLn:= Space(LenCol6),fa_nPesoPag:= 0
Local fa_nFobNcm:= 0,fa_nPesNcm:= 0,fa_cRe:= "",fa_dRe:= AVCTOD(""),fa_nLinhas:= 1, fa_i:=0
Local aData:={} 
Local l1vez := .T.
Local lfRENewPg := .F.
Local nLastPage := 0


Begin Sequence
   CursorWait()
   
   EE9->(dbSeek(xFilial()+EEC->EEC_PREEMB))
   
   While EE9->(!Eof() .And. EE9_FILIAL==xFilial("EE9")) .And.;
         EE9->EE9_PREEMB == EEC->EEC_PREEMB  
         SysRefresh()
      
      // Verifica se mudou a Ncm ...
      IF fa_cNcm != EE9->EE9_POSIPI
         // Atualiza o Valor Fob e Peso por Ncm ...
         aEval(aCols,{|z,y,x| x := aCols[y][PAGE]==fa_nPag .And. aCols[y][NCM]==fa_cNcm,;
                            if(x,aCols[y][PESLIQ] := fa_nPesNcm,),;
                            if(x,aCols[y][VLFOB]  := fa_nFobNcm,)})
         
         fa_nNcm := fa_nNcm+1
         if l1vez == .T. //20/07 - BCO - Caso seja a primeira vez que é executada a rotina alguns valores são definidos.
            fa_cLNcm := fa_cNcm
            fa_cNcm := EE9->EE9_POSIPI
            fa_nFobNcm := 0
            fa_nPesNcm := 0
            fa_cLRe    := fa_cRe
            fa_cRe     := EE9->EE9_RE
            fa_dRe     := EE9->EE9_DTRE
         endif
         // Verifica se houve quebra de pagina ...
         IF fa_nNcm > 4 .and. (!lformRE .OR. l1vez) //20/07 - BCO - Condição para executar rotina
            l1vez := .F.
            IF fa_nPag > 0
               fa_cDescrLn := IncSpace("NET WEIGHT: "+Transf(fa_nPesoPag,"@E 999,999,999.999")+" KG",LenCol3,.f.)
               
               AddaCols(Space(LenCol1),Space(LenCol2),fa_cDescrLn,;
                        Space(LenCol4),Space(LenCol5),Space(LenCol6),;
                        fa_cNcm,fa_cRe,fa_dRe,fa_nFobNcm,fa_nPesNcm,;
                        fa_nPag,fa_nLinhas)
               fa_cLNcm := fa_cNcm       
               fa_cNcm := EE9->EE9_POSIPI
               fa_nFobNcm := 0
               fa_nPesNcm := 0
               fa_cLRe    := fa_cRe
               fa_cRe     := EE9->EE9_RE
               fa_dRe     := EE9->EE9_DTRE         
            Endif
            
            if lformRE .AND. !lfRENewPg
               fa_nPag := 1
            else
               lfRENewPg := .F.
               fa_nPag := nLastPage
               fa_nPag := fa_nPag+1
            endif
            fa_nNcm := 1
            fa_nPrint := 3
            fa_nLinhas := 1
            fa_nPesoPag:= 0
         Endif
         fa_cLNcm := fa_cNcm 
         fa_cNcm := EE9->EE9_POSIPI
         fa_nFobNcm := 0
         fa_nPesNcm := 0
         fa_cLRe    := fa_cRe
         fa_cRe     := EE9->EE9_RE
         fa_dRe     := EE9->EE9_DTRE
      Endif
      
      fa_cDescr  := IF(fa_nPrint==3,AllTrim(EEC->EEC_PACKAGE)+ENTER,"")+AllTrim(MSMM(EE9->EE9_DESC,AVSX3("EE9_VM_DES",3)))
      fa_nDescrTo:= MlCount(fa_cDescr,LenCol3)
      
      // Verifica se houve quebra de pagina ...
      IF fa_nLinhas+fa_nDescrTo > TOTAL_ITENS
         IF fa_nPag > 0
            // Atualiza o Valor Fob e Peso por Ncm ...
            aEval(aCols,{|z,y,x| x := aCols[y][PAGE]==fa_nPag .And. aCols[y][NCM]==fa_cNcm,;
                               if(x,aCols[y][PESLIQ] := fa_nPesNcm,),;
                               if(x,aCols[y][VLFOB]  := fa_nFobNcm,) })
            
            fa_cDescrLn := IncSpace("NET WEIGHT: "+Transf(fa_nPesoPag,"@E 999,999,999.999")+" KG",LenCol3,.f.)
            AddaCols(Space(LenCol1),Space(LenCol2),fa_cDescrLn,Space(LenCol4),Space(LenCol5),Space(LenCol6),fa_cLNcm,fa_cLRe,fa_dRe,fa_nFobNcm,fa_nPesNcm,fa_nPag,fa_nLinhas)
            fa_nPrint:=3
            nLastPage := fa_nPag
            fa_nPag := 0
            fa_nNcm:=5
            fa_cNcm:= Space(AVSX3("EE9_POSIPI",AV_TAMANHO))
            fa_nIt:=1
            fa_cItLn:= Space(LenCol1)
            fa_cMark:= MSMM(EEC->EEC_CODMAR,AVSX3("EEC_MARCAC",3))
            fa_cMarkLn := Space(LenCol2)
            fa_nMarkLn := 1
            fa_nMarkTo := MlCount(fa_cMark,LenCol2)
            fa_cDescr:=""
            fa_cDescrLn:= Space(LenCol2)
            fa_nDescrTo:=1
            fa_cCritLn:=Space(LenCol4)
            fa_cPesoLn:= Space(LenCol5)
            fa_cInvLn:= Space(LenCol6)
            fa_nPesoPag:= 0
            fa_nFobNcm:= 0
            fa_nPesNcm:= 0
            fa_cRe:= ""
            fa_dRe:= AVCTOD("")
            fa_nLinhas:= 1
            fa_i:=0
            aData:={} 
            l1vez := .T.
            lfRENewPg := .T.
            loop
         Endif
         
         //fa_nNcm := 1
         fa_cLNcm := fa_cNcm //20/07 - BCO - Tratamento para não errado no tratamento com NCM 
         fa_cNcm := EE9->EE9_POSIPI
         
         fa_cLRe    := fa_cRe
         fa_cRe     := EE9->EE9_RE
         fa_dRe     := EE9->EE9_DTRE
         
         if lformRE .AND. !(fa_nLinhas+fa_nDescrTo > TOTAL_ITENS)
            fa_nPag := 1
         else
            fa_nFobNcm := 0
            fa_nPesNcm := 0
            fa_nPag := fa_nPag+1
            fa_nPrint := 3
            fa_nLinhas := 1
            fa_nPesoPag:= 0
         endif

      Endif
      
      // Totaliza Fob e Peso ...
      /*aEval(aCols,{|z,y,x| x := aCols[y][PAGE]==fa_nPag .And. aCols[y][NCM]==fa_cNcm,;
                          if(x,aCols[y][PESLIQ] := fa_nPesNcm,),;
                          if(x,aCols[y][VLFOB]  := fa_nFobNcm,) })*/
      fa_nFobNcm := fa_nFobNcm+(EE9->EE9_SLDINI*EE9->EE9_PRECOI)
      fa_nPesNcm := fa_nPesNcm+EE9->EE9_PSLQTO
      fa_nPesoPag:= fa_nPesoPag+EE9->EE9_PSLQTO
   
      IF fa_nPrint==3
         fa_nPrint:=2
      Endif
      
      For fa_i:=1 To fa_nDescrTo
         SysRefresh()
         
         IF fa_i == 1
            fa_cItLn   := StrZero(fa_nIt,3)
         Else
            fa_cItLn   := Space(LenCol1)
         Endif
         
         IF fa_nMarkLn <= fa_nMarkTo
            fa_cMarkLn := MemoLine(fa_cMark,LenCol2,fa_nMarkLn)
            fa_nMarkLn := fa_nMarkLn+1
         Else
            fa_cMarkLn := Space(LenCol2)
         Endif
         
         fa_cDescrLn := MemoLine(fa_cDescr,LenCol3,fa_I)
         fa_cLNcm := fa_cNcm
         fa_cNcm := EE9->EE9_POSIPI
         fa_cLRe    := fa_cRe
         fa_cRe     := EE9->EE9_RE
         fa_dRe     := EE9->EE9_DTRE
         

         
   
         IF fa_nPrint == 2
            fa_nPrint := 1
            // by CAF 24/08/2001 fa_cCritLn := Padc(AllTrim(Posicione("EEI",1,xFilial("EEI")+EE9->EE9_COD_I+EEC->EEC_PAISDT+cCodInst,"EEI_CRITOR")),LenCol4)
            fa_cCritLn := Space(LenCol4)
            fa_cPesoLn := Padl("KG",LenCol5)
            fa_cInvLn  := Padc(AllTrim(EEC->EEC_NRINVO),LenCol6)
         Else
            fa_cCritLn := Space(LenCol4)
            fa_cPesoLn := Space(LenCol5)
            fa_cInvLn  := Space(LenCol6)
            IF fa_nPrint == 1
               fa_nPrint  := 0
               fa_cPesoLn := Padl(AllTrim(Transf(EE9->EE9_PSBRTO,AVSX3("EE9_PSBRTO",6))),LenCol5)

               aData := DataExtenso(EEC->EEC_DTINVO,EEC->EEC_IDIOMA)
               fa_cInvLn  :=  Padc(Left(aData[1],3)+". "+aData[2]+", "+aData[3],LenCol6) // Padc(Dtoc(EEC->EEC_DTINVO),LenCol6)
            Else
               fa_cInvLn  := Space(LenCol6)
               //fa_cPesoLn := Space(LenCol5)
               fa_cPesoLn := Padl(AllTrim(Transf(EE9->EE9_PSBRTO,AVSX3("EE9_PSBRTO",6))),LenCol5) //20/07 - BCO - Imprime o peso de cada item
            Endif
         Endif

         AddaCols(fa_cItLn,fa_cMarkLn,fa_cDescrLn,fa_cCritLn,fa_cPesoLn,fa_cInvLn,fa_cNcm,fa_cRe,fa_dRe,fa_nFobNcm,fa_nPesNcm,fa_nPag,fa_nLinhas)
         fa_nLinhas := fa_nLinhas+1
      Next fa_i   
      
      fa_nIt := fa_nIt+1
      
      EE9->(dbSkip())
               
   Enddo
   
   // Verifica se imprimiu todas as linhas da marcacao ...
   For fa_nMarkLn:=fa_nMarkLn To fa_nMarkTo
      // Verifica se houve quebra de pagina ...
      IF fa_nLinhas > TOTAL_ITENS
         IF fa_nPag > 0
            // Atualiza o Valor Fob e Peso por Ncm ...
            aEval(aCols,{|z,y,x| x := aCols[y][PAGE]==fa_nPag .And. aCols[y][NCM]==fa_cNcm,;
                               if(x,aCols[y][PESLIQ] := fa_nPesNcm,),;
                               if(x,aCols[y][VLFOB]  := fa_nFobNcm,) })
            
            fa_cDescrLn := IncSpace("NET WEIGHT: "+Transf(fa_nPesoPag,"@E 999,999,999.999")+" KG",LenCol3,.f.)
            AddaCols(Space(LenCol1),Space(LenCol2),fa_cDescrLn,Space(LenCol4),Space(LenCol5),Space(LenCol6),fa_cNcm,fa_cRe,fa_dRe,fa_nFobNcm,fa_nPesNcm,fa_nPag,fa_nLinhas)
         Endif
         

         if lformRE
            fa_nPag := 1
         else
            fa_nPag := fa_nPag+1
         endif
         fa_nPrint := 3
         fa_nLinhas := 1
         fa_nPesoPag:= 0 
         //fa_nNcm := 1
         fa_cNcm := Space(Len(EE9->EE9_POSIPI))
         fa_nFobNcm := 0
         fa_nPesNcm := 0
         fa_cRe     := Space(Len(EE9->EE9_RE))
         fa_dRe     := AVCTOD("")
         
      Endif
      
      fa_cItLn   := Space(LenCol1)
      fa_cMarkLn := MemoLine(fa_cMark,LenCol2,fa_nMarkLn)
      fa_cDescrLn:= Space(LenCol3)
      fa_cCritLn := Space(LenCol4)
      fa_cPesoLn := Space(LenCol5)
      fa_cInvLn  := Space(LenCol6)
            
      AddaCols(fa_cItLn,fa_cMarkLn,fa_cDescrLn,fa_cCritLn,fa_cPesoLn,fa_cInvLn,fa_cNcm,fa_cRe,fa_dRe,fa_nFobNcm,fa_nPesNcm,fa_nPag,fa_nLinhas)
      fa_nLinhas := fa_nLinhas+1
   Next fa_nMarkLn
   
   IF fa_nPag > 0
      // Atualiza o Valor Fob e Peso por Ncm ...
      /*aEval(aCols,{|z,y,x| x := aCols[y][PAGE]==fa_nPag .And. aCols[y][NCM]==fa_cNcm,;
                         if(x,aCols[y][PESLIQ] := fa_nPesNcm,),;
                         if(x,aCols[y][VLFOB]  := fa_nFobNcm,) })*/
            
      fa_cDescrLn := IncSpace("NET WEIGHT: "+Transf(fa_nPesoPag,"@E 999,999,999.999")+" KG",LenCol3,.f.)
      AddaCols(Space(LenCol1),Space(LenCol2),fa_cDescrLn,Space(LenCol4),Space(LenCol5),Space(LenCol6),fa_cNcm,fa_cRe,fa_dRe,fa_nFobNcm,fa_nPesNcm,fa_nPag,fa_nLinhas)
   Endif
         
   CursorArrow()
   
End Sequence            

Return NIL

/*
Funcao      : AddFormA
Parametros  : 
Retorno     : 
Objetivos   : FORM A
Autor       : Cristiano A. Ferreira
Data/Hora   : 
Revisao     :
Obs.        :
*/
Static Function AddFormA

Local af_lNewPage := .t.,af_cNcm:= "",af_nNcm:= 0,af_cDet:= ""
Local af_i :=0

nPagina := 0
aPagina := {}

For af_i := 1 to Len(aCols)
   
   // Verifica se a linha foi excluida ...
   IF ATail(aCols[af_i])
      Loop
   Endif
   
   IF nPagina <> aCols[af_i][PAGE]
      af_lNewPage := .t.
   Else
      IF aCols[af_i][NCM] <> af_cNcm
         af_cNcm := aCols[af_i][NCM]
         IF (af_nNcm:=aScan(aPagina[nPagina][1],aCols[af_i][NCM])) == 0 .And. Len(aPagina[nPagina][1]) >= 4 .AND. !lFormRE
            af_lNewPage := .t.
         Elseif af_nNcm == 0
            aAdd(aPagina[nPagina][1],{aCols[af_i][NCM],aCols[af_i][RE],aCols[af_i][DTRE],aCols[af_i][VLFOB],aCols[af_i][PESLIQ]})
         Endif
      Endif
   Endif
   
   af_cDet:=MARGEM
   af_cDet:=af_cDet+IncSpace(aCols[af_i][ITEM],LenCol1,.f.)+" "
   af_cDet:=af_cDet+IncSpace(aCols[af_i][MARK],LenCol2,.f.)+" "
   af_cDet:=af_cDet+IncSpace(aCols[af_i][DESC],LenCol3,.f.)+" "
   af_cDet:=af_cDet+IncSpace(aCols[af_i][CRIT],LenCol4,.f.)
   af_cDet:=af_cDet+IncSpace(aCols[af_i][PESO],LenCol5,.f.)+" "
   af_cDet:=af_cDet+IncSpace(aCols[af_i][INVO],LenCol6,.f.)+" "
   
   IF af_lNewPage
      af_lNewPage := .f.
      aAdd(aPagina,{{{aCols[af_i][NCM],aCols[af_i][RE],aCols[af_i][DTRE],aCols[af_i][VLFOB],aCols[af_i][PESLIQ]}},af_cDet})
      nPagina := aCols[af_i][PAGE]
      af_cNcm := aCols[af_i][NCM]
   Else
      aPagina[nPagina][2] := aPagina[nPagina][2]+ENTER+af_cDet
   Endif
      
Next af_i

Return NIL

/*
Funcao      : TelaGets
Parametros  : 
Retorno     : 
Objetivos   : FORM A
Autor       : Cristiano A. Ferreira
Data/Hora   : 
Revisao     :
Obs.        :
*/
Static Function TelaGets

Local aRotOld := NIL

Local nColPos := 1
Local nPos    := 1

Local lRet := .f.
Local nOpc := 0

Local bEmpty  := {|x| SysRefresh(), !Empty(x) }
Local bLineOk := {|| aScan(aCols[n],bEmpty) <> 0 }

Local bOk     := {|| nOpc:=1,oDlg:End() }
Local bCancel := {|| nOpc:=0,oDlg:End() }
Local aPos

IF Type("aRotina") == "A"
   aRotOld := aClone(aRotina)
Endif

aRotina := { {"RDMAKE","SIGAIXB",0,4} }
aAdd(aRotina,aClone(aRotina[1]))
aAdd(aRotina,aClone(aRotina[1]))

Begin Sequence                                                                            

   DEFINE MSDIALOG oDlg TITLE AllTrim(WorkId->EEA_TITULO) FROM DLG_LIN_INI,DLG_COL_INI TO DLG_LIN_FIM,DLG_COL_FIM OF oMainWnd PIXEL
      
      // @ 6,5 TO 93,150 MULTILINE MODIFY DELETE FREEZE 1   
      aPos := PosDlg(oDlg)
      oGetDb := IW_MultiLine(aPos[1],aPos[2],aPos[3],aPos[4],.T.,.T.)
      oGetDb:oBrowse:bAdd := {||.f.}
   
   ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,bOk,bCancel)
   
   IF nOpc == 1
      lRet := .t.
   Endif

End Sequence

aRotina := aRotOld

Return lRet

/*
Funcao      : AtualizaBrw
Parametros  : 
Retorno     : 
Objetivos   : FORM A
Autor       : Cristiano A. Ferreira
Data/Hora   : 
Revisao     :
Obs.        :
*/
Static Function AtualizaBrw(ab_cField)
// ab_cField := WKPAGE/WKLINE

Local xOld

Begin Sequence

   IF Type("oGetDb") <> "O"
      Break
   Endif
             
   IF ab_cField == "WKLINE"
      
      aCols[n][LINE] := M->WKLINE
      //xOld := aCols[n][Len(aCols[n])]
      //aCols[n][Len(aCols[n])] := "Flag"
      
      aCols := aSort(aCols,,,{|x,y| Str(x[PAGE],2)+Str(x[LINE],2) < Str(y[PAGE],2)+Str(y[LINE],2)})
      
      M->WKLINE := aCols[n][LINE]
      //n := aScan(aCols,{|x| ValType(x[Len(x)]) == "C" .And. x[Len(x)] == "Flag"})      
      //aCols[n][Len(aCols[n])] := xOld
   Else
      aCols[n][PAGE] := M->WKPAGE
      aCols := aSort(aCols,,,{|x,y| Str(x[PAGE],2)+Str(x[LINE],2) < Str(y[PAGE],2)+Str(y[LINE],2)})
      M->WKPAGE := aCols[n][PAGE]
   Endif   
   
//   oGetDb:oBrowse:Refresh()
   
End Sequence

Return .T.

/*
Funcao      : AddaCols
Parametros  : 
Retorno     : 
Objetivos   : FORM A
Autor       : Cristiano A. Ferreira
Data/Hora   : 
Revisao     :
Obs.        :
*/
Static Function AddaCols(cItLn,cMarkLn,cDescrLn,cCritLn,cPesoLn,cInvLn,cNcm,cRe,dRe,nFobNcm,nPesNcm,nPag,nLinhas)

Begin Sequence

   aAdd(aCols,Array(14))
   aCols[Len(aCols)][14] := .f. // Deleted
   aCols[Len(aCols)][PAGE] := nPag
   aCols[Len(aCols)][LINE] := nLinhas

   aCols[Len(aCols)][ITEM]  := cItLn
   aCols[Len(aCols)][MARK]  := cMarkLn
   aCols[Len(aCols)][DESC]  := cDescrLn
   aCols[Len(aCols)][CRIT]  := cCritLn
   aCols[Len(aCols)][PESO]  := cPesoLn
   aCols[Len(aCols)][INVO]  := cInvLn
   aCols[Len(aCols)][NCM]   := cNcm
   aCols[Len(aCols)][RE]    := cRe
   aCols[Len(aCols)][DTRE]  := dRe
   aCols[Len(aCols)][VLFOB] := nFobNcm
   aCols[Len(aCols)][PESLIQ]:= nPesNcm

End Sequence

Return NIL

*------------------------------------------------------------------------------*
* FIM DO PROGRAMA EECPEM12.PRW                                                 *
*------------------------------------------------------------------------------*

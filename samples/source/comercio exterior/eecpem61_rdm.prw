/*
Programa..: EECPEM61.PRW
Objetivo..: Apêndice I ao Anexo IV - Certificado de Origem - Acordo Mercosul - Colômbia, Equador e Venezuela
Autor.....: João Pedro Macimiano Trabbold
Data/Hora.: 18/03/05 9:21
Obs.......: considera que está posicionado na Tabela de Processo de Embarque (EEC)
            
            Exemplo de Chamada do Rdmake
            ExecBlock("EECPEM61",.F.,.F.,{Tipo} )
            Tipo - Pode ser: "FIESP"  - Federação das Indústrias do Estado de São Paulo
                             "SANTOS" - Associação Comercial de Santos
                
*/
#include "EECRDM.CH"
#INCLUDE "EECPEM61.CH"

*--------------------------------------------------------------------
User Function EECPEM61
Local mDet,mRod,;
      lRet    := .F.,;
      aOrd    := SaveOrd({"EE9","EEI","SB1","SA2","SA1"}),;
      aLenCol, aLenCon

Local cMargem , nLenCon1, nLenCon2, nTotNormas, nLenCol1, nLenCol2, nLenCol3, nTotItens, nTamObs

Local cTipo := ParamIxb[1], lFiesp

Private cEdita,;
        aRecNo   := {},aRod     := {},aCab := {},;
        aC_Item  := {},aC_Norma := {},;
        aH_Item  := {},aH_Norma := {}, lFamilia := GetMv("MV_AVG0078",,.f.) 
Private nLenCol4, nLenCol5

If cTipo == "FIESP"
   lFiesp := .t.
   
   nLenCon1   := 8
   nLenCon2   := 93
   nTotItens  := 10
   nTamObs    := 93
   
   cMargem    := Space(03)
   nTotNormas := 06
   nLenCol1   := 08
   nLenCol2   := 12 
   nLenCol3   := 53 
   nLenCol4   := 16
   nLenCol5   := 16
   
ElseIf cTipo == "SANTOS"
   lFiesp := .f.
   
   nLenCon1   := 10
   nLenCon2   := 93
   nTotItens  := 10
   nTamObs    := 93
   
   cMargem    := Space(03)//FSY -  13/08/2013 - Alinhamento do relatório
   nTotNormas := 06
   nLenCol1   := 08
   nLenCol2   := 14 
   nLenCol3   := 50 
   nLenCol4   := 16
   nLenCol5   := 17
EndIf

aLenCol := {{"ORDEM"    ,nLenCol1,"C",STR0001},; //"Ordem"
            {"COD_NALAD",nLenCol2,"C",STR0002},; //"Cod.NALADI/SH"
            {"DESCRICAO",nLenCol3,"M",STR0003},; //"Descricao"
            {"PESO_QTDE",nLenCol4,"C",STR0004},; //"Peso Liq. ou Qtde."
            {"VALOR_FOB",nLenCol5,"C",STR0005}}  //"Valor Fob em Dolar"

aLenCon := {{"ORDEM"    ,nLenCon1,"C",STR0001},; //"Ordem"
            {"DESCRICAO",nLenCon2,"C",STR0006}}  //"Normas de Origem"

IF COVeri("ACE") // FJH 12/08/05 // verifica se país pertence ao acordo ace59
   IF CODet(aLenCol,aLenCon,"EE9_NALSH",nTotNormas,"PEM61",nTotItens,,,"1") // Detalhes
      aCab := COCab()        // Cabeçalho
      aRod := CORod(nTamObs) // Rodapé
      
      // DATA DE EMISSAO DO CERTIFICADO
      aRod[4] := Str(Day(dDATABASE),2)+" DE "+Alltrim(UPPER(MesExtenso(Month(dDATABASE))))+" DE "+Str(Year(dDATABASE),4)

      // Tela para edição dos dados
      IF COTelaGets(If(lFiesp,"FIESP","Associação Comercial de Santos"),"1")
          
         //Cabeçalho
         mDet := ""
         mDet += Replicate(ENTER,15)// Linhas em branco//FSY - 13/08/2013 - Removido o IF lFiesp
         //DFS - 03/12/12 - Alterado tratamento para preenchimento do Exportador e Importador. 
         mDet += cMargem+Space(19)+If(lFiesp,If(!Empty(aCab[1,4]),Alltrim(aCab[1,4])," "),"")+Space(55)+aCab[2,4]+ENTER  // Países do Exportador e Importador
         mDet += Replicate(ENTER,2)
          
         // Complemento (entre os itens e as normas)
         mCompl := ""
         If lFiesp
            mCompl += Replicate(ENTER,2)  // Linhas em branco entre o detalhe e o complemento
            mCompl += cMargem+Space(92) + Transform(aCab[7],AvSx3("EEC_NRINVO",AV_PICTURE)) + Replicate(ENTER,2)//nr. da Invoice
            mCompl += cMargem+Space(8)  + aCab[8]+Replicate(ENTER,2)//Data da Invoice
            mCompl += cMargem+Space(18) + aRod[2]+ENTER // Instrumento de Negociação
            mCompl += Replicate(ENTER,3)  // Linhas em branco entre o complemento e as normas
         Else
            mCompl += Replicate(ENTER,2)  // Linhas em branco entre o detalhe e o complemento
            mCompl += cMargem   + Space(92) + Transform(aCab[7],AvSx3("EEC_NRINVO",AV_PICTURE)) + Replicate(ENTER,2)//nr. da Invoice
            mCompl += Space(9)  + aCab[8]   + Replicate(ENTER,2)//Data da Invoice
            mCompl += Space(20) + cMargem   + "ACE 59" + Space(1) + aRod[2] + ENTER // Instrumento de Negociação
            mCompl += Replicate(ENTER,3)  // Linhas em branco entre o complemento e as normas
         EndIf
         
         // Rodapé
         mRod := "" + Replicate(ENTER,2)
         
         //Exportador ou Produtor - Razão Social e Endereço
         mRod += cMargem + Space(10) + aCab[1][1] + Replicate(ENTER,2) //Importador
         mRod += cMargem + Space(8)  + aCab[1][2] + ENTER //Endereço 1
         mRod += cMargem + Space(8)  + aCab[1][3] + ENTER //Endereço 2 - FSY - 09/08/2013 - Adicionado mais uma linha para imprimir dados do exportador

         // Data de Impressão do Certificado
         mRod += cMargem+Space(8)+Str(Day(CtoD(aRod[5])),2)+" DE "+;
                 Alltrim(UPPER(MesExtenso(Month(CtoD(aRod[5])))))+" DE "+;
                 Str(Year(CtoD(aRod[5])),4)+Replicate(ENTER,4)
                 
         //Importador
         mRod += cMargem + Space(10) + aCab[2][1]+Replicate(ENTER,2)
         //mRod += cMargem + Space(8)+aCab[2][2]+Replicate(ENTER,2)//FSY - 09/08/2013 - Antigo
         mRod += cMargem + Space(8)  + RTrim(aCab[2][2]) + Space(1) + aCab[2][3] + Replicate(ENTER,2)//Endereço 2 - FSY - 09/08/2013 - Adicionado mais uma linha para imprimir dados do importador - FSY 15/08/2013 - adicionado Space(1)
         
         //Transporte
         mRod += cMargem + Space(15)+aCab[6] + Replicate(ENTER,2) //Meio de Transporte
         mRod += cMargem + Space(23)+aCab[4] + Replicate(ENTER,2) // Porto ou lugar de embarque
         
         mRod += Replicate(ENTER,1)                 // Linhas em branco
         mRod += cMargem+aRod[1,1]+ENTER            // Linha 1 das Obs.
         mRod += cMargem+aRod[1,2]+ENTER            // Linha 2 das Obs. 
         mRod += cMargem+aRod[1,3]+ENTER            // Linha 3 das Obs.//FSY - 09/08/2013 - Adicionado mais uma linha na caixa de observações          
         mRod += Replicate(ENTER,2)                 // Linhas em branco
         mRod += cMargem+If(!lFiesp,Space(42)+"SANTOS","")+Replicate(ENTER,3) // Cidade
         mRod += Space(If(lFiesp,2,2))+aRod[4]+Replicate(ENTER,4) // Data de Emissão do Certificado
         
         // Detalhes
         lRet := COImp(mDet,mRod,cMargem,1,mCompl)
         
      EndIf
   EndIf
ENDIF  // FJH 15/08/05
RestOrd(aOrd)
Return lRet
*--------------------------------------------------------------------
USER FUNCTION PEM61()
Local cPictPeso  := "@E 99,999,999" + IF(EEC->EEC_DECPES > 0, "." + Replic("9",EEC->EEC_DECPES),""),;
      cPictPreco := AVSX3("EE9_PRCTOT",AV_PICTURE)
Local cDescFam := ""

//Verifica se imprime a descrição da família
If lFamilia
   cDescFam := AllTrim(Posicione("SYC",1,xFilial("SYC")+EE9->EE9_FPCOD,"YC_NOME"))+ENTER
ENDIF

TMP->ORDEM     := TMP->TMP_ORIGEM
TMP->COD_NALAD := TRANSFORM(TMP->EE9_NALSH,AVSX3("EE9_NALSH",AV_PICTURE))
TMP->DESCRICAO := cDescFam + TMP->TMP_DSCMEM
TMP->PESO_QTDE := PADL(ALLTRIM(TRANSFORM(TMP->TMP_PLQTDE,cPICTPESO)) ,nLencol4," ")
TMP->VALOR_FOB := PADL(ALLTRIM(TRANSFORM(TMP->TMP_VALFOB,cPICTPRECO)),nLencol5," ")

RETURN(NIL)
*--------------------------------------------------------------------

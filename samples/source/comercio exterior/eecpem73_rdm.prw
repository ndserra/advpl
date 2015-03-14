/*
Programa..: EECPEM73_RDM.PRW
Objetivo..: Certificado de Origem - Acordo Mercosul - Colômbia, Equador e Venezuela
Autor.....: Julio de Paula Paz
Data/Hora.: 09/06/2006 15:00
Obs.......: considera que está posicionado na Tabela de Processo de Embarque (EEC)
            
            Exemplo de Chamada do Rdmake
            ExecBlock("EECPEM73",.F.,.F.),{Tipo} )
            // Tipo =  "FIEP"  - Federação das Indústrias do Estado do Paraná
Revisão...: Fabrício e Diogo - 22/10/2009.
            Atualização do layout para a versão 5
*/
#include "EECRDM.CH"
#INCLUDE "EECPEM73.CH"

*--------------------------------------------------------------------
User Function EECPEM73
Local mDet,mRod,;
      lRet    := .F.,;
      aOrd    := SaveOrd({"EE9","EEI","SB1","SA2","SA1"}),;
      aLenCol, aLenCon

Local cMargem , nLenCon1, nLenCon2, nTotNormas, nLenCol1, nLenCol2, nLenCol3, nTotItens, nTamObs

Private cEdita,;
        aRecNo   := {},aRod     := {},aCab := {},;
        aC_Item  := {},aC_Norma := {},;
        aH_Item  := {},aH_Norma := {}, lFamilia := GetMv("MV_AVG0078",,.f.) 
Private nLenCol4, nLenCol5
   
nLenCon1   := 8
nLenCon2   := 93
nTotItens  := 07
nTamObs    := 80 //tamanho máximo para gravação na tabela EX0
   
cMargem    := Space(05)
nTotNormas := 04
nLenCol1   := 08
nLenCol2   := 13
nLenCol3   := 61
nLenCol4   := 13
nLenCol5   := 12
   
aLenCol := {{"ORDEM"    ,nLenCol1,"C",STR0001},; //"Ordem"
            {"COD_NALAD",nLenCol2,"C",STR0002},; //"Cod.NALADI/SH"
            {"DESCRICAO",nLenCol3,"M",STR0003},; //"Descricao"
            {"PESO_QTDE",nLenCol4,"C",STR0004},; //"Peso Liq. ou Qtde."
            {"VALOR_FOB",nLenCol5,"C",STR0005}}  //"Valor Fob em Dolar"

aLenCon := {{"ORDEM"    ,nLenCon1,"C",STR0001},; //"Ordem"
            {"DESCRICAO",nLenCon2,"C",STR0006}}  //"Normas de Origem"

IF COVeri("ACE") // verifica se país pertence ao acordo ace59
   IF CODet(aLenCol, aLenCon, "EE9_NALSH", nTotNormas, "PEM73", nTotItens,,, "1") //Detalhes
      aCab := COCab()        // Cabeçalho
      aRod := CORod(nTamObs) // Rodapé
      
      // Tela para edição dos dados
      IF COTelaGets("FIEP", "B3")
          
         //Cabeçalho
         mDet := ""
         mDet += Replicate(ENTER,12) // Linhas em branco
         mDet += cMargem+Space(52)+aCab[2,4]+ENTER // País Importador
         mDet += Replicate(ENTER,3)
          
         // Complemento (entre os itens e as normas)
         mCompl := ""
         mCompl += Replicate (ENTER,2) // Linhas em branco entre o detalhe e o complemento
         mCompl += cMargem+Space(84)+Alltrim(Transform(aCab[7],AvSx3("EEC_NRINVO",AV_PICTURE)))+Space(12)+aCab[8] //nr. da Invoice e data 
         mCompl += Replicate(ENTER,6)  // Linhas em branco entre o complemento e as normas

         // Rodapé
         mRod := "" + ENTER //+ Replicate(ENTER,2)
         
         //Exportador ou Produtor - Razão Social e Endereço
         mRod += cMargem + Space(13)+aCab[1][1]+Replicate(ENTER,1)
         mRod += cMargem + Space(13)+aCab[1][2]+Replicate(ENTER,2) 

         //Data por extenso
         mRod += cMargem + Space(4) + Str(Day(CtoD(aRod[5])), 2) + " DE " + AllTrim(Upper(MesExtenso(Month(CtoD(aRod[5]))))) +;
                " DE " + Str(Year(CtoD(aRod[5])), 4)
        // Data no formato DD/MM/AA
        // mRod += cMargem + Space(5) + aRod[5] + Replicate(ENTER,3) // Data de Emissão do Certificado
                          
         //Importador
         mRod += cMargem + Space(13)+aCab[2][1]+Replicate(ENTER,1)
         mRod += cMargem + Space(13)+aCab[2][2]+Replicate(ENTER,1)
         mRod += cMargem + Space(13)+aCab[2][3]+Replicate(ENTER,2)
        
         //Transporte
         mRod += cMargem + Space(25)+aCab[6]+Replicate(ENTER,1) //Meio de Transporte
         mRod += cMargem + Space(25)+aCab[4]+Replicate(ENTER,1) //Porto ou lugar de embarque
         
         //Observação
         mRod += Replicate(ENTER,2)                 // Linhas em branco
         mRod += Space(87) + aRod[5] + ENTER        // Data na observação
         mRod += cMargem+aRod[1,1]+ENTER            // Linha 1 das Obs.
         mRod += cMargem+aRod[1,2]+ENTER            // Linha 2 das Obs.
         mRod += cMargem+aRod[1,3]+ENTER            // Linha 3 das Obs.

         // Detalhes
         lRet := COImp(mDet,mRod,cMargem,1,mCompl)

      EndIf
   EndIf
ENDIF  
RestOrd(aOrd)
Return lRet                       
*--------------------------------------------------------------------
USER FUNCTION PEM73()
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
TMP->PESO_QTDE := Space(4) + AllTrim(TRANSFORM(TMP->TMP_PLQTDE,cPICTPESO))
TMP->VALOR_FOB := Space(4) + AllTrim(TRANSFORM(TMP->TMP_VALFOB,cPICTPRECO))

RETURN(NIL)
*--------------------------------------------------------------------

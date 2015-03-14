/*
Programa..: EECPEM33.PRW
Objetivo..: Certificado de Origem - Bolivia/Chile
Autor.....: Cristiano A. Ferreira
Data/Hora.: 18/01/2000 14:19
Revisão   : João Pedro Macimiano Trabbold - 13/06/05 - tipos : FIESP, FEDERASUL, FIEP e FIEB
Obs.......: considera que está posicionado no registro de processos (embarque) (EEC)
            Este programa imprime o C.O. da Bolivia e do Chile
            para identificar se é Bolivia ou Chile é usado a
            variavel lBolivia.
            
            Exemplo de Chamada do Rdmake - Bolivia:
            ExecBlock("EECPEM33",.F.,.F.,{"B",Tipo} )
            
            Exemplo de Chamada do Rdmake - Chile:
            ExecBlock("EECPEM33",.F.,.F.,{"C",Tipo} )
                
                Tipo - "FIESP", "FEDERASUL", "FIEP" OU "FIEB"
*/
#include "EECRDM.CH"
#INCLUDE "EECPEM33.CH"

*--------------------------------------------------------------------
USER FUNCTION EECPEM33
LOCAL mDET,mROD,;
      lRET    := .F.,;
      aOrd    := SaveOrd({"EE9","EEI","SB1","SA2","SA1"}),;
      aLENCOL, aLENCON

Local cMargem , nLenCon1, nLenCon2, nTotNormas, nLenCol1, nLenCol2, nLenCol3, nTotItens, nTamObs

Local lLayOut
Local cParam1, cParam2 := ""

If ValType(ParamIxb) = "A"
   cParam1 := ParamIxb[1]
   cParam2 := ParamIxb[2]
Else
   cParam1 := ParamIxb
EndIf

Private cEDITA,;
        lBOLIVIA := (ValType(cParam1) == "U" .OR. cParam1 == "B"),;
        aRECNO   := {},aROD     := {},aCAB := {},;
        aC_ITEM  := {},aC_NORMA := {},;
        aH_ITEM  := {},aH_NORMA := {}, lFamilia := GetMv("MV_AVG0078",,.f.) 
Private nLenCol4, nLenCol5

nLenCon1   := 10
nLenCon2   := 93
nTotItens  := 14
nTamObs    := 93
lLayOut := !Empty(cParam2)

If lLayOut //LayOut do documento impresso juntamente com o conteúdo.
   cMargem    := SPACE(02)
   nTotNormas := 07
   nLenCol1   := 09
   nLenCol2   := 12 
   nLenCol3   := 49
   nLenCol4   := 19
   nLenCol5   := 18
Else //Somente o conteúdo, para formulários prontos.
   cMargem    := " "
   nTotNormas := 04
   nLenCol1   := 10
   nLenCol2   := 20
   nLenCol3   := 45
   nLenCol4   := 17
   nLenCol5   := 17
EndIf        

aLENCOL := {{"ORDEM"    ,nLenCol1,"C",STR0001},; //"Ordem"
            {"COD_NALAD",nLenCol2,"C",STR0002},; //"Cod.NALADI/SH"
            {"DESCRICAO",nLenCol3,"M",STR0003},; //"Descricao"
            {"PESO_QTDE",nLenCol4,"C",STR0004},; //"Peso Liq. ou Qtde."
            {"VALOR_FOB",nLenCol5,"C",STR0005}}//"Valor Fob em Dolar"

aLENCON := {{"ORDEM"    ,nLenCon1,"C",STR0001},; //"Ordem"
            {"DESCRICAO",nLenCon2,"C",STR0006}}  //"Normas de Origem"

//IF COVERI("MER")
IF IF(lBolivia,COVERI("BOL"),COVERI("CHI")) // FJH 12/08/05 //Verifica se país é a bolivia ou chile
   IF CODET(aLENCOL,aLENCON,"EE9_NALSH",nTotNormas,"PEM33",nTotItens,,,"1") // DETALHES
      aCAB := COCAB()        // CABECALHO
      aROD := COROD(nTamObs) // RODAPE
      // EDICAO DOS DADOS
      IF COTELAGETS(IF(lBOLIVIA,STR0007,STR0008)) //"Bolivia"###"Chile"
         // EXPORTADOR
         mDET := ""
         mDET := mDET+REPLICATE(ENTER,8)
         mDET := mDET+cMargem+aCAB[1,1]+ENTER
         mDET := mDET+cMargem+aCAB[1,2]+ENTER
         mDET := mDET+cMargem+aCAB[1,3]+ENTER
         // IMPORTADOR
         mDET := mDET+REPLICATE(ENTER,If(lLayOut,5,2))
         mDET := mDET+cMargem+aCAB[2,1]+ENTER
         mDET := mDET+cMargem+aCAB[2,2]+ENTER
         mDET := mDET+cMargem+aCAB[2,3]+ENTER
         // CONSIGNATARIO
         mDET := mDET+REPLICATE(ENTER,If(lLayOut,5,3))
         mDET := mDET+cMargem+aCAB[3,1]+ENTER
         mDET := mDET+cMargem+aCAB[3,2]+ENTER
         // PORTO OU LOCAL DE EMBARQUE / PAIS DE DESTINO DAS MERCADORIAS
         mDET := mDET+REPLICATE(ENTER,If(lLayOut,4,1))
         mDET := mDET+cMargem+aCAB[4]+SPACE(If(lLayOut,01,02))+;
                              aCAB[5]+ENTER
         // VIA DE TRANSPORTE / N.FATURA / DATA DA FATURA
         mDET := mDET+REPLICATE(ENTER,If(lLayOut,3,2))
         mDET := mDET+cMargem+aCAB[6]+SPACE(If(lLayOut,8,15))+;
                              aCAB[7]+SPACE(If(lLayOut,10,07))+;
                              aCAB[8]+ENTER
         mDET := mDET+REPLICATE(ENTER,3)
         // RODAPE
         mROD := ""
         
         mROD := mROD+cMargem+aROD[1,1]+ENTER  // LINHA 1 DA OBS.
         mROD := mROD+cMargem+aROD[1,2]+ENTER  // LINHA 2 DA OBS.
         mROD := mROD+cMargem+aROD[1,3]+ENTER  // LINHA 3 DA OBS.
         mROD := mROD+cMargem+aROD[1,4]+ENTER  // LINHA 4 DA OBS.
         
         mROD := mROD+REPLICATE(ENTER,8)       // LINHAS EM BRANCO
         mROD := mROD+cMargem+aROD[2]+ENTER    // INSTRUMENTO DE NEGOCIACAO
         mROD := mROD+cMargem+aROD[3]+ENTER    // NOME DO EXPORTADOR
         mROD := mROD+cMargem+aROD[4]+ENTER    // MUNICIPIO/DATA DE EMISSAO
         // DETALHES
         lRET := COIMP(mDET,mROD,cMargem,2)
         If lRet .And. lLayOut
            HEADER_P->(RecLock("HEADER_P",.f.))
            HEADER_P->AVG_C01_10   := cParam2
            HEADER_P->AVG_C02_10   := cParam1
            HEADER_P->(MsUnlock())
         EndIf
         
      ENDIF
   ENDIF
ENDIF
RESTORD(aOrd)
RETURN(lRET)
*-------------------*
USER FUNCTION PEM33()
*-------------------*
// Estrutura do parametro que o ponto de entrada recebe (PARAMIXB)
// 1. Posicao = Numero da Ordem
// 2. Posicao em diante = numero dos registro que estao relacionados na ordem
LOCAL cPictPeso  := IF(lBOLIVIA,"@E ","")+"99,999,999"+IF(EEC->EEC_DECPES>0,"."+Replic("9",EEC->EEC_DECPES),""),;
      cPictPreco := AVSX3("EE9_PRCTOT",AV_PICTURE)
Local cDescFam := ""

//Verifica se imprime a descrição da família
If lFamilia
   cDescFam := Alltrim(POSICIONE("SYC",1,XFILIAL("SYC")+EE9->EE9_FPCOD,"YC_NOME"))+ENTER
ENDIF

TMP->ORDEM     := TMP->TMP_ORIGEM
TMP->COD_NALAD := TRANSFORM(TMP->EE9_NALSH,AVSX3("EE9_NALSH",AV_PICTURE))
TMP->DESCRICAO := cDescFam + TMP->TMP_DSCMEM
TMP->PESO_QTDE := PADL(ALLTRIM(TRANSFORM(TMP->TMP_PLQTDE,cPICTPESO)) ,nLencol4," ")
TMP->VALOR_FOB := PADL(ALLTRIM(TRANSFORM(TMP->TMP_VALFOB,cPICTPRECO)),nLencol5," ")

RETURN(NIL)

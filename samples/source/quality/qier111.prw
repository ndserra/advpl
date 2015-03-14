#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 03/12/99
#INCLUDE "QIER111.CH"

User Function qier111()        // incluido pelo assistente de conversao do AP5 IDE em 03/12/99

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("LI,")

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ QIER111  ¦ Autor ¦ Marcelo Pimentel      ¦ Data ¦ 27.05.98 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Listagem das Formulas do IQF                               ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦ QIER110 - RDMAKE                                           ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
Li:= PARAMIXB[1]
@  Li,002 PSAY STR0001	// "FORMULAS DO IQF :"
Li:=Li+1
@Li,002 PSAY STR0002	// "IQI : IQP * FC"
Li:=Li+1
@Li,002 PSAY STR0003	// "IQP : ( 100 - K ) - Fator de Criticidade"
Li:=Li+1
@Li,002 PSAY STR0004	// "IA  : ((Fator1 * q1 + Fator2 * q2 + Fator3 * q3) / (q1 + q2 + q3)) * 100"
Li:=Li+1
@Li,002 PSAY STR0005	// "      Sendo FC.: Fator de Correcao, tabulado em funcao do IQS"
Li:=Li+1
@Li,002 PSAY STR0006	// "            K..: Qtde. obtida em funcao do Indice de Aceitacao (IA)"
Li:=Li+1
@Li,002 PSAY STR0007	// "            qx.: Quantidade entregue com o Fator x."
Li:=Li+2

If Li > 58
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,cTamanho,GetMV("MV_COMP"))
	@Li,00  PSAY REPLICATE("*",132)
	Li:=Li+2
EndIf

@Li,002 PSAY STR0008	// "IES : IPO"
Li:=Li+1
@Li,002 PSAY STR0009+Str(GetMV("MV_QDIAIPO"))+; // "IPO : ( 1 - (Somatoria Ni * Di / ("
					STR0010	// " * Nt)) ) * 100"	
Li:=Li+1
@Li,002 PSAY STR0011	// "      Sendo Ni: Quantidade entregue em atraso (lote a lote)"
Li:=Li+1
@Li,002 PSAY STR0012	// "            Di: Numero de dias em atraso (lote a lote)"
Li:=Li+1
@Li,002 PSAY STR0013	// "            Nt: Quantidade total entregue no mes"
Li:=Li+1
@Li,002 PSAY STR0014	// "           Obs: No Calculo do IPO, se o nr. de dias em atraso real for maior que o nr."
Li:=Li+1
@Li,002 PSAY STR0015	// "                dias definido no parametro MV_QDIAIPO, sera utilizado este ultimo."
Li:=Li+2
// Substituido pelo assistente de conversao do AP5 IDE em 03/12/99 ==> __Return({LI})
Return({LI})        // incluido pelo assistente de conversao do AP5 IDE em 03/12/99

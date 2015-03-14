#Include "GPECR01.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao    ³ GPECR010 ³ Autor ³ Advanced RH              ³ Data ³ 17/05/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao ³ Calculo de dissidio retroativo.							      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe   ³ GPECR010()													  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ Especifico.													  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³			ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Programador ³ Data   ³ BOPS ³             Motivo da alteracao             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Desenv-RH   ³19/07/01³------³Colocar parametros: filial, centro de custo, ³±±
±±³-------------³--------³------³matricula e nome (De/Ate) na rotina  de  im- ³±±
±±³-------------³--------³------³pressao e gravacao. Verificar  totalizadores ³±±
±±³-------------³--------³------³na rotina de impressao e posicionar resgistro³±±
±±³-------------³--------³------³original no browse apos impressao e gravacao ³±±
±±³Emerson      ³25/09/01³------³Verificar se o arquivo do dissidio criado em ³±±
±±³             ³        ³------³disco esta de acordo com a nova estrutura.   ³±±
±±³Priscila     ³09/01/03³------³Alteracao p/ filtrar os dados na Geracao de  ³±±
±±³             ³        ³------³acordo com os parametros selecionados.       ³±±
±±³Andreia      ³25/07/03³------³Alteracao para calcular as diferencas das ver³±±
±±³             ³        ³------³bas fazendo o recalculo da folha, a partir   ³±±
±±³             ³        ³------³dos arquivos de fechamento, e atualizando o  ³±±
±±³             ³        ³------³historico salarial na geracao dos lancamentos³±±
±±³             ³        ³------³futuros, valores mensais ou valores extras.  ³±±
±±³Desenv-RH    ³02/09/04³------³Acerto dDataBase qdo usuario utiliza 4 digito³±±
±±³             ³        ³------³na data                                      ³±±
±±³Desenv-RH    ³18/11/04³------³Retirada nTotal  - Total a Pagar             ³±±
±±³Emerson      ³24/11/04³------³Ajuste na geracao dos valores p/ a folha, nos³±±
±±³             ³        ³------³casos de transferencia entre C. de Custo, nao³±±
±±³             ³        ³------³estava totalizando os valores para pagto.    ³±±
±±³Ricardo D.   ³27/12/04³------³Ajuste na pesquisa de salarios no SR3 pois   ³±±
±±³             ³        ³------³nao estava buscando corretamente o salario.  ³±±
±±³Ricardo D.   ³27/12/04³077386³Incluido parametro MV_GPECR01 para informar  ³±±
±±³             ³        ³------³os tipos de aumento que serao desconsiderados³±±
±±³Ricardo D.   ³28/01/05³FNC173³Incluida validacao p/permitir que o usuario  ³±±
±±³             ³        ³------³informe o mes entre 01 e 12 somente.         ³±±
±±³Emerson      ³03/02/05³------³Destravar registro do SRC - MsUnLock.        ³±±
±±³Emerson      ³17/02/05³078019³Inverter texto "% Aum" e "Mes/Ano" no relat. ³±±
±±³Ricardo D.   ³22/02/05³071672³Incluida a funcionalidade para proporcionali-³±±
±±³             ³        ³------³zar o aumento aos meses trabalhados e para   ³±±
±±³             ³        ³------³informar a data de admissao de/ate nas faixas³±±
±±³             ³        ³------³de aumento salarial por dissidio retroativo. ³±±
±±³Emerson      ³01/03/05³079300³Gravar dissidio somente se indice > 0.       ³±±
±±³Ricardo D.   ³25/04/05³080976³Ajuste na busca dos salarios dos meses passa-³±±
±±³             ³        ³------³dos e retirado tratamento do param.MV_GPECR01³±±
±±³             ³        ³------³Ajuste na coordenadas da janela e getdados.  ³±±
±±³Andreia S.   ³27/07/05³083788³Ajuste para respeitar os indices de reajuste ³±±
±±³             ³        ³------³quando e selecionada a opcao de indice mensal³±±
±±³Emerson G.R. ³12/08/05³085106³Permitir calculo do dissidio tambem em valor.³±±
±±³Andreia S.   ³24/08/05³085118³Utilizar o campo R3_ANTEAUM quando ele exis -³±±
±±³             ³        ³------³tir no historico de salarios e estiver com   ³±±
±±³             ³        ³------³valor.                                       ³±±
±±³Andreia S.   ³06/10/05³086496³Ajuste na busca do salario no SR3 para so con³±±
±±³             ³        ³------³siderar o maior valor a partir de julho/94,  ³±±
±±³             ³        ³------³quando entrou em vigor o Plano Real.         ³±±
±±³Andreia S.   ³06/10/05³Fnc   ³Verificacao se as datas de inicio e fim do   ³±±
±±³             ³        ³3148/ ³periodo estao preenchidas. Se estiverem em   ³±±
±±³             ³        ³2005  ³branco, da aviso e nao deixa prosseguir.     ³±±
±±³R.H.         ³01/11/05³081018³Acerto na montagem  do indice                ³±±
±±³             ³        ³      ³Inclusao da opcao de exclusao -opcao Menu    ³±±
±±³             ³        ³      ³Apos efetuado o calculo eh possivel recalcu- ³±±
±±³             ³        ³      ³lar o dissidio sem  que os anteriores sejam  ³±±
±±³             ³        ³      ³excluidos automaticamente- usuario pode optar³±±
±±³             ³        ³      ³entre excluir anteriores ou nao              ³±±
±±³R.H.         ³11/11/05³081018³Acerto na montagem  do indice                ³±±
±±³R.H.         ³23/11/05³088787³Passamos a tratar o calculo do dissidio retro³±±
±±³             ³        ³      ³ativo como uma funcao padrao do SIGAGPE.     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/
#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 13/09/00

User Function GPECR01()

GPEM690()

Return
#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/11/99
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function Boleto()        // incluido pelo assistente de conversao do AP5 IDE em 19/11/99

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_NTROCO,_LCVALE,_CVALE,CBTXT,CBCONT,NORDEM")
SetPrvt("ALFA,Z,M,NOMEPROG,NLASTKEY,LCONTINUA")
SetPrvt("NLIN,_LTROCA,I,CROT,CTIPO,MV_PAR01")
SetPrvt("MV_PAR02,MV_PAR03,NTAMNF,CSTRING,CPEDANT,NLININI")
SetPrvt("XNUM_NF,XSERIE,XEMISSAO,XTOT_FAT,XLOJA,XFRETE")
SetPrvt("XSEGURO,XBASE_ICMS,XBASE_IPI,XVALOR_ICMS,XICMS_RET,XVALOR_IPI")
SetPrvt("XVALOR_MERC,XDESC_TOT,XVALOR_BRUT,XNUM_DUPLIC,XCOND_PAG,XPBRUTO")
SetPrvt("XPLIQUI,XTIPO,XVALISS,XCLIENTE,XTIPO_CLI,XCONDPAG")
SetPrvt("CPEDATU,CITEMATU,XPED_VEND,XITEM_PED,XNUM_NFDV,XPREF_DV")
SetPrvt("XICMS,XCOD_PRO,XQTD_PRO,XPRE_UNI,XPRE_TAB,XIPI")
SetPrvt("XVAL_IPI,XDESC,XVAL_DESC,XVAL_MERC,XTES,XCF")
SetPrvt("XICMSOL,XICM_PROD,XPESO_PRO,XPESO_UNIT,XDESCRICAO,XUNID_PRO")
SetPrvt("XCOD_TRIB,XMEN_TRIB,XCOD_FIS,XCLAS_FIS,XMEN_POS,XISS")
SetPrvt("XTIPO_PRO,XLUCRO,XCLFISCAL,XPESO_LIQ,AAUX,AAUXSER")
SetPrvt("XDESC_PAG,XCODVENDE,XVENDEDOR,XCOD_VEND,J,XCOD_CLI")
SetPrvt("XNOME_CLI,XEND_CLI,XBAIRRO,XCEP_CLI,XCOB_CLI,XMUN_CLI")
SetPrvt("XEST_CLI,XCGC_CLI,XINSC_CLI,XTRAN_CLI,XTEL_CLI,XFAX_CLI")
SetPrvt("XSUFRAMA,XCALCSUF,XRG,ZFRANCA,XREC_CLI,XBSICMRET")
SetPrvt("XPARC_DUP,XVENC_DUP,XVALOR_DUP,XCARTAO,XCARTAOP,XCHEQUE")
SetPrvt("XCHEQUEP,XDINHEIRO,XVALE,XVCARTAO,XVCARTAOP,XVCHEQUE")
SetPrvt("XVCHEQUEP,XVDINHEIRO,XVVALE,XDUPLICATAS,XNOME_EMP,XEND_EMP")
SetPrvt("XCID_EMP,XEST_EMP,XCGC_EMP,XINSC_EMP,NTAMDET,NQTDE")
SetPrvt("NCOL,NAJUSTE,BB,")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 19/11/99 ==> 	#DEFINE PSAY SAY
#ENDIF
/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ BOLETO   ¦ Autor ¦    Fábio F. Pessoa    ¦ Data ¦ 22/03/99 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ CUPOM DE VENDA                                             ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Especifico para Clientes Microsiga                         ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

//+--------------------------------------------------------------+
//¦ Define Variaveis Ambientais                                  ¦
//+--------------------------------------------------------------+
//+--------------------------------------------------------------+
//¦ Variaveis utilizadas para parametros                         ¦
//¦ mv_par01             // Da Nota Fiscal                       ¦
//¦ mv_par02             // Ate a Nota Fiscal                    ¦
//¦ mv_par03             // Da Serie                             ¦
//+--------------------------------------------------------------+

_nTroco   := ParamIxb[1]

_lCVale:= .F.
_cVale := ""
CbTxt:=""
CbCont:=""
nOrdem :=0
Alfa := 0
Z:=0
M:=0
nomeprog:="BOLETO"
nLastKey:= 0
lContinua := .T.
nLin:=0
_lTroca  := .F.

i := 0
cRot := UPPER(AllTrim(ProcName(i)))
While !Empty(cRot)
    If cRot $ "LOJA010_LOJA220_LOJR110_LOJA020"
		Exit
	Else
		i := i + 1
		cRot := UPPER(AllTrim(ProcName(i)))
	Endif
EndDo

_lTroca := (cRot == "LOJA020")

If cRot!="LOJR110" // Se for diferente da reemissao
	If cRot $ "LOJA010_LOJA220" // Atendimento/Venda Rapida/SAIDA DE MATERIAIS
		cTipo := "N"
	Endif
	If cTipo == "D"
		MV_PAR01:=SF2->F2_DOC
		MV_PAR02:=SF2->F2_DOC
		MV_PAR03:=SF2->F2_SERIE
	Else
		MV_PAR01:=SL1->L1_DOC
		MV_PAR02:=SL1->L1_DOC
		MV_PAR03:=SL1->L1_SERIE
	Endif
Else
	mv_par03 := mv_par02
	mv_par02 := mv_par01
Endif

If _lTroca
    Set Device To Screen
    Return
Endif

//#IFDEF WINDOWS
//	initprint()
//#ENDIF
//+-----------------------------------------------------------+
//¦ Tamanho                                                   |
//+-----------------------------------------------------------+
nTamNf:=81     // Apenas Informativo
//+-------------------------------------------------------------------------+
//¦ Verifica as perguntas selecionadas, busca o padrao da Nfiscal           ¦
//+-------------------------------------------------------------------------+
cString:="SF2"
//+--------------------------------------------------------------+
//¦ Envia controle para a funcao SETPRINT                        ¦
//+--------------------------------------------------------------+
If nLastKey == 27
	Return
Endif
//+--------------------------------------------------------------+
//¦ Inicio do Processamento da Nota Fiscal                       ¦
//+--------------------------------------------------------------+

#IFDEF WINDOWS
RptStatus({|| RptDetail()})// Substituido pelo assistente de conversao do AP5 IDE em 19/11/99 ==> RptStatus({|| Execute(RptDetail)})
Return
// Substituido pelo assistente de conversao do AP5 IDE em 19/11/99 ==> Function RptDetail
Static Function RptDetail()
#ENDIF

dbSelectArea("SF2")                // * Cabecalho da Nota Fiscal Saida
dbSetOrder(1)
dbSeek(xFilial()+mv_par01+mv_par03,.t.)

dbSelectArea("SD2")                // * Itens de Venda da Nota Fiscal
dbSetOrder(3)
dbSeek(xFilial()+mv_par01+mv_par03)
cPedant := SD2->D2_PEDIDO

//+-----------------------------------------------------------+
//¦ Inicializa  regua de impressao                            ¦
//+-----------------------------------------------------------+

dbSelectArea("SF2")
While !Eof() .And. SF2->F2_DOC <= mv_par02 .and. SF2->F2_FILIAL==xFilial() .and. lContinua 
	
	#IFNDEF WINDOWS
	IF LastKey()==286
		@ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
		lContinua := .F.
		Exit
	Endif
	#ELSE
	If lAbortPrint
		@ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
		lContinua := .F.
		Exit
	Endif
	#ENDIF
	
	nLinIni:=nLin                         // Linha Inicial da Impressao
	
	If SF2->F2_SERIE #mv_par03           // Se a Serie do Arquivo for Diferente
		DbSkip()                           // do Parametro Informado !!!
		Loop
	Endif
	//+--------------------------------------------------------------+
	//¦ Inicio de Levantamento dos Dados da Nota Fiscal              ¦
	//+--------------------------------------------------------------+
	// * Cabecalho da Nota Fiscal
	
	xNUM_NF     :=SF2->F2_DOC             // Numero
	xSERIE      :=SF2->F2_SERIE           // Serie
	xEMISSAO    :=SF2->F2_EMISSAO         // Data de Emissao
	xTOT_FAT    :=SF2->F2_VALFAT          // Valor Total da Fatura
	if xTOT_FAT == 0
		xTOT_FAT := SF2->F2_VALMERC+SF2->F2_VALIPI+SF2->F2_SEGURO+SF2->F2_FRETE
	endif
	xLOJA       :=SF2->F2_LOJA            // Loja do Cliente
	xFRETE      :=SF2->F2_FRETE           // Frete
	xSEGURO     :=SF2->F2_SEGURO          // Seguro
	xBASE_ICMS  :=SF2->F2_BASEICM         // Base   do ICMS
	xBASE_IPI   :=SF2->F2_BASEIPI         // Base   do IPI
	xVALOR_ICMS :=SF2->F2_VALICM          // Valor  do ICMS
	xICMS_RET   :=SF2->F2_ICMSRET         // Valor  do ICMS Retido
	xVALOR_IPI  :=SF2->F2_VALIPI          // Valor  do IPI
	xVALOR_MERC :=SF2->F2_VALMERC         // Valor  da Mercadoria
	xDESC_TOT   :=SF2->F2_DESCONT	
	xVALOR_BRUT :=SF2->F2_VALBRUT         // Valor Bruto
	xNUM_DUPLIC :=SF2->F2_DUPL            // Numero da Duplicata
	xCOND_PAG   :=SF2->F2_COND            // Condicao de Pagamento
	xPBRUTO     :=SF2->F2_PBRUTO          // Peso Bruto
	xPLIQUI     :=SF2->F2_PLIQUI          // Peso Liquido
	xTIPO       :=SF2->F2_TIPO            // Tipo do Cliente
	xVALISS     :=SF2->F2_VALISS          // VALOR DO ISS
   xCLIENTE    :=SF2->F2_CLIENTE         // Codigo do Cliente
   xTIPO_CLI   :=SF2->F2_TIPOCLI         // Tipo de Cliente
   xCONDPAG    :=SF2->F2_COND            // Condicao de Pagamento
    
	dbSelectArea("SD2")                   // * Itens de Venda da N.F.
	dbSetOrder(3)
	dbSeek(xFilial()+xNUM_NF+xSERIE)
	
	cPedAtu := SD2->D2_PEDIDO
	cItemAtu := SD2->D2_ITEMPV
	
	xPED_VEND:={}                         // Numero do Pedido de Venda
	xITEM_PED:={}                         // Numero do Item do Pedido de Venda
	xNUM_NFDV:={}                         // nUMERO QUANDO HOUVER DEVOLUCAO
	xPREF_DV :={}                         // Serie  quando houver devolucao
	xICMS    :={}                         // Porcentagem do ICMS
	xCOD_PRO :={}                         // Codigo  do Produto
	xQTD_PRO :={}                         // Peso/Quantidade do Produto
	xPRE_UNI :={}                         // Preco Unitario de Venda
	xPRE_TAB :={}                         // Preco Unitario de Tabela
	xIPI     :={}                         // Porcentagem do IPI
	xVAL_IPI :={}                         // Valor do IPI
	xDESC    :={}                         // Desconto por Item
	xVAL_DESC:={}                         // Valor do Desconto
	xVAL_MERC:={}                         // Valor da Mercadoria
	xTES     :={}                         // TES
	xCF      :={}                         // Classificacao quanto natureza da Operacao
	xICMSOL  :={}                         // Base do ICMS Solidario
	xICM_PROD:={}                         // ICMS do Produto
	
	While !Eof() .and. SD2->D2_DOC==xNUM_NF .and. SD2->D2_SERIE==xSERIE
		AADD(xPED_VEND ,SD2->D2_PEDIDO)
		AADD(xITEM_PED ,SD2->D2_ITEMPV)
		AADD(xNUM_NFDV ,IIF(Empty(SD2->D2_NFORI),"",SD2->D2_NFORI))
		AADD(xPREF_DV  ,SD2->D2_SERIORI)
		AADD(xICMS     ,IIf(Empty(SD2->D2_PICM),0,SD2->D2_PICM))
		AADD(xCOD_PRO  ,SD2->D2_COD)
		AADD(xQTD_PRO  ,SD2->D2_QUANT)     // Guarda as quant. da NF
		AADD(xPRE_UNI  ,SD2->D2_PRCVEN)
		AADD(xPRE_TAB  ,SD2->D2_PRUNIT)
		AADD(xIPI      ,IIF(Empty(SD2->D2_IPI),0,SD2->D2_IPI))
		AADD(xVAL_IPI  ,SD2->D2_VALIPI)
		AADD(xDESC     ,SD2->D2_DESC)
		AADD(xVAL_MERC ,SD2->D2_TOTAL)
		AADD(xTES      ,SD2->D2_TES)
		AADD(xCF       ,SD2->D2_CF)
		AADD(xICM_PROD ,IIf(Empty(SD2->D2_PICM),0,SD2->D2_PICM))
		dbskip()
	End
	
	dbSelectArea("SB1")                     // * Desc. Generica do Produto
	dbSetOrder(1)
	xPESO_PRO  :={}                         // Peso Liquido
	xPESO_UNIT :={}                         // Peso Unitario do Produto
	xDESCRICAO :={}                         // Descricao do Produto
	xUNID_PRO  :={}                         // Unidade do Produto
	xCOD_TRIB  :={}                         // Codigo de Tributacao
	xMEN_TRIB  :={}                         // Mensagens de Tributacao
	xCOD_FIS   :={}                         // Cogigo Fiscal
	xCLAS_FIS  :={}                         // Classificacao Fiscal
	xMEN_POS   :={}                         // Mensagem da Posicao IPI
	xISS       :={}                         // Aliquota de ISS
	xTIPO_PRO  :={}                         // Tipo do Produto
	xLUCRO     :={}                         // Margem de Lucro p/ ICMS Solidario
	xCLFISCAL  :={}
	xPESO_LIQ  := 0
	aAux       :={}
	aAuxSer    :={}
	
	I:=1
	
	For I:=1 to Len(xCOD_PRO)
		
		dbSeek(xFilial()+xCOD_PRO[I])
		AADD(xPESO_PRO ,SB1->B1_PESO * xQTD_PRO[I])
		AADD(xPESO_UNIT , SB1->B1_PESO)
		AADD(xUNID_PRO ,SB1->B1_UM)
		AADD(xDESCRICAO ,SB1->B1_DESC)
		AADD(xCOD_TRIB ,SB1->B1_ORIGEM)
		If Ascan(xMEN_TRIB, SB1->B1_ORIGEM)==0
			AADD(xMEN_TRIB ,SB1->B1_ORIGEM)
		Endif
		
		AADD(xISS ,SB1->B1_ALIQISS)
		
		If SB1->B1_ALIQISS == 0
			AADD(aAux    , I)
		Endif
		
		AADD(xTIPO_PRO ,SB1->B1_TIPO)
		AADD(xLUCRO    ,SB1->B1_PICMRET)
		
	Next
	
	//+---------------------------------------------+
	//¦ Pesquisa da Condicao de Pagto               ¦
	//+---------------------------------------------+
	
	dbSelectArea("SE4")                    // Condicao de Pagamento
	dbSetOrder(1)
	dbSeek(xFilial("SE4")+xCONDPAG)
	xDESC_PAG := SE4->E4_DESCRI

	dbSelectArea("SL1")                   // * Cadastro de Vendedores
	dbSetOrder(1)

	dbSelectArea("SA3")                   // * Cadastro de Vendedores
	dbSetOrder(1)
	xCODVENDE:={}
	xVENDEDOR:={}                         // Nome do Vendedor
	xCOD_VEND:=SL1->L1_VEND
	I:=1
	J:=Len(xCOD_VEND)
	For I:=1 to J
		dbSeek(xFilial()+xCOD_VEND)
		AADD(xVENDEDOR,SA3->A3_NREDUZ)
		AADD(xCODVENDE,SA3->A3_COD)
	Next

	If xTIPO=='N' .OR. xTIPO=='C' .OR. xTIPO=='P' .OR. xTIPO=='I' .OR. xTIPO=='S' .OR. xTIPO=='T' .OR. xTIPO=='O'
		
		dbSelectArea("SA1")                // * Cadastro de Clientes
		dbSetOrder(1)
		dbSeek(xFilial()+xCLIENTE+xLOJA)
        
		xCOD_CLI :=SA1->A1_COD             // Codigo do Cliente
		xNOME_CLI:=SA1->A1_NOME            // Nome
		xEND_CLI :=SA1->A1_END             // Endereco
		xBAIRRO  :=SA1->A1_BAIRRO          // Bairro
		xCEP_CLI :=SA1->A1_CEP             // CEP
		xCOB_CLI :=SA1->A1_ENDCOB          // Endereco de Cobranca
		xMUN_CLI :=SA1->A1_MUN             // Municipio
		xEST_CLI :=SA1->A1_EST             // Estado
		xCGC_CLI :=SA1->A1_CGC             // CGC
		xINSC_CLI:=SA1->A1_INSCR           // Inscricao estadual
		xTRAN_CLI:=SA1->A1_TRANSP          // Transportadora
		xTEL_CLI :=SA1->A1_TEL             // Telefone
		xFAX_CLI :=SA1->A1_FAX             // Fax
		xSUFRAMA :=SA1->A1_SUFRAMA         // Codigo Suframa
		xCALCSUF :=SA1->A1_CALCSUF         // Calcula Suframa
		xRG      :=SA1->A1_RG              // Rg do Cliente
		// Alteracao p/ Calculo de Suframa
		if !empty(xSUFRAMA) .and. xCALCSUF =="S"
			IF XTIPO == 'D' .OR. XTIPO == 'B'
				zFranca := .F.
			else
				zFranca := .T.
			endif
		Else
			zfranca:= .F.
		endif
		
	Else
		zFranca:=.F.
		dbSelectArea("SA2")                // * Cadastro de Fornecedores
		dbSetOrder(1)
		dbSeek(xFilial()+xCLIENTE+xLOJA)
		xCOD_CLI :=SA2->A2_COD             // Codigo do Fornecedor
		xNOME_CLI:=SA2->A2_NOME            // Nome Fornecedor
		xEND_CLI :=SA2->A2_END             // Endereco
		xBAIRRO  :=SA2->A2_BAIRRO          // Bairro
		xCEP_CLI :=SA2->A2_CEP             // CEP
		xCOB_CLI :=""                      // Endereco de Cobranca
		xREC_CLI :=""                      // Endereco de Entrega
		xMUN_CLI :=SA2->A2_MUN             // Municipio
		xEST_CLI :=SA2->A2_EST             // Estado
		xCGC_CLI :=SA2->A2_CGC             // CGC
		xINSC_CLI:=SA2->A2_INSCR           // Inscricao estadual
		xTRAN_CLI:=SA2->A2_TRANSP          // Transportadora
		xTEL_CLI :=SA2->A2_TEL             // Telefone
		xFAX_CLI :=SA2->A2_FAX             // Fax
	Endif

	If xICMS_RET >0                            // Apenas se ICMS Retido > 0
		dbSelectArea("SF3")                   // * Cadastro de Livros Fiscais
		dbSetOrder(4)
		dbSeek(xFilial()+SA1->A1_COD+SA1->A1_LOJA+SF2->F2_DOC+SF2->F2_SERIE)
		If Found()
			xBSICMRET:=F3_VALOBSE
		Else
			xBSICMRET:=0
		Endif
	Else
		xBSICMRET:=0
	Endif

	dbSelectArea("SE1")                   // * Contas a Receber
	dbSetOrder(1)
	xPARC_DUP  :={}                       // Parcela
	xVENC_DUP  :={}                       // Vencimento
	xVALOR_DUP :={}                       // Valor
	xCARTAO    :={}
	xCARTAOP   :={}
	xCHEQUE    :={}
	xCHEQUEP   :={}
	xDINHEIRO  :={}
	xVALE      :={}
	xVCARTAO   :={}
	xVCARTAOP  :={}
	xVCHEQUE   :={}
	xVCHEQUEP  :={}
	xVDINHEIRO :={}
	xVVALE     :={}

	xDUPLICATAS:=IIF(dbSeek(xFilial()+xSERIE+xNUM_DUPLIC,.T.),.T.,.F.) // Flag p/Impressao de Duplicatas
	
	while !eof() .and. SE1->E1_NUM==xNUM_DUPLIC .and. xDUPLICATAS==.T.

		If SE1->E1_TIPO == "CC " .AND. SE1->E1_EMISSAO == SE1->E1_VENCTO 
			AADD(xCARTAO , SE1->E1_VALOR)
			AADD(xVCARTAO , SE1->E1_VENCTO)
		ENDIF
		If SE1->E1_TIPO == "CC " .AND. SE1->E1_EMISSAO <> SE1->E1_VENCTO 
			AADD(xCARTAOP , SE1->E1_VALOR)
			AADD(xVCARTAOP , SE1->E1_VENCTO)
		ENDIF
		If SE1->E1_TIPO == "CH " .AND. SE1->E1_EMISSAO == SE1->E1_VENCTO 
			AADD(xCHEQUE , SE1->E1_VALOR)
			AADD(xVCHEQUE , SE1->E1_VENCTO)
		ENDIF
		If SE1->E1_TIPO == "CH " .AND. SE1->E1_EMISSAO <> SE1->E1_VENCTO 
			AADD(xCHEQUEP , SE1->E1_VALOR)
			AADD(xVCHEQUEP , SE1->E1_VENCTO)
		ENDIF
		If SE1->E1_TIPO == "R$ "
			AADD(xDINHEIRO , SE1->E1_VALOR + _nTroco)
			AADD(xVDINHEIRO , SE1->E1_VENCTO)
		ENDIF
		If SE1->E1_TIPO == "VA "
			AADD(xVALE , SE1->E1_VALOR)
			AADD(xVVALE , SE1->E1_VENCTO)
		ENDIF

		dbSkip()

	EndDo

	If (Len(xDINHEIRO) == 0)
		xVALE[1]:= xVALE[1] + _nTroco
	EndIf

	dbSelectArea("SM0")                   // * Contas a Receber
	dbSetOrder(1)	
	xNOME_EMP :=SM0->M0_NOMECOM
	xEND_EMP  :=SM0->M0_ENDCOB
	xCID_EMP  :=SM0->M0_CIDCOB
	xEST_EMP  :=SM0->M0_ESTCOB 
	xCGC_EMP  :=SM0->M0_CGC 
	xINSC_EMP :=SM0->M0_INSC
	
	Imprime()
	//+--------------------------------------------------------------+
	//¦ Termino da Impressao da Nota Fiscal                          ¦
	//+--------------------------------------------------------------+
	
	nLin:=0
	dbSelectArea("SF2")     //
	dbSkip()                // passa para a proxima Nota Fiscal
	
EndDo
//+--------------------------------------------------------------+
//¦                      FIM DA IMPRESSAO                        ¦
//+--------------------------------------------------------------+
//+--------------------------------------------------------------+
//¦ Fechamento do Programa da Nota Fiscal                        ¦
//+--------------------------------------------------------------+

dbSelectArea("SF2")
Retindex("SF2")
dbSelectArea("SD2")
Retindex("SD2")
Set Device To Screen

//+--------------------------------------------------------------+
//¦ Fim do Programa                                              ¦
//+--------------------------------------------------------------+
//+--------------------------------------------------------------+
//¦                   FUNCOES ESPECIFICAS                        ¦
//+--------------------------------------------------------------+
/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ IMPDET   ¦ Autor ¦     THIAGO IURATO     ¦ Data ¦ 04/09/97 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Impressao de Linhas de Detalhe da Nota Fiscal              ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ INFO STORE                                                 ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/


Return(nil)        // incluido pelo assistente de conversao do AP5 IDE em 19/11/99

// Substituido pelo assistente de conversao do AP5 IDE em 19/11/99 ==> Function IMPDET
Static Function IMPDET()

nTamDet :=30           // Tamanho da Area de Detalhe

I:=1
J:=1

nQTDE := 0

For I:=1 to nTamDet
	If I<=Len(xCOD_PRO)                                 // Len(xCOD_PRO)
			@ nLin, 000  PSAY xCOD_PRO[I] 
			@ nLin, 010  PSAY xDESCRICAO[I]
			nLin := nLin + 1
			@ nLin, 001  PSAY xQTD_PRO[I]               PICTURE "@E 999,999"
			@ nLin, 013  PSAY xPRE_TAB[I]               PICTURE "@E 99,999,999.99"
			@ nLin, 022  PSAY (xQTD_PRO[I] * xPRE_TAB[I])   PICTURE "@E 99,999,999.99"
			nQTDE := nQTDE + xQTD_PRO[I]
			J:=J+1
			nLin :=nLin+1	
	Endif
Next

Return

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ DUPLIC   ¦ Autor ¦     THIAGO IURATO     ¦ Data ¦ 04/09/97 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Impressao do Parcelamento das Duplicacatas                 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ INFO STORE                                                 ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 19/11/99 ==> Function DUPLIC
Static Function DUPLIC()
nCol := 13
nAjuste := 0
For BB:= 1 to Len(xVALOR_DUP)
	If xDUPLICATAS == .T. .and. BB<=Len(xVALOR_DUP) .And. BB <= 3
		IF xCONDPAG == "001"
			@ nLin, nCol +      nAjuste PSAY "A VISTA"
		ELSEIF xCONDPAG == "022"
			@ nLin, nCol +      nAjuste PSAY "C/APRES."
		ELSE
			@ nLin, nCol +      nAjuste PSAY xVENC_DUP[BB]
			@ nLin, nCol + 18 + nAjuste PSAY xVALOR_DUP[BB] PICTURE ("@E 9,999,999.99")
			nAjuste := nAjuste + 43	
		ENDIF
	Endif
Next

Return
/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ IMPRIME  ¦ Autor ¦     THIAGO IURATO     ¦ Data ¦ 04/09/97 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Imprime a Nota Fiscal Saida                                ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Generico RDMAKE                                            ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 19/11/99 ==> Function Imprime
Static Function Imprime()

nLin:=0
@ nLin, 000 PSAY Chr(15)                   // Compressao de Impressao
@ nLin, 000 PSAY xNOME_EMP
nLin := nLin + 1
@ nLin, 000 PSAY xEND_EMP
nLin := nLin + 1
@ nLin, 000 PSAY xCID_EMP  + " - " + xEST_EMP
nLin := nLin + 1
@ nLin, 000 PSAY "C.G.C. :"
@ nLin, 010 PSAY xCGC_EMP PICTURE "@R 99.999.999/9999-99"
@ nLin, 030 PSAY "IE.: " + xINSC_EMP
nLin := nLin + 2
@ nLin, 011 PSAY "NUMERO DA COMANDA : " + xNUM_NF      // Numero da Nota Fiscal
nLin := nLin + 2
@ nLin, 000 PSAY "OPERADOR.: " + SUBSTR(CUSUARIO, 7,15)
@ nLin, 030 PSAY "DATA : " + DTOC(DDATABASE)
nLin := nLin + 1
@ nLin, 000 PSAY "CLIENTE..: " + xCOD_CLI + " - " + ALLTRIM(xNOME_CLI)         //Nome do Cliente
nLin := nLin + 1
@ nLin, 000 PSAY "VENDEDOR.: " + ALLTRIM(xCODVENDE[1])+" - "+ALLTRIM(xVENDEDOR[1])
//+-------------------------------------+
//¦ Dados dos Produtos Vendidos         ¦
//+-------------------------------------+

nLin := nLin + 2
@ nLin, 000 PSAY "-----------------------------------------------"
nLin := nLin + 1
@ nLin, 000 PSAY "CODIGO   DESCRICAO"
nLin := nLin + 1
@ nLin, 000 PSAY "      QTD      PRECO UNIT.    TOTAL  "
nLin := nLin + 1
@ nLin, 000 PSAY "-----------------------------------------------"
nLin := nLin + 2

ImpDet()                // Detalhe da NF

nLin := nLin + 1
@ nLin, 000 PSAY "TOTAL DE PECAS VENDIDAS:"
@ nLin, 031 PSAY nQTDE
nLin := nLin + 1
@ nLin, 000  PSAY "TOTAL MERCADORIA.......:" 
@ nLin, 027  PSAY xVALOR_BRUT  PICTURE "@E 999,999,999.99"  // Valor Tot. Prod.
nLin := nLin + 1
@ nLin, 000  PSAY "DESCONTO...............:"
@ nLin, 027  PSAY xDESC_TOT    PICTURE "@E 999,999,999.99"  
nLin := nLin + 1
@ nLin, 000 PSAY "TOTAL GERAL............:"
@ nLin, 027  PSAY xVALOR_MERC    PICTURE "@E 999,999,999.99"  
nLin := nLin + 2
//@ nLin, 000 PSAY "PAGAMENTO EM:"
//@ nLin, 015  PSAY xDESC_PAG      

If Len(xDINHEIRO) > 0
	FOR i := 1 TO LEN(xDINHEIRO)
		@ nLin, 000 PSAY xVDINHEIRO[i]
		@ nLin, 010 PSAY " - " + "DINHEIRO"
		@ nLin, 027 PSAY xDINHEIRO[i] PICTURE "@E 999,999,999.99"  
		nLin := nLin + 1
	NEXT
Endif
If Len(xCARTAO) > 0
	For i := 1 TO Len(xCARTAO)
		@ nLin, 000 PSAY xVCARTAO[i] 
		@ nLin, 010 PSAY " - " + "CARTAO"
		@ nLin, 027 PSAY xCARTAO[i]	 PICTURE "@E 999,999,999.99"  
		nLin := nLin + 1
	NEXT
Endif
If Len(xCARTAOP) > 0
	For i := 1 TO Len(xCARTAOP)
		@ nLin, 000 PSAY xVCARTAOP[i] 
		@ nLin, 010 PSAY " - " + "CARTAO PRE"
		@ nLin, 027 PSAY xCARTAOP[i]  PICTURE "@E 999,999,999.99"  
		nLin := nLin + 1
	NEXT	
Endif
If Len(xCHEQUE) > 0
	For i := 1 TO LEN(xCHEQUE)
		@ nLin, 000 PSAY xVCHEQUE[i] 
		@ nLin, 010 PSAY " - " + "CHEQUE"
		@ nLin, 027 PSAY xCHEQUE[i]  PICTURE "@E 999,999,999.99"  
		nLin := nLin + 1
	NEXT
EndiF
If Len(xCHEQUEP) > 0
	For i := 1 TO LEN(xCHEQUEP)
		@ nLin, 000 PSAY xVCHEQUEP[i]
		@ nLin, 010 PSAY " - " + "CHEQUE PRE"
		@ nLin, 027 PSAY xCHEQUEP[i]  PICTURE "@E 999,999,999.99"  
		nLin := nLin + 1
	NEXT
EndiF
If Len(xVALE) > 0
	FOR i := 1 TO LEN(xVALE)
		@ nLin, 000 PSAY xVVALE[i]	
		@ nLin, 010 PSAY " - " + "VALE"
		@ nLin, 027 PSAY xVALE[i]  PICTURE "@E 999,999,999.99"  
		nLin := nLin + 1
	NEXT
Endif

If _nTroco > 0
	@ nLin, 000 PSAY "TROCO"
	@ nLin, 027 PSAY _nTroco  PICTURE "@E 999,999,999.99"  
Endif

nLin := nLin + 2
@ nLin, 010 PSAY "Obrigado. Volte Sempre !!!"

@ nLin, 000 PSAY chr(18)                   // Descompressao de Impressao
nLin := nLin + 5
@ nLin, 000 PSAY " "

_lCVale:= GetMV("MV_CVALE")

If (_lCVale) .And. (Len(xDINHEIRO) == 0) .And. (_nTroco > 0)

	_cVale:= "Valor : " + Space(15) + "(" + Repl("*",14 - Len(AllTrim(Str(_nTroco)))) + AllTrim(Str(_nTroco)) + ")" 

	@ nLin, 010 PSAY xNOME_EMP
	nLin := nLin + 1

	@ nLin, 000 PSAY Chr(15)              							       // Compressao de Impressao
	@ nLin, 016 PSAY xEND_EMP
	nLin := nLin + 1

	@ nLin, 016 PSAY AllTrim(xCID_EMP) + " - " + xEST_EMP
	nLin := nLin + 1

	@ nLin, 000 PSAY "C.G.C. :"
	@ nLin, 010 PSAY xCGC_EMP PICTURE "@R 99.999.999/9999-99"
	@ nLin, 030 PSAY "IE.: " + xINSC_EMP
	nLin := nLin + 1

	@ nLin, 000 PSAY Dtoc(MSDate()) + Space(3) + SubStr(Time(),1,5) 
	nLin := nLin + 1

	@ nLin, 000 PSAY "Loja: " + SM0->M0_CODFIL + "   Operador : " + SubStr(cUsuario,7,15) 
	nLin := nLin + 2

	@ nLin, 000 PSAY Space(12) + "*** CONTRA VALE *** " 
	nLin := nLin + 2

	@ nLin, 000 PSAY Repl("-",48) 
	nLin := nLin + 1

	@ nLin, 000 PSAY _cVale
	nLin := nLin + 1

	@ nLin, 000 PSAY Repl("-",48)
	nLin := nLin + 1

	@ nLin, 000 PSAY chr(18)                   // Descompressao de Impressao

	nLin := nLin + 10
	@ nLin, 000 PSAY " "
	
EndIf

SetPrc(0,0)                             // (Zera o Formulario)
MS_FLUSH()
Return .T.

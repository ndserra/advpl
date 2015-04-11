#Include 'Protheus.ch'
#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'

User Function tReport2_secao()
	Local oReport := nil
	Local cPerg:= "RELNCM"
	
	AjustaSX1(cPerg)	

	Pergunte(cPerg,.F.)	          
		
	oReport := RptDef(cPerg)
	oReport:PrintDialog()
Return()
//------------------------------------------------------------------------------------------------

Static Function RptDef(cNome)
	Local oReport := Nil
	Local oSection1:= Nil
	Local oSection2:= Nil
	Local oBreak
	Local oFunction
	
	/*Sintaxe: TReport():New(cNome,cTitulo,cPerguntas,bBlocoCodigo,cDescricao)*/
	oReport := TReport():New(cNome,"Relatório NCM x Cadastro Produtos",cNome,{|oReport| ReportPrint(oReport)},"Descrição do meu relatório")
	oReport:SetPortrait()    
	oReport:SetTotalInLine(.F.)
	
	//Monstando a primeira seção
	//Neste exemplo, a primeira seção será composta por duas colunas, código da NCM e sua descrição
	//Iremos disponibilizar para esta seção apenas a tabela SYD, pois quando você for em personalizar
	//e entrar na primeira seção, você terá todos os outros campos disponíveis, com isso, será
	//permitido a inserção dos outros campos
	//Neste exemplo, também, já deixarei definido o nome dos campos, mascara e tamanho, mas você
	//terá toda a liberdade de modificá-los via relatorio. 

	oSection1:= TRSection():New(oReport, "NCM", {"SYD"}, , .F., .T.)
	TRCell():New(oSection1,"YD_TEC"		,"TRBNCM","NCM"  		,"@!",40)
	TRCell():New(oSection1,"YD_DESC_P"  ,"TRBNCM","DESCRICAO"	,"@!",200)
	
	//A segunda seção, será apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado também a tabela de NCM, com isso, você poderia incluir os campos da tabela
	//SYD.Semelhante a seção 1, defino o titulo e tamanho das colunas

	oSection2:= TRSection():New(oReport, "Produtos", {"SB1"}, NIL, .F., .T.)
	TRCell():New(oSection2,"B1_COD"   	,"TRBNCM","Produto"		,"@!",30)
	TRCell():New(oSection2,"B1_DESC"  	,"TRBNCM","Descrição"	,"@!",100)
	TRCell():New(oSection2,"B1_LOCPAD"	,"TRBNCM","Arm.Padrao"	,"@!",20)	
	TRCell():New(oSection2,"B1_POSIPI"	,"TRBNCM","NCM"			,"@!",30)	

	TRFunction():New(oSection2:Cell("B1_COD"),NIL,"COUNT",,,,,.F.,.T.)
	
	oReport:SetTotalInLine(.F.)
       
  //Pula de pagina por quebra
//	oSection1:SetPageBreak(.T.)
	oSection1:SetTotalText("EXEMPLO DA QUEBRA")				
Return(oReport)

Static Function ReportPrint(oReport)
	Local oSection1 := oReport:Section(1)
	Local oSection2 := oReport:Section(2)	 
	Local cQuery    := ""		
	Local cNcm      := ""   
	Local lPrim 	:= .T.	      

	//Monto minha consulta conforme parametros passado
	cQuery := "	SELECT YD_TEC,YD_DESC_P,B1_COD,B1_DESC,B1_LOCPAD,B1_POSIPI,B1_IPI,YD_PER_IPI "
	cQuery += "	 FROM "+RETSQLNAME("SYD")+" SYD "
	cQuery += "	 INNER JOIN "+RETSQLNAME("SB1")+" SB1 ON SB1.D_E_L_E_T_='' AND B1_FILIAL='"+xFilial("SB1")+"' AND B1_POSIPI=YD_TEC "
	cQuery += "	 WHERE SYD.D_E_L_E_T_=' ' "
	cQuery += "	 AND YD_FILIAL='"+xFilial("SYD")+"' "
	cQuery += " AND YD_TEC >= '"+MV_PAR01+"' AND YD_TEC <= '"+MV_PAR02+"'"
	cQuery += "	 ORDER BY YD_TEC,B1_COD "
		
	memowrite("C:\sql.txt",cQuery)
		
		
	//Se o alias estiver aberto, irei fechar, isso ajuda a evitar erros
	IF Select("TRBNCM") <> 0
		TRBNCM->(DbCloseArea())
	ENDIF
	
	//crio o novo alias
	
	dbUseArea( .T.,"TOPCONN", TCGENQRY(,,cQuery),"TRBNCM"	, .F., .T.)
	
	
	
	dbSelectArea("TRBNCM")
	TRBNCM->(dbGoTop())
	
	oReport:SetMeter(TRBNCM->(LastRec()))	

	//Irei percorrer todos os meus registros
	While !Eof()
		
		If oReport:Cancel()
			Exit
		EndIf
	
		//inicializo a primeira seção
		oSection1:Init()

		oReport:IncMeter()
					
		cNcm 	:= TRBNCM->YD_TEC
		
		IncProc("Imprimindo NCM "+alltrim(TRBNCM->YD_TEC))
		
		//imprimo a primeira seção				
		oSection1:Cell("YD_TEC"):SetValue(TRBNCM->YD_TEC)
		oSection1:Cell("YD_DESC_P"):SetValue(TRBNCM->YD_DESC_P)				
	
		// Imprimindo a linha da seção 1
		oSection1:Printline()
		
		//inicializo a segunda seção 2
		oSection2:init()
		
		//verifico se o codigo da NCM é mesmo, se sim, imprimo o produto
		While TRBNCM->YD_TEC == cNcm
		
			oReport:IncMeter()		
		
			IncProc("Imprimindo produto "+alltrim(TRBNCM->B1_COD))
			oSection2:Cell("B1_COD"):SetValue(TRBNCM->B1_COD)
			oSection2:Cell("B1_DESC"):SetValue(TRBNCM->B1_DESC)
			oSection2:Cell("B1_LOCPAD"):SetValue(TRBNCM->B1_LOCPAD)			
			oSection2:Cell("B1_POSIPI"):SetValue(TRBNCM->B1_POSIPI)			
				
 			TRBNCM->(dbSkip())
 			
 		EndDo		
 		//finalizo a segunda seção para que seja reiniciada para o proximo registro
 		oSection2:Finish()
 		//imprimo uma linha para separar uma NCM de outra
 		oReport:ThinLine()
 		//finalizo a primeira seção
		oSection1:Finish()
	Enddo
	
Return

static function ajustaSx1(cPerg)
	//Aqui utilizo a função putSx1, ela cria a pergunta na tabela de perguntas
	putSx1(cPerg, "01", "NCM DE ?"	  , "", "", "mv_ch1", "C", tamSx3("B1_POSIPI")[1], 0, 0, "G", "", "SYD", "", "", "mv_par01")
	putSx1(cPerg, "02", "NCM ATE?"	  , "", "", "mv_ch2", "C", tamSx3("B1_POSIPI")[1], 0, 0, "G", "", "SYD", "", "", "mv_par02")
return
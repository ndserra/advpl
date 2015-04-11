#INCLUDE "PROTHEUS.CH"
 
                 
User Function Exp_Excel()    
 
 Local oFont2 := TFont():New("Arial",,020,,.F.,,,,,.F.,.F.)
 Local oGroup1
 Local oGet1,oGet2,oGet3,oSay1, oSay2, oSay3
 Local dDataDe  := Date()
 Local dDataAte := Date()
 Local oSButton1, oSButton2
 Local oDlg               
 

	  DEFINE MSDIALOG oDlg TITLE "Pendência da Engenharia" FROM 000, 000  TO 150, 220 COLORS 0, 16777215 PIXEL
	
	    @ 000, 001 GROUP oGroup1 TO 055, 110 OF oDlg COLOR 0, 16777215 PIXEL    
	
	    @ 014, 005 SAY oSay1 PROMPT "Data De:"  SIZE 042, 013 OF oDlg FONT oFont2 COLORS 0, 16777215 PIXEL
	    @ 012, 044 MSGET oGet1 VAR dDatade      SIZE 048, 013 OF oDlg COLORS 0, 16777215 FONT oFont2 PIXEL
	    
	    @ 035, 005 SAY oSay2 PROMPT "Data ate:" SIZE 042, 013 OF oDlg FONT oFont2 COLORS 0, 16777215 PIXEL
	    @ 033, 044 MSGET oGet2 VAR dDataAte     SIZE 048, 013 OF oDlg COLORS 0, 16777215 FONT oFont2 PIXEL
	
	    DEFINE SBUTTON oSButton1 FROM 060, 020 TYPE 01 Action FGerar( DToS( dDatade ), DToS( dDataAte ) ) OF oDlg ENABLE 
	    DEFINE SBUTTON oSButton2 FROM 060, 060 TYPE 02 Action oDlg:END()                                  OF oDlg ENABLE
	
	  ACTIVATE MSDIALOG oDlg CENTERED
	
Return( NIL )

///////////////////////////////////////////////////////////////////////////////////////////////////////

Static Function FGerar(pDatade,pDataAte)
                               
Local cAlias := GetNextAlias()
Local aQuery

	BeginSql Alias cAlias  
	
			SELECT D1_DOC     AS NF, 
			       D1_FORNECE AS Fornecedor, 
			       D1_LOJA    AS Loja, 
			       D1_Serie   AS Serie, 
			       D1_QUANT   AS QTD, 
			       D1_ITEM    AS Item 
			FROM   %TABLE:SD1%
			WHERE  D1_FILIAL =  %xFilial:SD1% 
			       AND D1_EMISSAO >=  %EXP:pDatade%
			       AND D1_EMISSAO <=  %EXP:pDataAte%
			       AND %NOTDEL%                                
	
	EndSql         

		aQuery := GetLastQuery()
		


	TcSetField( cAlias, "D1_EMISSAO"  , "D", 08, 0 )
		
	MsAguarde( { || U_fGeraXLS( "TOTVSCTT" ) }, "Aguarde ...", "Criando arquivo Notas de Entradas...", .T. )
	
	(cAlias)->( dbCloseArea() )

Return( NIL )

//---------------------------------------------------------------------------------------------------------------------


User Function fGeraXLS( pNome )

	Local lTemExcel := ApOleClient( "MsExcel" )
	Local _cDRVOpen := ""
	Local _cTemp    := ""
	Local cPath     := "C:\"

	// Define o drive correto para gerar arquivo DBF ao invés de DTC //
	// pois os arquivos DTC não abrem em Excel                       //

	If RealRDD() == "ADSSERVER"
	   _cDRVOpen := "DBFCDX"
	Else
	   If IsSrvUnix()
	      _cDRVOpen := ""
	   Else
	      _cDRVOpen := "DBFCDXADS"
	   EndIf
	EndIf
	
	// Cria Arquivo Temporario ===================================== //
	
	_cTemp := CriaTrab( NIL, .F. )

	Copy To &_cTemp VIA _cDRVOpen
	
	// ============================================================= //
	                  
	__CopyFile( _cTemp+".DBF", cPath + pNome + ".XLS" )

	fErase( _cTemp )
	
	// ============================================================= //

	If lTemExcel
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( cPath + pNome + ".XLS" )
		oExcelApp:SetVisible( .T. ) 
   EndIf
   
	MsgInfo( "Arquivo " + cPath + pNome + ".XLS, gerado com sucesso !!!", "ATENÇÃO !!!" )
	
Return( NIL )
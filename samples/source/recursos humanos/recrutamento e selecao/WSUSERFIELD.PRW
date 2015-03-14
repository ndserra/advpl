USER FUNCTION WSUSRFIELD()
Local cCursor :=  PARAMIXB[1]
Local aReturn := {}

DO CASE
   CASE cCursor == "SQG"
   		aadd(aReturn, "QG_ULTVAGA")   	//1
   		aadd(aReturn, "QG_ULTETAP")    	//2
   		aadd(aReturn, "QG_ULTDATA")    	//3
   		
   CASE cCursor == "SQL"              
   		aadd(aReturn, "QL_AREA")    	//1 		

   CASE cCursor == "SQM"              
   		aadd(aReturn, "QM_ESCOLAR")     
   		aadd(aReturn, "QM_CDCURSO")
   		
EndCase
//conout("entrou no WSUSRFIELD ")

Return( aReturn )
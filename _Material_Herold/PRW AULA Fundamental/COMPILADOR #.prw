
//----------------------------------------------------------------------------------------------------------------// 
#define BRASIL

User Function TstUDC3()

#IfDef BRASIL
   Local cPais
   Local cLingua
   cPais   := "Brasil"
   cLingua := "Portugues"
 #Else
   Local cPais
   cPais := "Argentina"
#EndIf

MsgAlert(cPais + "/" + cLingua)

Return Nil 

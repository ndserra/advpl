#Include 'Protheus.ch'

User Function PHP()

cHTML := ""

cHTML := "<html>                                   "
cHTML += " <head>                                  "
cHTML += "  <title>PHP Teste</title>               "
cHTML += " </head>                                 "
cHTML += " <body>                                  "
For x := 1 to 10
	cHTML += " <p>Olá Mundo</p>                    "
Next x	
cHTML += " </body>                                 "
cHTML += "</html>                                  "
                                                   
Return(cHTML)


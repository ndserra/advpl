User Function TstMacro()

Local cCampo
Local cCalc

dbSelectArea("SA1")
cCampo := "A1_Nome"

MsgAlert(cCampo + ": " + &cCampo)

dbSelectArea("SA2")
cCampo := "A2_Nome"

MsgAlert(cCampo + ": " + &cCampo)

cCalc := "1 + 1"

MsgAlert(cCalc + ": " + Str(&cCalc))
             
Return Nil

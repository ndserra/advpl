#INCLUDE "Protheus.ch"
#INCLUDE "RTMSR26.ch"

//-- Define aHeader do Email
#DEFINE HD_FILDES  1
#DEFINE HD_DATEMI  2
#DEFINE HD_CIDUF   3
#DEFINE HD_CLIREM  4
#DEFINE HD_FILIAL  5
#DEFINE HD_TEL     6
#DEFINE HD_DATPAR  7
#DEFINE HD_NUMVOO  8
#DEFINE HD_HORPAR  9
#DEFINE HD_HORCHG 10 
#DEFINE HD_CODCIA 11
#DEFINE HD_NUMAWB 12
#DEFINE HD_QTDVOL 13
#DEFINE HD_PESO   14
#DEFINE HD_PESOM3 15
#DEFINE HD_CODEMB 16
#DEFINE HD_DESPRO 17
#DEFINE HD_NUMNFC 18
#DEFINE HD_CLIDES 19
#DEFINE HD_CGC    20
#DEFINE HD_END    21
#DEFINE HD_CEP    22
#DEFINE HD_NOTA   23
#DEFINE HD_PRZENT 24
#DEFINE HD_OBS    25
#DEFINE HD_LACRE  26

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RTMSR26 ºAutor  ³Gustavo Almeida       º Data ³ 13/05/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Monta o corpo do email em HTML para envio de Pré-Alerta    º±±
±±º          ³ em confirmação de embarque aereo.                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP 11.5                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function RTMSR26()
Local aArea   := { SM0->(GetArea()), SA2->(GetArea()) , DVH->(GetArea()) , DTX->(GetArea()) , DUD->(GetArea()) , DT6->(GetArea()) , SA1->(GetArea()) }
Local nX      := 0
Local cBody   := ""
Local cEmail  := ""
Local cBarSrv := If( IsSrvUnix(), "/", "\" ) //Checa se o Server e Linux
Local cPath   := ""
Local aDoctos := {}
Local aNotas  := {}  
Local cMemo   := ""
Local cLacre  := ""
Local aHeader := {}
Local lCancela:= (ParamIXB[01] == 4)
Local cFilOri := ParamIXB[02]
Local cViagem := ParamIXB[03]
Local cFilOco := ParamIXB[04]
Local cNumOco := ParamIXB[05]
Local dDatPar := ParamIXB[06]
Local cHorPar := ParamIXB[07]
Local cDatChg := ParamIXB[08]
Local cHorChg := ParamIXB[09]
Local cNumVoo := ParamIXB[10]

//-- Diretorio para Salvar cópias dos pre alertas gerado
If IsSrvUnix()
	cPath := CurDir() + cBarSrv + 'prealerta' + cBarSrv
Else
	cPath := CurDir() + 'prealerta' + cBarSrv
EndIf

//-- Cria diretorio
If !ExistDir( cPath )
	If MakeDir( cPath ) <> 0
		If IsSrvUnix()
			cPath := CurDir() + cBarSrv
		Else
			cPath := CurDir() + cBarSrv
		EndIf
	EndIf
EndIf

//-- by Gustavo 

//-- Header DADOS DO EMBARQUE
AAdd( aHeader,RetTitSX3( 'DTV_FILDES' ))
AAdd( aHeader,RetTitSX3( 'DTV_DATEMI' ))
AAdd( aHeader,RetTitSX3( 'A1_MUN')+'/'+RetTitSX3( 'A1_EST' ))
AAdd( aHeader,RetTitSX3( 'DT6_CLIREM' ))
AAdd( aHeader,RetTitSX3( 'DTV_FILIAL' ))    
AAdd( aHeader,RetTitSX3( 'A2_TEL'     )) 
//-- Header DADOS DO VÔO
AAdd( aHeader,RetTitSX3( 'DVH_DATPAR' ))
AAdd( aHeader,RetTitSX3( 'DVH_NUMVOO' ))
AAdd( aHeader,RetTitSX3( 'DVH_HORPAR' ))
AAdd( aHeader,RetTitSX3( 'DVH_HORCHG' ))  
AAdd( aHeader,RetTitSX3( 'DVH_CODCIA' )) 
AAdd( aHeader,RetTitSX3( 'DTV_NUMAWB' )) 
AAdd( aHeader,RetTitSX3( 'DTV_QTDVOL' )) 
AAdd( aHeader,RetTitSX3( 'DTV_PESO'   )) 
AAdd( aHeader,RetTitSX3( 'DTV_PESOM3' ))
AAdd( aHeader,RetTitSX3( 'DTV_CODEMB' )) 
AAdd( aHeader,RetTitSX3( 'DTV_DESPRO' ))
//-- Header DADOS PARA ENTREGA DA CARGA
AAdd( aHeader,RetTitSX3( 'DTC_DOC')+'/'+RetTitSX3( 'DTC_SERIE' ))
AAdd( aHeader,RetTitSX3( 'DT6_CLIDES' )) 
AAdd( aHeader,RetTitSX3( 'A2_CGC'     )) 
AAdd( aHeader,RetTitSX3( 'A2_END'     ))
AAdd( aHeader,RetTitSX3( 'A2_CEP'     ))
AAdd( aHeader,RetTitSX3( 'C5_NOTA'    ))
AAdd( aHeader,RetTitSX3( 'DT6_PRZENT' ))
AAdd( aHeader,RetTitSX3( 'DTV_OBS'    ))
AAdd( aHeader,RetTitSX3( 'DVB_LACRE'  )) 
//-- by Gustavo

//-- Filial de Destino
SM0->(MsSeek(cEmpAnt+DTV->DTV_FILDES))

cBody += '<html xmlns:v="urn:schemas-microsoft-com:vml"                                                                                  ' 
cBody += 'xmlns:o="urn:schemas-microsoft-com:office:office"                                                                              '
cBody += 'xmlns:w="urn:schemas-microsoft-com:office:word"                                                                                '
cBody += 'xmlns:st1="urn:schemas-microsoft-com:office:smarttags"                                                                         '
cBody += 'xmlns="http://www.w3.org/TR/REC-html40"                                                                                        '
cBody += 'xmlns:ns0="urn:schemas-microsoft-com:office:smarttags" xmlns:ns1="">                                                           '
cBody += '<head>                                                                                                                         '
cBody += '<!--[if !mso]>                                                                                                                 '
cBody += '<style>                                                                                                                        '
cBody += 'v\:* {behavior:url(#default#VML);}                                                                                             '
cBody += 'o\:* {behavior:url(#default#VML);}                                                                                             '
cBody += 'w\:* {behavior:url(#default#VML);}                                                                                             '
cBody += '.shape {behavior:url(#default#VML);}                                                                                           '
cBody += '</style>                                                                                                                       '
cBody += '<![endif]--><o:SmartTagType                                                                                                    '
cBody += ' namespaceuri="urn:schemas-microsoft-com:office:smarttags"                                                                     '
cBody += ' name="metricconverter"/>                                                                                                      '
cBody += '                                                                                                                               '
cBody += '<style>                                                                                                                        '
cBody += '<!--                                                                                                                           '
cBody += ' /* Style Definitions */                                                                                                       '
cBody += ' p.MsoNormal, li.MsoNormal, div.MsoNormal                                                                                      '
cBody += '	{mso-style-parent:"";                                                                                                        '
cBody += '	margin:0cm;                                                                                                                  '
cBody += '	margin-bottom:.0001pt;                                                                                                       '
cBody += '	mso-pagination:widow-orphan;                                                                                                 '
cBody += '	font-size:12.0pt;                                                                                                            '
cBody += '	font-family:"Times New Roman";                                                                                               '
cBody += '	mso-fareast-font-family:"Times New Roman";}                                                                                  '
cBody += 'span.SpellE                                                                                                                    '
cBody += '	{mso-style-name:"";                                                                                                          '
cBody += '	mso-spl-e:yes;}                                                                                                              '
cBody += 'span.GramE                                                                                                                     '
cBody += '	{mso-style-name:"";                                                                                                          '
cBody += '	mso-gram-e:yes;}                                                                                                             '
cBody += '@page Section1                                                                                                                 '
cBody += '	{size:595.3pt 841.9pt;                                                                                                       '
cBody += '	margin:70.85pt 3.0cm 70.85pt 3.0cm;                                                                                          '
cBody += '	mso-header-margin:35.4pt;                                                                                                    '
cBody += '	mso-footer-margin:35.4pt;                                                                                                    '
cBody += '	mso-paper-source:0;}                                                                                                         '
cBody += 'div.Section1                                                                                                                   '
cBody += '	{page:Section1;}                                                                                                             '
cBody += '-->                                                                                                                            '
cBody += '</style>                                                                                                                       '
cBody += '                                                                                                                               '
cBody += '</head>                                                                                                                        '
cBody += '<body lang=PT-BR style="tab-interval:35.4pt">                                                                                  '
cBody += '<div class=Section1>                                                                                                           '
cBody += '<div>                                                                                                                          '
cBody += '<div>                                                                                                                          '
cBody += '<div>                                                                                                                          '
cBody += '<div>                                                                                                                          '
cBody += '<table class=MsoNormalTable border=0 cellspacing=0 cellpadding=0                                                               '
cBody += ' style="border-collapse:collapse;mso-padding-alt:0cm 0cm 0cm 0cm">                                                             '
cBody += ' <tr style="mso-yfti-irow:0;mso-yfti-firstrow:yes;height:36.3pt">                                                              '
cBody += '  <td width=168 colspan=2 valign=top style="width:126.35pt;border-top:solid windowtext 1.0pt;                                  '
cBody += '  border-left:solid windowtext 1.0pt;border-bottom:none;border-right:none;                                                     '
cBody += '  padding:0cm 5.4pt 0cm 5.4pt;height:36.3pt">                                                                                  '
cBody += '  <p class=MsoNormal align=center style="mso-margin-top-alt:auto;mso-margin-bottom-alt:                                        '
cBody += '  auto;text-align:center"><b style="mso-bidi-font-weight:normal"><span                                                         '
cBody += '  style="font-size:10.0pt;font-family:Arial;color:red"><!--[if gte vml 1]><v:shapetype                                         '
cBody += '   id="_x0000_t75" coordsize="21600,21600" o:spt="75" o:preferrelative="t"                                                     '
cBody += '   path="m@4@5l@4@11@9@11@9@5xe" filled="f" stroked="f">                                                                       '
cBody += '   <v:stroke joinstyle="miter"/>                                                                                               '
cBody += '   <v:formulas>                                                                                                                '
cBody += '    <v:f eqn="if lineDrawn pixelLineWidth 0"/>                                                                                 '
cBody += '    <v:f eqn="sum @0 1 0"/>                                                                                                    '
cBody += '    <v:f eqn="sum 0 0 @1"/>                                                                                                    '
cBody += '    <v:f eqn="prod @2 1 2"/>                                                                                                   '
cBody += '    <v:f eqn="prod @3 21600 pixelWidth"/>                                                                                      '
cBody += '    <v:f eqn="prod @3 21600 pixelHeight"/>                                                                                     '
cBody += '    <v:f eqn="sum @0 0 1"/>                                                                                                    '
cBody += '    <v:f eqn="prod @6 1 2"/>                                                                                                   '
cBody += '    <v:f eqn="prod @7 21600 pixelWidth"/>                                                                                      '
cBody += '    <v:f eqn="sum @8 21600 0"/>                                                                                                '
cBody += '    <v:f eqn="prod @7 21600 pixelHeight"/>                                                                                     '
cBody += '    <v:f eqn="sum @10 21600 0"/>                                                                                               '
cBody += '   </v:formulas>                                                                                                               '
cBody += '   <v:path o:extrusionok="f" gradientshapeok="t" o:connecttype="rect"/>                                                        '
cBody += '   <o:lock v:ext="edit" aspectratio="t"/>                                                                                      '
cBody += '  </v:shapetype><v:shape id="Graphics_x0020_1" o:spid="_x0000_s1028" type="#_x0000_t75"                                        '
cBody += '   style="width:97pt;height:19pt;mso-wrap-style:none;                                                                          '
cBody += '   mso-position-horizontal-relative:char;mso-position-vertical-relative:line;                                                  '
cBody += '   v-text-anchor:middle">                                                                                                      '
cBody += '   <v:fill type="frame"/>                                                                                                      '
cBody += '   <v:stroke joinstyle="round"/>                                                                                               '
cBody += '   <v:imagedata src="LGRL'+cEmpFil+'.BMP" o:title=""/>                                                                         '
cBody += '   <w:wrap type="none"/>                                                                                                       '
cBody += '   <w:anchorlock/>                                                                                                             '
cBody += '  </v:shape><![endif]--><![if !vml]><img width=97 height=19                                                                    '
cBody += '  src="LGRL'+cEmpFil+'.BMP" v:shapes="Graphics_x0020_1"><![endif]><o:p></o:p></span></b></p>                                   '
cBody += '  </td>                                                                                                                        '
cBody += '  <td width=829 colspan=9 style="width:621.85pt;border-top:solid windowtext 1.0pt;                                            '
cBody += '  border-left:none;border-bottom:none;border-right:solid windowtext 1.0pt;                                                     '
cBody += '  padding:0cm 0cm 0cm 0cm;height:36.3pt">                                                                                      '
cBody += '  <p class=MsoNormal align=center style="mso-margin-top-alt:auto;mso-margin-bottom-alt:                                        '
cBody += '  auto;text-align:center"><b style="mso-bidi-font-weight:normal"><span                                                         '
cBody += '  style="font-size:14.0pt;mso-bidi-font-size:10.0pt;font-family:Arial;                                                         '

If !lCancela
	cBody += '  color:red">PRÉ-ALERTA No<span class=GramE>.:</span>' + M->DY8_NUMPRE +'</span></b><b                                      '
Else
	cBody += '  color:red">CANCELAMENTO DO PRÉ-ALERTA No<span class=GramE>.:</span>' + M->DY8_NUMPRE +'</span></b><b                      '
EndIf

cBody += '  style="mso-bidi-font-weight:normal"><span style="font-size:10.0pt;font-family:                                               '
cBody += '  Arial;color:red"><o:p></o:p></span></b></p>                                                                                  '
cBody += '  </td>                                                                                                                        '
cBody += ' </tr>                                                                                                                         '
cBody += ' <tr style="mso-yfti-irow:1">                                                                                                  '
cBody += '  <td width=998 colspan=11 valign=top style="width:748.2pt;border:solid windowtext 1.0pt;                                      '
cBody += '  border-top:none;background:#D9D9D9;padding:0cm 5.4pt 0cm 5.4pt;border-color:                                                 '
cBody += '  -moz-use-text-color windowtext windowtext">                                                                                  '
cBody += '  <p class=MsoNormal align=center style="mso-margin-top-alt:auto;mso-margin-bottom-alt:                                        '
cBody += '  auto;text-align:center"><b><span style="font-size:10.0pt;font-family:Arial">'+STR0001 //"DADOS DO EMBARQUE"
cBody += '  <u1:p></u1:p></span></b><span style="font-size:10.0pt;font-family:                                                           '
cBody += '  Arial"><o:p></o:p></span></p>                                                                                                '
cBody += '  </td>                                                                                                                        '
cBody += ' </tr>                                                                                                                         '
cBody += ' <tr style="mso-yfti-irow:2">                                                                                                  '
cBody += '  <td width=146 valign=top align=right style="width:109.5pt;border:solid windowtext 1.0pt;                                     '
cBody += '  border-top:none;padding:0cm 5.4pt 0cm 5.4pt;border-color:-moz-use-text-color windowtext windowtext">                         '
cBody += '  <p class=MsoNormal style="mso-margin-top-alt:auto;mso-margin-bottom-alt:auto"><b><span                                       '
cBody += '  style="font-size:8.0pt;mso-bidi-font-size:10.0pt;font-family:Arial">'+aHeader[HD_FILDES]+'<u1:p></u1:p></span></b><span      '
cBody += '  style="font-size:8.0pt;mso-bidi-font-size:12.0pt"><o:p></o:p></span></p>                                                     '
cBody += '  </td>                                                                                                                        '
cBody += '  <td width=428 colspan=6 valign=top style="width:321.2pt;border-top:none;                                                     '
cBody += '  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;                                   '
cBody += '  padding:0cm 5.4pt 0cm 5.4pt;border-color:-moz-use-text-color windowtext windowtext -moz-use-text-color">                     '
cBody += '  <p class=MsoNormal style="mso-margin-top-alt:auto;mso-margin-bottom-alt:auto"><span                                          '
cBody += '  style="font-size:8.0pt;mso-bidi-font-size:10.0pt;font-family:Arial"> ' + SM0->M0_CODFIL +'-'+SM0->M0_FILIAL +' '+SM0->M0_NOMECOM +' '
cBody += '  <u1:p></u1:p></span><span style="font-size:8.0pt;                                                                            '
cBody += '  mso-bidi-font-size:12.0pt"><o:p></o:p></span></p>                                                                            '
cBody += '  </td>                                                                                                                        '
cBody += '  <td width=88 valign=top align=right style="width:65.8pt;border-top:none;border-left:none;                                    '
cBody += '  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;                                                    '
cBody += '  padding:0cm 5.4pt 0cm 5.4pt;border-color:-moz-use-text-color windowtext windowtext -moz-use-text-color">                     '
cBody += '  <p class=MsoNormal style="mso-margin-top-alt:auto;mso-margin-bottom-alt:auto"><b><span                                       '
cBody += '  style="font-size:8.0pt;mso-bidi-font-size:10.0pt;font-family:Arial">'+aHeader[HD_DATEMI]+'<u1:p></u1:p></span></b><span      '
cBody += '  style="font-size:8.0pt;mso-bidi-font-size:12.0pt"><o:p></o:p></span></p>                                                     '
cBody += '  </td>                                                                                                                        '
cBody += '  <td width=336 colspan=3 valign=top style="width:251.7pt;border-top:none;                                                     '
cBody += '  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;                                   '
cBody += '  padding:0cm 5.4pt 0cm 5.4pt;border-color:-moz-use-text-color windowtext windowtext -moz-use-text-color">                     '
cBody += '  <p class=MsoNormal style="mso-margin-top-alt:auto;mso-margin-bottom-alt:auto"><span                                          '
cBody += '  style="font-size:8.0pt;mso-bidi-font-size:10.0pt;font-family:Arial">                                                         '
cBody +=    DtoC(DTV->DTV_DATEMI) +'<u1:p></u1:p></span><span style="font-size:8.0pt;mso-bidi-font-size:                                 '
cBody += '  12.0pt"><o:p></o:p></span></p>                                                                                               '
cBody += '  </td>                                                                                                                        '
cBody += ' </tr>                                                                                                                         '
cBody += ' <tr style="mso-yfti-irow:3">                                                                                                  '
//-- by Gustavo 
cBody += '  <td width=146 valign=top align=right style="width:109.5pt;border:solid windowtext 1.0pt;                                                 '
cBody += '  border-top:none;padding:0cm 5.4pt 0cm 5.4pt;border-color:-moz-use-text-color windowtext windowtext">                         '
cBody += '  <p class=MsoNormal style="mso-margin-top-alt:auto;mso-margin-bottom-alt:auto"><span                                          '
cBody += '  class=SpellE><span class=spelle><b><span style="font-size:8.0pt;mso-bidi-font-size:                                          '
cBody += '  10.0pt;font-family:Arial">'+aHeader[HD_CIDUF]+'</span></b></span></span><b><span                                             '
cBody += '  style="font-size:8.0pt;mso-bidi-font-size:10.0pt;font-family:Arial"><u1:p></u1:p></span></b><span                            '
cBody += '  style="font-size:8.0pt;mso-bidi-font-size:12.0pt"><o:p></o:p></span></p>                                                     '
cBody += '  </td>                                                                                                                        '
cBody += '  <td width=852 colspan=10 valign=top style="width:638.7pt;border-top:none;                                                    '
cBody += '  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;                                   '
cBody += '  padding:0cm 5.4pt 0cm 5.4pt;border-color:-moz-use-text-color windowtext windowtext -moz-use-text-color">                     '
cBody += '  <p class=MsoNormal style="mso-margin-top-alt:auto;mso-margin-bottom-alt:auto"><span                                          '
cBody += '  class=grame><span style="font-size:8.0pt;mso-bidi-font-size:10.0pt;                                                          '
cBody += '  font-family:Arial"></span></span><span style="font-size:8.0pt;                                                               '
cBody += '  mso-bidi-font-size:10.0pt;font-family:Arial"> ' + SM0->M0_CIDCOB + '<u1:p></u1:p></span><span                                '
cBody += '  style="font-size:8.0pt;mso-bidi-font-size:10.0pt;font-family:Arial"> / ' + SM0->M0_ESTCOB + '                                '
cBody += '  <u1:p></u1:p></span><span style="font-size:8.0pt;mso-bidi-font-size:                                                         '
cBody += '  12.0pt"><o:p></o:p></span></p>                                                                                               '
cBody += '  </td>                                                                                                                        '
//-- by Gustavo                                                                                                 

cBody += ' </tr>                                                                                                                         '
cBody += ' <tr style="mso-yfti-irow:4">                                                                                                  '
cBody += '  <td width=998 colspan=11 valign=top style="width:748.2pt;border-top:none;                                                    '
cBody += '  border-left:solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;                                   '
cBody += '  padding:0cm 5.4pt 0cm 5.4pt;border-color:-moz-use-text-color windowtext">                                                    '
cBody += '  <p class=MsoNormal style="mso-margin-top-alt:auto;mso-margin-bottom-alt:auto"><span                                          '
cBody += '  style="font-size:10.0pt;font-family:Arial"><u1:p>&nbsp;</u1:p></span></p>                                                    '
cBody += '  </td>                                                                                                                        '
cBody += ' </tr>                                                                                                                         '
cBody += ' <tr style="mso-yfti-irow:6">                                                                                                  '
cBody += '  <td width=998 colspan=11 valign=top style="width:748.2pt;border:solid windowtext 1.0pt;                                      '
cBody += '  border-top:none;padding:0cm 5.4pt 0cm 5.4pt;border-color:-moz-use-text-color windowtext windowtext">                         '
cBody += '  <p class=MsoNormal style="mso-margin-top-alt:auto;mso-margin-bottom-alt:auto"><b><span                                       '
cBody += '  style="font-size:10.0pt;font-family:Arial">'+aHeader[HD_CLIREM]+'</span></b></p>                                             '
cBody += '  </td>                                                                                                                        '
cBody += ' </tr>                                                                                                                         '
cBody += ' <u1:p></u1:p>                                                                                                                 '

//-- Filial de Origem
SM0->(MsSeek(cEmpAnt+DTV->DTV_FILORI))

cBody += ' <tr style="mso-yfti-irow:7">                                                                                                  '
cBody += '  <td width=574 colspan=7 valign=top style="width:430.7pt;border:solid windowtext 1.0pt;                                       '
cBody += '  border-top:none;padding:0cm 0cm 0cm 0cm;border-color:-moz-use-text-color windowtext windowtext">                             '
cBody += '  <p class=MsoNormal style="mso-margin-top-alt:auto;mso-margin-bottom-alt:auto"><span                                          '
cBody += '  style="font-size:8.0pt;mso-bidi-font-size:10.0pt;font-family:Arial">&nbsp;                                                   '
cBody +=    SM0->M0_NOMECOM + '<u1:p></u1:p></span><span style="font-size:8.0pt;                                                         '
cBody += '  mso-bidi-font-size:12.0pt"><o:p></o:p></span></p>                                                                            '
cBody += '  </td>                                                                                                                        '
cBody += '  <td width=88 valign=top align=right style="width:65.8pt;border-top:none;border-left:none;                                    '
cBody += '  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;                                                    '
cBody += '  padding:0cm 5.4pt 0cm 5.4pt;border-color:-moz-use-text-color windowtext windowtext -moz-use-text-color">                     '
cBody += '  <p class=MsoNormal style="mso-margin-top-alt:auto;mso-margin-bottom-alt:auto"><b><span                                       '
cBody += '  style="font-size:8.0pt;mso-bidi-font-size:10.0pt;font-family:Arial">'+aHeader[HD_FILIAL]+'<u1:p></u1:p></span></b><span      '
cBody += '  style="font-size:8.0pt;mso-bidi-font-size:12.0pt"><o:p></o:p></span></p>                                                     '
cBody += '  </td>                                                                                                                        '
cBody += '  <td width=336 colspan=3 valign=top style="width:251.7pt;border-top:none;                                                     '
cBody += '  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;                                   '
cBody += '  padding:0cm 5.4pt 0cm 5.4pt;border-color:-moz-use-text-color windowtext windowtext -moz-use-text-color">                     '
cBody += '  <p class=MsoNormal style="mso-margin-top-alt:auto;mso-margin-bottom-alt:auto"><span                                          '
cBody += '  style="font-size:8.0pt;mso-bidi-font-size:10.0pt;font-family:Arial">                                                         '
cBody +=    SM0->M0_CODFIL + '<u1:p></u1:p></span><span style="font-size:8.0pt;mso-bidi-font-size:                                       '
cBody += '  12.0pt"><o:p></o:p></span></p>                                                                                               '
cBody += '  </td>                                                                                                                        '
cBody += ' </tr>                                                                                                                         '
cBody += ' <tr style="mso-yfti-irow:8">                                                                                                  '
cBody += '  <td width=574 colspan=7 valign=top align=right style="width:430.7pt;border:solid windowtext 1.0pt;                           '
cBody += '  border-top:none;padding:0cm 5.4pt 0cm 5.4pt;border-color:-moz-use-text-color windowtext windowtext">                         '
cBody += '  <p class=MsoNormal style="mso-margin-top-alt:auto;mso-margin-bottom-alt:auto"><span                                          '
cBody += '  style="font-size:8.0pt;mso-bidi-font-size:10.0pt;font-family:Arial">                                                         '
cBody += '  <u1:p></u1:p></span><span style="font-size:8.0pt;                                                                            '
cBody += '  mso-bidi-font-size:12.0pt"><o:p></o:p></span></p>                                                                            '
cBody += '  </td>                                                                                                                        '
cBody += '  <td width=88 valign=top align=right style="width:65.8pt;border-top:none;border-left:none;                                    '
cBody += '  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;                                                    '
cBody += '  padding:0cm 5.4pt 0cm 5.4pt;border-color:-moz-use-text-color windowtext windowtext -moz-use-text-color">                     '
cBody += '  <p class=MsoNormal style="mso-margin-top-alt:auto;mso-margin-bottom-alt:auto"><b><span                                       '
cBody += '  style="font-size:8.0pt;mso-bidi-font-size:10.0pt;font-family:Arial">'+aHeader[HD_TEL]+'<u1:p></u1:p></span></b><span         '
cBody += '  style="font-size:8.0pt;mso-bidi-font-size:12.0pt"><o:p></o:p></span></p>                                                     '
cBody += '  </td>                                                                                                                        '
cBody += '  <td width=336 colspan=3 valign=top style="width:251.7pt;border-top:none;                                                     '
cBody += '  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;                                   '
cBody += '  padding:0cm 5.4pt 0cm 5.4pt;border-color:-moz-use-text-color windowtext windowtext -moz-use-text-color">                     '
cBody += '  <p class=MsoNormal style="mso-margin-top-alt:auto;mso-margin-bottom-alt:auto"><span                                          '
cBody += '  style="font-size:8.0pt;mso-bidi-font-size:10.0pt;font-family:Arial">                                                         '
cBody +=    SM0->M0_TEL + '<u1:p></u1:p></span><span style="font-size:8.0pt;mso-bidi-font-size:                                          '
cBody += '  12.0pt"><o:p></o:p></span></p>                                                                                               '
cBody += '  </td>                                                                                                                        '
cBody += ' </tr>                                                                                                                         '
cBody += ' <tr style="mso-yfti-irow:9">                                                                                                  '
cBody += '  <td width=998 colspan=11 valign=top style="width:748.2pt;border-top:none;                                                    '
cBody += '  border-left:solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;                                   '
cBody += '  padding:0cm 5.4pt 0cm 5.4pt;border-color:-moz-use-text-color windowtext">                                                    '
cBody += '  <p class=MsoNormal style="mso-margin-top-alt:auto;mso-margin-bottom-alt:auto"><span                                          '
cBody += '  style="font-size:10.0pt;font-family:Arial"><u1:p>&nbsp;</u1:p></span></p>                                                    '
cBody += '  </td>                                                                                                                        '
cBody += ' </tr>                                                                                                                         '
cBody += ' <tr style="mso-yfti-irow:10">                                                                                                 '
cBody += '  <td width=998 colspan=11 valign=top style="width:748.2pt;border-top:none;                                                    '
cBody += '  border-left:solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;                                   '
cBody += '  padding:0cm 5.4pt 0cm 5.4pt;border-color:-moz-use-text-color windowtext">                                                    '
cBody += '  <p class=MsoNormal style="mso-margin-top-alt:auto;mso-margin-bottom-alt:auto"><span                                          '
cBody += '  style="font-size:10.0pt;font-family:Arial"><u1:p>&nbsp;</u1:p></span></p>                                                    '
cBody += '  </td>                                                                                                                        '
cBody += ' </tr>                                                                                                                         '
cBody += ' <tr style="mso-yfti-irow:11">                                                                                                 '
cBody += '  <td width=998 colspan=11 valign=top style="width:748.2pt;border:solid windowtext 1.0pt;                                      '
cBody += '  border-top:none;background:#D9D9D9;padding:0cm 5.4pt 0cm 5.4pt;border-color:                                                 '
cBody += '  -moz-use-text-color windowtext windowtext">                                                                                  '
cBody += '  <p class=MsoNormal align=center style="mso-margin-top-alt:auto;mso-margin-bottom-alt:                                        '
cBody += '  auto;text-align:center"><b><span style="font-size:10.0pt;font-family:Arial">'+STR0002 //DADOS DO VÔO
cBody += '  <u1:p></u1:p></span></b></p>                                                                                                 '
cBody += '  </td>                                                                                                                        '
cBody += ' </tr>                                                                                                                         '
cBody += ' <tr style="mso-yfti-irow:12">                                                                                                 '
cBody += '  <td width=146 valign=top align=right style="width:109.5pt;border:solid windowtext 1.0pt;                                     '
cBody += '  border-top:none;padding:0cm 5.4pt 0cm 5.4pt;border-color:-moz-use-text-color windowtext windowtext">                         '
cBody += '  <p class=MsoNormal style="mso-margin-top-alt:auto;mso-margin-bottom-alt:auto"><b><span                                       '
cBody += '  style="font-size:8.0pt;mso-bidi-font-size:10.0pt;font-family:Arial">'+aHeader[HD_DATPAR]+'                                   '
cBody += '  <u1:p></u1:p></span></b><span style="font-size:8.0pt;mso-bidi-font-size:                                                     '
cBody += '  12.0pt"><o:p></o:p></span></p>                                                                                               '
cBody += '  </td>                                                                                                                        '
cBody += '  <td width=193 colspan=3 valign=top style="width:144.95pt;border-top:none;                                                    '
cBody += '  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;                                   '
cBody += '  padding:0cm 5.4pt 0cm 5.4pt;border-color:-moz-use-text-color windowtext windowtext -moz-use-text-color">                     '
cBody += '  <p class=MsoNormal style="mso-margin-top-alt:auto;mso-margin-bottom-alt:auto"><span                                          '
cBody += '  style="font-size:8.0pt;mso-bidi-font-size:10.0pt;font-family:Arial">&nbsp;<span                                              '
cBody += '  class=GramE><span class=grame><span style="font-family:Arial">' + DtoC(dDatPar) +'</span></span></span>                      '
cBody += '  <u1:p></u1:p></span><span style="font-size:8.0pt;mso-bidi-font-size:                                                         '
cBody += '  12.0pt"><o:p></o:p></span></p>                                                                                               '
cBody += '  </td>                                                                                                                        '
cBody += '  <td width=68 valign=top align=right style="width:51.0pt;border-top:none;border-left:none;                                    '
cBody += '  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;                                                    '
cBody += '  padding:0cm 5.4pt 0cm 5.4pt;border-color:-moz-use-text-color windowtext windowtext -moz-use-text-color">                     '
cBody += '  <p class=MsoNormal style="mso-margin-top-alt:auto;mso-margin-bottom-alt:auto"><b><span                                       '
cBody += '  style="font-size:8.0pt;mso-bidi-font-size:10.0pt;font-family:Arial">'+aHeader[HD_NUMVOO]+'<u1:p></u1:p></span></b><span      '
cBody += '  style="font-size:8.0pt;mso-bidi-font-size:12.0pt"><o:p></o:p></span></p>                                                     '
cBody += '  </td>                                                                                                                        '
cBody += '  <td width=167 valign=top style="width:125.25pt;border-top:none;                                                              '
cBody += '  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;                                   '
cBody += '  padding:0cm 5.4pt 0cm 5.4pt;border-color:-moz-use-text-color windowtext windowtext -moz-use-text-color">                     '
cBody += '  <p class=MsoNormal style="mso-margin-top-alt:auto;mso-margin-bottom-alt:auto"><span                                          '
cBody += '  style="font-size:8.0pt;mso-bidi-font-size:10.0pt;font-family:Arial">&nbsp;<span                                              '
cBody += '  class=GramE><span class=grame><span style="font-family:Arial">' + cNumVoo + '</span></span></span>                           '
cBody += '  <u1:p></u1:p></span><span style="font-size:8.0pt;mso-bidi-font-size:12.0pt"><o:p></o:p></span></p>                           '
cBody += '  </td>                                                                                                                        '
cBody += '  <td width=88 valign=top align=right style="width:65.8pt;border-top:none;border-left:none;                                    '
cBody += '  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;                                                    '
cBody += '  padding:0cm 5.4pt 0cm 5.4pt;border-color:-moz-use-text-color windowtext windowtext -moz-use-text-color">                     '
cBody += '  <p class=MsoNormal style="mso-margin-top-alt:auto;mso-margin-bottom-alt:auto"><span                                          '
cBody += '  class=SpellE><span class=spelle><b><span style="font-size:8.0pt;mso-bidi-font-size:                                          '
cBody += '  10.0pt;font-family:Arial"></span></b></span></span><b><span                                                                  '
cBody += '  style="font-size:8.0pt;mso-bidi-font-size:10.0pt;font-family:Arial">'+aHeader[HD_HORPAR]+'<u1:p></u1:p></span></b><span      '
cBody += '  style="font-size:8.0pt;mso-bidi-font-size:12.0pt"><o:p></o:p></span></p>                                                     '
cBody += '  </td>                                                                                                                        '
cBody += '  <td width=100 colspan=2 valign=top style="width:83.6pt;border-top:none;                                                      '
cBody += '  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;                                   '
cBody += '  padding:0cm 5.4pt 0cm 5.4pt;border-color:-moz-use-text-color windowtext windowtext -moz-use-text-color">                     '
cBody += '  <p class=MsoNormal style="mso-margin-top-alt:auto;mso-margin-bottom-alt:auto"><span                                          '
cBody += '  style="font-size:8.0pt;mso-bidi-font-size:10.0pt;font-family:Arial"><span                                                    '
cBody += '  class=SpellE><span class=spelle><span style="font-family:Arial">'+Transform(cHorPar, PesqPict('DVH', 'DVH_HORPAR'))
cBody += '  </span></span></span>                                                                                                        '
cBody += '  <u1:p></u1:p></span><span style="font-size:8.0pt;mso-bidi-font-size:12.0pt"><o:p></o:p></span></p>                           '
cBody += '  </td>                                                                                                                        '
cBody += '  <td width=81 valign=top align=right style="width:61.05pt;border-top:none;border-left:                                        '
cBody += '  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;                                               '
cBody += '  padding:0cm 5.4pt 0cm 5.4pt;border-color:-moz-use-text-color windowtext windowtext -moz-use-text-color">                     '
cBody += '  <p class=MsoNormal style="mso-margin-top-alt:auto;mso-margin-bottom-alt:auto"><span                                          '
cBody += '  class=SpellE><span class=spelle><b><span style="font-size:8.0pt;mso-bidi-font-size:                                          '
cBody += '  10.0pt;font-family:Arial"></span></b></span></span><b><span                                                                  '
cBody += '  style="font-size:8.0pt;mso-bidi-font-size:10.0pt;font-family:Arial"><span                                                    '
cBody += '  class=SpellE><span class=spelle><span style="font-family:Arial">'+aHeader[HD_HORCHG]+'</span></span></span><span             '
cBody += '  class=GramE><span class=grame><span style="font-family:Arial"><u1:p></u1:p></span></span></span></span></b><span             '
cBody += '  style="font-size:8.0pt;mso-bidi-font-size:12.0pt"><o:p></o:p></span></p>                                                     '
cBody += '  </td>                                                                                                                        '
cBody += '  <td width=143 valign=top style="width:107.05pt;border-top:none;border-left:                                                  '
cBody += '  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;                                               '
cBody += '  padding:0cm 5.4pt 0cm 5.4pt;border-color:-moz-use-text-color windowtext windowtext -moz-use-text-color">                     '
cBody += '  <p class=MsoNormal style="mso-margin-top-alt:auto;mso-margin-bottom-alt:auto"><span                                          '
cBody += '  style="font-size:8.0pt;mso-bidi-font-size:10.0pt;font-family:Arial">                                                         '
cBody +=    Transform(cHorChg, PesqPict('DVH', 'DVH_HORCHG')) +'<u1:p></u1:p></span><span style="font-size:8.0pt;mso-bidi-font-size:     '
cBody += '  12.0pt"><o:p></o:p></span></p>                                                                                               '
cBody += '  </td>                                                                                                                        '
cBody += ' </tr>                                                                                                                         '
cBody += ' <tr style="mso-yfti-irow:13">                                                                                                 '
cBody += '  <td width=146 valign=top align=right style="width:109.5pt;border:solid windowtext 1.0pt;                                     '
cBody += '  border-top:none;padding:0cm 5.4pt 0cm 5.4pt;border-color:-moz-use-text-color windowtext windowtext">                         '
cBody += '  <p class=MsoNormal style="mso-margin-top-alt:auto;mso-margin-bottom-alt:auto"><b><span                                       '
cBody += '  style="font-size:8.0pt;mso-bidi-font-size:10.0pt;font-family:Arial">'+aHeader[HD_CODCIA]+'<u1:p></u1:p></span></b><span      '
cBody += '  style="font-size:8.0pt;mso-bidi-font-size:12.0pt"><o:p></o:p></span></p>                                                     '
cBody += '  </td>                                                                                                                        '
cBody += '  <td width=428 colspan=6 valign=top style="width:321.2pt;border-top:none;                                                     '
cBody += '  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;                                   '
cBody += '  padding:0cm 5.4pt 0cm 5.4pt;border-color:-moz-use-text-color windowtext windowtext -moz-use-text-color">                     '
cBody += '  <p class=MsoNormal style="mso-margin-top-alt:auto;mso-margin-bottom-alt:auto"><span                                          '
cBody += '  style="font-size:8.0pt;mso-bidi-font-size:10.0pt;font-family:Arial"><span                                                    '
cBody += '  class=SpellE><span class=GramE><span class=grame><span style="font-family:                                                   '
cBody += '  Arial"></span></span></span></span> ' + Posicione('SA2',1,xFilial('SA2')+DTV->DTV_CODCIA+DTV->DTV_LOJCIA,'A2_NOME')
cBody += '  <u1:p></u1:p></span><span                                                                                                    '
cBody += '  style="font-size:8.0pt;mso-bidi-font-size:12.0pt"><o:p></o:p></span></p>                                                     '
cBody += '  </td>                                                                                                                        '
cBody += '  <td width=88 valign=top align=right style="width:65.8pt;border-top:none;border-left:none;                                    '
cBody += '  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;                                                    '
cBody += '  padding:0cm 5.4pt 0cm 5.4pt;border-color:-moz-use-text-color windowtext windowtext -moz-use-text-color">                     '
cBody += '  <p class=MsoNormal style="mso-margin-top-alt:auto;mso-margin-bottom-alt:auto"><b><span                                       '
cBody += '  style="font-size:8.0pt;mso-bidi-font-size:10.0pt;font-family:Arial">'+aHeader[HD_NUMAWB]+'<span                              '
cBody += '  class=GramE><span class=grame><span style="font-family:Arial"><u1:p></u1:p></span></span></span></span></b><span             '
cBody += '  style="font-size:8.0pt;mso-bidi-font-size:12.0pt"><o:p></o:p></span></p>                                                     '
cBody += '  </td>                                                                                                                        '
cBody += '  <td width=336 colspan=3 valign=top style="width:251.7pt;border-top:none;                                                     '
cBody += '  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;                                   '
cBody += '  padding:0cm 5.4pt 0cm 5.4pt;border-color:-moz-use-text-color windowtext windowtext -moz-use-text-color">                     '
cBody += '  <p class=MsoNormal style="mso-margin-top-alt:auto;mso-margin-bottom-alt:auto"><span                                          '
cBody += '  style="font-size:8.0pt;mso-bidi-font-size:10.0pt;font-family:Arial"> ' + DTV->DTV_NUMAWB + '-' + DTV->DTV_DIGAWB
cBody += '  <u1:p>&nbsp;</u1:p></span><span                                                                                              '
cBody += '  style="font-size:8.0pt;mso-bidi-font-size:12.0pt"><o:p></o:p></span></p>                                                     '
cBody += '  </td>                                                                                                                        '
cBody += ' </tr>                                                                                                                         '
cBody += ' <tr style="mso-yfti-irow:14">                                                                                                 '
cBody += '  <td width=146 valign=top align=right style="width:109.5pt;border:solid windowtext 1.0pt;                                     '
cBody += '  border-top:none;padding:0cm 5.4pt 0cm 5.4pt;border-color:-moz-use-text-color windowtext windowtext">                         '
cBody += '  <p class=MsoNormal style="mso-margin-top-alt:auto;mso-margin-bottom-alt:auto"><b><span                                       '
cBody += '  style="font-size:8.0pt;mso-bidi-font-size:10.0pt;font-family:Arial">'+aHeader[HD_QTDVOL]+'<u1:p></u1:p></span></b><span      '
cBody += '  style="font-size:8.0pt;mso-bidi-font-size:12.0pt"><o:p></o:p></span></p>                                                     '
cBody += '  </td>                                                                                                                        '
cBody += '  <td width=428 colspan=6 valign=top style="width:321.2pt;border-top:none;                                                     '
cBody += '  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;                                   '
cBody += '  padding:0cm 5.4pt 0cm 5.4pt;border-color:-moz-use-text-color windowtext windowtext -moz-use-text-color">                     '
cBody += '  <p class=MsoNormal style="mso-margin-top-alt:auto;mso-margin-bottom-alt:auto"><span                                          '
cBody += '  style="font-size:8.0pt;mso-bidi-font-size:10.0pt;font-family:Arial">                                                         '
cBody +=    str(DTV->DTV_QTDVOL) + '<u1:p></u1:p></span><span style="font-size:8.0pt;mso-bidi-font-size:                                 '
cBody += '  12.0pt"><o:p></o:p></span></p>                                                                                               '
cBody += '  </td>                                                                                                                        '
cBody += '  <td width=88 valign=top align=right style="width:65.8pt;border-top:none;border-left:none;                                    '
cBody += '  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;                                                    '
cBody += '  padding:0cm 5.4pt 0cm 5.4pt;border-color:-moz-use-text-color windowtext windowtext -moz-use-text-color">                     '
cBody += '  <p class=MsoNormal style="mso-margin-top-alt:auto;mso-margin-bottom-alt:auto"><b><span                                       '
cBody += '  style="font-size:8.0pt;mso-bidi-font-size:10.0pt;font-family:Arial">'+aHeader[HD_PESO]+'<u1:p></u1:p></span></b><span        '
cBody += '  style="font-size:8.0pt;mso-bidi-font-size:12.0pt"><o:p></o:p></span></p>                                                     '
cBody += '  </td>                                                                                                                        '
cBody += '  <td width=100 valign=top style="width:83.6pt;border-top:none;                                                                '
cBody += '  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;                                   '
cBody += '  padding:0cm 5.4pt 0cm 5.4pt;border-color:-moz-use-text-color windowtext windowtext -moz-use-text-color">                     '
cBody += '  <p class=MsoNormal style="mso-margin-top-alt:auto;mso-margin-bottom-alt:auto"><span                                          '
cBody += '  style="font-size:8.0pt;mso-bidi-font-size:10.0pt;font-family:Arial"><ns0:metricconverter                                     '
cBody += '   ns1:productid="99 kg"><st1:metricconverter ProductID="99 kg" w:st="on"> ' + Transform(DTV->DTV_PESO, PesqPict("DTV", "DTV_PESO")) 
cBody += '  </st1:metricconverter></ns0:metricconverter>                                                                                 '
cBody += '  <span class=GramE><span class=grame><span style="font-family:Arial"></span></span></span></span><span                        '
cBody += '  style="font-size:8.0pt;mso-bidi-font-size:12.0pt"><o:p></o:p></span></p>                                                     '
cBody += '  </td>                                                                                                                        '
cBody += '  <u1:p></u1:p>                                                                                                                '
cBody += '  <td width=81 valign=top align=right style="width:61.05pt;border-top:none;border-left:                                        '
cBody += '  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;                                               '
cBody += '  padding:0cm 5.4pt 0cm 5.4pt;border-color:-moz-use-text-color windowtext windowtext -moz-use-text-color">                     '
cBody += '  <p class=MsoNormal style="mso-margin-top-alt:auto;mso-margin-bottom-alt:auto"><b><span                                       '
cBody += '  style="font-size:8.0pt;mso-bidi-font-size:10.0pt;font-family:Arial">'+aHeader[HD_PESOM3]+'                                   '
cBody += '  <u1:p></u1:p></span></b><span style="font-size:8.0pt;mso-bidi-font-size:                                                     '
cBody += '  12.0pt"><o:p></o:p></span></p>                                                                                               '
cBody += '  </td>                                                                                                                        '
cBody += '  <td width=143 valign=top style="width:107.05pt;border-top:none;border-left:                                                  '
cBody += '  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;                                               '
cBody += '  padding:0cm 5.4pt 0cm 5.4pt;border-color:-moz-use-text-color windowtext windowtext -moz-use-text-color">                     '
cBody += '  <p class=MsoNormal style="mso-margin-top-alt:auto;mso-margin-bottom-alt:auto"><span                                          '
cBody += '  style="font-size:8.0pt;mso-bidi-font-size:10.0pt;font-family:Arial"><ns0:metricconverter                                     '
cBody += '   ns1:productid="99 kg"><st1:metricconverter ProductID="99 kg" w:st="on"></st1:metricconverter></ns0:metricconverter>         '
cBody += '  <span class=GramE><span class=grame><span style="font-family:Arial"> '+ Transform(DTV->DTV_PESOM3, PesqPict("DTV", "DTV_PESOM3"))
cBody += '  </span></span></span></span><span                                                           											  '
cBody += '  style="font-size:8.0pt;mso-bidi-font-size:12.0pt"><o:p></o:p></span></p>                                                     '
cBody += '  </td>                                                                                                                        '
cBody += ' </tr>                                                                                                                         '
cBody += ' <u1:p></u1:p>                                                                                                                 '
cBody += ' <tr style="mso-yfti-irow:15">                                                                                                 '
cBody += '  <td width=146 valign=top align=right style="width:109.5pt;border:solid windowtext 1.0pt;                                     '
cBody += '  border-top:none;padding:0cm 5.4pt 0cm 5.4pt;border-color:-moz-use-text-color windowtext windowtext">                         '
cBody += '  <p class=MsoNormal style="mso-margin-top-alt:auto;mso-margin-bottom-alt:auto"><span                                          '
cBody += '  class=SpellE><span class=spelle><b><span style="font-size:8.0pt;mso-bidi-font-size:                                          '
cBody += '  10.0pt;font-family:Arial"></span></b></span></span><b><span                                                                  '
cBody += '  style="font-size:8.0pt;mso-bidi-font-size:10.0pt;font-family:Arial"><span                                                    ' 
cBody += '  class=SpellE><span class=spelle><span style="font-family:Arial">'+aHeader[HD_CODEMB]+'</span></span></span><u1:p>            '
cBody += '  </u1:p></span></b><span                        																										  '
cBody += '  style="font-size:8.0pt;mso-bidi-font-size:12.0pt"><o:p></o:p></span></p>                                                     '
cBody += '  </td>                                                                                                                        '
cBody += '  <td width=428 colspan=6 valign=top style="width:321.2pt;border-top:none;                                                     '
cBody += '  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;                                   '
cBody += '  padding:0cm 5.4pt 0cm 5.4pt;border-color:-moz-use-text-color windowtext windowtext -moz-use-text-color">                     '
cBody += '  <p class=MsoNormal style="mso-margin-top-alt:auto;mso-margin-bottom-alt:auto"> <span                                         '
cBody += '  class=grame><span style="font-size:8.0pt;mso-bidi-font-size:10.0pt;                                                          '
cBody += '  font-family:Arial"></span></span><span style="font-size:8.0pt;                                                               '
cBody += '  mso-bidi-font-size:10.0pt;font-family:Arial"> ' + DTV->DTV_CODEMB + ' <u1:p></u1:p></span><span                              '
cBody += '  style="font-size:8.0pt;mso-bidi-font-size:12.0pt"><o:p></o:p></span></p>                                                     '
cBody += '  </td>                                                                                                                        '
cBody += '  <td width=88 valign=top align=right style="width:65.8pt;border-top:none;border-left:none;                                                '
cBody += '  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;                                                    '
cBody += '  padding:0cm 5.4pt 0cm 5.4pt;border-color:-moz-use-text-color windowtext windowtext -moz-use-text-color">                     '
cBody += '  <p class=MsoNormal style="mso-margin-top-alt:auto;mso-margin-bottom-alt:auto"><b><span                                       '
cBody += '  style="font-size:8.0pt;mso-bidi-font-size:10.0pt;font-family:Arial">'+aHeader[HD_LACRE]+'<u1:p></u1:p></span></b><span       '
cBody += '  style="font-size:8.0pt;mso-bidi-font-size:12.0pt"><o:p></o:p></span></p>                                                     '
cBody += '  </td>

DVB->( dbSetOrder( 1 ) )

If DVB->( MsSeek( cSeek := xFilial( "DVB" ) + cFilOri + cViagem ) )
	Do While DVB->( !EoF() ) .And. DVB->(DVB_FILIAL+DVB_FILORI+DVB_VIAGEM) == cSeek
		cLacre += AllTrim(DVB->DVB_LACRE)+"<br />"
		DVB->( dbSkip() )
	EndDo
   cLacre := SubStr( cLacre,1,Len(cLacre)-6 )
EndIf  
                                                                                                                    
cBody += '  <td width=336 colspan=3 valign=top style="width:251.7pt;border-top:none;                                                     '
cBody += '  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;                                   '
cBody += '  padding:0cm 5.4pt 0cm 5.4pt;border-color:-moz-use-text-color windowtext windowtext -moz-use-text-color">                     '
cBody += '  <p class=MsoNormal style="mso-margin-top-alt:auto;mso-margin-bottom-alt:auto"><span                                          '
cBody += '  style="font-size:8.0pt;mso-bidi-font-size:10.0pt;font-family:Arial">                                                         '                                              
cBody += '  <u1:p>'+cLacre
cBody += '  </u1:p></span><span style="font-size:8.0pt;mso-bidi-font-size:                                                               '
cBody += '  12.0pt"><o:p></o:p></span></p>                                                                                               '
cBody += '  </td>                                                                                                                        '
cBody += ' </tr>                                                                                                                         '
cBody += ' <tr style="mso-yfti-irow:16">                                                                                                 '
cBody += '  <td width=146 valign=top align=right style="width:109.5pt;border:solid windowtext 1.0pt;                                     '
cBody += '  border-top:none;padding:0cm 5.4pt 0cm 5.4pt;border-color:-moz-use-text-color windowtext windowtext">                         '
cBody += '  <p class=MsoNormal style="mso-margin-top-alt:auto;mso-margin-bottom-alt:auto"><span                                          '
cBody += '  class=SpellE><span class=spelle><b><span style="font-size:8.0pt;mso-bidi-font-size:                                          '
cBody += '  10.0pt;font-family:Arial"></span></b></span></span><b><span                                                                  '
cBody += '  style="font-size:8.0pt;mso-bidi-font-size:10.0pt;font-family:Arial">'+aHeader[HD_DESPRO]+'<u1:p></u1:p></span></b><span      '
cBody += '  style="font-size:8.0pt;mso-bidi-font-size:12.0pt"><o:p></o:p></span></p>                                                     '
cBody += '  </td>                                                                                                                        '
cBody += '  <td width=852 colspan=10 valign=top style="width:638.7pt;border-top:none;                                                    '
cBody += '  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;                                   '
cBody += '  padding:0cm 5.4pt 0cm 5.4pt;border-color:-moz-use-text-color windowtext windowtext -moz-use-text-color">                     '
cBody += '  <p class=MsoNormal style="mso-margin-top-alt:auto;mso-margin-bottom-alt:auto"><span                                          '
cBody += '  class=grame><span style="font-size:8.0pt;mso-bidi-font-size:10.0pt;                                                          '
cBody += '  font-family:Arial"></span></span><span style="font-size:8.0pt;                                                               '
cBody += '  mso-bidi-font-size:10.0pt;font-family:Arial"> ' + DTV->DTV_DESPRO + ' <u1:p></u1:p></span><span                              '
cBody += '  style="font-size:8.0pt;mso-bidi-font-size:12.0pt"><o:p></o:p></span></p>                                                     '
cBody += '  </td>                                                                                                                        '
cBody += ' </tr>                                                                                                                         '
cBody += ' <tr style="mso-yfti-irow:17">                                                                                                 '
cBody += '  <td width=998 colspan=11 valign=top style="width:748.2pt;border-top:none;                                                    '
cBody += '  border-left:solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;                                   '
cBody += '  padding:0cm 5.4pt 0cm 5.4pt;border-color:-moz-use-text-color windowtext">                                                    '
cBody += '  <p class=MsoNormal style="mso-margin-top-alt:auto;mso-margin-bottom-alt:auto"><span                                          '
cBody += '  style="font-size:10.0pt;font-family:Arial"><u1:p>&nbsp;</u1:p></span></p>                                                    '
cBody += '  </td>                                                                                                                        '
cBody += ' </tr>                                                                                                                         '
cBody += ' <tr style="mso-yfti-irow:18">                                                                                                 '
cBody += '  <td width=998 colspan=11 valign=top style="width:748.2pt;border-top:none;                                                    '
cBody += '  border-left:solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;                                   '
cBody += '  padding:0cm 5.4pt 0cm 5.4pt;border-color:-moz-use-text-color windowtext windowtext">                                         '
cBody += '  <p class=MsoNormal style="mso-margin-top-alt:auto;mso-margin-bottom-alt:auto"><span                                          '
cBody += '  style="font-size:10.0pt;font-family:Arial"><u1:p>&nbsp;</u1:p></span></p>                                                    '
cBody += '  </td>                                                                                                                        '
cBody += ' </tr>                                                                                                                         '


cMemo := MsMM(DTV->DTV_CODOBS,Len(SYP->YP_TEXTO))

cBody += ' <tr style="mso-yfti-irow:11">                                                                                                 '
cBody += '    <td width=998 colspan=11 valign=top style="width:748.2pt;border:solid windowtext 1.0pt;                                    '
cBody += '    border-top:none;background:#D9D9D9;padding:0cm 5.4pt 0cm 5.4pt;border-color:                                               '
cBody += '    -moz-use-text-color windowtext windowtext">                                                                                '
cBody += '    <p class=MsoNormal align=center style="mso-margin-top-alt:auto;mso-margin-bottom-alt:                                      '
cBody += '    auto;text-align:center"><b><span style="font-size:10.0pt;font-family:Arial">'+Upper(aHeader[HD_OBS])
cBody += '    <u1:p></u1:p></span></b></p>                                                                                               '
cBody += '    </td>                                                                                                                      '
cBody += '   </tr>                                                                                                                       '
cBody += '   <tr style="mso-yfti-irow:19">                                                                                               '
cBody += '    <td width=998 colspan=11 valign=top style="width:748.2pt;border:solid windowtext 1.0pt;                                    '
cBody += '    border-top:none;padding:0cm 5.4pt 0cm 5.4pt;border-color:-moz-use-text-color windowtext windowtext">                       '
cBody += '    <p class=MsoNormal style="mso-margin-top-alt:auto;mso-margin-bottom-alt:auto"><span                                        '
cBody += '   style="font-size:8.0pt;font-family:Arial">' + cMemo + '<u1:p></u1:p></span><span                                            '
cBody += '   style="font-size:8.0pt;mso-bidi-font-size:12.0pt"><o:p></o:p></span></p>                                                    '                                
cBody += '    </td>                                                                                                                      '

cBody += ' <tr style="mso-yfti-irow:24">                                                                                                 '
cBody += '  <td width=998 colspan=11 valign=top style="width:748.2pt;border:solid windowtext 1.0pt;                                      '
cBody += '  border-top:none;background:#D9D9D9;padding:0cm 5.4pt 0cm 5.4pt;border-color:                                                 '
cBody += '  -moz-use-text-color windowtext windowtext">                                                                                  '
cBody += '  <p class=MsoNormal align=center style="mso-margin-top-alt:auto;mso-margin-bottom-alt:                                        '
cBody += '  auto;text-align:center"><b><span style="font-size:10.0pt;font-family:Arial">'+STR0003 //"DADOS PARA ENTREGA DA CARGA"
cBody += '  </span></b><span style="font-size:10.0pt;font-family:                                                                        '
cBody += '  Arial"> </span><b><span style="font-size:7.0pt;font-family:Arial;color:red">                                                 '
cBody += '  </span></b></p>                                                                                                              '
cBody += '  </td>                                                                                                                        '
cBody += ' </tr>                                                                                                                         '
cBody += ' <u1:p></u1:p>                                                                                                                 '
cBody += ' <tr style="mso-yfti-irow:25">                                                                                                 '
cBody += '  <td width=146 valign=top style="width:109.5pt;border:solid windowtext 1.0pt;                                                 '
cBody += '  border-top:none;padding:0cm 0cm 0cm 0cm;border-color:-moz-use-text-color windowtext windowtext">                             '
cBody += '  <p class=MsoNormal align=center style="mso-margin-top-alt:auto;mso-margin-bottom-alt:                                        '
cBody += '  auto;text-align:center"><span style="font-size:8.0pt;mso-bidi-font-size:10.0pt;                                              '
cBody += '  font-family:Arial">'+aHeader[HD_NUMNFC]+'<u1:p></u1:p></span><span style="font-size:8.0pt;                                   '
cBody += '  mso-bidi-font-size:12.0pt"><o:p></o:p></span></p>                                                                            '
cBody += '  </td>                                                                                                                        '
cBody += '  <td width=152 colspan=2 valign=top style="width:114.2pt;border-top:none;                                                     '
cBody += '  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;                                   '
cBody += '  padding:0cm 0cm 0cm 0cm;border-color:-moz-use-text-color windowtext windowtext -moz-use-text-color">                         '
cBody += '  <p class=MsoNormal align=center style="mso-margin-top-alt:auto;mso-margin-bottom-alt:                                        '
cBody += '  auto;text-align:center"><span style="font-size:8.0pt;mso-bidi-font-size:10.0pt;                                              '
cBody += '  font-family:Arial">'+aHeader[HD_CLIDES]+'<u1:p></u1:p></span><span style="font-size:                                         '
cBody += '  8.0pt;mso-bidi-font-size:12.0pt"><o:p></o:p></span></p>                                                                      '
cBody += '  </td>                                                                                                                        '
cBody += '  <td width=123 colspan=3 valign=top style="width:92.5pt;border-top:none;                                                      '
cBody += '  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;                                   '
cBody += '  padding:0cm 0cm 0cm 0cm;border-color:-moz-use-text-color windowtext windowtext -moz-use-text-color">                         '
cBody += '  <p class=MsoNormal align=center style="mso-margin-top-alt:auto;mso-margin-bottom-alt:                                        '
cBody += '  auto;text-align:center"><span style="font-size:8.0pt;mso-bidi-font-size:10.0pt;                                              '
cBody += '  font-family:Arial">'+aHeader[HD_CGC]+'<u1:p></u1:p></span><span style="font-size:8.0pt;                                      '
cBody += '  mso-bidi-font-size:12.0pt"><o:p></o:p></span></p>                                                                            '
cBody += '  </td>                                                                                                                        '
cBody += '  <td width=153 valign=top style="width:114.5pt;border-top:none;border-left:                                                   '
cBody += '  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;                                               '
cBody += '  padding:0cm 5.4pt 0cm 5.4pt;border-color:-moz-use-text-color windowtext windowtext -moz-use-text-color">                     '
cBody += '  <p class=MsoNormal align=center style="mso-margin-top-alt:auto;mso-margin-bottom-alt:                                        '
cBody += '  auto;text-align:center"><span style="font-size:8.0pt;mso-bidi-font-size:10.0pt;                                              '
cBody += '  font-family:Arial">'+aHeader[HD_END]+'<u1:p></u1:p></span><span style="font-size:8.0pt;                                      '
cBody += '  mso-bidi-font-size:12.0pt"><o:p></o:p></span></p>                                                                            '
cBody += '  </td>                                                                                                                        '
cBody += '  <td width=88 valign=top style="width:65.8pt;border-top:none;border-left:none;                                                '
cBody += '  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;                                                    '
cBody += '  padding:0cm 5.4pt 0cm 5.4pt;border-color:-moz-use-text-color windowtext windowtext -moz-use-text-color">                     '
cBody += '  <p class=MsoNormal align=center style="mso-margin-top-alt:auto;mso-margin-bottom-alt:                                        '
cBody += '  auto;text-align:center"><span style="font-size:8.0pt;mso-bidi-font-size:10.0pt;                                              '
cBody += '  font-family:Arial">'+aHeader[HD_CEP]+'<u1:p></u1:p></span><span style="font-size:8.0pt;                                      '
cBody += '  mso-bidi-font-size:12.0pt"><o:p></o:p></span></p>                                                                            '
cBody += '  </td>                                                                                                                        '
cBody += '  <td width=93 valign=top style="width:69.8pt;border-top:none;border-left:none;                                                '
cBody += '  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;                                                    '
cBody += '  padding:0cm 5.4pt 0cm 5.4pt;border-color:-moz-use-text-color windowtext windowtext -moz-use-text-color">                     '
cBody += '  <p class=MsoNormal align=center style="mso-margin-top-alt:auto;mso-margin-bottom-alt:                                        '
cBody += '  auto;text-align:center"><span style="font-size:8.0pt;mso-bidi-font-size:10.0pt;                                              '
cBody += '  font-family:Arial">'+aHeader[HD_NOTA]+'<u1:p></u1:p></span><span style="font-size:8.0pt;                                     '
cBody += '  mso-bidi-font-size:12.0pt"><o:p></o:p></span></p>                                                                            '
cBody += '  </td>                                                                                                                        '
cBody += '  <td width=100 colspan=2 valign=top style="width:74.85pt;border-top:none;                                                     '
cBody += '  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;                                   '
cBody += '  padding:0cm 5.4pt 0cm 5.4pt;border-color:-moz-use-text-color windowtext windowtext -moz-use-text-color">                     '
cBody += '  <p class=MsoNormal align=center style="mso-margin-top-alt:auto;mso-margin-bottom-alt:                                        '
cBody += '  auto;text-align:center"><span style="font-size:8.0pt;mso-bidi-font-size:10.0pt;                                              '
cBody += '  font-family:Arial">'+aHeader[HD_PRZENT]+'<u1:p></u1:p></span><span style="font-size:8.0pt;                                   '
cBody += '  mso-bidi-font-size:12.0pt"><o:p></o:p></span></p>                                                                            '
cBody += '  </td>                                                                                                                        '
cBody += ' </tr>                                                                                                                         '
cBody += '                                                                                                                               '


DTX->(dbSetOrder(4))
DTX->(MsSeek(xFilial("DTX")+ DTV->(DTV_NUMAWB+DTV_DIGAWB+DTV_CODCIA+DTV_LOJCIA)) )
Do While DTX->(!Eof()) .And. DTX->(DTX_FILIAL+DTX_NUMAWB+DTX_DIGAWB+DTX_CODCIA+DTX_LOJCIA) == xFilial("DTX") + DTV->(DTV_NUMAWB+DTV_DIGAWB+DTV_CODCIA+DTV_LOJCIA)
	DUD->(dbSetOrder(5)) //DUD_FILIAL+DUD_FILORI+DUD_VIAGEM+DUD_FILMAN+DUD_MANIFE
	DUD->(MsSeek(xFilial("DUD")+ DTX->(DTX_FILORI+DTX_VIAGEM+DTX_FILMAN+DTX_MANIFE)) )
	Do While !DUD->(Eof()) .And. DUD->(DUD_FILIAL+DUD_FILORI+DUD_VIAGEM+DUD_FILMAN+DUD_MANIFE) == xFilial("DUD")+DTX->(DTX_FILORI+DTX_VIAGEM+DTX_FILMAN+DTX_MANIFE)
		If aScan( aDoctos, { |X| X[2] == DUD->DUD_DOC }) == 0
			AADD(aDoctos, {DUD->DUD_FILDOC,DUD->DUD_DOC,DUD->DUD_SERIE} )
		EndIf
		
		DTC->(dbSetOrder(3))
		DTC->(MsSeek(xFilial("DTC")+DUD->(DUD_FILDOC+DUD_DOC+DUD_SERIE)))
		Do While !DTC->(Eof()) .And. DTC->(DTC_FILIAL+DTC_FILDOC+DTC_DOC+DTC_SERIE) == xFilial("DUD")+DUD->(DUD_FILDOC+DUD_DOC+DUD_SERIE)
			If aScan( aNotas, { |X| X[1] + x[2] == DTC->DTC_NUMNFC+DTC->DTC_SERNFC }) == 0
				AADD(aNotas, {DTC->DTC_NUMNFC,DTC->DTC_SERNFC} )
			EndIf
			DTC->(dbSkip())
		EndDo
		DUD->(dbSkip())
	EndDo
	DTX->(dbSkip())
EndDo


For nX := 1 To Len(aDoctos)
	
	DT6->(dbSetOrder(1))
	DT6->(MsSeek(xFilial("DT6")+ aDoctos[nx,1]+ aDoctos[nx,2]+ aDoctos[nx,3] ))
	SA1->(dbSetOrder(1))
	SA1->(MsSeek(xFilial("SA1")+ DT6->DT6_CLIDES + DT6->DT6_LOJDES))
	
	
	cBody += ' <tr style="mso-yfti-irow:26">                                                                                                 '
	cBody += '  <td width=146 valign=top style="width:109.5pt;border:solid windowtext 1.0pt;                                                 '
	cBody += '  border-top:none;padding:0cm 5.4pt 0cm 5.4pt;border-color:-moz-use-text-color windowtext windowtext">                         '
	cBody += '  <p class=MsoNormal style="mso-margin-top-alt:auto;mso-margin-bottom-alt:auto"><span                                          '
	cBody += '  style="font-size:8.0pt;font-family:Arial">' + aDoctos[nx,2] +'/'+ aDoctos[nx,3]+ '<u1:p></u1:p></span><span                  '
	cBody += '  style="font-size:8.0pt;mso-bidi-font-size:12.0pt"><o:p></o:p></span></p>                                                     '
	cBody += '  </td>                                                                                                                        '
	cBody += '  <td width=152 colspan=2 valign=top style="width:114.2pt;border-top:none;                                                     '
	cBody += '  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;                                   '
	cBody += '  padding:0cm 5.4pt 0cm 5.4pt;border-color:-moz-use-text-color windowtext windowtext -moz-use-text-color">                     '
	cBody += '  <p class=MsoNormal style="mso-margin-top-alt:auto;mso-margin-bottom-alt:auto"><span                                          '
	cBody += '  style="font-size:8.0pt;font-family:Arial"> <span class=SpellE><span                                                          '
	cBody += '  class=spelle><span style="font-family:Arial">' + AllTrim(SA1->A1_NOME) + '</span></span></span>                              '
	cBody += '  <u1:p></u1:p></span><span style="font-size:8.0pt;mso-bidi-font-size:12.0pt"><o:p></o:p></span></p>                           '
	cBody += '  </td>                                                                                                                        '
	cBody += '  <td width=123 colspan=3 valign=top style="width:92.5pt;border-top:none;                                                      '
	cBody += '  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;                                   '
	cBody += '  padding:0cm 5.4pt 0cm 5.4pt;border-color:-moz-use-text-color windowtext windowtext -moz-use-text-color">                     '
	cBody += '  <p class=MsoNormal style="mso-margin-top-alt:auto;mso-margin-bottom-alt:auto"><span                                          '
	cBody += '  style="font-size:8.0pt;font-family:Arial">' + TRANSFORM(SA1->A1_CGC,If(SA1->A1_PESSOA=='J','@R 99.999.999/9999-99','@R 999.999.999-99')) + '<u1:p></u1:p></span><span '
	cBody += '  style="font-size:8.0pt;mso-bidi-font-size:12.0pt"><o:p></o:p></span></p>                                                     '
	cBody += '  </td>                                                                                                                        '
	cBody += '  <td width=153 valign=top style="width:114.5pt;border-top:none;border-left:                                                   '
	cBody += '  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;                                               '
	cBody += '  padding:0cm 5.4pt 0cm 5.4pt;border-color:-moz-use-text-color windowtext windowtext -moz-use-text-color">                     '
	cBody += '  <p class=MsoNormal style="mso-margin-top-alt:auto;mso-margin-bottom-alt:auto"><span                                          '
	cBody += '  style="font-size:8.0pt;font-family:Arial"><span class=SpellE><span                                                           '
	cBody += '  class=spelle><span style="font-family:Arial">' + AllTrim(SA1->A1_END) + '</span></span></span>                               '
	cBody += '  <u1:p></u1:p></span><span style="font-size:8.0pt;mso-bidi-font-size:12.0pt"><o:p></o:p></span></p>                           '
	cBody += '  </td>                                                                                                                        '
	cBody += '  <td width=88 valign=top style="width:65.8pt;border-top:none;border-left:none;                                                '
	cBody += '  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;                                                    '
	cBody += '  padding:0cm 5.4pt 0cm 5.4pt;border-color:-moz-use-text-color windowtext windowtext -moz-use-text-color">                     '
	cBody += '  <p class=MsoNormal style="mso-margin-top-alt:auto;mso-margin-bottom-alt:auto"><span                                          '
	cBody += '  style="font-size:8.0pt;font-family:Arial">' + Alltrim(Transform(SA1->A1_CEP, "@R 99999-999")) + '<u1:p></u1:p></span><span   '
	cBody += '  style="font-size:8.0pt;mso-bidi-font-size:12.0pt"><o:p></o:p></span></p>                                                     '
	cBody += '  </td>                                                                                                                        '
	cBody += '  <td width=93 valign=top style="width:69.8pt;border-top:none;border-left:none;                                                '
	cBody += '  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;                                                    '
	cBody += '  padding:0cm 5.4pt 0cm 5.4pt;border-color:-moz-use-text-color windowtext windowtext -moz-use-text-color">                     '
	cBody += '  <p class=MsoNormal style="mso-margin-top-alt:auto;mso-margin-bottom-alt:auto"><span                                          '
	cBody += '  style="font-size:8.0pt;font-family:Arial"> <span class=SpellE><span                                                          '
	cBody += '  class=spelle><span style="font-family:Arial">' + If (Len(aNotas)>0,aNotas[nX,1],'') + '</span></span></span> <u1:p></u1:p>   '
	cBody += '  </span><span '
	cBody += '  style="font-size:8.0pt;mso-bidi-font-size:12.0pt"><o:p></o:p></span></p>                                                     '
	cBody += '  </td>                                                                                                                        '
	cBody += '  <td width=100 colspan=2 valign=top style="width:74.85pt;border-top:none;                                                     '
	cBody += '  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;                                   '
	cBody += '  padding:0cm 5.4pt 0cm 5.4pt;border-color:-moz-use-text-color windowtext windowtext -moz-use-text-color">                     '
	cBody += '  <p class=MsoNormal align=center style="mso-margin-top-alt:auto;mso-margin-bottom-alt:auto"><span                             '
	cBody += '  style="font-size:8.0pt;font-family:Arial"> ' + DtoC(DT6->DT6_PRZENT) + ' <span class=grame><span                             '
	cBody += '  style="font-family:Arial"> <u1:p></u1:p></span></span></span><span                                                           '
	cBody += '  style="font-size:8.0pt;mso-bidi-font-size:12.0pt"><o:p></o:p></span></p>                                                     '
	cBody += '  </td>                                                                                                                        '
	cBody += ' </tr>                                                                                                                         '
	
Next nX

cBody += ' <![if !supportMisalignedColumns]>                                                                                            	  '
cBody += ' <tr height=0>                                                                                                                    '
cBody += '  <td width=144 style="border:none"></td>                                                                                      	  '
cBody += '  <td width=22 style="border:none"></td>                                                                                          '
cBody += '  <td width=75 style="border:none"></td>                                                                                          '
cBody += '  <td width=32 style="border:none"></td>                                                                                          ' 
cBody += '  <td width=57 style="border:none"></td>                                                                                          '
cBody += '  <td width=11 style="border:none"></td>                                                                                          '
cBody += '  <td width=98 style="border:none"></td>                                                                                          '
cBody += '  <td width=79 style="border:none"></td>                                                                                          '
cBody += '  <td width=63 style="border:none"></td>                                                                                          '
cBody += '  <td width=8 style="border:none"></td>                                                                                           '
cBody += '  <td width=70 style="border:none"></td>                                                                                          '
cBody += ' </tr>                                                                                                                            '
cBody += ' <![endif]>                                                                                                                       '
cBody += '                                                                                                                                  '
cBody += '</table>                                                                                                                          '
cBody += '<p class=MsoNormal style="mso-margin-top-alt:auto;mso-margin-bottom-alt:auto"><u1:p>&nbsp;</u1:p></p>                             '
cBody += '</div>                                                                                                                            ' 
cBody += '</div>                                                                                                                            '
cBody += '</div>                                                                                                                            '
cBody += '</div>                                                                                                                            '
cBody += '</div>                                                                                                                            '
cBody += '</body>                                                                                                                           '
cBody += '</html>                                                                                                                           '

If !lCancela
	MemoWrite(cPath+'PRE'+M->DY8_NUMPRE+".HTM",cBody)
Else
	MemoWrite(cPath+'CAN'+M->DY8_NUMPRE+".HTM",cBody)
EndIf

For nX := 1 To Len(aArea)
	RestArea(aArea[nX])
Next nX

Return cBody

/*
Programa : EECRDM.CH
Objetivo : manter definicoes genericas para uso no SIGAEEC
Autor    : Cristiano A. Ferreira
Data/Hora: 11/07/00 15:26
Obs      : Em todos os Rdmakes deve haver uma chamada para este header
           Nao eh necessario incluir o rwmake.ch nos prg's
*/

#define _AVRDM

#include "EEC.ch"

#ifndef CRLF
   #define CRLF chr(13)+chr(10)
#endif

//-------- COPIA DO RWMAKE.CH

#Translate User Function <cNome> => Function U_<cNome>
#Translate HTML Function <cNome> => Function H_<cNome>

#xtranslate oSend( <o>,<m> [,<param,...>] ) => OSEND <o> METHOD <m> [ PARAM \{<param>\} ]
#xtranslate OSEND <o> METHOD <m> [PARAM <param>] => PT_oSend( <(o)>,<m>,<o> [,<param> ] )
#xtranslate OSEND <o>() METHOD <m> [PARAM <param>] => PT_oSend( <(o)>+"()",<m>, [,<param>] )

//-------- COPIA DO SIGAWIN.CH

#xcommand DEFINE MSDIALOG <oDlg> ;
				 [ <resource: NAME, RESNAME, RESOURCE> <cResName> ] ;
				 [ TITLE <cTitle> ] ;
				 [ FROM <nTop>, <nLeft> TO <nBottom>, <nRight> ] ;
				 [ <lib: LIBRARY, DLL> <hResources> ] ;
				 [ <vbx: VBX> ] ;
				 [ STYLE <nStyle> ] ;
				 [ <color: COLOR, COLORS> <nClrText> [,<nClrBack> ] ] ;
				 [ BRUSH <oBrush> ] ;
				 [ <of: WINDOW, DIALOG, OF> <oWnd> ] ;
				 [ <pixel: PIXEL> ] ;
				 [ ICON <oIco> ] ;
				 [ FONT <oFont> ] ;
				 [ <status: STATUS> ] ;
		 => ;
			 <oDlg> = MsDialog():New( <nTop>, <nLeft>, <nBottom>, <nRight>,;
					  <cTitle>, <cResName>, <hResources>, <.vbx.>, <nStyle>,;
					  <nClrText>, <nClrBack>, <oBrush>, <oWnd>, <.pixel.>,;
					  <oIco>, <oFont> , <.status.> )

#xcommand ACTIVATE MSDIALOG <oDlg> ;
				 [ <center: CENTER, CENTERED> ] ;
				 [ <NonModal: NOWAIT, NOMODAL> ] ;
				 [ WHEN <uWhen> ] ;
				 [ VALID <uValid> ] ;
				 [ ON [ LEFT ] CLICK <uClick> ] ;
				 [ ON INIT <uInit> ] ;
				 [ ON MOVE <uMoved> ] ;
				 [ ON PAINT <uPaint> ] ;
				 [ ON RIGHT CLICK <uRClicked> ] ;
		  => ;
			 <oDlg>:Activate( <oDlg>:bLClicked [ := <{uClick}> ], ;
									<oDlg>:bMoved	  [ := <{uMoved}> ], ;
									<oDlg>:bPainted  [ := <{uPaint}> ], ;
									<.center.>, [{|Self|<uValid>}],;
									[ ! <.NonModal.> ], [{|Self|<uInit>}],;
									<oDlg>:bRClicked [ := <{uRClicked}> ],;
									[{|Self|<uWhen>}] )

#command @ <nRow>, <nCol> MSGET [ <oGet> VAR ] <uVar> ;
				[ <dlg: OF, WINDOW, DIALOG> <oWnd> ] ;
				[ PICTURE <cPict> ] ;
				[ VALID <ValidFunc> ] ;
				[ <color:COLOR,COLORS> <nClrFore> [,<nClrBack>] ] ;
				[ SIZE <nWidth>, <nHeight> ]	;
				[ FONT <oFont> ] ;
				[ <design: DESIGN> ] ;
				[ CURSOR <oCursor> ] ;
				[ <pixel: PIXEL> ] ;
				[ MESSAGE <cMsg> ] ;
				[ <update: UPDATE> ] ;
				[ WHEN <uWhen> ] ;
				[ <lCenter: CENTER, CENTERED> ] ;
				[ <lRight: RIGHT> ] ;
				[ ON CHANGE <uChange> ] ;
				[ <readonly: READONLY, NO MODIFY> ] ;
				[ <pass: PASSWORD> ] ;
				[ F3 <cAlias> ];
				[ <lNoBorder: NO BORDER, NOBORDER> ] ;
				[ <help:HELPID, HELP ID> <nHelpId> ] ;
				[ <lHasButton: HASBUTTON> ] ;
		 => ;
			 [ <oGet> := ] TGet():New( <nRow>, <nCol>, bSETGET(<uVar>),;
				 [<oWnd>], <nWidth>, <nHeight>, <cPict>, <{ValidFunc}>,;
				 <nClrFore>, <nClrBack>, <oFont>, <.design.>,;
				 <oCursor>, <.pixel.>, <cMsg>, <.update.>, <{uWhen}>,;
				 <.lCenter.>, <.lRight.>,;
				 [\{|nKey, nFlags, Self| <uChange>\}], <.readonly.>,;
				 <.pass.> ,<cAlias>,<(uVar)>,,[<.lNoBorder.>], [<nHelpId>], [<.lHasButton.>] )

#xcommand DEFINE SBUTTON [ <oBtn> ] ;
				 [ FROM <nTop>,<nLeft> ] ;
				 [ TYPE <nType> ] ;
				 [ <action:ACTION,EXEC> <uAction> ] ;
				 [ OF <oWnd> ] ;
				 [ <mode: ENABLE > ] ;
				 [ ONSTOP <cMsg> ] ;
				 [ WHEN	 <uWhen>] ;
		=> ;
			[ <oBtn> := ] SButton():New( <nTop>, <nLeft>,<nType>, <{ uAction }>,;
													  <oWnd>, <.mode.>, <cMsg>,<{ uWhen}>)

//SigaTTS
#xcommand  BEGIN TRANSACTION => Begin Sequence; BeginTran()
#xcommand  BEGIN TRANSACTION EXTENDED => Begin Sequence; BeginTran()
#Translate END TRANSACTION   => End Sequence ; EndTran()
#Translate END TRANSACTION EXTENDED   => End Sequence ; EndTran()

#Translate Enchoice => Zero();MsMGet():New


//-------- COPIA DO FIVEWIN.CH

/*
!short: FiveWin main Header File */

#ifndef _FIVEWIN_CH
#define _FIVEWIN_CH

/*----------------------------------------------------------------------------//
!short: ACCESSING / SETTING Variables */

#xtranslate bSETGET(<uVar>) => ;
    { | u | If( PCount() == 0, <uVar>, <uVar> := u ) }

/*----------------------------------------------------------------------------//
!short: Default parameters management */

#xcommand DEFAULT <uVar1> := <uVal1> ;
      [, <uVarN> := <uValN> ] => ;
    <uVar1> := If( <uVar1> == nil, <uVal1>, <uVar1> ) ;;
   [ <uVarN> := If( <uVarN> == nil, <uValN>, <uVarN> ); ]

#xcommand @ <nRow>, <nCol> BUTTON [ <oBtn> PROMPT ] <cCaption> ;
     [ SIZE <nWidth>, <nHeight> ] ;
     [ ACTION <uAction> ] ;
     [ <default: DEFAULT> ] ;
     [ <of:OF, WINDOW, DIALOG> <oWnd> ] ;
     [ <help:HELP, HELPID, HELP ID> <nHelpId> ] ;
     [ FONT <oFont> ] ;
     [ <pixel: PIXEL> ] ;
     [ <design: DESIGN> ] ;
     [ MESSAGE <cMsg> ] ;
     [ <update: UPDATE> ] ;
     [ WHEN <WhenFunc> ] ;
     [ VALID <uValid> ] ;
     [ <lCancel: CANCEL> ] ;
    => ;
  [ <oBtn> := ] TButton():New( <nRow>, <nCol>, <cCaption>, <oWnd>,;
    <{uAction}>, <nWidth>, <nHeight>, <nHelpId>, <oFont>, <.default.>,;
    <.pixel.>, <.design.>, <cMsg>, <.update.>, <{WhenFunc}>,;
    <{uValid}>, <.lCancel.> )

/*----------------------------------------------------------------------------//
!short: CHECKBOX */

#xcommand @ <nRow>, <nCol> CHECKBOX [ <oCbx> VAR ] <lVar> ;
     [ PROMPT <cCaption> ] ;
     [ <of:OF, WINDOW, DIALOG> <oWnd> ] ;
     [ SIZE <nWidth>, <nHeight> ] ;
     [ <help:HELPID, HELP ID> <nHelpId> ] ;
     [ FONT <oFont> ] ;
     [ <change: ON CLICK, ON CHANGE> <uClick> ] ;
     [ VALID   <ValidFunc> ] ;
     [ <color: COLOR, COLORS> <nClrFore> [,<nClrBack>] ] ;
     [ <design: DESIGN> ] ;
     [ <pixel: PIXEL> ] ;
     [ MESSAGE <cMsg> ] ;
     [ <update: UPDATE> ] ;
     [ WHEN <WhenFunc> ] ;
    => ;
  [ <oCbx> := ] TCheckBox():New( <nRow>, <nCol>, <cCaption>,;
     [bSETGET(<lVar>)], <oWnd>, <nWidth>, <nHeight>, <nHelpId>,;
     [<{uClick}>], <oFont>, <{ValidFunc}>, <nClrFore>, <nClrBack>,;
     <.design.>, <.pixel.>, <cMsg>, <.update.>, <{WhenFunc}> )

/*----------------------------------------------------------------------------//
!short: COMBOBOX */

#xcommand @ <nRow>, <nCol> COMBOBOX [ <oCbx> VAR ] <cVar> ;
     [ <items: ITEMS, PROMPTS> <aItems> ] ;
     [ SIZE <nWidth>, <nHeight> ] ;
     [ <dlg:OF,WINDOW,DIALOG> <oWnd> ] ;
     [ <help:HELPID, HELP ID> <nHelpId> ] ;
     [ ON CHANGE <uChange> ] ;
     [ VALID <uValid> ] ;
     [ <color: COLOR,COLORS> <nClrText> [,<nClrBack>] ] ;
     [ <pixel: PIXEL> ] ;
     [ FONT <oFont> ] ;
     [ <update: UPDATE> ] ;
     [ MESSAGE <cMsg> ] ;
     [ WHEN <uWhen> ] ;
     [ <design: DESIGN> ] ;
     [ BITMAPS <acBitmaps> ] ;
     [ ON DRAWITEM <uBmpSelect> ] ;
     => ;
   [ <oCbx> := ] TComboBox():New( <nRow>, <nCol>, bSETGET(<cVar>),;
     <aItems>, <nWidth>, <nHeight>, <oWnd>, <nHelpId>,;
     [{|Self|<uChange>}], <{uValid}>, <nClrText>, <nClrBack>,;
     <.pixel.>, <oFont>, <cMsg>, <.update.>, <{uWhen}>,;
     <.design.>, <acBitmaps>, [{|nItem|<uBmpSelect>}] )

/*----------------------------------------------------------------------------//
!short: LISTBOX */

#xcommand @ <nRow>, <nCol> LISTBOX [ <oLbx> VAR ] <cnVar> ;
     [ <items: ITEMS, PROMPTS> <aList>  ] ;
     [ SIZE <nWidth>, <nHeight> ] ;
     [ ON CHANGE <uChange> ] ;
     [ ON [ LEFT ] DBLCLICK <uLDblClick> ] ;
     [ <of: OF, WINDOW, DIALOG > <oWnd> ] ;
     [ VALID <uValid> ] ;
     [ <color: COLOR,COLORS> <nClrFore> [,<nClrBack>] ] ;
     [ <pixel: PIXEL> ] ;
     [ <design: DESIGN> ] ;
     [ FONT <oFont> ] ;
     [ MESSAGE <cMsg> ] ;
     [ <update: UPDATE> ] ;
     [ WHEN <uWhen> ] ;
     [ BITMAPS <aBitmaps> ] ;
     [ ON DRAWITEM <uBmpSelect> ] ;
     [ <multi: MULTI, MULTIPLE, MULTISEL> ] ;
     [ <sort: SORT> ] ;
     [ ON RIGHT CLICK <uRClick> ] ;
    => ;
   [ <oLbx> := ] TListBox():New( <nRow>, <nCol>, bSETGET(<cnVar>),;
     <aList>, <nWidth>, <nHeight>, <{uChange}>, <oWnd>, <{uValid}>,;
     <nClrFore>, <nClrBack>, <.pixel.>, <.design.>, <{uLDblClick}>,;
     <oFont>, <cMsg>, <.update.>, <{uWhen}>, <aBitmaps>,;
     [{|nItem|<uBmpSelect>}], <.multi.>, <.sort.>,;
     [\{|nRow,nCol,nFlags|<uRClick>\}] )

/*----------------------------------------------------------------------------//
!short: LISTBOX - BROWSE */
// Warning: SELECT <cField>  ==> Must be the Field key of the current INDEX !!!

#xcommand @ <nRow>, <nCol> LISTBOX [ <oBrw> ] FIELDS [<Flds,...>] ;
      [ ALIAS <cAlias> ] ;
      [ <sizes:FIELDSIZES, SIZES, COLSIZES> <aColSizes,...> ] ;
      [ <head:HEAD,HEADER,HEADERS,TITLE> <aHeaders,...> ] ;
      [ SIZE <nWidth>, <nHeigth> ] ;
      [ <dlg:OF,DIALOG> <oDlg> ] ;
      [ SELECT <cField> FOR <uValue1> [ TO <uValue2> ] ] ;
      [ ON CHANGE <uChange> ] ;
      [ ON [ LEFT ] CLICK <uLClick> ] ;
      [ ON [ LEFT ] DBLCLICK <uLDblClick> ] ;
      [ ON RIGHT CLICK <uRClick> ] ;
      [ FONT <oFont> ] ;
      [ CURSOR <oCursor> ] ;
      [ <color: COLOR, COLORS> <nClrFore> [,<nClrBack>] ] ;
      [ MESSAGE <cMsg> ] ;
      [ <update: UPDATE> ] ;
      [ <pixel: PIXEL> ] ;
      [ WHEN <uWhen> ] ;
      [ <design: DESIGN> ] ;
      [ VALID <uValid> ] ;
      [ ACTION <uAction,...> ] ;
    => ;
   [ <oBrw> := ] TWBrowse():New( <nRow>, <nCol>, <nWidth>, <nHeigth>,;
      [\{|| \{<Flds> \} \}], ;
      [\{<aHeaders>\}], [\{<aColSizes>\}], ;
      <oDlg>, <(cField)>, <uValue1>, <uValue2>,;
      [<{uChange}>],;
      [\{|nRow,nCol,nFlags|<uLDblClick>\}],;
      [\{|nRow,nCol,nFlags|<uRClick>\}],;
      <oFont>, <oCursor>, <nClrFore>, <nClrBack>, <cMsg>,;
      <.update.>, <cAlias>, <.pixel.>, <{uWhen}>,;
      <.design.>, <{uValid}>, <{uLClick}>,;
      [\{<{uAction}>\}] )

/*----------------------------------------------------------------------------//
!short: RADIOBUTTONS */

#xcommand @ <nRow>, <nCol> RADIO [ <oRadMenu> VAR ] <nVar> ;
     [ <prm: PROMPT, ITEMS> <cItems,...> ] ;
     [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
     [ <help:HELPID, HELP ID> <nHelpId,...> ] ;
     [ <change: ON CLICK, ON CHANGE> <uChange> ] ;
     [ COLOR <nClrFore> [,<nClrBack>] ] ;
     [ MESSAGE <cMsg> ] ;
     [ <update: UPDATE> ] ;
     [ WHEN <uWhen> ] ;
     [ SIZE <nWidth>, <nHeight> ] ;
     [ VALID <uValid> ] ;
     [ <lDesign: DESIGN> ] ;
     [ <lLook3d: 3D> ] ;
     [ <lPixel: PIXEL> ] ;
     => ;
   [ <oRadMenu> := ] TRadMenu():New( <nRow>, <nCol>, {<cItems>},;
     [bSETGET(<nVar>)], <oWnd>, [{<nHelpId>}], <{uChange}>,;
     <nClrFore>, <nClrBack>, <cMsg>, <.update.>, <{uWhen}>,;
     <nWidth>, <nHeight>, <{uValid}>, <.lDesign.>, <.lLook3d.>,;
     <.lPixel.> )

/*----------------------------------------------------------------------------//
!short: BITMAP */

#xcommand @ <nRow>, <nCol> BITMAP [ <oBmp> ] ;
     [ <resource: NAME, RESNAME, RESOURCE> <cResName> ] ;
     [ <file: FILE, FILENAME, DISK> <cBmpFile> ] ;
     [ <NoBorder:NOBORDER, NO BORDER> ] ;
     [ SIZE <nWidth>, <nHeight> ] ;
     [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
     [ <lClick: ON CLICK, ON LEFT CLICK> <uLClick> ] ;
     [ <rClick: ON RIGHT CLICK> <uRClick> ] ;
     [ <scroll: SCROLL> ] ;
     [ <adjust: ADJUST> ] ;
     [ CURSOR <oCursor> ] ;
     [ <pixel: PIXEL>   ] ;
     [ MESSAGE <cMsg>   ] ;
     [ <update: UPDATE> ] ;
     [ WHEN <uWhen> ] ;
     [ VALID <uValid> ] ;
     [ <lDesign: DESIGN> ] ;
     => ;
   [ <oBmp> := ] TBitmap():New( <nRow>, <nCol>, <nWidth>, <nHeight>,;
     <cResName>, <cBmpFile>, <.NoBorder.>, <oWnd>,;
     [\{ |nRow,nCol,nKeyFlags| <uLClick> \} ],;
     [\{ |nRow,nCol,nKeyFlags| <uRClick> \} ], <.scroll.>,;
     <.adjust.>, <oCursor>, <cMsg>, <.update.>,;
     <{uWhen}>, <.pixel.>, <{uValid}>, <.lDesign.> )

#xcommand DEFINE BITMAP [<oBmp>] ;
     [ <resource: NAME, RESNAME, RESOURCE> <cResName> ] ;
     [ <file: FILE, FILENAME, DISK> <cBmpFile> ] ;
     [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
     => ;
   [ <oBmp> := ] TBitmap():Define( <cResName>, <cBmpFile>, <oWnd> )

/*----------------------------------------------------------------------------//
!short: SAY  */

#xcommand @ <nRow>, <nCol> SAY [ <oSay> <label: PROMPT,VAR > ] <cText> ;
     [ PICTURE <cPict> ] ;
     [ <dlg: OF,WINDOW,DIALOG > <oWnd> ] ;
     [ FONT <oFont> ]  ;
     [ <lCenter: CENTERED, CENTER > ] ;
     [ <lRight:  RIGHT >  ] ;
     [ <lBorder: BORDER > ] ;
     [ <lPixel: PIXEL, PIXELS > ] ;
     [ <color: COLOR,COLORS > <nClrText> [,<nClrBack> ] ] ;
     [ SIZE <nWidth>, <nHeight> ] ;
     [ <design: DESIGN >  ] ;
     [ <update: UPDATE >  ] ;
     [ <lShaded: SHADED, SHADOW > ] ;
     [ <lBox:  BOX   >  ] ;
     [ <lRaised: RAISED > ] ;
    => ;
   [ <oSay> := ] TSay():New( <nRow>, <nCol>, <{cText}>,;
     [<oWnd>], [<cPict>], <oFont>, <.lCenter.>, <.lRight.>, <.lBorder.>,;
     <.lPixel.>, <nClrText>, <nClrBack>, <nWidth>, <nHeight>,;
     <.design.>, <.update.>, <.lShaded.>, <.lBox.>, <.lRaised.> )

/*----------------------------------------------------------------------------//
!short: GET  */

#command @ <nRow>, <nCol> GET [ <oGet> VAR ] <uVar> ;
    [ <dlg: OF, WINDOW, DIALOG> <oWnd> ] ;
    [ <memo: MULTILINE, MEMO, TEXT> ] ;
    [ <color:COLOR,COLORS> <nClrFore> [,<nClrBack>] ] ;
    [ SIZE <nWidth>, <nHeight> ] ;
    [ FONT <oFont> ] ;
    [ <hscroll: HSCROLL> ] ;
    [ CURSOR <oCursor> ] ;
    [ <pixel: PIXEL> ] ;
    [ MESSAGE <cMsg> ] ;
    [ <update: UPDATE> ] ;
    [ WHEN <uWhen> ] ;
    [ <lCenter: CENTER, CENTERED> ] ;
    [ <lRight: RIGHT> ] ;
    [ <readonly: READONLY, NO MODIFY> ] ;
    [ VALID <uValid> ] ;
    [ ON CHANGE <uChange> ] ;
    [ <lDesign: DESIGN> ] ;
    [ <lNoBorder: NO BORDER, NOBORDER> ] ;
    [ <lNoVScroll: NO VSCROLL> ] ;
     => ;
   [ <oGet> := ] TMultiGet():New( <nRow>, <nCol>, bSETGET(<uVar>),;
     [<oWnd>], <nWidth>, <nHeight>, <oFont>, <.hscroll.>,;
     <nClrFore>, <nClrBack>, <oCursor>, <.pixel.>,;
     <cMsg>, <.update.>, <{uWhen}>, <.lCenter.>,;
     <.lRight.>, <.readonly.>, <{uValid}>,;
     [\{|nKey, nFlags, Self| <uChange>\}], <.lDesign.>,;
     [<.lNoBorder.>], [<.lNoVScroll.>] )

#command @ <nRow>, <nCol> GET [ <oGet> VAR ] <uVar> ;
    [ <dlg: OF, WINDOW, DIALOG> <oWnd> ] ;
    [ PICTURE <cPict> ] ;
    [ VALID <ValidFunc> ] ;
    [ <color:COLOR,COLORS> <nClrFore> [,<nClrBack>] ] ;
    [ SIZE <nWidth>, <nHeight> ]  ;
    [ FONT <oFont> ] ;
    [ <design: DESIGN> ] ;
    [ CURSOR <oCursor> ] ;
    [ <pixel: PIXEL> ] ;
    [ MESSAGE <cMsg> ] ;
    [ <update: UPDATE> ] ;
    [ WHEN <uWhen> ] ;
    [ <lCenter: CENTER, CENTERED> ] ;
    [ <lRight: RIGHT> ] ;
    [ ON CHANGE <uChange> ] ;
    [ <readonly: READONLY, NO MODIFY> ] ;
    [ <pass: PASSWORD> ] ;
    [ <lNoBorder: NO BORDER, NOBORDER> ] ;
    [ <help:HELPID, HELP ID> <nHelpId> ] ;
     => ;
   [ <oGet> := ] TGet():New( <nRow>, <nCol>, bSETGET(<uVar>),;
     [<oWnd>], <nWidth>, <nHeight>, <cPict>, <{ValidFunc}>,;
     <nClrFore>, <nClrBack>, <oFont>, <.design.>,;
     <oCursor>, <.pixel.>, <cMsg>, <.update.>, <{uWhen}>,;
     <.lCenter.>, <.lRight.>,;
     [\{|nKey, nFlags, Self| <uChange>\}], <.readonly.>,;
     <.pass.>, [<.lNoBorder.>], <nHelpId> )

/*----------------------------------------------------------------------------//
!short: BOX - GROUPS */

#xcommand @ <nTop>, <nLeft> [ GROUP <oGroup> ] TO <nBottom>, <nRight > ;
     [ <label:LABEL,PROMPT> <cLabel> ] ;
     [ OF <oWnd> ] ;
     [ COLOR <nClrFore> [,<nClrBack>] ] ;
     [ <lPixel: PIXEL> ] ;
     [ <lDesign: DESIGN> ] ;
     => ;
   [ <oGroup> := ] TGroup():New( <nTop>, <nLeft>, <nBottom>, <nRight>,;
     <cLabel>, <oWnd>, <nClrFore>, <nClrBack>, <.lPixel.>,;
     [<.lDesign.>] )
#endif

//----------------------------------------------------------------------------\\
// FIM DO ARQUIVO EECRDM.CH                                                   \\
//----------------------------------------------------------------------------\\

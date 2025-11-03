"Exemplos de screen com código"

*&---------------------------------------------------------------------*
*& Report ZASA0LSS_R_SCREEN
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zasa0lss_r_screen.

*TABLES: sscrfields.
*
*SELECTION-SCREEN BEGIN OF SCREEN 0101 AS SUBSCREEN.
*  PARAMETERS: p_par1 TYPE string.
*SELECTION-SCREEN END OF SCREEN 0101.
*SELECTION-SCREEN BEGIN OF SCREEN 0102 AS SUBSCREEN.
*  PARAMETERS: p_par2 TYPE string.
*SELECTION-SCREEN END OF SCREEN 0102.
*SELECTION-SCREEN BEGIN OF SCREEN 0103 AS SUBSCREEN.
*  PARAMETERS: p_par3 TYPE string.
*SELECTION-SCREEN END OF SCREEN 0103.
*
*SELECTION-SCREEN BEGIN OF BLOCK b01.
*  SELECTION-SCREEN BEGIN OF TABBED BLOCK tab FOR 20 LINES.
*    SELECTION-SCREEN TAB (20) text-t02 USER-COMMAND tab1 DEFAULT SCREEN 0101.
*    SELECTION-SCREEN TAB (20) text-t03 USER-COMMAND tab2 DEFAULT SCREEN 0102.
*    SELECTION-SCREEN TAB (20) text-t04 USER-COMMAND tab3 DEFAULT SCREEN 0103.
*  SELECTION-SCREEN END OF BLOCK tab.
*
*SELECTION-SCREEN END OF BLOCK b01.


*TABLES: sscrfields.
*
*DATA: vg_ok_code  TYPE sy-ucomm.
*
*SELECTION-SCREEN BEGIN OF SCREEN 0101 AS SUBSCREEN.
*  PARAMETERS: p_par4 TYPE string.
*  SELECT-OPTIONS: s_ucomm FOR sy-ucomm.
*SELECTION-SCREEN END OF SCREEN 0101.
*
*START-OF-SELECTION.
*
*  CALL SCREEN '0100'.


*TABLES: sscrfields.
*
*SELECTION-SCREEN BEGIN OF SCREEN 0101 TITLE text-t01 AS WINDOW.
*  PARAMETERS: p_par4 TYPE string.
*SELECTION-SCREEN END OF SCREEN 0101.
*
*
*SELECTION-SCREEN BEGIN OF BLOCK b01.
*  PARAMETERS: p_par1 TYPE string MODIF ID gr1.
*  PARAMETERS: p_par2 TYPE string MODIF ID gr2.
*  PARAMETERS: p_par3 TYPE string MODIF ID gr3.
*
*  SELECTION-SCREEN PUSHBUTTON /2(15) bt_valid USER-COMMAND valid.
*
*SELECTION-SCREEN END OF BLOCK b01.
*
*INITIALIZATION.
*  bt_valid = |{ icon_check } Validar|.
*
*AT SELECTION-SCREEN.
*
*  CASE sscrfields-ucomm.
*    WHEN 'VALID'.
*      CALL SELECTION-SCREEN '0101' STARTING AT 10 5.
*    WHEN 'CRET'.
*      p_par1 = p_par4.
*      p_par2 = p_par4.
*      p_par3 = p_par4.
*      p_par4 = p_par4.
*  ENDCASE.

*TABLES: sscrfields.
*
*SELECTION-SCREEN FUNCTION KEY 1.
*SELECTION-SCREEN BEGIN OF BLOCK b01.
*
*  PARAMETERS: p_par1 TYPE string MODIF ID gr1.
*  PARAMETERS: p_par2 TYPE string MODIF ID gr2.
*  PARAMETERS: p_par3 TYPE string MODIF ID gr3.
*
*SELECTION-SCREEN END OF BLOCK b01.
*
*INITIALIZATION.
*
*  sscrfields-functxt_01 = |{ icon_check } Validar|.
*
*AT SELECTION-SCREEN.
*
*  CASE sscrfields-ucomm.
*    WHEN 'FC01'.
*      IF p_par1 IS INITIAL AND p_par2 IS INITIAL AND p_par3 IS INITIAL.
*        MESSAGE 'Todo os parâmetros são iniciais' TYPE 'S' DISPLAY LIKE 'W'.
*      ELSE.
*        MESSAGE 'Algum parâmetro foi preenchido' TYPE 'S'.
*      ENDIF.
*  ENDCASE.

*TABLES: sscrfields.
*
*SELECTION-SCREEN BEGIN OF BLOCK b01.
*
*  PARAMETERS: p_par1 TYPE string MODIF ID gr1.
*  PARAMETERS: p_par2 TYPE string MODIF ID gr2.
*  PARAMETERS: p_par3 TYPE string MODIF ID gr3.
*
*  SELECTION-SCREEN: PUSHBUTTON /2(12) bt_valid USER-COMMAND valid.
*
*SELECTION-SCREEN END OF BLOCK b01.
*
*INITIALIZATION.
*
*  bt_valid = |{ icon_check } Valida| ."'@38@ Valida'.
*
*AT SELECTION-SCREEN.
*
*  CASE sscrfields-ucomm.
*    WHEN 'VALID'.
*      IF p_par1 IS INITIAL AND p_par2 IS INITIAL AND p_par3 IS INITIAL.
*        MESSAGE 'Todo os parâmetros são iniciais' TYPE 'S' DISPLAY LIKE 'W'.
*      ELSE.
*        MESSAGE 'Algum parâmetro foi preenchido' TYPE 'S'.
*      ENDIF.
*  ENDCASE.

*TABLES: sscrfields.
*
*SELECTION-SCREEN BEGIN OF BLOCK b01.
*
*  PARAMETERS: p_par1 TYPE string MODIF ID gr1.
*  PARAMETERS: p_par2 TYPE string MODIF ID gr2.
*  PARAMETERS: p_par3 TYPE string MODIF ID gr3.
*
*  PARAMETERS: p_gr1 RADIOBUTTON GROUP gr1 USER-COMMAND gr DEFAULT 'X',
*              p_gr2 RADIOBUTTON GROUP gr1,
*              p_gr3 RADIOBUTTON GROUP gr1.
*
*SELECTION-SCREEN END OF BLOCK b01.
*
*AT SELECTION-SCREEN OUTPUT.
*  LOOP AT SCREEN.
*    IF p_gr1 EQ 'X' AND ( screen-group1 EQ 'GR2' OR screen-group1 EQ 'GR3' ).
*      screen-active = 0.
*    ENDIF.
*    IF p_gr2 EQ 'X' AND ( screen-group1 EQ 'GR1' OR screen-group1 EQ 'GR3' ).
*      screen-active = 0.
*    ENDIF.
*    IF p_gr3 EQ 'X' AND ( screen-group1 EQ 'GR1' OR screen-group1 EQ 'GR2' ).
*      screen-active = 0.
*    ENDIF.
*    MODIFY SCREEN.
*  ENDLOOP.



*AT SELECTION-SCREEN.
*
*  CASE sscrfields-ucomm.
*    WHEN 'GR'.
*      LOOP AT SCREEN.
*        IF p_par1 IS INITIAL AND p_gr1 EQ 'X'.
*          MESSAGE 'Primeiro parâmetro inicial' TYPE 'S' DISPLAY LIKE 'W'.
*        ENDIF.
*        IF p_par2 IS INITIAL AND p_gr2 EQ 'X'.
*          MESSAGE 'Segundo parâmetro inicial' TYPE 'S' DISPLAY LIKE 'W'.
*        ENDIF.
*        IF p_par3 IS INITIAL AND p_gr3 EQ 'X'.
*          MESSAGE 'Terceiro parâmetro inicial' TYPE 'S' DISPLAY LIKE 'W'.
*        ENDIF.
*      ENDLOOP.
*  ENDCASE.


*SELECTION-SCREEN BEGIN OF SCREEN 200 TITLE title AS WINDOW.
*
*  PARAMETERS: p_par1 TYPE string MODIF ID t.
*  PARAMETERS: p_par2 TYPE c LENGTH 20 AS LISTBOX VISIBLE LENGTH 20.
*  PARAMETERS: p_par3 TYPE string.
*
*SELECTION-SCREEN END OF SCREEN 200.

*
*SELECTION-SCREEN BEGIN OF SCREEN 200 TITLE title AS WINDOW.
*
*  PARAMETERS: p_par1 TYPE string MODIF ID t.
*  PARAMETERS: p_par2 TYPE c LENGTH 20 AS LISTBOX VISIBLE LENGTH 20.
*  PARAMETERS: p_par3 TYPE string.
*
*SELECTION-SCREEN END OF SCREEN 200.
*
*title = 'teste'.
*
*START-OF-SELECTION.
*
*  CALL SCREEN '0200'.


*SELECTION-SCREEN BEGIN OF BLOCK b01.
*
*  PARAMETERS: p_par1 TYPE string MODIF ID t.
*  PARAMETERS: p_par2 TYPE c LENGTH 20 AS LISTBOX VISIBLE LENGTH 20.
*  PARAMETERS: p_par3 TYPE string.
*
*SELECTION-SCREEN END OF BLOCK b01.
*
*AT SELECTION-SCREEN ON p_par1.
*
*  BREAK-POINT.

*AT SELECTION-SCREEN OUTPUT.
*  LOOP AT SCREEN.
*    IF screen-name EQ 'P_PAR1'.
*      screen-values_in_combo = 0.
*    ENDIF.
*
*    IF screen-name EQ 'P_PAR3'.
*      screen-values_in_combo = 1.
*    ENDIF.
*
*    MODIFY SCREEN.
*  ENDLOOP.
*
*INITIALIZATION.
*
*  DATA: tl_values TYPE vrm_values.
*
*  APPEND VALUE vrm_value(
*      key  = 'A'
*      text = 'ABAP'
*  ) TO tl_values.
*
*  CALL FUNCTION 'VRM_SET_VALUES'
*    EXPORTING
*      id     = 'P_PAR3'
*      values = tl_values
**   EXCEPTIONS
**     ID_ILLEGAL_NAME       = 1
**     OTHERS = 2
*    .
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ENDIF.



**    IF screen-name EQ 'P_PAR1'.
**      screen-required = 0.
**    ENDIF.
**    IF screen-name EQ 'P_PAR2'.
**      screen-required = 1.
**    ENDIF.
**    IF screen-name EQ 'P_PAR3'.
**      screen-required = 2.
**    ENDIF.

**    IF screen-name EQ 'P_PAR1'.
**      screen-input = 0.
**    ENDIF.
**    IF screen-name EQ 'P_PAR2'.
**      screen-input = 1.
**    ENDIF.

**    IF screen-name EQ 'P_PAR1'.
**      screen-output = 0.
**    ENDIF.
**    IF screen-name EQ 'P_PAR2'.
**      screen-input = 0.
**      screen-output = 1.
**    ENDIF.

**    IF screen-name EQ 'P_PAR1'.
**      screen-intensified = 0.
**    ENDIF.
**
**    IF screen-name EQ 'P_PAR2'.
**      screen-intensified = 1.
**    ENDIF.

**    IF screen-name EQ 'P_PAR1'.
**      screen-invisible = 0.
**    ENDIF.
**
**    IF screen-name EQ 'P_PAR2'.
**      screen-invisible = 1.
**    ENDIF.

**    IF screen-name EQ 'P_PAR1'.
**      screen-active = 0.
**    ENDIF.
**
**    IF screen-name EQ 'P_PAR2'.
**      screen-active = 1.
**    ENDIF.
**
**    IF screen-name CS 'P_PAR3'.
**      screen-active = 0.
**    ENDIF.

**    IF screen-name EQ 'P_PAR1'.
**      screen-value_help = 0.
**    ENDIF.
**
**    IF screen-name EQ 'P_PAR2'.
**      screen-value_help = 1.
**    ENDIF.
**
**    IF screen-name EQ 'P_PAR3'.
**      screen-value_help = 2.
**    ENDIF.



*
*AT SELECTION-SCREEN ON RADIOBUTTON GROUP gr1.
*
*  BREAK-POINT.
*
*AT SELECTION-SCREEN ON p_nome.
*
*  BREAK-POINT.
*
*START-OF-SELECTION.

*  CALL SCREEN '0100' STARTING AT 10 10.
*
*
**&---------------------------------------------------------------------*
**&      Module  USER_COMMAND_0100  INPUT
**&---------------------------------------------------------------------*
**       text
**----------------------------------------------------------------------*
*MODULE user_command_0100 INPUT.
*
*  CASE vg_ok_code.
*    WHEN 'BACK' OR 'END' OR 'CANCEL'.
*      LEAVE TO SCREEN 0.
*  ENDCASE.
*
*ENDMODULE.
**&---------------------------------------------------------------------*
**& Module STATUS_0100 OUTPUT
**&---------------------------------------------------------------------*
**&
**&---------------------------------------------------------------------*
*MODULE status_0100 OUTPUT.
*
** SET PF-STATUS 'STATUS_0100'. "Normal
* SET PF-STATUS 'STATUS_D_0100'. "Dialog
* SET TITLEBAR 'TITLE_0100'.
*
*ENDMODULE.
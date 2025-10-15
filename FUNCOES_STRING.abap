*&---------------------------------------------------------------------*
*& Report ZTT0SIMOEV_R_FUNCOES_STRING
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztt0simoev_r_funcoes_string.

tables: T001.

START-OF-SELECTION.
  TYPES ty_doc TYPE c LENGTH 18.

  PARAMETERS: p_input TYPE ty_doc.

  DATA: vl_strlen TYPE i.

  REPLACE '.' IN p_input WITH ''.
  REPLACE '.' IN p_input WITH ''.
  REPLACE '-' IN p_input WITH ''.
  REPLACE '/' IN p_input WITH ''.

  vl_strlen = strlen( p_input ).

  IF vl_strlen EQ 11.
    WRITE: / 'PF: ', p_input.

  ELSEIF vl_strlen EQ 14.
    WRITE: / 'PJ: ', p_input.

  ELSE.
    MESSAGE 'Registro Inválido' TYPE 'S' DISPLAY LIKE 'E'.
  ENDIF.
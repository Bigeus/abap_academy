"REUSE ALV GRID DISPLAY"

*&---------------------------------------------------------------------*
*& Report ZASA0LSS_R_RAGD
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zasa0lss_r_ragd.

START-OF-SELECTION.

  DATA: tl_fieldcat TYPE slis_t_fieldcat_alv,
        tl_sort     TYPE slis_t_sortinfo_alv.

  SELECT *
    FROM zasa0lss_tm_vend
    INTO TABLE @DATA(tl_alv).

  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name = 'ZASA0LSS_TM_VEND'
    CHANGING
      ct_fieldcat      = tl_fieldcat.

  READ TABLE tl_fieldcat ASSIGNING FIELD-SYMBOL(<fieldcat>) WITH KEY fieldname = 'QTD'.
  <fieldcat>-do_sum   = 'X'.
  <fieldcat>-hotspot  = 'X'.

  APPEND INITIAL LINE TO tl_sort ASSIGNING FIELD-SYMBOL(<sort>).
  <sort>-fieldname  = 'NRO'.
  <sort>-subtot     = 'X'.
  <sort>-expa       = 'X'.
  <sort>-up         = 'X'.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program       = sy-repid "Nome do programa que contém os FORM's
      i_callback_pf_status_set = 'ZF_SET_STATUS' "Nome do FORM para a rotina de definição do PF-STATUS
      i_callback_user_command  = 'ZF_USER_COMMAND' "Nome do FORM para a rotina de USER-COMMAND
      i_callback_top_of_page   = 'ZF_TOP_OF_PAGE'
      it_fieldcat              = tl_fieldcat
    TABLES
      t_outtab                 = tl_alv
    EXCEPTIONS
      program_error            = 1
      OTHERS                   = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

FORM zf_set_status USING rt_extab TYPE slis_t_extab.
  SET PF-STATUS 'STATUS_ALV'.
ENDFORM.

FORM zf_user_command USING r_ucomm      LIKE sy-ucomm
                           rs_selfield  TYPE slis_selfield.
  CASE r_ucomm.
    WHEN '&IC1'.
      READ TABLE tl_alv ASSIGNING FIELD-SYMBOL(<alv>) INDEX rs_selfield-tabindex.
      CLEAR: <alv>.
    WHEN 'EXPORT'.

  ENDCASE.
  rs_selfield-refresh = 'X'.
ENDFORM.

FORM zf_top_of_page.

  DATA: tl_listheader TYPE slis_t_listheader,
        wl_listheader TYPE slis_listheader.

  wl_listheader-typ  = 'H'.
  wl_listheader-info = 'Relatório de Vendas'.
  APPEND wl_listheader TO tl_listheader.

  wl_listheader-typ  = 'S'.
  wl_listheader-key  = 'Data: '.
  wl_listheader-info = sy-datum.
  APPEND wl_listheader TO tl_listheader.

  DATA(vl_lines) = lines( tl_alv ).

  wl_listheader-typ  = 'S'.
  wl_listheader-key  = 'Quantidade de Linhas: '.
  wl_listheader-info = vl_lines.
  APPEND wl_listheader TO tl_listheader.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = tl_listheader.

ENDFORM.
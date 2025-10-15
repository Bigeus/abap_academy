*&---------------------------------------------------------------------*
*& Report ZTT0SIMOEV_R_GIANNI
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztt0simoev_r_gianni.

TABLES: kna1.

" Type Tipo Tabela
TYPES: ty_t_kna1 TYPE STANDARD TABLE OF ztt0simoev_s_knagianni WITH NON-UNIQUE KEY kunnr.

" Declaração de tabela interna
DATA: tl_kna1 TYPE ty_t_kna1.
DATA: tl_fcat TYPE slis_t_fieldcat_alv.

" Declaração de estrutura
DATA: pt_kna1 TYPE ztt0simoev_s_knagianni.

START-OF-SELECTION.
  " SELECT
  SELECT kunnr land1 name1 ort01 stras adrnr
    FROM kna1
    INTO CORRESPONDING FIELDS OF TABLE tl_kna1.

****************************************
  "Atualiza o Registro para - São Paulo
  PERFORM change_adrs CHANGING tl_kna1.
****************************************

  "Criar o fieldcat
  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_program_name         = sy-repid
      i_internal_tabname     = 'PT_KNA1'
      i_structure_name       = 'ZTT0SIMOEV_S_KNAGIANNI'
      i_inclname             = sy-repid
    CHANGING
      ct_fieldcat            = tl_fcat
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.
  IF sy-subrc <> 0.
    WRITE: 'deu ruim'.
  ENDIF.

  DATA: wl_fieldcat TYPE slis_fieldcat_alv.

  " Adicionar Hotspot click no kunnr
  LOOP AT tl_fcat INTO wl_fieldcat.
    IF wl_fieldcat-fieldname = 'KUNNR'.
       wl_fieldcat-hotspot = 'X'.
      MODIFY tl_fcat FROM wl_fieldcat.
      CLEAR wl_fieldcat.
    ENDIF.

    IF wl_fieldcat-fieldname = 'ADRNR'.
       wl_fieldcat-hotspot = 'X'.
*       wl_fieldcat-no_zero = 'X'.
       wl_fieldcat-no_convext = 'X'.
      MODIFY tl_fcat FROM wl_fieldcat.
      CLEAR wl_fieldcat.
    ENDIF.
  ENDLOOP.

****************************************
  PERFORM present_alv USING tl_kna1.
*  PERFORM hotspot_click.

*****************************************************************************************************************************
*&---------------------------------------------------------------------*
*& Form change_adrs
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- TL_KNA1
*&---------------------------------------------------------------------*
FORM change_adrs CHANGING tl_kna1 TYPE ty_t_kna1.
  FIELD-SYMBOLS: <tl_kna1> TYPE ztt0simoev_s_knagianni.

*  DATA: wl_kna1 TYPE ztt0simoev_s_knagianni.

  IF tl_kna1[] IS INITIAL.
    MESSAGE: 'Não foi encontrado esse registro.' TYPE 'S' DISPLAY LIKE 'E'.
  ENDIF.

*  READ TABLE tl_kna1 INTO wl_kna1 WITH KEY name1 = 'Partage campos'.

  " Tentativa com o LOOP
  LOOP AT tl_kna1 ASSIGNING <tl_kna1>.
    IF <tl_kna1>-name1 EQ 'Partage campos'.
      <tl_kna1>-ort01 = 'São Paulo'.
    ENDIF.

    IF sy-subrc <> 0.
      MESSAGE: 'Deu ruim atribuindo o endereço.' TYPE 'S' DISPLAY LIKE 'E'.
    ENDIF.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form present_alv
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM present_alv USING tl_kna1 TYPE ty_t_kna1.

*  DATA: ty_t_alv TYPE STANDARD TABLE OF ty_t_kna1.
*
*  DATA: tl_alv TYPE ty_t_alv.

*  tl_alv[] = tl_kna1.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program      = sy-repid
      it_fieldcat             = tl_fcat
      i_callback_user_command = 'HOTSPOT_CLICK'
    TABLES
      t_outtab                = tl_kna1
    EXCEPTIONS
      program_error           = 1
      OTHERS                  = 2.
  IF sy-subrc <> 0.
    WRITE: 'Deu ruim algo'.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form hotspot_click
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*

FORM hotspot_click USING r_ucomm TYPE sy-ucomm rs_selfield TYPE slis_selfield.
*  BREAK-POINT.
  DATA: vl_text TYPE string.
  vl_text = rs_selfield-value.
  MESSAGE |Texto que foi clicado: { vl_text } | TYPE 'S'.
ENDFORM.
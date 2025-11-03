*&---------------------------------------------------------------------*
*& Include          ZTT0SIMOEV_I_ORQUESTR_V2_CLS
*&---------------------------------------------------------------------*
CLASS lcl_handler_tree_9000 IMPLEMENTATION.

  METHOD: node_double_click.

    CASE node_key.
      WHEN 'AM'.
        vg_screen = '9100'.
      WHEN 'AC'.
        MESSAGE: 'Funcionalidade não implementada ainda' TYPE 'S' DISPLAY LIKE 'W'.
        EXIT.
      WHEN 'SH'.
        vg_screen = '9101'.
    ENDCASE.

  ENDMETHOD.

ENDCLASS.
CLASS lcl_event_handler IMPLEMENTATION.

  METHOD on_toolbar.
    DATA: wl_button TYPE stb_button.

    " --- Botão 1 ---
    CLEAR wl_button.
    wl_button-function  = 'BTN_EDIT'.  " Código do botão
    wl_button-icon      = icon_change.   " Ícone SAP padrão
    wl_button-quickinfo = 'Edit row'.    " Tooltip
    wl_button-text      = 'Edit'.      " Texto no botão
    wl_button-disabled  = space.
    APPEND wl_button TO e_object->mt_toolbar.

    " --- Botão 2 ---
    CLEAR wl_button.
    wl_button-function  = 'BTN_INSERT'.
    wl_button-icon      = icon_insert_row.
    wl_button-quickinfo = 'Insert row'.
    wl_button-text      = 'Insert'.
    APPEND wl_button TO e_object->mt_toolbar.

        " --- Botão 3 ---
    CLEAR wl_button.
    wl_button-function  = 'BTN_DELETE'.
    wl_button-icon      = icon_delete_row.
    wl_button-quickinfo = 'Delete row'.
    wl_button-text      = 'Delete'.
    APPEND wl_button TO e_object->mt_toolbar.
  ENDMETHOD.

  METHOD on_user_command.

    CASE e_ucomm.
      WHEN 'BTN_EDIT'.
        MESSAGE 'Botão: BTN_EDIT' TYPE 'I'.

      WHEN 'BTN_INSERT'.
        MESSAGE 'Botão: BTN_INSERT' TYPE 'I'.

      WHEN 'BTN_DELETE'.
        MESSAGE 'Botão: BTN_DELETE' TYPE 'I'.

      WHEN 'BTN_UPDATE'.
        MESSAGE 'Botão: BTN_DELETE' TYPE 'I'.
        " Aqui você pode chamar o refresh_table_display, por exemplo.
    ENDCASE.
  ENDMETHOD.

ENDCLASS.
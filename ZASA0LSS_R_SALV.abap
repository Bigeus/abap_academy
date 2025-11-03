"ALV com cl_salv_table=>factory"

*&---------------------------------------------------------------------*
*& Report ZASA0LSS_R_SALV
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zasa0lss_r_salv.

START-OF-SELECTION.

  "REUSE_ALV_GRID_DISPLAY
  "CL_GUI_ALV_GRID
  "CL_SALV_TABLE

  SELECT *
    FROM ztbsicorc_md_seq
    INTO TABLE @DATA(tl_md).

  cl_salv_table=>factory(
*      EXPORTING
*        list_display   = if_salv_c_bool_sap=>false " ALV Displayed in List Mode
*        r_container    =                           " Abstract Container for GUI Controls
*        container_name =
    IMPORTING
      r_salv_table   = DATA(o_table)
    CHANGING
      t_table        = tl_md
  ).
*    CATCH cx_salv_msg. " ALV: General Error Class with Message

  o_table->display( ).
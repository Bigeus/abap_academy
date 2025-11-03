*----------------------------------------------------------------------*
***INCLUDE ZTT0SIMOEV_I_ORQUESTR_V2_I01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9000  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_9000 INPUT.

  CASE vg_ok_code.
    WHEN 'BACK' OR 'END' OR 'CANCEL'.
      LEAVE TO SCREEN 0.
    WHEN 'RUN'.
      PERFORM zf_seleciona.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9101  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_9101 INPUT.

  CASE vg_ok_code.
    WHEN 'TAB_MD'.
      tab_scheduller-activetab  = 'TAB_MD'.
    WHEN 'TAB_APP'.
      tab_scheduller-activetab  = 'TAB_APP'.
    WHEN OTHERS.
  ENDCASE.

ENDMODULE.
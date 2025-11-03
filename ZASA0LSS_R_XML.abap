"Usando XML"

*&---------------------------------------------------------------------*
*& Report ZASA0LSS_R_XML
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zasa0lss_r_xml.

START-OF-SELECTION.

  DATA: wl_reinf TYPE zasa0lss_s_reinf.

  DATA: vl_xml TYPE xstring.

  wl_reinf-evtretpf-ideevento = 'Gabriel'.

  CALL TRANSFORMATION zasa0lss_t_reinf
    SOURCE reinf = wl_reinf
    RESULT XML vl_xml.

  CLEAR: wl_reinf.

  CALL TRANSFORMATION zasa0lss_t_reinf
    SOURCE XML vl_xml
    RESULT reinf = wl_reinf.

  BREAK-POINT.
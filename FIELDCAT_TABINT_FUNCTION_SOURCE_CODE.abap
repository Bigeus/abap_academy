FUNCTION ZTT0SIMOEV_MF_FIELDCAT_TABINT.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(I_T_ALV) TYPE  STANDARD TABLE
*"  EXPORTING
*"     REFERENCE(E_T_FIELDCAT) TYPE  SLIS_T_FIELDCAT_ALV
*"----------------------------------------------------------------------

DATA: wl_descricao TYPE sydes_desc,
        wl_fieldcat  TYPE slis_fieldcat_alv.

  DATA: vl_name     TYPE ddobjname,
        vl_idx_help TYPE i.

  DESCRIBE FIELD i_t_alv INTO wl_descricao.

  LOOP AT wl_descricao-types INTO DATA(wl_type)
                              WHERE idx_name > 0.

    READ TABLE wl_descricao-names INTO DATA(wl_name)
                                        INDEX wl_type-idx_name.
    IF sy-subrc EQ 0.
      APPEND INITIAL LINE TO e_t_fieldcat ASSIGNING FIELD-SYMBOL(<fieldcat>).
      <fieldcat>-fieldname    = wl_name-name.
      <fieldcat>-intlen       = wl_type-length.
      <fieldcat>-outputlen    = wl_type-output_length.
      <fieldcat>-decimals_out = wl_type-decimals.
      <fieldcat>-inttype      = wl_type-type.

      IF wl_type-idx_help_id > 0.
        CLEAR: vl_name.
        vl_idx_help = wl_type-idx_help_id.
        DO.
          READ TABLE wl_descricao-names INTO wl_name INDEX vl_idx_help.
          CONCATENATE vl_name wl_name-name INTO vl_name.
          IF wl_name-continue EQ ' '.
            EXIT.
          ENDIF.
          ADD 1 TO vl_idx_help.
        ENDDO.

        SPLIT vl_name AT '-' INTO TABLE DATA(tl_split).
        <fieldcat>-ref_tabname    = tl_split[ 1 ].
        <fieldcat>-ref_fieldname  = tl_split[ 2 ].

        SELECT SINGLE rollname
          FROM dd03l
          INTO @DATA(vl_rollname)
            WHERE tabname   EQ @<fieldcat>-ref_tabname
              AND fieldname EQ @<fieldcat>-ref_fieldname.

        IF sy-subrc EQ 0 AND vl_rollname IS NOT INITIAL.
          SELECT SINGLE rollname scrtext_s scrtext_m scrtext_l
            FROM dd04t
            INTO ( <fieldcat>-rollname, <fieldcat>-seltext_s, <fieldcat>-seltext_m, <fieldcat>-seltext_l )
              WHERE rollname    EQ vl_rollname
                AND ddlanguage  EQ sy-langu.
        ENDIF.

      ENDIF.

    ENDIF.

  ENDLOOP.



ENDFUNCTION.
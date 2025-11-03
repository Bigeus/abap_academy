*&---------------------------------------------------------------------*
*& Report ZASA0LSS_R_CNPJA
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zasa0lss_r_cnpja.

TABLES: but000.

SELECTION-SCREEN BEGIN OF BLOCK b01.

  SELECT-OPTIONS: s_part  FOR but000-partner.

SELECTION-SCREEN END OF BLOCK b01.

START-OF-SELECTION.

  SELECT partner, name_org1
    FROM but000
    INTO TABLE @DATA(tl_but).

  /ui2/cl_json=>serialize(
    EXPORTING
      data             = tl_but
*        compress         =                  " Skip empty elements
*        name             =                  " Object name
*        pretty_name      =                  " Pretty Print property names
*        type_descr       =                  " Data descriptor
*        assoc_arrays     =                  " Serialize tables with unique keys as associative array
*        ts_as_iso8601    =                  " Dump timestamps as string in ISO8601 format
*        expand_includes  =                  " Expand named includes in structures
*        assoc_arrays_opt =                  " Optimize rendering of name value maps
*        numc_as_string   =                  " Serialize NUMC fields as strings
*        name_mappings    =                  " ABAP<->JSON Name Mapping Table
*        conversion_exits =                  " Use DDIC conversion exits on serialize of values
    RECEIVING
      r_json           = DATA(vl_json)
  ).

  /ui2/cl_json=>deserialize(
    EXPORTING
      json             = vl_json
*      jsonx            =                  " JSON XString
*      pretty_name      =                  " Pretty Print property names
*      assoc_arrays     =                  " Deserialize associative array as tables with unique keys
*      assoc_arrays_opt =                  " Optimize rendering of name value maps
*      name_mappings    =                  " ABAP<->JSON Name Mapping Table
*      conversion_exits =                  " Use DDIC conversion exits on deserialize of values
    CHANGING
      data             = tl_but
  ).

  BREAK-POINT.

*TABLES: j_1bbranch.

*SELECTION-SCREEN BEGIN OF BLOCK b01.
*
*  SELECT-OPTIONS s_cnpj FOR j_1bbranch-stcd1 NO INTERVALS.
*
*SELECTION-SCREEN END OF BLOCK b01.
*
*START-OF-SELECTION.

*  DATA: vg_url      TYPE string,
*        vg_response TYPE string.
*
*  DATA: o_client TYPE REF TO if_http_client.

*  CONSTANTS: c_url TYPE string VALUE 'https://open.cnpja.com/office/'.
*
*  LOOP AT s_cnpj.
*
*    vg_url = |{ c_url }{ s_cnpj-low }|.
*
*    cl_http_client=>create_by_url(
*      EXPORTING
*        url                    = vg_url
**        proxy_host             =                  " Logical destination (specified in function call)
**        proxy_service          =                  " Port Number
**        ssl_id                 =                  " SSL Identity
**        sap_username           =                  " ABAP System, User Logon Name
**        sap_client             =                  " R/3 system (client number from logon)
**        proxy_user             =                  " Proxy user
**        proxy_passwd           =                  " Proxy password
**        do_not_use_client_cert = abap_false       " SSL identity not used for logon
**        use_scc                = abap_false       " Connection needed for SAP Cloud Connector
**        scc_location_id        =                  " Location ID for SAP Cloud Connector
*      IMPORTING
*        client                 = o_client
*      EXCEPTIONS
*        argument_not_found     = 1                " Communication parameter (host or service) not available
*        plugin_not_active      = 2                " HTTP/HTTPS communication not available
*        internal_error         = 3                " Internal error (e.g. name too long)
*        pse_not_found          = 4                " PSE not found
*        pse_not_distrib        = 5                " PSE not distributed
*        pse_errors             = 6                " General PSE error
*        others                 = 7
*    ).
*    IF SY-SUBRC <> 0.
**     MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**       WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*    ENDIF.
*
*    o_client->propertytype_logon_popup = o_client->co_disabled.
*    o_client->request->set_method( method = 'GET' ).
*    o_client->request->set_version( if_http_request=>co_protocol_version_1_1 ).
*
*    o_client->request->set_header_field(
*    EXPORTING
*      name  = '~request_method'
*      value = 'GET' ).
*
*    o_client->send(
*      EXPORTING
*        timeout = 30
*      EXCEPTIONS
*        http_communication_failure = 1                  " Communication Error
*        http_invalid_state         = 2                  " Invalid state
*        http_processing_failed     = 3                  " Error when processing method
*        http_invalid_timeout       = 4                  " Invalid Time Entry
*        others                     = 5
*    ).
*    IF sy-subrc <> 0.
**     MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**       WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*    ENDIF.
*
*    o_client->receive(
*      EXCEPTIONS
*        http_communication_failure = 1                " Communication Error
*        http_invalid_state         = 2                " Invalid state
*        http_processing_failed     = 3                " Error when processing method
*        others                     = 4
*    ).
*    IF SY-SUBRC <> 0.
**     MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**       WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*    ENDIF.
*
*    vg_response = o_client->response->get_cdata( ).
*
*    o_client->close( ).
*    FREE: o_client.
*
*  ENDLOOP.
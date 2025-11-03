*&---------------------------------------------------------------------*
*& Include          ZTT0SIMOEV_I_ORQUESTRADOR_O01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_9000 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_9000 OUTPUT.

 SET PF-STATUS 'STATUS_9000'.
 SET TITLEBAR 'TITLE_9000'.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module SET_CONTAINER_9000 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE set_container_9000 OUTPUT.

 CHECK o_cont_9000 IS NOT BOUND.

 CREATE OBJECT o_cont_9000
   EXPORTING
*     parent                      =                  " Parent container
     container_name              = 'CONT_9000'       " Name of the Screen CustCtrl Name to Link Container To
*     style                       =                  " Windows Style Attributes Applied to this Container
*     lifetime                    = lifetime_default " Lifetime
*     repid                       =                  " Screen to Which this Container is Linked
*     dynnr                       =                  " Report To Which this Container is Linked
*     no_autodef_progid_dynnr     =                  " Don't Autodefined Progid and Dynnr?
   EXCEPTIONS
     cntl_error                  = 1                " CNTL_ERROR
     cntl_system_error           = 2                " CNTL_SYSTEM_ERROR
     create_error                = 3                " CREATE_ERROR
     lifetime_error              = 4                " LIFETIME_ERROR
     lifetime_dynpro_dynpro_link = 5                " LIFETIME_DYNPRO_DYNPRO_LINK
     others                      = 6
   .
 IF SY-SUBRC <> 0.
   MESSAGE: 'Deu ruim na criação do container principal' TYPE 'I' DISPLAY LIKE 'E'.
 ENDIF.

 CREATE OBJECT o_split_9000
   EXPORTING
*     link_dynnr              =                    " Screen Number
*     link_repid              =                    " Report Name
*     shellstyle              =                    " Window Style
*     left                    =                    " Left-aligned
*     top                     =                    " Top
*     width                   =                    " NPlWidth
*     height                  =                    " Hght
*     metric                  = cntl_metric_dynpro " Metric
*     align                   = 15                 " Alignment
     parent                  = o_cont_9000         " Parent Container
     rows                    = 1                   " Number of Rows to be displayed
     columns                 = 2                   " Number of Columns to be Displayed
*     no_autodef_progid_dynnr =                    " Don't Autodefined Progid and Dynnr?
*     name                    =                    " Name
   EXCEPTIONS
     cntl_error              = 1                  " See Superclass
     cntl_system_error       = 2                  " See Superclass
     others                  = 3
   .
 IF SY-SUBRC <> 0.
   MESSAGE: 'Deu ruim criando o objeto split' TYPE 'I' DISPLAY LIKE 'E'.
 ENDIF.

 o_cont_9000_tree = o_split_9000->get_container( row = 1 column = 1 ).

 o_split_9000->set_column_width( id = 1 width = 15 ).

 o_cont_9000_alv  = o_split_9000->get_container( row = 1 column = 2 ).

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module SET_TREE_9000 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE set_tree_9000 OUTPUT.

  DATA: tl_events TYPE cntl_simple_events.

  DATA: wl_event TYPE cntl_simple_event.

  CREATE OBJECT o_tree_9000
    EXPORTING
      node_selection_mode         = cl_gui_column_tree=>node_sel_mode_multiple
*      hide_selection              =                  " Visibility of Selection
    EXCEPTIONS
      illegal_node_selection_mode = 1                " "
      others                      = 2.
  IF SY-SUBRC <> 0.
    MESSAGE: 'Deu ruim criando o tree_9000 no MODULE set_tree_9000' TYPE 'I' DISPLAY LIKE 'E'.
  ENDIF.

  " Instanciando realmente o objeto. acima apenas declaramos ele
  o_tree_9000->create_tree_control( parent = o_cont_9000_tree ).

  " Node - parent? - isFolder - text
  PERFORM zf_add_node USING 'ROOT' ''     'X'  'Rule Control'.
  PERFORM zf_add_node USING 'MD'   'ROOT' 'X'  'Master Data'.
  PERFORM zf_add_node USING 'AM'   'MD'   ''   'Application Management'.

" Nova forma de APPEND
*  APPEND VALUE cntl_simple_event( eventid = cl_simple_tree_model=>eventid_node_double_click appl_event = 'X' )
*  TO tl_events.

  wl_event-eventid    = cl_simple_tree_model=>eventid_node_double_click.
  wl_event-appl_event = 'X'.
  APPEND wl_event TO tl_events.
  o_tree_9000->set_registered_events( tl_events ).

  CREATE OBJECT o_handler_tree_9000.

  SET HANDLER o_handler_tree_9000->node_double_click FOR o_tree_9000.



ENDMODULE.
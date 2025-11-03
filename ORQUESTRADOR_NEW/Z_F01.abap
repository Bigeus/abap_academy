*&---------------------------------------------------------------------*
*& Include          ZTT0SIMOEV_I_ORQUESTRADOR_F01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Form zf_add_node
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_
*&      --> P_
*&      --> P_
*&      --> P_
*&---------------------------------------------------------------------*
FORM zf_add_node  USING p_v_node_key
                        p_v_relative_node_key
                        p_v_isfolder
                        p_v_text.

   o_tree_9000->add_node(
     EXPORTING
       node_key                = p_v_node_key           " Código do node atual
       relative_node_key       = p_v_relative_node_key  " Código do Node Pai
       relationship            = 1                      " Relationship
       isfolder                = p_v_isfolder           " 'X': Node is Folder; ' ': Node is Leaf
       text                    = p_v_text               " Node text
*       hidden                  =                       " 'X': Node is Invisible
*       disabled                =                       " 'X': Node Cannot be Selected
*       style                   =                       " See Method Documentation
*       no_branch               =                       " 'X': Do Not Draw Hierarchy Lines
*       expander                =                       " See Method Documentation
*       image                   =                       " See Method Documentation
*       expanded_image          =                       " See Method Documentation
*       drag_drop_id            =                       " See Method Documentation
*       user_object             =                       " User Object
*     EXCEPTIONS
*       node_key_exists         = 1                     " Node Key Already Exists
*       illegal_relationship    = 2                     " RELATIONSHIP Contains Invalid Value
*       relative_node_not_found = 3                     " The RELATIVE_NODE Node Does Not Belong to This Tree
*       node_key_empty          = 4                     " NODE_KEY is Initial or Contains Only Blanks
*       others                  = 5
   ).
   IF SY-SUBRC <> 0.
     MESSAGE: 'Deu ruim no add node do F01.' TYPE 'I' DISPLAY LIKE 'E'.
   ENDIF.

   IF p_v_isfolder EQ 'X'.
     o_tree_9000->expand_node( node_key = p_v_node_key ).
   ENDIF.

ENDFORM.
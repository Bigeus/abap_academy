*&---------------------------------------------------------------------*
*& Include          Z_SCR_0101
*&---------------------------------------------------------------------*

MODULE status_0101 OUTPUT.

  SET PF-STATUS 'STATUS_0101'.
  SET TITLEBAR 'TITLE_0101'.

ENDMODULE.

MODULE user_command_0101 INPUT.
      DATA: tl_file TYPE STANDARD TABLE OF char100.
      DATA: wl_file TYPE string.
      FIELD-SYMBOLS: <alv> TYPE ty_s_alv.

  CASE vg_ok_code.
    WHEN 'BACK' OR 'END' OR 'CANCEL' OR 'EXIT' OR 'Cancel'.
      LEAVE TO SCREEN 0.
    WHEN 'ENTER'.
      CASE 'X'.
        WHEN scr_0101-servidor.
          CLEAR tl_file.
          CLEAR wl_file.
          UNASSIGN <alv>.
          APPEND 'Sales Doc.;Item;Material;MaterialDescription;Target Qty;BUn;Valor Total;Vlr.Unit.;Customer;Name1'
          TO tl_file.

          LOOP AT tg_alv ASSIGNING <alv>.
            wl_file = |{ <alv>-vbeln };{ <alv>-posnr };{ <alv>-matnr };{ <alv>-maktx };{ <alv>-menge };{ <alv>-meins };{ <alv>-vlr_tot };{ <alv>-vlr_unit };{ <alv>-kunnr };{ <alv>-name1 }|.

            APPEND wl_file TO tl_file.
          ENDLOOP.

          "Validar extensão do arquivo
          IF scr_0101-arquivo NS '.csv' AND scr_0101-arquivo NS '.txt'.
            MESSAGE: 'Caminho precisa terminar em .csv ou .txt' TYPE 'I'.
            EXIT.
          ENDIF.

          "Validar se é o caminho pra Windows
          IF scr_0101-arquivo CS 'C:\'.
            MESSAGE: 'Apenas diretórios UNIX são permitidos'
            TYPE 'I'.
            EXIT.
          ENDIF.

          "Validar inicio do diretório
          IF scr_0101-arquivo NS '/usr/sap/trans/'.
            MESSAGE: 'Local precisa ser dentro do diretório usr > sap > trans'
            TYPE 'I'.
            EXIT.
          ENDIF.

          TRANSLATE scr_0101-arquivo TO LOWER CASE.

          OPEN DATASET scr_0101-arquivo FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.

          IF sy-subrc EQ 0.
            LOOP AT tl_file ASSIGNING FIELD-SYMBOL(<file>).
              TRANSFER <file> TO scr_0101-arquivo.
            ENDLOOP.

          ELSE.
            MESSAGE: 'Erro no OPEN DATASET' TYPE 'I' DISPLAY LIKE 'E'.
            EXIT.
          ENDIF.

          CLOSE DATASET scr_0101-arquivo.
          MESSAGE: 'File created successfully' TYPE 'S'.
********************************************************************************
        WHEN scr_0101-usuario.
          CLEAR tl_file.
          CLEAR wl_file.
          UNASSIGN <alv>.
          "Validar extensão do arquivo
          IF scr_0101-arquivo NS '.csv' AND scr_0101-arquivo NS '.txt'.
            MESSAGE: 'Caminho precisa terminar em .csv ou .txt' TYPE 'I'.
            EXIT.
          ENDIF.

          "Validar início do caminho no windows
          IF scr_0101-arquivo NS 'C:\'.
            MESSAGE: 'Diretório inválido para download' TYPE 'I'.
            EXIT.
          ENDIF.

           APPEND 'Sales Doc.;Item;Material;MaterialDescription;Target Qty;BUn;Valor Total;Vlr.Unit.;Customer;Name1'
          TO tl_file.

          LOOP AT tg_alv ASSIGNING <alv>.
            wl_file = |{ <alv>-vbeln };{ <alv>-posnr };{ <alv>-matnr };{ <alv>-maktx };{ <alv>-menge };{ <alv>-meins };{ <alv>-vlr_tot };{ <alv>-vlr_unit };{ <alv>-kunnr };{ <alv>-name1 }|.

            APPEND wl_file TO tl_file.
          ENDLOOP.

          CALL FUNCTION 'GUI_DOWNLOAD'
            EXPORTING
              filename                = scr_0101-arquivo
            TABLES
              data_tab                = tl_file
            EXCEPTIONS
              file_write_error        = 1
              no_batch                = 2
              gui_refuse_filetransfer = 3
              invalid_type            = 4
              no_authority            = 5
              unknown_error           = 6
              header_not_allowed      = 7
              separator_not_allowed   = 8
              filesize_not_allowed    = 9
              header_too_long         = 10
              dp_error_create         = 11
              dp_error_send           = 12
              dp_error_write          = 13
              unknown_dp_error        = 14
              access_denied           = 15
              dp_out_of_memory        = 16
              disk_full               = 17
              dp_timeout              = 18
              file_not_found          = 19
              dataprovider_exception  = 20
              control_flush_error     = 21
              OTHERS                  = 22.
          IF sy-subrc <> 0.
            MESSAGE: 'Deu ruim no GUI_DOWNLOAD' TYPE 'I' DISPLAY LIKE 'E'.
            EXIT.
          ENDIF.

          LEAVE TO SCREEN 0.
      ENDCASE.
  ENDCASE.

      CLEAR vg_ok_code.

ENDMODULE.

MODULE f4_arquivo INPUT.
  CASE 'X'.
    WHEN scr_0101-servidor.
      PERFORM zf_f4_server.
    WHEN scr_0101-usuario.
      PERFORM zf_f4_0101_user USING scr_0101-arquivo.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Form zf_f4_server
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM zf_f4_server .

  DATA: vl_directory TYPE string,
        vl_file      TYPE string,
        vl_full      TYPE string.

  vl_file = |{ sy-uname }_{ sy-datum }_{ sy-uzeit }.csv|.

  CALL FUNCTION '/SAPDMC/LSM_F4_SERVER_FILE'
    EXPORTING
      directory        = '/usr/sap/trans/tmp/'
    IMPORTING
      serverfile       = vl_directory
    EXCEPTIONS
      canceled_by_user = 1
      OTHERS           = 2.
  IF sy-subrc <> 0.
    MESSAGE: 'Erro no F4_SERVER_FILE' TYPE 'I' DISPLAY LIKE 'E'.
    EXIT.
  ENDIF.

  CONCATENATE vl_directory vl_file INTO vl_full.

  scr_0101-arquivo = vl_full.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form zf_f4_0101_user
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> SCR_0101_ARQUIVO
*&---------------------------------------------------------------------*
FORM zf_f4_0101_user  USING p_scr_0101_arquivo.

  DATA: vl_directory TYPE string,
        vl_file      TYPE string,
        vl_full      TYPE string.

  vl_file = |{ sy-uname }_{ sy-datum }_{ sy-uzeit }.csv|.

  cl_gui_frontend_services=>directory_browse(
    EXPORTING
      window_title    = 'Selecione o diretório para salvar o arquivo'
    CHANGING
      selected_folder = vl_directory
    EXCEPTIONS
      cntl_error           = 1
      error_no_gui         = 2
      not_supported_by_gui = 3
      OTHERS               = 4
  ).

  IF sy-subrc <> 0.
    MESSAGE 'Deu ruim no directory_browse' TYPE 'I' DISPLAY LIKE 'E'.
    STOP.
  ENDIF.

  vl_directory = vl_directory && '\'.

  CONCATENATE vl_directory vl_file INTO vl_full.

  scr_0101-arquivo = vl_full.

ENDFORM.
*&---------------------------------------------------------------------*
*& Module DEFAULT_RADIOBUTTON OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE default_radiobutton OUTPUT.
  IF scr_0101-servidor EQ '' AND scr_0101-usuario EQ ''.
    scr_0101-servidor = 'X'.
  ENDIF.
ENDMODULE.
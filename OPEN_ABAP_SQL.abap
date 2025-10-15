*&---------------------------------------------------------------------*
*& Report ZTT0SIMOEV_R_OPEN_ABAP_SQL
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztt0simoev_r_open_abap_sql.

" TIPOS
TABLES: zasa0lss_tm_cad.

TYPES:
  BEGIN OF ty_s_cadastro,
    registro   TYPE zasa0lss_tm_cad-registro,
    nome       TYPE zasa0lss_tm_cad-nome,
    nascimento TYPE zasa0lss_tm_cad-nascimento,
  END OF ty_s_cadastro.

TYPES: ty_t_cadastro TYPE STANDARD TABLE OF ty_s_cadastro WITH NON-UNIQUE KEY registro.

" TELA DE SELEÇÃO
SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-t01.

  SELECT-OPTIONS: s_reg   FOR zasa0lss_tm_cad-registro   NO-EXTENSION NO INTERVALS OBLIGATORY,
                  s_nome  FOR zasa0lss_tm_cad-nome       NO-EXTENSION NO INTERVALS,
                  s_nas   FOR zasa0lss_tm_cad-nascimento NO-EXTENSION NO INTERVALS.

  SELECTION-SCREEN SKIP.

  PARAMETERS: p_cr RADIOBUTTON GROUP grp1,
              p_vs RADIOBUTTON GROUP grp1,
              p_dl RADIOBUTTON GROUP grp1.
SELECTION-SCREEN END OF BLOCK b01.


" Eventos de seleção

START-OF-SELECTION.

  DATA: tl_fieldcat TYPE slis_t_fieldcat_alv,
        wl_fieldcat TYPE slis_fieldcat_alv.

  DATA: vl_registro   TYPE zasa0lss_tm_cad-registro,
        vl_nome       TYPE zasa0lss_tm_cad-nome,
        vl_nascimento TYPE zasa0lss_tm_cad-nascimento.

  DATA: tl_cadastro TYPE ty_t_cadastro.
  DATA: wl_cadastro TYPE ty_s_cadastro.

  DATA: wl_insert   TYPE zasa0lss_tm_cad.

  CASE 'X'.
      " VISUALIZAÇÃO
    WHEN p_vs.

      SELECT registro nome nascimento
        FROM zasa0lss_tm_cad
        INTO TABLE tl_cadastro
        WHERE registro    IN s_reg
        AND nome          IN s_nome
      AND nascimento      IN s_nas.

      wl_fieldcat-fieldname  = 'REGISTRO'.
      wl_fieldcat-key        = 'X'.
      wl_fieldcat-rollname   =  zasa0lss_tm_cad-registro.
      wl_fieldcat-seltext_s  = 'REG'.
      wl_fieldcat-seltext_m  = 'REGIST'.
      wl_fieldcat-seltext_l  = 'REGISTRO'.
      APPEND wl_fieldcat TO tl_fieldcat.
      CLEAR: wl_fieldcat.

      wl_fieldcat-fieldname = 'NOME'.
      wl_fieldcat-rollname =  zasa0lss_tm_cad-nome.
      wl_fieldcat-seltext_s  = 'NOME'.
      wl_fieldcat-seltext_m  = 'NOME'.
      wl_fieldcat-seltext_l  = 'NOME'.
      APPEND wl_fieldcat TO tl_fieldcat.
      CLEAR: wl_fieldcat.

      wl_fieldcat-fieldname = 'NASCIMENTO'.
      wl_fieldcat-rollname =  zasa0lss_tm_cad-nascimento.
      wl_fieldcat-seltext_s  = 'NASC'.
      wl_fieldcat-seltext_m  = 'NASCIMT'.
      wl_fieldcat-seltext_l  = 'NASCIMENTO'.
      APPEND wl_fieldcat TO tl_fieldcat.
      CLEAR: wl_fieldcat.

      CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
        EXPORTING
          it_fieldcat = tl_fieldcat
        TABLES
          t_outtab    = tl_cadastro
        EXCEPTIONS
          OTHERS      = 1.
      IF sy-subrc <> 0.
        MESSAGE: 'DEU RUIM ALGO' TYPE 'S' DISPLAY LIKE 'E'.
      ENDIF.

      " CRIAÇÃO
    WHEN p_cr.
      wl_insert-registro   = s_reg-low.
      wl_insert-nome       = s_nome-low.
      wl_insert-nascimento = s_nas-low.

      INSERT zasa0lss_tm_cad FROM wl_insert.

      IF sy-subrc EQ 0.
        MESSAGE |Deu certo, objeto criado: { wl_insert-nome }| TYPE 'S' DISPLAY LIKE 'S'.
*        COMMIT WORK.
      ELSE.
        MESSAGE |DEU RUIM !!!!!!!! :O { wl_insert-nome }| TYPE 'S' DISPLAY LIKE 'E'.
        ROLLBACK WORK.
        CLEAR wl_insert.
      ENDIF.

      " DELETE
    WHEN p_dl.
      wl_insert-registro   = s_reg-low.
      wl_insert-nome       = s_nome-low.
      wl_insert-nascimento = s_nas-low.

      DELETE zasa0lss_tm_cad FROM wl_insert.

      IF sy-subrc EQ 0.
        MESSAGE |Deu certo, objeto excluído.| TYPE 'S' DISPLAY LIKE 'S'.
*        COMMIT WORK.
      ELSE.
        MESSAGE |DEU RUIM !!!!!!!! :O| TYPE 'S' DISPLAY LIKE 'E'.
        ROLLBACK WORK.
        CLEAR wl_insert.
      ENDIF.

  ENDCASE.
*&---------------------------------------------------------------------*
*& Report ZTT0SIMOEV_R_TREINAMENTO
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztt0simoev_r_treinamento NO STANDARD PAGE HEADING LINE-SIZE 232.

TABLES: ztt0simoev_tm_tr.

* CABEÇALHO
TOP-OF-PAGE.
  WRITE: / sy-uline,
         / sy-vline, 2(20) 'Usuário' COLOR COL_HEADING,
           sy-vline, 24(10) 'Pacote' COLOR COL_HEADING,
           sy-vline, 36(50) 'Descrição' ,
           sy-vline, 88(20) 'Dt.Admissão' ,
           sy-vline, 110(5) 'Tr1' ,
           sy-vline, 117(40) 'Nome Colaborador' ,
           sy-vline, 159(20) 'Change Request' ,
           sy-vline, 181(50) 'Descrição' ,
           sy-vline,
         / sy-uline.

* PARAMETROS DE SELEÇÃO
  SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-b01.
    SELECT-OPTIONS s_bname FOR ztt0simoev_tm_tr-bname NO INTERVALS.
    SELECT-OPTIONS s_devcla FOR ztt0simoev_tm_tr-devclass NO INTERVALS.
    SELECT-OPTIONS s_dtadm FOR ztt0simoev_tm_tr-data_admissao.
    SELECT-OPTIONS s_trkorr FOR ztt0simoev_tm_tr-tr_trkorr.
    SELECT-OPTIONS s_treino FOR ztt0simoev_tm_tr-treinamento NO INTERVALS NO-EXTENSION.
  SELECTION-SCREEN END OF BLOCK b01.


START-OF-SELECTION.

* ESTRUTURA
  TYPES:
    BEGIN OF ty_s_treinamento,
      bname            TYPE ztt0simoev_tm_tr-bname, "User Name in User Master Record
      devclass         TYPE ztt0simoev_tm_tr-devclass, "Package
      ctext            TYPE ztt0simoev_tm_tr-ctext, "Short Description of Repository Objects
      data_admissao    TYPE ztt0simoev_tm_tr-data_admissao, "Data de Admissão do Colaborador
      treinamento      TYPE ztt0simoev_tm_tr-treinamento, "SA (Standard ABAP) / DA (Data Analytics)
      nome_colaborador TYPE ztt0simoev_tm_tr-nome_colaborador, "Nome do Colaborador
      tr_trkorr        TYPE ztt0simoev_tm_tr-tr_trkorr, "Input field for request number for individual display
      as4text          TYPE ztt0simoev_tm_tr-as4text, "Short Description of Request
    END OF ty_s_treinamento.

* CATEGORIA DE TABELA
  TYPES: ty_t_treinamento TYPE SORTED TABLE OF ty_s_treinamento WITH UNIQUE KEY bname devclass.

* DECLARAR TABELA
  DATA: t_treinamento TYPE ty_t_treinamento.

* DECLARAR WORK AREA
  DATA: w_treinamento TYPE ty_s_treinamento.

* SELEÇÃO DE DADOS
  SELECT bname devclass ctext data_admissao treinamento nome_colaborador tr_trkorr as4text
    FROM ztt0simoev_tm_tr
    INTO TABLE t_treinamento
    WHERE bname           IN s_bname
    AND   devclass        IN s_devcla
    AND   data_admissao   IN s_dtadm
    AND   tr_trkorr       IN s_trkorr
    AND   treinamento     IN s_treino.

    IF t_treinamento IS INITIAL.
      MESSAGE: 'Sem resultados para a pesquisa' TYPE 'S' DISPLAY LIKE 'E'.
    ENDIF.

* IMPRESSÃO
  LOOP AT t_treinamento INTO w_treinamento.
    WRITE: / sy-vline, 2(20) w_treinamento-bname COLOR COL_KEY,
             sy-vline, 24(10) w_treinamento-devclass COLOR COL_KEY,
             sy-vline, 36(50) w_treinamento-ctext,
             sy-vline, 88(20) w_treinamento-data_admissao,
             sy-vline, 110(5) w_treinamento-treinamento,
             sy-vline, 117(40) w_treinamento-nome_colaborador,
             sy-vline, 159(20) w_treinamento-tr_trkorr,
             sy-vline, 181(50) w_treinamento-as4text,
             sy-vline,
           / sy-uline.
  ENDLOOP.
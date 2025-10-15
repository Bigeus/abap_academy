*&---------------------------------------------------------------------*
*& Report ZTT0SIMOEV_R_BOOK_LIST
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztt0simoev_r_book_list NO STANDARD PAGE HEADING LINE-SIZE 169.

TABLES: ztt0simoev_tm_b1.

TOP-OF-PAGE.

  WRITE: / sy-uline,
         / sy-vline, 2(20) 'Título' COLOR COL_HEADING,
           sy-vline, 24(20) 'ISBN' COLOR COL_HEADING,
           sy-vline, 46(20) 'Moeda' COLOR COL_HEADING,
           sy-vline, 68(20) 'Gênero' COLOR COL_HEADING,
           sy-vline, 90(20) 'Autor' COLOR COL_HEADING,
           sy-vline, 114(20) 'Preço' COLOR COL_HEADING,
           sy-vline, 136(10) 'Páginas' COLOR COL_HEADING,
           sy-vline, 148(20) 'Data de Lançamento' COLOR COL_HEADING,
           sy-vline,
         / sy-uline.


*--------------------------------------------------------------------*
*Elementos de Seleção
*--------------------------------------------------------------------*
  SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-b01.
*    PARAMETERS p_title TYPE ztt0simoev_tm_b1-title."NO-EXTENSION NO INTERVALS.
    SELECT-OPTIONS s_title FOR ztt0simoev_tm_b1-title NO-EXTENSION NO INTERVALS.
    SELECT-OPTIONS p_author FOR ztt0simoev_tm_b1-author NO-EXTENSION NO INTERVALS.
    SELECT-OPTIONS p_genre FOR ztt0simoev_tm_b1-genre NO-EXTENSION NO INTERVALS.
    SELECT-OPTIONS p_isbn FOR ztt0simoev_tm_b1-isbn NO-EXTENSION NO INTERVALS.

    SELECTION-SCREEN SKIP.

    SELECT-OPTIONS p_zpages FOR ztt0simoev_tm_b1-zpages.
    SELECT-OPTIONS p_price FOR ztt0simoev_tm_b1-price.
    SELECT-OPTIONS p_date FOR ztt0simoev_tm_b1-launch_date.
*    PARAMETERS p_title TYPE c LENGTH 50.

*    SELECTION-SCREEN COMMENT 4(20) TEXT-t01 FOR FIELD p_date.
*    dúvida: só consegui por label em Selection texts, é isso?
* Atenção com o 4(10) acima! É preciso pois o bloco come o início.
  SELECTION-SCREEN END OF BLOCK b01.

*--------------------------------------------------------------------*
*SELECT dos campos
*--------------------------------------------------------------------*
START-OF-SELECTION.

*IF p_title IS INITIAL.
*  CLEAR p_title.
*
*ENDIF.

  DATA: tl_livros TYPE ztt0simoev_ct_book.
* DATA: tl_livros TYPE TABLE OF ztt0simoev_tm_b1

  DATA: wl_livros TYPE ztt0simoev_s_book.
* DATA: wl_livros TYPE ztt0simoev_tm.   PS: assim a estrutura recebe todos os campos

  SELECT title author zpages price genre launch_date currency isbn
    FROM ztt0simoev_tm_b1
    INTO TABLE tl_livros
    WHERE launch_date IN p_date
      AND title IN s_title
      AND author IN p_author
      AND zpages IN p_zpages
      AND price IN p_price
      AND genre IN p_genre
      AND isbn IN p_isbn.
*     AND outro_campo IN/LIKE/EQ outra_variavel_filtro.

*--------------------------------------------------------------------*
*Display Loop
*--------------------------------------------------------------------*
*  LOOP AT tl_livros INTO wl_livros.
*    WRITE: /  wl_livros-title,
*             wl_livros-author,
*             wl_livros-currency,
*             wl_livros-genre,
*             wl_livros-isbn,
*             wl_livros-price,
*             wl_livros-zpages,
*            wl_livros-launch_date.
*  ENDLOOP.

  LOOP AT tl_livros INTO wl_livros.


    WRITE: / sy-vline,
               2(20) wl_livros-title,
               sy-vline, 24(20) wl_livros-isbn COLOR COL_KEY,
               sy-vline, 46(20) wl_livros-currency,
               sy-vline, 68(20) wl_livros-genre,
               sy-vline, 90(20) wl_livros-author,
               sy-vline, 114(20) wl_livros-price,
               sy-vline, 136(10) wl_livros-zpages,
               sy-vline, 148(20) wl_livros-launch_date,
               sy-vline,
             / sy-uline.


        ENDLOOP.
*&---------------------------------------------------------------------*
*& Report ZTT0SIMOEV_R_BOOK_STRUCTURE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztt0simoev_r_book_structure.

*DATA: wl_book_struct TYPE ztt0simoev_S_BOOK.
*
*wl_book_struct-title = 'Harry Potter'.
*wl_book_struct-author = 'J.K Rowling'.
*wl_book_struct-genre = 'Adventure'.
*wl_book_struct-launch_date = '19940912'.
*
*DATA: vl_price TYPE p LENGTH 3 DECIMALS 2.
*vl_price = '149.90'.
*wl_book_struct-price = vl_price.
*
*wl_book_struct-zpages = 356.
*
*WRITE: wl_book_struct-title,
*/ wl_book_struct-author,
*/ wl_book_struct-genre,
*/ wl_book_struct-launch_date,
*/ wl_book_struct-price,
*/ wl_book_struct-zpages.

* INSERT tabela FROM estrutura.

DATA: tl_books TYPE ztt0simoev_ct_book.

BREAK-POINT.
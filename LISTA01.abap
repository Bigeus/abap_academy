*&---------------------------------------------------------------------*
*& Report ZTT0SIMOEV_LISTA01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZTT0SIMOEV_LISTA01 LINE-SIZE 176.

TOP-OF-PAGE.

WRITE: sy-vline,
  5(30) 'Nome' COLOR COL_HEADING,
  sy-vline,
  40(30) 'Gênero' COLOR COL_HEADING,
  sy-vline,
  75(30) 'Preço' COLOR COL_HEADING,
  sy-vline,
  110(30) 'Duração em min' COLOR COL_HEADING,
  sy-vline,
  145(30) 'Nota' COLOR COL_HEADING,
  sy-vline,
  SY-ULINE.

START-OF-SELECTION.

 WRITE: / sy-vline,
 5(30) 'Zelda' COLOR COL_NORMAL,
 sy-vline,
 40(30) 'Ação e Aventura' COLOR COL_NORMAL,
 sy-vline,
 75(30) '300.00' COLOR COL_NORMAL,
 sy-vline,
 110(30) 400 COLOR COL_NORMAL,
 sy-vline,
 145(30) '9.8' COLOR COL_NORMAL,
 sy-vline,
 SY-ULINE.

 WRITE: / sy-vline,
 5(30) 'Elden Ring' COLOR COL_NORMAL,
 sy-vline,
 40(30) 'Combate' COLOR COL_NORMAL,
 sy-vline,
 75(30) '300.00' COLOR COL_NORMAL,
 sy-vline,
 110(30) 250 COLOR COL_NORMAL,
 sy-vline,
 145(30) '9.4' COLOR COL_NORMAL,
 sy-vline,
 SY-ULINE.

 WRITE: / sy-vline,
 5(30) 'The Witcher 3' COLOR COL_NORMAL,
 sy-vline,
 40(30) 'RPG' COLOR COL_NORMAL,
 sy-vline,
 75(30) '200.00' COLOR COL_NORMAL,
 sy-vline,
 110(30) 199 COLOR COL_NORMAL,
 sy-vline,
 145(30) '8.9' COLOR COL_NORMAL,
 sy-vline,
 SY-ULINE.

 WRITE: / sy-vline,
 5(30) 'Rocket League' COLOR COL_NORMAL,
 sy-vline,
 40(30) 'Esportes' COLOR COL_NORMAL,
 sy-vline,
 75(30) 'n/a' COLOR COL_NORMAL,
 sy-vline,
 110(30) 100 COLOR COL_NORMAL,
 sy-vline,
 145(30) '7.0' COLOR COL_NORMAL,
 sy-vline,
 SY-ULINE.

 WRITE: / sy-vline,
 5(30) 'Overwatch' COLOR COL_NORMAL,
 sy-vline,
 40(30) 'FPS Multiplayer' COLOR COL_NORMAL,
 sy-vline,
 75(30) 'n/a' COLOR COL_NORMAL,
 sy-vline,
 110(30) 200 COLOR COL_NORMAL,
 sy-vline,
 145(30) '7.5' COLOR COL_NORMAL,
 sy-vline,
 SY-ULINE.
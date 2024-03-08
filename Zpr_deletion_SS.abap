*&---------------------------------------------------------------------*
*& Include          ZPR_DELETION_SS
*&---------------------------------------------------------------------*

TABLES: eban.
SELECTION-SCREEN BEGIN OF BLOCK text-001 WITH FRAME TITLE TEXT-002.
  SELECT-OPTIONS: s_banfn FOR eban-banfn.
SELECTION-SCREEN END OF BLOCK text-001.

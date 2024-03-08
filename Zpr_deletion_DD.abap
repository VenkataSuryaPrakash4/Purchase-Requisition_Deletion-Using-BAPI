*&---------------------------------------------------------------------*
*& Include          ZPR_DELETION_DD
*&---------------------------------------------------------------------*

***Class Definition for Purchase requisition deletion.
CLASS pr_deletion DEFINITION FINAL.

  PUBLIC SECTION.
***strucure for EBAN table.
    TYPES: BEGIN OF ty_eban,
             banfn TYPE banfn,
             bnfpo TYPE bnfpo,
             matnr TYPE matnr,
             werks TYPE ewerk,
             matkl TYPE matkl,
           END OF ty_eban,

***Structure for MARA table.
           BEGIN OF ty_mara,
             matnr TYPE matnr,
             mtart TYPE mtart,
             mbrsh TYPE mbrsh,
             matkl TYPE matkl,
           END OF ty_mara.

    TYPES: tt_eban TYPE TABLE OF ty_eban,
           tt_mara TYPE TABLE OF ty_mara.

    CLASS-METHODS:
      main,

      get_pr_data
        CHANGING
          pr_data  TYPE tt_eban
          mat_data TYPE tt_mara,

      pr_deletion_data
        IMPORTING
          lt_delete TYPE tt_eban.

ENDCLASS.

*&---------------------------------------------------------------------*
*& Report ZOO_PRDELETION
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZOO_PRDELETION.

include zpr_deletion_dd.
include zpr_deletion_ss.
include zpr_deletion_validation.

START-OF-SELECTION.
  pr_deletion=>main( ).

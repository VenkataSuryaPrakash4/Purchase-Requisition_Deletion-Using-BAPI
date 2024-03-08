*&---------------------------------------------------------------------*
*& Include          ZPR_DELETION_VALIDATION
*&---------------------------------------------------------------------*
CLASS pr_deletion IMPLEMENTATION.

  METHOD main.
    DATA: lt_eban TYPE TABLE OF ty_eban,
          lt_mara TYPE TABLE OF ty_mara.

    get_pr_data( CHANGING
                  pr_data = lt_eban
                  mat_data = lt_mara ).

*    BREAK-POINT.
    pr_deletion_data( EXPORTING
                        lt_delete = lt_eban ).


  ENDMETHOD.

  METHOD get_pr_data.
    SELECT banfn,bnfpo,matnr,werks,matkl
      INTO TABLE @pr_data
      FROM eban
      WHERE banfn IN @s_banfn.

    IF pr_data[] IS NOT INITIAL.
      SELECT matnr,mtart,mbrsh,matkl
        INTO TABLE @mat_data
        FROM mara
        FOR ALL ENTRIES IN @pr_data
        WHERE matnr  = @pr_data-matnr.
    ENDIF.

  ENDMETHOD.


  METHOD pr_deletion_data.

***Data Declaration
    DATA: pr_number TYPE bapieban-preq_no,
          wa_item   TYPE bapieband,
          lt_item   TYPE TABLE OF bapieband,
          r_msg_log TYPE TABLE OF bapireturn.

***Looping on PR Deletion records.
    LOOP AT lt_delete INTO DATA(wa_delete).

***Mappings for workarea.
      pr_number = wa_delete-banfn.
      wa_item-preq_item = wa_delete-bnfpo.
      wa_item-closed = 'X'.
      wa_item-delete_ind = 'X'.
      APPEND wa_item TO lt_item.

***BAPI for PR deletion.
      CALL FUNCTION 'BAPI_REQUISITION_DELETE'
        EXPORTING
          number                      = pr_number
        TABLES
          requisition_items_to_delete = lt_item
          return                      = r_msg_log.

***BAPI Commit on success case.
      IF sy-subrc EQ 0.
        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = 'X'.
      ENDIF.

      CLEAR:wa_item.
    ENDLOOP.
***ALV Report Message log on failure case.
    READ TABLE r_msg_log WITH KEY type = 'E'
                         TRANSPORTING NO FIELDS.
    IF sy-subrc = 0.

***Field catalogue.
      DATA: lt_fcat TYPE TABLE OF slis_fieldcat_alv,
            lv_pos1 TYPE i VALUE 0.

      ADD 1 TO lv_pos1.
      APPEND VALUE #( col_pos = lv_pos1 fieldname = 'TYPE' seltext_m = 'Message Type' key = 'X') TO lt_fcat.
      ADD 1 TO lv_pos1.
      APPEND VALUE #( col_pos = lv_pos1 fieldname = 'CODE' seltext_m = 'Message Code' ) TO lt_fcat.
      ADD 1 TO lv_pos1.
      APPEND VALUE #( col_pos = lv_pos1 fieldname = 'LOG_NO' seltext_m = 'Message Description') TO lt_fcat.
      ADD 1 TO lv_pos1.
      APPEND VALUE #( col_pos = lv_pos1 fieldname = 'LOG_MSG_NO' seltext_m = 'Message Description') TO lt_fcat.
      ADD 1 TO lv_pos1.
      APPEND VALUE #( col_pos = lv_pos1 fieldname = 'MESSAGE_V1' seltext_m = 'Message Description') TO lt_fcat.
      ADD 1 TO lv_pos1.
      APPEND VALUE #( col_pos = lv_pos1 fieldname = 'MESSAGE_V2' seltext_m = 'Message Description') TO lt_fcat.
      ADD 1 TO lv_pos1.
      APPEND VALUE #( col_pos = lv_pos1 fieldname = 'MESSAGE_V3' seltext_m = 'Message Description') TO lt_fcat.
      ADD 1 TO lv_pos1.
      APPEND VALUE #( col_pos = lv_pos1 fieldname = 'MESSAGE_V4' seltext_m = 'Message Description') TO lt_fcat.
      ADD 1 TO lv_pos1.
      APPEND VALUE #( col_pos = lv_pos1 fieldname = 'MESSAGE_V5' seltext_m = 'Message Description') TO lt_fcat.


***Layout.
      DATA: wa_layout TYPE slis_layout_alv.
      wa_layout-zebra = 'X'.
      wa_layout-colwidth_optimize = 'X'.


      CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
        EXPORTING
          i_callback_program = sy-repid
          is_layout          = wa_layout
          it_fieldcat        = lt_fcat
        TABLES
          t_outtab           = r_msg_log
        EXCEPTIONS
          program_error      = 1
          OTHERS             = 2.

    ENDIF.

  ENDMETHOD.

ENDCLASS.

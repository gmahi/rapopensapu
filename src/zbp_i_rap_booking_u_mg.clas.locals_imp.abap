CLASS lhc_Booking DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE Booking.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE Booking.

    METHODS read FOR READ
      IMPORTING keys FOR READ Booking RESULT result.

    METHODS rba_Travel FOR READ
      IMPORTING keys_rba FOR READ Booking\_Travel FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lhc_Booking IMPLEMENTATION.

  METHOD delete.

    DATA messages TYPE /dmo/t_message.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<key>).

      CALL FUNCTION '/DMO/FLIGHT_TRAVEL_UPDATE'
        EXPORTING
          is_travel   = VALUE /dmo/s_travel_in( travel_id = <key>-travelid )
          is_travelx  = VALUE /dmo/s_travel_inx( travel_id = <key>-travelid )
          it_booking  = VALUE /dmo/t_booking_in( ( booking_id = <key>-bookingid ) )
          it_bookingx = VALUE /dmo/t_booking_inx( ( booking_id  = <key>-bookingid
                                                    action_code = /dmo/if_flight_legacy=>action_code-delete ) )
        IMPORTING
          et_messages = messages.

      IF messages IS INITIAL.

        APPEND VALUE #( travelid = <key>-travelid
                       bookingid = <key>-bookingid ) TO mapped-booking.

      ELSE.

        "fill failed return structure for the framework
        APPEND VALUE #( travelid = <key>-travelid
                        bookingid = <key>-bookingid ) TO failed-booking.

        LOOP AT messages INTO DATA(message).
          "fill reported structure to be displayed on the UI
          APPEND VALUE #( travelid = <key>-travelid
                          bookingid = <key>-bookingid
                  %msg = new_message( id = message-msgid
                                                number = message-msgno
                                                v1 = message-msgv1
                                                v2 = message-msgv2
                                                v3 = message-msgv3
                                                v4 = message-msgv4
                                                severity = CONV #( message-msgty ) )
         ) TO reported-booking.
        ENDLOOP.



      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD update.

    DATA messages TYPE /dmo/t_message.
    DATA legacy_entity_in  TYPE /dmo/booking.
    DATA legacy_entity_x TYPE /dmo/s_booking_inx.


    LOOP AT entities ASSIGNING FIELD-SYMBOL(<entity>).

      legacy_entity_in = CORRESPONDING #( <entity> MAPPING FROM ENTITY ).

      legacy_entity_x-booking_id = <entity>-BookingID.
      legacy_entity_x-_intx      = CORRESPONDING zsrap_booking_x_mg( <entity> MAPPING FROM ENTITY ).
      legacy_entity_x-action_code = /dmo/if_flight_legacy=>action_code-update.

      CALL FUNCTION '/DMO/FLIGHT_TRAVEL_UPDATE'
        EXPORTING
          is_travel   = VALUE /dmo/s_travel_in( travel_id = <entity>-travelid )
          is_travelx  = VALUE /dmo/s_travel_inx( travel_id = <entity>-travelid )
          it_booking  = VALUE /dmo/t_booking_in( ( CORRESPONDING #( legacy_entity_in ) ) )
          it_bookingx = VALUE /dmo/t_booking_inx( ( legacy_entity_x ) )
        IMPORTING
          et_messages = messages.



      IF messages IS INITIAL.

        APPEND VALUE #( travelid = <entity>-travelid
                       bookingid = legacy_entity_in-booking_id ) TO mapped-booking.

      ELSE.

        "fill failed return structure for the framework
        APPEND VALUE #( travelid = <entity>-travelid
                        bookingid = legacy_entity_in-booking_id ) TO failed-booking.
        "fill reported structure to be displayed on the UI

        LOOP AT messages INTO DATA(message).
          "fill reported structure to be displayed on the UI
          APPEND VALUE #( travelid = <entity>-travelid
                          bookingid = legacy_entity_in-booking_id
                  %msg = new_message( id = message-msgid
                                                number = message-msgno
                                                v1 = message-msgv1
                                                v2 = message-msgv2
                                                v3 = message-msgv3
                                                v4 = message-msgv4
                                                severity = CONV #( message-msgty ) )
         ) TO reported-booking.
        ENDLOOP.

      ENDIF.

    ENDLOOP.



  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD rba_Travel.
  ENDMETHOD.

ENDCLASS.

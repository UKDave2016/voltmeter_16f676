#include "settings.inc"
    
        ; I2C routines
    extern	    sendClock
    extern	    start_i2c
    extern	    stop_i2c
    extern	    write_i2c
    extern	    read_i2c
    extern	    ack_i2c
    extern	    noack_i2c


    global  DS1307_Init
    global  DS1307_ReadClock
    global  DS1307_Send
    
PROG    CODE
    
DS1307_Init
    call    start_i2c
    movlw   0xd0
    call    DS1307_Send
    movlw   0x00
    call    DS1307_Send
    call    start_i2c
    movlw   0xd1
    call    DS1307_Send
    call    read_i2c
    movwf   second
    call    noack_i2c
    btfss   second,7 ; test halt bit
    goto    DS1307_Init_exit
    ; clock is on halt
    call    start_i2c
    movlw   0xd0
    call    DS1307_Send
    movlw   0x00 ; time offset into the 1307 memory
    call    DS1307_Send
    movlw   0x00 ; reset seconds to clear the halt bit
    call    DS1307_Send
    
DS1307_Init_exit
    call    stop_i2c
    return
    
DS1307_ReadClock
    call    start_i2c
    movlw   0xd0
    call    DS1307_Send
    movlw   0x00	 ; time offset into the 1307 memory
    call    DS1307_Send
    call    stop_i2c
    call    start_i2c
    movlw   0xd1
    call    DS1307_Send
    call    read_i2c
    movwf   second
    call    ack_i2c
    call    read_i2c
    movwf   minute
    call    ack_i2c
    call    read_i2c
    movwf   hour
    call    ack_i2c
    call    read_i2c
    movwf   day
    call    stop_i2c
    return
    
DS1307_Send
    call    write_i2c
    call    sendClock
    return

    END



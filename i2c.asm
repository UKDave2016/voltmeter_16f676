#include "settings.inc"
    
    global	    sendClock
    global	    start_i2c
    global	    stop_i2c
    global	    write_i2c
    global	    read_i2c
    global	    ack_i2c
    global	    noack_i2c

PROG    CODE
    
sendClock
    BSF	    SCLPORT,SCL
    nop	    ;call delay_us
    nop	    ;call delay_us
    BCF	    SCLPORT,SCL
    return

start_i2c
    BCF	    SCLPORT,SCL
    BSF	    SDAPORT,SDA
    nop	    ;call delay_us
    BSF	    SCLPORT,SCL
    nop	    ;call delay_us
    BCF	    SDAPORT,SDA
    nop	    ;call delay_us
    BCF	    SCLPORT,SCL
    return
    
stop_i2c
    BCF	    SCLPORT,SCL
    nop	    ;call delay_us
    BCF	    SDAPORT,SDA
    nop	    ;call delay_us
    BSF	    SCLPORT,SCL
    nop	    ;call delay_us
    BSF	    SDAPORT,SDA
    return
    
    ; write the byte in W to the I2C bus
write_i2c
    movwf   dly3 ; temp hold
    movlw   8
    movwf   dly2
_write_i2c_loop
    btfss   dly3,7
    goto    _write_i2c_0
    BSF	    SDAPORT,SDA
    goto    _write_i2c_next
_write_i2c_0    
    BCF	    SDAPORT,SDA
_write_i2c_next
    call    sendClock
    rlf	    dly3,1
    decfsz  dly2,1
    goto    _write_i2c_loop
    bsf	    SDAPORT,SDA
    return
    
    ; read a byte and return it in W
read_i2c
    banksel TRISDA
    BSF	    TRISDA,SDA	; set port to input
    banksel SDAPORT
    movlw   8
    movwf   dly2
    clrf    dly3
    bcf	    STATUS,C
_read_i2c_loop
    BSF	    SCLPORT,SCL	; clock high
    rlf	    dly3,1	; running bits received
    btfsc   SDAPORT,SDA
    bsf	    dly3,0	; set the bit we received
    nop	    ;call delay_us
    bcf	    SCLPORT,SCL	; clock low
    decfsz  dly2,1
    goto    _read_i2c_loop
    movfw   dly3	; read our read value into 'W'
    banksel TRISDA
    BCF	    TRISDA,SDA	; set port back to output
    banksel SDAPORT
    return
    
ack_i2c    
    BCF	    SDAPORT,SDA
    call    sendClock
    BSF	    SDAPORT,SDA
    return
    
noack_i2c
    BSF	    SDAPORT,SDA
    call    sendClock
    BSF	    SCLPORT,SCL
    return
    
    END
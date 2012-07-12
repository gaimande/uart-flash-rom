
_choose:

;main.c,8 :: 		int choose (char m)
;main.c,10 :: 		if (m==1||m==2) return 1;
	MOVF       FARG_choose_m+0, 0
	XORLW      1
	BTFSC      STATUS+0, 2
	GOTO       L__choose45
	MOVF       FARG_choose_m+0, 0
	XORLW      2
	BTFSC      STATUS+0, 2
	GOTO       L__choose45
	GOTO       L_choose2
L__choose45:
	MOVLW      1
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	RETURN
L_choose2:
;main.c,11 :: 		else if (m==3||m==4) return 2;
	MOVF       FARG_choose_m+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L__choose44
	MOVF       FARG_choose_m+0, 0
	XORLW      4
	BTFSC      STATUS+0, 2
	GOTO       L__choose44
	GOTO       L_choose6
L__choose44:
	MOVLW      2
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	RETURN
L_choose6:
;main.c,12 :: 		else if (m==5||m==6) return 3;
	MOVF       FARG_choose_m+0, 0
	XORLW      5
	BTFSC      STATUS+0, 2
	GOTO       L__choose43
	MOVF       FARG_choose_m+0, 0
	XORLW      6
	BTFSC      STATUS+0, 2
	GOTO       L__choose43
	GOTO       L_choose10
L__choose43:
	MOVLW      3
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	RETURN
L_choose10:
;main.c,13 :: 		else if (m==7) return 4;
	MOVF       FARG_choose_m+0, 0
	XORLW      7
	BTFSS      STATUS+0, 2
	GOTO       L_choose12
	MOVLW      4
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	RETURN
L_choose12:
;main.c,14 :: 		else return 0;
	CLRF       R0+0
	CLRF       R0+1
;main.c,15 :: 		}
	RETURN
; end of _choose

_main:

;main.c,17 :: 		void main()
;main.c,20 :: 		TRISB = 0;
	CLRF       TRISB+0
;main.c,21 :: 		PORTB = 0xFF;
	MOVLW      255
	MOVWF      PORTB+0
;main.c,24 :: 		addr = 0x0500;
	MOVLW      0
	MOVWF      _addr+0
	MOVLW      5
	MOVWF      _addr+1
;main.c,26 :: 		UART1_Init(9600);               // Initialize UART module at 9600 bps
	MOVLW      129
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;main.c,27 :: 		Delay_ms(100);                  // Wait for UART module to stabilize
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_main14:
	DECFSZ     R13+0, 1
	GOTO       L_main14
	DECFSZ     R12+0, 1
	GOTO       L_main14
	DECFSZ     R11+0, 1
	GOTO       L_main14
	NOP
	NOP
;main.c,33 :: 		UART1_Write_Text("Enter a message from keyboard\n\r");
	MOVLW      ?lstr1_main+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;main.c,38 :: 		while(1)
L_main15:
;main.c,40 :: 		UART1_Write_Text("Your message is: ");
	MOVLW      ?lstr2_main+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;main.c,41 :: 		for(i=0; i< MAXLINE/8; i++)
	CLRF       _i+0
L_main17:
	MOVLW      128
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main18
;main.c,43 :: 		for(j=0; j<8; j++)
	CLRF       _j+0
L_main20:
	MOVLW      8
	SUBWF      _j+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main21
;main.c,45 :: 		Revieve_data:
___main_Revieve_data:
;main.c,46 :: 		if (UART1_Data_Ready())
	CALL       _UART1_Data_Ready+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main23
;main.c,47 :: 		uart_rd = UART1_Read();
	CALL       _UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      _uart_rd+0
	GOTO       L_main24
L_main23:
;main.c,49 :: 		goto Revieve_data;
	GOTO       ___main_Revieve_data
L_main24:
;main.c,50 :: 		if ((uart_rd == 'I') || (uart_rd == 'D'))
	MOVF       _uart_rd+0, 0
	XORLW      73
	BTFSC      STATUS+0, 2
	GOTO       L__main47
	MOVF       _uart_rd+0, 0
	XORLW      68
	BTFSC      STATUS+0, 2
	GOTO       L__main47
	GOTO       L_main27
L__main47:
;main.c,51 :: 		break;
	GOTO       L_main21
L_main27:
;main.c,52 :: 		dat_uart[j] = uart_rd;
	MOVF       _j+0, 0
	ADDLW      _dat_uart+0
	MOVWF      FSR
	MOVF       _uart_rd+0, 0
	MOVWF      INDF+0
;main.c,43 :: 		for(j=0; j<8; j++)
	INCF       _j+0, 1
;main.c,53 :: 		}
	GOTO       L_main20
L_main21:
;main.c,54 :: 		FLASH_Write(addr+i*4,dat_uart);
	MOVF       _i+0, 0
	MOVWF      R0+0
	CLRF       R0+1
	RLF        R0+0, 1
	RLF        R0+1, 1
	BCF        R0+0, 0
	RLF        R0+0, 1
	RLF        R0+1, 1
	BCF        R0+0, 0
	MOVF       R0+0, 0
	ADDWF      _addr+0, 0
	MOVWF      FARG_FLASH_Write_address+0
	MOVF       _addr+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      R0+1, 0
	MOVWF      FARG_FLASH_Write_address+1
	MOVLW      _dat_uart+0
	MOVWF      FARG_FLASH_Write_data_+0
	CALL       _FLASH_Write+0
;main.c,55 :: 		if ((uart_rd == 'I') || (uart_rd == 'D'))
	MOVF       _uart_rd+0, 0
	XORLW      73
	BTFSC      STATUS+0, 2
	GOTO       L__main46
	MOVF       _uart_rd+0, 0
	XORLW      68
	BTFSC      STATUS+0, 2
	GOTO       L__main46
	GOTO       L_main30
L__main46:
;main.c,56 :: 		break;
	GOTO       L_main18
L_main30:
;main.c,41 :: 		for(i=0; i< MAXLINE/8; i++)
	INCF       _i+0, 1
;main.c,61 :: 		}
	GOTO       L_main17
L_main18:
;main.c,63 :: 		addr = 0x0500;
	MOVLW      0
	MOVWF      _addr+0
	MOVLW      5
	MOVWF      _addr+1
;main.c,64 :: 		for (k = 0; k < i*4; k++)
	CLRF       _k+0
L_main31:
	MOVF       _i+0, 0
	MOVWF      R1+0
	CLRF       R1+1
	RLF        R1+0, 1
	RLF        R1+1, 1
	BCF        R1+0, 0
	RLF        R1+0, 1
	RLF        R1+1, 1
	BCF        R1+0, 0
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      R1+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main48
	MOVF       R1+0, 0
	SUBWF      _k+0, 0
L__main48:
	BTFSC      STATUS+0, 0
	GOTO       L_main32
;main.c,66 :: 		data_ = FLASH_Read(addr++);
	MOVF       _addr+0, 0
	MOVWF      FARG_FLASH_Read_address+0
	MOVF       _addr+1, 0
	MOVWF      FARG_FLASH_Read_address+1
	CALL       _FLASH_Read+0
	MOVF       R0+0, 0
	MOVWF      _data_+0
	MOVF       R0+1, 0
	MOVWF      _data_+1
	INCF       _addr+0, 1
	BTFSC      STATUS+0, 2
	INCF       _addr+1, 1
;main.c,67 :: 		Delay_us(10);
	MOVLW      16
	MOVWF      R13+0
L_main34:
	DECFSZ     R13+0, 1
	GOTO       L_main34
	NOP
;main.c,68 :: 		UART1_Write(data_);
	MOVF       _data_+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;main.c,69 :: 		UART1_Write(data_ >> 8);
	MOVF       _data_+1, 0
	MOVWF      R0+0
	CLRF       R0+1
	MOVF       R0+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;main.c,64 :: 		for (k = 0; k < i*4; k++)
	INCF       _k+0, 1
;main.c,71 :: 		}
	GOTO       L_main31
L_main32:
;main.c,72 :: 		if (0<j<8)
	MOVF       _j+0, 0
	SUBLW      0
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R1+0
	MOVLW      8
	SUBWF      R1+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main35
;main.c,74 :: 		for (k=0; k<choose(j); k++)
	CLRF       _k+0
L_main36:
	MOVF       _j+0, 0
	MOVWF      FARG_choose_m+0
	CALL       _choose+0
	MOVLW      128
	MOVWF      R2+0
	MOVLW      128
	XORWF      R0+1, 0
	SUBWF      R2+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main49
	MOVF       R0+0, 0
	SUBWF      _k+0, 0
L__main49:
	BTFSC      STATUS+0, 0
	GOTO       L_main37
;main.c,76 :: 		data_ = FLASH_Read(addr++);
	MOVF       _addr+0, 0
	MOVWF      FARG_FLASH_Read_address+0
	MOVF       _addr+1, 0
	MOVWF      FARG_FLASH_Read_address+1
	CALL       _FLASH_Read+0
	MOVF       R0+0, 0
	MOVWF      _data_+0
	MOVF       R0+1, 0
	MOVWF      _data_+1
	INCF       _addr+0, 1
	BTFSC      STATUS+0, 2
	INCF       _addr+1, 1
;main.c,77 :: 		Delay_us(10);
	MOVLW      16
	MOVWF      R13+0
L_main39:
	DECFSZ     R13+0, 1
	GOTO       L_main39
	NOP
;main.c,78 :: 		if(k == (choose(j)-1))
	MOVF       _j+0, 0
	MOVWF      FARG_choose_m+0
	CALL       _choose+0
	MOVLW      1
	SUBWF      R0+0, 0
	MOVWF      R2+0
	MOVLW      0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBWF      R0+1, 0
	MOVWF      R2+1
	MOVLW      0
	XORWF      R2+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main50
	MOVF       R2+0, 0
	XORWF      _k+0, 0
L__main50:
	BTFSS      STATUS+0, 2
	GOTO       L_main40
;main.c,80 :: 		if((j%2)==0)
	MOVLW      1
	ANDWF      _j+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main41
;main.c,82 :: 		UART1_Write(data_);
	MOVF       _data_+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;main.c,83 :: 		UART1_Write(data_ >> 8);
	MOVF       _data_+1, 0
	MOVWF      R0+0
	CLRF       R0+1
	MOVF       R0+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;main.c,84 :: 		break;
	GOTO       L_main37
;main.c,85 :: 		}
L_main41:
;main.c,88 :: 		UART1_Write(data_);
	MOVF       _data_+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;main.c,89 :: 		break;
	GOTO       L_main37
;main.c,91 :: 		}
L_main40:
;main.c,92 :: 		UART1_Write(data_);
	MOVF       _data_+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;main.c,93 :: 		UART1_Write(data_ >> 8);
	MOVF       _data_+1, 0
	MOVWF      R0+0
	CLRF       R0+1
	MOVF       R0+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;main.c,74 :: 		for (k=0; k<choose(j); k++)
	INCF       _k+0, 1
;main.c,95 :: 		}
	GOTO       L_main36
L_main37:
;main.c,96 :: 		}
L_main35:
;main.c,97 :: 		UART1_Write_Text("\n\rTotal of bytes in the message: ");
	MOVLW      ?lstr3_main+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;main.c,98 :: 		IntToStr(i*8 + j,total);
	MOVLW      3
	MOVWF      R0+0
	MOVF       _i+0, 0
	MOVWF      FARG_IntToStr_input+0
	CLRF       FARG_IntToStr_input+1
	MOVF       R0+0, 0
L__main51:
	BTFSC      STATUS+0, 2
	GOTO       L__main52
	RLF        FARG_IntToStr_input+0, 1
	RLF        FARG_IntToStr_input+1, 1
	BCF        FARG_IntToStr_input+0, 0
	ADDLW      255
	GOTO       L__main51
L__main52:
	MOVF       _j+0, 0
	ADDWF      FARG_IntToStr_input+0, 1
	BTFSC      STATUS+0, 0
	INCF       FARG_IntToStr_input+1, 1
	MOVLW      _total+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;main.c,99 :: 		UART1_Write_Text(total);
	MOVLW      _total+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;main.c,100 :: 		UART1_Write_Text("\n\r-----------------------------------\r\n");
	MOVLW      ?lstr4_main+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;main.c,101 :: 		}
	GOTO       L_main15
;main.c,102 :: 		}
	GOTO       $+0
; end of _main

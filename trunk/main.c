/* Global variable */
#define MAXLINE 1024
char  uart_rd,total[3];
unsigned int i,j,k;
char dat_uart[8]={0,0,0,0,0,0,0,0};
unsigned int addr,data_;

int choose (char m)
{
	if (m==1||m==2) return 1;
	else if (m==3||m==4) return 2;
	else if (m==5||m==6) return 3;
	else if (m==7) return 4;
	else return 0;
}

void main()
{
	/* Init Port for Led */
    TRISB = 0;
    PORTB = 0xFF;

	/* Set Flash address to store data from UART */
	addr = 0x0500;

    UART1_Init(9600);               // Initialize UART module at 9600 bps
	Delay_ms(100);                  // Wait for UART module to stabilize

	//UART1_Write_Text("**********************************************************************");
	//UART1_Write_Text("*VIETTEL'S TEST: COMMUNICATE UART BETWEEN PC AND MICROCONTROLLER PIC**");
	//UART1_Write_Text("******************* Candidate: DO VAN QUYEN  *************************");
	//UART1_Write_Text("**********************************************************************\n\r");
	UART1_Write_Text("Enter a message from keyboard\n\r");
	//UART1_Write_Text("Enter 'I' to commplete the message and to arrange by increasing or\n\r");
	//UART1_Write_Text("enter 'D' to commplete the message and to arrange by decreasing.\n\r");
	//UART1_Write_Text("----------------------------------------------------------------------\n\r\n\r");

	while(1)
	{
		UART1_Write_Text("Your message is: ");
		for(i=0; i< MAXLINE/8; i++)
		{
			for(j=0; j<8; j+=2)
			{
				Revieve_data:
				if (UART1_Data_Ready())
					uart_rd = UART1_Read();
				else
					goto Revieve_data;
				if ((uart_rd == 'I') || (uart_rd == 'D'))
					break;
				dat_uart[j] = uart_rd;
			}
			FLASH_Write(addr+i*4,dat_uart);
			if ((uart_rd == 'I') || (uart_rd == 'D'))
				break;
			PORTB = 0x00;
			Delay_ms(50);
			PORTB = 0xFF;
			Delay_ms(50);
		}

		addr = 0x0500;
		for (k = 0; k < i*4; k++)
		{
			data_ = FLASH_Read(addr++);
			Delay_us(10);
			UART1_Write(data_);
		}
		if (1<j<9)
		{
			for (k=0; k < j/2; k++)
			{
				data_ = FLASH_Read(addr++);
				Delay_us(10);
				UART1_Write(data_);
			}
		}
		UART1_Write_Text("\n\rTotal of bytes in the message: ");
		IntToStr(i*4 + j/2,total);
		UART1_Write_Text(total);
		UART1_Write_Text("\n\r-----------------------------------\r\n");
		while(1);
	}
}
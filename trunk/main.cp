#line 1 "E:/Code Project/uart-flash-rom/main.c"


char uart_rd,total[3];
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

 TRISB = 0;
 PORTB = 0xFF;


 addr = 0x0500;

 UART1_Init(9600);
 Delay_ms(100);





 UART1_Write_Text("Enter a message from keyboard\n\r");




 while(1)
 {
 UART1_Write_Text("Your message is: ");
 for(i=0; i<  1024 /8; i++)
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

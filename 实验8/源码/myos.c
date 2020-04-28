/*myos.c文件*/
/*部分字符串函数参考了cplusplus标准库*/
/*主函数为myos*/ 
#include "PCB.h"
extern void cls();
extern void printchar();
extern void getchar(); 
extern void gettime();
extern void run(); 
extern void run33();
extern void run34();
extern void run35();
extern void run36();
extern void showOUCH();   
extern void upper();   
extern void lower(); 
extern void int21h_call33h(); 
extern void int21h_call34h(); 
extern void int21h_call35h(); 
extern void int21h_call36h(); 
extern void int21h_run4prog();  
extern void int21h_showdata();
extern void run_process();

char in;	/*存储输入字符*/ 
char num;	/*存储待执行程序序号*/ 
char hour,min,sec;	/*存储时分秒*/ 
char input[100],output[100],buf[100];	/*输入区 输出区 缓冲区*/ 
int i,j,tmp;	/*中间变量*/ 
char sector_number, sector_size;

typedef struct{			/*构建文件信息表*/ 
	char name[20];
	char size[20];
	char index[5];
}table;

table t[5]={		/*t存储着文件信息*/ 
	{"program1","1673Bytes ","11"},
	{"program2","5364Bytes ","12"},
	{"program3","1912Bytes ","13"},
	{"program4","1598Bytes ","14"},
	{"myos    ","3095Bytes ","2-10"}		
};

void print(char *str)	/*打印字符串*/ 
{
	while(*str != '\0'){
		printchar(*str);
		str++;
	}
}

int getline(char str[],int len)	/*输入一行，长度至多为len*/ 
{
	if(!len)
		return 0;
	i=0;
	getchar();
	while(in!='\n'&&in!='\r') {
		int k=in;
		if(k==8){
			i--;
			getchar();
			continue;
		}
		printchar(in);
		str[i++]=in;
		if(i==len){
			str[i]='\0';
			printchar('\n');
			return 0;
		}
		getchar();
	}
	str[i]='\0';
	print("\n\r");
    return 1;
}



int strcmp(char* str1,char* str2)	/*比较字符串*/ 
{
	while(*str1!='\0'&&*str2!='\0'){
		if(*str1!=*str2) 
			return 0;
		str1++;
		str2++;
	}
	if(*str1=='\0'&&*str2=='\0') 
		return 1;
	return 0;
}

void strcpy(char src[],char dest[])	/*字符串拷贝*/ 
{
	i=0;
	while(src[i]!='\0'){
		dest[i]=src[i];
		i++;
	}
	dest[i]='\0';
}


int substr(char src[],char dest[],int begin,int len)	/*获取子字符串*/ 
{
	for(i=begin; i<begin+len; i++)
		dest[i-begin] = src[i];
	dest[begin+len]='\0';
}

int strlen(char str[])	/*获取字符串长度*/ 
{
	i=0;
	while(str[i]!='\0')
		i++;
	return i;
}

void printInt(int n)	/*打印整数*/ 
{
	i=0;
	while(n){
		tmp=n%10;
		output[i++]='0'+tmp;
		n/=10;
	}
	for(j=0; j<i; j++)
		buf[j]=output[i-j-1];
	for(j=0; j<i; j++)
		output[j]=buf[j];	
	output[i]='\0';
	print(output);
}

void time()	/*获取时间。这里调用function.asm函数*/ 
{
	/*hour转换并输出*/ 
	gettime();
	tmp=hour/16*10+hour%16;  
	if(tmp==0) 
		print("00");
	else if(tmp>0 && tmp<10) 
		printchar('0');
	printInt(tmp);
	printchar(':');
	/*min转换并输出*/ 
	tmp=min/16*10+min%16;
	if(tmp==0) 
		print("00");
	else if(tmp>0 && tmp<10) 
		printchar('0');
	printInt(tmp);
	printchar(':');
	/*sec转换并输出*/ 
	tmp=sec/16*10+sec%16;
	if(tmp==0) 
		print("00");
	else if(tmp>0 && tmp<10) 
		printchar('0');
	printInt(tmp);
	print("\r\n\n");
}

void ChooseToRun()	/*根据输入运行对应程序*/ 
{
	/*判断用户命令是否valid*/ 
	for(j=4; j<strlen(input); j++){
		if(input[j]<'1' || input[j]>'4'){
			print("There is no such program!Please use the combination of 1,2,3!\n\n");
			return;
		}
	}
	/*如果valid，则执行相应程序*/ 
	for(j = 4; j<strlen(input); j++){
		if(input[j]==' ') 
			continue;
		else if(input[j]>='1' && input[j]<='4'){
			num=input[j]-'0'+7;
			run();
		}
	}
}



to_upper(char *p)
{
	while(*p!='\0'){
		if(*p>='a' && *p<='z')
			*p=*p-32;
		p++;
	}
}

to_lower(char *p)
{
	while(*p!='\0'){
		if(*p>='A' && *p<='Z')
			*p=*p+32;
		p++;
	}
}

void to_run_myprogram()
{
	for(j = 1; j<=4; j++){
		num=j+7;
		run();
	}
}

void help_21h()
{
	cls();
	print("@This is INT 21h\n\r");
	print("@Please select the function number\n\n\r");		
	print("    #0 : show OUCH!\n\r");
	print("    #1 : lower to upper                   #2 : upper to lower\n\r"); 
	print("    #3 : call INT 33h                     #4 : call INT 34h\n\r"); 
	print("    #5 : call INT 35h                     #6 : call INT 36h\n\r"); 
	print("    #7 : run my program 1-4               #8 : show my information\n\r"); 
	print("    #9 : quit INT 21h\r\n\r\n"); 	
}

void call21h()
{
	help_21h();
	while(1)
	{
		print(">>>"); 
		getline(input,20);
	    if(strcmp(input,"0")){
			showOUCH();
			help_21h();   	
		}
	    else if(strcmp(input,"1"))
		{
			print("Please enter a sentence:");
			getline(input,30);
			upper(input);
			print(input);
			print("\r\n\n");
		}
	    else if(strcmp(input,"2"))
		{
			print("Please enter a sentence:");
			getline(input,30);
			lower(input);
			print(input);
			print("\r\n\n");
		}
	    else if(strcmp(input,"3")){
			int21h_call33h();
			help_21h();   	
		}
	    else if(strcmp(input,"4")){
			int21h_call34h();	  
			help_21h(); 	
		}
	    else if(strcmp(input,"5")){
			int21h_call35h();	 
			help_21h();   	
		}
	    else if(strcmp(input,"6")){
			int21h_call36h();
			help_21h();	    	
		}
		else if(strcmp(input,"7")){
			int21h_run4prog();	
			help_21h();		
		}
		else if(strcmp(input,"8")){
			int21h_showdata();
			help_21h();		
		}
	    else if(strcmp(input,"9"))
			break;
	}
}



void help()	/*提示信息*/ 
{
	cls();
	print("@Welcome to myos\n\r");
	print("@Please select the function according to the prompt\n\r\n");
	print("    #cls: Clear the screen       #time: Get the time\r\n");
	print("    #author: Show the author of program\r\n");
	print("    #run: Run any number of program  e.g: run 23131\n\r"); 
	print("    #pro: Execute multi-proesses e.g: pro 1234\n\r");
	print("    #test: Test Test the semaphore mechanism in lab8\n\r");	
	print("    [Quick CMD]: #a.cmd: Excute prog1 2 3 4 sequentially.\n\r");
	print("                 #b.cmd: Excute 1.cmd then get the time\n\r");
	print("                 #c.cmd: Show the file name & size & disk\n\r");
	print("    Others: int 33h , int 34h , int 35h , int 36h\n\n\r");
}


void create_process(char *comm) {
	int i, sum = 0, flag = 0;
	for (i = 3; i < strlen(comm); ++i) {
		if (comm[i] == ' ' || comm[i] >= '1' && comm[i] <= '4') continue;
		else {
			print("invalid program number: ");
			printChar(comm[i]);
			print("\n\n\r");
			return;
		}
	}
	for (i = 3; i < strlen(comm); ++i) {
		if (comm[i] != ' ') flag = 1;
	}
	if (flag == 0) {
		print("invalid input\n\n\r");
		return;
	}
	for (i = 3; i < strlen(comm) && sum < MAX_PCB_NUMBER; ++i) {
		if (comm[i] == ' ') continue;
		sum++;
		sector_number = comm[i] - '0';
		sector_size = 1;
		run_process();
	}
	PCB_initial(&PCB_LIST[0], 1, 0x1000);
	kernal_mode = 0;
}


void myos(){
	initial_PCB_settings();
	initsema();
	kernal_mode = 1;
	help();
	while(1)	/*一直循环运行*/ 
	{
		print(">>>");
	    getline(input,30);
	    if(strcmp(input, "name")){
	    	print("[NAME]\r\n");
	    	for(i=0;i<5;i++){
	    		print(t[i].name); print("\r\n");	    		
			}
	    	print("\n");
		}
		else if(strcmp(input, "size")){
	    	print("[NAME]    [SIZE]\r\n");
	    	for(i=0;i<5;i++){
	    		print(t[i].name); print("  ");
	    		print(t[i].size); print("\r\n");
	    	}
	    	print("\n");		
		}
		else if(strcmp(input, "author"))
			print("17341178 XueWeihao\r\n\n");
	    else if(strcmp(input,"time"))
			time();
		else if(strcmp(input,"cls"))
			help();
		else if(strcmp(input,"a.cmd")){
			for(i=1;i<=4;i++){
				num=i+14;
				run();
			}
			help();
		}
		else if(strcmp(input,"b.cmd")){
			for(i=1;i<=4;i++){
				num=i+14;
				run();
			}
			help();
			time();
		}
		else if(strcmp(input,"c.cmd")){
	    	print("[NAME]    [SIZE]        [DISK]\r\n");
	    	for(i=0;i<5;i++){
	    		print(t[i].name); print("  ");
	    		print(t[i].size); print("    ");
	    		print(t[i].index); print("\r\n");
			}
			print("\n");			
		}
		else if(substr(input,buf,0,3) && strcmp(buf,"run")){
			ChooseToRun();
			help();
		}
		else if(strcmp(input,"int 21h")){
			call21h();
			help();
		}
		else if(strcmp(input,"int 33h")){
			run33();
			help();
		}
		else if(strcmp(input,"int 34h")){
			run34();
			help();
		}
		else if(strcmp(input,"int 35h")){
			run35();
			help();
		}
		else if(strcmp(input,"int 36h")){
			run36();
			help();
		}
		else if (substr(input,buf,0,3) && strcmp(buf,"pro")){
			create_process(input);
			help();			
		}
		else if(strcmp(input,"test")){
			cls();
			sector_number = 5;
			sector_size = 2;
			run_process();
			kernal_mode = 0;
		}
	    else
			print("Can't find the function, please try again.\r\n\n");
	}
}

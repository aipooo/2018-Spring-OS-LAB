/*myos.c文件*/
/*部分字符串函数参考了cplusplus标准库*/
/*主函数为myos*/ 

extern void cls();
extern void printchar();
extern void getchar(); 
extern void gettime();
extern void run(); 
extern void run33();
extern void run34();
extern void run35();
extern void run36();  

char in;	/*存储输入字符*/ 
char num;	/*存储待执行程序序号*/ 
char hour,min,sec;	/*存储时分秒*/ 
char input[100],output[100],buf[100];	/*输入区 输出区 缓冲区*/ 
int i,j,tmp;	/*中间变量*/ 

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

void upper(char str[])	/*小写转大写*/ 
{
   	i=0;
   	while(str[i]) {
     	if(str[i]>='a' && str[i]<='z')  
      		str[i]=str[i]+'A'-'a';
	  	i++;
    }
    print("\r");
    print(str);
    print("\r\n\n");
}

void lower(char str[])	/*大写转小写*/ 
{
   	i=0;
   	while(str[i]) {
     	if(str[i]>='A' && str[i]<='Z')  
      		str[i]=str[i]-'A'+'a';
	  	i++;
    }
    print("\r");
    print(str);	
    print("\r\n\n");
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

int strlen(char str[])	/*获取字符串长度*/ 
{
	i=0;
	while(str[i]!='\0')
		i++;
	return i;
}

int substr(char src[],char dest[],int begin,int len)	/*获取子字符串*/ 
{
	for(i=begin; i<begin+len; i++)
		dest[i-begin] = src[i];
	dest[begin+len]='\0';
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
			num=input[j]-'0'+14;
			run();
		}
	}
}

void help()	/*提示信息*/ 
{
	cls();
	print("@Welcome to myos\n\r");
	print("@Please select the function according to the prompt\n\r\n");
	print("#cls: Clear the screen       #time: Get the time\r\n");
	print("#author: Show the author of program\r\n");
	print("#lower: Upper to lower  e.g: lower ABCDE\r\n");
	print("#upper: Lower to upper  e.g: upper abcde\r\n");
	print("#run: Run any number of program  e.g: run 23131\n\r"); 
	print("[Quick CMD]: #a.cmd: Excute prog1 2 3 4 sequentially.\n\r");
	print("             #b.cmd: Excute 1.cmd then get the time\n\r");
	print("             #c.cmd: Show the file name & size & disk\n\r");
	print("Others: int 33h , int 34h , int 35h , int 36h\n\n\r");
}

void myos(){
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
		else if(substr(input,buf,0,5) && strcmp(buf,"upper")){
			substr(input,buf,6,strlen(input));
			upper(buf);			
		}
		else if(substr(input,buf,0,5) && strcmp(buf,"lower")){
			substr(input,buf,6,strlen(input));
			lower(buf);			
		}
		else if(substr(input,buf,0,3) && strcmp(buf,"run"))
		{
			ChooseToRun();
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
	    else
			print("Can't find the function, please try again.\r\n\n");
	}
}

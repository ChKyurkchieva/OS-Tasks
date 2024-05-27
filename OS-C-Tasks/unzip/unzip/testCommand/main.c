#include<err.h>
#include<unistd.h>
#include<stdbool.h>
#include<stdio.h>
#include<time.h>
#include<string.h>
#include<stdlib.h>
#include<fcntl.h>
int main(int argc, char* argv[])
{
	if(argc!=1)
	{
		err(1,"Usage: %s", argv[0]);
	}
	char fileName[2048];
    snprintf(fileName,2048,"%d", getpid());
	printf(fileName);
	printf(" \n");
	int fileDescriptor = open(fileName, O_WRONLY | O_CREAT | O_TRUNC, 0666);
	if(fileDescriptor == -1)
	{
		err(1, "error opening file");
	}
	
	char buffer[1];
	while(read(0, buffer, sizeof(char))==1)
	{
		write(fileDescriptor, buffer, 1);
	}
	
	close(fileDescriptor);
	return 0;
}


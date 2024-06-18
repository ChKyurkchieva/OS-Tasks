#include <err.h>
#include <unistd.h>
#include <sys/wait.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/wait.h>

pid_t myFork(void)
{
	pid_t pid = fork();
	if(pid == -1)
	{
		err(1, "Couldn't fork()\n");
	}
	return pid;
}

void myPipe(int p[2])
{
	if(pipe(p) < 0)
	{
		err(1, "Couldn't pipe()\n");
	}
}

void findExecution(char* directory)
{
	if(execlp("find", "find", directory, "-type", "f", "-not", "-name","*.hash", NULL) == -1)
	{
		err(1, "exec find was NOT successful\n");
	}
}

int myOpen(char* fileName)
{
	int fileDescriptor = open(fileName, O_RDWR | O_CREAT, 0644);
	if (fileDescriptor < 0)
	{
		err(1, "Something gone wrong with opening %s for reading and writing\n", fileName);
	}
	return fileDescriptor;
}

int myRead(int fileDescriptor, char* string, int size)
{
	int readString = 0;
	if((readString = read(fileDescriptor, string, size)) < 0)
	{
		err(1, "Something went wrong with reading from file descriptor\n");
		return -1;
	}

	return readString;
}

int myWrite( int fileDescriptor, char* string, int size)
{
	int written = 0; 
	if( (written = write(fileDescriptor, string, size)) < 0)
	{
		err(1, "Something gone wrong with writing in file\n");
		return -1;
	}
	return written;
}

void myClose(int fileDescriptor)
{
	if (close(fileDescriptor) == -1)
	{
		err(1, "Something went wrong with closing file descriptor\n");
	}
}

int readLine(int fileDescriptor) 
{
	char c = ' ';
	char newLine = '\n';
	int readChar = 0;
	//TODO READING LINE FROM FILE DECRIPTOR
	int size = 0;
	
	while((readChar = myRead(fileDescriptor, &c, 1)) > 0)
	{
		if ( c == newLine)
		{
			break;
		}
		if( c == '\r')
		{
			printf("kur\n");
		}
		size++;
	}
	return size;
}

void removingTempFile(char* name)
{
	pid_t rmChild=myFork();
	if(rmChild == 0)
	{
		if (execlp("rm", "rm", name, NULL)== -1)
		{
			err(1, "Something went wrong with execution of rm\n");
		}
	}
}

void clearTempFile(char* fileName)
{
	char fileNameHash[2048];
	fileNameHash[strlen(fileName)+5]='\0';
	strcpy(fileNameHash,fileName);
	strcat(fileNameHash, ".hash");
	removingTempFile(fileName);
	removingTempFile(fileNameHash);
}

int main(int argc, char* argv[]) {
	
	if( argc != 2)
	{
		err(1, "Usage: %s <path_to_directory>\n", argv[0]);
	}

	int status = 0;
	char fileName[2048];
	snprintf(fileName, 2048, "%d", (int)time(NULL));

	pid_t findPID = myFork();
	int fileDescriptor = -1;// choose sth;
	if(findPID == 0)
	{
		//child
		fileDescriptor = myOpen(fileName); // my be two FDs
		dup2(fileDescriptor, 1);
		//close(1);
		findExecution(argv[1]);
		return -1; 
	}
	if (wait(&status) == -1)
	{
		err(1, "Something went wrong with waitng child to finish\n"); 
	}
	if(WIFEXITED(status))
	{
		fileDescriptor = myOpen(fileName);
		char* line = NULL;	
		int readS = 0;

		do
		{
			int size = readLine(fileDescriptor);
			line = malloc(size+1);
			lseek(fileDescriptor, -(size+1), SEEK_CUR);
			//TODO myLseek
			myRead(fileDescriptor, line, size);
			line[size]='\0';

			int size_hash = 5; //.hash
			char hash[] = ".hash";
			char *newFile=malloc(size+1+size_hash);
			strcpy(newFile, line);
			strcat(newFile, hash);
			//md5sum
			if(strcmp(newFile, ".hash")!=0)
			{	pid_t child = myFork();
				if (child == 0)
				{
					myClose(fileDescriptor);
					int hashFD = myOpen(newFile);
					dup2(hashFD, 1);
					myClose(hashFD);
					if (execlp("md5sum", "md5sum", newFile, NULL) == -1)
					{
						err(1, "Something went wrong with execution of md5sum\n");
					}
				}
			}
			lseek(fileDescriptor, 2, SEEK_CUR);
			free(line);
			free(newFile);
			lseek(fileDescriptor, -(size+1), SEEK_CUR);
		} while((readS = readLine(fileDescriptor)) != 0);
		
	myClose(fileDescriptor);
	}

	clearTempFile(fileName);
	return 0;
}

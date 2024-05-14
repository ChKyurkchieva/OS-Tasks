#include <err.h>
#include <unistd.h>
#include <time.h>
#include <stdio.h>
#include <fcntl.h>
#include <sys/wait.h>

int openFile(char* fileName)
{
	int fileDescriptor = open(fileName, O_WRONLY | O_CREAT, 0666);
	if(fileDescriptor == -1)
	{
		err(1, "Couldn't open for writing %s\n", fileName);
	}
	return fileDescriptor;
}

int main(int argc, char *argv[]) 
{

	if (argc != 1)
	{
		err(1, "Usage: <command>");
		return -1;
	}

	if(argv==NULL)
	{
		err(1, "Something in execution of this program goes wrong");
		return -1;
	}

	char fileName[2048];
	snprintf(fileName,2048,"%d", (int)time(NULL));

	int fileDescriptor = openFile(fileName);

	int status;

	pid_t firstChildPID = fork();
	if (firstChildPID < 0)
	{
		err(1, "system call fork() was NOT successful\n");
	}

	pid_t secondChildPID = fork();
	if (secondChildPID < 0)
	{
		err(1, "system call fork() was NOT successful\n");
	}

	if (firstChildPID == 0)
	{
		if (write(fileDescriptor, "foo", sizeof("foo"))!= sizeof("foo"))
		{
			err(1, "First child writing was NOT succsessful\n");
		}
	}
	
	if (secondChildPID == 0)
	{
		waitpid(firstChildPID, &status);	
		if (write(fileDescriptor, "bar", sizeof("bar"))!= sizeof("bar"))
		{
			err(1, "Second child writing was NOT succsessful\n");
		}
	}



	return 0;
}

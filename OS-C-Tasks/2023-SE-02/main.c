#include <err.h>
#include <unistd.h>
#include <sys/wait.h>
#include <string.h>
#include <stdbool.h>
#include <stdlib.h>

int hasFoundIt(int found, int numCommands, pid_t *pids)
{
	int status;
	if(found)
	{
		for(int i = 0; i < numCommands; i++)
		{
			if(kill(pids[i], SIGTERM) < 0)
			{
				err(26, "killing process %d unsuccessful\n", pids[i]);
			}
		}
		while(wait(NULL) > 0);
		status = 0;
	}
	else
	{
		while(wait(NULL) > 0);
		status = 1;
	}
	return status;
}

void myPipe(int p[2])
{
	if(pipe(p) < 0)
	{
		err(26, "pipe() is unsuccessful\n");
	}
}

pid_t myFork(pid_t pid)
{
	pid = fork();
	if(pid < 0)
	{
		err(26, "fork() is unsuccessful\n");
	}
	return pid;
}

void myExec(char* argv)
{
	if( execlp(argv, argv, NULL) < 0)
	{
		err(26, "Could NOT exec %s\n", argv);
	}
}

void myDup2(int oldFD, int newFD)
{
	if( dup2(oldFD, newFD) < 0)
	{
		err(26, "duplicate pipe unsuccessful\n");
	}
}

off_t myLseek(int fileDescriptor, off_t offset, int whence)
{
	if(lseek(fileDescriptor, offset, whence) < 0)
	{
		err(26, "Couldn't lseek()\n");
	}
	return offset;
}

int searchingFor(int found, int size, int pipes[][2])
{	
	const char foundit[] = "found it!";
	int stringSize = strlen(foundit);
	const int BUFFER_SIZE = 1024; 
	char buffer [BUFFER_SIZE];
	buffer[stringSize] = '\0';
	for(int i = 0; i < size; i++)
	{
		int nbytes = 0;
		while( (nbytes = read(pipes[i][0], buffer, stringSize)) == stringSize)
		{
			if( strstr(buffer, foundit) )
			{
				found = 1;
				break;
			}
			myLseek(pipes[i][0], -(stringSize-1), SEEK_CUR);
		}
		close(pipes[i][0]);
		if(found)
		{
			break;
		}
	}
	return found;
}

int main(int argc, char* argv[]) {

	if(argc < 2)
	{
		err(26, "Usage: <command_name> <command_parameter> {<command_parameter>}\n");
		return 26;
	}

	int pipes[argc - 1][2];
	pid_t pids[argc - 1];

	for(int i = 0; i < (argc - 1); i++)
	{
		myPipe(pipes[i]);
		pids[i] = myFork(pids[i]);
		if(pids[i] == 0)
		{
			//child process
			close(pipes[i][0]); //closing read end of the pipe in the child
			myDup2(1, pipes[i][1]);
			myExec(argv[i+1]);
		}
		else
		{
			//parent process
			close(pipes[i][1]); //closing write end of the pipe in the parent
		}
	}

	int found = 0;
	found = searchingFor(found, argc -1, pipes);

	int status = hasFoundIt(found, argc - 1, pids);

	return status;
}

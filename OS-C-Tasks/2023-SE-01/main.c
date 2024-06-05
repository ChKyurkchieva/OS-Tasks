#include <err.h>
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

void findExecution(void)
{
	if(execlp("find", "find", argv[1], "type - f", "-not", "-name","*.hash") == -1)
	{
		err(1, "exec find was NOT successful\n");
	}
}

void readLine(char* from, int sizeFrom)
{
	char c;
	char newLine = '\n';
	int read;
	//TODO READING LINE FROM FILE DECRIPTOR
	//while( (read = read(fileDecri 

}

int main(int argc, char* argv[]) {
	
	if( argc != 2)
	{
		err(1, "Usage: <command> <path_to_directory>\n");
	}

	int status;

	int pipeFind[2];
	myPipe(pipeFind);
	close(pipeFind[0]);

	//Create file using PID of procces for name and open its file descriptors
	pid_t findPID = myFork();
	//create pipe

	if(findPID == 0)
	{
		//child
		close(pipeFind[1]);
		dup2(0, pipeFind[0]);
		close(0);
		findExecution();
	}
	 //parent

	return 0;
}

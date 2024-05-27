#include <err.h>

int main(int argc, char* argv[]) {
	
	if( argc != 2)
	{
		err(1, "Usage: <command> <path_to_directory>\n");
	}

	int status;
	//Create file using PID of procces for name and open its file descriptors
	pid_t findPID = fork();

	if(findPID == -1)
	{
		err(1, "fork() was NOT successful\n");
	}

	if(findPID == 0)
	{
		//child
		if(execlp("find", "find", argv[1], "type - f") == -1)
		{
			err(1, "execlp() was NOT successful\n");
		}
	}
	if(wait(&status) == -1)
	{
		err(1, "wait() was NOT successful\n");
	}

	if( !WIFEXITED )
	{
		err(1, "child process is NOT  exited\n");
	}

	if(WEXITSTATUS(&status) != 0)
	{
		err(1, "child process is NOT exited successfuly\n");
	}
	
	return 0;
}

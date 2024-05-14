#include <unistd.h>
#include <err.h>
#include <sys/wait.h>

int main(int argc, char* argv[]) {

	if (argc != 3)
	{
		err(1, "Usage: <command> <parameter> <parameter>\n");
		return -1;
	}

	int status;
	pid_t childPID = fork();
	if (childPID < 0)
	{
		err(1, "system call fork() was NOT successful\n");
		return -1;
	}

	if(childPID >0)
	{
		wait(&status);
		if( WIFEXITED(status) && WEXITSTATUS(status) == 0)
		{
			if (execlp(argv[2], argv[2], (char*)NULL) == -1)
			{
				err(1, "error while exec command\n");
			}
		}
		else
		{
			return 42;
		}

	}
	else
	{
		if (execlp(argv[1], argv[1], (char*)NULL) == -1)
		{
			err(1, "error while exec command\n");
			return 42;
		}
	}


	return 0;
}

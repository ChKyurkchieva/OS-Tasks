#include <unistd.h>
#include <err.h>
#include <sys/wait.h>
#include <stdio.h>

int main(int argc, char* argv[]) {

	if (argc>0 && argc < 2) 
	{
		err(1, "Usage: <command> <command> {<command>}\n");
		return -1;
	}

	int success=0, fail=0, executed=0;

	for (int i = 1; i <argc; i++)
	{
		int status;
		pid_t childPID = fork();
		if ( childPID > 0 )
		{
			//parent
			wait(&status);
			if (WIFEXITED(status) && WEXITSTATUS(status) == 0)
			{ 
				success++;
			}
			else
			{
				fail++;
			}
			executed++;
		}
		else
		{
			//child
			if (execlp(argv[i], argv[i], (char*)NULL) == -1)
			{
				err(1, "Error while executing %s\n", argv[i]);
			}
		}
	}

	char buffer[256];
	int length = snprintf(buffer, sizeof(buffer), "Executed: %d\tSuccess: %d\tFailed: %d\n", executed, success, fail);

	write(1, buffer, length);

	return 0;
}

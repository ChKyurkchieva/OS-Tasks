#include <unistd.h>
#include <err.h>
#include <string.h>
#include <stdio.h>
#include <sys/wait.h>

int main(int argc, char *argv[]) {
	pid_t child_pid;
	int status;
	char buffer[1024];

	if (argc != 4)
	{
		err(1, "Usage: <command> <command> <command> <command>");
		return -1;
	}
	
	for(int i=1; i<=3; i++)
	{
		child_pid = fork();
		if( child_pid == -1)
		{
			err(1, "Error: fork() is unsuccessful");
		}
		if(child_pid > 0)
		{
			//father
			wait(&status);

			if(WIFEXITED(status) && WEXITSTATUS(status) == 0)
			{
				int written = snprintf(buffer, 1024, "PID: %d \t EXITSTATUS: %d \n", child_pid, status);
				write(1, buffer, written); 
			}

		}
		else
		{
			//child
			execlp(argv[i],argv[i], (char*)NULL);
			err(1, "Couldn't execute %s", argv[i]);
		}

	}
	return 0;
}

#include <err.h>
#include <sys/wait.h>
#include <unistd.h>
#include <string.h>

int main(int argc, char* argv[]) 
{
	
	if (argc != 2)
	{
		err(1, "Usage: <execution file> <command>");
	}

	pid_t child_pid = fork();
	int status;

	if (child_pid == -1)
	{
		err(1, "Error: fork() is unsuccesfull");
	}

	if(child_pid>0)
	{
		wait(&status);
		if(WIFEXITED(status))
		{
			write(1, argv[1], strlen(argv[1]));
			write(1, "\n", 1);
		}
	}
	else
	{
		if( execlp( argv[1], argv[1], (char*)NULL) == -1)
		{
			err(1, "error while exec command");
		}
	}
	return 0;

}

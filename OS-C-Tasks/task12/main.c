#include <unistd.h>
#include <err.h>
#include <sys/wait.h>
#include <fcntl.h>
#include <string.h>

int main(int argc, char* argv[]) {

	if (argc != 4)
	{
		err(1, "Usage: <command> <command> <command> <file_name>\n");
		return -1;
	}

	int fileDescriptor = open(argv[3], O_WRONLY | O_CREAT | O_TRUNC, 0666);
	if( fileDescriptor == -1 )
	{
		err(1, "Couldn't open %s for writing\n", argv[3]);
		return -1;
	}

	int status; 

	pid_t childPID = fork();
	if(childPID < 0)
	{
		err(1, "system call fork() is NOT successfuly executed\n");
	}

	if (childPID > 0)
	{
		//father
		wait(&status);
		if (WIFEXITED(status) && WEXITSTATUS(status) == 0)
		{
			if (write(fileDescriptor, argv[1], strlen(argv[1])) < 0)
			{
				err(1, "Something went wrong while writing in %s\n", argv[3]);		
			}
		}

		if(execlp(argv[2], argv[2], (char*)NULL) == -1)
		{
			err(1, "Couln't execute %s properly\n", argv[2]);
		}
	}
	else
	{
		//child
		if (execlp(argv[1], argv[1], (char*)NULL) == -1)
		{
			err(1, "Couldn't execute %s properly\n", argv[1]);
		}
	}

	close(fileDescriptor);
	return 0 ;
}

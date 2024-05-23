#include <unistd.h>
#include <err.h>
#include <sys/wait.h>
#include <string.h>
#include <stdio.h>
int main(int argc, char* argv[]) {

	if (argc != 3 )
	{
		err(1, "Usage: <command> <command> <command>\n");
		return -1;
	}

	int status;
	pid_t firstChild;

	firstChild = fork();
	if(firstChild < 0)
	{
		err(1, "system call fork() was NOT successfull\n");
		return -1;
	}

	if(firstChild > 0)
	{
		
		pid_t secondChild = fork();
		if(secondChild < 0)
		{
			err(1, "system call fork() was NOT successfull\n");
			return -1;
		}
	

		if(secondChild > 0)
		{
		//parent
			pid_t firstExited = wait(&status);
			char buffer[256];
			if(WIFEXITED(status))
			{
				if(WEXITSTATUS(status) == 0)
				{
					int length = snprintf(buffer, sizeof(buffer), "%d\n", firstExited) ;
					if( write(1, buffer, length) != length)
					{
						err(2, "Writing was NOT successful\n");
					}
				}
			}
			else
			{
				if( write(1, "-1", strlen("-1")) != strlen("-1"))
				{
					err(2, "Writing was NOT successfull\n");
				}
			}
		}
		if(secondChild == 0)
		{
			if( execlp(argv[2],argv[2], (char*)NULL) == -1)
			{
				err(2, "Execution of %s was NOT successful\n", argv[2]);
				return -1;
			}
		}
	}
	if( firstChild == 0)
	{
		if( execlp(argv[1], argv[1], (char*)NULL) == -1)
		{
			err(2, "Execution of %s was NOT successful\n", argv[1]);
			return -1;
		}	
	}

	return 0;
}

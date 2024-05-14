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
	//int status;
	pid_t firstChild, secondChild;

	firstChild = fork();
	if(firstChild < 0)
	{
		err(1, "system call fork() was NOT successfull\n");
		return -1;
	}

	secondChild = fork();
	if(secondChild < 0)
	{
		err(1, "system call fork() was NOT successfull\n");
		return -1;
	}

	if( firstChild > 0 && secondChild > 0)
	{
		//parent
		siginfo_t info;
		waitid(P_ALL, 0, &info, WEXITED);
		if(WEXITED)
		{
			char buffer[256];
			int length = snprintf(buffer, sizeof(buffer), "%d\n", info.si_pid) ;
			if( write(1, buffer, length) != length)
			{
				err(2, "Writing was not successful\n");
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
	else if( firstChild == 0)
	{
		if( execlp(argv[1],argv[1], (char*)NULL) == -1)
		{
			err(2, "Execution of %s was NOT successful\n", argv[1]);
		}
	}
	else if( secondChild == 0)
	{
		if( execlp(argv[2], argv[2], (char*)NULL) == -1)
		{
			err(2, "Execution of %s was NOT successful\n", argv[2]);
		}	
	}


	return 0;
}

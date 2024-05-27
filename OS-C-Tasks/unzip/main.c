#include<err.h>
#include<unistd.h>
#include<stdbool.h>
#include<stdio.h>
#include<string.h>
#include<sys/wait.h>

void childWork(int secondPipe[2], char *argv)
{
    dup2(secondPipe[0], 0);
    close(secondPipe[0]);
    close(secondPipe[1]);
    char buffer1[256] = {0};
    strcat(buffer1, "./");
    strcat(buffer1, argv);
    if (execlp(buffer1, argv, (char *)NULL) == -1)
        err(1, "second execlp() not successful");
}

int main(int argc, char *argv[])
{

    if(argc != 3)
		err(1, "Usage: %s <command_parameter> <command_parameter>", argv[0]);
	
	int status;
	int firstPipe[2];
	if(pipe(firstPipe) == -1)
		err(1, "first call of pipe() was NOT successful\n");

	int secondPipe[2];
	if(pipe(secondPipe) == -1)
		err(1, "second call of pipe() was NOT successful\n");

	pid_t first_child = fork();
	if(first_child == -1)
		err(1, "fork() was NOT successful");

	pid_t second_child = -1;
	if(first_child > 0)
	{
		//parent
		second_child = fork();
		if(second_child == -1)
			err(1,"second call of fork() was NOT successful\n");
	}

	if(second_child == 0)
	{
		//second_child
		close(firstPipe[0]);
		close(firstPipe[1]);

        childWork(secondPipe, argv[2]);
    }
	else if(first_child == 0)
	{
		//first_child
		close(secondPipe[0]);
		close(secondPipe[1]);

		childWork(firstPipe, argv[1]);
	}
	else
	{
		close(firstPipe[0]);
		close(secondPipe[0]);
		bool who = 0; //first child =0, second = 1
		char buffer[1];
		char c = '\n';
		while(read(0, buffer, sizeof(char))>0)
		{
			if(!who)	
				write(firstPipe[1],buffer, 1);
			else
				write(secondPipe[1],buffer, 1);
			if(buffer[0]==c)
				who = !who;
		}
		waitpid(first_child, &status, 0);
		waitpid(second_child, &status, 0);	
		close(firstPipe[1]);
		close(secondPipe[1]);
		write(1,"Happy?\n", sizeof("Happy?\n"));
		return 0;
	}
	return 0;
}
#include<err.h>
#include<unistd.h>
#include<stdbool.h>
#include<stdio.h>
void newPipe(int in, int out)
{
	int pipeFD[2] = {in, out};
	if(pipe(pipeFD) == -1)
	{
		err(1, "\n");
	}
}

int main(int argc, char* argv[]) {

	if(argc != 3)
	{
		err(1, "Usage: %s <command_parameter> <command_parameter>", argv[0]);
	}
	int firstPipe[2];
	if(pipe(firstPipe) == -1)
	{
		err(1, "\n");
	}

	int secondPipe[2];
	pipe(secondPipe);

	pid_t first_child = fork();
	if(first_child == -1)
	{
		err(1, "fork() was NOT successful");
	}

	pid_t second_child = -1;
	if(first_child > 0)
	{
		//parent
		second_child = fork();
		if(second_child == -1)
		{
			err(1,"\n");
		}
	}

	if(second_child == 0)
	{
		//second_child
		close(firstPipe[0]);
		close(firstPipe[1]);
		close(secondPipe[1]);

		//execlp("date", "date", (char*)NULL);
		char buffer[1];
		while(read(secondPipe[0], buffer, sizeof(char))>0)
		{
			write(1, "2", 1);
			write(1, buffer, 1);
		}
		close(secondPipe[0]);
	}
	else if(first_child == 0)
	{
		//first_child
		close(secondPipe[0]);
		close(secondPipe[1]);
		close(firstPipe[1]);
		//execlp("ls", "ls", (char*)NULL);
		//dup2(firstPipe[0], 1);
		char buffer[1];
		while (read(firstPipe[0], buffer, sizeof(char))>0)
		{
			write(1, "1", 1);
			write(1, buffer, 1);
		}
		close(firstPipe[0]);
	}
	else
	{
		close(firstPipe[0]);
		close(secondPipe[0]);
		bool who = 0; //first child =0, second = 1
		char buffer[1];
		char c = '\n';
		//char r = '\r';
		while(read(0, buffer, sizeof(char))>0)
		{
			if(!who)
			{
				write(firstPipe[1],buffer,1);
			}
			else
			{
				write(secondPipe[1],buffer,1);
			}
			if(buffer[0]==c)
			{
				who = !who;
			}
		}
		close(firstPipe[1]);
		close(secondPipe[1]);
	}
	return 0;
}

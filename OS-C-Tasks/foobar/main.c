#include <stdio.h>
#include <err.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/wait.h>


int main(int argc, char *argv[]) 
{
	if ( argc != 2) 
	{
		err(1, "Usage: <command> <path_file>");
		return -1;
	}
	int file_descriptor = open(argv[1], O_RDWR | O_CREAT | O_TRUNC, 0666);
	if( file_descriptor == -1 )
	{
		err(1, "Couldn't open %s properly!", argv[1]);
		return -1;
	}

	pid_t child_pid = fork();
	
	if ( child_pid < 0 )
	{
		err(1, "fork() was unsuccessful");
		close(file_descriptor);
	}

	int status;
	if ( child_pid > 0 )
	{
		wait(&status);
		//father
		char buffer[128];
		
		if (lseek(file_descriptor,0, SEEK_SET) == -1)
		{
			err(1, "Error while trying to lseek()");
			close(file_descriptor);
			return -1;
		}

		int read_file = read(file_descriptor, buffer, strlen("foobar"));
		
		if (read_file < 0)
		{
			err(1, "Reading from %s was not successful!", argv[1]);
		}
		
		for( int i = 0; i < read_file; i++)
		{
			write(1, &(buffer[i]), sizeof(buffer[i]));
			write(1, " ", 1);
		}
	}
	else
	{
		//child
		write(file_descriptor, "foobar", 6);
	}
	close(file_descriptor);
	return 0;
}

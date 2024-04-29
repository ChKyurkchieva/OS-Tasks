#include <err.h>
#include <unistd.h>
#include <fcntl.h>

void writeFile(int fileDescriptor, char* buffer, int readChar)
{
	int writeResult;
	if((writeResult = write(fileDescriptor, buffer, readChar))<	
readChar)
	{
		err(4, "Couldn't write properly!");
	}
}

int main(int argc, char* argv[]) {
	if (argc != 3)
	{
		errx(1, "Usage: <command> <source> <destination>");
	}
	// opening file1 for reading and file2 for writing
	int fdSource, fdDestination;
	if ((fdSource = open(argv[1], O_RDONLY)) < 0)
	{
		err(2, "Couldn't open %s for reading!\n", argv[1]);
	}
	
	if ((fdDestination = open(argv[2], O_WRONLY | O_TRUNC | O_CREAT, 0666))<0)
	{
		err(3, "Couldn't open %s for writing!\n", argv[2]);
	}
	// read from file1 into buffer

	char buffer[1];
	char replacement[] = "?";
	char toReplace[] = ":";
	int readResult;

	while((readResult = read(fdSource, buffer, sizeof(buffer))) > 0)
	{
		if (buffer[0] == toReplace[0])
		{
			writeFile(fdDestination, replacement, readResult);
		}
		else
		{
			writeFile(fdDestination, buffer, readResult);
		}
	}
	if(readResult>0)
	{
		err(5, "Error occured while reading %s!", argv[1]);
	}
	close(fdSource);
	close(fdDestination);

	return 0;
}

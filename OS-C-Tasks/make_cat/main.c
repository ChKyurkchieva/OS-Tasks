#include <unistd.h>
#include <err.h>
#include <fcntl.h>

int openFileDescriptor(const char* filename, int flags)
{
	int fileDescriptor = open(filename, flags);
	if ( fileDescriptor < 0)
	{
			err(1, "Culdn't open %s!\n", filename);
	}
	return fileDescriptor;
}

void closeFileDescriptor(int fileDescriptor)
{
	if (close(fileDescriptor)!=0)
	{
		err(2, "Error while closing file descriptor occured!");
	}
}

void catFile(const char* filename)
{
	int fileDescriptor=openFileDescriptor(filename, O_RDONLY);
	char buffer[4096];
	int readResult, writeResult;
	while((readResult=read(fileDescriptor, buffer, sizeof(buffer))) > 0)
	{
		if((writeResult = write(0, buffer, readResult)) < readResult)
		{
			err(3, "Couldn't write properly %s!", filename);
		}
	}

	if(readResult>0)
	{
		err(4, "Error occured while reading %s!", filename);
	}
	closeFileDescriptor(fileDescriptor);
}


int main(int argc, char *argv[]) {
	if ( argc < 1)
	{
		errx(1, "Error occured!\n");
	}
	if ( argc == 1)
	{
		return 0;
	}
	for ( int i = 1; i< argc; i++)
	{
		catFile(argv[i]);
	}

	return 0;
}

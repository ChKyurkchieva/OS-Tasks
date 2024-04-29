#include <unistd.h>
#include <err.h>
#include <fcntl.h>

int compareStrings ( char* string1, int sizeString1, char* string2, int sizeString2)
{
	if ( sizeString1!=sizeString2)
		return 1;

	for (int i=0; i<sizeString1; i++)
	{
		if(string1[i]!=string2[i])
			return 1;
	}
	return 0;
}

int main(int argc, char* argv[]) {
	
	if (argc != 3)
	{
		errx(1, "Usage: <command> <--min | --max | --print> <file>");
	}
	
	if (compareStrings(argv[1], sizeof(argv[1]),"--min", 5) ||
		compareStrings(argv[1], sizeof(argv[1]), "--max",5) ||
		compareStrings(argv[1], sizeof(argv[1]), "--print", 7))
	{
		errx(1, "Usage: <comand> <--min | --max | --print> <file>");
	}

	uint16_t minNumber, maxNumber;
	uint16_t number;
	int fileDescriptor;
	if ( (fileDescriptor = open(argv[2], O_RDONLY)) < 0)
	{
		err(2, "Couldn't open %s for reading!\n", argv[2]);
	}

	//TASK IS NOT COMPLETE
	return 0;
}

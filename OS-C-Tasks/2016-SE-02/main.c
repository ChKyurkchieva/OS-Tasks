#include <unistd.h>
#include <err.h>
#include <stdint.h>
#include <fcntl.h>
int openFile(const char* fileName, int mode)
{
        int fd = open(fileName, mode);
        if ( fd == -1 )
        {
                err(1, "Error occured while opening %s", fileName);
        }
        return fd;
}

void extractInfo(int positionFD, int sourceFD, int destinationFD)
{
        uint32_t start;
        uint32_t interval;
        ssize_t readBytes;
        if((readBytes = read(positionFD, &start, sizeof(start))) == -1)
        {
                err(1, "Error occured while reading start from file");
        }
        if( readBytes != sizeof(start))
        {
                err(1, "Incomplete read");
        }
        if((readBytes = read(positionFD, &interval, sizeof(interval))) == -1)
        {
                err(1, "Error occured while reading interval from file");
        }
        if(readBytes != sizeof(interval))
        {
                err(1, "Incomplete reading");
        }
        if(lseek(sourceFD, start, SEEK_SET) == -1)
        {
                err(1, "Error occured while lseek");
        }
        for(int i = 0; i < (int)interval; i++)
        {
                uint32_t number;
                if((readBytes=read(sourceFD, &number, sizeof(number))) == -1)
                {
                        err(1, "Error occured while reading from source file");
                }
                if(readBytes != sizeof(number))
                {
                        err(1, "Incomplete reading");
                }
                if(lseek(destinationFD, 0, SEEK_END) == -1)
                {
                        err(1, "Error ocured while seek");
                }
                if(write(destinationFD, &number, sizeof(number)) == -1)
                {
                        err(1, "Error occured while writing a number into destination file");
                }
        }
        if(lseek(sourceFD, 0, SEEK_SET) == -1)
        {
                err(1, "Error occured while lseek");
        }
}

int main(int argc, const char* argv[])
{
        if( argc != 4 )
        {
                err(1, "Usage: %s <path_to_file> <path_to_file> <path_to_file>", argv[0]);
        }
        int positionFD = openFile(argv[1], O_RDONLY);
        int sourceFD = openFile(argv[2], O_RDONLY);
        int destinationFD = openFile(argv[3], O_WRONLY);
        extractInfo(positionFD, sourceFD, destinationFD);
        close(positionFD);
        close(sourceFD);
        close(destinationFD);
        return 0;
}
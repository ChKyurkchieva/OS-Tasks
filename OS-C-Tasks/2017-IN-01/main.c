#include <unistd.h>
#include <err.h>
#include <fcntl.h>
#include <stdint.h>

int openReadingFile(const char* fileName, int mode)
{
    int fileDescriptor = open(fileName, mode);
    if (fileDescriptor == -1)
    {
        err(1, "Error occurred while opening for reading %s", fileName);
    }
    return fileDescriptor;
}

int openWritingFile(const char* fileName, int mode)
{
    int fileDescriptor = open(fileName, mode, 0644);
    if (fileDescriptor == -1)
    {
        err(1, "Error occurred while opening for writing %s", fileName);
    }
    return fileDescriptor;
}

ssize_t readNumbers(int fileDescriptor, void* number, size_t size)
{
    ssize_t readBytes = read(fileDescriptor, number, size);
    if (readBytes == -1)
    {
        err(1, "Error occurred while reading number from file");
    }

    if (readBytes == 0)
    {
        return 0;  // EOF reached
    }

    if (readBytes < (ssize_t)size)
    {
        warnx("Incomplete reading: expected %zu bytes, but got %zd bytes", size, readBytes);
    }
    return readBytes;
}

void writeNumbers(int fileDescriptor, const void* number, size_t size)
{
    ssize_t writtenBytes = write(fileDescriptor, number, size);
    if (writtenBytes == -1)
    {
        err(1, "Error occurred while writing in file");
    }
    if (writtenBytes < (ssize_t)size)
    {
        err(1, "Incomplete writing: expected to write %zu bytes, but only wrote %zd bytes", size, writtenBytes);
    }
}

int main(int argc, const char* argv[])
{
    if (argc != 5)
    {
        err(1, "Usage: %s <file1.dat> <file1.idx> <file2.dat> <file2.idx>", argv[0]);
    }

    int datSourceFD = openReadingFile(argv[1], O_RDONLY);
    int idxSourceFD = openReadingFile(argv[2], O_RDONLY);
    int datDestinationFD = openWritingFile(argv[3], O_WRONLY | O_CREAT | O_TRUNC);
    int idxDestinationFD = openWritingFile(argv[4], O_WRONLY | O_CREAT | O_TRUNC);

    uint16_t position[1];
    uint8_t length[1], notUsable[1];

    while (readNumbers(idxSourceFD, position, sizeof(uint16_t)) > 0 &&
           readNumbers(idxSourceFD, length, sizeof(uint8_t)) > 0 &&
           readNumbers(idxSourceFD, notUsable, sizeof(uint8_t)) > 0)
    {
        uint8_t string[256];
        off_t changedPosition;
        if ((changedPosition = lseek(datSourceFD, position[0], SEEK_SET)) == -1 || changedPosition < position[0])
        {
            err(1, "Error while seeking. Data may be corrupted.");
        }

        readNumbers(datSourceFD, string, length[0]);
        if( string[0] >= 0x41 && string[0]<= 0x5A)
                {
                writeNumbers(datDestinationFD, string, length[0]);
                }
        // Write back the same idx structure to the destination index file
        writeNumbers(idxDestinationFD, position, sizeof(uint16_t));
        writeNumbers(idxDestinationFD, length, sizeof(uint8_t));
        writeNumbers(idxDestinationFD, notUsable, sizeof(uint8_t));
    }

    close(datSourceFD);
    close(idxSourceFD);
    close(datDestinationFD);
    close(idxDestinationFD);

    return 0;
}

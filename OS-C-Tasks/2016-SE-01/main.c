#define _GNU_SOURCE
#include <err.h>
#include <unistd.h>
#include <stdbool.h>
#include <stdio.h>
#include <string.h>
#include <sys/wait.h>
#include <fcntl.h>
#include <stdint.h>
#include <stdlib.h>
#define MAX_BUFFER_SIZE 1024

int openFileDescriptor(const char* filename, int flags)
{
        int fileDescriptor = open(filename, flags, 0644);
        if (fileDescriptor < 0)
        {
        err(1, "Culdn't open %s!\n", filename);
        }
        return fileDescriptor;
}

void closeFileDescriptor(int fileDescriptor)
{
        if (close(fileDescriptor) != 0)
        {
                err(1, "Error while closing file descriptor occured!");
        }
}

int compareBytes(const void* a, const void* b)
{
    return ( *(uint8_t*)(uintptr_t)a - *(uint8_t*)(uintptr_t)b );
}

void insertByteInFile(int fileDescriptorRead, int fileDescriptorWrite, uint8_t byte)
{
    uint8_t lastReadByte;
    off_t offset = 0;

    if (read(fileDescriptorRead, &lastReadByte, sizeof(lastReadByte)) < 0)
    {
        err(1, "Error occured while reading single byte from file");
    }

    while(compareBytes(&lastReadByte, &byte) < 0)
    {
        offset+=1;
        if (read(fileDescriptorRead, &lastReadByte, sizeof(lastReadByte)) < 0)
        {
            err(1, "Error occured while reading single byte from file");
        }
    }
    lseek(fileDescriptorWrite, offset, SEEK_CUR);
    write(fileDescriptorWrite, &byte, sizeof(byte));
}

int main(int argc, const char* argv[])
{
    if (argc != 2)
        {
                err(1, "Usage: %s <path_to_file>", argv[0]);
                return -1;
        }
    int fileDescriptor = openFileDescriptor(argv[1], O_RDONLY);

    uint8_t buffer[MAX_BUFFER_SIZE];
    char tempFileName[] = "/tmp/tmpXXXXXX";
    int tempFDRead = openFileDescriptor(tempFileName, O_RDONLY);
    int tempFDWrite = openFileDescriptor(tempFileName, O_WRONLY);
    int bytesRead;
    while((bytesRead = read(fileDescriptor, buffer, sizeof(buffer))) > 0)
    {
        qsort(buffer, bytesRead, sizeof(uint8_t), compareBytes);

        for (int i = 0; i < bytesRead; i++)
        {
            insertByteInFile(tempFDRead, tempFDWrite, buffer[i]);
        }
    }

    if (bytesRead < 0)
    {
        err(1, "Error while reading %s", argv[0]);
    }
    closeFileDescriptor(fileDescriptor);
    closeFileDescriptor(tempFDRead);
    closeFileDescriptor(tempFDWrite);
    if (rename(tempFileName, argv[0]) == -1)
    {
        err(1, "Error occured while replace original file with temporary file.");
    }
    return 0;
}
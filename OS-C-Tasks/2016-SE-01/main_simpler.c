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

int openFileDescriptor(const char* filename, int flags) {
    int fileDescriptor = open(filename, flags, 0644);
    if (fileDescriptor < 0) {
        err(1, "Couldn't open %s!\n", filename);
    }
    return fileDescriptor;
}

void closeFileDescriptor(int fileDescriptor) {
    if (close(fileDescriptor) != 0) {
        err(1, "Error while closing file descriptor occurred!");
    }
}

int compareBytes(const void* a, const void* b) {
    return (*(uint8_t*)(uintptr_t)a - *(uint8_t*)(uintptr_t)b);
}

int main(int argc, const char* argv[])
{
    if (argc != 2) 
    {
        err(1, "Usage: %s <path_to_file>", argv[0]);
        return -1;
    }

    int fileDescriptor = openFileDescriptor(argv[1], O_RDONLY);
    if (fileDescriptor < 0) 
    {
        err(1, "Failed to open input file");
    }

    uint8_t buffer[MAX_BUFFER_SIZE];
    ssize_t bytesRead = read(fileDescriptor, buffer, sizeof(buffer));

    if (bytesRead < 0) 
    {
        err(1, "Error while reading %s", argv[1]);
    }

    qsort(buffer, bytesRead, sizeof(uint8_t), compareBytes);

    closeFileDescriptor(fileDescriptor);
    fileDescriptor = openFileDescriptor(argv[1], O_WRONLY | O_TRUNC);

    if (write(fileDescriptor, buffer, bytesRead) != bytesRead) 
    {
        err(1, "Failed to write sorted data back to the original file");
    }

    closeFileDescriptor(fileDescriptor);

    return 0;
}
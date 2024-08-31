#include <unistd.h>
#include <string.h>
#include <sys/wait.h>
#include <err.h>
#include <stdbool.h>
int readData(int fd, void* data, size_t size)
{
        int readBytes = read(fd, data, size);
        if(readBytes < 0)
        {
                err(1, "Error occured while reading");
        }
        if(readBytes == 0)
        {
                return 0;
        }
        return readBytes;
}

int main(int argc, const char* argv[])
{
        if( argc != 1)
        {
                err(1, "Usage: %s", argv[0]);
        }

        char command[1024];
        int status;
        while(true)
        {
                write(1, "Prompt: ", 9);
                size_t readBytes = read(0, command, sizeof(command) - 1);
                if(readBytes == 0)
                {
                        break;
                }
                command[readBytes - 1] = '\0';
                if(strcmp(command, "exit") == 0)
                {
                        break;
                }
                pid_t childPID = fork();
                if(childPID == -1)
                {
                        err(1, "Error occured while fork()");
                }
                if(childPID == 0)
                {
                        execlp(command, command, (char*)NULL);
                        err(1, "Error occured while executing %s", command);
                }
                else
                {
                        if(wait(&status) == -1)
                        {
                                err(1, "Error occurred while waiting for child process");
                        }
                }
        }
        return 0;
}
#include <unistd.h>
#include <err.h>
#include <sys/wait.h>
#include <stdbool.h>
#include <string.h>
#include <signal.h>
//TODO: SIGNAL HANDLING 
size_t readData(int fd, char* buffer, size_t maxLength) {
    char c;
    size_t count = 0;

    while (count < maxLength)
    {
        ssize_t bytesRead = read(fd, &c, 1);
        if (bytesRead < 0)
        {
            err(1, "Error occurred while reading");
        }
        else if (bytesRead == 0 || c == ' ' || c == '\n')
        {
                if(bytesRead == 0)
                        {
                                return 0;
                        }
            break;
        }

        buffer[count++] = c;
    }

    if (count == maxLength)
    {
        ssize_t bytesRead = read(fd, &c, 1);
        if (bytesRead > 0 && c != ' ' && c != '\n')
        {
            errx(1, "Error: input string too long");
        }
    }
    buffer[count] = '\0';
    return count;
}

void execute(const char* command)
{
        char argument1[5];
        char argument2[5];
        while(!stop)
        {
                ssize_t readBytes1 = readData(0, argument1, 4);
                if(readBytes1 == 0)
                {
                        break;
                }
                ssize_t readBytes2 = readData(0, argument2, 4);
                if(readBytes2 == 0)
                {
                        argument2[0] ='\0';
                }
                int status;
                pid_t childPID = fork();
                if(childPID < 0)
                {
                        err(1, "Error while fork");
                }
                if(childPID == 0)
                {
                        if(argument2[0] != '\0')
                        {
                                execlp(command, command, argument1, argument2, (char*)NULL);
                        }
                        else
                        {
                                execlp(command, command, argument1, (char*)NULL);
                        }
                        err(1, "Error while executing %s", command);
                }
                else
                {
                        if(wait(&status) == -1)
                        {
                                err(1, "Error while waiting child process to end its tasks");
                        }
                }
        }
}

int main(int argc, const char* argv[])
{
        if(argc != 1 && argc != 2)
        {
                err(1, "Usage: %s <command>", argv[0]);
        }

        if(argc == 1)
        {
                execute("echo");
        }
        else
        {
                if(strlen(argv[1]) > 4)
                {
                        err(1, "Error: Command name too long");
                }
                execute(argv[1]);
        }
        return 0;
}
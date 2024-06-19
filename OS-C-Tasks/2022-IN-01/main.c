#include <err.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>
#include <sys/wait.h>

void safePipe(int p[2])
{
    if(pipe(p) < 0)
    {
        err(1, "Something went wrong with creating a pipe\n");
    }
}

void childMessageHandling(int N, int readPipe[2], int writePipe[2], const char* receivedMessage, const char* sendMessage)
{
    char message[6]; // Ensure space for null terminator
    for (int i = 0; i < N; i++)
    {
        if (read(readPipe[0], message, 5) == 5)
        {
            message[5] = '\0'; // Null-terminate the string
            if (strcmp(message, receivedMessage) == 0)
            {
                write(1, sendMessage, strlen(sendMessage));
                write(writePipe[1], sendMessage, strlen(sendMessage));
            }
        }
    }
}

void parentMessageHandling(int N, int D, int readPipe[2], int writePipe[2], const char* receivedMessage, const char* sendMessage)
{
        for (int i = 0; i < N; ++i)
        {
        if (i == 0)
        {
           // Parent starts the process by writing "DING"
            write(1, sendMessage, strlen(sendMessage));
            write(writePipe[1], sendMessage, strlen(sendMessage));
        }
        else
        {
                // Parent waits to read "DONG" from child
            char message[6];
            if (read(readPipe[0], message, 5) == 5)
            {
                message[5] = '\0'; // Null-terminate the string
                if (strcmp(message, receivedMessage) == 0)
                {
                    sleep(D);  // Simulate the parent taking time to do something
                    write(1, sendMessage, strlen(sendMessage));
                    write(writePipe[1], sendMessage, strlen(sendMessage));
                }
            }
        }
     }
}


int main(int argc, char* argv[])
{
    if (argc != 3)
    {
        err(1, "Usage: <command> <N> <D>\n");
    }
    int N = atoi(argv[1]);
    int D = atoi(argv[2]);

    const char ding[] = "DING\n";
    const char dong[] = "DONG\n";

    int dingPipe[2];
    safePipe(dingPipe);

    int dongPipe[2];
    safePipe(dongPipe);

    int status;
    pid_t child = fork();
    if (child < 0)
    {
        err(1, "Something went wrong with fork\n");
    }

    if (child > 0)
    {
        // Parent process
        close(dingPipe[0]);
        close(dongPipe[1]);

                parentMessageHandling(N, D, dongPipe, dingPipe, dong, ding);
        // Ensure the child has time to process the last message
        wait(&status);
        if (WIFEXITED(status))
        {
            close(dingPipe[1]);
            close(dongPipe[0]);
        }
    }
    else
    {
        // Child process
        close(dongPipe[0]);
        close(dingPipe[1]);

        childMessageHandling(N, dingPipe, dongPipe, ding, dong);

        close(dongPipe[1]);
        close(dingPipe[0]);
    }

    return 0;
}

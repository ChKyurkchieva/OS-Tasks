#include<unistd.h>
#include<err.h>
#include<stdlib.h>
#include<string.h>

void safePipe(int p[2])
{
    if(pipe(p) < 0)
    {
        err(1, "Something went wrong with creating a pipe\n");
    }
}

pid_t safeFork(void)
{
        pid_t child = fork();
        if(child < 0)
        {
                err(1, "Something went wrong with fork\n");
        }
        return child;
}

void messageHandling(int readPipe[2], int writePipe[2], char receivedMessage[5], char sendMessage[5])
{
        char message[5];
        if (read(readPipe[0], message, 4) == 4)
    {
        message[4] = '\0'; // Null-terminate the string
        if (strcmp(message, receivedMessage) == 0)
        {
                write(1, sendMessage, strlen(sendMessage));
                write(writePipe[1], sendMessage, strlen(sendMessage));
        }
     }
}

int main(int argc, const char* argv[])
{
        if(argc != 3)
        {
                err(1, "Usage: <command> <NC> <WC>\n");
        }

        int NC = atoi(argv[1]);
        int WC = atoi(argv[2]);

        if(NC <= 0 || NC > 7)
        {
                err(1, "First argument must be positive integer [1-7]\n");
        }

        if(WC <= 0 || WC > 35)
        {
                err(1, "Second argument must be positive integer [1-35]\n");
        }

        pid_t *processes = malloc((NC + 1)*sizeof(pid_t)); //check if malloc is safe

        if(processes == NULL)
        {
                err(1, "Memory allocation failed\n");
        }

        char words[3][5] = {"tic ", "tac ", "toe\n"};

        int pipes[NC + 1][2];

        for(int i = 0; i <= NC; i++)
        {
                safePipe(pipes[i]); //safePipe()
        }

        processes[0] = getpid();

        for(int i = 1; i <= NC; i++)
        {
                if(processes[0] == getpid())
                {
                        processes[i] = safeFork();

                }//safe fork?
        }

        for(int i = 0; i <= NC; i++)
        {
                if(processes[i] == getpid())
                {
                        for (int j = 0; j <= NC; j++)
                        {
                if (j != i)
                {
                    close(pipes[j][0]); // Close read end
                }
                if (j != (i + 1) % (NC + 1))
                {
                    close(pipes[j][1]); // Close write end
                }
                        }
                        if(i == 0)
                        {
                                int next = (i + 1)%(NC + 1);
                                write(1, words[0], 4);
                                write(pipes[next][1], words[0], 4);
                        }
                        break;
                }
        }

        int tempWC = 0;
        while(tempWC != WC)
        {
                for(int i = 0; i <= NC; i++)
                {
                        if((i != 0 || tempWC != 0)  && processes[i] == getpid())
                        {
                                int next = (i + 1)%(NC+1);
                                int received = (i - 1) % 3;
                                int send = i % 3;
                                messageHandling(pipes[i], pipes[next], words[received], words[send]);

                                tempWC++;
                                if(tempWC == WC)
                                {
                                        break;
                                }
                        }
                }
        }
        for (int i = 0; i <= NC; i++)
        {
        close(pipes[i][0]);
        close(pipes[i][1]);
    }

    free(processes);

        return 0;
}
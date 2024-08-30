#include <unistd.h>
#include <err.h>
#include <fcntl.h>
#include <stdint.h>

int main(int argc, const char* argv[])
{
        if(argc != 2)
        {
                err(1, "Usage: %s <path_to_file>", argv[0]);
        }
        int pipeFD[2];
        if(pipe(pipeFD) < 0)
        {
                err(1, "Error occured while pipe");
        }
        pid_t childPID = fork();
        if(childPID == -1)
        {
                err(1, "Error occured while fork()");
        }
        if(childPID > 0)
        {
                //parent
                close(pipeFD[1]);
                dup2(pipeFD[0], 0);
                close(pipeFD[0]);
                execlp("sort", "sort",NULL);
                err(1, "Error occured while executing sort");
        }
        else
        {
                //child
                close(pipeFD[0]);
                dup2(pipeFD[1],1);
                close(pipeFD[1]);
                execlp("cat","cat",argv[1], NULL);
                err(1, "Error occured while executing cat");
        }
        return 0;
}
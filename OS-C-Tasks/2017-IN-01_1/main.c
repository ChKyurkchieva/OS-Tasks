#include <unistd.h>
#include <sys/wait.h>
#include <err.h>
int main(int argc, const char* argv[]) {
        if(argc != 1)
        {
                err(1, "Ussage: %s", argv[0]);
        }
        int pipeFD[2];
        if(pipe(pipeFD) == -1)
        {
                err(1, "Error occurred while pipe");
        }
        pid_t childPID = fork();
        int status;
        if(childPID < 0)
        {
                err(1, "Error occurred while fork()");
        }
        if(childPID == 0)
        {
                close(pipeFD[0]);
                dup2(pipeFD[1],1);
                close(pipeFD[1]);
                execlp("awk", "awk", "-F:", "{sum[$7]++} END {for (shell in sum) print sum[shell],shell}", "/etc/passwd", (char*)NULL);
                err(1, "Error occurred while executing awk");
        }
        else
        {
                //parent
                close(pipeFD[1]);
                dup2(pipeFD[0],0);
                close(pipeFD[0]);
                if(wait(&status) == -1)
                {
                    err(1, "Error occurred while waiting for child process");
                }
                execlp("sort", "sort", "-n", (char*)NULL);
                err(1, "Error occured while executing sort");
        }
        return 0;
}
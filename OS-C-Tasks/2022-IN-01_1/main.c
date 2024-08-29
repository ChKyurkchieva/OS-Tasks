#include <unistd.h>
#include <err.h>
#include <fcntl.h>
#include <string.h>
#include <stdint.h>

int openReadingFile(const char* fileName, int mode)
{
    int fileDescriptor = open(fileName, mode);
    if(fileDescriptor == -1)
    {
        err(1, "Error occured while opening %s for reading", fileName);
    }
    return fileDescriptor;
}

int openWritingFile(const char* fileName, int mode)
{
    int fileDescriptor = open(fileName, mode, 0644);
    if(fileDescriptor == -1)
    {
        err(1, "Error occured while opeing %s for writing", fileName);
    }
    return fileDescriptor;
}

int readingFileNumber(int fileDescriptor, void* data, size_t size)
{
    ssize_t readBytes = read(fileDescriptor, data, size);
    if (readBytes == -1)
    {
        err(1, "Error occured while reading data from file");
    }
    if (readBytes < (ssize_t)size)
    {
        err(1, "Incomplete reading");
    }
    if(readBytes == 0)
    {
        return 0;
    }
    return readBytes;
}

uint32_t readingHeader(int fileDescriptor, const char* fileName)
{
    uint16_t hoge = 0x5A4D;
    uint16_t magic;
    uint16_t filetype;
    uint32_t count;
    readingFileNumber(fileDescriptor, &magic, sizeof(magic));
    if(magic != hoge)
    {
        err(1, "Corupted file. This file is not from system Hoge");
    }
    readingFileNumber(fileDescriptor, &filetype, sizeof(filetype));
    if(filetype == 1 && strcmp(fileName,"list.bin") != 0)
    {
        err(1, "Corrupted file. Filetype doesn't match.");
    }
    if(filetype == 2 && strcmp(fileName, "data.bin") != 0 )
    {
        err(1, "Corrupted file. Filetype doesn't match.");
    }
    if(filetype == 3 && strcmp(fileName, "out.bin") != 0 )
    {
        err(1, "Corrupted file. Filetype doesn't match.");
    }
    readingFileNumber(fileDescriptor, &count, sizeof(count));
    return count;
}

ssize_t readData(int fileDescritor, void* data, size_t size)
{
    ssize_t readBytes = read(fileDescritor, data, size);
    if(readBytes == -1)
    {
        err(1, "Error occured while reading data form file.");
    }
    if(readBytes == 0)
    {
        return 0;
    }
    if(readBytes != size)
    {
        err(1, "Incomplete reading");
    }
    return readBytes;
}

uint16_t maxDataValue(int fileDescriptor )
{
    uint16_t max = 0;
    if(lseek(fileDescriptor, 0, SEEK_SET) == -1)
    {
        err(1, "Error occured while lseeking");
    }
    uint16_t currentMax = 0;
    while(readData(fileDescriptor, &currentMax, sizeof(currentMax)) > 0)
    {
        if(currentMax > max)
        {
            max=currentMax;
        }
    }
    if(lseek(fileDescriptor, 0, SEEK_SET) == -1)
    {
        err(1, "Error occured while lSeeking");
    }
    return max;
}

ssize_t writeData(int fileDescriptor, void* data, size_t size)
{
    ssize_t writtenBytes;
    if((writtenBytes = write(fileDescriptor, data, size)) == -1)
    {
        err(1, "Error occured while writing in file");
    }
    if(writtenBytes != size)
    {
        err(1, "Incomplete writing");
    }
    return writtenBytes;
}

uint32_t extractData(int listFD, int dataFD, int outFD)
{
    if ((lseek(listFD, 2*sizeof(uint32_t), SEEK_SET) == -1) || 
        (lseek(dataFD, 2*sizeof(uint32_t), SEEK_SET) == -1) ||
        (lseek(outFD, 2*sizeof(uint32_t), SEEK_SET) == -1))
    {
        err(1, "Error occured while lseeking");
    }
    int position = 2;
    uint16_t listValue;
    uint32_t count = 0;
    while(readData(listFD, &listValue, sizeof(listValue))>0)
    {
        if(listValue >= 1)
        {
            uint32_t dataValue;
            if(lseek(dataFD, position*sizeof(uint32_t), SEEK_SET) == -1)
            {
                err(1, "Error while lseeking");
            }
            readData(dataFD, &dataValue, sizeof(dataValue));
            if(dataValue > 0)
            {
                if(lseek(outFD, listValue*sizeof(uint64_t), SEEK_SET) == -1)
                {
                    err(1, "Error while lseeking");
                }
                writeData(outFD, &dataValue, sizeof(uint64_t));
                count++;
            }
        }
        else
        {
            err(1, "Corrupted data. Trying to write in header.");
        }
    }
    return count;
}

int main(int argc, const char* argv[])
{
    if( argc != 4)
    {
        err(1, "Usage: %s <list_binary_file> <data_binary_file> <out_binary_file>", argv[0]);
    }

    uint16_t magic = 0x5A4D;
    uint16_t fileType; //1 -> list 2 -> data 3 -> out
    uint32_t count;
    //data of list uint16_t
    //data of data uint32_t
    //data of out uint64_t

    int listFD, dataFD, outFD;
    listFD = openReadingFile(argv[1], O_RDONLY);
    dataFD = openReadingFile(argv[2], O_RDONLY);
    outFD = openWritingFile(argv[3], O_WRONLY | O_CREAT | O_TRUNC);
    size_t listDataSize = readingHeader(listFD, argv[1]);
    size_t dataDataSize = readingHeader(dataFD, argv[2]);
    uint16_t maxValue = maxDataValue(listFD);   
    uint64_t zero = 0;
    uint16_t outFileType = 3;
    writeData(outFD, &magic, sizeof(magic));
    writeData(outFD, &outFileType, sizeof(uint16_t));
    writeData(outFD, &zero, maxValue*sizeof(zero));
    uint32_t values = extractData(listFD, dataFD, outFD);
    lseek(outFD, 3*sizeof(uint16_t), SEEK_SET);
    writeData(outFD, values, sizeof(values));

    //
    close(listFD);
    close(dataFD);
    close(outFD);
    return 0;
}
#!/bin/bash
myDirectories=$(find ~ -type d)
while read -p directory
do 
    chmod 
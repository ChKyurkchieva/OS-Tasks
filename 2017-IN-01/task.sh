#!/bin/bash

userName=$(whoami)
#whoami
#find / -user $userName 2>/dev/null | wc -l #if you are not interested od readability and executability
find / -user $userName -readable -executable 2>/dev/null | wc -l
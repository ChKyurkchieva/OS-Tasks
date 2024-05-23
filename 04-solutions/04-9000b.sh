#!/bin/bash

ps -eo pid,ppid | awk 'NR > 1 {
	child[$2]++;
	parent[$1] = $2;
}

END {
for (pid in parent)	{
		ppid = parent[pid];
		if(child[pid] > child[ppid]){
			print pid;
		}
	}
}'

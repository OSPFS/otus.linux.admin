#!/bin/bash

pids=$(ls -l /proc|egrep '[0-9] [0-9]+$'|awk '{print $NF}'|sort -n)


fnc () {
echo -e "PID\tSTATE\tCOMMAND"
 for i in $pids
 do
   nm=$(head -1 /proc/$i/status 2>/dev/null|awk '{print $2}');
   if [[ -z $nm ]]; then
    continue
   fi
   cat /proc/$i/cmdline|sed 's/\x00/\x20/g'>/tmp/mycmdvar
   cmd=$(cat /tmp/mycmdvar)
   st=$(cat /proc/$i/status 2>/dev/null|grep -e "State"|awk '{print $2}')
   if [[ -z $cmd ]];then
    cmd=$nm
   fi
   echo -e "$i\t$st\t$cmd"
 done
}

fnc


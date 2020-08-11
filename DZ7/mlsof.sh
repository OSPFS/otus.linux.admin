#!/bin/bash

pids=$(ls -l /proc|egrep '[0-9] [0-9]+$'|awk '{print $NF}')

fnc () {
 for i in $pids
 do
  ff=$(ls -l /proc/$i/fd/ 2>/dev/null |grep -v -e '\:\[' -e "/dev"| grep $pth |awk '{print $NF}')
  if [[ -n $ff ]]; then
   echo
   nm=$(head -1 /proc/$i/status)
   echo "PID: $i $nm"
   echo "Opened Files:"
   echo "$ff"
  fi
 done
}

if [[ -n $1 ]]
 then
  pth=$1
 else
  pth="/"
fi

fnc


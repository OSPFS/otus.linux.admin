#!/bin/bash

Lockfile='/opt/LogCHK/lck.pid'

if (set -o noclobber; echo "$$" > "$Lockfile") 2>/dev/null
then
trap 'rm -f "$Lockfile"; exit $?' INT TERM EXIT

IFS=$"|"
LogFile='/opt/LogCHK/access.log'
TMPFile='/opt/LogCHK/lchk.tmp'
Letter='/opt/LogCHK/Letter.txt'
Subj=$(echo "Access.log Report")

if [[ ! -f $TMPFile ]] || [[ ! -s $TMPFile ]]
 then 
  Str=$(wc -l < $LogFile)
  echo 0 > $TMPFile
 else
  Str=$(expr $(wc -l < $LogFile) - $(cat $TMPFile)) 
fi

tail -$Str $LogFile|awk '{print $1";"$2";"$3";"$4";"$5";"$6";"$7";"$8";"$9}'|sed -e 's/\;+/ /g' -e 's/;\// \//g' -e 's/;HTTP/ HTTP/g' > out.csv

Str=$(expr $(wc -l < out.csv) + $(cat $TMPFile))
echo $Str > $TMPFile

while read i
do
 array=($(echo $i|awk -F';' '{print $1" "$4" "$5" "$6}'|sed -e 's/ \[/|/' -e 's/\] /|/' -e 's/ \"/|/' -e 's/\" /|/'))
 IPs+=(${array[0]})
 Time+=(${array[1]})
 URLs+=(${array[2]})
 ERRs+=(${array[3]})
done < out.csv

CountFunc () {
for i in $1
do 
 echo $i
done|sort|uniq -c|sort -n -r
}

{
echo
echo "Access.log Report for: ${Time[0]} - ${Time[-1]}"
echo
cat << EOF

    TOP-10 IP Addresses
--------------------------------

EOF
CountFunc "${IPs[*]}"| awk '{print "Found:\t"$1"\t"$2}'|head -10

cat << EOF

    TOP-10 IP Requested URLs
--------------------------------

EOF
CountFunc "${URLs[*]}"|awk '{print "Found:\t"$1"\t"$2,$3}'|head -10

cat << EOF

    All Error's
--------------------------------

EOF

for er in ${ERRs[*]}
do
 if [[ $er == 200 ]] || [[ $er == 301 ]] 
 then continue
 fi
 echo -e '\t'$er
done|sort|uniq

cat << EOF

    All Error Codes
--------------------------------

EOF
CountFunc "${ERRs[*]}"|awk '{print "Found:\t"$1"\t"$2,$3}'

echo
} > $Letter

mailx -s $Subj root < $Letter
#cat $Letter

rm -f "$Lockfile"
trap - INT TERM EXIT
else
 echo "Failed to acquire lockfile: $Lockfile."
 echo "Held by $(cat $Lockfile)"
fi
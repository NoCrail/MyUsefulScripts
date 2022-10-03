#!/usr/local/bin/bash 
#path for MacOS, change for other OS

find $PWD -name "*.JPG" > listfiles
find $PWD -name "*.jpg" >> listfiles
ALL_LINES_COUNT=$(wc -l < listfiles)
echo $ALL_LINES_COUNT
let CURRENT_PROGRESS=0
cat listfiles | while read line; 
do 
#echo $line; #for more info
FN=$(echo "$line" | awk -F/ '{print $NF}' | awk -F'.' '{print $1}' )
FFN=$(echo "$line" | awk -F/ '{print $NF}' )
COUNT=${#FFN}
PATHFILE=${line::-$COUNT}
#echo $PATHFILE
cwebp -o  "$PATHFILE""$FN".webp -preset photo -q 85  -mt -metadata all "$line" &>> log
let CURRENT_PROGRESS++
PERCENT=$(echo $CURRENT_PROGRESS / $ALL_LINES_COUNT *100 | bc -l)
PERCENT=${PERCENT::-16}
echo "$PERCENT%"
rm "$line" #Do backup or comment this line
done

#rm listfiles

